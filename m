Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B777E30ED2A
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 08:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbhBDHTv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 02:19:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233134AbhBDHTq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Feb 2021 02:19:46 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EE89C0613D6;
        Wed,  3 Feb 2021 23:19:05 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id i9so2063154wmq.1;
        Wed, 03 Feb 2021 23:19:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dKnnBugZuls52n3i8ryVdUVwDswkCyMsKS/zoa3vdT4=;
        b=XLooWB7wQENTBZ+q5Gr4QPZUqlDZ51S6BpANcmk0iSCvz4RuCCjwEwCXMAi79mC+Jo
         DL5zJassUWNoudkQO3jxJyCb/6eem271pB9rJfUloaqqXTfaVpEEz87uM++y0bEHz2oC
         sl5xrfm76h6cPH3g9rWi1+rhCIDU0vRZaI7kFvuuGWMoEj3G4OYwPdwBH5NbKxo/5pC4
         dHTqs48dYgSmSSELIIMBZwhRTk70cFnh1nQ10fOus3NNiSvR7HA7Rgn4H4QuBcEzOqtw
         O5mCy0oqrIxIPwJsED3eOIsyqJnLuVg8M+uslcVhZ0TS2IWXw55aGAlyzhL71px2WHAG
         pGQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dKnnBugZuls52n3i8ryVdUVwDswkCyMsKS/zoa3vdT4=;
        b=V0HJEZzfXeAPNiVlQVgd8rcHO1NQiw6dMMn4V4zc69o6sXdRT7lkAJ2FcZwjokTMDt
         UuEncnfo0IOFQVTFvSz93QeCXAbitgKCezK8j2eI3gZ5JXif37+TORutJOXzqOesTm/N
         zgqxsLt399/xEtN/wQFFSeV/C+tY4YG7cqfjb1/VAKYUGeSfaA86GfP1W9xj82R+fOcT
         xVbdTZCUVVUw3SbGKNcTXWeYSATqtb1+XX+ZxkogAKd1zIX9ByIDyh8RaUraRwhCODms
         dSoQC49/wofcntEolmhhZbeScSOXb1ZJ48pUhBJHja7JTVtvqTiwd1Wku8fsboCCbNCC
         pvBA==
X-Gm-Message-State: AOAM533EZY2J/xJTOXFPWR0LiI47DYkVe8xXKhddM08w/TkACbgDKzYC
        +VKVHVBbCBf1d3YQej6o6hUKkNxm+tw=
X-Google-Smtp-Source: ABdhPJwwgTXueQCGO+tcm2C3Ut0CQ0tzOg+r3gZXQFuM28sTRiR8kWKi+v+FCzb6wybo5DDCTDlbJg==
X-Received: by 2002:a7b:c8ca:: with SMTP id f10mr6060695wml.101.1612423144089;
        Wed, 03 Feb 2021 23:19:04 -0800 (PST)
Received: from ?IPv6:2003:ea:8f1f:ad00:2463:7e37:9a7d:855f? (p200300ea8f1fad0024637e379a7d855f.dip0.t-ipconnect.de. [2003:ea:8f1f:ad00:2463:7e37:9a7d:855f])
        by smtp.googlemail.com with ESMTPSA id c20sm4978402wmb.38.2021.02.03.23.19.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Feb 2021 23:19:03 -0800 (PST)
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Raju Rangoju <rajur@chelsio.com>,
        David Miller <davem@davemloft.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b07dc99d-7fd0-48c0-3fc4-89cda90ee5d7@gmail.com>
 <a64e550c-b8d2-889e-1f55-019b10060c1b@gmail.com>
 <20210203183019.7c9a5004@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next 1/4] PCI/VPD: Remove Chelsio T3 quirk
Message-ID: <2a15d286-2f3d-9ec5-0f54-925a51427689@gmail.com>
Date:   Thu, 4 Feb 2021 08:18:52 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210203183019.7c9a5004@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04.02.2021 03:30, Jakub Kicinski wrote:
> On Tue, 2 Feb 2021 21:35:55 +0100 Heiner Kallweit wrote:
>> cxgb3 driver doesn't use the PCI core code for VPD access, it has its own
>> implementation. Therefore we don't need a quirk for it in the core code.
>>
>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> Would this not affect the size of the file under sysfs?
> 
Good point. Not the size (because it's 0 = unlimited), but the exposed
data would be limited to what can be auto-detected from offset 0.
Most T3 devices have the VPD at offset 0x0c00, and I'd expect (don't have
test hw) that there's no valid VPD structure at offset 0.
Therefore no VPD data will be exposed via sysfs. But:

- VPD data starting at an offset doesn't follow PCI spec. Therefore it's
  questionable whether anybody can expect such data to be available via sysfs.

- Typical userspace tools like lspci start parsing VPD at offset 0,
  and therefore won't recognize the VPD data also as of today.
  (again: no test hw to verify this)

- There might be Chelsio-provided userspace tools that use sysfs VPD access
  and parse the data based on knowledge of the proprietary VPD layout.
  Such a usecase would be broken now, indeed. Not sure whether any such
  tool exists, maybe Raju can comment on this.



>> diff --git a/drivers/pci/vpd.c b/drivers/pci/vpd.c
>> index 7915d10f9..db86fe226 100644
>> --- a/drivers/pci/vpd.c
>> +++ b/drivers/pci/vpd.c
>> @@ -628,22 +628,17 @@ static void quirk_chelsio_extend_vpd(struct pci_dev *dev)
>>  {
>>  	int chip = (dev->device & 0xf000) >> 12;
>>  	int func = (dev->device & 0x0f00) >>  8;
>> -	int prod = (dev->device & 0x00ff) >>  0;
>>  
>>  	/*
>> -	 * If this is a T3-based adapter, there's a 1KB VPD area at offset
>> -	 * 0xc00 which contains the preferred VPD values.  If this is a T4 or
>> -	 * later based adapter, the special VPD is at offset 0x400 for the
>> -	 * Physical Functions (the SR-IOV Virtual Functions have no VPD
>> -	 * Capabilities).  The PCI VPD Access core routines will normally
>> +	 * If this is a T4 or later based adapter, the special VPD is at offset
>> +	 * 0x400 for the Physical Functions (the SR-IOV Virtual Functions have
>> +	 * no VPD Capabilities). The PCI VPD Access core routines will normally
>>  	 * compute the size of the VPD by parsing the VPD Data Structure at
>>  	 * offset 0x000.  This will result in silent failures when attempting
>>  	 * to accesses these other VPD areas which are beyond those computed
>>  	 * limits.
>>  	 */
>> -	if (chip == 0x0 && prod >= 0x20)
>> -		pci_set_vpd_size(dev, 8192);
>> -	else if (chip >= 0x4 && func < 0x8)
>> +	if (chip >= 0x4 && func < 0x8)
>>  		pci_set_vpd_size(dev, 2048);
>>  }
>>  
> 

