Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F4C32E0FA7
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 22:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728025AbgLVVGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 16:06:08 -0500
Received: from mail-bn8nam11on2057.outbound.protection.outlook.com ([40.107.236.57]:1248
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727716AbgLVVGH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 16:06:07 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fJAsygbDmQXzHfZacY4HdGSxCIWll9UJBH/U+evqPGIV+I3XmHg/u3NG0MnNuOgqDXPg1bLAmJF1CX6qPoSnfS7OJjn/g4jLGBn5x2XurwSiEkgLZvKDbuMgySibvmKlPiSPjWKvRRwhsTshV/4cm4OIyveU2y3zZWbdMJgy9kbeFtfxmfkSd+O4pAAFyuYIBzUYiEvo/1sc+OKhLa4qxjH5j4w2ZnzXCLuqEyPj435bYMzZ6Qza2HPpB1Dl0mU0wb+PZ1JqoDhHT1qP3Up6qR0ARK44Lv//KBb5fVv3B3Mn/NF7XUmced/SN4wN/R0SrEki2FjrvrQ1KzkltWIB1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAmDQA7Rh3lAqFsGHUKxyHSI1GWxlxbNaME350+fAnI=;
 b=BtI97tru7W+EbSqSbB3reN+l+RfGs50273jaFPfXCFJzb0i3cyVEt368WPsSnBXO92GZW6f8ZRg703ZaF7f2dTz5FB4+IQbI7mhX3biuj0H2cTS+e7r4DhZZ+MFtFPOSzq8vrLKFEzdR7uL+QopL//FVWtq+ErrVub5mFDAvjeF7qrUiR6xU3y043cMquWa0CsBT7EhJXP8YaH+3ioaaB22e2an7A9h9Zz0+ROxfztDwolIirhKSJwW+tT4wTd4eiK0et9G/y3zeU+9xO2aACg0fFVsmhi63oqcgOFv2Nez/yaMjG6HrkK+TtTqHuvJTb29OehO8lFEsmVZF3MXPDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cAmDQA7Rh3lAqFsGHUKxyHSI1GWxlxbNaME350+fAnI=;
 b=BYfzwoV7pYaG7QFnXqOSd7K5xMrNo/51FNRR/K0a2UnbXjA1q/YM2sF4c+ZuIpmXk0I24HcExbP4o5seobIVJxbgn9hlN2hvux+4ppSvkeiqbuiWsU3hX9l4r+2OszVFyxHXfsU800N1RWUa+ItAirNc0cVGrmgbGkOI4mHT7Q8=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB4988.namprd11.prod.outlook.com (2603:10b6:806:f8::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 21:05:19 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Tue, 22 Dec 2020
 21:05:19 +0000
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
Subject: Re: [PATCH v3 12/24] wfx: add hif_api_*.h
Date:   Tue, 22 Dec 2020 22:05:14 +0100
Message-ID: <1766959.tdWV9SEqCh@pc-42>
Organization: Silicon Labs
In-Reply-To: <87h7od98a9.fsf@codeaurora.org>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com> <20201104155207.128076-13-Jerome.Pouiller@silabs.com> <87h7od98a9.fsf@codeaurora.org>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN4PR0701CA0030.namprd07.prod.outlook.com
 (2603:10b6:803:2d::23) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SN4PR0701CA0030.namprd07.prod.outlook.com (2603:10b6:803:2d::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.30 via Frontend Transport; Tue, 22 Dec 2020 21:05:16 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70237889-3087-4f9b-c94a-08d8a6bd49dd
X-MS-TrafficTypeDiagnostic: SA2PR11MB4988:
X-Microsoft-Antispam-PRVS: <SA2PR11MB4988C4AD615867A86654346E93DF0@SA2PR11MB4988.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ciNKdOa9lYqaLiLp5G7J90kJIJB7u5jN5pb/+eDu5VJeJw4O3eIghE2qOx8xm6fSG5ZUQ23nkoE2qEwLpdy1kkc9A95lq4zqoVceUH+9b0GB7pofolSwvZl1vhzJ0MoOgWmqt2xtVkIbGOMtc3JeisB3UDy4LtwUetyF/W/FvSFK/43rceEL1BHaMcdiiBlSBqtWe7xqBNB+GU7tcA6YrqY7540MYAhee2LNEESa5ofUMAUSCZgVUWkcdsZL5Mc0eLDTjq4Koa2DvBqmY5nefmRU/YlmXhtteeLJGlfmBAdlW2dFE+a43sUWNLC25KZQOVsAeCKnD7l3FFzbNl+4Ubgg17NVRLQCVx8G64bK12ezmIhmJhodOdd7w529ka9cTcoBsAtvjLVSbjwVc/rOfKIn5CTM86/N4pI8zyvOaI0ZTqMgrxFN+or9w0RgCP0g
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(39850400004)(396003)(4326008)(8936002)(6486002)(2906002)(8676002)(36916002)(16526019)(26005)(186003)(6916009)(66556008)(6506007)(956004)(7416002)(4744005)(33716001)(316002)(66476007)(86362001)(9686003)(54906003)(5660300002)(6512007)(478600001)(66946007)(52116002)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?IDnQluwifcq+VScLSz+yyJjBi2uDDdHhYWoF//5zdkSsWi1Bi2FLEM/xWP?=
 =?iso-8859-1?Q?g51NqNK1ULCa+8gLNlQD1wkVXmyyaQlq459Jqgfqzj3tdf7xPNZlQs1n8I?=
 =?iso-8859-1?Q?i43zo/VKMvtD3VyECTaHGO7DjfzRexOrtZqEpEX5bSk+P/FJWfDG4axC42?=
 =?iso-8859-1?Q?hcOKxwdsJh3R8+nsESS3fudDjNTSbv/AJLh0q5vb04NhCid8kAHRMSpkEV?=
 =?iso-8859-1?Q?bs7ebDrp8BHaC7k/IiKsdes2sR4I+LaunuWEnBBWSkMG2+li6dxDHAGEs6?=
 =?iso-8859-1?Q?5xFNmVCx9dWYNRGe2hz31xdkojbkrQrFoBf6inydsMRLYPigh/ausJsXKK?=
 =?iso-8859-1?Q?zsRJMHze3b7xQ1aSXwclbA5BEm+KtbvDP4oP+mmxGWjGq69x9RM4mF/XBv?=
 =?iso-8859-1?Q?VEO6FaLaJ7X3eKk/6BOMrrMvJGrE+2Mnl6PQ0UrgDqYlbqMQOHjRsWVS5K?=
 =?iso-8859-1?Q?3PPkvj+TEKhOwgSFLGXjLTwEyBql8NTPVqiSzJNItpNqXIHbprduUqI/4S?=
 =?iso-8859-1?Q?tQ84qHWUUjvrQ6byyrO6tAQdvidN93sCO1Nv2YchYkx0kqBpi4JIKyZNrQ?=
 =?iso-8859-1?Q?oYsjqpahnu6yHshJZI9QhQVTMQGDj3j7o9Bz+axZX2CxoYdSsgo0yjkuEE?=
 =?iso-8859-1?Q?5FkRxseHLWHM/9L3f8WSWC4haXRu0MF3qCPZIXmyIjvZVwaPlD6BDByI7e?=
 =?iso-8859-1?Q?GwIQX4ral3ZTLP+bp0086VAValnyOg/3N4dgedRdf3E8sSnhV1He/DIWIL?=
 =?iso-8859-1?Q?csXVQDX1rG3h8FX3uWzPgWRmbQ5s5j6PzOFQpbLqMlpwsLH8VXUkDBkh8t?=
 =?iso-8859-1?Q?rtyEhzoMRYt3NEyaayNCltPNTVXmINT6bhYNrmVl03BoiRAGV7Wd5BGFEq?=
 =?iso-8859-1?Q?ac/6vjETmGI5d/vhvGk2Vxf1RgM7g+hPt32J+VZXuyAJyNsYSk5+w0ZCVs?=
 =?iso-8859-1?Q?NSIA3FqHsp+Wx12TIOCfHpuZaxgZ3M8n6qAuidvH2WE80PgtSw3O1Ez3GA?=
 =?iso-8859-1?Q?DlfA14wqWnijPYH6ciYVjd7S+W09gqS2274M6m?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 21:05:18.9727
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 70237889-3087-4f9b-c94a-08d8a6bd49dd
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RuM0pZ6WTrVb/dFsLlRn1XyeKzn7LazXMTWtF5qLRBqyhvap7vTGZnU0R9hQfMH/Rq0D52CrCi/N1K+shkOGvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 22 December 2020 16:20:46 CET Kalle Valo wrote:
> Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
>=20
> > --- /dev/null
> > +++ b/drivers/net/wireless/silabs/wfx/hif_api_general.h
> > @@ -0,0 +1,267 @@
> > +/* SPDX-License-Identifier: Apache-2.0 */
> > +/*
> > + * WFx hardware interface definitions
> > + *
> > + * Copyright (c) 2018-2020, Silicon Laboratories Inc.
> > + */
> > +
> > +#ifndef WFX_HIF_API_GENERAL_H
> > +#define WFX_HIF_API_GENERAL_H
> > +
> > +#ifdef __KERNEL__
> > +#include <linux/types.h>
> > +#include <linux/if_ether.h>
> > +#else
> > +#include <net/ethernet.h>
> > +#include <stdint.h>
> > +#define __packed __attribute__((__packed__))
> > +#endif
>=20
> Why check for __KERNEL__ and redefined __packed? These don't belong to a
> wireless driver.

In the old days, this file was shared with other projects. I though I had
cleaned all these things.

--=20
J=E9r=F4me Pouiller


