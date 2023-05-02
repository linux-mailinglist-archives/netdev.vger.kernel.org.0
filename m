Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7416F3EC9
	for <lists+netdev@lfdr.de>; Tue,  2 May 2023 10:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233762AbjEBIH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 May 2023 04:07:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233781AbjEBIHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 May 2023 04:07:17 -0400
Received: from FRA01-MR2-obe.outbound.protection.outlook.com (mail-mr2fra01on2131.outbound.protection.outlook.com [40.107.9.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4CE35AF;
        Tue,  2 May 2023 01:07:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FzqvgLml87I4M8lajJFCpjn8sepGfnucFZr5A7wXgyne3WxL5v1Pv/+j2wwFfoXjBfXFHKWLkKOp1KAi9K2ADpOu0cRz0cg+6WKYLVCRTFUc0AnGXun50D+xyvZxKUN+17Y3I2NIjQDYz2k+rP/WDntx6mC4vyfm2SddtNNHgk6fTIYnv9sYQmF9X+ByNAQiX5D7TAu9P8vns2Lwu2lH7PfHxtNJYbhmxJdAA93+Wx+H9ClES16SpXILt1/I0HiE8vqbWHMefOp2PbvF2Ry1xcSi7OwcJSTi9c8JRvigbvhYdDjPoO0NoFjCT0vtTAQuDPdTSMcFl+ybXWGNAppCMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZuHNnpFmhpB5ryXC+K6/vBtb/64lGWvI3nwgNeibSl0=;
 b=Jggn31Ff5XRbw8ffX1ti/lMRfrmwa79j4+eQXPI0HLf5CQzvepZme9ZE2YxCTeI2EPA5NufW7vGJQzVfv2CTkcpBpoU/UgHtZlga1zBCxAqznBKR5cOuYzncMXbUUEt3s9ArY5NwxYvUY6iaAWUKe08bEKQM/02xdbXBzhAqOJyB4z/0K3FKUv2Nn+nWflBo/9Z4eIyQgxY6eZHPhnzL3ceR/cVR/RruIjUW0/0rNXN73cK28LmudD9wSrP662onJvlgPcmnF2gnBEdYGReFemUpsnx47YNcLkYBrUkKWHzjN4FQBO+pZoIWo/fsU/WNhodi6UwdCT28CCFfBH7oUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ekinops.com; dmarc=pass action=none header.from=ekinops.com;
 dkim=pass header.d=ekinops.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ekinops.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZuHNnpFmhpB5ryXC+K6/vBtb/64lGWvI3nwgNeibSl0=;
 b=OayMP1pdOuBSuLv7j2OadawTdPIBT3/ZI4pjOeEEFkCj8EH9RVTnLE8vDvw7fu8VCrjUnfIu0cje1CIinzp8txZYToMzMX4M5h2WG6R5uZaX5TxW8to1O1aPfQ/Vll4byX0BNXSxEFVUAFD3PGq1RPTRHQtLoHTcSYVCNvQOIsQ=
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:141::6)
 by MR1P264MB1539.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:3::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.31; Tue, 2 May
 2023 08:07:10 +0000
Received: from PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5442:2af6:2ce1:f8a]) by PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
 ([fe80::5442:2af6:2ce1:f8a%6]) with mapi id 15.20.6340.031; Tue, 2 May 2023
 08:07:10 +0000
From:   Ganesh Babu <ganesh.babu@ekinops.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ganesh Babu <ganesh.babu@ekinops.com>
Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Topic: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32
Thread-Index: AQHZYUP13XlrMpW17Ue8ZSjM0wOOK68RBfoAgCx+iec=
Date:   Tue, 2 May 2023 08:07:10 +0000
Message-ID: <PAZP264MB406414BA18689729DDE24F3DFC659@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
References: <PAZP264MB4064279CBAB0D7672726F4A1FC889@PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM>
 <20230328191456.43d2222e@kernel.org>
In-Reply-To: <20230328191456.43d2222e@kernel.org>
Accept-Language: en-IN, en-US
Content-Language: en-IN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ekinops.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PAZP264MB4064:EE_|MR1P264MB1539:EE_
x-ms-office365-filtering-correlation-id: 82711abd-cd5c-448c-26b6-08db4ae43b11
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RUTjHhP7pHXiRYmz/YK7yIBSF46zQGF6ZbpijEpNLpu1Zp/xm58k4uPvlsXKWgfIp0ETHhoAeXzTFTq/gDImSXBB2pRkn4yNoI5OkD2Dj5EWY9jToNaFpe+kd9K10FnPA3/+ww5qlA0Varam3IwYMI1shf+WGxSQeOuITUL1j3zUjP7ja17JAEEUDNNV6wJLVzFSRWld9L9eucP8SLkHjq4CKjuX2BuceKUundy+Md/71M+XnWp+XG3AqZtn4shz6+oWtwrT8FB8/KSJyneQdvr2o8YBJl4ZzLjTtVuds/I7fzOI0p9Zvb53gjl/k4eTT8BFKGZPYPYKtLVBQqh8RGz9tzzJnkWyKfJV5BQAXv81cMIdrKOWejNZoCvOjoIqKwSuECqr5XfXjdnCj3kT8XEShDc/eFncCoE7OwiGHBGb9EVer8BqbdCbrM5uRXfPJRNxo05iAKyjeXuhq/UH6sAOt10HSvCud2bUJgLNztO8gW0wyd5Xb3JnoQRH+NFfr+QwZ2WDD1QoIWdQlXrqvOx7PWImytSl5zqyVYlbom8y/ddFDVfxztcEwMkixcfRZ9BgsLKGN080KQsdiupb0LRHPT3JtEJgudvt/ZGliywbwjIbtyFP1+rIDNBXKUGD
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(136003)(396003)(346002)(39850400004)(451199021)(478600001)(54906003)(186003)(55016003)(71200400001)(7696005)(91956017)(6916009)(4326008)(66556008)(66446008)(64756008)(316002)(66476007)(6506007)(53546011)(9686003)(107886003)(66946007)(83380400001)(76116006)(41300700001)(8936002)(5660300002)(8676002)(122000001)(44832011)(52536014)(38070700005)(38100700002)(2906002)(33656002)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?LI1xrEisCy0jx2OLr/GaiVOBF6bvsqgchQB+h6FIp92uvztRjWKdjpOB1V?=
 =?iso-8859-1?Q?s75jmi2yvuFok9XmYYO4+axeuhMCFgMu7rnSrX7ugMSXWFocscQWZ/D0XO?=
 =?iso-8859-1?Q?3nrOGAzdgC/dIz/dxMQQKDzI1Pcs3UjgqItzDcaiJ1qBVujaA1g79fs6y6?=
 =?iso-8859-1?Q?3uyq8czU2tKQZSZ6i3ca1O8gAHe4WT7uTWTZV1FhdoF1ONIwzpwjcfwGsp?=
 =?iso-8859-1?Q?6/Q1B6Nw6wGy5XmDHsu8fxzj5Uou/NZ9Mdh3c/rQcGuF37rKdZNNVHowKq?=
 =?iso-8859-1?Q?Qpo/5ja7rnlJZuI9NmWMaXTTRnqkJEfVNy5X+Y4+9XKT2KtP5JM426/VTo?=
 =?iso-8859-1?Q?Ap6+ZsXUSB+5hDPj43lO37fr9okdRLpzMJXbFIpzeT0FYjZy6l32HgDBNZ?=
 =?iso-8859-1?Q?qKZlTC9QO0Kn7SNuN5Mm98eKHMfRYWFZTxeg947T7ZuadGve4BDpO+n3zU?=
 =?iso-8859-1?Q?SiDoqHU+avhlr4WiHPZf+paSsS4m0D4EmWsMACL2x2nQ9ioZww058Cl+xa?=
 =?iso-8859-1?Q?+yVVJBfDVkgWE+y7feFcT0EwWrIdnrdU1VvqTQPMJ/0GJa8ONKnr15onsA?=
 =?iso-8859-1?Q?jnXgl7iHVaQGNxyOb2FSrpe7qod3nE2IKCYCPc2/usdhNkVblLGVZq6k2c?=
 =?iso-8859-1?Q?PLwOBdyVU1pjcIC8uYGyYV/IkseziTxJo7hP271dEbtLt02KLgNEm8lGTA?=
 =?iso-8859-1?Q?qnirbFSyPfTBHAnJkGHCwEFwfuDMrVvupC/gM8rjK4e1CMEnXcPP44KHLK?=
 =?iso-8859-1?Q?82ZnpvmtZJqWufpiZEc4dDGNGM94oXWJrebbksYMkAdlq+uSbvcuAqpu+0?=
 =?iso-8859-1?Q?AWe42RFKHuTz+toxWHOTcuh0xkwolKscfN/kH1TDdxXQGxwmIZOr2X8aWA?=
 =?iso-8859-1?Q?lQ54cfPaQvuMaopb0Yww6iYqINT/OlySZwENQozFaEyyzfx1thoL8m41fd?=
 =?iso-8859-1?Q?/HxY0BuBjojhRH33SZ+k5OOGkpqT+gb0+cU/LWpjvJYJ05FzSddjsAlDJy?=
 =?iso-8859-1?Q?UgkYF87akOACmkSEtr4SlVnkY6ReuqzvDpnFzr4ihr+lVvP0fcLc3pSaiH?=
 =?iso-8859-1?Q?KXwMpXUqRBJKNdZzV+KKoGjJlCI9SEaRXxXTq+Z8jhpdtVLBaiTgToEUfa?=
 =?iso-8859-1?Q?Ce1CBDkoP802Vw5tyxry9B0vmNn9B4SJAyIkBOZx57i8LEYFYd1qrj9yz1?=
 =?iso-8859-1?Q?Z/0lddBvILIVN8sJ2GvVOxHFZLvfezUpgRqrWR4sVkyoz6vLdhTvuTI34Y?=
 =?iso-8859-1?Q?4IJP0VT7Uv0fMG3zsL0Ruxratsh8+DY4ypqnvSZrj+4Y0AUIWxL6izqw7S?=
 =?iso-8859-1?Q?m+SnM3Yo/zAdX2jVmxwA5A41h625KTwsK7drday/mK7arN5AaP9QV9/ZqS?=
 =?iso-8859-1?Q?kefRDq5Nh9s6KBwYi31D0iTUY2CX1i3j/Y+JSl7mTrpfcmas99Hjuj8Q30?=
 =?iso-8859-1?Q?4Ql7T7Swq9UXpo9ueHCYF9te4O7Gg3KqCHnApiv+UFgAqlp28dAST3ddz6?=
 =?iso-8859-1?Q?35RUQ7F0nMpOg6rZs4NF6ZeKwy/bLncke3sYyFg+OBzkW8l9moBr33RR+y?=
 =?iso-8859-1?Q?Ir8+/j8wGNYv92v2NmxL2/Zh9s//8GeEWlnOyWwYk2eDNTGQc4Qlq6Q21A?=
 =?iso-8859-1?Q?XYefwKrXlYm2bkIhRbiJqVG08V/coj/fBvgiF4Q8eZYnU0D5TJxXPdmZ7A?=
 =?iso-8859-1?Q?PDH4jBp0vuK4xnaPMS2FyMRETf1cGy6HdgMdmits?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ekinops.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PAZP264MB4064.FRAP264.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 82711abd-cd5c-448c-26b6-08db4ae43b11
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 May 2023 08:07:10.6983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: f57b78a6-c654-4771-a72f-837275f46179
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: laqiwb+TBN3Y19/15WhYlwswc60vBuEfnMcoP5F/c1Hd6rB7IVyT7PpNvsHjNLWzIhivLZ6nWAOs3OEYLPsyTA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MR1P264MB1539
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thank you for your response. Regarding the proposed change to=0A=
the mif6ctl structure in mroute6.h, I would like to clarify,=0A=
that changing the datatype of mif6c_pifi from __u16 to __u32=0A=
will not change the offset of the structure members, which=0A=
means that the size of the structure remains the same and=0A=
the ABI remains compatible. Furthermore, ifindex is treated=0A=
as an integer in all the subsystems of the kernel and not=0A=
as a 16-bit value. Therefore, changing the datatype of=0A=
mif6c_pifi from __u16 to __u32 is a natural and expected=0A=
change that aligns with the existing practice in the kernel.=0A=
I understand that the mif6ctl structure is part of the uAPI=0A=
and changing its geometry is not allowed. However, in this=0A=
case, we are not changing the geometry of the structure,=0A=
as the size of the structure remains the same and the offset=0A=
of the structure members will not change. Thus, the proposed=0A=
change will not affect the ABI or the user API. Instead, it=0A=
will allow the kernel to handle 32-bit ifindex values without=0A=
any issues, which is essential for the smooth functioning of=0A=
the PIM6 protocol. I hope this explanation clarifies any=0A=
concerns you may have had. Let me know if you have any further=0A=
questions or need any more details.=0A=
=0A=
Signed-off-by: Ganesh Babu <ganesh.babu@ekinops.com>=0A=
=0A=
From: Jakub Kicinski <kuba@kernel.org>=0A=
Sent: 29 March 2023 07:44=0A=
To: Ganesh Babu <ganesh.babu@ekinops.com>=0A=
Cc: netdev@vger.kernel.org <netdev@vger.kernel.org>; linux-kernel@vger.kern=
el.org <linux-kernel@vger.kernel.org>=0A=
Subject: Re: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32 =0A=
=A0=0A=
On Tue, 28 Mar 2023 07:13:03 +0000 Ganesh Babu wrote:=0A=
> From a91f11fe060729d0009a3271e3a92cead88e2656 Mon Sep 17 00:00:00 2001=0A=
> From: "Ganesh Babu" <ganesh.babu@ekinops.com>=0A=
> Date: Wed, 15 Mar 2023 15:01:39 +0530=0A=
> Subject: [PATCH] net: mroute6.h: change type of mif6c_pifi to __u32=0A=
> =0A=
> Increase mif6c_pifi field in mif6ctl struct=0A=
> from 16 to 32 bits to support 32-bit ifindices.=0A=
> The field stores the physical interface (ifindex) for a multicast group.=
=0A=
> Passing a 32-bit ifindex via MRT6_ADD_MIF socket option=0A=
> from user space can cause unpredictable behavior in PIM6.=0A=
> Changing mif6c_pifi to __u32 allows kernel to handle=0A=
> 32-bit ifindex values without issues.=0A=
=0A=
The patch is not formatted correctly.=0A=
Maybe try git send-email next time?=0A=
=0A=
> diff --git a/include/uapi/linux/mroute6.h b/include/uapi/linux/mroute6.h=
=0A=
> index 1d90c21a6251..90e6e771beab 100644=0A=
> --- a/include/uapi/linux/mroute6.h=0A=
> +++ b/include/uapi/linux/mroute6.h=0A=
> @@ -75,7 +75,7 @@ struct mif6ctl {=0A=
> =A0 =A0 =A0 =A0 mifi_t =A0mif6c_mifi; =A0 =A0 =A0 =A0 =A0 =A0 /* Index of=
 MIF */=0A=
> =A0 =A0 =A0 =A0 unsigned char mif6c_flags; =A0 =A0 =A0/* MIFF_ flags */=
=0A=
> =A0 =A0 =A0 =A0 unsigned char vifc_threshold; =A0 /* ttl limit */=0A=
> - =A0 =A0 =A0 __u16 =A0 =A0mif6c_pifi; =A0 =A0 =A0 =A0 =A0 =A0/* the inde=
x of the physical IF */=0A=
> + =A0 =A0 =A0 __u32 =A0 =A0mif6c_pifi; =A0 =A0 =A0 =A0 =A0 =A0/* the inde=
x of the physical IF */=0A=
=0A=
Unfortunately we can't do this. The structure is part of uAPI,=0A=
we can't change it's geometry. The kernel must maintain binary=0A=
backward compatibility. =0A=
=0A=
> =A0 =A0 =A0 =A0 unsigned int vifc_rate_limit; =A0 /* Rate limiter values =
(NI) */=0A=
> =A0};=0A=
> =0A=
> --=0A=
> 2.11.0=0A=
> =0A=
> Signed-off-by: Ganesh Babu <ganesh.babu@ekinops.com>=0A=
> ---=0A=
