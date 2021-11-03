Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB19D443FE1
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 11:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231910AbhKCKRb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Nov 2021 06:17:31 -0400
Received: from mx0b-0014ca01.pphosted.com ([208.86.201.193]:13410 "EHLO
        mx0a-0014ca01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231948AbhKCKRa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Nov 2021 06:17:30 -0400
Received: from pps.filterd (m0042333.ppops.net [127.0.0.1])
        by mx0b-0014ca01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1A36hL0c030576;
        Wed, 3 Nov 2021 03:14:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=proofpoint;
 bh=NnK+KHkgI7mRmywv+L2MfJNh3KtrG5tenO9kLryPJgI=;
 b=H5ndscO8o4IntRHdfYPUuxVFqZ/k3RbUYYA1u7VQzNMcDbUPtsrNfNGrwu6+E6wQjSuB
 PCv1QEzSsfq8JFLTO+9+ypi4xfcMfCOzmR/FbhqDr/m/Pqb5pr0T9VVeS1O6VAMGI4GM
 kw7kjadef721jcoaK3WwDe8/l03wHalM0AD/SzRcMezLz4hNtRoj1weh0CO1bayXX5SN
 bKwGnWLJzmwsnye33kIyZMLdUVv9AlrALLaesJOC/O++4zq/8rz6XcNo+Ba2MUl0CMXr
 zUoSCbeilWqkK5bOoKyPhRcQJC39eBLKPmS/WHlFC+XfO4AlaPKmT1+r2khSQPeaIiLi 1w== 
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by mx0b-0014ca01.pphosted.com (PPS) with ESMTPS id 3c3dcra9mf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 03 Nov 2021 03:14:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dS5zYpz0g6u5Jn0QxxfgSlWtJCEqiJ54cSWe1AcILCatVDeoH9Vn1l7/RN3rX3Epi9zhnDdqHONloF1RpBELF4ggCEKkaxYKoIp+MpB+bY3bmh/wjGWBhAn3cZ/aAcSQu9dMuSeVEGMnRvWAP5kNKBu5Aom4ZbNiCdub9ykP2CRC8SfdytDOiXXH+6sEOdENEZ/5sPN3pXldowuub1QBGHpRUFwipVinabY9FZfazpCgDmchLFFIqR5+qYUwXf786SQFZCZ2sZadnj787kdLLdw4J2xPQmg0DmyWTiO4vCCcfZVelK1xTdN/QuwYVNsyf3vLZOw+r6m7Q0wEjkDqwA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NnK+KHkgI7mRmywv+L2MfJNh3KtrG5tenO9kLryPJgI=;
 b=Z3snQGLj5GfoSK7teKdqAyehV45feh7HCPJkKtshPVLpj1b4bZ4RlF1joNiQrZOEWD91WlHoOYv2KQnNaoXCBSo96HkLIhhmfFU2Xq1CKRjVbolbvTtfmZf5ONtGDTJEJUegCZmfNWFUz36Sje9pknQ4fTsF4b3KCQ+2m2kq+Y92ISQ/x5ATJYMcC9kY2+2cmZrqHNx1SMKPq1bVQztJIYPiwlOxC1zH65GTvnUzCycqYsUpWLyu9Cd/vgBxzrJ0asUgi/X5xZgxXsDpr2SE2KmxAQ46r+LnFrZFXpVWtKI4/rd1H37iJdb9lLP74q3usE82XMVavksOXNIr98U6EA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cadence.com; dmarc=pass action=none header.from=cadence.com;
 dkim=pass header.d=cadence.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cadence.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnK+KHkgI7mRmywv+L2MfJNh3KtrG5tenO9kLryPJgI=;
 b=m2NS7Bw9TLbzbKx6ia8zwiNTXVA57Ote7Ocbc4qtAZJrJhbabzows7GHYahXy2Svwq5NHKPBbp+x+713Gpto+ckGsaDxLOv0O6YLZeb7anfgaLrJcU3OgE6bo3FTjDb1fk8J8Jl92OqU9crndJ+yrzUqqwVZHUlmtuR1vLV1/XA=
Received: from CY4PR07MB2757.namprd07.prod.outlook.com (2603:10b6:903:22::20)
 by CY4PR07MB3046.namprd07.prod.outlook.com (2603:10b6:903:d2::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Wed, 3 Nov
 2021 10:14:34 +0000
Received: from CY4PR07MB2757.namprd07.prod.outlook.com
 ([fe80::18cb:253e:25e5:3928]) by CY4PR07MB2757.namprd07.prod.outlook.com
 ([fe80::18cb:253e:25e5:3928%5]) with mapi id 15.20.4649.020; Wed, 3 Nov 2021
 10:14:33 +0000
From:   Parshuram Raju Thombare <pthombar@cadence.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Milind Parab <mparab@cadence.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Antoine Tenart <atenart@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Nicolas Ferre <nicolas.ferre@microchip.com>
Subject: RE: [net-next PATCH v5] net: macb: Fix several edge cases in validate
Thread-Topic: [net-next PATCH v5] net: macb: Fix several edge cases in
 validate
Thread-Index: AQHXzzHzuFgiQnQIfUGJCp+Cz9BARavxkoyg
Date:   Wed, 3 Nov 2021 10:14:33 +0000
Message-ID: <CY4PR07MB27576B46D37E39F9F1789A31C18C9@CY4PR07MB2757.namprd07.prod.outlook.com>
References: <20211101150422.2811030-1-sean.anderson@seco.com>
In-Reply-To: <20211101150422.2811030-1-sean.anderson@seco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-dg-ref: PG1ldGE+PGF0IG5tPSJib2R5LnR4dCIgcD0iYzpcdXNlcnNccHRob21iYXJcYXBwZGF0YVxyb2FtaW5nXDA5ZDg0OWI2LTMyZDMtNGE0MC04NWVlLTZiODRiYTI5ZTM1Ylxtc2dzXG1zZy1kNGJmM2ZmNi0zYzhlLTExZWMtODY0ZC0xMDY1MzBlZjIyZjVcYW1lLXRlc3RcZDRiZjNmZjctM2M4ZS0xMWVjLTg2NGQtMTA2NTMwZWYyMmY1Ym9keS50eHQiIHN6PSIxMDc0IiB0PSIxMzI4MDQwODA3MDQ0MDE0NTciIGg9IlNoZm1VejY0R1dvdXRGSjlHQlUxRXdoNDBxbz0iIGlkPSIiIGJsPSIwIiBibz0iMSIvPjwvbWV0YT4=
x-dg-rorf: true
authentication-results: seco.com; dkim=none (message not signed)
 header.d=none;seco.com; dmarc=none action=none header.from=cadence.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 564e4036-aff9-4ec8-3235-08d99eb2bb8f
x-ms-traffictypediagnostic: CY4PR07MB3046:
x-microsoft-antispam-prvs: <CY4PR07MB30467EC0447467A9B2716037C18C9@CY4PR07MB3046.namprd07.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xKD8cRMf38N5VPob68ZSY+qDD3AUh+fwfiWmnuDnjB/wkXYecHlvBzdyOGL2FUCinA91iJJUdv0bMvcSr0xeOa4+JQPpeduAEAZMExO7iJK3nLU0PeJPyBOCyhy4wEijL6sKcO7ZKbBDpOCbSC0SYu2yGNGwEWb1VLuNt+lG0FCP1JjkntbFGSQf3SIoM8v3w6RAHjhjzVawCylp0HGa2LDUk1EIaaNmt27iiF6A3l+qvqSYrtr0yCVEzbcZ/oEnSpu/+THEyhlPX2T37rLxnvtpX/DwrU7E2jKiI3CkVsSotwcM6LJOmxNylOO/zb+WudjAUiVQjBe0PnznAZn5uTLPFiArh40GNlSW37jmaT8aVquzETEJQiBmm1EfIOfrYSOvDUlTTWA1lKHqAA4J4yPFdcC/XVHCUBEoc3ihRUgGjZVEHfRaCX3M2qkWBbJ9SDntQj4BzJsCrjXMT6feACeUPO8U6iypRB280uSJR9aIDGG/sQDXrq+6IwnlmAnFEsqrVzsk6p/Kku95dUn0HkEtpEAcA6uONmoRe3EbLuVrkv+acqDkOVSK4kzuT+73It8mvkZ9sFVRb2rMT+ZAAZKuGR+XHzw7GwMRWxzOw2DQWrUK24wrU2ExYg2tfHAeEja4Kb3PGDf/bXXkOWgEHu9q/bQswp5+Bbi/0Woq9ILXzA2+vWc0fzL1+ZKqgfouel2ib4VhPWEgOPjrl6RUs3vEkOtZ65QGeAsmoHFqX/PfXKTdzGJG6L5TFAM1gN0o
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR07MB2757.namprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36092001)(6506007)(110136005)(54906003)(52536014)(7696005)(8936002)(4326008)(316002)(8676002)(5660300002)(4744005)(71200400001)(38100700002)(76116006)(64756008)(33656002)(38070700005)(2906002)(66556008)(66476007)(66446008)(26005)(9686003)(66946007)(508600001)(55016002)(86362001)(186003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SOA9tyxj7VcPJOx5CkMgejHr1CHOZ5/jMuZ9uqfK+G0c/ekGqDuPAKYyLEVQ?=
 =?us-ascii?Q?pphSy+w1/+CBBrivs8pdItZEGLPB9diF4sJ0NHsgpqmuP3rBqkoehvgFrKdF?=
 =?us-ascii?Q?gao6dIfVXJ4pp6Xd3navLOyKkbsDxP2LAB2uWDK9rO267fXR8LNzSVxxLAfF?=
 =?us-ascii?Q?UrQX/LJMI6g6FEPpxcWvP2C4gJ2aNoHrS/Z2esjwmUHweLuRAtjov15C0Ul5?=
 =?us-ascii?Q?lE2L8hYDzvmTDzFFJ5DC8lUfsn0SFo96TuapZcIIsf72QjvImhIjpfOSz5rH?=
 =?us-ascii?Q?0kplCRcJvwbsLloeHjGlsGO9sUJhJcq+6sWULAAK1K5pIkQYAEnSDo0HObpR?=
 =?us-ascii?Q?Atq6NbKeTk01HLc+IrJsyMnWzFYqvz6lfHnIHaUnnmuXwTvehgqr5ElHutPW?=
 =?us-ascii?Q?FlFfjh8Cf0pY2xa67NA+Td1kpXXVK49YQiP678z9AEbsLhwDcmct63/suNtD?=
 =?us-ascii?Q?XcCQ53t0xvYIFN1Ve7wZ6iM6zNH9+6V5Gj/wqNjqiNQ3KMQ6spbXi90mrGlO?=
 =?us-ascii?Q?gPqZvvVbc9kr+KDfbRWpV4IOznN1Xs4/tHxlyiTHLnjrfbLRkXBGw2EQjDfS?=
 =?us-ascii?Q?zuQuE2BYVlzf3kMvOD1Pj4nHQ6n64fO4ceUqU+5vFRqgsKBhoT0hLy7VSh4R?=
 =?us-ascii?Q?zYRXZLqRTHc+iWWPxwsyElQ+Gw6aLdfyMIpLi6r+SxdTtR8fiI2J0WuW8hBt?=
 =?us-ascii?Q?hIN9261JM9MIfqkXE4LbTDJGEmbvJHPEBaLhkmgSrbxpudCc0FPP8TxpIyvk?=
 =?us-ascii?Q?R0yk55YHPAj/tWu+U4jybzg3cJ90IVA5a3GmhMTXYVLlsaRiQGk3n4gKPcF7?=
 =?us-ascii?Q?MVSKxyWpg1zxQa+63O780Jj5imnOhRJEg28qCfBpw4oGkfFQZTBKG98XRvET?=
 =?us-ascii?Q?4aBQA/c333o/8xjN6KgqSrqpdzeIrZxVpaCuX5dnGYbX8t0iPDKVYO7XumFD?=
 =?us-ascii?Q?Z+qU7MEA3UuL0bE1O5K8I8cowU60ESG6ClM1wf7LziNyLyQ9XGkrOZrX0ZoC?=
 =?us-ascii?Q?Dn6qBxAdrLSMnT1W1xvublJaBU942BdsRSAQeUcRQQLtETF61xSscYhNPFmE?=
 =?us-ascii?Q?RL/MhiRavT7m6Y+AEInbbduNsVXAXnnlNPePqW3hlELMAy7ic4tnYpmjq72F?=
 =?us-ascii?Q?MdxMCB4gyRxTXBo3gTped1Wq2mbe2aS6nSVttspFLwqwIVrjx7St+SaOZkaJ?=
 =?us-ascii?Q?2IjQflvgEkarrTifoO2+IJxGyblO1bDQxQY/p5XZIDi+ktAz/mcw42G9ZA0A?=
 =?us-ascii?Q?omTuZ1zwgZqg0D48eTHXmHSbbSiS87SvfpDSepaiyr0C3yJr/hpUcFVGR5A1?=
 =?us-ascii?Q?fSgi1Kx/brlSuMjnemMkv1N9E8FofhC/zBXUPYLszccyXeu+r+faeEK5V0hq?=
 =?us-ascii?Q?UejhS9rRqWiNNqu3Fm0pYTuZu/axO8zYBUlyF77WFMjqAu4F3M14COeKyrcw?=
 =?us-ascii?Q?b+DHkxG0/1hPkftN97IAq2+flTM4ujN93Za2VHn9U0s3QzhaDMJQJJyhgxtN?=
 =?us-ascii?Q?oJPQ0kTDpF1DYMg6aKmQVp6WpDxGAGESnD+eXPzTaWRgXI4m67K7fnuxWHLY?=
 =?us-ascii?Q?ETQOdxOCM6+Fd2ZQxdpcQl5M9UPSZ/1xvS0RahSzmvfiO0rJ+rni0qdKWgyh?=
 =?us-ascii?Q?Yw8MeqDtsyTihj2+JkcfWzvKuERwUsRkF2geS8LWH73aGdZZ6lRTPolTuCJz?=
 =?us-ascii?Q?bywK1g=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: cadence.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR07MB2757.namprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 564e4036-aff9-4ec8-3235-08d99eb2bb8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2021 10:14:33.6607
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d36035c5-6ce6-4662-a3dc-e762e61ae4c9
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /eADPKBuQUXMmwk5aOCFmrXkNLk3B7JMEPIkCt5rP0YbA4zNVQ1NjN7cHuBfnbTdxiPA2k29OXGah5SdhCZC3tHvQQnVZUAOcNoRtPT8i0A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR07MB3046
X-Proofpoint-ORIG-GUID: 6ULl5Rrg9BGkir45XMw9QmT9TvmwbKv_
X-Proofpoint-GUID: 6ULl5Rrg9BGkir45XMw9QmT9TvmwbKv_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-03_03,2021-11-03_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_check_notspam policy=outbound_check score=0 mlxlogscore=350
 adultscore=0 lowpriorityscore=0 phishscore=0 suspectscore=0 clxscore=1011
 spamscore=0 malwarescore=0 bulkscore=0 impostorscore=0 priorityscore=1501
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111030058
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sean,

Thanks for this improvement.

>+	if (!macb_is_gem(bp) ||
>+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>+		have_1g =3D true;
>+		if (bp->caps & MACB_CAPS_PCS)
>+			have_sgmii =3D true;
>+		if (bp->caps & MACB_CAPS_HIGH_SPEED)
>+			have_10g =3D true;

As I understand, MACB_CAPS_GIGABIT_MODE_AVAILABLE is used as a quirk in con=
figs
to prevent giga bit operation support, Nicolas should have more information=
 about this.

macb_is_gem() tells whether giga bit operations is supported by HW, MACB_CA=
PS_PCS indicate
whether PCS is included in the design (needed for SGMII and 10G operation),=
 MACB_CAPS_HIGH_SPEED
indicate if design supports 10G operation.

I believe this should be

>+	if (macb_is_gem(bp) &&
>+	    (bp->caps & MACB_CAPS_GIGABIT_MODE_AVAILABLE)) {
>+		have_1g =3D true;
>+		if (bp->caps & MACB_CAPS_PCS)
>+			have_sgmii =3D true;
>+		if (bp->caps & MACB_CAPS_HIGH_SPEED)
>+			have_10g =3D true;

Regards,
Parshuram Thombare
