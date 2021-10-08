Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FF544265A1
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 10:12:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbhJHIOO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 04:14:14 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:4055 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhJHIOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 04:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633680736; x=1665216736;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=J15oMMG9rv1wh4nQYkmbQkjSLViu6qN4eINtjWsGwtQ=;
  b=ZMia7WYI9w/X0jINNBJNzGEluMOAkqdstXiP0vUykUGTWP9AMQqWhJys
   hvbnZ43l1O5BhDQcRkPy62++0kJNy8Ng3/uGrWrPV/mO51x++82VS+We0
   0gPSyRWpwqZO7HuYqwbfaQw+pRGDjHmkZd4E2vqA5e15KEIEuCKu6yH+O
   SKrjKePsK9jePa0/3r25kvccp7K+qF3gpgNaZBrj+o4xiK8cfjgP2iVrr
   iCgoyjlzMD+/dD06cfy9Wy7YFGqoh/40DTah2c1wNM5Yv5egrz5jMv8GA
   0zacujanipi99ousCAYbn0GZfTqFIiH5qvtw51/H8L0x5RKACut4tad+Z
   A==;
IronPort-SDR: 9/e9WlaIP/j0OjIptTsxaiGbraRKTAtnBOesXTt4/aGr62zb63lBUhdOsvpfWLVE5tZFlwg38n
 6Xk74qlZzbx9K9JYgYTmrxkCUCssgBbfRe8YJ+gBig1ahTikqdsGYPmgSL+pCtecejntKSXdC0
 hbMpUuEDAlZllbtFdL4Df23Oy2hyeLGHcOC5Z1iKulRWFXkjcULPhgRcQxj2Uil41MHBDJpRIW
 YmSXxvI2VPLQwKUiAZnRV0LBka5f8GRK805uzhwChWbPqS250WuqCbYRL/U6QmTIYvjS7cfYeH
 i58AGVTfwCB/SBa4GE30UYAM
X-IronPort-AV: E=Sophos;i="5.85,357,1624345200"; 
   d="scan'208";a="147259533"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Oct 2021 01:12:15 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Fri, 8 Oct 2021 01:12:14 -0700
Received: from [10.12.68.175] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Fri, 8 Oct 2021 01:12:12 -0700
Subject: Re: [RFC net-next PATCH 08/16] net: macb: Clean up macb_validate
To:     Sean Anderson <sean.anderson@seco.com>, <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
References: <20211004191527.1610759-1-sean.anderson@seco.com>
 <20211004191527.1610759-9-sean.anderson@seco.com>
 <b1401da6-5bab-2e4c-e667-aca0bbf013dc@microchip.com>
 <b898bd53-baa8-2a25-74d2-de3b75f447e3@seco.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <4ec4c642-6a31-8e33-d7bd-e7f8882d7e3b@microchip.com>
Date:   Fri, 8 Oct 2021 10:12:12 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <b898bd53-baa8-2a25-74d2-de3b75f447e3@seco.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sean,

On 08/10/2021 at 02:20, Sean Anderson wrote:
> 
> On 10/7/21 9:22 AM, Nicolas Ferre wrote:
>> On 04/10/2021 at 21:15, Sean Anderson wrote:
>>> While we're on the subject, could someone clarify the relationship
>>> between the various speed capabilities? What's the difference between
>>> MACB_CAPS_GIGABIT_MODE_AVAILABLE, MACB_CAPS_HIGH_SPEED, MACB_CAPS_PCS,
>>> and macb_is_gem()? Would there ever be a GEM without GIGABIT_MODE?
 >>
>> Yes. GEM is a new revision of the IP that is capable of doing Gigabit
>> mode or not. sama7g5_emac_config is typically one of those doing only
>> 10/100.
 >
> Thanks for pointing that out. But even that config still has
> MACB_CAPS_GIGABIT_MODE_AVAILABLE. So presumably you can use it for
> gigabit speed if you don't use MII-on-RGMII. I suppose that
> sama7g5_emac_config is not a GEM?

There must be a confusion between sama7g5_gem_config and 
sama7g5_emac_config here. The later one doesn't have this 
MACB_CAPS_GIGABIT_MODE_AVAILABLE capability.
Both are flavors of GEM and identified as such in the driver.

Best regards,
   Nicolas

-- 
Nicolas Ferre
