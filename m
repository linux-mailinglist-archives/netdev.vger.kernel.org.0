Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8974F108AD2
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 10:27:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbfKYJ11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 04:27:27 -0500
Received: from mail-eopbgr10052.outbound.protection.outlook.com ([40.107.1.52]:54758
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726498AbfKYJ11 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Nov 2019 04:27:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oXu3bEGZG8uTg4kuo/exMeNvUCpyosarZvqLoOhRV5cdUEqlwMTgPM2EJOnQmyZYjpKpGlHiqBcKWKqLSZ4O9PezyMjeQIUPvh1BkmW9CgUFfvTDtlgDxbQKI9fcXPbPa7cXbjbIiCoMl5+5XqLAZAkRZBR0OWDFfdFwfbd1haw2JQdNwRztqAOaFqOLGFVcXz5grDrQLEpZLThpvTZIWDo+0ONxfmdKF+Efl47bdvocTpZ8BwHrsNzc/NUkMrwZPjAY1y9BtysPEoj1dUq2sExcnw2Oxv4gQBTQ+B2Sa7pqqegaDVuuDPP8cSIzzU1N7GV2VEsb9Ucj+EKiFKwctg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ca0I43/2QYly6Wl7t2jDGUJ8JGoOf48gF/DTosH+SvY=;
 b=MXZlp8SQJlBNJqihVQ9G10I7UQpOii9gkS3pvAtuFVbHm5CtfuKMH5pLk3R1drMWs5g6kteYEZMYpsrvQpN7WBut15RRX+VqK8aBl3ENyHyvo0d8y8u6RKLMK9tPTS47YLtgSErMmx66ISXnLiBa44ixT/ZpsWQI2GjTN592cL5x1rLt8juWWMTpwbbCVULDCZwYrh1s3QagcBkL/k19M13iinMVi0Q1mYF2EG0/aaFi070BhJCF5RewENpTzLlKb9ZUBSWuYZg0AF49ze7GcOrQRjeSJ/yCBQwds8rOIRPn1saSSsxyKc0hZBi6mfoAKCk3Nj+QUucwFfOHMtSYgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ca0I43/2QYly6Wl7t2jDGUJ8JGoOf48gF/DTosH+SvY=;
 b=F83ym2x4yUpUY2kxZPC1iRuAG/9UoSOs9LQZKJdeD/p7PoYum5x2FAxplRlQovGJwFUnNHQ0oCNTTHWI5/lJNYzNdKSqLB8OlUN/G+wnOsjsRg6ULLbi+RODYzNrfIkgkZOA9F06PQTRRIDqosGf7AeQ4iPm7che4pAJ4j2EEaM=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB5964.eurprd04.prod.outlook.com (20.178.104.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.21; Mon, 25 Nov 2019 09:27:22 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7915:7cc9:fee9:b180]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7915:7cc9:fee9:b180%4]) with mapi id 15.20.2474.023; Mon, 25 Nov 2019
 09:27:22 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Required guidance to debug ipsec memory leak
Thread-Topic: Required guidance to debug ipsec memory leak
Thread-Index: AdWd2QXmH/AhltijRLm1Z0DPO4/iVQABxjGAAWSIBGA=
Date:   Mon, 25 Nov 2019 09:27:22 +0000
Message-ID: <DB7PR04MB462082BD6A5587F6E4FB66DF8B4A0@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620A7723FAC95C7767573208B4D0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20191118071638.GQ14361@gauss3.secunet.de>
In-Reply-To: <20191118071638.GQ14361@gauss3.secunet.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.120.1.68]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6cbae30e-b54b-40ed-ca5c-08d77189ad4f
x-ms-traffictypediagnostic: DB7PR04MB5964:
x-microsoft-antispam-prvs: <DB7PR04MB5964FF3190663EA0DF822A5C8B4A0@DB7PR04MB5964.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0232B30BBC
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(39860400002)(366004)(136003)(51914003)(13464003)(189003)(199004)(76116006)(5660300002)(6506007)(53546011)(71200400001)(71190400001)(44832011)(478600001)(14454004)(26005)(102836004)(25786009)(316002)(76176011)(52536014)(7696005)(3846002)(6116002)(99286004)(6246003)(256004)(4744005)(4326008)(229853002)(33656002)(86362001)(9686003)(81156014)(81166006)(55016002)(66066001)(186003)(305945005)(7736002)(74316002)(8936002)(6916009)(6436002)(66946007)(8676002)(2906002)(66556008)(446003)(11346002)(66476007)(64756008)(66446008);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB5964;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p0PJ/48TvjsojIGV93/fZaFzMhF5vi75hHVHAL98VxT5LgM7QEOTWOBxShs43YBhToDE7SWUJOakfUEBMAaqmDOJIphLpD+IYdbJNYgOwLU9PNplmuHRfYQwrsX1KzFKpImpyotU9suP5JiWhFQlclbPWDb9HIBhwZUjhp8XWoKfkDu/WhiiVXYa5lzbJyJAzypjQn6sfdozzUPU2nfrKy4JxiWwvefV5zfpSEnspZbpyQt01zPKkYx0G1uEStU1Dt0ZfKFz9JGqWArtelgQG5yIp8cP5bgVPSeBkzfuCNbOaTeYBLR0oU9DVEIicbfvzbXgM5fvvpryEp+BbOpXsRR8WWggM9dTkhA1WPuUpSFWIYwyPyZYA/fk3eiJSc0PCNDQgizWZ6tu0N0W5HLEaPML1MSapglJ89X8JlKNPK7ug1leEklGzQRUzYr7K+op
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6cbae30e-b54b-40ed-ca5c-08d77189ad4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2019 09:27:22.7580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +zTDiBrN/yQGzScEdQOaHCqTZDP3PkyismbYdPUkmShsT6WQLXftNXFwQV1+oL9ufCzcv4Q2T8u2Rwxq/LbT1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5964
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org>
> On Behalf Of Steffen Klassert
> Sent: Monday, November 18, 2019 12:47 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: netdev@vger.kernel.org
> Subject: Re: Required guidance to debug ipsec memory leak
>=20
> On Mon, Nov 18, 2019 at 06:35:24AM +0000, Vakul Garg wrote:
> > Hi
> >
> > I need help to debug a suspected memory leak problem while running
> kernel ipsec with rekeying enabled.
>=20
> Did you try with the current net tree? There is a fix for such a leak:
>=20
> commit 86c6739eda7d ("xfrm: Fix memleak on xfrm state destroy")

Sorry for a late response. Thanks for the help.=20
The given patch has helped in reducing the rate at which memory is leaking.

But we are still losing memory at rate of about 30-40MB per hour.

Any pointers in debugging would greatly help.
