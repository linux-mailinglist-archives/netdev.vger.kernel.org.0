Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B67E14FF866
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 16:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235847AbiDMOFy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 10:05:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233591AbiDMOFw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 10:05:52 -0400
Received: from IND01-MA1-obe.outbound.protection.outlook.com (mail-ma1ind01olkn0144.outbound.protection.outlook.com [104.47.100.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A007357148;
        Wed, 13 Apr 2022 07:03:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d6zZ22+jpeSRHnfDB90wsKjXIGEKgawe9K1hdnUct9753AqQxcFbHOYi2u33+Iisalg6xwmhcPPFVWMvuZyZ+aYEUlWcnK9256DDjj/LmuhNDji5Kkkf3h824QNzkBS/rkOoTqQPnzmRar05iMoioX/Zl2MKm/WPTvpL6LZFkJX7DnQQ0g8KniWXiBF0FOK30W+jqo53nNuET6YeRBMKJu5UmPDRaRscifvMj19dN2bI+GjjtWn8VXPoSD6/lod6CLiHRqkunyUVl03TscP4ooUit9bc69Stp4rIVSY6SYBkN/GlzPsDv3T53VJegY0DsmRBH4/cTduKJZZup/2raA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3e2qrF2VbRQ/dWfra6k56oNwbx/wmLRO4XY3GZSl7Uw=;
 b=Q69OwgoiBHW9oXDqEqM615IWnx2HEg9fLZeGNZ2+x/Y2g1yucJa+QPCrF6+ZRUBRFLEShmsNzbXA4OW4yeQt+CV3rnV/v3dGVYxUeKxXTtTAzi7OIKQVkrJikXmZ+3mGnk21fJ3Di6D8sVbi9+c+zTf71Nj01eFC/RI5PJeKIgBk/ROA/8B1jsNXTKnP8Ky1rsYA/u/iXTheXjjnfjOa6Hni8jc762U1kLmwemc9Ar9U847KX2qXL0H0NUuPNMUp6T/aGbm7AIOJAV/j4qaqgRud38usmb1pBs+6tBigkHCPjZkHqQaOZYvKVzmJ0yTx0HuOacDtApLBkVism/868g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3e2qrF2VbRQ/dWfra6k56oNwbx/wmLRO4XY3GZSl7Uw=;
 b=rkpaD5OA2286ck445pCe/kw+D91Wal0K+3m/YwUg9G+8dcitxhZL6Doh9YZyls/76WP1zTQJHAWAMkBVXEl9fNFcfsP5HSme9HatZaW/h5A0xiFxvFJX7F2r6I+bf/A5HFDFlpW3mc1qs2cR0DjE3qyg2fVl//ZDkD4L/JVsWdzc8oaHNrBwG0zsaAvbn3dRTKjWPSnBu1Niy1XFZqQVgaazluxC8s/vA8XEW5ejZK/JRIt4yHDuQMlWBJdYEE6Fj88gA2gOQq2sfWi17klmFQAjBaVNI9sjibeQNCg6Cabw6YKZtVI09mJ76nLpQv+soG6XdUKGNS6bro+Qtl6ZKQ==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by PN1PR0101MB2045.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:1c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Wed, 13 Apr
 2022 14:03:22 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5144.030; Wed, 13 Apr 2022
 14:03:22 +0000
From:   Aditya Garg <gargaditya08@live.com>
To:     Mimi Zohar <zohar@linux.ibm.com>
CC:     "jarkko@kernel.org" <jarkko@kernel.org>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        "admin@kodeit.net" <admin@kodeit.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v4 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Topic: [PATCH v4 RESEND] efi: Do not import certificates from UEFI
 Secure Boot for T2 Macs
Thread-Index: AQHYToykbBmBCQ6Dr0qfXL8vw1ISnazshQAAgAFcXAA=
Date:   Wed, 13 Apr 2022 14:03:22 +0000
Message-ID: <A997BDE1-BA52-4974-BF6F-EF086ED7779E@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <6545f8241f3d41dd0f55997bfb85ad0de9f1c3e3.camel@linux.ibm.com>
In-Reply-To: <6545f8241f3d41dd0f55997bfb85ad0de9f1c3e3.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [bBikVXLTwwzc70E8fmc31MQAdIJlqREd]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f54c36cb-4082-4493-6edf-08da1d565f3e
x-ms-traffictypediagnostic: PN1PR0101MB2045:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: E5bYQHrOEo9z1CpmlqC/mAIfQMRu3DXnpzdFP1Mefjlm90wN02T+MLl+xIwm5ty9aqSkhbFrH8EkUf0NnXgzEWwUs8y96NgFSgdAnaaA11qAxuczGSHRCR1mjGvO/ZhIbGfRyFqk0zEedwoQzY0A9s/SMuzo42Fj5fryGCXF0wYoX3cH80DceRVTXsVqhN443LfsM+7ZWC9JGPtXrOvRWFCVDJ0gUSCaORb8M6qzoH2HtMALcygmdomOw3GTNRsWjlfy+r4wWQgHnPMdS2ViympRsjL13jLgnp4YqCpOMoB/oDrcvibknkKUZwc3YcYaqKERnJsAp79zN3x6TXiHIHA40vrecVK4rbEPo5696aeMo1GzoCsYWmISxt3CQLkGcUQ+QWAOURguUZ0AleeCD73c2we9bVJs6siHjpICUQ3+Zy34VaXVW+qCZF+CsHY4Hfzt5q/vIUZmN446dPvL36sdr6DE6OhiLevdR/wc0g3Ol7CyfJSOgwp/X3vt2Djh/EdwvXRGKR7Jc1YbjsxWeodSyb2j7s2DCX8ovv5CI1tvLB2PXUQFqzfulPRz5oGb1tvcFqCruVZfSl3vMe8KLQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Nyh9UuIfp/T7ruVHQHwapwoeJfawRmXj2WvxfCdaCHKS4AI2zU1FC0pw8WmK?=
 =?us-ascii?Q?tPShHhCeVPVBWgbSljw2eLO4OWtypTVQbKCsF67ZvDOPaPRSQRqAK/6jZKbq?=
 =?us-ascii?Q?Li/izdPQXYfH26O03VPJ+8vGIQu+ozu4HliWLhcUC/ueq6/P3UZ89k6bXrbG?=
 =?us-ascii?Q?UCsAJY6TBbCjVZZQ5TnfjRlWpnUb3PRa76boKT3GZZ1NZsaLx+gYOnAaK055?=
 =?us-ascii?Q?3AD9pNY+V0japjv3qaz+NZMdGzQA4UoPnCWXimD5gYTa9rCYOg1J07/87/yd?=
 =?us-ascii?Q?0wKtBYEBOamh51cIt+1/BrX8uJudc6R6wY0CtyEVlkjxsBT397hTmlAMVy1e?=
 =?us-ascii?Q?Mb8ViCCvKc/GKf5aADegltlMJgqeB2DuN2sDPODUWIZBpsEbfiMprMnfn8gS?=
 =?us-ascii?Q?loqkx4dgwA0Vr2rgJzkD9SMMV95gHY+rjxarhNObzA1nCEz1tpXd11rL8U1m?=
 =?us-ascii?Q?WRiLvTKqgm2o7tG8UyopWOYPKjfXNya5E8UYNiiOXGnVh4m5bLRtuliUd8IJ?=
 =?us-ascii?Q?fRo+90zeFfsu4GaHUy+dNYvrEh82QDkZUJJ/7MatbRskgJVFb3OilFtQ8Ryu?=
 =?us-ascii?Q?h1fLCRAHakO8UB4ZSsu8YS2TohuRnOZsKHrXCR5hg3HIi9Sa0vwKuJpqSwyE?=
 =?us-ascii?Q?2DBDWhieK2QShFg+U1PrIFt3cdVhUzdBrtGP1G0a2L/GRBqUHRexsxUcmaqV?=
 =?us-ascii?Q?4FW6CPGT0673Xe9il3IspdbPW4gM5cUI0brhDaTw5zcNGrVH+Y8nxy4pO4zx?=
 =?us-ascii?Q?j36fdD3lCLVSs98y7TPDiox/GgvXVMOcsa1Hh64t9VDdfc2ieRfkaVbX2mRd?=
 =?us-ascii?Q?RDYfwlHct5kRL3+kBoYGOoWya9lx0dryT+nkJBqfnDwRuTkyvBzTIKX7vJVP?=
 =?us-ascii?Q?U8XjxtwCk1n6V+fxtfaV2H+jdbD9/E+0Uw45gFWlJrrWF3rO/eqVDXpL7hW7?=
 =?us-ascii?Q?SjCnE1EmSfgpowSQeAE2X4B8lkQClTYR3NydUWeGnDiQXswXxWysgVZlfkF5?=
 =?us-ascii?Q?+8PvAw19XVUf15ICJX45woOzxlN46w7ed0QAacE7ZFqEQd1eqYrBtEr0ldc9?=
 =?us-ascii?Q?+aATRVAPcitvWP8NaNIg207NM4woQNBV2Xk8wUhX95bOiIrIZwlw/XVMQrbS?=
 =?us-ascii?Q?rjN6lIMzfuc3hDDa1Ie70tprHQxKTTpcFDs5L+fkw9PXRgVk0piCDpAo+o3R?=
 =?us-ascii?Q?YvXDzriTib5DZwVCrzWlRCzt8HDX/AYW9HF/QJp7MNgSauNY3NVTGFlAZgSc?=
 =?us-ascii?Q?B9gi/tmlTYWL5L5R35tb7EpMQl0Mz/tp55Nrtz17Dt4DzluXXkjOBapAstFU?=
 =?us-ascii?Q?2mlF7IrAweu2/GWEmP3FY6oCgiP9+reHsU4R+il8jq3TANUoF89aFI/WC0MP?=
 =?us-ascii?Q?2mf6k/KlWG2gXn8Kar/wWzZYme7wzmK9Q4rnQoP5hQ6q2UkRnS36fmzZA6Yj?=
 =?us-ascii?Q?3O4bSMWAOkc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BF4835A2D061724C81996A1E2916CFBC@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: f54c36cb-4082-4493-6edf-08da1d565f3e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Apr 2022 14:03:22.8041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PN1PR0101MB2045
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> Both the comment here and the patch description above still needs to be
> improved. Perhaps something along these lines.
Checkout v5
>=20
> Secure boot on Apple Macs with a T2 Security chip cannot read either
> the EFI variables or the certificates stored in different db's (e.g.
> db, dbx, MokListXRT). Attempting to read them causes ...=20
>=20
> Avoid reading the EFI variables or the certificates stored in different
> dbs. As a result, without certificates secure boot signature
> verification fails.
>=20
> thanks,
>=20
> Mimi
>=20
>=20

