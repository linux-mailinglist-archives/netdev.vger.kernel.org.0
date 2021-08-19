Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C5583F16D6
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 11:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238120AbhHSJ5C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 05:57:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238109AbhHSJ5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 05:57:00 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC3C1C0613CF;
        Thu, 19 Aug 2021 02:56:23 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id l11so8182491wrx.4;
        Thu, 19 Aug 2021 02:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZGvg8dfc9wmKRNl+QTgPyRSm2QhtLNfk+83gimM4XNI=;
        b=hag8HjWkoLnlWff2dlAOAjapUPbMFhns4/RrxwIf+cDegN7pvOFV7IfidwjeW08FXQ
         Je5DUPNJLtqG/sUQaoBAmHu5UXUQxve7qCtaIKPUOmDLAf6T9UhuCy7bmTfQed2OxHrM
         aHChMrPIA7tydWGo4dnGXOD0+ZzCHzGFZM8F4oOAJoi5JO2vs2iWYwaWZ+wKS5Lkgsb/
         WZdhWbue0BccvU9iVXZItQuIhcCvx1tvofwNURqgK5385KBnererOE2iJWfQrNS+eBPk
         j5ZJRQo5rlxDP6qRR5bQysbTRpyJnnuii4QnhDZ0aXklIyB6vr2vkP7byz9KkKYcz5v8
         RcjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZGvg8dfc9wmKRNl+QTgPyRSm2QhtLNfk+83gimM4XNI=;
        b=nzZAs+Xe2ink19GpjDYLZ1Ko4/sEEbMjSNNJ3PYlPNLmo7ohKwVIDgNEg5kFHpD+uI
         l3AdU0pfV/VoljaF/mamP4l8/YqKbVBZc3F31bta9lY3A4ewZoOk5Ii5WMNT/fGyMT2Y
         69Kl3va95o2rSdMLx4TublyaFD1eFu3V8MoJL5JKtrAFwQGhlWjCFbmlc9Cq3KX6MSSE
         XSlKmGyomYS7eJfMsE8Hl1GRlJhRLZS5bZrgPPTCBgEkK2O07/Il7bI6Bvahcs3cyuqI
         dlT06oS5Rs8nqPlFSGMnKojm+GFzyCE1TrfzSel/N2nIGGtBD9lNLtaD8jRmPzNiY+6A
         0eig==
X-Gm-Message-State: AOAM533MX1Orz/MNaCjkm02Uc1izYrcpJmLIosCAxxL4YqdeS41zugti
        TApjSQNLHy8kDxwCVkNFgsUIiahcZGSieg==
X-Google-Smtp-Source: ABdhPJxlGYn7yHv27sS4+nkt/PPDWOb1MWMaWjfTDsGFR/1mUORspVeaACo9BHfSH46NWm2h9tIvHA==
X-Received: by 2002:a5d:4d8e:: with SMTP id b14mr2683537wru.422.1629366982248;
        Thu, 19 Aug 2021 02:56:22 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:c830:756b:68fa:7529? (p200300ea8f084500c830756b68fa7529.dip0.t-ipconnect.de. [2003:ea:8f08:4500:c830:756b:68fa:7529])
        by smtp.googlemail.com with ESMTPSA id o14sm2005680wms.2.2021.08.19.02.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Aug 2021 02:56:21 -0700 (PDT)
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     nic_swsd <nic_swsd@realtek.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
References: <20210819054542.608745-1-kai.heng.feng@canonical.com>
 <20210819054542.608745-4-kai.heng.feng@canonical.com>
 <084b8ea3-99d8-3393-4b74-0779c92fde64@gmail.com>
 <CAAd53p4CYOOXjyNdTnBtsQ+2MW-Jar8fgEfPFZHSPrJde=HqVA@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v3 3/3] r8169: Enable ASPM for selected NICs
Message-ID: <d3e4ec0b-2681-1b3c-f0ca-828b24b253e7@gmail.com>
Date:   Thu, 19 Aug 2021 11:56:11 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <CAAd53p4CYOOXjyNdTnBtsQ+2MW-Jar8fgEfPFZHSPrJde=HqVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.08.2021 08:50, Kai-Heng Feng wrote:
> On Thu, Aug 19, 2021 at 2:08 PM Heiner Kallweit <hkallweit1@gmail.com> wrote:
>>
>> On 19.08.2021 07:45, Kai-Heng Feng wrote:
>>> The latest vendor driver enables ASPM for more recent r8168 NICs, so
>>> disable ASPM on older chips and enable ASPM for the rest.
>>>
>>> Rename aspm_manageable to pcie_aspm_manageable to indicate it's ASPM
>>> from PCIe, and use rtl_aspm_supported for Realtek NIC's internal ASPM
>>> function.
>>>
>>> Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
>>> ---
>>> v3:
>>>  - Use pcie_aspm_supported() to retrieve ASPM support status
>>>  - Use whitelist for r8169 internal ASPM status
>>>
>>> v2:
>>>  - No change
>>>
>>>  drivers/net/ethernet/realtek/r8169_main.c | 27 ++++++++++++++++-------
>>>  1 file changed, 19 insertions(+), 8 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 3359509c1c351..88e015d93e490 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -623,7 +623,8 @@ struct rtl8169_private {
>>>       } wk;
>>>
>>>       unsigned supports_gmii:1;
>>> -     unsigned aspm_manageable:1;
>>> +     unsigned pcie_aspm_manageable:1;
>>> +     unsigned rtl_aspm_supported:1;
>>>       unsigned rtl_aspm_enabled:1;
>>>       struct delayed_work aspm_toggle;
>>>       atomic_t aspm_packet_count;
>>> @@ -702,6 +703,20 @@ static bool rtl_is_8168evl_up(struct rtl8169_private *tp)
>>>              tp->mac_version <= RTL_GIGA_MAC_VER_53;
>>>  }
>>>
>>> +static int rtl_supports_aspm(struct rtl8169_private *tp)
>>> +{
>>> +     switch (tp->mac_version) {
>>> +     case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_31:
>>> +     case RTL_GIGA_MAC_VER_37:
>>> +     case RTL_GIGA_MAC_VER_39:
>>> +     case RTL_GIGA_MAC_VER_43:
>>> +     case RTL_GIGA_MAC_VER_47:
>>> +             return 0;
>>> +     default:
>>> +             return 1;
>>> +     }
>>> +}
>>> +
>>>  static bool rtl_supports_eee(struct rtl8169_private *tp)
>>>  {
>>>       return tp->mac_version >= RTL_GIGA_MAC_VER_34 &&
>>> @@ -2669,7 +2684,7 @@ static void rtl_pcie_state_l2l3_disable(struct rtl8169_private *tp)
>>>
>>>  static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
>>>  {
>>> -     if (!tp->aspm_manageable && enable)
>>> +     if (!(tp->pcie_aspm_manageable && tp->rtl_aspm_supported) && enable)
>>>               return;
>>>
>>>       tp->rtl_aspm_enabled = enable;
>>> @@ -5319,12 +5334,8 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
>>>       if (rc)
>>>               return rc;
>>>
>>> -     /* Disable ASPM completely as that cause random device stop working
>>> -      * problems as well as full system hangs for some PCIe devices users.
>>> -      */
>>> -     rc = pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S |
>>> -                                       PCIE_LINK_STATE_L1);
>>> -     tp->aspm_manageable = !rc;
>>> +     tp->pcie_aspm_manageable = pcie_aspm_supported(pdev);
>>
>> That's not what I meant, and it's also not correct.
> 
> In case I make another mistake in next series, let me ask it more clearly...
> What you meant was to check both link->aspm_enabled and link->aspm_support?
> 
aspm_enabled can be changed by the user at any time.
pci_disable_link_state() also considers whether BIOS forbids that OS
mess with ASPM. See aspm_disabled.

>>
>>> +     tp->rtl_aspm_supported = rtl_supports_aspm(tp);
> 
> Is rtl_supports_aspm() what you expect for the whitelist?
> And what else am I missing?
> 
I meant use rtl_supports_aspm() to check when ASPM is relevant at all,
and in addition use a blacklist for chip versions where ASPM is
completely unusable.

> Kai-Heng
> 
>>>
>>>       /* enable device (incl. PCI PM wakeup and hotplug setup) */
>>>       rc = pcim_enable_device(pdev);
>>>
>>

