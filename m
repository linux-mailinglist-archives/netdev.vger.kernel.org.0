Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B52021AFCF1
	for <lists+netdev@lfdr.de>; Sun, 19 Apr 2020 20:02:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726498AbgDSSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Apr 2020 14:01:47 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:7940 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725793AbgDSSBq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Apr 2020 14:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1587319306; x=1618855306;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=PZCe66rtkt6vuLucf0J+7oucMB4zIT+Ne++JDKdkHQg=;
  b=GjpaINbWXKj6y85umgM03pc416NVXAPzahEfShYZ9Jjt07QSz71CQNJQ
   TIe4/cYcwFVOt/1FrEUlpFdOhRAcvbSyd1agoC0FxCQzESwyijjHG5+jf
   sBnsJmpFdSmfUKxb2zKpR3/loBz/3zgAiDZi/hLmF9gniCn42FQCkyZOA
   wgLRFZP3u7XakVJzEEA22mRaR42jXztwn02Orr/lm0sR6COlxZbDg5KmY
   sZJhlAmCro3iCmoyMQ/MIIpcBDGnS/7CW0KSfvDtWxwSXJ5ERdFW9CIeD
   SkZjWuGrPPGWmOqlp9T8evf2R/cs1wn9aCdcyKKOCUo12GTYVNGVzALuY
   g==;
IronPort-SDR: ndD5hgwaFYlzoS1114exR2HsETDw0vHMdt9IGjRBoJ/m/RsJCc++T1C1b8udexQhVvPOj/2ye/
 zQ1iwYW3k4Kg4CSZLF9XLMPz9TPemaFzkXTHm/IagZ3tdQyauUmZt6+YR8Z08P3Vw66pGjUxhf
 E0Oe518L13zUX3O4HmPWlX2nRVWAXq1B9Ml7+T0lYvLmkRmEXtAG+e4rQPJVxaHszwuud0fxqA
 8C5+mgGFlIVJ5bm3AYb89OJkBKm+yMKkRZ5t0ZZqlYg3umzK8B8cqfVTDZrlcaU9EJJhwZ1N8H
 Yjc=
X-IronPort-AV: E=Sophos;i="5.72,403,1580799600"; 
   d="scan'208";a="70826916"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2020 11:01:45 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sun, 19 Apr 2020 11:01:51 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1713.5 via Frontend
 Transport; Sun, 19 Apr 2020 11:01:44 -0700
Date:   Sun, 19 Apr 2020 20:01:43 +0200
From:   "Allan W. Nielsen" <allan.nielsen@microchip.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     Vladimir Oltean <olteanv@gmail.com>, <davem@davemloft.net>,
        <horatiu.vultur@microchip.com>, <alexandre.belloni@bootlin.com>,
        <antoine.tenart@bootlin.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <vivien.didelot@gmail.com>,
        <joergen.andreasen@microchip.com>, <claudiu.manoil@nxp.com>,
        <netdev@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <alexandru.marginean@nxp.com>, <xiaoliang.yang_1@nxp.com>,
        <yangbo.lu@nxp.com>, <po.liu@nxp.com>, <jiri@mellanox.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: mscc: ocelot: deal with problematic
 MAC_ETYPE VCAP IS2 rules
Message-ID: <20200419180143.ibexwjrlp3flla6z@ws.localdomain>
References: <20200417190308.32598-1-olteanv@gmail.com>
 <20200419073307.uhm3w2jhsczpchvi@ws.localdomain>
 <20200419083032.GA3479405@splinter>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Disposition: inline
In-Reply-To: <20200419083032.GA3479405@splinter>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.04.2020 11:30, Ido Schimmel wrote:
>Not sure I completely understand the difficulties you are facing, but it
>sounds similar to a problem we had in mlxsw. You might want to look into
>"chain templates" [1] in order to restrict the keys that can be used
>simultaneously.
Not sure I understood the details, but but sure it is the same issue we
are trying to solve.

>I don't mind participating in an online discussion if you think it can
>help.
I'm sure it would be helpfull to have someone with insight in the MLX
driver. I have been looking a lot at it, and there are large part of it
which I still have not understood.

If you get too borrowed you can always leave ;-)

/Allan
