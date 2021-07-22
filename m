Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC0C33D2667
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 17:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232571AbhGVO3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 10:29:16 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.6]:32978 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232328AbhGVOZa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 10:25:30 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05lp2106.outbound.protection.outlook.com [104.47.17.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 687A740083
        for <netdev@vger.kernel.org>; Thu, 22 Jul 2021 15:05:47 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ao0k6lDFFFpW59kL2XIo+GPl2YhHsWjROUCcJWhuVssFX/XeUF5PKXC+4jhyvBSYGoVkmp+F9IGDdBi7tiTWcR0jDDObn2p+pMBclbKzvrNfLsKkzSxXq8rfF7nXHtjhi928+icDFoa9qpDmPYvk6T8SvU1pA6d7RjMGkjRSxDWmR2uoVZkxNTW8m7MAJs71lJRi2xsjxyzq9OcS9ngpWaDPt6TKRFGpqAQ4E6K32Q52WsMctls4aKnaa4DSsTJLyZiXlIwlNwj87WeZEOov+MCEDXfczIgl/+lk+po6NaSVg6VZD5eLdoeZTiyJcvIkVeqi/eDg+92awtKQZwIMmw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rpx1g7apbHQMiXPH4SOERZ5S86Itqk5m+8xs7H3BBk=;
 b=hnq2P4uXMdpNJcUcsxU5bLS/J2f72xFxLC8rHWb3y2GN8Ps6uKV/vwRXi8klM6Gycl+USedNyFBY2TK83hkAmS2CkvEMtuUBR5N5rOltMC+A/FozDGFL293QJNelFrIfvSrZCBJvA5aQWDta22jPyMXl9z/IrOD3dhMd+aUjD7Tc2QvlbbmYlnjoZ5OdMTrBxmc6GRwQ4jfc+maMLM6dZkfjwdyT+gpfDf2z7ldugm7pXEMuHQGEPGYfGPUVkPg8tmMvQCsn72aGXbFTXWVYTaEWBVxJIHsUPWt5aK8vBP1XG73iNShXdXSvx4tURvpnNOXp/LpzJ0iSo+gWyR5DPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0Rpx1g7apbHQMiXPH4SOERZ5S86Itqk5m+8xs7H3BBk=;
 b=gW4kNcwOmX/DmzwtP5ZqjBerm8U4eHaKmpzc3qEfUIZmJe2rt6mSbFfhGiYgagFPF6pJCUX1Z9/8k3vIpWLOtQ3TB8Qc0maD610+8XEeIBJzovJJ/nM2D6SUesejEiUM+iAxxWYV0JT5gJQXhfLPCN6sSKhV1YuVvkdLyXnVkFI=
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com (2603:10a6:20b:aa::25)
 by AS8PR08MB6775.eurprd08.prod.outlook.com (2603:10a6:20b:352::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4331.26; Thu, 22 Jul
 2021 15:05:46 +0000
Received: from AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce]) by AM6PR08MB4118.eurprd08.prod.outlook.com
 ([fe80::39dd:5002:3465:46ce%4]) with mapi id 15.20.4331.034; Thu, 22 Jul 2021
 15:05:46 +0000
From:   Gilad Naaman <gnaaman@drivenets.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Possible GRE-TAP/ECT bug
Thread-Topic: Possible GRE-TAP/ECT bug
Thread-Index: AQHXflb8Wfdlm8Ca5UG3hehvW9cpvatN3pSAgAE61gA=
Date:   Thu, 22 Jul 2021 15:05:46 +0000
Message-ID: <36DE845D-8360-4776-9892-377F4FE18B4C@drivenets.com>
References: <60DDAD73-D59E-449E-B85C-2A79F41C687D@drivenets.com>
 <5CE212DA-0C5E-47B7-9612-4BE6EA224488@drivenets.com>
In-Reply-To: <5CE212DA-0C5E-47B7-9612-4BE6EA224488@drivenets.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.1)
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dccc07e9-7892-420f-48c1-08d94d222f3f
x-ms-traffictypediagnostic: AS8PR08MB6775:
x-microsoft-antispam-prvs: <AS8PR08MB67756CAE4CCB115D8E497F3BBEE49@AS8PR08MB6775.eurprd08.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1adfAE1ZXxsiN8KdLWX8gVI2cC/ccy2ge5oA0eGTanbJA9uQ55bVjsOVUB2iunwHChTjHkUcufg/sgP9jjh1QW4OneTmAPglZQ7Ch3hRqdZXZIbeXKosvqfS1r5YuiiWhXqAWXg+4ovzEOalL9k5U/LCrzvsmnkO3pMWp/uz7ujJBDVrpOntnYRNOqFOKuP5g4gCAMYHjrPegjaXIenBrbi40wFY7FfT7zMsRr4lzyS4DCarBvasGOMYB8iHiv+nrPh4lZWjS5jTGBlL8onMx/LH7J0GUvX26sse2JKaWrIAjrTKyBqNi4bP4zeVnHkw7o3xSfgKb7N5kV6cpx0UKFBx4IlZnBWd/Xno1/txRLY8T5etCqWHodUPTK5JHnMPjiLHMUVxmXUzlrlY+z67pAO502LIyVDwShr2FEiPGZCqoWFWsQSurdXT2AFCapoqxa+W7aBegcK08eJFoMtS+TkKEUrgOFf5RyE4pzRNHQ9QN9A7KODIQ7dtGaVhAI2DcsEJbtZ/sh1muEA4TO5xl54EJ7abxPUYQJ+1sUKyyiKMoum+adV2eUiURFDF3DChFNg/HwsxpGCz0eIvRpCCOzmxViI/HIfLbp/zJK5BxwgVH9obaF3bcyoI2PS9KztNBq5eMQTHSGia7EDIwi0PMZ69AbDtmSj3Tr7LWMFJDp3vEO7Pjjh+IECzxBIC1cjl64FGnapQmvoRUSp41MP8NApWfe6asktaKksAo1bUEg5kmxb+bb/pjWUnRQqOOKWpQIrkVYkEesV1HairMJvYuD13RXOE6jYaBouOnfcjTCS5yaG/aINDQBBfLNujPQ/X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR08MB4118.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(136003)(39830400003)(346002)(26005)(478600001)(6916009)(8936002)(36756003)(122000001)(186003)(66446008)(66556008)(6486002)(66476007)(966005)(66946007)(76116006)(71200400001)(33656002)(316002)(38100700002)(6512007)(86362001)(8676002)(64756008)(2616005)(91956017)(4744005)(6506007)(5660300002)(3480700007)(2906002)(45980500001)(38070700004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hRbm4+BWXnuK028EuffI8Q9mQXLfktgx41F6iHmbdnX4LuHFx6hfXCQgE007?=
 =?us-ascii?Q?NseFL4V2w+o/qM5gmW5FCjDomUm2gOHNRRXKnG3x0IuCrVXbCPLsGm96mug8?=
 =?us-ascii?Q?3GmgzyRebgvdJWSt1ZJ7Uy8d/u+qcdhYa33vvR8sK2tCK75Oc/U0qDVdq82K?=
 =?us-ascii?Q?CJmKSYCL2UpK9nakFok9JZZnpjNBGq3AoKrRtRuXFiPLcxiT48cN5CIDSmGf?=
 =?us-ascii?Q?X0dHzaVZYvh1Az8ueGIim0+LStA8ANPsNh5zdVjePIJNR+a6Tjjhr0+ctsjz?=
 =?us-ascii?Q?6IbyEIMe/XLHR1105fiy5i0OPbdliqKjDy/zH6AhBxOHncQFgrTZyVUTzLE/?=
 =?us-ascii?Q?cub9Uyj7ZV/oAYox5/dSRjMcTYf5Urc2BYsjeVCqO6LO5oJMRRGWP2fdvzrb?=
 =?us-ascii?Q?jQABB7oDi0OsJ9/4mR3zZ21irroSUvBuqmBHiB4esdh6rQ33UkvZt0mAWSvL?=
 =?us-ascii?Q?4P8XZwey+C5InR0M0aWUsN2DSPqUHInY40OS0ZmQ93er2BdvkLssOzIIT5f+?=
 =?us-ascii?Q?ZYoLSdwr0CXfDP4033BGS51DbCctBSDu+TCjJ+RELkEfkXgArvF8YtbOo2HF?=
 =?us-ascii?Q?FDFaWjcPxgnXppDPzhwyNg40SkKpbK4AIAE9wLA9a3vcwrWm9VtOuwbmi70i?=
 =?us-ascii?Q?jlSmHtANFRzE/LHXVI2iO5Xkz4cyUx35P+nD2hM4NjWWJor2xyMThKep5Vmo?=
 =?us-ascii?Q?EAiH0Q7T8fcROXQ9rE9w/KvufmKyIxM29I1zeak6w4Em5yjag7xn+3MRU3KP?=
 =?us-ascii?Q?3aB0/me1xgA5y62SxsC3oeYcbPLR8sKlugfsB9DhO4cTuuO9twgVAcx+XzRV?=
 =?us-ascii?Q?SsuTilkdsvM5rPJg8a1RSv2OTkhFp67YorsQPa0IaTYOWMEPLRnXAk1/usyO?=
 =?us-ascii?Q?JqgVqEVNjfuFVuxqgBv9BQVypRiIHSeR0DQpphXGHrnUaVhYA1Y2BoULrefh?=
 =?us-ascii?Q?1Kfjq6OLawINW5fMPquoaKOPDBdzOjLe1xGRzqJ/9mzwse2fh4VNSXNKf7so?=
 =?us-ascii?Q?aD+fNit3z4B4YTInZmKg5Si4W+EdVyYakj8bQPbPIUTl7PZlC7lINffK5UuB?=
 =?us-ascii?Q?fSr61mvKQXtobUMJ8NOGHNC2MUZTwJFZHpQPH+QDWhH9eDKS2O32/3VKE/fs?=
 =?us-ascii?Q?0FW3xVwmc7K0865tBfN02ExSkZl5q1d8AcWzkOvaCd8VumACTqjKyx7f90u8?=
 =?us-ascii?Q?gVZwRCMGOdzu2ug5aNDqKAjAH6rC1oZnMjJP9VhM4v8+WvlU40+MfMg6aR6g?=
 =?us-ascii?Q?CxTIaiUOgjQZ8jis43cM0/glABQPLJTpblrD3Q73MSyM4H+UEnoM9aJtwDGw?=
 =?us-ascii?Q?yfpXYR/dTvy7Ir3vGZHJi0iP?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5F296790E3C82548BC4444616756A45D@eurprd08.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR08MB4118.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dccc07e9-7892-420f-48c1-08d94d222f3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2021 15:05:46.5729
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tkEyeZXlSP99pmoFC3PnFlrhrFz12MAo5KJdMXW57yE2y052G75Vvz756zDKvVhMkGwzMNVSpFlmReRg/mTJ5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR08MB6775
X-MDID: 1626966348-I4j_r4ZOd6Ix
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I apologise, I have mistakingly supplied the wrong version.
The lowest kernel version we found this in is v5.3, but this is not a vanil=
la kernel, but an Ubuntu kernel with probable backports.
Specifically

$ uname -a
Linux ubuntu1910.localdomain 5.3.0-64-generic #58-Ubuntu SMP Fri Jul 10 19:=
33:51 UTC 2020 x86_64 x86_64 x86_64 GNU/Linux


The lowest version from https://kernel.ubuntu.com/~kernel-ppa/mainline/ we =
found the bug in is v5.7.
i.e. v5.6 does not exhibit the bug, but v5.7 does.
(v5.6.X where X>0 were not checked)=
