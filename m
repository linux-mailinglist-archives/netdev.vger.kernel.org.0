Return-Path: <netdev+bounces-12068-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EC41C735DFC
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 21:50:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 248E7280F4B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 19:50:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6222E14A86;
	Mon, 19 Jun 2023 19:50:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5672E14298
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 19:50:19 +0000 (UTC)
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F8E711B;
	Mon, 19 Jun 2023 12:50:10 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
	by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 35JJnfgk030920;
	Mon, 19 Jun 2023 14:49:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
	s=ti-com-17Q1; t=1687204181;
	bh=PoKOvK7usjm1ob7WNxMkDZSniex+haYHBcVoexZNQpY=;
	h=Date:Subject:To:CC:References:From:In-Reply-To;
	b=gkVuW8nroY/jLzBkPeso8rv0zNpCv2WKc0KePPKsMJc0nOqosns8qhV3s3tINiQWp
	 1Nf85Abw/kxC3pWvbqeedeLXbgGBN6pHKNADNRjQ7nkk/YS4FHTwkcfBoPCIzEcFIs
	 F4MW/K3klMmOJxz+V9v5HlbVcLzT7wa2Eq1HR8lY=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
	by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 35JJnfLo053840
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Jun 2023 14:49:41 -0500
Received: from DFLE101.ent.ti.com (10.64.6.22) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23; Mon, 19
 Jun 2023 14:49:40 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE101.ent.ti.com
 (10.64.6.22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2507.23 via
 Frontend Transport; Mon, 19 Jun 2023 14:49:40 -0500
Received: from [10.247.25.76] (ileaxei01-snat2.itg.ti.com [10.180.69.6])
	by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 35JJne4A031011;
	Mon, 19 Jun 2023 14:49:40 -0500
Message-ID: <1fd76d67-0839-1b82-5b6a-d3fc75a240f8@ti.com>
Date: Mon, 19 Jun 2023 14:49:40 -0500
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH net v1] Revert "net: phy: dp83867: perform soft reset and
 retain established link"
Content-Language: en-US
To: Andrew Lunn <andrew@lunn.ch>, Francesco Dolcini <francesco@dolcini.it>,
        Siddharth Vadapalli <s-vadapalli@ti.com>
CC: Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King
	<linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni
	<pabeni@redhat.com>, <linux-kernel@vger.kernel.org>,
        Francesco Dolcini
	<francesco.dolcini@toradex.com>,
        Geet Modi <geet.modi@ti.com>, <netdev@vger.kernel.org>
References: <20230619154435.355485-1-francesco@dolcini.it>
 <5563611e-5354-42fc-b33f-b1b4945e71de@lunn.ch>
From: "Bajjuri, Praneeth" <praneeth@ti.com>
In-Reply-To: <5563611e-5354-42fc-b33f-b1b4945e71de@lunn.ch>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 6/19/2023 11:30 AM, Andrew Lunn wrote:
> On Mon, Jun 19, 2023 at 05:44:35PM +0200, Francesco Dolcini wrote:
>> From: Francesco Dolcini <francesco.dolcini@toradex.com>
>>
>> This reverts commit da9ef50f545f86ffe6ff786174d26500c4db737a.
>>
>> This fixes a regression in which the link would come up, but no
>> communication was possible.
>>
>> The reverted commit was also removing a comment about
>> DP83867_PHYCR_FORCE_LINK_GOOD, this is not added back in this commits
>> since it seems that this is unrelated to the original code change.
>>
>> Cc: Praneeth Bajjuri <praneeth@ti.com>
>> Closes: https://lore.kernel.org/all/ZGuDJos8D7N0J6Z2@francesco-nb.int.toradex.com/
>> Fixes: da9ef50f545f ("net: phy: dp83867: perform soft reset and retain established link")
>> Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> 
> There has been plenty of time given for somebody to investigate this
> regression, and nothing has happened. So i agree, lets revert it.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Agreed to revert.

Reviewed-by: Praneeth Bajjuri <praneeth@ti.com>


> 
>      Andrew

