Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F2872E1994
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 09:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbgLWIC2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 03:02:28 -0500
Received: from mail-bn8nam12on2075.outbound.protection.outlook.com ([40.107.237.75]:30944
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727168AbgLWIC1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 03:02:27 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=INoSoVw4jJJzcUdcPqvcibof0/wvMLWip4A9PfcBGINo8Lu1WiEqsoMIXFtl6OVmZkuBWsZu9A9u0hT49VqnHYJuVlPBxBjNO2Mzj6N2ClCFkUTVsdhsEslLZ85/d6VHmeiMMiUlqvy6/jHL0JBZ+G3iGseayZCe0zrhHIt2TVcvHvSNN9FWmGuN3rTbIw3JktAAbiyprIAI0NlwPG5tYlJM4i83fD3pBcYPDuUdJG7c9k5ovptdszRm6QLQQw8uraipFvgi38xzUBmwMbtHD5xXa7xLFt+7oOMXo1kxomIU93xgiCltsCv5Kc0JXcdAgR3gZOb8VDD+TKriKUvySw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2Tx5WM+e/RNsKFEh2Fda8i2Dqa9Vlm0daguChkzo/E=;
 b=JbgAklGP6Mo9936d5wXrn3VYNYLZpNUytOhj5dwf7zeR1A3TaAifWuG+S2bCuoFpnXHhDEUC0wF7ORTeRGtId7EdL1/l95YjdQBYDM4ViPDKLBCNytBFplaD24wGzYRTvXt0+eJmCzcR3hxRM5mLE2lrNdgCo4NEAUGvAg/3X6hQtD87kGpT0IqMq601Cgh0yYlvUKiBBRX9eqzrTMkWD5JpZKOlhhhQImJzggMt+SYJ/9+aGhLMrKEnimNqiFTKardGKe1q7KaqlXcFrVgwqty+iJOX6a1JLXK0IxJTE0g19IL0b66p/tW5Vr4nVHojP8g5IzT1sJ2ggu4QayFJ9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t2Tx5WM+e/RNsKFEh2Fda8i2Dqa9Vlm0daguChkzo/E=;
 b=pfjHTD/jmpMu9fsfwsXH/fN1dIfOo4LCkMGJFw+YxHW8PvN+c/8ADwljR7Ku0Sp/XXK5K9bvqTHYeKo2gcILlffwjkm7WmyWHujaX5HXz8F6ktajW7rDI5uDmM0D30ZoMK3wKZjZJOBevilHR6x4GdqtPrnwV4gf4SbxspUAmxw=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2653.namprd11.prod.outlook.com (2603:10b6:805:63::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29; Wed, 23 Dec
 2020 08:01:38 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::a989:f850:6736:97ca%5]) with mapi id 15.20.3700.026; Wed, 23 Dec 2020
 08:01:38 +0000
From:   =?ISO-8859-1?Q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        Pali =?ISO-8859-1?Q?Roh=E1r?= <pali@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 09/24] wfx: add hwio.c/hwio.h
Date:   Wed, 23 Dec 2020 09:01:33 +0100
Message-ID: <5567602.MhkbZ0Pkbq@pc-42>
Organization: Silicon Labs
In-Reply-To: <X+IQRct0Zsm87H4+@kroah.com>
References: <20201104155207.128076-1-Jerome.Pouiller@silabs.com> <87lfdp98rw.fsf@codeaurora.org> <X+IQRct0Zsm87H4+@kroah.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Originating-IP: [82.67.86.106]
X-ClientProxiedBy: SN4PR0701CA0042.namprd07.prod.outlook.com
 (2603:10b6:803:2d::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.localnet (82.67.86.106) by SN4PR0701CA0042.namprd07.prod.outlook.com (2603:10b6:803:2d::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3700.27 via Frontend Transport; Wed, 23 Dec 2020 08:01:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 34ee1a89-afaa-4783-732e-08d8a718f9c0
X-MS-TrafficTypeDiagnostic: SN6PR11MB2653:
X-Microsoft-Antispam-PRVS: <SN6PR11MB2653BCF766E1BD90A800400093DE0@SN6PR11MB2653.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k7Bm05TVa6l0sZbUDDcgk9562codqJyRcbxT/kIw7K1frgz8pzLJd+LU0qhkIk4Hp9hbqDTxo9Gee+l7DXufQfgMbZvtGtaU+EYQf1S7p5rT6swbb00y0bdqQa8JCGe2YRBvjV9HYxFzgGtAyZzKpK5z+mAGkffzCXmqoFJ9wjDXXecd5aSRxNo2wxbcIyWMKlr8l5DRH+alQVFbdN7ttwxVZgkDFS5v+88pNNPEzwCl+Le/7wXb+pw/6MQe8guLdMUKJgzwyeoF0At3UkopRgwYD87i5b/FKsqqBTHvUdTVicmY+Fw8yyXCVHKEZQx/NtnY/+Ujm7cHMPz3u9WZqzs00LTLtdBdpeIiNFM1XA3AYUUMMq8MlqSrAW47TgDUdhM1Qc0PHNmOncibpzX8oAxtCpclaqBRuZTV86LweWgwOb3OBT7qaBYtk9oSn53S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(366004)(39850400004)(376002)(346002)(396003)(2906002)(5660300002)(8676002)(6666004)(316002)(6512007)(110136005)(186003)(66946007)(9686003)(16526019)(54906003)(66574015)(33716001)(6486002)(83380400001)(36916002)(66556008)(66476007)(52116002)(26005)(478600001)(4326008)(6506007)(8936002)(7416002)(956004)(86362001)(39026012);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?iso-8859-1?Q?j1KjEDULDNLkpMXVIS4vBiaHpcy3z6+j00d8qlEa4AqGTDE1hHDhFR5qSd?=
 =?iso-8859-1?Q?hMNbX+HWXLxJV3PDn/TGOZ5GzstvZEGTXYiD0r8eOVPAh05x0OUZZPh9hS?=
 =?iso-8859-1?Q?umLh+YPUX7lct99MccwvbhPtrOXgjactSkdw/tIWtBQdzGL6kiw/edkyGo?=
 =?iso-8859-1?Q?IV5DvEvtkW2Q33f6w5NDrB8/DaNeHODmsJRsF+hM0Lqp0frZZj9ACIOiR6?=
 =?iso-8859-1?Q?d/+bCBFH09ROdtzv3QjOYKBLxckmaKRdpu1v4CP8q1m8EotjXdzQf8S4GV?=
 =?iso-8859-1?Q?0UuU5oz/ujSHWQ7sbm2/WnQFwtOWnUqVxyGRv3lc0aC5qZfC7Fkycf7Y9J?=
 =?iso-8859-1?Q?mnp+nD3+Jsxokw9tXBVl9RFt2xqYoE10awOyPQfDGZu7G4SXsSWBAIkXG7?=
 =?iso-8859-1?Q?UOmQAf90bDkNfNTVpVU8mRcABZQI+jOfuj3SrhhzuKMtZ7zw+D2X5OeNN1?=
 =?iso-8859-1?Q?DJl4AVcOzBsi0vxMBHDsUtJv080RsCc2pErtkamiqiFnPc7EHAuXOG3azO?=
 =?iso-8859-1?Q?WYMHHVJB9vQiUXUvWgi5ZPxRhjhbz0gLv9qGcFTh2+LLd+eNKiRwadaNYx?=
 =?iso-8859-1?Q?ko2gRJTT+qAiNqVgqYMai3fgDBSG4STBF9SU26yDDrrXmyKEY+VxA58nxX?=
 =?iso-8859-1?Q?7LkoFVyanEUK2/kCv7GtGGqHXHw9NRhTIMjkIS46029qk0YTdpEcXZU4Lt?=
 =?iso-8859-1?Q?JpvAksm57mLUBNLP1fxwe5F97Ye4XUS3aEjM4zbe/StcnmTD6HkjpkLcsW?=
 =?iso-8859-1?Q?lWf8GQY9Xe8WO9ebcTXH0bgonm4+cT4sFB9vzin/lVy+S46FXK1i0rI9py?=
 =?iso-8859-1?Q?D2Bjs6O/WZ5rh9MIqeWPx6ZJRIeu0Mouv5c5OTDTnmq132j/WmibF7P5ku?=
 =?iso-8859-1?Q?HYWaWt6QlRlE/v08HR+TVMtESHlvAiDrk2c4gIwmbRI1W+tLoJii3pz70A?=
 =?iso-8859-1?Q?fOs8tlMtkAWZc96vxQYgvLBVMGF1xenU2kCffde7aL10rQ910Y64jGmUMC?=
 =?iso-8859-1?Q?PYM9qVzyCgc6buvi4=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2020 08:01:38.2748
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-Network-Message-Id: 34ee1a89-afaa-4783-732e-08d8a718f9c0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hopm7uaW1xAbroXUKPX0aPno3Cdjbj16CONACu6xDx9iVj+tlvnseK7OqN1FWrxxfoxlvnMOeCUV7LWJhTzuOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2653
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tuesday 22 December 2020 16:27:01 CET Greg Kroah-Hartman wrote:
> On Tue, Dec 22, 2020 at 05:10:11PM +0200, Kalle Valo wrote:
> > Jerome Pouiller <Jerome.Pouiller@silabs.com> writes:
> >
> > > +/*
> > > + * Internal helpers.
> > > + *
> > > + * About CONFIG_VMAP_STACK:
> > > + * When CONFIG_VMAP_STACK is enabled, it is not possible to run DMA =
on stack
> > > + * allocated data. Functions below that work with registers (aka fun=
ctions
> > > + * ending with "32") automatically reallocate buffers with kmalloc. =
However,
> > > + * functions that work with arbitrary length buffers let's caller to=
 handle
> > > + * memory location. In doubt, enable CONFIG_DEBUG_SG to detect badly=
 located
> > > + * buffer.
> > > + */
> >
> > This sounds very hacky to me, I have understood that you should never
> > use stack with DMA.
>=20
> You should never do that because some platforms do not support it, so no
> driver should ever try to do that as they do not know what platform they
> are running on.

Just to be curious, why these platforms don't support DMA in a stack
allocated area? If the memory is contiguous (=3D not vmalloced), correctly
aligned and in the first 4GB of physical memory, it should be sufficient,
shouldn't?=20

--=20
J=E9r=F4me Pouiller


