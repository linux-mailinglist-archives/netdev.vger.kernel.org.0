Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01A1E502E25
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 19:02:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356065AbiDOREr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 13:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234657AbiDOREp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 13:04:45 -0400
Received: from IND01-BMX-obe.outbound.protection.outlook.com (mail-bmxind01olkn2057.outbound.protection.outlook.com [40.92.103.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AA2A55BD7;
        Fri, 15 Apr 2022 10:02:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJ+EOdVBenrVtavvemtbvu7g4LnvyMbpf4Fwg+bxgT/nnSmCoE4iZrMnKWrFZILFmzT/iHL1F763RJSkUkIfzR1MiAkJh4FzDcCLEEAVZh5mgkh6+x2F+uzInJ6uTAWw+13g+tiE5CrSSJDsz5ZEWluVILcYmPJPqb+R498vO85+y+OayOGpRjZtvrrbk0/UpKJgtF4gKI8/oS+Y2PyhJFf7g7up2JLJzR0xT1Cla38RLAqhf3zO1Xwe+OJbmxMjX9SjkrhWQNpwZriUHOADqEspOehjILUosF1/ShaAJY2S0KK0EAyZbJr6Fw+9kKnziy6zM+ZUEnfPQKh1CCh1Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipZ05THe8gawDYwRcTsPWhEbAOurKQybfhkIrn2V0k0=;
 b=gYwA5y/iG1bJpkOrS461S1C1ppAwBuq8vJiKJqjfB9QsIIg/5eY0uyjPdxBsqVsfK9Ybckg1AtQZ11Tufrlg8Lyn9F7FJ1se3FFwK2kcKYHAL0eSd51DpwpALAjSnHhe2mcJR8l/JRd9sdrPUMLYZLJtC7ubObnwe0Qi67ebBipQM5TJ6Jg3k3AcmyCvcGgu6dek4GwaGqGgNhalBQRZKajJ1RueTLIjjkJ1EYDKjBj30ZgVMlnn5iDFRR5KSp63QPioxOqJnnZGf7imqCiqApYDyfo8a+IHAApXAJoeDvlkQ2Tnzc8kocwsPmx84n1g9AyqGyiYBXg6N3YNtQABcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=live.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipZ05THe8gawDYwRcTsPWhEbAOurKQybfhkIrn2V0k0=;
 b=tFy/Jg0c6gDmuoO+Vx3PsX8uKT6sRWESzN3yI4cuosjkFJmig8juZA6cGhaj8iYSRc6PdRMAewrILZymKG8lOhGXGN1MymwkdFdzvjGbfeXVigEvCOm8ZR7RYubd0q/xgfKZuuKyvBoL2sjKxho0i7f753f70eKpJphS+7Tp4TAkAIrMgS3O4kiEwLlKzYSecydDO4uaGIT0tlnYPmPWLC8mtBKjgN7tBPBP8aD37Mcr3buarNl9n7Npg33DNS8ahfGjFNPaurBv4HvuodH/yHHUjwTK2yxiQ26d22bVvxehJzzgqdreZbGEOenGZTefEEWHDOSzrpfGGk3ROkuuWg==
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c01:1b::13)
 by BM1PR01MB2881.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:52::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5164.20; Fri, 15 Apr
 2022 17:02:07 +0000
Received: from PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd]) by PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
 ([fe80::dc4b:b757:214c:22cd%7]) with mapi id 15.20.5164.020; Fri, 15 Apr 2022
 17:02:07 +0000
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
Subject: Re: [PATCH v6] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Topic: [PATCH v6] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYUJC2bz3LzFcn3U+BP1sAv+GFWqzxKf2AgAAJ8oA=
Date:   Fri, 15 Apr 2022 17:02:07 +0000
Message-ID: <EBA0583E-3BAA-4916-93B9-3FFF67E637DC@live.com>
References: <652C3E9E-CB97-4C70-A961-74AF8AEF9E39@live.com>
 <94DD0D83-8FDE-4A61-AAF0-09A0175A0D0D@live.com>
 <590ED76A-EE91-4ED1-B524-BC23419C051E@live.com>
 <E9C28706-2546-40BF-B32C-66A047BE9EFB@live.com>
 <02125722-91FC-43D3-B63C-1B789C2DA8C3@live.com>
 <faa20ad9a934269e6292ffdb385ebec2a2475454.camel@linux.ibm.com>
In-Reply-To: <faa20ad9a934269e6292ffdb385ebec2a2475454.camel@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-tmn:  [wTm9BNdXsB+X2jrLCBfDR/R5tW96thryPZPjP7lFlkIengUSy3VLFo4808ITJ3cuKpyHQ0KXSsg=]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 02133097-dc9b-4721-bf4d-08da1f01aca3
x-ms-traffictypediagnostic: BM1PR01MB2881:EE_
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GAtsgk95y/SKS8PMtJWmdCnArahB8nDLBWcnwCgpnHsJLEgnYFmA/T/qzIY48iY+6Urnwfvj1bQgKL8BELz6KkCctvswE+j1lfVu0mOUoY5hdTZQfJsjO+RTOHfQ+dJKwehiMRONAbIcijOXtRJ3RQgkQjsYJBEwxv/Lkiq9DgThSzN9eNgtfm4lfi70Bhk0FwXIMLbCjgoXJ6pcl3pVf7FZFvsniopseqN+TIpGrvGzUQgYCBmS2bc4ow08BDE1gLFdju7hKTpnGgQ0urbiYvnRz/kGVZ3ZKkaxlssxw/cureCxNlx+dArM4j2kxqnaet4y4KTBzE1qPV9Y6RFsc+ugTTFe5QFcFOxd+ju09pg/mDZ16zsPJc0NU2+uih6VWzAdbDbnvewL2QoVY6A8pa1tatkVFkw07I8C8Ds0D6Lt27B6Qk+Ppzd1PFw40gIg20JL/g9RinkyJtAniNDkemxKGSIaO1kwHd2ulLqF71V350/s4dDnFrW+0fHPmjvq8aII46xBheN5s9nNuF2R0TOjazx+cstQFWQBGaiYlZY+PUQRpliyYFlzPeaRCiZEsOBzotmIAoHi161n9PYEMQ==
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?i34670fzdRkGqhw3JqFMuRSW8F+8crPsPIAvy8xTcGFCVUv02Zkx7FEFs1BQ?=
 =?us-ascii?Q?NGDo9hQ863ENpgaRM1HB/r+nfUX1C6g3VRLZ9+xfGrd3MesY3vimA5bP34Cm?=
 =?us-ascii?Q?Eis1FRgjzUVGf1ok5HbSFnAIAOAb2wdHh3WWQgM1Tz605AaeB9O8qmIhjEmK?=
 =?us-ascii?Q?6j+C6l+9Le7auGj5Rp5+BYW+c+olMP8EfxcaWZnoJv6sREJpnH2KaJieiOHW?=
 =?us-ascii?Q?SfYWi4ZDcALBnPTYI0wyYnD0vbYDG856ZtCnOIyTleiwe6Sm0pwFR7riUnNb?=
 =?us-ascii?Q?nP+9nKbV3QKJ+v/t0YcGIUKr3WXeCePtfn2Bv7R7RqgMho0t1sO37WWpWVGH?=
 =?us-ascii?Q?U453eCa9QGYYNr1kgJNjMcS18L153PRmp+fghntG8sRvtnNCXjc+tqXjjkep?=
 =?us-ascii?Q?BLD+0sTpgQMa0i3rOp93uMdf/iCt6Y8s1oNPIwJiCr4gp1RPHKQQEhnpfrdB?=
 =?us-ascii?Q?QZ9xd5J2/V/YLn2hmel6RwXm6RMQpzlUxJD+JPP5s188bSgf3pDi6Po+2XN8?=
 =?us-ascii?Q?ANdM/72kF25SUCBuANkvQAwbi5zCrTZyoPDJXp5//+DZ+xYYI4/Z4HclmuxC?=
 =?us-ascii?Q?ThdIqbRp3TqCiYbslIt9qlPqJ5cTMBifTcUGGnzuqd3yu+tyz7/rmq+xvGjZ?=
 =?us-ascii?Q?Djx140H7oWoRW87lndmgXP2JvYCmVJEfm9LX6aZ+UwATB/8weNdCkDvInIVP?=
 =?us-ascii?Q?EoyNwzKeMVGyOCeYTcBskwtnUCR2TRoXW57uXaR/taSOp6K4MJxsLgPjdmRX?=
 =?us-ascii?Q?o7IPCwX2aY71QTu6dwi4jL+LWnvGZCQMbfULenQ+p5ZgL3DsCn2NJ9jfRWTT?=
 =?us-ascii?Q?h7D6vCjctDUuAW8130eBWDoisqV+HP/iepf4aP5cWdC1s60omPTONI7w4xKQ?=
 =?us-ascii?Q?rZO4KOWfwFKEvSPcWgLl3t5+BMTxHWYD/O81lU0WAAkiscCYQOKL80FaDdtV?=
 =?us-ascii?Q?f2veAKloNl2+WhA/VUhEylj9xdpytDYde+QH6lJL8QE6wj/WOIp8fKu6LDaw?=
 =?us-ascii?Q?Sh8A1mbf8e/urGODX7IbzbtSNOtlcVggIVnGOvjfXQK+qbuv3mxKPptCeBU4?=
 =?us-ascii?Q?RHNj3sLDKUQ3TT7Z1OoXwbA+u8y7ltH8/XhP5rIFW32RXWy6jQ6g4S6eHlTY?=
 =?us-ascii?Q?kDM6ZIY4ptCxhTAVouyF/yqoBHolGlosxYLdnc+xLRLITxoGdf7tjxtst/LA?=
 =?us-ascii?Q?U0ydRRktA/2I6mXFdlimRu/GSIfyEoEbzJCLNnMSENbJaIyJSdAi6ozkQ/A1?=
 =?us-ascii?Q?dLyhCmCCvo4BiG1gabgQ0O2oKQDlBBCHsq1x/r8VJXq45cM+u598HLfghlQy?=
 =?us-ascii?Q?goTgpV3icvyXtacVDiOutbToo6GI7fkm0U59oAPh+hXWGIwSfwSFxNpC6tcs?=
 =?us-ascii?Q?sXVODKGz4ein8Go90qUz1AhG4be6yJ6VzNdAN/PSW5GrIXgxYvGnbyiJ+Lhc?=
 =?us-ascii?Q?KkZtlXPIaZwRUyqr2f6UljPcq8zfq0R+xGFkM9ur9wSK1vbeBoKZK+S0pw0l?=
 =?us-ascii?Q?eggWsFYj+UvTysggCH4N7Lxuo0tghcpde4lc?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7D6AE25695AD3446BF83071054A6B8B3@INDPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-42ed3.templateTenant
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PNZPR01MB4415.INDPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-CrossTenant-Network-Message-Id: 02133097-dc9b-4721-bf4d-08da1f01aca3
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2022 17:02:07.7563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-rms-persistedconsumerorg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BM1PR01MB2881
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>=20
> After making these minor changes, both above and below,=20
> 	Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
>=20

Sending a v7

