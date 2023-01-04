Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BB1E65D9F1
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 17:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231782AbjADQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 11:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjADQfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 11:35:10 -0500
Received: from mail.marcansoft.com (marcansoft.com [212.63.210.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969F4165A5;
        Wed,  4 Jan 2023 08:35:09 -0800 (PST)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: marcan@marcan.st)
        by mail.marcansoft.com (Postfix) with ESMTPSA id 3DDA541DF4;
        Wed,  4 Jan 2023 16:35:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=marcan.st; s=default;
        t=1672850108; bh=TvncWowxEgTW0bS4kVFjn9GlEGLockSZ0Yom8+Vo6QQ=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To;
        b=qRWfTMPYGZs22n13FfjSKlpkWBIpsqiqInet0D7+uDuKajt1tFJYMFgc4VSsKiCx9
         geK7qhY6yhQ593XoOD/FWWka99dMm4k5L06rwRBe1vU59o3SBC8lCuyGp4B1s3x+xJ
         CTkAwILwKPeh2sD89tvhrakMRt21M37kr/g4cdDT46O8CS4gKE3NfgId0ZS+IxrKeb
         k53cdi9eTxRZ8+ky1YsmUZuMc7hHDjDgJpPRjSG4lVF9B83nYqtbH+QHC4u+g0rHI+
         4e8sfJa8Z3BHMmV848D5uplvmOrP4W1lTL/qpcgcJ5xBxhbuZmRRJPi0ePpNX4F5XY
         OeXfC8769/otg==
Message-ID: <d242c9e4-e551-aa7a-0f20-f3f1351648a3@marcan.st>
Date:   Thu, 5 Jan 2023 01:35:00 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Arend van Spriel <arend.vanspriel@broadcom.com>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Alexander Prutskov <alep@cypress.com>,
        Chi-Hsien Lin <chi-hsien.lin@cypress.com>,
        Wright Feng <wright.feng@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Soontak Lee <soontak.lee@cypress.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230104100116.729-1-marcan@marcan.st>
 <20230104100116.729-2-marcan@marcan.st>
 <6517b791-1700-970d-ac0a-847f60a6fa6f@broadcom.com>
From:   Hector Martin <marcan@marcan.st>
Subject: Re: [PATCH v1 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
In-Reply-To: <6517b791-1700-970d-ac0a-847f60a6fa6f@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/01/2023 22.29, Arend van Spriel wrote:
> On 1/4/2023 11:01 AM, 'Hector Martin' via BRCM80211-DEV-LIST,PDL wrote:
>> The commit that introduced support for this chip incorrectly claimed it
>> is a Cypress-specific part, while in actuality it is just a variant of
>> BCM4355 silicon (as evidenced by the chip ID).
>>
>> The relationship between Cypress products and Broadcom products isn't
>> entirely clear, but given what little information is available and prior
>> art in the driver, it seems the convention should be that originally
>> Broadcom parts should retain the Broadcom name.
>>
>> Thus, rename the relevant constants and firmware file. Also rename the
>> specific 89459 PCIe ID to BCM43596, which seems to be the original
>> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
>> driver). Also declare the firmware as CLM-capable, since it is.
>>
>> Fixes: dce45ded7619 ("brcmfmac: Support 89459 pcie")
>> Signed-off-by: Hector Martin <marcan@marcan.st>
>> ---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c   | 5 ++---
>>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c   | 8 ++++----
>>   .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h | 6 +++---
>>   3 files changed, 9 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> index 121893bbaa1d..3e42c2bd0d9a 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> 
> [...]
> 
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> index ae57a9a3ab05..3264be485e20 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> 
> [...]
> 
>> @@ -2590,6 +2590,7 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
>>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_4350_DEVICE_ID, WCC),
>>   	BRCMF_PCIE_DEVICE_SUB(0x4355, BRCM_PCIE_VENDOR_ID_BROADCOM, 0x4355, WCC),
>>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_4354_RAW_DEVICE_ID, WCC),
>> +	BRCMF_PCIE_DEVICE(BRCM_PCIE_4355_RAW_DEVICE_ID, WCC),
> 
> A bit of a problem here. If Cypress want to support this device, 
> regardless how they branded it, they will provide its firmware. Given 
> that they initially added it (as 89459) I suppose we should mark it with 
> CYW and not WCC. Actually, see my comment below on RAW dev ids.

Right, I thought we might wind up with this issue. So then the question
becomes: can we give responsibility over PCI ID 0x4415 to Cypress and
mark just that one as CYW (if so it probably makes sense to keep that
labeled CYW89459 instead of BCM43596), and if not, is there some other
way to tell apart Cypress and Broadcom products we can use? I believe
the Apple side firmware is developed by Broadcom, not Cypress.

Note that even if we split by PCI device ID here, we still have a
problem with firmware selection, since that means we're requesting the
same firmware filename for both vendors (since that only tests the chip
ID and revision ID). If Apple is the *only* Broadcom customer using
these chips then we can get away with this, since I can just make sure
the fancy Apple firmware selection will never collide with the vanilla
firmware filename. But if other customers of both companies are both
shipping the same chip with different and incompatible generic firmware,
we need some way to tell them apart.

> 
>>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_4356_DEVICE_ID, WCC),
>>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_43567_DEVICE_ID, WCC),
>>   	BRCMF_PCIE_DEVICE(BRCM_PCIE_43570_DEVICE_ID, WCC),
> 
> [...]
> 
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>> index f4939cf62767..cacc43db86eb 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
>> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> 
> [...]
> 
>> @@ -72,6 +72,7 @@
>>   #define BRCM_PCIE_4350_DEVICE_ID	0x43a3
>>   #define BRCM_PCIE_4354_DEVICE_ID	0x43df
>>   #define BRCM_PCIE_4354_RAW_DEVICE_ID	0x4354
>> +#define BRCM_PCIE_4355_RAW_DEVICE_ID	0x4355
> 
> I would remove all RAW device ids. These should not be observed outside 
> chip vendor walls.

Ack, I'll remove this one instead of renaming it (or I can just drop all
the existing RAW IDs first in one commit at the head of v2 if you prefer
that).

- Hector
