Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F2FE501A75
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 19:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343944AbiDNRxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 13:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343952AbiDNRxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 13:53:46 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA322EA76F
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 10:51:20 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id q3so5280432plg.3
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 10:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:content-language:to:cc
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=R60EpWC4+M+3jSe48lUE7Gq4ExP+RSflXlkjF6VcaNg=;
        b=MJT5ZerLaHe0JjBpnq1LElIVlHvKx2ombKDP9yRuUPnzETaAhn9nIFw2s+5thyg8ck
         z+Auc/bX6s4XDzQD7WK+/TG6WF/NPaz7NxNF+va1neIBQvkDM8rvE/Z8Bu7yJMiDjGhr
         Qq/F7VMSrZoc5QrzMA5rKvUUC9eGBE4aSx1/AZufDrZmL8MFVO75636rgU+GQRNVBJf+
         XMC2Wjv8LayNUGel212gOwnBPbKqlmm34ot5OyZMuDQLngo5WNI+Qvm1BsfC5EhRNMHA
         pczXurvhUftRw1ejmjb5pCtSqc/EQVw3Lip1QWxc1k5n4sDFrV6ZrKI9OY/a3Zk8+Y1S
         UitA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:cc:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=R60EpWC4+M+3jSe48lUE7Gq4ExP+RSflXlkjF6VcaNg=;
        b=2CapEV/paC5Mnw/GcATAirM7ylocs8mFkLYrPl7qOpZeCtfrqnaqRpTAY+S4mwN5MB
         Aa3E2MSyoTMmwsLYxcqaqmBF0RnNCjoGxxa6ZvpaPi9EYNhQoAONDZUGgtEuCqm654dy
         8TainyDJlfTiTMTRe6qYHUnzjiDw2uH6LeDFBzD/DjvRtyvaARklYKT3xnYKM2ssq3AY
         oYQrKVOA9E7pIZ6hBZqXowjLolaKb+DsqN1mmYD6ZPjyPVLXOJgfe1z5Wae2PFqa9HTj
         kf+NCX1X7QysCO8fqXMbh0pFI/EEAVxrIBeLNsZepCmwGIU4JYYtciEbAV0HEXvtXk70
         zYDQ==
X-Gm-Message-State: AOAM530pJ+gm4OVRl1z09NJM8zCqHJi+il6y+qRgf7XcGRv82zMqxufm
        PbkNOd6XEzI3uwLx3CBfWZgjrKZYUpHAXe8C
X-Google-Smtp-Source: ABdhPJwRAMampTIjKcuBpR+du+kxiuKgR+5wRxgzxrak8w+8zYw1w59xdKpX2VjJw2lzIeX2jldwgw==
X-Received: by 2002:a17:902:b7c9:b0:158:b09e:527a with SMTP id v9-20020a170902b7c900b00158b09e527amr6104672plz.40.1649958679806;
        Thu, 14 Apr 2022 10:51:19 -0700 (PDT)
Received: from [192.168.254.17] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm506706pfo.155.2022.04.14.10.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Apr 2022 10:51:19 -0700 (PDT)
Message-ID: <584183e2-2473-6185-e07d-f478da118b87@linaro.org>
Date:   Thu, 14 Apr 2022 10:51:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>
Cc:     cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
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
References: <20220412192459.227740-1-tadeusz.struk@linaro.org>
 <20220414164409.GA5404@blackbody.suse.cz>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
Subject: Re: [PATCH] cgroup: don't queue css_release_work if one already
 pending
In-Reply-To: <20220414164409.GA5404@blackbody.suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,
Thanks for your analysis.

On 4/14/22 09:44, Michal Koutný wrote:
> Hello Tadeusz.
> 
> Thanks for analyzing this syzbot report. Let me provide my understanding
> of the test case and explanation why I think your patch fixes it but is
> not fully correct.
> 
> On Tue, Apr 12, 2022 at 12:24:59PM -0700, Tadeusz Struk <tadeusz.struk@linaro.org> wrote:
>> Syzbot found a corrupted list bug scenario that can be triggered from
>> cgroup css_create(). The reproduces writes to cgroup.subtree_control
>> file, which invokes cgroup_apply_control_enable(), css_create(), and
>> css_populate_dir(), which then randomly fails with a fault injected -ENOMEM.
> 
> The reproducer code makes it hard for me to understand which function
> fails with ENOMEM.
> But I can see your patch fixes the reproducer and your additional debug
> patch which proves that css->destroy_work is re-queued.

Yes, it is hard to see the actual failing point because, I think it is randomly
failing in different places. I think in the actual case that causes the list
corruption is in fact in css_create().
It is the css_create() error path that does fist rcu enqueue in:

https://elixir.bootlin.com/linux/v5.10.109/source/kernel/cgroup/cgroup.c#L5228

and the second is triggered by the css->refcnt calling css_release()

The reason why we don't see it actually failing in css_create() in the trace
dump is that the fail_dump() is rate-limited, see:
https://elixir.bootlin.com/linux/v5.18-rc2/source/lib/fault-inject.c#L44

I was confused as well, so I put additional debug prints in every place
where css_release() can fail, and it was actually in
css_create()->cgroup_idr_alloc() that failed in my case.

What happened was, the write triggered:
cgroup_subtree_control_write()->cgroup_apply_control()->cgroup_apply_control_enable()->css_create()

which, allocates and initializes the css, then fails in cgroup_idr_alloc(),
bails out and calls queue_rcu_work(cgroup_destroy_wq, &css->destroy_rwork);

then cgroup_subtree_control_write() bails out to out_unlock:, which then goes:

cgroup_kn_unlock()->cgroup_put()->css_put()->percpu_ref_put(&css->refcnt)->percpu_ref_put_many(ref)

which then calls ref->data->release(ref) and enqueues the same
&css->destroy_rwork on cgroup_destroy_wq causing list corruption in insert_work.

>> In such scenario the css_create() error path rcu enqueues css_free_rwork_fn
>> work for an css->refcnt initialized with css_release() destructor,
> 
> Note that css_free_rwork_fn() utilizes css->destroy_*r*work.
> The error path in css_create() open codes relevant parts of
> css_release_work_fn() so that css_release() can be skipped and the
> refcnt is eventually just percpu_ref_exit()'d.
> 
>> and there is a chance that the css_release() function will be invoked
>> for a cgroup_subsys_state, for which a destroy_work has already been
>> queued via css_create() error path.
> 
> But I think the problem is css_populate_dir() failing in
> cgroup_apply_control_enable(). (Is this what you actually meant?
> css_create() error path is then irrelevant, no?)

I thought so too at first as the the crushdump shows that this is failing
in css_populate_dir(), but this is not the fail that causes the list corruption.
The code can recover from the fail in css_populate_dir().
The fail that causes trouble is in css_create(), that makes it go to its error path.
I can dig out the patch with my debug prints and request syzbot to run it
if you want.

> 
> The already created csses should then be rolled back via
> 	cgroup_restore_control(cgrp);
> 	cgroup_apply_control_disable(cgrp);
> 	   ...
> 	   kill_css(css)
> 
> I suspect the double-queuing is a result of the fact that there exists
> only the single reference to the css->refcnt. I.e. it's
> percpu_ref_kill_and_confirm()'d and released both at the same time.
> 
> (Normally (when not killing the last reference), css->destroy_work reuse
> is not a problem because of the sequenced chain
> css_killed_work_fn()->css_put()->css_release().)
> 
>> This can be avoided by adding a check to css_release() that checks
>> if it has already been enqueued.
> 
> If that's what's happening, then your patch omits the final
> css_release_work_fn() in favor of css_killed_work_fn() but both should
> be run during the rollback upon css_populate_dir() failure.

This change only prevents from double queue:

queue_[rcu]_work(cgroup_destroy_wq, &css->destroy_rwork);

I don't see how it affects the css_killed_work_fn() clean path.
I didn't look at it, since I thought it is irrelevant in this case.

-- 
Thanks,
Tadeusz
