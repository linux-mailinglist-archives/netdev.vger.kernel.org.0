Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317B2514195
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 06:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237814AbiD2Ez2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 00:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbiD2Ez1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 00:55:27 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2040.outbound.protection.outlook.com [40.107.95.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72727BE1F;
        Thu, 28 Apr 2022 21:52:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LNasrMeCIsO3ga2gFRLULG9zbxSfPp9EE70sluLQ/T11JReRbcuG337GUmgSUe/VKo5bLlDxDOgCDx/KxBIsoNV/tPXXFo+S7WVV2ZT7NL4aDYRhQfKhJ4BpPpelDqCvcc81VvGW2a9OAqcXAfpynfsjw2xjSJ6iX1jbNQ4evbB0KDNXuq5RZK6So7cL4+fFnlc8D84MSWpjjEfbeLtpwv5ziTRTim086iKvK07N+jSD8dRuzruZcDAPya5T9GLKgCh/Bd2iL+ruwKa50PutFmsGtg+j2cqzt3da/h4MZMrrq99LMGpjxOX3h42OOw7i3OuPcZBaTQL0PD+wdhyfRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7B7ZNJfG2pgoWAKvYpcdDCVfLUah0CR6NxJUt4QEZcc=;
 b=f6X30c+fhDOUL2ck0BryVSzhkq+IEhHZm/6KRJ82sgYryIdfG3Y6aU60WK1+y0vZjzBeF06lxgDf4yPZrRIE/o8iUpgO94L5aFmdVVU5xP78joolLVsdpDFpbSsqaRkOB/wF2SSaf36hxaRKJEWYp61G6q9te2UFlpUiCzb72nkh0HD3AyIIF55JZQKI/I6RI0wSbjpMAtdHZrBVaaMC5aZL6wfUGQSIlnxuck1NFoz3v9v356h8SVga6g+bB4A13wCVEhozOeEN2yXDwwljXD2YBlPiyLx9fuTX2uFehTv4gHJQ3MMaXft387gAdHX5kylYS1ex84al585eEvl4xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=xilinx.com; dmarc=pass action=none header.from=xilinx.com;
 dkim=pass header.d=xilinx.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7B7ZNJfG2pgoWAKvYpcdDCVfLUah0CR6NxJUt4QEZcc=;
 b=WyGaYvnqekOHBGLHewoQGgjsjBAgB3X4c4KA+AYb2D2SkcTfZfjbfsS/EwZGOXMtJpY8K7RcywCUBjgJckTtRuZAlYuYdMUclK7vb5QovWdF5+G3U4rQmet325OmNmIF6tEiVscdQrHlXt1Jkl9hQ0HdZY7uD2R6liGVhcJ+lYU=
Received: from SA1PR02MB8560.namprd02.prod.outlook.com (2603:10b6:806:1fb::24)
 by BY5PR02MB6485.namprd02.prod.outlook.com (2603:10b6:a03:1d2::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Fri, 29 Apr
 2022 04:52:08 +0000
Received: from SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::f8bc:753c:d997:24de]) by SA1PR02MB8560.namprd02.prod.outlook.com
 ([fe80::f8bc:753c:d997:24de%3]) with mapi id 15.20.5186.025; Fri, 29 Apr 2022
 04:52:08 +0000
From:   Radhey Shyam Pandey <radheys@xilinx.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Michal Simek <michals@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        git <git@xilinx.com>, Shravya Kumbham <shravyak@xilinx.com>
Subject: RE: [PATCH 2/2] net: emaclite: Add error handling for
 of_address_to_resource()
Thread-Topic: [PATCH 2/2] net: emaclite: Add error handling for
 of_address_to_resource()
Thread-Index: AQHYWx0B4DcbdH5mIkm3NhPw0t6SKK0GF5cAgAA59UA=
Date:   Fri, 29 Apr 2022 04:52:08 +0000
Message-ID: <SA1PR02MB8560AEC29F442363E2E1F8A0C7FC9@SA1PR02MB8560.namprd02.prod.outlook.com>
References: <1651163278-12701-1-git-send-email-radhey.shyam.pandey@xilinx.com>
 <1651163278-12701-3-git-send-email-radhey.shyam.pandey@xilinx.com>
 <Yms8sJzJe6Cl2x7J@lunn.ch>
In-Reply-To: <Yms8sJzJe6Cl2x7J@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=xilinx.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b99a899f-e356-401f-55f0-08da299c03c5
x-ms-traffictypediagnostic: BY5PR02MB6485:EE_
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <BY5PR02MB6485CD21B88D65A37B1571DFC7FC9@BY5PR02MB6485.namprd02.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tp37/ZPVY0BRvnT61nW+MVTm0asAzvk/bWPqInLJL3aj9XNuvykHs14XmElKompCKi+XxByTkKrLGMmqHwOMC0IwfCc/JiFRzmmxoQeqGYd4bpjt1YPf7/iyhkudeFyfTW5z0xMkUyPEo50uDQyKQ22Qt/64bqxdLEKRyFwgviVAaXVWHXCHBGDCd45ot/Ai0MWiBmCjGkY+G+L31OJwoT4mfZb6QWwVXfnyV7xtAa7y2x4VUOJk3n/HP6MJ+OcT7eQBWYclbt+nIeZ/ebN80+strBDrNVdQXjOaliYWq2r91VCEK31S39uOUm4uS8Ed33nYVnLnoNNXaqOyT0/SDZypesh2RmK/4z1n9KZ5zWKywT3rqzAIeJLOLsqn2WaqO4SXYuw6uH/94DexguoNxt1PfzqlsiE+HaHg+bSEkNqEv1O2kllALBz9ZNWDZh6ddzNiuSzFM3bbNfX2/L2J7M1Ch1027gbF047rA3Wdqz3Ty97DFV76uIV7YsD7OzmQwUe/5ymudaanfl9OBJMmSPfD67u8TWxykiQX0sUIQjRrVb5BR4xyXNhW/7uHg7Kyc6ggoed83sSUxvjsA6tklqeQuPQIoVfdOS7lGEX+vl3DPmUI1UKftVt/uPWqw2GGwsvuuCcBpTXa6bED59SzdK8z2dlw1YrtMK5WQ/ezIOXwdonxWVk2tptL0Q1mQP1WJXhHDSWFv4WJvCPyQiWGEA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA1PR02MB8560.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(33656002)(86362001)(122000001)(38070700005)(38100700002)(5660300002)(71200400001)(8936002)(52536014)(2906002)(508600001)(6916009)(54906003)(316002)(66556008)(66946007)(76116006)(66446008)(64756008)(66476007)(4326008)(8676002)(83380400001)(186003)(55016003)(6506007)(7696005)(53546011)(107886003)(9686003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OSECVl3BGtUqjTsGEp3HXMezniMQqVohjrotx+yRirKrDRQhuU7YnNwGpRXz?=
 =?us-ascii?Q?L3Yr8ebMpWi79giSQm4ArfBnu/rRCPQZGj/ZwUkq7vMSsBQTY1jTQY4x6x9j?=
 =?us-ascii?Q?RZWLPTNEBk0TGy3bF6Y8pJMa7MJ6AIo6VdQ/D1NKL7lW+56QLcIJ1IzRvBgV?=
 =?us-ascii?Q?ZyTuFkM5td/nD9udFR6dp27pawTF9va8Lks9+s0iYqsv4vkeq2OBwncca8Im?=
 =?us-ascii?Q?n7ZhHwpGTnYbHlAsj2cMsJJF5AUrBjFay6CCz2vHvlRbj5Cmoreo1HL9LTvF?=
 =?us-ascii?Q?aJ56FkI6Zdh105s20z03AwI3iML6Lu2siUCm2axwIzXxvd1dDygxxer5dSuv?=
 =?us-ascii?Q?jPGOPw9SOgDrwm9o+8yMbOGAek8eiyCwf2O7mv7T4MbcIEzK3/BCGgP6OBId?=
 =?us-ascii?Q?R+Ga1NpOt3KsycqT0TBQYqOXTQxZbTSFEBGOZFq/VD5yTNwfArnhVAwo35HE?=
 =?us-ascii?Q?Ttqvb7kvLxEvzpPAuiGUAui6UWJ5StcIGtrgmEM/4LlhAx9V9ZOKTW3fXJHL?=
 =?us-ascii?Q?/kys/n0lLkk4yMT0SrQHree0+kqU1t9NQohd6T8DQH2cz8SCE0cuKhfzNkDS?=
 =?us-ascii?Q?wXy/sbvUdR3izb6aFNDZBlf8D+teIb6owVchzVYQ2/72lxMDwimkMLQol95n?=
 =?us-ascii?Q?DAxBY0/Op8myqZxGDvkitQyrm5JuM3fuxASZzsgOc4g0mrzL2Tv+yBtCbCzd?=
 =?us-ascii?Q?eIN5PFLuBTV0KkkodMeQhf2xAbjChyan3Fh19OlJsnLtwOBaY8lTIVAplWrg?=
 =?us-ascii?Q?UC16pwjtDt5w2MtDt0CxcIKB8zdDILm5JpjZuLJpajpPeLgU9mf/KYCEkHCM?=
 =?us-ascii?Q?jYuhr4O04H24xkF6I+5ThsjiAn0K8Pi7z7xVb3T1DwlaV3rUX91zMKpCBMAY?=
 =?us-ascii?Q?B4/jWhFealnPfUivO8rYwzMEPfNzOV+kTJQ38yE9DMldaud3JGBLC/+3UpO3?=
 =?us-ascii?Q?qkfo1WPPnnVOqKrLsr8Qss1Wogg4vCBUDXwuK/zLG+H0oMi4c/IwAnWnMnFy?=
 =?us-ascii?Q?j8bY/pAeiILQfHP8p+BvFaU7YflhKa6LKSiQSLGve9l/ZyITqDcJeFSpqcW/?=
 =?us-ascii?Q?O0CY+l2Rh49OQ/CsgiffMw4sg9jxEgQOXQd+pmebJe83H6UdVkRkHNR1hTlP?=
 =?us-ascii?Q?Lmq8ASFRtA3acyH0ADKBIVf/3dQ459TrWEY2sLsruJh86bAAU5zLbXG61G8I?=
 =?us-ascii?Q?UsOgvijBbVmE1Sc9iHg7dP8v3N1VzKc+uHPDMO86la2eEICEy1mkTkk0LLe3?=
 =?us-ascii?Q?HjYnI6fLs1BXT0rwRA4hv4K/XQaXBgaAKROBPh3bsa6AVqrLzQQCDQt1K6Ed?=
 =?us-ascii?Q?/ADd0mZNE7Xg5EWG8Yk9U/YFz5r6d7iYrVaKfiuzUVB+shwO4U/PiUIRzlgp?=
 =?us-ascii?Q?GK4ivLs334n8mBjD/Ti5kw2Iy9wOGP6biSfq4iJHIqRaHIRN8YrM5751AOEB?=
 =?us-ascii?Q?1Q2+oUmhjPQIwHccN7H3nyybSOSCrpn/bArh3BvNPsI6BFVBYZqBgkIY01ul?=
 =?us-ascii?Q?zuh48ZdoSXoNGJth5KlGYNcTy7V9dSL/3vkNK+pQiqKNHJrUqwfNLnfSf61n?=
 =?us-ascii?Q?MyGoO0ImDTe7py3bs0/yV8iK5/rdzN8QrA28n/4arbq61HBZucZ+NYhi1J6A?=
 =?us-ascii?Q?yCpvHkV2lcPOHgnEBqwSCmMjdogNBIKN0fQ3W6szqvzIMCr1OZZPiNU2Xz/G?=
 =?us-ascii?Q?yO9TPNLAn57PahVkYO8avY8729z7ppGiPAxkg/IhM16jtUlqrXGXdX6l5DhP?=
 =?us-ascii?Q?5gLucJ8mw+pFYnPE75mYw95A8N/aNu9e4/myrrHWqESJAfq+d0zDXKfh4fnZ?=
x-ms-exchange-antispam-messagedata-1: MhkpFFSVdWSVqQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA1PR02MB8560.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b99a899f-e356-401f-55f0-08da299c03c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2022 04:52:08.0935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: omK2uCesrVtmqa8NjYmIi6kdt67ajXxD3XqcQdCTaTRzKldBeMv8930vZf+E0glpRmTzmnxkMUzzu0+fYw2i3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR02MB6485
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Friday, April 29, 2022 6:48 AM
> To: Radhey Shyam Pandey <radheys@xilinx.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com; Michal
> Simek <michals@xilinx.com>; netdev@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-kernel@vger.kernel.org; git <git@xilinx=
.com>;
> Shravya Kumbham <shravyak@xilinx.com>
> Subject: Re: [PATCH 2/2] net: emaclite: Add error handling for
> of_address_to_resource()
>=20
> On Thu, Apr 28, 2022 at 09:57:58PM +0530, Radhey Shyam Pandey wrote:
> > From: Shravya Kumbham <shravya.kumbham@xilinx.com>
> >
> > check the return value of of_address_to_resource() and also add
> > missing of_node_put() for np and npp nodes.
> >
> > Addresses-Coverity: Event check_return value.
> > Signed-off-by: Shravya Kumbham <shravya.kumbham@xilinx.com>
> > Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
> > ---
> >  drivers/net/ethernet/xilinx/xilinx_emaclite.c |   15 ++++++++++++---
> >  1 files changed, 12 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > index f9cf86e..c281423 100644
> > --- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > +++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
> > @@ -803,7 +803,7 @@ static int xemaclite_mdio_write(struct mii_bus *bus=
,
> int phy_id, int reg,
> >  static int xemaclite_mdio_setup(struct net_local *lp, struct device *d=
ev)
> >  {
> >  	struct mii_bus *bus;
> > -	int rc;
> > +	int rc, ret;
> >  	struct resource res;
> >  	struct device_node *np =3D of_get_parent(lp->phy_node);
> >  	struct device_node *npp;
>=20
> Reverse Chritmas tree is messed up here, but you could make it a bet
> less messed up by moving rc, ret further down.

Thanks, I will fix the existing declaration order in a new patch.
and in this patch will align new changes to reverse Christmas tree=20
order.

>=20
>      Andrew
