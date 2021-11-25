Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B20B45E1FD
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 22:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357196AbhKYVQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 16:16:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243150AbhKYVOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 16:14:39 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F5FFC061574
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 13:11:27 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id c6-20020a05600c0ac600b0033c3aedd30aso5486556wmr.5
        for <netdev@vger.kernel.org>; Thu, 25 Nov 2021 13:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:from:to:cc
         :references:subject:in-reply-to:content-transfer-encoding;
        bh=fejCLqfpxeszsjUhqKoV6J1c3n1EJ0BRSy7qk2+0l2M=;
        b=epQ9prFjDGfpItBMS36QakCCJiCnL32/jVWQta4juxmZrAVkBhCsR0IvmulRLX4JSB
         WhCG0eeVupFhM0D+lpm0jgmOPNwOpgiXxskUZBVZ1jnfXOUjNokfC8011dXH/92G2jIU
         5Ey8H4p4CFeihnO2RJCA0xW5CubyzvgcWzNFDqn6nHiWXLviSmF9wkP1tf00kwVpVhq8
         oB/fv3PhUQTeMjnsLdDp7drrcfeBlGoyz822n10iN9h/rvxhWZoNIEIlngaafu4tXWGj
         F0kSblk0DPXwoaOqtyuWDB76MsZUjKEckeD3DbRE0OhCZvO7w7buwd56Q9ynIbLDh4AL
         x/KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:from:to:cc:references:subject:in-reply-to
         :content-transfer-encoding;
        bh=fejCLqfpxeszsjUhqKoV6J1c3n1EJ0BRSy7qk2+0l2M=;
        b=ZEUtrsw20hrt9VDXzirYA5M9SK95apwVdvkNbt9tylsWUOtRAe0xQspFbxmen5id/7
         uAkJh9qlGoODk1CMAGyJMTtLA9n9bwG8YZ1f6/RyDznF/A6kGAjErhr1GLxH+FnJQGGm
         3HgOpV8zdVvdSUmPlcKAu4cAojxOV/0v3u7sjsz/7zp7QarPblRTq+zhAI0wU0AmF7NG
         I7Na49/1or44yHNPVZnpBKbKDTBC6+DnTdrW7KUeSFiv1d8DEvut0IfenscQVLMV/CTy
         4SpZiFcruGANEhw75vbsr1sft+3/FTlPLxLdwbdqiY0nFZ0i/rL/dAFkdc690qAC4OMG
         8JVQ==
X-Gm-Message-State: AOAM533nxe8BskKsWyOHAz5tLJ3eol3p3e0eQGboW++x0GaFXHvP51MN
        Cg8sIv+PvJrBRZ/dPEWLenuqFZnK8kg=
X-Google-Smtp-Source: ABdhPJzqfwCY9i+K//SkPkGYS1wzRnRNUZb93hE4GO8nuDWqRBESFuF3uBoLH/KgpXr7uqKvJsordw==
X-Received: by 2002:a1c:1d04:: with SMTP id d4mr10758701wmd.103.1637874685920;
        Thu, 25 Nov 2021 13:11:25 -0800 (PST)
Received: from ?IPV6:2003:ea:8f1a:f00:4553:54d4:5457:fb08? (p200300ea8f1a0f00455354d45457fb08.dip0.t-ipconnect.de. [2003:ea:8f1a:f00:4553:54d4:5457:fb08])
        by smtp.googlemail.com with ESMTPSA id g5sm5508520wri.45.2021.11.25.13.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Nov 2021 13:11:25 -0800 (PST)
Message-ID: <4a28ad86-1b1e-ab51-2351-efdd6caf8e1d@gmail.com>
Date:   Thu, 25 Nov 2021 22:11:16 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     netdev@vger.kernel.org, ath10k@lists.infradead.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20211124144505.31e15716@hermes.local>
 <20211124164648.43c354f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <1849b7a3-cdfe-f9dc-e4d1-172e8b1667d2@gmail.com>
Subject: Re: [Bug 215129] New: Linux kernel hangs during power down
In-Reply-To: <1849b7a3-cdfe-f9dc-e4d1-172e8b1667d2@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.11.2021 08:32, Heiner Kallweit wrote:
> On 25.11.2021 01:46, Jakub Kicinski wrote:
>> Adding Kalle and Hainer.
>>
>> On Wed, 24 Nov 2021 14:45:05 -0800 Stephen Hemminger wrote:
>>> Begin forwarded message:
>>>
>>> Date: Wed, 24 Nov 2021 21:14:53 +0000
>>> From: bugzilla-daemon@bugzilla.kernel.org
>>> To: stephen@networkplumber.org
>>> Subject: [Bug 215129] New: Linux kernel hangs during power down
>>>
>>>
>>> https://bugzilla.kernel.org/show_bug.cgi?id=215129
>>>
>>>             Bug ID: 215129
>>>            Summary: Linux kernel hangs during power down
>>>            Product: Networking
>>>            Version: 2.5
>>>     Kernel Version: 5.15
>>>           Hardware: All
>>>                 OS: Linux
>>>               Tree: Mainline
>>>             Status: NEW
>>>           Severity: normal
>>>           Priority: P1
>>>          Component: Other
>>>           Assignee: stephen@networkplumber.org
>>>           Reporter: martin.stolpe@gmail.com
>>>         Regression: No
>>>
>>> Created attachment 299703
>>>   --> https://bugzilla.kernel.org/attachment.cgi?id=299703&action=edit    
>>> Kernel log after timeout occured
>>>
>>> On my system the kernel is waiting for a task during shutdown which doesn't
>>> complete.
>>>
>>> The commit which causes this behavior is:
>>> [f32a213765739f2a1db319346799f130a3d08820] ethtool: runtime-resume netdev
>>> parent before ethtool ioctl ops
>>>
>>> This bug causes also that the system gets unresponsive after starting Steam:
>>> https://steamcommunity.com/app/221410/discussions/2/3194736442566303600/
>>>
>>
> 
> I think the reference to ath10k_pci is misleading, Kalle isn't needed here.
> The actual issue is a RTNL deadlock in igb_resume(). See log snippet:
> 
> Nov 24 18:56:19 MartinsPc kernel:  igb_resume+0xff/0x1e0 [igb 21bf6a00cb1f20e9b0e8434f7f8748a0504e93f8]
> Nov 24 18:56:19 MartinsPc kernel:  pci_pm_runtime_resume+0xa7/0xd0
> Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
> Nov 24 18:56:19 MartinsPc kernel:  __rpm_callback+0x41/0x120
> Nov 24 18:56:19 MartinsPc kernel:  ? pci_pm_freeze_noirq+0x110/0x110
> Nov 24 18:56:19 MartinsPc kernel:  rpm_callback+0x35/0x70
> Nov 24 18:56:19 MartinsPc kernel:  rpm_resume+0x567/0x810
> Nov 24 18:56:19 MartinsPc kernel:  __pm_runtime_resume+0x4a/0x80
> Nov 24 18:56:19 MartinsPc kernel:  dev_ethtool+0xd4/0x2d80
> 
> We have at least two places in net core where runtime_resume() is called
> under RTNL. This conflicts with the current structure in few Intel drivers
> that have something like the following in their resume path.
> 
> 	rtnl_lock();
> 	if (!err && netif_running(netdev))
> 		err = __igb_open(netdev, true);
> 
> 	if (!err)
> 		netif_device_attach(netdev);
> 	rtnl_unlock();
> 
> Other drivers don't do this, so it's the question whether it's actually
> needed here to take RTNL. Some discussion was started [0], but it ended
> w/o tangible result and since then it has been surprisingly quiet.
> 
> [0] https://www.spinics.net/lists/netdev/msg736880.html
> 

I think the problem with runtime_resume() taking RTNL could also hit
the driver internally. See following call chain: If this would ever
be called when the device is runtime-suspended, then a similar
deadlock would occur.

__dev_open()    - called with RTNL held
  igb_open()
    __igb_open()   - arg resuming is false
      if (!resuming)
        pm_runtime_get_sync(&pdev->dev);
          igb_resume()
            rtnl_lock()
