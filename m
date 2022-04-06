Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317E44F608F
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 15:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233624AbiDFNuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 09:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiDFNu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 09:50:29 -0400
Received: from lelv0143.ext.ti.com (lelv0143.ext.ti.com [198.47.23.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E776DB4D9;
        Wed,  6 Apr 2022 04:20:40 -0700 (PDT)
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 236BIgjD021840;
        Wed, 6 Apr 2022 06:18:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1649243922;
        bh=qg6EV2IZc1k/9CqC+u3u9RiNmaa89xg9kphbIADuZ+g=;
        h=Date:Subject:To:CC:References:From:In-Reply-To;
        b=zQJGOIk/wYiqKUt6EV0CQTtSGiDru84V6lTgBPUw569T7+Wm3Jkf1U60kDwMuQA0u
         docahuL6oiEbnx/swKDlQb4dxe55WSRlZcqf89N7AeC17drJ1gGd2qrfRJf0gBxJeu
         QVxuADL/hRKgwqLobCco1iB4P+UqhluPNejUTd88=
Received: from DFLE106.ent.ti.com (dfle106.ent.ti.com [10.64.6.27])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 236BIgWg037134
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 6 Apr 2022 06:18:42 -0500
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE106.ent.ti.com
 (10.64.6.27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Wed, 6
 Apr 2022 06:18:41 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14 via
 Frontend Transport; Wed, 6 Apr 2022 06:18:41 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 236BIcf8012911;
        Wed, 6 Apr 2022 06:18:39 -0500
Message-ID: <f8130c2a-f51d-21fd-d999-886ce9559e9c@ti.com>
Date:   Wed, 6 Apr 2022 14:18:38 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH RFC V1 net-next 3/4] net: Let the active time stamping
 layer be selectable.
Content-Language: en-US
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     Kurt Kanzenbach <kurt@linutronix.de>,
        Michael Walle <michael@walle.cc>, <davem@davemloft.net>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux@armlinux.org.uk>, <mlichvar@redhat.com>,
        <netdev@vger.kernel.org>, <qiangqing.zhang@nxp.com>,
        <vladimir.oltean@nxp.com>
References: <20220104014215.GA20062@hoboy.vegasvil.org>
 <20220404150508.3945833-1-michael@walle.cc> <YksMvHgXZxA+YZci@lunn.ch>
 <e5a6f6193b86388ed7a081939b8745be@walle.cc> <877d83rjjc.fsf@kurt>
 <ad4a8d3efbeaacf241a19bfbca5976f9@walle.cc> <87wng3pyjl.fsf@kurt>
 <defe77d9-1a41-7112-0ef6-a12aa2b725ab@ti.com> <YkxEIZfA0H8yvrzn@lunn.ch>
 <20220405154821.GB6509@hoboy.vegasvil.org>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
In-Reply-To: <20220405154821.GB6509@hoboy.vegasvil.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/04/2022 18:48, Richard Cochran wrote:
> On Tue, Apr 05, 2022 at 03:29:05PM +0200, Andrew Lunn wrote:
> 
>> Maybe. Device tree is supposed to describe the hardware, not how you
>> configure the hardware. Which PTP you using is a configuration choice,
>> so i expect some people will argue it should not be in DT.
> 
> +1
> 
> Pure DT means no configuration choices.
> 
> (but you find many examples that break the rules!)
> 

My point was related to one of issues described by Michael Walle in this thread:
- supporting TS by the PHY may require also additional board support;
- phy_has_hwtstamp() defined statically by PHY drivers without taking into account board design;
- Kconfig option Doesn't really work with generic distro support and not allowed per-port cfg.

So adding smth like "hwtstamp-en" will clear identify that this particular PHY on this particular board
supports time stamping.
(or hwtstamp-full/hwtstamp-rx/hwtstamp-tx).

Of course, it will not help with default or dynamic selection of time stamping layer :(,
but it will be one problem less.

-- 
Best regards,
Grygorii, Ukraine
