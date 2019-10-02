Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBBAC491A
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 10:03:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727452AbfJBICG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 2 Oct 2019 04:02:06 -0400
Received: from smtp.cellavision.se ([84.19.140.14]:36150 "EHLO
        smtp.cellavision.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbfJBICF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 04:02:05 -0400
Received: from DRCELLEX03.cellavision.se (172.16.169.12) by
 DRCELLEX03.cellavision.se (172.16.169.12) with Microsoft SMTP Server (TLS) id
 15.0.1044.25; Wed, 2 Oct 2019 10:02:03 +0200
Received: from DRCELLEX03.cellavision.se ([fe80::982a:ae4b:76e:fa98]) by
 DRCELLEX03.cellavision.se ([fe80::982a:ae4b:76e:fa98%12]) with mapi id
 15.00.1044.021; Wed, 2 Oct 2019 10:02:03 +0200
From:   Hans Andersson <Hans.Andersson@CELLAVISION.SE>
To:     Jose Abreu <Jose.Abreu@synopsys.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: stmmac: Read user ID muliple times if needed.
Thread-Topic: [PATCH] net: stmmac: Read user ID muliple times if needed.
Thread-Index: AQHVePAX5n9iUQBpykuXocq+LEgDYKdG2TOAgAAjX2A=
Date:   Wed, 2 Oct 2019 08:02:02 +0000
Message-ID: <e878e0e4036a4d69b05dcee717fd7ac5@DRCELLEX03.cellavision.se>
References: <20191002070721.9916-1-haan@cellavision.se>
 <BN8PR12MB3266ED591171A79825090BE0D39C0@BN8PR12MB3266.namprd12.prod.outlook.com>
In-Reply-To: <BN8PR12MB3266ED591171A79825090BE0D39C0@BN8PR12MB3266.namprd12.prod.outlook.com>
Accept-Language: en-US, sv-SE
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.230.0.148]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We assert / de-assert the reset line, but the CPU is too fast and the IP is still 
in reset when we later try to read user ID / Synopsys ID. Another option would
be to add a delay after we reset.

-----Original Message-----
From: Jose Abreu <Jose.Abreu@synopsys.com> 
Sent: den 2 oktober 2019 09:52
To: Hans Andersson <Hans.Andersson@CELLAVISION.SE>; mcoquelin.stm32@gmail.com
Cc: peppe.cavallaro@st.com; alexandre.torgue@st.com; davem@davemloft.net; netdev@vger.kernel.org; linux-stm32@st-md-mailman.stormreply.com; linux-arm-kernel@lists.infradead.org; linux-kernel@vger.kernel.org; Hans Andersson <Hans.Andersson@CELLAVISION.SE>
Subject: RE: [PATCH] net: stmmac: Read user ID muliple times if needed.

From: Hans Andersson <haan@cellavision.se>
Date: Oct/02/2019, 08:07:21 (UTC+00:00)

> When we read user ID / Synopsys ID we might still be in reset, so read 
> muliple times if needed.

We shouldn't even try to read it if IP is in reset ... 

---
Thanks,
Jose Miguel Abreu
