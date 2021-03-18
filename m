Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000C5340985
	for <lists+netdev@lfdr.de>; Thu, 18 Mar 2021 17:03:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbhCRQCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 12:02:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231648AbhCRQC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Mar 2021 12:02:26 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D26BC06174A;
        Thu, 18 Mar 2021 09:02:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e14so1524861plj.2;
        Thu, 18 Mar 2021 09:02:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aWQn+KxpM+FCprE+s/1ErFCFT6wlwgu1cIOzSYiq34Y=;
        b=u31DHUD3YRWEsDn0Z43UW1cYn93K/PmjgIvTE+lTPMdMdInO78dLV4meStrFBpNBia
         +yj+J/NkeZ6BmEBf7KyiOYfsR4kLouQ8FrARjm4Pxghft+FZVrSlThO/r7Ek5FCuZ0hF
         PTaUI04FhSoidQHK9/8LjkcSvwXgFXWhQxXBXDAexK+YN86zybl/Gim9fmUE2HXO3QO9
         SzTBew4P5CJGmp5U2i5wkiIF7QvBrg20blmqWrxoLkWtP+ODGpU8cLH2EgHO288EGwnV
         iYuRGkiuzp7iey0gBxNPReZljW6FPOa7RxrAYt9mSefrl5d7tijdFzfJiIlt219GPF1H
         eutg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aWQn+KxpM+FCprE+s/1ErFCFT6wlwgu1cIOzSYiq34Y=;
        b=EETZrv5mvmqVn5dqAZjVnVIQpNAJC1DGT1MBFrKwAUVbd+fCn6MdjnCcHe7Jd84Kw2
         my5BaWLDh5cnGosr0PQjvawjS32LhTnqNtu5UDsGQmzUBpKxUCvp7oVEQsnaaiBzZwH1
         LMNINZaQ/Ey2pnu2gkGGyco9JgQO4DUv0qtb8QiJALPjFINdIeMFU6E+Cs/CnfItW4ff
         QxUZy6kv05nE3bP10hjjWW6pec1/CVmzprhnA7vluEEqFoLfDARMjT2VUNk0nc3tkCsf
         VzVgMIDlf+T++qfb/QXFKu8ULkprsbt7aSAxTSGhwOZYm1FI+Aje7mdIZxEjsLaOQFi4
         /PYg==
X-Gm-Message-State: AOAM531nXIjxwoQ90o8UNtGycX55ozrXfbVhiN1aUcxO9Odsi2+2oRxs
        XPbNUOaB1zxOsh8nKuZdgGQ=
X-Google-Smtp-Source: ABdhPJzOhpm96kinKcHy2Al29bhenoV3I92pQSHFNQj14p43DCFITgaT96zvor4crLga9TgoyXl6YQ==
X-Received: by 2002:a17:90b:a0d:: with SMTP id gg13mr4978358pjb.29.1616083345573;
        Thu, 18 Mar 2021 09:02:25 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q10sm2533948pgs.44.2021.03.18.09.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Mar 2021 09:02:25 -0700 (PDT)
Subject: Re: [PATCH net V2 1/1] net: phy: fix invalid phy id when probe using
 C22
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Wong Vee Khee <vee.khee.wong@intel.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Voon Weifeng <weifeng.voon@intel.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
References: <20210318090937.26465-1-vee.khee.wong@intel.com>
 <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c921bf7f-e4d1-eefa-c5ae-024d5e8a4845@gmail.com>
Date:   Thu, 18 Mar 2021 09:02:22 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <b63c5068-1203-fcb6-560d-1d2419bb39b0@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/18/2021 6:25 AM, Heiner Kallweit wrote:
> On 18.03.2021 10:09, Wong Vee Khee wrote:
>> When using Clause-22 to probe for PHY devices such as the Marvell
>> 88E2110, PHY ID with value 0 is read from the MII PHYID registers
>> which caused the PHY framework failed to attach the Marvell PHY
>> driver.
>>
>> Fixed this by adding a check of PHY ID equals to all zeroes.
>>
> 
> I was wondering whether we have, and may break, use cases where a PHY,
> for whatever reason, reports PHY ID 0, but works with the genphy
> driver. And indeed in swphy_read_reg() we return PHY ID 0, therefore
> the patch may break the fixed phy.
> Having said that I think your patch is ok, but we need a change of
> the PHY ID reported by swphy_read_reg() first.
> At a first glance changing the PHY ID to 0x00000001 in swphy_read_reg()
> should be sufficient. This value shouldn't collide with any real world
> PHY ID.

It most likely would not, but it could be considered an ABI breakage,
unless we filter out what we report to user-space via SIOGCMIIREG and
/sys/class/mdio_bus/*/*/phy_id

Ideally we would have assigned an unique PHY OUI to the fixed PHY but
that would have required registering Linux as a vendor, and the process
is not entirely clear to me about how to go about doing that.
--
Florian
