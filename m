Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB23C60ED9B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233997AbiJ0Bu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233996AbiJ0Bu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:50:57 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2063.outbound.protection.outlook.com [40.107.104.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C743A12A348;
        Wed, 26 Oct 2022 18:50:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MXGsIZLO+iwrJj7LVl6dY3kAoP6GCMK5ilKPPtYgMLJgjGsFxIy5UPCBsJWGVdLNT82/ibvfOUTMHzsK6X4+K/w4oTggOuBWS/iQjD2mA7CzZQYQeMC4UfFlTGpiHBvtoePSrYGkNwwOgtWi0uwxQwQsT+A8FwrPn6oW/LSATddCG2BL1xAm5A9RABPzsC/+AoCFucZs/A6q7YynoVHZHAu2fTVTArzIbgpb3YdFcMHV0VbLPGD6e9d9iCYfVtDEjjR1kyJv2GBX9ZjbRit/1lRCxIqonLGhB/tWBLnbWu2dvHjllj1gEyoym+6EVnIM/I1Gg19nlbbh2W1YWC1HXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=44uqE6Ry1ohlyeAFB09V+VeXuoQIBl3/CX9kmk3XEGk=;
 b=GJsSCLesMYXFz4UaYva+exRxVmvtARa1WjvM7FaTA78V7eZH2+Roz1y5Le18ASOMJpzCmbPu6xs49aOrYykIZaDk+EXR/mZbSntZ4b2sy/4DqD0jDTIDd+sFUZwgzzB0veywuee/8b+kkonUxuMDl0VDxWCepxmkkcXLr85jnX3kTjMzdB0+EGneJ5s9hUCtVhEG3h0B/RqtvFfYb73llEoXisbeOZz9pswt9AlOfJhuLpSD3/HoIJr11Gqu15Yje94Bn5t3mFllYge2zQAjLCsdvTHDIS/3iPJ9wL6F6oOyMMRUAH72/imGJuGVEuaswJy+i1gFUMPq3hTTWYrL9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=44uqE6Ry1ohlyeAFB09V+VeXuoQIBl3/CX9kmk3XEGk=;
 b=KliMWgZYt3CFRvsD7xw96NKoD3O8eSUDU9JGrbcVcfhnoLPEjW/vftpntTZHW5V7DQlmikb3tIM4pq367SqAwHR/rxEyH4v9j/VL3BYAtdXYbtqAEZaDQFb50bbiucefR3AQG2tkhobrQCkX65HkDwV8mf1c4YAhfnW01Nb02Ew=
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com (2603:10a6:102:231::11)
 by PAXPR04MB8335.eurprd04.prod.outlook.com (2603:10a6:102:1c2::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.21; Thu, 27 Oct
 2022 01:50:54 +0000
Received: from PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c]) by PAXPR04MB9185.eurprd04.prod.outlook.com
 ([fe80::4150:173b:56ec:dc6c%9]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 01:50:54 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Index: AQHY6K4PPMwFL4lhXUy4OBl+zI+fJK4fq0QAgAHOQoA=
Date:   Thu, 27 Oct 2022 01:50:54 +0000
Message-ID: <PAXPR04MB91856F5DC9B273037BBCB28789339@PAXPR04MB9185.eurprd04.prod.outlook.com>
References: <20221025201156.776576-1-shenwei.wang@nxp.com>
 <Y1heXnxgA6e5T8sr@lunn.ch>
In-Reply-To: <Y1heXnxgA6e5T8sr@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAXPR04MB9185:EE_|PAXPR04MB8335:EE_
x-ms-office365-filtering-correlation-id: 24b2c399-2fcd-46c8-f49d-08dab7bdaf5e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7X62vhe8C8LSpN6Bzl2rrAEfNUfKcoAH281hOv9on+3HZGbHvn5TNsqIne614/Os9OIjqGfdtdaYoYecIpQ9pq18lYA6B7FsybaWzncsbq8IAik/29l0F2Vf4DV4oLmYUbhJipr8yC6l17kktSBxn4Odq/Fn1dqLi87BpAxHtLdhmRvw0O2MCM8fZzX+iF9lBKXuabeEZXAPY53TgndZPHJ/deSM8X7ISw/HvOZ6Na/PCyQCDv8/fKKxQgnhuZxf2lFih2qkct2Gx+7565wgF9LakdtsITzGice/NE7TAC7yDphMl5SJ0nzSKfTY/xLsQFazHCc6UkUGaYcmDrIKmi+UB+bCu4SMoNrBqGZ0iS9WK//MIAJiPN2VBWi2aSMkrlYZPoF4YF4Fbcq9io12+wXyX34jh8F3QMrQxg1E0r6UiXwqHYBWrMXFl2KLwCMCkCOZVP8RcuIrKA/bSrwYJXMwlG0RflndYrWIfysmnWBEN9Ti5OwC7M/3eO0ujYO92PvgJoSN5FJrZaK3TwMNmctTgZA73gxQmOwsnK5bbT7TYsXQu+DEOYIxI+Xoxp5Gu+v89YlXWWU/o1ajAUO6tfAJ/z6SQROBIfYlU1SLWrRo+7E2gDDg1p7pcILbUgo+Sy1IHaQdhLKj7ZWSmvuNMFVDXbe2zFeD9Whx8RVnNoS8hIAbaxBZwZa+WVoBHlauBRD5NCETmEneYnJIWaZ/Qnj57B7sxzQEcJ9Xt+cK6bBOzroCCztqdhAQWiB/GTNRSX0LO49Niu+sC6eWPNtMaw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAXPR04MB9185.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(376002)(396003)(346002)(39860400002)(366004)(451199015)(26005)(7696005)(53546011)(55236004)(6506007)(9686003)(478600001)(66556008)(83380400001)(186003)(44832011)(2906002)(6916009)(55016003)(4326008)(66476007)(71200400001)(76116006)(8936002)(7416002)(5660300002)(66946007)(52536014)(41300700001)(8676002)(54906003)(64756008)(66446008)(316002)(86362001)(33656002)(122000001)(38070700005)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?MYV6JaRMHrf5nSRM1ZdO4aZeiq1ikCV/sRO+M9nD0BvxQZPhSeMSI5xaaWI0?=
 =?us-ascii?Q?zA6vBQqONw6Cxs/FAhJX8QAZWIvD07j/wBYtUOE7APL4S8M9J06P+mW6dEaq?=
 =?us-ascii?Q?S9czz0stoKSxZDpf4zBmEK6tm1c3R0VzmbQL/D8uiZRLWMFv+J4V6q6LuRi6?=
 =?us-ascii?Q?NprDETV5ZNX1SyPIym2s2EkCeFq/MnHtl/+50bfk4tLpD+LfDO3P1mlhx2A4?=
 =?us-ascii?Q?nlfXpk2dAMsb1iVavK3S8x/XWMpZA2uIe4bT77+ykixi6Ri8MSuZ3sWacIMh?=
 =?us-ascii?Q?9tf8BTWDxhnA9MirvVWDfcHys+eb4ZhizHQE34ApgMv24w6a5IGCaRELTHpA?=
 =?us-ascii?Q?sdA8NT0F+jnPa5m/sv2JO+ulTelq0i5B7uj6T5eBWcRnt/CNa+KsiqBdn4Nu?=
 =?us-ascii?Q?RlRbhesyqs22iuc/SlbMGdwHvXEwc6Ls1YXvymtlOeVNcyxT96Et0/dNXAFK?=
 =?us-ascii?Q?byKfoBdOKf4uA+yVuY2YVp6ceDuG2T839+RKtUMmEjL3qAd8/W8IDUP098w1?=
 =?us-ascii?Q?QjW/g+4YmWUuxioIGzPzG2VvtBemAisPbzh1Xiv+R13w2VWdJZsjcXCTEzrt?=
 =?us-ascii?Q?jwg+2Zz1oGJZXy8J2XQ5F5PFEUeY6Rd9fZj4uHGRDWE2yxJruyEXhMskZAk4?=
 =?us-ascii?Q?bhRO3jDYN6XrELWHa0DE93weRnsoHfbUs92S9LTWlF5gb91rMdc6LXWNedMs?=
 =?us-ascii?Q?9qFmAiJ6mXj0y4mucdBZl3/OLa7AsCZDG1rgQdHmTraKTjyoYRcb4FLM4O8Z?=
 =?us-ascii?Q?+XkBrUvvWlvIyRhBxQzyipCc8fD2ttjFq0JWiixaQCovTJbuhH6jM/RijxD9?=
 =?us-ascii?Q?1OWBkscPaE9oo2oHAcakZcajQ0InfluJzmvBP4Pdr7vrmsQboQNbgYX2ab9j?=
 =?us-ascii?Q?WWD7EJR7oQXm52oBS/r2zhJh+GCDU/IePqK2I/aTeA1H/n6nqNpd/AkviYHf?=
 =?us-ascii?Q?ajcVs/4KgDeqyq62HqgQWVdPR9Q56zenx6YWUDQ9Rk6+sLOBQy9XKo8XQCaS?=
 =?us-ascii?Q?tZM6eYz3zoWne06M61TAf889zHvkk/FqrNGQceopxyrj2suU+CqHnnkYVM2D?=
 =?us-ascii?Q?VIgR6BlcT/Fvn9OJL0jJ1hPy3iDylIe8BqENnA5l6iXTSky8cboX7rBDXDk+?=
 =?us-ascii?Q?5TqP/dsVx3rt7EphiVZB+es7Yi0iR9pwHiT1hoe7DPj2tHYY7LXwbc8iKI4r?=
 =?us-ascii?Q?+wX7Cf8tE93f9MHF63syajdiQN0qY9b5+sPrDw1SNHO7GRGWAWzOtuvyXOpw?=
 =?us-ascii?Q?EHr2qXf78jvkhPyE2H76rxxbtTD2nJIVREctRYIaZe/4yaEyB805M28YAYyB?=
 =?us-ascii?Q?7igwym5/EkB/2dUMgFaff4wlYm33pxQhK2AFE/mQOUjCB8Yajx7zxfWP/XtL?=
 =?us-ascii?Q?QhEhgLsFr0LBsZnm0UHu0x+NL+dE4XYUuKbEj8GkpN32OvL83J8vchb3+zKq?=
 =?us-ascii?Q?C93nuljM8+wMfmDuiAMYFnWKe3L0Fk3dlpvRlQ3nDjlao+7YmkmiK9seiv4l?=
 =?us-ascii?Q?KoPZ5W7A6FFFFggcHvQx955BUDY9VM+AKFmCM3/94D9NzoZDHJS0y3RFna0r?=
 =?us-ascii?Q?OFXoZwCLJXVJ07HUNpzMrxhcXzOL3c6PumrSU9IQ?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAXPR04MB9185.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24b2c399-2fcd-46c8-f49d-08dab7bdaf5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 01:50:54.5128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fvYcOONOVVPxODA2Ivg09AbUQUhezTunNHblAjoJ6eoWbIUMiUjn9ilCekJihjUna5qTSXupPy+fCpAT3cg+Ng==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB8335
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Tuesday, October 25, 2022 5:09 PM
> To: Shenwei Wang <shenwei.wang@nxp.com>
> Cc: David S. Miller <davem@davemloft.net>; Eric Dumazet
> <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; Alexei Starovoitov <ast@kernel.org>; Daniel Borkmann
> <daniel@iogearbox.net>; Jesper Dangaard Brouer <hawk@kernel.org>; John
> Fastabend <john.fastabend@gmail.com>; netdev@vger.kernel.org; linux-
> kernel@vger.kernel.org; imx@lists.linux.dev
> Subject: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
>=20
> Caution: EXT Email
>=20
> > +#define FEC_ENET_XDP_PASS          0
> > +#define FEC_ENET_XDP_CONSUMED      BIT(0)
> > +#define FEC_ENET_XDP_TX            BIT(1)
> > +#define FEC_ENET_XDP_REDIR         BIT(2)
>=20
> I don't know XDP, so maybe a silly question. Are these action mutually ex=
clusive?
> Are these really bits, or should it be an enum?
> fec_enet_run_xdp() does not combine them as bits.
>=20
The bit here is to record the states that may required after completing the=
 XDP processing.
As the current implementation for XDP is not full, the other bit like FEC_E=
NET_XDP_TX is not=20
used for now. Generally it will require an extra action if a FEC_ENET_XDP_T=
X is returned.=20
Because we are processing a batch of packets together, those bits may get c=
ombined. It will=20
then responds to each bit accordingly.

> > +static int fec_enet_bpf(struct net_device *dev, struct netdev_bpf
> > +*bpf) {
> > +     struct fec_enet_private *fep =3D netdev_priv(dev);
> > +     bool is_run =3D netif_running(dev);
>=20
> You have the space, so maybe call it is_running.
>=20
> > +     struct bpf_prog *old_prog;
> > +     unsigned int dsize;
> > +     int i;
> > +
> > +     switch (bpf->command) {
> > +     case XDP_SETUP_PROG:
> > +             if (is_run)
> > +                     fec_enet_close(dev);
>=20
> fec_net_close() followed by fec_enet_open() is pretty expensive.  The PHY=
 is
> stopped and disconnected, and then connected and started. That will proba=
bly
> trigger an auto-neg, which takes around 1.5 seconds before the link is up=
 again.
>=20
> Maybe you should optimise this. I guess the real issue here is you need t=
o resize
> the RX ring. You need to be careful with that anyway. If the machine is u=
nder
> memory pressure, you might not be able to allocate the ring, resulting in=
 a
> broken interface. What is recommended for ethtool --set-ring is that you =
first
> allocate the new ring, and if that is successful, free the old ring. If t=
he allocation
> fails, you still have the old ring, and you can safely return -ENOMEM and=
 still
> have a working interface.
>=20
> So i think you can split this patch up into a few parts:
>=20
> XDP using the default ring size. Your benchmarks show it works, its just =
not
> optimal. But the resulting smaller patch will be easier to review.
>=20
> Add support for ethtool set-ring, which will allow you to pick apart the =
bits of
> fec_net_close() and fec_enet_open() which are needed for changing the rin=
gs.
> This might actually need a refactoring patch?
>=20

That sounds good. Let me think about it.

Thanks,
Shenwei

> And then add support for optimal ring size for XDP.
>=20
>     Andrew
