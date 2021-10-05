Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46A7422DD0
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236379AbhJEQYd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 12:24:33 -0400
Received: from mail-bn8nam12on2057.outbound.protection.outlook.com ([40.107.237.57]:41104
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233896AbhJEQYc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 12:24:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YOoXKtH7bs8v6mDVY8cTWV6WglbgL1Fig5JLqU4s2xRJIjmW66j1xx1yMVtboQVwrwCT+ngjSPNBfksCtKWQx2XhFrmtp9ERnzMzzpywO9n1Fp4oTvNxXMJx7J3eKcJGixAQL481xcN1fQFoToY/uITvT5ll40f3KiClmlP0BNi5EpDIGayRUdKlQIb7Owh6dexxAOf4xc9HnvMAV2O968lvDlC+pJOxOwfw86k70Vkodi6oHgbWOWv/CVvKoLchpiMHDeM9s/dwvMIp0dg1BY6a5qxQoC58DEOkXHTjhQv3Nuu7dJxGqOqYwVhIVlM6Pk6Thq+G+ENTJzNzvTrSaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+1KVmKS/HYaWoVV3SVIPrZDdLQYJ/+dWuwdtEanHYIc=;
 b=VRxqPynhAU15i9MRLT0Es7FNbAKQAWXD1Yt4Zg6QqQrVmhfbYC9iYairllFsQVaNzzJofA33nvVBiMtagcXo0OUuD+aY8oNkL9u7ZYiY+Fv0n1vp6Dzh+5Z1OR+AyWiZYDO3//8yn/5GIcRskJI1Rpjya3bEvs66ImYAKVP4UZu+3WTt5IRRdiFodgVmOV95llWj8aY2BhjpIa05oX43pxTNVkONyWzdmVx9JPfVTItr6CfTMrqvXo6TgHsm0n+EN/ZVTGU4fYkWPN7At3WTSSK7zI4iF1IjRTVCZdlvUT/Kf1uKNZ8Xsa6SskmdlYOId4Jnh63aLonDwDY9JNzAyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+1KVmKS/HYaWoVV3SVIPrZDdLQYJ/+dWuwdtEanHYIc=;
 b=AHtVWHTls/6txgXh/kKJrY0XRDg4qkrcAki3ZsbZBP53Iv8976WTQxZPfNYk1BablANti5zHoIGq1Fm0pVmn7LYTB+NQ5CGW+7d7k75CHdM7VZ7jDnFhNZlo4yiDK0UMH3FOzepokOOCq8/l3kJkauvT2xVZQu0Vg9tR6AkD5KQ=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by PH0PR11MB5627.namprd11.prod.outlook.com (2603:10b6:510:e4::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14; Tue, 5 Oct
 2021 16:22:39 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::31cb:3b13:b0e8:d8f4%9]) with mapi id 15.20.4566.022; Tue, 5 Oct 2021
 16:22:39 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [PATCH v8 00/24] wfx: get out from the staging area
Date:   Tue, 05 Oct 2021 18:22:31 +0200
Message-ID: <2810333.gDgIz5hftg@pc-42>
Organization: Silicon Labs
In-Reply-To: <875yubfthh.fsf@codeaurora.org>
References: <20211005135400.788058-1-Jerome.Pouiller@silabs.com> <875yubfthh.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-ClientProxiedBy: PAZP264CA0124.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1ef::21) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
Received: from pc-42.localnet (37.71.187.125) by PAZP264CA0124.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1ef::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Tue, 5 Oct 2021 16:22:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c1e70767-65cb-4326-c144-08d9881c59a8
X-MS-TrafficTypeDiagnostic: PH0PR11MB5627:
X-Microsoft-Antispam-PRVS: <PH0PR11MB5627328F63A27AB1771E40D393AF9@PH0PR11MB5627.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: T3oMbq3qvsksCJWfeweZVmdcryXVQpTfKS6SJ+6Twxkcjs78UWqydlp6L1TbpTJ+W3oTrOVrur78XhADOgayUucE3Q0qNpn+fiXk1kFoFLaJMGs+xcMd1Bdi4cZKHQPcTbpf+Pyi/K8XCLafIbVIddBv8MxX5j2aZfQ59k+N8sh0egVPcD6RHSNrKOcWPbPh5AZEvz98mnsGdXnLMXCfO2R0bzOTpxfqFp/UGLDNSf21mdCPk5qfaaA6iroDGNvTda+PgRC6fVIKeNeR41215UA8LM3v9lTlK7LVCQaYK6Bvp1h7CiOW40Te27/j4snQbWFvfOBYmyqCwJWqR1bKfZBjyCEer9W4wkGLyePymW3VygCLZXpPv3l10NT3YIjOj8emgNdvK6Q0Vjo5J9eaIKA0UtaQm4y8hCtHpMrMURLoR2UrIFA+i8bbX07XXopbQ6OusfMIwTUvI7es8Y3WNcAO9GL1bALsUlM+gM6RjkeM0iOUYyCmmZLnOygJIRxO5p2NIuU6H9qYxKINl/Rzx7ytgFIumTmYL3lXkiFWUSJiEs202hFtvaKkity4cNNZ7XVx/mXlpcxFWuxRHZFJRH3BlLWbXR1BrkHgG+1KwzA0/+Dye+uqEetggGbyfLdS5sBzKrkUgFruUJIiQhgoVzWBy7vDYGuGrKdcBmESZslmGKRaPvwpLDo9frGnP/GQUgfTEF7KqNIPhiGBDJfyBD3B0WzOeIExMS+DBYwExnKseERV+bIYvvBjVz4WFx/DMzL03DGGiZzGoemcLw4QznOtZ3VvhC/j/l+FGRRnwD7oVmcQko24QvWfUg7KHgCC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(508600001)(33716001)(52116002)(66946007)(8676002)(66556008)(36916002)(66476007)(6666004)(316002)(2906002)(4326008)(26005)(9686003)(7416002)(6506007)(956004)(54906003)(186003)(5660300002)(6512007)(38350700002)(6486002)(83380400001)(86362001)(6916009)(8936002)(38100700002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?Y/pVuYsRSGklU/DFTJQ9ERpJewktz2AZYjSgpFIeqrfvSDsk+IqVMKPIEF?=
 =?iso-8859-1?Q?Nr4MV+TLM2AtqANXMkMtZRmTXAhcH2PM+5hLZU1kWzgA7po6VafSnpcklh?=
 =?iso-8859-1?Q?MFfEjmDGaVs/PbL8QgqhvxtrBIfQtlq9xC6CE/hK7wwgLurcYJ2tEm44NW?=
 =?iso-8859-1?Q?2pgb6MR8X6g8jn7Iry8+q2Tp/MpDJaeg7vBJuFr7oOEkc0hFYgMDjMDghj?=
 =?iso-8859-1?Q?ZAQZpMIr0WnfeSctdatat05CbC7eczH8YYQo5VanKH/Cwc1DivY6b2y4KE?=
 =?iso-8859-1?Q?aL8bSV2VJX5Y+OKnFD6S5iFTsXI7J+rJzthFgozI0oMuZnHT35IuVSDqxN?=
 =?iso-8859-1?Q?vth0NLlID0QF8JxyobsW8MRqG/dXnyiR1gmsWVA6jRgiC9DWmRu/PUmxr/?=
 =?iso-8859-1?Q?6BpaRiGnhnY6+kluZO39kmk8EpPHHgO6ac8/jpM/3wmEMdQ14mPrEPy3H7?=
 =?iso-8859-1?Q?CmBJTJPQS8Hmv3ejFc+l6glA7cHyDHI82L2jNUwzw00Y7J7TALoZGp6uOd?=
 =?iso-8859-1?Q?sA/Dz44ki+ut4+m2A+NBM08SjHuOxdKgp8Fr5PjN6s9TtAkJvQKrz8Hl1b?=
 =?iso-8859-1?Q?5coIlrwPbKzxlNgfa5zY5EioztnJnIgCGoawJAChBZz25cqeC3M4nIG/GP?=
 =?iso-8859-1?Q?v1iKiNP+7SmC8YSSbS2ZfgVs1BZKFSy7RuUAs1xzMNOnYB0fCNCupo68wQ?=
 =?iso-8859-1?Q?9BVxAOzQbdW0+yia7kEJ6iOsJ9YywJi5QQ9CKy4yjRI+O24EMyzyh5kr09?=
 =?iso-8859-1?Q?MVdkbitKsPfqTizrrW/9x6oT7gdObeiVDCDBA5KEF3+nfPHBqkAcnl2JpY?=
 =?iso-8859-1?Q?6XUoXgWYNjq1ILp7FEX3Kvtwwvzo8K9BS4qwe6Sk3ZjTK3bpgnNb0eGNHJ?=
 =?iso-8859-1?Q?2kbJAzB+8gJM17KKsh5ZgWF0SJJm4Qp96rDfGqiZPLJkt0ibCq7jpQ0Mct?=
 =?iso-8859-1?Q?PsRkcUOjLoRkP2MGK6VPXf6r8NYI2Mh3k+SlF45CQ6n+n2EpcsvmCnMz8s?=
 =?iso-8859-1?Q?3Vh9OFVSbYIXk06nnetAkoC5kWuCa22on+Fd+CrY9UKVakMZS5KKvVsnLG?=
 =?iso-8859-1?Q?Bs/nU8BWIlAKPK9K/1yK87PX784bAiX8HPyxhw+i0dka/61dkHZQMqbAV9?=
 =?iso-8859-1?Q?3nZFXt6oD03ITSU5LB53GKnZq9OrOpU00NeERiKNF7X7a4ZVHDJCybVxTI?=
 =?iso-8859-1?Q?ePsJCTjMPBCreeZLwvCgqPSHiTySiBkOIk/hVuFdQ3vSTBqPao+W5n7b/w?=
 =?iso-8859-1?Q?9p/QzsRi+EcK0EodStRAnI/KQ8wrHcTjo98Seh/mRElt0aEdBAktSr/RbV?=
 =?iso-8859-1?Q?uemlblaPB8UgT5CuPNLWZXVAdPb799afPK1KMHK6r/VrUcxM8Ly98Cajki?=
 =?iso-8859-1?Q?P8l+RnyU4A?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1e70767-65cb-4326-c144-08d9881c59a8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Oct 2021 16:22:39.6131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uwAqSujHSNO3Tq13gSJak3xn5goDBACX2oCu1yJffDj7jfEWITLpHHXe+lR3KWP92NELWtgM+uqYVlr1DOkz8Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5627
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 5 October 2021 16:15:22 CEST Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > From: J=E9r=F4me Pouiller <jerome.pouiller@silabs.com>
[...]
> > v8:
> >   - Change the way the DT is handled. The user can now specify the name=
 of
> >     the board (=3D chip + antenna) he use. It easier for board designer=
s to
> >     add new entries. I plan to send a PR to linux-firmware to include P=
DS
> >     files of the developpement boards belong the firmware (I also plan =
to
> >     relocate these file into wfx/ instead of silabs/). (Kalle, Pali)
> >   - Prefix visible functions and structs with "wfx_". I mostly kept the
> >     code under 80 columns. (Kalle, Pali, Greg)
> >   - Remove support for force_ps_timeout for now. (Kalle)
> >   - Fix licenses of Makefile, Kconfig and hif_api*.h. (Kalle)
> >   - Do not mix and match endianess in struct hif_ind_startup. (Kalle)
> >   - Remove magic values. (Kalle)
> >   - Use IS_ALIGNED(). (BTW, PTR_IS_ALIGNED() does not exist?) (Kalle)
> >   - I have also noticed that some headers files did not declare all the
> >     struct they used.
> >
> >   These issues remain (I hope they are not blockers):
> >   - I have currently no ideas how to improve/simplify the parsing PDS f=
ile.
> >     (Kalle)
>=20
> For the PDS file problem it would help if you could actually describe
> what the firmware requires/needs and then we can start from that. I had
> some questions about this in v7 but apparently you missed those.

Did you received this reply[1]?

[1]: https://lore.kernel.org/all/2723787.uDASXpoAWK@pc-42/


--=20
J=E9r=F4me Pouiller


