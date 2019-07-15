Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC7DE68634
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 11:21:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729594AbfGOJVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 05:21:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43399 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729563AbfGOJVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 05:21:12 -0400
Received: from mail-pg1-f197.google.com ([209.85.215.197])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <kai.heng.feng@canonical.com>)
        id 1hmxAT-0008Rl-HO
        for netdev@vger.kernel.org; Mon, 15 Jul 2019 09:21:09 +0000
Received: by mail-pg1-f197.google.com with SMTP id x19so10187511pgx.1
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 02:21:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=K7sR63lDZ6+bfE96HoDVWneUYi62vGyC0+ZoJVjOpqo=;
        b=gw5QS08BvCIl7XEGaWTcWqw9YQguPbcZ2matHLulgXDcf0ef9qNVNvTm79/7v3F+dN
         Cu466nhMsMgWLxphKUcl1EW/1tmCJErg+R1oJsV4foa9WDFcMb4DIlUxx1r/s+Ym+daB
         9STdB/IvFHcUuykPjxddPIOJLXAQiwtmYZH2QOHcwxd6TKxcqpR4swkt/yGblqE8En87
         N11NNBIrtNr6UDEdm/PxAGnhnXdcP3MUZs97UXva1vfVFSwHCh4r36B/PD/e3mPlMoaA
         gy0PfsziyqQOBhv03jttj0En8ICb76xDJciyr4sJPrRdQ2UtsQWegGvanSpfD3gchRa1
         ovOQ==
X-Gm-Message-State: APjAAAXqczseTdhfcF797Da/laStvkhkxkhNV1UIuJqyhF0PXPkEY9SU
        ZiG1MYx37BvC7SVzWTB7fRGY9N2GtJv93JEoeYG1HUmhZcp09zmF0g2SLh4+EPEZYbx3fn0OK+n
        U/LBiaKzlr+681qSG7sNkAo/9wWTw4LNhmg==
X-Received: by 2002:a17:90a:601:: with SMTP id j1mr27617739pjj.96.1563182468249;
        Mon, 15 Jul 2019 02:21:08 -0700 (PDT)
X-Google-Smtp-Source: APXvYqzHwAWIe0k8hTqh9iJGtpYLSTUNN/uaDfo3XVoAz1JGLpmxyFRzJG7TI40AZpQ93ZnK+ynB3A==
X-Received: by 2002:a17:90a:601:: with SMTP id j1mr27617713pjj.96.1563182467961;
        Mon, 15 Jul 2019 02:21:07 -0700 (PDT)
Received: from [10.101.46.105] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id u3sm14656829pjn.5.2019.07.15.02.21.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Jul 2019 02:21:07 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8;
        delsp=yes;
        format=flowed
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [Intel-wired-lan] [PATCH] e1000e: Make speed detection on
 hotplugging cable more reliable
From:   Kai Heng Feng <kai.heng.feng@canonical.com>
In-Reply-To: <37a1e2af-64c6-4515-5dcc-6051e1192636@molgen.mpg.de>
Date:   Mon, 15 Jul 2019 17:21:04 +0800
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
Message-Id: <1BD6D413-E22A-40A3-B8E8-B9B56B9B5232@canonical.com>
References: <20190715084355.9962-1-kai.heng.feng@canonical.com>
 <017771d5-f168-493a-46a1-88e513941ba1@molgen.mpg.de>
 <F9859C57-4F6D-4685-B4B6-D1D7DCB50D27@canonical.com>
 <37a1e2af-64c6-4515-5dcc-6051e1192636@molgen.mpg.de>
To:     Paul Menzel <pmenzel@molgen.mpg.de>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

at 5:06 PM, Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Kai Heng,
>
>
> (with or without hyphen?)
>
> On 7/15/19 11:00 AM, Kai Heng Feng wrote:
>> at 4:52 PM, Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
>>> On 7/15/19 10:43 AM, Kai-Heng Feng wrote:
>>>> After hotplugging an 1Gbps ethernet cable with 1Gbps link partner, the
>>>> MII_BMSR may reports 10Mbps, renders the network rather slow.
>>>
>>> s/may reports/may report/
>>> s/renders/rendering/
>>
>> Apparently English isn’t my mother tongue ;)
>
> No problem. Mine neither.
>
>>>> The issue has much lower fail rate after commit 59653e6497d1 ("e1000e:
>>>> Make watchdog use delayed work"), which esssentially introduces some
>>>
>>> essentially
>>
>> Ok.
>>
>>>> delay before running the watchdog task.
>>>>
>>>> But there's still a chance that the hotplugging event and the queued
>>>> watchdog task gets run at the same time, then the original issue can be
>>>> observed once again.
>>>>
>>>> So let's use mod_delayed_work() to add a deterministic 1 second delay
>>>> before running watchdog task, after an interrupt.
>>>
>>> I am not clear about the effects for the user. Could you elaborate
>>> please? Does the link now come up up to one second later?
>>
>> Yes, the link will be up on a fixed one second later.
>>
>> The delay varies between 0 to 2 seconds without this patch.
>
> Is there no other fix? Regarding booting a system fast (less than six
> seconds), a fixed one second delay is quite a regression on systems where
> it worked before.

This only affects when ethernet cable is hot plugged.

Kai-Heng

>
>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>
>>> Any bug URL?
>>
>> If maintainers think it’s necessary then I’ll file one.
>
> Not necessary, if there is none. I thought you had one in Launchpad or so.
>
>
> Kind regards,
>
> Paul


