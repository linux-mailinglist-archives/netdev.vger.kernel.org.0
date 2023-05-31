Return-Path: <netdev+bounces-6675-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DFC1717663
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 07:54:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89E38281378
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 05:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BEFA4C6B;
	Wed, 31 May 2023 05:54:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5958B20F3
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 05:54:12 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2076.outbound.protection.outlook.com [40.107.243.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27BDC11C
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:54:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fMjzuGNf9IVe5hEZyoAiZgTJ3OSVmdzYFsyy4mtIjXlClRk01D2g2EeWQqIhD64n1RhvKHd1lzW7kkY+2T+4L4uhLnB/yTRysgG3vBybvTpkT2M3wliT87RNEdDD1oLhQvpqsdb9Qy1h5PeM5BT/E8O+C2nT0dzTzaoxaFylXxF5AN2jIBn+pyMISXbPWGpvho4LN5oIJBCIhogVkxjdRQuhc8wDtST9uySfzCPpnWqP4U13vT+9O5h/UnZqCQ331SvBxdjeH1pS3TeRzTyHkUIDVRao2/N8DdwE5E5ALSLY3BKBuYsRa40Ay2e3LKRZ5AJagc94VHbyLBOENHBaUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6Jd2qFhxfe8p92ysZ8M89fEYFtY52/Bz/wbvRd2S7UM=;
 b=YMODY9l0hYUuIhuZbqsZz6tkqr70QeDk2W+7MN1onwdJXfgr4ghUnlZrc4pWRx7Iu5x5Jf8JCcRxvlKLmzXGKOMqcg31qVC03NuvmIA07VP/iuFtsWOs40FL/h4sV/At0XyLih9gYyIG8GNCWO43xHZQI9zVlf+JC2qXU/S/p/XkVUNyv0XHYCt9KsTZkIobqPde0l1wwryaJh9jBYSlqI8Gx6rN+AkEhrkmiYh0trODS9Zrfo4ew0cxymU/cOeparzqRNETqA2AqqTNskT7oXKLMgQwizwH+2n4jLLSGHSvE4YGlp2oXTDCFSJ3nOWLZc6/lAZesCIxddZetxohnw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ooma.com; dmarc=pass action=none header.from=ooma.com;
 dkim=pass header.d=ooma.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ooma.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Jd2qFhxfe8p92ysZ8M89fEYFtY52/Bz/wbvRd2S7UM=;
 b=B0UwYXO/1Ke4BwaFwqJGOcSCzZ2OCnnq/5mWMBLChToZnv9uYzOcco8ZGAN9dd72LNtWYU2Dsfl7KJIG1xdwUCTRZsL8mUSR86CcfwgRu6GhFWyvjBBsxzGl6jDp9DugYXQaSLpLjA0SKHsxJEcMMEkM2WbG9u80ud7utJEh8Co=
Received: from BYAPR14MB2918.namprd14.prod.outlook.com (2603:10b6:a03:153::10)
 by PH8PR14MB6040.namprd14.prod.outlook.com (2603:10b6:510:224::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.21; Wed, 31 May
 2023 05:54:07 +0000
Received: from BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa]) by BYAPR14MB2918.namprd14.prod.outlook.com
 ([fe80::3d7d:27a2:4327:e6fa%4]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 05:54:07 +0000
From: Michal Smulski <michal.smulski@ooma.com>
To: =?iso-8859-1?Q?Marek_Beh=FAn?= <kabel@kernel.org>
CC: Andrew Lunn <andrew@lunn.ch>, "f.fainelli@gmail.com"
	<f.fainelli@gmail.com>, "olteanv@gmail.com" <olteanv@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Topic: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mode
 for mv88e6393x
Thread-Index: AQHZkL+NHkfrw6UQ4EebLP2q0dZYnq9vaygAgAHzBwCAACBmoIABXEyAgAELccA=
Date: Wed, 31 May 2023 05:54:07 +0000
Message-ID:
 <BYAPR14MB2918D22EAF8998C56EC09443E3489@BYAPR14MB2918.namprd14.prod.outlook.com>
References: <20230527172024.9154-1-michal.smulski@ooma.com>
	<20230528092522.47enrnrslgflovmx@kandell>
	<512cef84-b7f0-4532-86a3-6972d05ca25d@lunn.ch>
	<BYAPR14MB291865D8A5763CFA9552774FE34A9@BYAPR14MB2918.namprd14.prod.outlook.com>
 <20230530155401.706eb6b2@dellmb>
In-Reply-To: <20230530155401.706eb6b2@dellmb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ooma.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR14MB2918:EE_|PH8PR14MB6040:EE_
x-ms-office365-filtering-correlation-id: 5829bb34-ac79-4471-c804-08db619b729c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 DwrSxJAfvzjeabpFRUwkva4tFB7qCZTWCDSMikqdH1Q/05XEUYEJ3UhlHFkQNuqDsRKZEw2UdNigH5yodzfGQRTRlyN6SPJ61MpRAoHgZojD6RwtsXYC0u/LaCUL0wSihnhRrQVoFsy0HzUNti4T+w6lEkjjDJDz1HyMbfsDuQ/fDu81S4XuNl2ApO/jU6Hyi3Odo7O/etZFNS9JmiJgjaoD7Tr2JLzQe/8OFpFMjBUNdlRonCVSoBdw/G6RA5GW0Bno+zhxXb8IvvBsuIxnoAujpSQx6Lr1qQf5+n0C6OtXNsgQapU48HwOtxwcmDpcsQXQ7fGTkqgeQ4JUmRSM3TT0np76ZMmUMvQ3M2ZzyZV+lIIpc2UxR1/h9sFiONiFIhYgwEJIr2ZD29ZuK7D6vIUWJZbU5GEvZZxaK2LQPD7Z+/2+qZpKRbHPna/UjIZ+0tfVx/Kx4VMev/1UEPD4jEuVl76xeWhcvS1dlNOtG6BXPm59+aW4MT+5v2FKC87d8j6nL+G0h/0OxhLqVJVojK2xJRbLNCeVifn1/irekQg+Jjx24O+Qe87fi1YYbg3ZOC9eoEbI2r4eQltYsNVD7v2A6JIBU9zNkfe/w3qH2qg4VhR7wLX1Gh/V7IBwczGiV+JAduWxl+WO/ML4Fkgx7w==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR14MB2918.namprd14.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39850400004)(136003)(396003)(376002)(346002)(451199021)(54906003)(38070700005)(66446008)(966005)(6506007)(26005)(83380400001)(122000001)(44832011)(86362001)(316002)(6916009)(66946007)(478600001)(66574015)(64756008)(2906002)(66556008)(4326008)(66476007)(76116006)(52536014)(33656002)(41300700001)(5660300002)(71200400001)(186003)(7696005)(55016003)(9686003)(8676002)(38100700002)(8936002)(53546011)(138113003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?F9XF9CVEvt5C5dcmy4eToMR38LK64Vo3StiiYJhiEUdZcfS6Se2+//iuDd?=
 =?iso-8859-1?Q?LrABpJeOmofMWePUNBQqPCKYYniX7po9csxH5wu+Qg6CCM7OVAOG7wnlV2?=
 =?iso-8859-1?Q?Mwc+5ND0OJtGLmxUJl/hn3+U0s+D+aUrtXOK+LmqWX5cPn+eJqHi2klLWy?=
 =?iso-8859-1?Q?KWRE5zgzErYFvwKe26rF+hkp8+4OKBdZ6DHezlwtyxtLrQCd2WiHfCyp+t?=
 =?iso-8859-1?Q?99WxcxS27lfl4wk3hWkfF79z6N4hUHsOkuz61+lDn/2blsAA/YzI+/g0Va?=
 =?iso-8859-1?Q?64TnP8dP6Y9yR7dBxbS6oAMYLAOYm2fMAynOk8us7N9slgHJw/e84pGyij?=
 =?iso-8859-1?Q?vn7c0SyRRdXHKRhkCHcE2mwlC8tZDPdQp3m7cdtM+R0riQbDXf79o+sRc6?=
 =?iso-8859-1?Q?evMefolCqo0RGQDUJ8DuOwSuCa1MsGZrUmX1mlj6Q9zCYROylqy8U9ZYjE?=
 =?iso-8859-1?Q?Gj2ZCnPJBNJ7+rk+kJ3ObbWMeSTOmkyakrX+c2gdczZbQYE9UgZGkwB3/a?=
 =?iso-8859-1?Q?rmR7jJ8Vn4y01JJa02lome8MB2qgbB9QPojy749GXh/1ErDWDUDqMoXO4t?=
 =?iso-8859-1?Q?QXZfaZLCui5M0PFp39LIxYdqnml7Mt/zX3+uSAQx7/dl8RigTYK43Ccvca?=
 =?iso-8859-1?Q?icq6fuHPtAyy6kXSjGQwqsT+DuYG42xOt0CLyRbqF55Eqli1LmTM+wQGmP?=
 =?iso-8859-1?Q?EjfMZkph/YAcLDYKu1KDdbleumi5M7/WN0n2wrDZr3io+LJKFd0byfcKCi?=
 =?iso-8859-1?Q?55jOFdb/UN+p9DzdhWzznoc0KMkg8+7+hMGzcuXW58ePUtpqt59vre7t1q?=
 =?iso-8859-1?Q?+PwviVJPA3Sr3+WQ1ehT2RXUPbRBgWt37QeI+paeqXHFZoCyyQ++x4k/Ab?=
 =?iso-8859-1?Q?y0CKvq+jMKIjE4upXoaJB42Uwih1oYAk7m9aVRsATk44/fv0mVh0UwFWkN?=
 =?iso-8859-1?Q?V2PqKV+E8WiJPUcIW6jspLymdeELLHQXtBf42mS6kIL2rXtqMBM9Ag4CSa?=
 =?iso-8859-1?Q?tLouSMMsua7YT663RIgfzAVKhtKQjGenAPPVfUGNabPNQUwQnfbhQDnyKo?=
 =?iso-8859-1?Q?yJmUapvH5QFA71akNUtkRRzvmq1HUQJCVY8m38vPa9VbqaQjbuH9G77G3i?=
 =?iso-8859-1?Q?7nbz7RvHlYNwhfXijPh98umMeJ3ABFO39xDR16mmTQn/Fuj/3TpWNRYPAM?=
 =?iso-8859-1?Q?fc2U9OZFZTD9vHOGPm/M6BQLIR+KvQsB9Ut8by85UkvjjKwh8mqLvo5rM6?=
 =?iso-8859-1?Q?vue74CpxGFgCcIqu5PuWP1a/fG/98aTuheO7uSrWj05qcBdyPTmFcbGnXY?=
 =?iso-8859-1?Q?3Y49l7YgFRrEjloQdR/lTeWJOdm8QLZt8Sm0bRZA8xuXLGueMVk/Qw/45J?=
 =?iso-8859-1?Q?e4gfDcOSVsU+84DAJPK9HrYPsjl5MXsi2lPyfBN0ZB66YitAyaXjfFs9F2?=
 =?iso-8859-1?Q?btRwdR+JJeWhmbSLcmXPyFHUxbb6PE2qESgNCD0mV4ZnFixFbnevcJB80U?=
 =?iso-8859-1?Q?JUpqKsuAS958/L4QQjU16U7Pl87SDmpBEvSCZ0tKaMLQ4zs1KEtP0bObVV?=
 =?iso-8859-1?Q?q0qE4rG7XWCn6bFvTtY+dne6ycl82Uzfip3z5+ZNXXa/zXY0MXhKVzlkuO?=
 =?iso-8859-1?Q?sr1gYfccUhkB513ZDhuXxcrqDpToK+8kH8?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: ooma.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR14MB2918.namprd14.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5829bb34-ac79-4471-c804-08db619b729c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 05:54:07.3519
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 2d44ad66-e31e-435e-aaf4-fc407c81e93b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nI9BypDum+znLc+DR82izirAVV9pHkZUyETTraOHDg0WjFHoFI9yu08Zux21s6jxlbEAmJu9mkQpXiICyCLR1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR14MB6040
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

I followed your suggestions and came up with version v3 as in my previous e=
mail. With that patch, I get a notice of link up in logs.

[   51.658898] mv88e6085 0x0000000008b96000:02: switch 0x1920 detected: Mar=
vell 88E6191X, revision 0
[   52.325920] mv88e6085 0x0000000008b96000:02: configuring for inband/usxg=
mii link mode
[   52.521309] mv88e6085 0x0000000008b96000:02: Link is Up - 10Gbps/Full - =
flow control off


Michal

-----Original Message-----
From: Marek Beh=FAn <kabel@kernel.org>=20
Sent: Tuesday, May 30, 2023 6:54 AM
To: Michal Smulski <michal.smulski@ooma.com>
Cc: Andrew Lunn <andrew@lunn.ch>; f.fainelli@gmail.com; olteanv@gmail.com; =
netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: implement USXGMII mod=
e for mv88e6393x

CAUTION: This email is originated from outside of the organization. Do not =
click links or open attachments unless you recognize the sender and know th=
e content is safe.


On Mon, 29 May 2023 17:23:12 +0000
Michal Smulski <michal.smulski@ooma.com> wrote:

> If I understand this correctly, you are asking to create a function for U=
SXGMII similar to:
>
> static int mv88e6390_serdes_pcs_get_state_sgmii(struct mv88e6xxx_chip *ch=
ip,
>       int port, int lane, struct phylink_link_state *state)
>
> However, the datasheet for 88e6393x chips does not document any registers=
 for USXGMII interface (as it does for SGMII). You can only see that 10G li=
nk is valid by looking at MV88E6390_10G_STAT1 & MDIO_STAT1_LSTATUS which ha=
s already been implemented in:
> static int mv88e6390_serdes_pcs_get_state_10g(struct mv88e6xxx_chip *chip=
,
>       int port, int lane, struct phylink_link_state *state) The=20
> datasheet states that in USXGMII mode the link is always set to 10GBASE-R=
 coding for all data rates.
>
> From the logs, I see that that the link is configured using in-band infor=
mation. However, there is no register access in MV88E6393x that would allow=
 to either control or get status information (speed, duplex, flow control, =
auto-negotiation, etc). Most of "useful" registers are already defined in m=
v88e6xxx/serdes.h file.
>
> [   50.624175] mv88e6085 0x0000000008b96000:02: configuring for inband/us=
xgmii link mode
> ...
> [  387.116463] fsl_dpaa2_eth dpni.3 eth1: configuring for=20
> inband/usxgmii link mode [  387.132554] fsl_dpaa2_eth dpni.3 eth1:=20
> Link is Up - 10Gbps/Full - flow control off
>
> If I misunderstood what is requested, please give me a bit more informati=
on what I should be adding for this patch to be accepted.

I know that 6393x does not document the USXGMII registers, but I bet there =
are there. Similar to how 88X3540 supports USXGMII but the registers are no=
t documented.

Do you have func spec for 88X3310 / 88X3340 ? Those two document some USXGM=
II registers, and the bits are the same as in this microsemi document
  https://www.microsemi.com/document-portal/doc_view/1245324-coreusxgmii-hb

I don't acutally have access to Cisco's USXGMII specification, but I bet th=
ese register bits are same between vendors. Could you at least try to inves=
tigate this?

Marek

