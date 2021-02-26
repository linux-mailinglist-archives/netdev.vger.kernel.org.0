Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07F96326375
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 14:42:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhBZNlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 08:41:23 -0500
Received: from m42-2.mailgun.net ([69.72.42.2]:32882 "EHLO m42-2.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229795AbhBZNlU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Feb 2021 08:41:20 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1614346861; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=YptA8kAZhQsB/gFtRWYpF2uoN0yMu74Sopi3PQoKs7w=; b=cOT7C9SyQ20EVkcc0mn4TdToX6OZ9g3NtfMftu95xHdRBoyM4pd8yzb22ZTYEaP+0uAw8Pam
 KuYzLJW1H/6QtAmkFbjmrRuuC6vm1h6Dm2+6hOYvVwVXYmkO4y+j5zGNKsdFLa98+WMn10P3
 YCxyxsyuInt3rYqaFgpmR+w/EUM=
X-Mailgun-Sending-Ip: 69.72.42.2
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n01.prod.us-west-2.postgun.com with SMTP id
 6038fa4d8f0d5ba6c5f9731f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Fri, 26 Feb 2021 13:40:29
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id A64FCC43461; Fri, 26 Feb 2021 13:40:29 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 30C9FC433CA;
        Fri, 26 Feb 2021 13:40:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 30C9FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 3/3] PCI: Convert rtw88 power cycle quirk to shutdown quirk
References: <20210225174041.405739-1-kai.heng.feng@canonical.com>
        <20210225174041.405739-3-kai.heng.feng@canonical.com>
        <87o8g7e20e.fsf@codeaurora.org>
        <0e8ba5a4-0029-6966-e4ab-265a538f3b3d@gmail.com>
        <CAAd53p6tWUn-QbCysL_KweREmpSNfiQa7-gHgndqGta2UWt0=Q@mail.gmail.com>
        <6db9e75e-52a7-4316-bfd8-cf44b4875f44@gmail.com>
Date:   Fri, 26 Feb 2021 15:40:23 +0200
In-Reply-To: <6db9e75e-52a7-4316-bfd8-cf44b4875f44@gmail.com> (Heiner
        Kallweit's message of "Fri, 26 Feb 2021 14:31:31 +0100")
Message-ID: <87pn0n9cc8.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Heiner Kallweit <hkallweit1@gmail.com> writes:

> On 26.02.2021 13:18, Kai-Heng Feng wrote:
>> On Fri, Feb 26, 2021 at 8:10 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>>
>>> On 26.02.2021 08:12, Kalle Valo wrote:
>>>> Kai-Heng Feng <kai.heng.feng@canonical.com> writes:
>>>>
>>>>> Now we have a generic D3 shutdown quirk, so convert the original
>>>>> approach to a PCI quirk.
>>>>>
>>>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>>>> ---
>>>>>  drivers/net/wireless/realtek/rtw88/pci.c | 2 --
>>>>>  drivers/pci/quirks.c                     | 6 ++++++
>>>>>  2 files changed, 6 insertions(+), 2 deletions(-)
>>>>
>>>> It would have been nice to CC linux-wireless also on patches 1-2. I only
>>>> saw patch 3 and had to search the rest of patches from lkml.
>>>>
>>>> I assume this goes via the PCI tree so:
>>>>
>>>> Acked-by: Kalle Valo <kvalo@codeaurora.org>
>>>>
>>>
>>> To me it looks odd to (mis-)use the quirk mechanism to set a device
>>> to D3cold on shutdown. As I see it the quirk mechanism is used to work
>>> around certain device misbehavior. And setting a device to a D3
>>> state on shutdown is a normal activity, and the shutdown() callback
>>> seems to be a good place for it.
>>> I miss an explanation what the actual benefit of the change is.
>> 
>> To make putting device to D3 more generic, as there are more than one
>> device need the quirk.
>> 
>> Here's the discussion:
>> https://lore.kernel.org/linux-usb/00de6927-3fa6-a9a3-2d65-2b4d4e8f0012@linux.intel.com/
>> 
>
> Thanks for the link. For the AMD USB use case I don't have a strong opinion,
> what's considered the better option may be a question of personal taste.
> For rtw88 however I'd still consider it over-engineering to replace a simple
> call to pci_set_power_state() with a PCI quirk.
> I may be biased here because I find it sometimes bothering if I want to
> look up how a device is handled and in addition to checking the respective
> driver I also have to grep through quirks.c whether there's any special
> handling.

Good point about rtw88. And if there's a new PCI id for rtw88 we need to
also update the quirk in the PCI subsystem, which will be most likely
forgotten.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
