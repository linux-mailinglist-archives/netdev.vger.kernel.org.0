Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5292526AC7
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 21:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378150AbiEMT5f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 15:57:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349451AbiEMT5c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 15:57:32 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2119.outbound.protection.outlook.com [40.107.114.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAE4C5D81;
        Fri, 13 May 2022 12:57:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nJBgSwshcuyctcX7GoOznCqcw2fYlgzCqwxDWf8R0NhJMSw5Lq5fyBgtAdiBPWwrj9KlWmkZzNx0lLMiht0qWYwL2vzRvH//dD4+dHyA+zCWj325dqJrzhk3lw/6xEat8pl5YXh2iEiEjcmnCyB2rNZ2pA+SzPv6RSP2KS1Ys/k1+esNRPyiiuS9k0DG0V2tyEaeYAYSQJ9EwQA6f+ka2o9Rc8X6SxqXOf28FDVn//txJcs3xA9hY4XZYpaJSMFLnItWtrlX+R9sMbroc86zn6fXcWC4AU272t5WuCbbBAZgW3b0ShegXURmce4B9Y5XTbG9MWCnHjphU97CcNN9iA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J5OY3ikBQUr4o2Glpj2dm5OFFW7d157PySj/REgIJ00=;
 b=W+O2uYSllDrcacuKkW4e+v0Yyw/S4GkDd7FeERmzIMrAWeiNTl0vXUXAmT0LmAvx+MNG99VIPBDFCBDbs6Za8j+Vil9p8soNncq52mQU/ASur6ulCeq6Kkqt00Jd1s1MM9zP4xdASYqp1fv/9uz60P6XZmIgQyK+/f8rdng2oofj2F5LDUWL+958p9mDGMvsG6zlFIxZjQ2RKaJVn/wfvviglnY6fHX7oxOC1oL+jhXDwk3j1YszNxVf4Qll0K9yoip9YibjHQXG4ZUgZeu5MrRMSGtncYC8KVEOOFgwCjIICrUcEFMQqhqQzJoRe5L1Bf98fbif/Qsuehf7M2DfIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J5OY3ikBQUr4o2Glpj2dm5OFFW7d157PySj/REgIJ00=;
 b=QjwI3cmd748/2P308kqOmF9cO+ZVFexT01VerVqOfCXFj+0GYAZBuoKjbPDKOZPxpIZhQv5w9l9YuqXxOlnxTtWODEe+scD77hKs4UE0+SXLMnigswp8t0R+ciBTu/+LK+VUECjUhG81B2H82yfE1RPOLBqimWehmhZ/blc4f7o=
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com (2603:1096:400:ae::14)
 by OS3PR01MB6920.jpnprd01.prod.outlook.com (2603:1096:604:116::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 19:57:27 +0000
Received: from TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::6965:ec42:82ea:8492]) by TYCPR01MB6608.jpnprd01.prod.outlook.com
 ([fe80::6965:ec42:82ea:8492%7]) with mapi id 15.20.5250.016; Fri, 13 May 2022
 19:57:26 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Thread-Topic: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Thread-Index: AQHYZUL8ldsZ7eBi5U+Dt1LHv3Avg60aZmgAgAAq2yCAANe4AIAB0pmA
Date:   Fri, 13 May 2022 19:57:26 +0000
Message-ID: <TYCPR01MB6608DC38FC74BB484E2B6079BACA9@TYCPR01MB6608.jpnprd01.prod.outlook.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
        <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
        <20220511173732.7988807e@kernel.org>
        <OS3PR01MB659312F189453925868225B2BACB9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
 <20220512090300.162e5441@kernel.org>
In-Reply-To: <20220512090300.162e5441@kernel.org>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f7d8c71a-0f99-4f44-7eca-08da351acd92
x-ms-traffictypediagnostic: OS3PR01MB6920:EE_
x-microsoft-antispam-prvs: <OS3PR01MB69202CA6D8B2AD0D0119E415BACA9@OS3PR01MB6920.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p7wOLBM3hVNxPCQD0q/LYOQpckEDdwYqYGcyfB/RkMIawOVVxSntjt2nq4Ib9csZj9lvKNs+ptYr5nxlGpeAtDNiWTOzzdoNWKio0KzQ5xPmQENnbZgs89nfBK6pyP71jHeNSp77eg3/IKDrDb3JWra9V/yrJwAkHd5sZCS3IzvbjLPRo7CVvwQS3D65hW4cCqd0f8n3T9TT3bZjoO95QBZOoIKgsiUHoeRzHF2UN54mmgmkZ/G9pvau0vSCqzRi5A+rLwbyNknzXToTBxurbnbhDPaLkdI4M/kJAm80Wytn7ZM7O+yKJLxojupbFi8mwzbjSxX7PDlI7ylFH0f66Nia9jBw5WOiJa9KHQOuq2dlssixKgAfUVlkI3iH+eyaBLS0nMuPwu/TI+hxsgr7FyWN7bJA1kxbRL+BfQHO77JjEbuW5V8mxVjQg2RQBQlHpth3AYsHDtNvLtHQ8E1SscQ7snVpnPeawfYnvro8c7of4pc/1shEEbS0thlCnAeBj9KfSCZlxnFTCh+xZG9PF9pdPBhNA5Ou07kBi76mfzvfqxOKv95QL6LD6W4lhfW0cZrugP7C9ZFkzpyJcnagg012ll6oepd5H9+3MKy24u+mjAW3JQi6VYub9pH0JxP/YXC43lVz7ZblKWeR0NDdOIy2vkppLrsV63iXhqsXIepzIUcwb4LwxgK3c8D7S2pqc8ilbkggiY6aEVQ1ImP60heN9bDNaX411/W0g0VZ+RT/VeyGpv2/FWVD+z7DC2F7gz1ZI6plxqrqJxyDJU+94aVu3/nJf7gktTXVfg9aXnA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYCPR01MB6608.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(8676002)(66946007)(86362001)(9686003)(66446008)(66476007)(66556008)(64756008)(186003)(4326008)(316002)(2906002)(6916009)(966005)(54906003)(45080400002)(83380400001)(26005)(38100700002)(33656002)(38070700005)(7696005)(52536014)(55016003)(508600001)(6506007)(71200400001)(5660300002)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?7wuqa6UEZhxPGfO8+UOgmxiQgUheLyicYotzCsa4fmAH7gtjzZcHmcZh3XMA?=
 =?us-ascii?Q?quys0o3nR+Fz2Uabd648GNtM+QQnRsGKbV8zf33/AorzFveRynBj4Sd8Ueh2?=
 =?us-ascii?Q?jNSGREss0lkyOoOOCxJ/wLDX/obz5D01SWPtfb6GBJhGIxgGCeIJmnhT4Fes?=
 =?us-ascii?Q?OFzQo228+yd4yqGnNs+QOJTr7BF2QVooP7GWwsAP8lPpz/621TR17SaKQxLn?=
 =?us-ascii?Q?uIotQky5dvqd2mHq5wEvUKyOQ2xDVjYlubUa+62VOYmwPoH71Ext4VM9/VYo?=
 =?us-ascii?Q?F58nekGC/18F9ZVjasaNosjgD7ingH0N6jew8HzjIwdRjDkNWNVDkzZdtG0h?=
 =?us-ascii?Q?qf595AqItVA8Z/R+eIqVYTCEcAtbn+WwWYE9LTFbX0BJywsEYa1/cIInYNnl?=
 =?us-ascii?Q?KOHJgS3mY6G9HrEx61EIRzlOMEhVOJFgUj21ugYSlSieFt2rjZMfM6bLxAcd?=
 =?us-ascii?Q?7g98paZlI2D1mVm11UJmUWsWCyRjkYMWKPH4PKBNT/HWloIWBofsExZBHIAx?=
 =?us-ascii?Q?gTWehQu0tyWSWGZ3Mbe+NKQRk8NhyxPCngfjOqnDQn6l6i/s3x68p48hJc4R?=
 =?us-ascii?Q?7RJHVQVrhXhNshquCe3E1wyf7NDfM1YS4lQCF/8lLCqp0pjnNpVtPm+CSnvK?=
 =?us-ascii?Q?fLQslUvl+VT+AUdgdAaV9FuDvSNC/3MG6G8aJD1+lgcchSvasxD48TBM3MAD?=
 =?us-ascii?Q?kdjPP/na2tyxQXdrBfcIFneKiUvzYG+Rpbza4F+SX9JAwzC/NtD5/lCU2vY0?=
 =?us-ascii?Q?LLHUsx3y2NrvEpPduQmiBaZL2SjiCi8uP4YeaaAflp3a8uwO9JrETrUyFIJG?=
 =?us-ascii?Q?BRgtzufy4l3TJwGb750678k3hbYM9hAP6iNqinsPTHzRVO6ruM820hcmqjyW?=
 =?us-ascii?Q?bddUgMS3UtZF2oT1NqgIJfIy3HAt8TiKFdaQy23rxNIa/3lI5HVhc8hT3SkP?=
 =?us-ascii?Q?3iZvh+VK7b29iDcE6W05OhfGf1fIhUiXtYKQ18MTD5Dy7n2AOw0MTey89ySu?=
 =?us-ascii?Q?zHF6prR1sF5Z0+QxRlu0YKZXFhKO9tDV8JS2kKYhjM23wdV9I+L9dJs2vyDh?=
 =?us-ascii?Q?xKiCCDUzzamG33OJnaZQBtxpMxoAP8Goz5sd8Rgx558/woKzalGQMqsHYgeU?=
 =?us-ascii?Q?61Pb8X2cIO0r0pmpQvXr03o9LQEZ/p+/sOKeEmv+YQUedQDh4/dIdHZzETtt?=
 =?us-ascii?Q?PuO9/XjS7kh+VUsCX2YFXQjGHIfvjOUaFdHYmIuohAX5abAGBMBAsncNgGxf?=
 =?us-ascii?Q?8tN/ubkR7NTDTBnCDOouWqpqEgVUYxxx860tGUUgvTSsDY7fHCOVWwfbeFjV?=
 =?us-ascii?Q?ZSmcwX3Q7v/lYsGh/r5O/7Cmwkg3XuU3SbtHwQ7zVrB+ntKv9wp1W6jmS9DC?=
 =?us-ascii?Q?gl8nsU51HvCCx2ipIW+ZsjHFHVXpPnLNZ0ojfiTn98rwoyK5G/RACZovEv0a?=
 =?us-ascii?Q?NLMqN6fGj+hjAS7LRAbhOOfwYdn4aAd//ICQ5u8a++3oHbZCfjmcHraI/Kuu?=
 =?us-ascii?Q?CVJTVKLVfigDe9HmP8nsdmd/A1t1uGFsfV5MW0zAFbz40rYgt2VqthPaigMC?=
 =?us-ascii?Q?p4KGcdtDCTARfxylBs8bHvlxpFdeXUqiyomjMM3vz4Nki/GtRWkGsIrh9FCV?=
 =?us-ascii?Q?rQA5RzY3dup6hAz9EJyY/AgtYdPxRhfWhN/WpXqrntuxfMtVgcoNq9IFJGjS?=
 =?us-ascii?Q?FrvGkNPoN2N7g6UWqc7KmdgWskAuFzVy4Lf7zKM8aA+Bh10MWqjEqtuV/ETK?=
 =?us-ascii?Q?en0IxaCNRw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYCPR01MB6608.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7d8c71a-0f99-4f44-7eca-08da351acd92
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 19:57:26.0542
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sTD97SF6KbaO2lU0o6+F1/qaHsi1GNePSogjVcIG6LhAecnTWYJDrE8NRu41fCZhzfqkgydM1VZ+RBXQLDdCyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB6920
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>=20
> First of all, I don't understand why you keep sending these patches for n=
et.
> Please add more information about the changes to the commit messages.
>=20
> For the formatting I was complaining about - you should fold updates to t=
he
> code you're _already_modifying_ into the relevant patches.
>=20
> You can clean up the rest of the code but definitely not in net. Code
> refactoring goes to net-next.
>=20
> Perhaps a read of the netdev FAQ will elucidate what I'm on about:
> https://jpn01.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Fwww.
> kernel.org%2Fdoc%2Fhtml%2Flatest%2Fprocess%2Fmaintainer-
> netdev.html&amp;data=3D05%7C01%7Cmin.li.xe%40renesas.com%7C3cbe9c7
> 3bb2e4e4765d608da3430e6c8%7C53d82571da1947e49cb4625a166a4a2
> a%7C0%7C0%7C637879681870307714%7CUnknown%7CTWFpbGZsb3d8ey
> JWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D
> %7C3000%7C%7C%7C&amp;sdata=3DcYeTkW596blMW6amKHFPk7cgv9G%2B
> R7%2B0zZP72DJebDA%3D&amp;reserved=3D0

Hi Jakub

There are multiple places where "no empty line between call and error check=
" and "return directly"
like you pointed out before. Some are related to this change and some are n=
ot. Do you prefer to fix only
the related ones in this patch or do them all in another patch to net-next

Min
