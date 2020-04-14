Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36BD51A8490
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 18:23:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391057AbgDNQWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 12:22:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2391350AbgDNQUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 12:20:49 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ACAAC061A0C;
        Tue, 14 Apr 2020 09:20:49 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c195so12884070wme.1;
        Tue, 14 Apr 2020 09:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RzM2/AbyGI6UWlmPhW951h4l6PcCooddl/vjXRB7hSU=;
        b=vZOrCPWIfKQ3k/q7qXN7XQxRJ1kbCT8T2tAmiqaA7KY9OBS+8E4chKc+4+diCaxXRt
         Wf4F161DOfaOQxOieWbiber5zDpewsFT//+9hSzn7FbQsQrps8K8qnsxeGESa5ZsfjG8
         256LXtCuF5V855JwJJGX+88w4ErZx6salfjiLGaYPQ5wSRFlmjFsFbVYJ4EGqJS8f/fP
         kPbdLcMUVMI3MrZjILH2JSdpYu0ijLMQa0J2skF4GVdCZqKXJEFOK5Sujgojd6IMDkMj
         RjQ9K2KrZVVx0IzwX/uXozVxJlwOVb0CYAZPiPMnmoLEX2AW9b6zyWCC/5LpyywR3ENA
         EHDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RzM2/AbyGI6UWlmPhW951h4l6PcCooddl/vjXRB7hSU=;
        b=SszoM29dIPVTU+X8hPTPybkj3xw5hQ/hosXNapo75nyLCAEVzeUxXUD5QzQeSprZ8F
         7vUznIeGqyMigEFEvrNDLzRy+IyEw/Ve4Gk/bkvPaAJvSrjtu+84tO4n4Q8XYP3kzO7L
         WuSQU4mqNpsBQciAi2DFH5X2QMPqlJ0Nvk8aW9bE8oxtd+PV+nW41y1EWNQT7HlK/OOl
         e+iSa7TV22CFh1jI7GDOgyP5Gi6HFVTvhc4nAmHL6Ies/yjCj28zNztgFuionM67RaiD
         /QWZnVGy7Y69xbFTgnMRLwvhUHgM4ofuAJRsNtY74lIvVapO+xGYDHFErPz/n8PLsSXz
         UP9A==
X-Gm-Message-State: AGi0Pua1UzGdc0pTpTpYCmX+9e601iIlpFIfDOV/x+ccJO9fxB7WElsd
        VWts63aJuaRvhcG+O9cnAd5vvN9L
X-Google-Smtp-Source: APiQypI58O4sr+sWdOWbX406lW/6Yj73xS5VY7Mo3gUfZTDXSkfNqQd9Next7g8H4yNs1T2sz2ffjw==
X-Received: by 2002:a05:600c:2f88:: with SMTP id t8mr621611wmn.46.1586881247647;
        Tue, 14 Apr 2020 09:20:47 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f29:6000:7dac:d074:4b40:6d0d? (p200300EA8F2960007DACD0744B406D0D.dip0.t-ipconnect.de. [2003:ea:8f29:6000:7dac:d074:4b40:6d0d])
        by smtp.googlemail.com with ESMTPSA id y7sm20483042wmb.43.2020.04.14.09.20.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2020 09:20:47 -0700 (PDT)
Subject: Re: RFC: Handle hard module dependencies that are not symbol-based
 (r8169 + realtek)
To:     Jessica Yu <jeyu@kernel.org>
Cc:     Lucas De Marchi <lucas.demarchi@intel.com>,
        Petr Mladek <pmladek@suse.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        live-patching@vger.kernel.org
References: <f8e3f271-82df-165f-63f1-6df73ba3d59c@gmail.com>
 <20200409000200.2qsqcbrzcztk6gmu@ldmartin-desk1>
 <6ed6259b-888d-605a-9a6f-526c18e7bb14@gmail.com>
 <20200414160930.GA20229@linux-8ccs>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <e38f3115-1e77-ebce-423b-8ea445be9e0d@gmail.com>
Date:   Tue, 14 Apr 2020 18:20:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200414160930.GA20229@linux-8ccs>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.04.2020 18:09, Jessica Yu wrote:
> +++ Heiner Kallweit [10/04/20 00:25 +0200]:
>> On 09.04.2020 02:02, Lucas De Marchi wrote:
>>> On Wed, Apr 01, 2020 at 11:20:20PM +0200, Heiner Kallweit wrote:
>>>> Currently we have no way to express a hard dependency that is not
>>>> a symbol-based dependency (symbol defined in module A is used in
>>>> module B). Use case:
>>>> Network driver ND uses callbacks in the dedicated PHY driver DP
>>>> for the integrated PHY (namely read_page() and write_page() in
>>>> struct phy_driver). If DP can't be loaded (e.g. because ND is in
>>>> initramfs but DP is not), then phylib will use the generic
>>>> PHY driver GP. GP doesn't implement certain callbacks that are
>>>> needed by ND, therefore ND's probe has to bail out with an error
>>>> once it detects that DP is not loaded.
>>>> We have this problem with driver r8169 having such a dependency
>>>> on PHY driver realtek. Some distributions have tools for
>>>> configuring initramfs that consider hard dependencies based on
>>>> depmod output. Means so far somebody can add r8169.ko to initramfs,
>>>> and neither human being nor machine will have an idea that
>>>> realtek.ko needs to be added too.
>>>
>>> Could you expand on why softdep doesn't solve this problem
>>> with MODULE_SOFTDEP()
>>>
>>> initramfs tools can already read it and modules can already expose them
>>> (they end up in /lib/modules/$(uname -r)/modules.softdep and modprobe
>>> makes use of them)
>>>
>> Thanks for the feedback. I was under the impression that initramfs-tools
>> is affected, but you're right, it considers softdeps.
>> Therefore I checked the error reports again, and indeed they are about
>> Gentoo's "genkernel" tool only. See here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=204343#c15
>>
>> If most kernel/initramfs tools consider softdeps, then I don't see
>> a need for the proposed change. But well, everything is good for
>> something, and I learnt something about the structure of kmod.
>> Sorry for the noise.
> 
> Well, I wouldn't really call it noise :) I think there *could* be
> cases out there where a establishing a non-symbol-based hard
> dependency would be beneficial.
> 
Thanks for the encouraging words ;)

> In the bug you linked, I think one could hypothetically run into the
> same oops if the realtek module fails to load for whatever reason, no?

Basically yes. Just that it wouldn't be an oops any longer, r8169
would detect the missing dedicated PHY driver and bail out in probe().

> Since realtek is only a soft dependency of r8169, modprobe would
> consider realtek optional and would still try to load r8169 even if
> realtek had failed to load previously. Then wouldn't the same problem
> (described in the bugzilla) arise?  Maybe a hard dependency could
> possibly come in handy in this case, because a softdep unfortunately
> implies that r8169 can work without realtek loaded.
> 
Right. Even though kmod treats a softdep more or less like a harddep
with regard to module loading, it's called "soft" for a reason.
Relying on a softdep to satisfy a hard dependency doesn't seem
to be the ideal solution.

> Another potential usecase - I think livepatch folks (CC'd) have
> contemplated establishing some type of hard dependency between patch
> module and the target module before. I have only briefly skimmed
> Petr's POC [1] and it looks like this patch module dependency is
> accomplished through a request_module() call during load_module()
> (specifically, in klp_module_coming()) so that the patch module gets
> loaded before the target module finishes loading.
> 
> I initially thought this dependency could be expressed through
> MODULE_HARDDEP(target_module) in the patch module source code, but it
> looks like livepatch might require something more fine-grained, since
> the current POC tries to load the patch module before the target
> module runs its init(). In addition, this method wouldn't prevent the
> target module from loading if the patch module fails to load..
> 
> In any case, I appreciate the RFC and don't really have any gripes
> against having an analogous MODULE_HARDDEP() macro. If more similar
> cases crop up then it may be worth seriously pursuing, and then we'll
> at least have this RFC to start with :)
> 
> Thanks,
> 
> Jessica

Heiner
