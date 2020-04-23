Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 701031B5DC8
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 16:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728013AbgDWO3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 10:29:36 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:59234 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWO3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 10:29:36 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 03NETSot078418;
        Thu, 23 Apr 2020 09:29:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1587652168;
        bh=wBBGLm/GU/IWOc28k0N2zTqFLwnTT77BHKEVRmH7rpE=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=DsQ1WXaV6Zy/vKf7bEWUOT4pa1hMMKm7faDpkefg40mq0UGDL47aMaB6ibu1B1s2s
         2U23jQohIFFs6FN2fXpf6mz8N2KR5k5AqFdYcdO04IvBEzAQ66s8Cd+4KJ3Bc+ZbUV
         wExBr+lr67BwPqsO7kzYvnlwfSVU/UVXetoqeecc=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 03NETS0x053944
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 23 Apr 2020 09:29:28 -0500
Received: from DFLE108.ent.ti.com (10.64.6.29) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 23
 Apr 2020 09:29:28 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 23 Apr 2020 09:29:28 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 03NETP4k112639;
        Thu, 23 Apr 2020 09:29:26 -0500
Subject: Re: [PATCH net-next v4 00/10] net: ethernet: ti: cpts: add irq and
 HW_TS_PUSH events
To:     David Miller <davem@davemloft.net>
CC:     <richardcochran@gmail.com>, <lokeshvutla@ti.com>,
        <tony@atomide.com>, <netdev@vger.kernel.org>, <nsekhar@ti.com>,
        <linux-kernel@vger.kernel.org>, <m-karicheri2@ti.com>,
        <linux-omap@vger.kernel.org>
References: <20200422201254.15232-1-grygorii.strashko@ti.com>
 <20200422.195705.2021017077827664261.davem@davemloft.net>
 <20200422.195947.725312745030873910.davem@davemloft.net>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <8f7954ce-566a-1968-9800-bd0ee75959c0@ti.com>
Date:   Thu, 23 Apr 2020 17:29:21 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422.195947.725312745030873910.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 23/04/2020 05:59, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Wed, 22 Apr 2020 19:57:05 -0700 (PDT)
> 
>> From: Grygorii Strashko <grygorii.strashko@ti.com>
>> Date: Wed, 22 Apr 2020 23:12:44 +0300
>>
>>> This is re-spin of patches to add CPSW IRQ and HW_TS_PUSH events support I've
>>> sent long time ago [1]. In this series, I've tried to restructure and split changes,
>>> and also add few additional optimizations comparing to initial RFC submission [1].
>>   ...
>>
>> Series applied, thanks.
> 
> Actually I had to revert, this breaks the build:
> 
> [davem@localhost net-next]$ make -s -j14
> ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw_new.ko] undefined!
> ERROR: modpost: "cpts_misc_interrupt" [drivers/net/ethernet/ti/ti_cpsw.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:94: __modpost] Error 1
> make: *** [Makefile:1319: modules] Error 2
> 

Fixed and resent.

-- 
Best regards,
grygorii
