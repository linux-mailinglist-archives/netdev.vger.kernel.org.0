Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22D4C990A9
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 12:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387550AbfHVKXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 06:23:34 -0400
Received: from mail-eopbgr140074.outbound.protection.outlook.com ([40.107.14.74]:15591
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387545AbfHVKXe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 06:23:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WReWOsaGe318142necCcAzMWEljDwXvdMzEb1qOzcvRP2HL1SH2loZwCvgRIJNDFHMBo74XDRmt65A1kPQUcuEkyEt7Y+YEes8Ij1rFVW+W8ZYmVY1GbSdMyhbH8lufeyyEdgwHGGJGI/YCXHw4BmTYv2//nnB9bqlCvxMh1cKpccIaXd0u7aswzJUyjf4RpKQ48XzfEJzWZtxgJvDth36r8Mv6z+mwkWg9VKnXWXdKdksNlk5SQlg+LSX9hm2jKx8lGaQ0PY68g8+r3UB4sBiTonlACdSyM9LUeu5Uz+wJlzwIX+oX1U+0RA2d/yXAZiRutbglqin1gJteYOU33Sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNI1qADJozxt90Ayx41nYkvh6YT7FJ/8xU0iiwaqZ/A=;
 b=nQn3c50qB4rrLOcgsFOjHP3gYAXAtjBW+sJQLv/RrVroJbupC+VtWUaGYugd6IX3XVth4Q6QEmMwPzfqGvaNkEyp7xb2fD8x2hQI533HS9OE8y9qqMh5UCZ431Ycn3zPkfPuT2bnfuANnfQBTYUgVdcdH20jPwyFnauOYA7Y7TQ3kFKj8RpWFrOtRPFWiy3o5u+8rEdb7aM2OgawwjpolN2/Rin0OKXO6SKWEbfuIbbpDdYdJ0rxRpoyumwVkGsbDAOMnH2E7G8qY7O7fdrnF8Ah84jCXV30EZKhjGF9jGkCOTTCmE2DgrVPZRKm7v/ewuyFQpxFyXLpPFkgcOHdnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tNI1qADJozxt90Ayx41nYkvh6YT7FJ/8xU0iiwaqZ/A=;
 b=i7miCDCDRq6FOCbaRHBsNweqh7Nmw7kTtK6PeIdXniGj5CEEos2nCB/ZUazqkY9LZ3muCY4xlyrw0PFq+4Wu90TiyHqb9Cf/SJIT3NhGwd5zDzczj0n9ik8s4O8ysFj0UfBprqg7hkN1sajKkYnadX5yWPS8/3gfV92QgfbZd/s=
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com (52.135.140.28) by
 DB7PR04MB4044.eurprd04.prod.outlook.com (52.134.109.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 10:23:31 +0000
Received: from DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250]) by DB7PR04MB4620.eurprd04.prod.outlook.com
 ([fe80::7c8a:c0c2:97d1:4250%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 10:23:31 +0000
From:   Vakul Garg <vakul.garg@nxp.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: Help needed - Kernel lockup while running ipsec
Thread-Topic: Help needed - Kernel lockup while running ipsec
Thread-Index: AdVWjKmxsxThBk5DR52nDhmLe9COdgAKDSMAACB27LAAAIj+gAAABzZQAAB+dAAAAHQ0QAABmv2AACvZoLAAEiRGgAAmFRmg
Date:   Thu, 22 Aug 2019 10:23:31 +0000
Message-ID: <DB7PR04MB46208495C3ADCCD58B1131C88BA50@DB7PR04MB4620.eurprd04.prod.outlook.com>
References: <DB7PR04MB4620CD9AFFAFF8678F803DCE8BA80@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190819173810.GK2588@breakpoint.cc>
 <DB7PR04MB4620C6E770C97AB14A04A1D98BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820092303.GM2588@breakpoint.cc>
 <DB7PR04MB4620487074796FBC015AFD098BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190820093800.GN2588@breakpoint.cc>
 <DB7PR04MB46204E237BB1E495FC799E588BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <DB7PR04MB4620B6ACB01BFA338ADAED048BAB0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <DB7PR04MB46204E4A3EBD5DD665F492D38BAA0@DB7PR04MB4620.eurprd04.prod.outlook.com>
 <20190821161159.GA20113@breakpoint.cc>
In-Reply-To: <20190821161159.GA20113@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vakul.garg@nxp.com; 
x-originating-ip: [92.120.0.2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d0f7a04-10b6-4b66-b6ba-08d726eac826
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB7PR04MB4044;
x-ms-traffictypediagnostic: DB7PR04MB4044:
x-microsoft-antispam-prvs: <DB7PR04MB4044EE5C5ACBA3573339DA578BA50@DB7PR04MB4044.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(376002)(366004)(136003)(39860400002)(396003)(346002)(189003)(199004)(13464003)(40764003)(6246003)(74316002)(4326008)(81156014)(81166006)(66066001)(55016002)(8936002)(25786009)(8676002)(7736002)(2906002)(14454004)(6436002)(52536014)(53936002)(478600001)(5660300002)(6916009)(3846002)(305945005)(6116002)(86362001)(71200400001)(186003)(486006)(26005)(6506007)(53546011)(476003)(7696005)(11346002)(76176011)(33656002)(256004)(446003)(99286004)(5024004)(9686003)(102836004)(76116006)(71190400001)(66476007)(66946007)(44832011)(316002)(229853002)(66446008)(64756008)(66556008)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB7PR04MB4044;H:DB7PR04MB4620.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: H4tGsAiz5jOYI3sVCDDV6S+rnUQN2mU7Qbc2OO7ndhdQAP4SXPIocJ4Nd52oOffGswZAlOI1zlpdesDOrnirDh9v87bvzC/ya/iUMYbr+oxN+YiR3g8XFISMoxz3CSPVOHcU78BitKTFRLQy+fomoGCacsptk3IO0L2wiTrPDbkcMzIoXkDig6mIHy26G2BFnFkZUUMWOQPlBk99MDOJclDc9etUg3Xiq73s6asU4kiNYaIoDn8FGonnH7hi0tgY12BBXTFN72paUkC3cL6s/Sl+l8xnUcEiPhQ43dkfx/1lkIJVQ55eVxLN+ay56frkyzmuAy8FN/8n+C9KPjrwgabNcCCquM7cHrVBJJoUBEv9/1piyL2/nKyp3FQBjNIe+JTiATYFjcLKLdZzCjDahislBzCtdOxpu6DGpDTjA7w=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d0f7a04-10b6-4b66-b6ba-08d726eac826
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 10:23:31.7328
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SVH5jebuZhhw8D0nPJi/2kNIVbMv3bWErwl+nU20LVWF6ZIENza0Jr3Y+l5bckr2iCTXEm7OyvhkaX0STVxI1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB4044
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Florian Westphal <fw@strlen.de>
> Sent: Wednesday, August 21, 2019 9:42 PM
> To: Vakul Garg <vakul.garg@nxp.com>
> Cc: Florian Westphal <fw@strlen.de>; netdev@vger.kernel.org
> Subject: Re: Help needed - Kernel lockup while running ipsec
>=20
> Vakul Garg <vakul.garg@nxp.com> wrote:
> > > Policy refcount is decreasing properly on 4.19.
> > > Same should be on the latest kernel too.
> >
> > On kernel-4.14, I find dst_release() is getting called through
> xfrm_output_one().
> > However since dst->__refcnt gets decremented to '1', the
> > call_rcu(&dst->rcu_head, dst_destroy_rcu) is not invoked.
> >
> > On kernel-4.19, dst->__refcnt gets decremented to '0', hence things
> > fall in place and
> > dst_destroy_rcu() eventually executes.
> >
> > Any further help/pointers for kernel-4.14 would be deeply appreciated.
>=20
> Can you try getting rid of the pcpu dst cache?
>=20
> I had a look at 4.14-stable and it at least lacks 2950278d2d04ff531.
>=20
> I've attached an (untested) revert of the pcpu cache (its gone in 4.19 an=
d
> onwards).
>=20

This patch fixed the refcnt issue. Many thanks for your help.
Would you send this patch for inclusion into 4.14-stable?

