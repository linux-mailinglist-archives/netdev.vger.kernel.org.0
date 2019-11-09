Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09173F5FBF
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 16:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfKIPQC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 10:16:02 -0500
Received: from lelv0143.ext.ti.com ([198.47.23.248]:39480 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726372AbfKIPPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 10:15:54 -0500
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA9FFj9w067009;
        Sat, 9 Nov 2019 09:15:45 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1573312545;
        bh=q54WWdOI9rdwUEth2Kb8Y2jtiHd96DerLSZQMBvr0mw=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=N6uE/FDsYmPVkQCW3YW4pahPNsaAlK2OLy85H0HC9Jr2Nx9Vt/oW7jNR0Y6wtKcLr
         LZht9DdUPsEqxQ8dC9j2v6/gsYKVrVQucIotruUNWLm4PVVb3DqL/xTWGum4NKGavX
         ZbdKHyxCciRTs2Fol1hFLSA2lmeTZUxVj0AsJ90k=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA9FFjUT087338
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Sat, 9 Nov 2019 09:15:45 -0600
Received: from DLEE113.ent.ti.com (157.170.170.24) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Sat, 9 Nov
 2019 09:15:45 -0600
Received: from lelv0326.itg.ti.com (10.180.67.84) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Sat, 9 Nov 2019 09:15:45 -0600
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA9FFe6i024185;
        Sat, 9 Nov 2019 09:15:41 -0600
Subject: Re: [PATCH v5 net-next 00/12] net: ethernet: ti: introduce new cpsw
 switchdev based driver
To:     Tony Lindgren <tony@atomide.com>, Sekhar Nori <nsekhar@ti.com>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024160549.GY5610@atomide.com>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <dc621a9d-eb92-5df9-81d7-ad2b037ac3c7@ti.com>
Date:   Sat, 9 Nov 2019 17:15:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191024160549.GY5610@atomide.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tony,

On 24/10/2019 19:05, Tony Lindgren wrote:
> Hi,
> 
> * Grygorii Strashko <grygorii.strashko@ti.com> [191024 10:10]:
>> This the RFC v5 which introduces new CPSW switchdev based driver which is
>> operating in dual-emac mode by default, thus working as 2 individual
>> network interfaces. The Switch mode can be enabled by configuring devlink driver
>> parameter "switch_mode" to 1/true:
>> 	devlink dev param set platform/48484000.ethernet_switch \
>> 	name switch_mode value 1 cmode runtime
> 
> Just wondering about the migration plan.. Is this a replacement
> driver or used in addition to the old driver?
> 

Sry, I've missed you mail.

As it's pretty big change the idea is to keep both drivers at least for sometime.
Step 1: add new driver and enable it on one platform. Do announcement.
Step 2: switch all one-port and dual mac drivers to the new driver
Step 3: switch all other platform to cpsw switchdev and deprecate old driver.

-- 
Best regards,
grygorii
