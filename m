Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEEC108E72
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 14:07:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfKYNHK convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 25 Nov 2019 08:07:10 -0500
Received: from mail-oln040092254094.outbound.protection.outlook.com ([40.92.254.94]:21612
        "EHLO APC01-PU1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725823AbfKYNHK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 08:07:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PgAXBNhc/dr9IaXB3oiE7UsJeiQeCQ6Vhx9llbIbKroamkAp+dY40+MKiwylRTGiJ3z9HAfDEf/stDIOKglp+NsZ0wVC1TMqWIX7/noMXWkdg6yCiS9n7tgy92X0hdHWUO2BIq3STkumZk1dnRoaoFt+H2ZVuaCS9eF+kKsqYD5d89tcocTdDNv46vbPjSnRgw4BfGhL5n8MnBCr60Q4v1fribRFIh42LU+SYk3VGB39NsG+m+hdpN88deovSd9ZqDKkGyABRCAsslptGonZtT1cXgte4t3G54hBio8w7VlvCryVUMmixqLVSyWSohD24FyPCyYMBp4C2M5mDRQWVA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ussIT6WMhlCX3m2iUJPrui4UIHnA30pYfJ7pNOLiO7c=;
 b=YMzJrrh0hoCSmwovFexobgC1i8pBhUATkGjec9tkJmqZKDePXwoIRDsksv9ne40VnqWsLoCWUvTvZ/BFdjn88g1p0wSrcFzgXb17VolR0XX4pVpN8Y+RDBVWpjVavWm4KBzD+/y2vN4uFUyJj9+XlyptlMLK2rgmqHVpDpYlB67eAA4AlbPLZ9tmOeeKma6WcY1RNaN48lZsz4qKFf23y9xcCAHgA1VzkYYK7ZKSECjquDzZD1ryB7j99dt9HYE4D7EabtZaTqZAsvvWpncxU5CHMGHQ55lGWeqoI7Cbh1mafZ1rwHdDa5tRXvzifPBvnjtIk8SzYKiRBXlrOXJXSg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from HK2APC01FT032.eop-APC01.prod.protection.outlook.com
 (10.152.248.59) by HK2APC01HT181.eop-APC01.prod.protection.outlook.com
 (10.152.249.163) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2474.17; Mon, 25 Nov
 2019 13:07:01 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM (10.152.248.56) by
 HK2APC01FT032.mail.protection.outlook.com (10.152.248.188) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17 via Frontend Transport; Mon, 25 Nov 2019 13:07:01 +0000
Received: from PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d]) by PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 ([fe80::b880:961e:dd88:8b5d%12]) with mapi id 15.20.2474.023; Mon, 25 Nov
 2019 13:07:01 +0000
From:   Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     Johannes Berg <johannes@sipsolutions.net>,
        Alexander Lobakin <alobakin@dlink.ru>,
        Edward Cree <ecree@solarflare.com>,
        David Miller <davem@davemloft.net>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "petrm@mellanox.com" <petrm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "jaswinder.singh@linaro.org" <jaswinder.singh@linaro.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "emmanuel.grumbach@intel.com" <emmanuel.grumbach@intel.com>,
        "luciano.coelho@intel.com" <luciano.coelho@intel.com>,
        "linuxwifi@intel.com" <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL in
 napi_gro_receive()
Thread-Topic: [PATCH v2 net-next] net: core: use listified Rx for GRO_NORMAL
 in napi_gro_receive()
Thread-Index: AQHVo2IFW7miydWzwUGig6GEl/Vj46ebhG8AgAAIsACAAAw6AIAAFs0AgAAHqgCAAAH+vIAAClQAgAAXfQA=
Date:   Mon, 25 Nov 2019 13:07:01 +0000
Message-ID: <PSXP216MB04382C21FF000C9A516324D4804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
References: <20191015.181649.949805234862708186.davem@davemloft.net>
 <7e68da00d7c129a8ce290229743beb3d@dlink.ru>
 <PSXP216MB04388962C411CD0B17A86F47804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <c762f5eee08a8f2d0d6cb927d7fa3848@dlink.ru>
 <746f768684f266e5a5db1faf8314cd77@dlink.ru>
 <PSXP216MB0438267E8191486435445DA6804A0@PSXP216MB0438.KORP216.PROD.OUTLOOK.COM>
 <cc08834c-ccb3-263a-2967-f72a9d72535a@solarflare.com>
 <3147bff57d58fce651fe2d3ca53983be@dlink.ru>
 <414288fcac2ba4fcee48a63bdbf28f7b9a5037c6.camel@sipsolutions.net>
 <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
In-Reply-To: <b4b92c4d066007d9cb77e1645e667715c17834fb.camel@redhat.com>
Accept-Language: en-AU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SY2PR01CA0046.ausprd01.prod.outlook.com
 (2603:10c6:1:15::34) To PSXP216MB0438.KORP216.PROD.OUTLOOK.COM
 (2603:1096:300:d::20)
x-incomingtopheadermarker: OriginalChecksum:E7F442EC7319ADFC37A5714FE8A944776DCFE236F325233D06C5FC731D2A1CED;UpperCasedChecksum:812488E1055A9E8D70C60692D43AE09A8E1C06FA9DC7E6FD848F32B4E4A13AAB;SizeAsReceived:8964;Count:49
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [Gv9cvn6EIHH4e+XHnq34GNzcdmw3KM8NXs6fHRJW+MHN8raa/XXXjtovXqTqEIVhtk4F98Is5iQ=]
x-microsoft-original-message-id: <20191125130643.GA2616@nicholas-usb>
x-ms-publictraffictype: Email
x-incomingheadercount: 49
x-eopattributedmessage: 0
x-ms-office365-filtering-correlation-id: 9ad09a14-937e-45bf-ea2f-08d771a85c14
x-ms-traffictypediagnostic: HK2APC01HT181:
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zwpRn3lD7F/tKlvVKelXCbwPpdqtDmtucoyT1EwLluxregYFEHjajBlqk98e2YDECgqz9CqobQXG3IFt6AVciz5ng9LiL3xw9zlvjoJfMqeBhpahiHcI4x+sIpJUm0l7uTMa4RKFNtl9cM4UFaGmNehjVklypN+8T/k/u9pb9AlMfazTo7ejHXv35ROXRYdA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1AB422FB0C9ED94F8B792DCE12FE05D1@KORP216.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ad09a14-937e-45bf-ea2f-08d771a85c14
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 13:07:01.3521
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Internet
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK2APC01HT181
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 25, 2019 at 12:42:44PM +0100, Paolo Abeni wrote:
> I think it would be nice moving the iwlwifi driver to full/plain NAPI
> mode. The interrupt handler could keep processing extra work as it does
> now and queue real pkts on some internal queue, and than schedule the
> relevant napi, which in turn could process such queue in the napi poll
> method. Likely I missed tons of details and/or oversimplified it...

It must have something to do with iwlwifi (as if we needed more 
evidence). I just booted a different variant of the Dell XPS 9370 which 
has Qualcomm Wi-Fi [168c:003e] (ath10k_pci.ko), instead of Intel Wi-Fi, 
from the same USB SSD as before, and it has no issues whatsoever.

My regression report quickly blown up to be way over my head in terms of 
understanding, but I will keep monitoring the discussions and try to 
learn from it. Everybody, please keep me CC'd into any further 
communications with driver teams, as I am genuinely interested in the 
journey and the outcome.

> Cheers,
> 
> Paolo
> 
> 
Cheers,
Nicholas
