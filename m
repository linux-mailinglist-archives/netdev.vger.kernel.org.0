Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6C150AC2F
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 01:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1442721AbiDUXqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 19:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442701AbiDUXqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 19:46:11 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F933B549;
        Thu, 21 Apr 2022 16:43:20 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id l127so6386213pfl.6;
        Thu, 21 Apr 2022 16:43:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/eAIscwqrdOmVK8JO+DB8Q4/nTvq74/yqQoE6DPm+YE=;
        b=BuOn9jZFa0z5WyxQu4hiLUdJAi/zwUHm1r5eQfF7B2DC/9QVs/N7Mp7ZrccbIIYZNo
         JsuVB84ni+bT89l44FR+k4nl0uSUmLdPjndEgpc7uQjvsH7k7fC8x6jdaCnPmXGAj72B
         RD3E5PqhesJS6VUic1lN4Y1goCu1XOftLSnezxcJKa4c8uYsIR2rXQJvctMKpqafnXgI
         X8fYyAgjhj0wzO9ejjFn/X4JrqEEwzeOGAaPglJsO0KPU1g1t/Xlv7qycSpvTjiS/OEW
         aQD80Xii/k6tttIIf28RUlUjmahDWuo5Gvo5TzlOb23eBJLCNKOeV4/LWcBQRJ59T7gZ
         yvFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=/eAIscwqrdOmVK8JO+DB8Q4/nTvq74/yqQoE6DPm+YE=;
        b=0ari8QYeiJBp50Pv5qe7Dgt4I75lfCIlOPnDWFXGEn6X8cwHCBWpJvuSjNX1bC7tyr
         IOekfKGCtN97VOuNFV8NhbisiXBkWXoVxKpLMG/GH85GdLrWDVxe8cbkGXaRbfW9bxxV
         4QJM1vA2PlNU2EdInEY3uml1rn7xz5nLlBEMplrDM2sLdZVuiNCouULlgMf3bjPqskM9
         rqMAUuRPBhFS7p1ak96I/efmiAFtr8b3K1hJ+JDfHLDnJrdWHWebZmobpvZ5cUmuxLYo
         1kLct7LoVsF8AYvsqMPCxbm159JGXS2CxxGO0jP8vzZfl1Y4Q0UaxCpt7dB37rW/FCn9
         vQYA==
X-Gm-Message-State: AOAM531gwhzxS5DFs3pD1bQRTrF5kMspEkZKnoLj6jA5K7CFCR/DYumJ
        40i3d0zyim+t3kF58v17xG4=
X-Google-Smtp-Source: ABdhPJxkv5K1zioe2274aA1Q6utDtfK3QelJffKteGA/Wy59Myg/5/Pq6CEuktdxSk03lsKKuJ26nA==
X-Received: by 2002:a05:6a00:10cc:b0:506:e0:d6c3 with SMTP id d12-20020a056a0010cc00b0050600e0d6c3mr1906210pfu.33.1650584599907;
        Thu, 21 Apr 2022 16:43:19 -0700 (PDT)
Received: from localhost ([2620:10d:c090:400::5:15fa])
        by smtp.gmail.com with ESMTPSA id g17-20020a625211000000b005056a6313a7sm220809pfb.87.2022.04.21.16.43.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 16:43:19 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date:   Thu, 21 Apr 2022 13:43:17 -1000
From:   Tejun Heo <tj@kernel.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>,
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
Message-ID: <YmHsFWy7Wa4HNZXl@slm.duckdns.org>
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
 <584183e2-2473-6185-e07d-f478da118b87@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <584183e2-2473-6185-e07d-f478da118b87@linaro.org>
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Thu, Apr 14, 2022 at 10:51:18AM -0700, Tadeusz Struk wrote:
> What happened was, the write triggered:
> cgroup_subtree_control_write()->cgroup_apply_control()->cgroup_apply_control_enable()->css_create()
> 
> which, allocates and initializes the css, then fails in cgroup_idr_alloc(),
> bails out and calls queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);

Yes, but this css hasn't been installed yet.

> then cgroup_subtree_control_write() bails out to out_unlock:, which then goes:
> 
> cgroup_kn_unlock()->cgroup_put()->css_put()->percpu_ref_put(&css->refcnt)->percpu_ref_put_many(ref)

And this is a different css. cgroup->self which isn't connected to the half
built css which got destroyed in css_create().

So, I have a bit of difficulty following this scenario. The way that the
current code uses destroy_work is definitely nasty and it'd probably be a
good idea to separate out the different use cases, but let's first
understand what's failing.

Thanks.

-- 
tejun
