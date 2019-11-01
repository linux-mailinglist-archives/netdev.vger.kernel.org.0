Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8685EC721
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 17:56:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbfKAQ4T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 12:56:19 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:44474 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726825AbfKAQ4T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 12:56:19 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id xA1Gu6QL070747;
        Fri, 1 Nov 2019 11:56:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1572627366;
        bh=dN8GUr7HzuqoDTbyDZffnsBZFiH3Uv5/NcCnzJnn4Ys=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=Po62kRxFsLrGdYSvI4RmBNzwne4rIXUbYXV5akh3UCsPA6adDLvgiDGJByi5f20E/
         VP6mNqyLsDPyXIi7f9c641qHnKGODjGHXIMX6xwjw9pinRB/ArQWKMhFYHMpZPLy4R
         DMNd2BDtG2pACPe91fcuclnsQ296WnCtZN7RMxWg=
Received: from DLEE115.ent.ti.com (dlee115.ent.ti.com [157.170.170.26])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xA1Gu6bG070066
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Fri, 1 Nov 2019 11:56:06 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Fri, 1 Nov
 2019 11:56:06 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Fri, 1 Nov 2019 11:55:52 -0500
Received: from [10.250.98.116] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xA1Gu2ga024118;
        Fri, 1 Nov 2019 11:56:03 -0500
Subject: Re: [PATCH v5 net-next 04/12] net: ethernet: ti: cpsw: move set of
 common functions in cpsw_priv
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S . Miller" <davem@davemloft.net>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Ivan Vecera <ivecera@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, <devicetree@vger.kernel.org>
References: <20191024100914.16840-1-grygorii.strashko@ti.com>
 <20191024100914.16840-5-grygorii.strashko@ti.com>
 <20191025130109.GB10212@lunn.ch>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <57f4ad69-b865-85c9-3342-e44bdc267ace@ti.com>
Date:   Fri, 1 Nov 2019 18:55:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025130109.GB10212@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/10/2019 16:01, Andrew Lunn wrote:
> On Thu, Oct 24, 2019 at 01:09:06PM +0300, Grygorii Strashko wrote:
>> As a preparatory patch to add support for a switchdev based cpsw driver,
>> move common functions to cpsw-priv.c so that they can be used across both
>> drivers.
> 
> Hi Grygorii
> 
> Bike shedding, but it seems odd to move common code into a private
> file. How common is the current code in cpsw-common.c?

cpsw-common.c is used between cpsw and davinci_emac.c and, as of now, contains
only code to retrieve MAC addr from eFuse regs.
cpsw_priv.x were added intentionally as code moved to these files only used
by ald and new CPSW drivers. This also allows to avoid build/link issues.

-- 
Best regards,
grygorii
