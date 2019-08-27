Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7CAC9EF14
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 17:37:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729166AbfH0Ph3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 11:37:29 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40033 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728506AbfH0Ph3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 11:37:29 -0400
Received: by mail-pg1-f195.google.com with SMTP id w10so12900700pgj.7;
        Tue, 27 Aug 2019 08:37:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OGMX6emQR1IxpVlLVh2L9MxkhIrpMKYtuCVjN/it++Y=;
        b=oebhzohkNVT/w7W7XTgl7/oHL17GkyFgd1KngfBfOtFeWISVFzwlw4FJ1/ilEVb1rJ
         Vhupo0cLfir4CslrdMPm20LPcVWZOfVlPKnHqTvjUCZYds5FZICwG8mHxoX9m/b0JQUk
         RZS7mwP93F9aV3dbAYLA+DgQlKyzs3kf4xgyeg//nWAvL/0onj4AIlq+rLMvr+UB0muD
         vXB4teK+UIqDZsK6RTf0TtMTei8YiTX5pUrNrli/kJxFIfi0MGyavmz+rwFWm4eARzBG
         DiQcGUUg7JCDtynbvr6XoPlYOj7db5FlRbN5xdju6VENJohNMmJNmUljX7EGm5GUqaaB
         LvJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OGMX6emQR1IxpVlLVh2L9MxkhIrpMKYtuCVjN/it++Y=;
        b=IXOjTRc7e81xAbQxCX1qnmz5NZ7rIHLBDKaygKn3Lwj1+124CuemTzdCSAn1gN1ce1
         iEl6DUDGLJz5mXq241+3KeY4O9axbacoD6hzFuNyxSNL54u8QfAEnxSMsoiBANbR+gwo
         V0bPKcSWhCtqj5KWhlIaS6s73qs14gDLgq7/cIMc7t/ZdTbg4DuKM2ujNvMnVuH6gf2u
         K+pRDL6CkVNKNFyRQgBnduSIXeSwlOoQid0FYrGIh0CdJtLB7iNqWtZ181VQimcdCJ4o
         xDbOdLoCINdiHRunofyx9LoS3sKhXyijnMyxRD895I++NRR4xVdKV2CzPd9qIzpWHEZC
         vnQg==
X-Gm-Message-State: APjAAAWQkSVG41MgWQQHDOcHOb/ag7R7XAoWJrLUuXAPYfgg6QB5RQso
        uoMmOOYlg66UB4I45Niuht0=
X-Google-Smtp-Source: APXvYqycqUVsu1TtUS45hUIDY1J/diKpn9XcXnmUwZ9v2pFDeU5TxAt/H+OC3jfol/Ak4mHAeMmvQQ==
X-Received: by 2002:a17:90a:e38e:: with SMTP id b14mr13232435pjz.125.1566920248773;
        Tue, 27 Aug 2019 08:37:28 -0700 (PDT)
Received: from [10.230.28.130] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e3sm2720186pjr.9.2019.08.27.08.37.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Aug 2019 08:37:27 -0700 (PDT)
Subject: Re: [PATCH v1 net-next] net: phy: mdio_bus: make mdiobus_scan also
 cover PHY that only talks C45
To:     "Voon, Weifeng" <weifeng.voon@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jose Abreu <joabreu@synopsys.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>
References: <1566870769-9967-1-git-send-email-weifeng.voon@intel.com>
 <e9ece5ad-a669-6d6b-d050-c633cad15476@gmail.com>
 <20190826185418.GG2168@lunn.ch>
 <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <e7548bb7-a431-748b-36a9-be2eb4c3b400@gmail.com>
Date:   Tue, 27 Aug 2019 08:37:26 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <D6759987A7968C4889FDA6FA91D5CBC814758ED8@PGSMSX103.gar.corp.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/27/2019 8:23 AM, Voon, Weifeng wrote:
>>>> Make mdiobus_scan() to try harder to look for any PHY that only
>> talks C45.
>>> If you are not using Device Tree or ACPI, and you are letting the MDIO
>>> bus be scanned, it sounds like there should be a way for you to
>>> provide a hint as to which addresses should be scanned (that's
>>> mii_bus::phy_mask) and possibly enhance that with a mask of possible
>>> C45 devices?
>>
>> Yes, i don't like this unconditional c45 scanning. A lot of MDIO bus
>> drivers don't look for the MII_ADDR_C45. They are going to do a C22
>> transfer, and maybe not mask out the MII_ADDR_C45 from reg, causing an
>> invalid register write. Bad things can then happen.
>>
>> With DT and ACPI, we have an explicit indication that C45 should be used,
>> so we know on this platform C45 is safe to use. We need something
>> similar when not using DT or ACPI.
>>
>> 	  Andrew
> 
> Florian and Andrew,
> The mdio c22 is using the start-of-frame ST=01 while mdio c45 is using ST=00
> as identifier. So mdio c22 device will not response to mdio c45 protocol.
> As in IEEE 802.1ae-2002 Annex 45A.3 mention that:
> " Even though the Clause 45 MDIO frames using the ST=00 frame code
> will also be driven on to the Clause 22 MII Management interface,
> the Clause 22 PHYs will ignore the frames. "
> 
> Hence, I am not seeing any concern that the c45 scanning will mess up with 
> c22 devices.

It is not so much the messing up that concerns me other than the
increased scan time. Assuming you are making this change to support your
stmmac PCI patch series with SGMII/RGMII, etc. cannot you introduce a
bitmask of C45 PHY addresses that should be scanned and the logic could
look like (pseudo code):

- for each bit clear in mii_bus::phy_mask, scan it as C22
- for each bit clear in mii_bus::phy_c45_mask, scan it as C45

or something along those lines?
--
Florian
