Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1989292086
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 00:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729500AbgJRW61 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 18:58:27 -0400
Received: from mail-eopbgr40080.outbound.protection.outlook.com ([40.107.4.80]:38574
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726681AbgJRW60 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Oct 2020 18:58:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UnScr4CG1GR6ux917CVY20Cpr4qMC1rN0jzKT2lHEQDixhcrikQOzCVHQUMA/gMCZsaWyPkrpgJesW1IPeCKQqEIH4AR/AJJxQPlPbEatYTXXU72KZnAjVHSjYdk/dOecQlzfitdXPUduddkQ4WNX4TBe4rRwwqJoo3rP5RBjYEIfPmkrniwkSBdAybE9FohgjJCuE8qyEPVgtslOK3YKyvCanKbaSv06E26oGiDnQHptMFPjuflbdn1Kz5o5IySC5VK8iBUBRmDp0hkLdKE3FtLPnCMyb3BKP8HkVjigbuA8dJ5vpBlR6OpcxfyGOwb2gaPn3gGYVU5zf4r49SBDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ul4Ax21WeiZ8LuMSI2qUrBDj7iyh9OsqZsoVp34NxLw=;
 b=Sxh4xdqV4IpnuHqYzaGzY9eKhozjNyw+gmJwf8/YfVyLEnSXt7CfTqGYi4t3owVVFnuWkhKbJ4Rnp8JrLkV3OyKplHS2731eB7Xqrv4txkypOpIgGCjsFKZLF5e6na9nCzzjsp3QvMzWgVnL6xefhiuYLlk5kNXJCHst8LUl7ZcMd7CuzYn8ul/hbTjWFpI+LrF9rER/YuqrTVYMmJZ2V0K1wvs7iYK8RY+zvlsUzzMhnip0t9P5ka6/oxix8JJo/JYY5JSYd6MI1UWRGdR/LUzsKMYOeDgYeS+xxjcasf+klA01DYerwhPs20UepOpwARBCjL6pM1SX2acDSp8a+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ul4Ax21WeiZ8LuMSI2qUrBDj7iyh9OsqZsoVp34NxLw=;
 b=pXOfj/xCiiBTI4LMd0JfNKGGzMAII8vNKKC+STj6OkTqw1TRvrQvkqRu/jJ3P/MiqcO6/Ss3ARGG3/IeG3hgrPilGS/qrn1s755rbCbH/2QAR09PlfIPXavfvkA1KqDztAMNuo63xLxJFRSjX95Jbtta+Dg/OGeHAKb6871xaj0=
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0401MB2688.eurprd04.prod.outlook.com (2603:10a6:800:59::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.25; Sun, 18 Oct
 2020 22:58:21 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3477.028; Sun, 18 Oct 2020
 22:58:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Topic: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Thread-Index: AQHWpM2VvXEF3YqeV0mNLAH0H5Z1UKmdQ5MAgAAD4gCAAA7GAIAACvKAgAAG6gCAAJKmAA==
Date:   Sun, 18 Oct 2020 22:58:21 +0000
Message-ID: <20201018225820.b2vhgzyzwk7vy62j@skbuf>
References: <20201017213611.2557565-1-vladimir.oltean@nxp.com>
 <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
 <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
In-Reply-To: <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [188.26.174.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 8aa47dfe-bd26-4a3e-7e83-08d873b94fb1
x-ms-traffictypediagnostic: VI1PR0401MB2688:
x-microsoft-antispam-prvs: <VI1PR0401MB2688146D7E4E8D055F02595CE0010@VI1PR0401MB2688.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EpdrjcpbJ0yLfg5Hy7PVGAawXOByqP55OAZK7ugwR1MzgqM1m0/zY12xWx6crrOxG5Bq1ZOlxPwIEGiWVUlHH3rRRxP6+t5HOkEbKyBsWvO4XTppPFm5cPV0gwqDRYl675I7kGmjZFg+Sgx9w2FyqcWtsHuKq+FD2HU6xe+u9DJCdLs5myiJJfxJPIhSRQmC3G/ymuOgPCadHmtAOADkoKiLIEv199EAqKKmBaa8udeTj0XFaVEgfn91dJmjiFGwU5zrhdCeryHBqIwSmRj+He9D8G2hEFxu0vCD+fOLDJ9A8DZQCD2mquXlDrujicHmLqqQT6FpV/NvHefer7hp1A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(136003)(396003)(366004)(376002)(346002)(39860400002)(9686003)(86362001)(6512007)(6486002)(83380400001)(71200400001)(4744005)(6916009)(2906002)(5660300002)(1076003)(6506007)(186003)(66446008)(66556008)(54906003)(4326008)(33716001)(26005)(44832011)(478600001)(8676002)(316002)(66476007)(8936002)(66946007)(64756008)(76116006)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: yffkAqXYDKBv9mTSvZ1g3feaQNqdPM8xHSrPP7WdWN9xlRADEglEz1vz974nuGFYRXIRAxfQpvM2rI24xZvV2Myw0cyZxn7IR8rYRq5gCTf37SOiCtn68h/LaFS8nt5hTzCtVIgtL7IPvck8PgR1yqlTAUcWhZZj+wWTl/Dpn/7igzKVo5vUMN/d4NnvJbEpEw2yFZrK8qv5ZQ7ckRcxUmdlV679pZcJ8iE4evMi26bCVUOdtqwz7afjlDksxuGnyf+zPkJ//gGHW8tn2AS8D61tH0kwzpb9iPNVSvEV/87G7EIkohi8quxQL2ohdDl7z6LnlFjZ9JjXFnlTI1BQxy4v6tdzvLxSjMvGVXsJdPWrAPWQC0fp156f0wsO+sfg65P+X0gEyy3/2h54ropttd2LhdxWy0L7AOUEpzzi46dbvdL4qkh38NOtKwlHIHxXFwblCe8aeErmpKqjJ4D1FwQntFkhictPh30pDZ3+dVuWn4ZR9yJpbdFqnHtMkqDvEFrEWq+1T8vXWHNLqaBu/8lm0LScdhhIXOl0bMlDFVeUKAtyIJ6DYtYe7DClKjOif+Wa143SNOej9qxXP3JaAnhoGH/hkajCY65XfE0QI7WTEO4olXuBwANQlBhN/ugkTFsmnTWe7e3yjkfEOtNwNA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3764E619B320B1428A216573132820C2@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8aa47dfe-bd26-4a3e-7e83-08d873b94fb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Oct 2020 22:58:21.5112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3FozT+xZeZ91W2Mi0GHfOCjjsoINnHm0F5a5HkWCPY/LT+WR2RIgFN496vAWsQRhmJmWR7Gk1yRIJWmkQKYbjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2688
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 04:13:28PM +0200, Heiner Kallweit wrote:
> On a side note, because I'm also just dealing with it: this_cpu_ptr()
> is safe only if preemption is disabled. Is this the case here? Else
> there's get_cpu_ptr/put_cpu_ptr.

lockdep would shout about using smp_processor_id() in preemptible
context? Because it doesn't do that, and never did, but I don't really
understand why, coming to think of it.

> Also, if irq's aren't disabled there might be a need to use
> u64_stats_update_begin_irqsave() et al. See: 2695578b896a ("net:
> usbnet: fix potential deadlock on 32bit hosts") But I don't know dsa
> good enough to say whether this is applicable here.

DSA xmit and receive path do not run from hardirq context, just softirq,
so I believe the issue reported to Eric there does not apply here.=
