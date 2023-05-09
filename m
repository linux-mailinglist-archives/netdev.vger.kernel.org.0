Return-Path: <netdev+bounces-1032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CEC96FBE4D
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 06:42:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 870A028121F
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 04:42:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 942DB391;
	Tue,  9 May 2023 04:42:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84BB4191
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 04:42:45 +0000 (UTC)
Received: from fllv0015.ext.ti.com (fllv0015.ext.ti.com [198.47.19.141])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3527F558D;
	Mon,  8 May 2023 21:42:43 -0700 (PDT)
Received: from lelv0266.itg.ti.com ([10.180.67.225])
	by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id 3494gL1a003157;
	Mon, 8 May 2023 23:42:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1683607341;
	bh=YfCKA31Ps0JPQEAdzY7jNg99L/MnSENSiIkKGZQoxH4=;
	h=Date:CC:Subject:To:References:From:In-Reply-To;
	b=ai0Lbc0FvlrraMrpmyWsQcMn5JBtqQNtqobJdrfFiNUaG7IeKj11aytepSqsp8IoZ
	 22SXJKUZbWKJX8LOsEdBqBwqX5Z7oBVdX7xJLenIXAb86/edtBE48J4SB/HNQ+DgvC
	 CSbKsloPCdLKcnoXFvGW9h9Hhwm7c+kyfm1Tur3U=
Received: from DFLE108.ent.ti.com (dfle108.ent.ti.com [10.64.6.29])
	by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 3494gLQ2057151
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 8 May 2023 23:42:21 -0500
Received: from DFLE111.ent.ti.com (10.64.6.32) by DFLE108.ent.ti.com
 (10.64.6.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 8
 May 2023 23:42:21 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE111.ent.ti.com
 (10.64.6.32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 8 May 2023 23:42:20 -0500
Received: from [172.24.145.61] (ileaxei01-snat.itg.ti.com [10.180.69.5])
	by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 3494gHfH097353;
	Mon, 8 May 2023 23:42:17 -0500
Message-ID: <007ca679-2ba7-635f-942f-deee52e70117@ti.com>
Date: Tue, 9 May 2023 10:12:16 +0530
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
CC: <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <srk@ti.com>,
        <s-vadapalli@ti.com>
Subject: Re: [PATCH net] net: phy: dp83867: add w/a for packet errors seen
 with short cables
To: Jakub Kicinski <kuba@kernel.org>
References: <20230508070019.356548-1-s-vadapalli@ti.com>
 <20230508190035.24b5710e@kernel.org>
Content-Language: en-US
From: Siddharth Vadapalli <s-vadapalli@ti.com>
In-Reply-To: <20230508190035.24b5710e@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-6.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 09/05/23 07:30, Jakub Kicinski wrote:
> Thanks for the patch! Some nit picks below..
> 
> On Mon, 8 May 2023 12:30:19 +0530 Siddharth Vadapalli wrote:
>> +	err = phy_write_mmd(phydev, DP83867_DEVADDR, DP83867_DSP_FFE_CFG, 0X0E81);
> 
> Pleas wrap this line at 80 characters, there's no reason for it 
> to be this long.
> 
> And 0x prefix should not be in upper case, here and in the new define
> you're adding.

Thank you for pointing out the issues. I will fix them and post the v2 patch.

-- 
Regards,
Siddharth.

