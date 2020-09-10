Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 083D5264CBE
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725803AbgIJSWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:22:42 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:38734 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgIJSV5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:21:57 -0400
Received: from fllv0034.itg.ti.com ([10.64.40.246])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 08AILigX125786;
        Thu, 10 Sep 2020 13:21:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1599762104;
        bh=11GKWFJbgoEwg1d2kcqLWyqiPTh+7X6kqteZc6SwQ4w=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=aCEU0dysBTDbi+CxFop2c316bT1UMJrS3GI1M+x9u7cK3p/ChvKqH9CNBdz6KfyC0
         ECkoE2OnaCJtKhMvxoMdrbDumY6nKvhgJp6w2maB4LF+/ZiDu84DzX1x93gn4Sd0VF
         ld7200zXRD/G3VXBWIFjmTWbiS6oyr9shz2JXBlQ=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0034.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 08AILiQD127001
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 10 Sep 2020 13:21:44 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Thu, 10
 Sep 2020 13:21:43 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Thu, 10 Sep 2020 13:21:43 -0500
Received: from [10.250.38.37] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 08AILhLN051137;
        Thu, 10 Sep 2020 13:21:43 -0500
Subject: Re: [PATCH net-next v3 2/3] net: phy: dp83869: support Wake on LAN
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>,
        <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200903114259.14013-1-dmurphy@ti.com>
 <20200903114259.14013-3-dmurphy@ti.com>
 <20200905113428.5bd7dc95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <5051f1e2-4f8e-a021-df6c-d4066938422f@ti.com>
 <20200910180257.GD3354160@lunn.ch>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <acb8368f-2ead-cf3e-c099-18aeeab2b3f3@ti.com>
Date:   Thu, 10 Sep 2020 13:21:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200910180257.GD3354160@lunn.ch>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew

On 9/10/20 1:02 PM, Andrew Lunn wrote:
>>>>    static int dp83869_config_port_mirroring(struct phy_device *phydev)
>>>>    {
>>>>    	struct dp83869_private *dp83869 = phydev->priv;
>>> Overall this code looks quite similar to dp83867, is there no way to
>>> factor this out?
>> Factor what out?  Yes the DP83867 and DP83869 are very similar in registers
>> and bitmaps.  They just differ in their feature sets.
>>
>> The WoL code was copied and pasted to the 869 and I would like to keep the
>> two files as similar as I can as it will be easier to fix and find bugs.
> It will be even easier if they shared the same code. You could create
> a library of functions, like bcm-phy-lib.c.

If I do that I would want to add in the DP83822 and the DP83811 as well 
even though the SOP and Data registers are different the code is the same.

I can just pass in the register numbers in.

That will have to be something I refactor later as it will rip up at 
least 4 TI drivers if not more.

Dan

