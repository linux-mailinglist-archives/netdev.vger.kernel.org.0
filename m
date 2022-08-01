Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B790B587434
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 01:01:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235296AbiHAXA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 19:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235098AbiHAXAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 19:00:38 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F90A63D6;
        Mon,  1 Aug 2022 16:00:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z19so11834654plb.1;
        Mon, 01 Aug 2022 16:00:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YL23/hoAvzZlOos/Qg6i+1wu9EdaWZsaI3xrm+6DO6Q=;
        b=P8F59PpCHknKeqciDKWmGNWVwW1uJoxcuQU8SnYQWKlORzxTaETX9UO9+eRlyB93zD
         7tWrE9Boh9AYaXJEbmmRn9omJRDbZUJYYein05vcRe/smG6Ha6UmrVe9lehRl3B8nDOD
         pJx2okyyMTUFFJvoruJHTeQvU7YnlkdTi6uVsF74RspUHfS0VhCfai5Wlp749kN2shYd
         yZLR+CjUHSrg7jj40gm/KCbKFmViyftS3xlFAHFeMYraE/BbY1XAQHSbON4nTvS5JARr
         MxcftlrPZ443Rx/3enzUb1Lcf+hYONClDf/q78byMAi9+eiynsyxbZF3KqUd/rUA1U2n
         Y4YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YL23/hoAvzZlOos/Qg6i+1wu9EdaWZsaI3xrm+6DO6Q=;
        b=KvAsHRPLFeLwthtfcTnl3WF51ysr1NeklO+QlrR6Rk93AvQ3R87B/q6ROwtfFpvZTY
         XxO1agDR3gy+XnMaEA7154D0VICQpODdLNDIT9EM6DndMl5qZs+im9wmgffk75k/WMZs
         cEx5GzuYeCaSLa1RzHuiOHgmjtHJIxsWYG9A8eFgH8eSMmG/7YpahOF+FP8OUDwdvn4v
         NGDu1PosqDehPL0qEom6IoVDDjcBlCiEr/lp9ThxS/w2Ai+YeIYGzciWsYnb4JLiF2ag
         AM14TwTBBcnnrKpNPoV7/qoJjR93Bfx2iivR9Etb7sf5dYymdJQ81Tbz0u7ohdMRhQK8
         FnMQ==
X-Gm-Message-State: ACgBeo2Swh4mEeLtnLyo94QgNy/lrPDus50EOXSxKuCXzCIRQkNmlZ61
        Xn90kXuXoyJe8t/gE1YU8TMnJHzvark=
X-Google-Smtp-Source: AA6agR4BZy7lu7xerf1px822n7fdIKzcqc0wI6kmt2nBVxXflYkwF07DEqfBt7RN1eHJotIi5MghsQ==
X-Received: by 2002:a17:902:ce84:b0:16d:9a19:570c with SMTP id f4-20020a170902ce8400b0016d9a19570cmr19064333plg.132.1659394834871;
        Mon, 01 Aug 2022 16:00:34 -0700 (PDT)
Received: from macbook-pro-3.dhcp.thefacebook.com ([2620:10d:c090:400::5:f128])
        by smtp.gmail.com with ESMTPSA id m12-20020a170902d18c00b0016d1d1c376fsm9972159plb.287.2022.08.01.16.00.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 16:00:34 -0700 (PDT)
Date:   Mon, 1 Aug 2022 16:00:30 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Frederick Lawler <fred@cloudflare.com>
Cc:     kpsingh@kernel.org, revest@chromium.org, jackmanb@chromium.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, jmorris@namei.org, serge@hallyn.com,
        paul@paul-moore.com, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, ebiederm@xmission.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com
Subject: Re: [PATCH v4 2/4] bpf-lsm: Make bpf_lsm_userns_create() sleepable
Message-ID: <20220801230030.w4rgzlncgdrcz7q2@macbook-pro-3.dhcp.thefacebook.com>
References: <20220801180146.1157914-1-fred@cloudflare.com>
 <20220801180146.1157914-3-fred@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801180146.1157914-3-fred@cloudflare.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 01, 2022 at 01:01:44PM -0500, Frederick Lawler wrote:
> Users may want to audit calls to security_create_user_ns() and access
> user space memory. Also create_user_ns() runs without
> pagefault_disabled(). Therefore, make bpf_lsm_userns_create() sleepable
> for mandatory access control policies.
> 
> Signed-off-by: Frederick Lawler <fred@cloudflare.com>
> Acked-by: Christian Brauner (Microsoft) <brauner@kernel.org>

We can take this set through bpf-next tree if it's easier.

Or if it goes through other trees:
Acked-by: Alexei Starovoitov <ast@kernel.org>
