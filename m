Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 762B0522449
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 20:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349051AbiEJSoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 14:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349050AbiEJSo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 14:44:27 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0893F2A7C0B;
        Tue, 10 May 2022 11:44:26 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d22so17506975plr.9;
        Tue, 10 May 2022 11:44:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PY+WJJsqIbfDwJgzkuBE2iPkWgMrw4K1Mhhpa4dAqtU=;
        b=p00MbnRqdRmjeePF8YWO/lHYe4mcUBFcKUfEBVak/KvHMu0ou5wk4CPtT/oCkXaR48
         KuOCnGuz8Tupkgg8erPU71pw/B9OfUdw27Ms83guk1NRhCXBQvolY998RoMWgk/u1H9W
         sE08oN8p86ys70WKR7PmsfQ9mJvfWyZfkM6eGPX2N0k1g1THUfJg3JXUrt+TD3H4wDJo
         y7zo6tzKoehDCXIHdWGAoDhj1aUs5r7fLWEEmubl89AFL6lyXcE/qmTCmsvn5fiYsZSz
         UCgu32eq2rKygSnX8KRwTTLTj8MYrGsNZ54/Zu3xSvdorA3bhe4kssveKBF1bAx+dqsy
         pHxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=PY+WJJsqIbfDwJgzkuBE2iPkWgMrw4K1Mhhpa4dAqtU=;
        b=0dKVG4RXXos6FfPFwGwjnucVruMdY/4L5aGhWCo58FB58W+9LG2m5QoqfZDMduDVbr
         zacCs/LloRB8R9B2AuoDWhjkb17eh0ZhefRq9U2VwkT4T1EZoIYlFcycX2FVs9OSXSnM
         Phlj4O5OakM2CLipYnNtygxy1StPgUcMUVKsnGXr2RVgqXh/8HrJUQDEVR/2kHc9Jl3F
         YHYVq5xQ2gRXMbEv9pHquJ22g5kn4xv7k0G6tDpfJO5gIqPSp+XjUkGGQYk83ZhmEoiK
         JTMCok9ONFJrjrXuE86Wyab5Sm3yDbZ8PXJj6y8Mu6Qlk76Lrfke+y870v+ag7lqR0m1
         sO4A==
X-Gm-Message-State: AOAM531n8I07BSsZxbU87oavmHqCD/fE1sLEORq7IY8XjQ2sd3sekXBs
        lOgdvCZtvcZBlmZ7rQ1q7fg=
X-Google-Smtp-Source: ABdhPJxE4jsnrGQQxRR8zWzwQ6l6VqaQdZx3bbC5B5iVac1YBXClL3sKqzZcxPPvYsb09AACudf5OA==
X-Received: by 2002:a17:902:b610:b0:15f:3063:6530 with SMTP id b16-20020a170902b61000b0015f30636530mr761629pls.131.1652208265386;
        Tue, 10 May 2022 11:44:25 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::4:6c64])
        by smtp.gmail.com with ESMTPSA id b3-20020a170902d30300b0015e8d4eb1edsm2275735plc.55.2022.05.10.11.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 11:44:25 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Tue, 10 May 2022 08:44:23 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Michal Hocko <mhocko@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        David Rientjes <rientjes@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [RFC PATCH bpf-next 1/9] bpf: introduce CGROUP_SUBSYS_RSTAT
 program type
Message-ID: <Ynqyh+K1tMyNCTUW@slm.duckdns.org>
References: <20220510001807.4132027-1-yosryahmed@google.com>
 <20220510001807.4132027-2-yosryahmed@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220510001807.4132027-2-yosryahmed@google.com>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, May 10, 2022 at 12:17:59AM +0000, Yosry Ahmed wrote:
> @@ -706,6 +707,9 @@ struct cgroup_subsys {
>  	 * specifies the mask of subsystems that this one depends on.
>  	 */
>  	unsigned int depends_on;
> +
> +	/* used to store bpf programs.*/
> +	struct cgroup_subsys_bpf bpf;
>  };

Care to elaborate on rationales around associating this with a specific
cgroup_subsys rather than letting it walk cgroups and access whatever csses
as needed? I don't think it's a wrong approach or anything but I can think
of plenty of things that would be interesting without being associated with
a specific subsystem - even all the cpu usage statistics are built to in the
cgroup core and given how e.g. systemd uses cgroup to organize the
applications in the system whether resource control is active or not, there
are a lot of info one can gather about those without being associated with a
specific subsystem.

Thanks.

-- 
tejun
