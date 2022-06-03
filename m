Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D03D53D145
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 20:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiFCSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 14:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348137AbiFCSVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 14:21:42 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 748285710D
        for <netdev@vger.kernel.org>; Fri,  3 Jun 2022 11:06:19 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id h192so994238pgc.4
        for <netdev@vger.kernel.org>; Fri, 03 Jun 2022 11:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=svaPePYVH4vz0O3T8xIGrC8HyL06d2NGhj+KphBzUno=;
        b=IwAVBHzgWS4dkVu/qLRjRhpRlO9tC9h6H0XLkm6gQfD1Ick+CmJZfRRii+FDxIWP85
         hVopm9iS326lYl/5DkMQNmUIOy3WxNkt5E/K3aft11XxaP4WWRGkqJL/FPEzDEXsD/Aa
         lJWuOyXQN903SYenOmP4skGdUxIanc1vk5022d8ALXUOepRz6Xi3cPbEvojIb8L2pnzj
         aIQBYZD/ZSr0dyb+LvspeTRRCXoBe7vxqIFyzMzxKIBK1t4ekpvPMHQuLfoH5YQw86Nk
         KhamVkfq0/4ejEwmXXosra2Zs+TQJrM/2JSLvZ5xtZYJ7RxKPZm48xOMMKtLpKt7sNlT
         Qthw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=svaPePYVH4vz0O3T8xIGrC8HyL06d2NGhj+KphBzUno=;
        b=sM6+598knfANOOnOm2Pbds+/AKa8Vlj+fsSuLbZX4uawtvIBvRlrOPcDEZ7x4/X+H1
         VkwnTXycgMH85BHICnTLOn5zi/8rryq+ueECaN+mJhpgwXt4PQvfDtsLycXutC50uFZM
         RCCP8Si8P3DuvxjhSRVCl2XeQ6ucZqG1rjEOMoZ8G63EP5/gAjpUH1dPG3cKS3Es+I5C
         9Qzh17Df39UOTgJuR5Mmd8Of3DrZYVaD+4Lxd1CVvvXVQNTd5eMV3XCI5JX9zXx7uk7k
         xMafpMrYL+E6zygeUFoCn307idkyX9vLJAWGY8rgU7x2Dpy/8Ot2xWdUBLX4VMaZFcMY
         knyw==
X-Gm-Message-State: AOAM533eOGf3YRxM3bx4EPGkCKje7cnl5tZo/kI1mPuQgfolfKpLgsg8
        bSAw0o7oHWz7oTEsLRPaQE4cPA==
X-Google-Smtp-Source: ABdhPJz5HDnPBWYPC/6wFvAYbckub3E1dTzAciJW93WVpE6oNFAHmVnt3INU9abX+ASYlI0QTMtV/g==
X-Received: by 2002:a63:2109:0:b0:3fc:9fdf:f4e0 with SMTP id h9-20020a632109000000b003fc9fdff4e0mr10104603pgh.586.1654279578981;
        Fri, 03 Jun 2022 11:06:18 -0700 (PDT)
Received: from [192.168.254.36] ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id c11-20020a170903234b00b001641047544bsm5716733plh.103.2022.06.03.11.06.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jun 2022 11:06:18 -0700 (PDT)
Message-ID: <79ec0073-2db7-a7a2-ec60-265a617d463a@linaro.org>
Date:   Fri, 3 Jun 2022 11:06:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] cgroup: serialize css kill and release paths
Content-Language: en-US
To:     Tejun Heo <tj@kernel.org>
Cc:     Michal Koutny <mkoutny@suse.com>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Christian Brauner <brauner@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, cgroups@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
References: <20220603173455.441537-1-tadeusz.struk@linaro.org>
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
In-Reply-To: <20220603173455.441537-1-tadeusz.struk@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/3/22 10:34, Tadeusz Struk wrote:
> Syzbot found a corrupted list bug scenario that can be triggered from
> cgroup_subtree_control_write(cgrp). The reproduces writes to
> cgroup.subtree_control file, which invokes:
> cgroup_apply_control_enable()->css_create()->css_populate_dir(), which
> then fails with a fault injected -ENOMEM.
> In such scenario the css_killed_work_fn will be en-queued via
> cgroup_apply_control_disable(cgrp)->kill_css(css), and bail out to
> cgroup_kn_unlock(). Then cgroup_kn_unlock() will call:
> cgroup_put(cgrp)->css_put(&cgrp->self), which will try to enqueue
> css_release_work_fn for the same css instance, causing a list_add
> corruption bug, as can be seen in the syzkaller report [1].
> 
> Fix this by synchronizing the css ref_kill and css_release jobs.
> css_release() function will check if the css_killed_work_fn() has been
> scheduled for the css and only en-queue the css_release_work_fn()
> if css_killed_work_fn wasn't already en-queued. Otherwise css_release() will
> set the CSS_REL_LATER flag for that css. This will cause the css_release_work_fn()
> work to be executed after css_killed_work_fn() is finished.
> 
> Two scc flags have been introduced to implement this serialization mechanizm:
> 
>   * CSS_KILL_ENQED, which will be set when css_killed_work_fn() is en-queued, and
>   * CSS_REL_LATER, which, if set, will cause the css_release_work_fn() to be
>     scheduled after the css_killed_work_fn is finished.
> 
> There is also a new lock, which will protect the integrity of the css flags.
> 
> [1]https://syzkaller.appspot.com/bug?id=e26e54d6eac9d9fb50b221ec3e4627b327465dbd
> 
> Cc: Tejun Heo<tj@kernel.org>
> Cc: Michal Koutny<mkoutny@suse.com>
> Cc: Zefan Li<lizefan.x@bytedance.com>
> Cc: Johannes Weiner<hannes@cmpxchg.org>
> Cc: Christian Brauner<brauner@kernel.org>
> Cc: Alexei Starovoitov<ast@kernel.org>
> Cc: Daniel Borkmann<daniel@iogearbox.net>
> Cc: Andrii Nakryiko<andrii@kernel.org>
> Cc: Martin KaFai Lau<kafai@fb.com>
> Cc: Song Liu<songliubraving@fb.com>
> Cc: Yonghong Song<yhs@fb.com>
> Cc: John Fastabend<john.fastabend@gmail.com>
> Cc: KP Singh<kpsingh@kernel.org>
> Cc:<cgroups@vger.kernel.org>
> Cc:<netdev@vger.kernel.org>
> Cc:<bpf@vger.kernel.org>
> Cc:<stable@vger.kernel.org>
> Cc:<linux-kernel@vger.kernel.org>
> 
> Reported-and-tested-by:syzbot+e42ae441c3b10acf9e9d@syzkaller.appspotmail.com
> Fixes: 8f36aaec9c92 ("cgroup: Use rcu_work instead of explicit rcu and work item")
> Signed-off-by: Tadeusz Struk<tadeusz.struk@linaro.org>

I just spotted an issue with this. I'm holding invalid lock in css_killed_work_fn().
I will follow up with a v2 of the patch soon.

-- 
Thanks,
Tadeusz
