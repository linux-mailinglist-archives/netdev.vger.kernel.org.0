Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B18D150AC9B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 02:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442781AbiDVADy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 20:03:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441834AbiDVADw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 20:03:52 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E460144769;
        Thu, 21 Apr 2022 17:00:59 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id n8so7203855plh.1;
        Thu, 21 Apr 2022 17:00:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=zNM0T6G9nbgHrNZ4fTkXwyWCBaHcehFw/2xC4YUFDsI=;
        b=EuvVsx4ZgPslFCb7gOV55CeCnLpdDVKzvax8LPd7QTAK+3cU87Nftp2h7LeD7u3x2U
         PO69KJYfLa71urQQP2eN+4+QzGZOFbUrNStJDozSoWX4l5jGuO1fYDQUPM7oTzQ8wB2U
         8EIgEV6FSttJlevNQj86csduSGRTjcTwZHEIHMy9jGjOczOnergao1IJkSzCCnshkNPJ
         Py6NTTy2g3djoSt3B+mT0dIwNsW/H2Eqoy9JrURvzKTT9fe9QNKppdTpHmWnLEPGs5gR
         mcaxAyyi41329d31VgPJuKePYtKsinZGMVLpeuN/3ZZvqvZv6ZUF8piVfQllRNkVMPdm
         7ZLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=zNM0T6G9nbgHrNZ4fTkXwyWCBaHcehFw/2xC4YUFDsI=;
        b=4HnZN7U4hdqGNz2gxOt8cs4uMQhPhHWINIIi229/C8bJf0VHPpeotkrASIZQVu5SD+
         29/ZmnGL55SEpj4luZPkl9u/IDXg3EEliIXD65sW6l1eRUMCYKpNH9jTTCPR2ro1FP4/
         Sw7Jy+ZTRWsC1dRz8TjxreC9HHaBYT33kq9tXbcPuUNxd1YHMFkGtObGvXRBH7RpvJe2
         PAfMxjlNlAlrbnQEhdXBHfMBXGJeWoC/8xxuehwBuAFmdZ+JBmTzKovtq5OeCtwHZJ5F
         6dBZ9MxRIff1TYTMxUrgnJxBLgacFLc9R9HdN7P+wuMUTzvwfMYSATnRWTzbn+R3kBFb
         ONHA==
X-Gm-Message-State: AOAM530i/cMQ54mTDXH5D/Fql11fBRUh4n9+wa4q5ZSfoePjpwt5YESz
        9wjQigu0C9OugzHUdp7jl3g=
X-Google-Smtp-Source: ABdhPJxz3NmXXbUUbQ3NvykiAKXEknpp47eUrgOLe/3aWtrn3sSIrFY8IHtbDQGUfcjACG6SN923fA==
X-Received: by 2002:a17:902:ab56:b0:15a:ccc7:a311 with SMTP id ij22-20020a170902ab5600b0015accc7a311mr1722336plb.22.1650585659276;
        Thu, 21 Apr 2022 17:00:59 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:15fa])
        by smtp.gmail.com with ESMTPSA id ck20-20020a17090afe1400b001cd4989ff3dsm4180906pjb.4.2022.04.21.17.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 17:00:58 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 21 Apr 2022 14:00:56 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc:     Tadeusz Struk <tadeusz.struk@linaro.org>, cgroups@vger.kernel.org,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
Message-ID: <YmHwOAdGY2Lwl+M3@slm.duckdns.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220414164409.GA5404@blackbody.suse.cz>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 14, 2022 at 06:44:09PM +0200, Michal Koutný wrote:
> I suspect the double-queuing is a result of the fact that there exists
> only the single reference to the css->refcnt. I.e. it's
> percpu_ref_kill_and_confirm()'d and released both at the same time.
> 
> (Normally (when not killing the last reference), css->destroy_work reuse
> is not a problem because of the sequenced chain
> css_killed_work_fn()->css_put()->css_release().)

If this is the case, we need to hold an extra reference to be put by the
css_killed_work_fn(), right?

Thanks.

-- 
tejun
