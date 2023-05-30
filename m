Return-Path: <netdev+bounces-6581-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7645E717068
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 00:04:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 30ADE281225
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 22:04:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 132D631F13;
	Tue, 30 May 2023 22:04:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF889200BC
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 22:04:50 +0000 (UTC)
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2042.outbound.protection.outlook.com [40.107.15.42])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F406F11D;
	Tue, 30 May 2023 15:04:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ftH0J+/N89Nwz9UGuB57LmaNUYKgCAdzD8S8UO/uqyNgbWnN8c2MhDzAt1+V/p/01O3wX9hynMM7E0e7CGrgdhKNj8uTS38MUtnysbn6ecaUwhiQxWNcaWQjLDQdnS7sFqyK2C5KakiEgAQ0vvzLw8Fg6juIhxfhkCwyPWxshMWKmvLyd2Y//sbMaHzae6rRqHJF6qczIFdl/7tFC3b6sx8qGgSgGMLnvUHtcOy1WGwlWvm60XqIjNjbY19LLM0Pd83re/6dixgrQz6CifWO6MQnsHF4SsYQHBS5TT5KKx0iHiIRu942n5NWAy141p79+e0DzG97Bgpl3K1eMv1lfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qGJK/d6YNlRmzVfTCKf3xMj2KYmNZrBFRKPramYl/2U=;
 b=WbKQQLmk8YRmnjz2aqtLKlP/lMvJguue9h9p7qgOZxnVHtFiu7RwaXi3EDOJWNdMSgeeAhNYza0ivE/0iPbvyZfIVZPdcDqY6DUWYmZv5MqNSneflmsCOHNpIa8MzyNR0P7fZx4Tc9NFvprs9taGATBeKuTvysF0Muyb9ubhx+XihTk88Hi9CkaIyarybDAMIT7d1PwJhQ4I7K2Q3jSv9R2bvOavLnNfRD6wdadS7TelubgI1cSArjel6KXvL0wb+jngiz/fA9tI06kGvKJ8qPV/6Eunr/ZnuWOM2yL6+N2yOYK39qUDiHb3nulC4dbSsu1so6zljRTldtwnseya2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qGJK/d6YNlRmzVfTCKf3xMj2KYmNZrBFRKPramYl/2U=;
 b=etQ0ndL7hfzRcdtaonm2X3qMptTkMb3EJOYnVEBjzLxEjgywesVdTxNEnQ/rn3JQKjHbRlM8Kq1rgluhKA3jH5KAPpIe30n8jMQlbQadKISk1yOlDnyOYP12n2hU2zomFfbGnLB1a2CvehEKJPkpglVsHIvWO1NX1Din+x1msqI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by DU2PR04MB9131.eurprd04.prod.outlook.com (2603:10a6:10:2f6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 22:04:40 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40%7]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 22:04:40 +0000
Date: Wed, 31 May 2023 01:04:36 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: linux-pci@vger.kernel.org, netdev@vger.kernel.org,
	Bjorn Helgaas <bhelgaas@google.com>, Rob Herring <robh@kernel.org>,
	Claudiu Manoil <claudiu.manoil@nxp.com>,
	Michael Walle <michael@walle.cc>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH pci] PCI: don't skip probing entire device if first fn OF
 node has status = "disabled"
Message-ID: <20230530220436.fooxifm47irxqlrj@skbuf>
References: <20230521115141.2384444-1-vladimir.oltean@nxp.com>
 <ZHZxn0a3/EJbthYO@bhelgaas>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZHZxn0a3/EJbthYO@bhelgaas>
X-ClientProxiedBy: FR0P281CA0052.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:48::20) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|DU2PR04MB9131:EE_
X-MS-Office365-Filtering-Correlation-Id: dd769c17-599e-4637-6277-08db6159dd51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Fted+wFUE6oT5a1YTjzXM56Ub+P6lVGtSTdkQcwFWtDl5mcavvDwbzd2kCp6Au76hzBHTA9OlptPjYxSFVZV9ebVNk44OQ7GGVZ7nW5j8eo9H2qdHpujrP65yxasq4S8MXY5l71TvGs42S9zNxbUDYrp/KmobKEGkPHTt79l4ryBWML13eJf6ebN2dbJz4rbzJ2WxtO98v9JJBWuwrUIgaYoeYMXFV7/AbUxMPcqe9M0lMgdRcWVx+7AluIIrfFDVTmkkg9N+s5VokSBEZ7A3ZoPq/DgebD2N3ksbialuKC/r7XcQKltj/t+v05BRYv1QUWPcKunK+Id5rUMfxD0E5820c5ggVYi1vHl+TrLn+mM/TzzD6RWOjmYnd2PXgXcH+TZiKhU6T4IZ3DvXmDbEMNFOsY8DGfIwf3BbopO1Im+xn/PhcKlKvQbeASPACsJjaDV0yQZqh0kVugQfdISgqozOLtoqCdBX6jmYWlUCFTzNF2x9Z3w7/ZlQ1kQgXc06Qr1fNzcLr1wOI0K9+bjgURRMATfhMI8pQLnG0L+AQrIHlNUHE3D3k1HitQZRLAo
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(396003)(366004)(346002)(39860400002)(136003)(376002)(451199021)(33716001)(83380400001)(41300700001)(26005)(9686003)(6512007)(1076003)(6506007)(186003)(44832011)(66476007)(66556008)(316002)(66946007)(8676002)(5660300002)(4326008)(8936002)(86362001)(478600001)(54906003)(6916009)(38100700002)(6486002)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?gOx1NtRnJel12Y3LxS0twQtymKlcMh/WlN0+g27r6L/q7KnA9QAJd2syIcH8?=
 =?us-ascii?Q?F7njaYrALTgg74/q7FPaHnAk8AEWLMYGy2/GLor9lDlLhdlNB6GSHS21nnXt?=
 =?us-ascii?Q?ZOjWYK4ya8dpxwuTBn7F9nk7zT+G8JLtZj63/+OAjm1da8PSgogF5EVJkMZv?=
 =?us-ascii?Q?qmuVDcXp65P3Oj3izq0kI18L8UMuM4zFdeKWZpdyJvUPyvf+UHsSPJ+lZZXd?=
 =?us-ascii?Q?jVLxbNzIIlua0H43l6oKtRWn18Avtmh/8WtP55SfmpTMr2dEx0shuFvCwC6W?=
 =?us-ascii?Q?Wg0hkGnGeq6FIUOawGQFtWL4tFbntp66PlRSugrHk3y+YGph8A8tLmE6mBc4?=
 =?us-ascii?Q?gyLEyhZk8GgJ2brjsJN1//GGB0VqETSrt7QDH9fAMUGVAFEQxZ8yvM6uS6nc?=
 =?us-ascii?Q?qh1blQBwUu3Mt26O6aVBvS+NIS0UfqQp2bds5aAu77lG7YejGloukoXDA4kH?=
 =?us-ascii?Q?TjEY5V50SJ2EfDJlmyEP7r5OJHcl7IAIaKElmZzA4ybiK/e4XMN6hy7FDdRM?=
 =?us-ascii?Q?K0/Poj+FKxW1eVfJUYlpwiNdv1hV7PoOhmvIDetTt2AMGwSNwymtA9/Z+Ixg?=
 =?us-ascii?Q?GA/p7MdD6lGLdyOJxyoTy/w66lOpCYif2SAU2XdoWZ3cAdiHFvCdfzFRM5Lp?=
 =?us-ascii?Q?P9k+H2zmKpN4LawL68e4qMyh1b6TTDVuMyxs9vZSIlRSCQohgVmSfZFvskxr?=
 =?us-ascii?Q?u1LqQqpU8eZf5fQQtsxuvjcfHQNZEx4kEZw4a9asN8JlaZcZDfcQPZhQ1k2s?=
 =?us-ascii?Q?opo4hWjbYTvjqx91GjUp9xxXY2tl+KUwLwKUMbWML5WnCOGoDE7E0c0eRiW7?=
 =?us-ascii?Q?0qOd2BSR77sl7hYsiMCoTPDItzEP4HD7XjAd9wUvvLtmOmJy6JguoAMZlks9?=
 =?us-ascii?Q?NRLf1cKxbgfEqef74sGulQdd217HbpD1FIzAn1WgW8r0MxOz4lerjv1D1ijZ?=
 =?us-ascii?Q?YlEC1V4w8qvftYcyYoG7yIrktdJZAAa7uHi8cFgeU8qNNsC9ZIkfzN3L6SWm?=
 =?us-ascii?Q?d2NIbkP/CUyi7QQhapZ7ohCbBuFvyc5iFAYLNtrxJQIK/arMU8L9HxKnJgHj?=
 =?us-ascii?Q?lRXTTyhg/dLHC/irM/LlyvQGRMVIHX43MdCTU+IbfNWIJe1pkv7Mf5EcrK40?=
 =?us-ascii?Q?iQZTy5w7LzeU6o0Be6umuQlAb9HqjH37yVOeyT2GPQZGykAgj7FAYa62NbII?=
 =?us-ascii?Q?wj09ZTnLSDqkMxo+XqkgoJQixqpMEaHg7L6oPhbI/gmnLw6L7UHvvIwLZvmq?=
 =?us-ascii?Q?MkwJP6ID+Bf29DUEQ4LXvvuAqEP7nj48vVEwHsKl4IEz9dIRS1LFEDiCEGnv?=
 =?us-ascii?Q?T/s/l6uNLzmuqoP8k+tSg6ZQW1nBQ4DdxWrUJufmQ3M8ZFENE1I/ZL9cpmwK?=
 =?us-ascii?Q?/MzzftaTgwhFnEpZf1WhrxZh4xeDtvfNLoQPd5t0MABW6zSkompKb56Pzudq?=
 =?us-ascii?Q?6jwa/Gga7rFGkLtJHofPkSdABghX0lKZ4/me8YVmaraz6DR3bnbIYUjQfK5v?=
 =?us-ascii?Q?HsRbLQh+vWRjBlYs+duAsk9KSu05BaJIopY+x5mP5xR/tsW/znXCRFhfPFvt?=
 =?us-ascii?Q?w+cRpkFVLioNc43gP4wqrYSXlDsxZ5t1wsIJjaerfObaFd4bhGGaGBBh0lPJ?=
 =?us-ascii?Q?5Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dd769c17-599e-4637-6277-08db6159dd51
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 22:04:39.9357
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: i9fHBWtG1j2AgVD4wvEca4293TtsKPPhuAm/0PkJtYA2qpbyH4GlocVxcvk9uccSkyLT+k/mDsWCYsOEaG/jcg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU2PR04MB9131
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 30, 2023 at 04:58:55PM -0500, Bjorn Helgaas wrote:
> Can you write this description in terms of PCI topology?  The
> nitty-gritty SERDES details are not relevant at this level, except to
> say that Function 0 is present in some cases but not others, and when
> it is not present, *other* functions may be present.

No. It is to say that within the device, all PCIe functions (including 0)
are always available and have the same number, but depending on SERDES
configuration, their PCIe presence might be practically useful or not.
So that's how function 0 may end having status = "disabled" in the
device tree.

> Sigh.  Per spec (PCIe r6.0, sec 7.5.1.1.9), software is not permitted
> to probe for Functions other than 0 unless "explicitly indicated by
> another mechanism, such as an ARI or SR-IOV Capability."
> 
> Does it "work" to probe when the spec prohibits it?  Probably.  Does
> it lead to some breakage elsewhere eventually?  Quite possibly.  They
> didn't put "software must not probe" in the spec just to make
> enumeration faster.
> 
> So I'm a little grumpy about further complicating this already messy
> path just to accommodate a new non-compliant SoC.  Everybody pays the
> price of understanding all this stuff, and it doesn't seem in balance.
> 
> Can you take advantage of some existing mechanism like
> PCI_SCAN_ALL_PCIE_DEVS or hypervisor_isolated_pci_functions() (which
> could be renamed and made more general)?

Not responding yet to the rest of the email since it's not clear to me
that you've understood function 0 is absolutely present and responds
to all config space accesses - it's just disabled in the device tree
because the user doesn't have something useful to do with it.

