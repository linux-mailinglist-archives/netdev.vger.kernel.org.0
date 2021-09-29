Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3CA41C290
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 12:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245553AbhI2KTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 06:19:19 -0400
Received: from mail-mw2nam12on2102.outbound.protection.outlook.com ([40.107.244.102]:53985
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245493AbhI2KS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Sep 2021 06:18:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JHy/HzQLyC5taefBYnRzN5CDLHLEC4wub233PE0dS1csKDdTD4m2aL1yKAk3g0zuyMANYBlldPH62u8gtTUaYskZurrFwcaxXgSjX24iCgJA9/aS863o72TOaVZnoLx9qCKZbzfftBtKqKPv3daDituA18wSfV+hfRIGcjds5r+LzLt43MrI1Xo93gX1YnanWn0SA/MW/qdjm5HiLWdIBk9zvY5fmWFOSlQwisy7tDBawdVGiaY8mz47Us4q6x114ekWSzG9mMKt1usAhJi1n5uf/dKLYHTW7WDi9NSq0QWizeJsNfzEmcsWHs6o9rneV2E0NUI45TpMVgRtJIRw3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jyqPAoKXGoqzpWfcWDQA0QwX4xHbYvKVNyPoyY7h72Q=;
 b=kWg++jg03mMjgRVM+vPlBgD4sjtUMfAwIUJq0JiHvTjQrZssLStA7SHHtCEnWcbyLhIv/6YTMK78xFHR2S/a+GccKEzislngQCzRPuH5AzfMUiB6YC9Aa4gx1ptEWymt18cHCpkapUGDQ0GfjE/RK97znUrmQm2JbPkjl3tNnrjL939lGiaN8efR5SxvEy3YQxzMditmCZGVYm3ROWiTtkPzamLWHGISGtSEG85etwxDAkD3MbhUzTMlNzVrs5/SLBdCZfoE6mpc3nf+n4A2Q2bUJAUd870q/33NKzocn0BVgVg1xpERqj1Ti/NnZNvMsbRnqezmmgr8jD0U5UGnGQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jyqPAoKXGoqzpWfcWDQA0QwX4xHbYvKVNyPoyY7h72Q=;
 b=AseZ8Y/f5Q3D2JFsjs3t/qCuRdo5v/ugyaDugSgCGc+6LamTeHB8Cn22eypA3E9Ofe+Pqyu3UNuavFNsLvCXDoA8QB7W98ExunO4ljSq40qYYkVJNgfREtVLQC0Rophu80VzjYLpUjinQQahAkGuDNdt7lg2CsfClvVbR3ivysU=
Authentication-Results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none
 header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4794.namprd13.prod.outlook.com (2603:10b6:510:96::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.8; Wed, 29 Sep
 2021 10:17:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::e1d9:64d0:cb4f:3e90%9]) with mapi id 15.20.4566.014; Wed, 29 Sep 2021
 10:17:13 +0000
Date:   Wed, 29 Sep 2021 12:17:03 +0200
From:   Simon Horman <simon.horman@corigine.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Bjorn Helgaas <helgaas@kernel.org>, Christoph Hellwig <hch@lst.de>,
        linux-pci@vger.kernel.org, kernel@pengutronix.de,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Zhou Wang <wangzhou1@hisilicon.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Michael Buesch <m@bues.ch>,
        Oliver O'Halloran <oohall@gmail.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH v5 07/11] PCI: Replace pci_dev::driver usage that gets
 the driver name
Message-ID: <20210929101702.GD13506@corigine.com>
References: <20210929085306.2203850-1-u.kleine-koenig@pengutronix.de>
 <20210929085306.2203850-8-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210929085306.2203850-8-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: AM0PR08CA0026.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
Received: from corigine.com (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR08CA0026.eurprd08.prod.outlook.com (2603:10a6:208:d2::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.14 via Frontend Transport; Wed, 29 Sep 2021 10:17:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ae53e499-2baf-4888-966a-08d983324dec
X-MS-TrafficTypeDiagnostic: PH0PR13MB4794:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB4794052F35552891F4D9EA28E8A99@PH0PR13MB4794.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2woKV4HKG64SPX5X09IWvfN9MJjcMKLiccyCSNNbpi5SXBR80DUgmbO3bcGUkNgQsWYyUK7aFq4caJKLKe+uohhUdK+4SsDPipTF1dG9UlV5xiqAHuC2s51WZiYCjvl053pSjl2OcoA66YdXS5gJStSr+TGo/unGtQJ5gOAWxp6PwBLd1IuLW12QwYEbzsUitqUYISrWOdhps+dqK5DqpiqJWQ8+VkRc9L+7p3TMJ2V6hB+tsVSo3zJrJ2/abO4nKuOHi1rX6c0yrn2u7vB+MwRFCWLnnkRR5Kde7tfGCWTdgYyKX+kDsHB3tSsRnFHzbGg7n6j50mDYK92eQsrXFASzJoD7L1QyLpRG/5kIBbqpnBTkOhPPrsBW3tReAgbWunAq8NqJzv8fSLFjjWA7jZr29qRGaI7anpj81ZDZmsiw4yuqJsAdbHdjxHCNh9NPV1wiedg2hmjtIY/D9oygroAgrH7a5ssAdlE5QVK4QBMc57NKKpzA066Hrl2zLbZkCUY86X8Vae7o4bU19hQ6TOWSdWwy1v7CIykDA4U5li8kbzNxKwb9FMgLv3CnyZXqGGoZmjwr41SMu+2YG11sC+dxQHoPjbHbIA4ZCyrMyv0R+DsYJcFsLn4N4c7AJs7Em1/mLdZZ0KAMVIa4PozoRg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(396003)(39830400003)(366004)(376002)(33656002)(186003)(36756003)(6916009)(44832011)(508600001)(86362001)(38100700002)(5660300002)(8886007)(55016002)(8936002)(52116002)(316002)(83380400001)(7696005)(54906003)(8676002)(2616005)(66556008)(4326008)(6666004)(66476007)(2906002)(66946007)(107886003)(4744005)(1076003)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Yi9ObWFiUzV6bDdYOFpDMEFXc3Bncm53U3F0M2JWYnNrQWFQZGpXWkhkbkxo?=
 =?utf-8?B?Y3JsUUpDeGczcHQxMGFwSXloMUtOWGRMQzhUd1p2WTVqK1NucmVRblFvSGVx?=
 =?utf-8?B?cmN2RnVJaGVqWjVFYmhnT1FROHUvcmg0OW5OZUFzZ1JRVjlvTGRkOTlCZzUw?=
 =?utf-8?B?Y3VoMDJSQk1pSngwekQvYTE2TlJpclRwWXBoSmFqbXllRzNDS0xHK2VTMEhM?=
 =?utf-8?B?QkZzMTQrV2tJQm1SWjBOc0FKYm5VTW15S1UwcVZyRTBrT0lzS3h0ejE0eDhY?=
 =?utf-8?B?ZndSb3pEMndUL21NSEt4cmg5V1N4WlhzVHc0RlM0clNHRFBiam1GQTREZkRt?=
 =?utf-8?B?R3NmVWtGaXgrTmZ3T2RLbGpobU9uVHhPT0ozY0xIR2VKN3NzWUpSbFJONjhK?=
 =?utf-8?B?V0dIR21lWkZZemJ4RlE3OEY0NkJGbi94L1ZKdVZ2MUNxUm5vZGRZelVVMHdB?=
 =?utf-8?B?RlNkeWZCVVNKMTZ2QTlYOTA5bE9zcVNYcmRIM3hkd00vTWRrWHZJc1QxMlRX?=
 =?utf-8?B?YTVKMmtIUzBnTDl3NDVSVDdGNW15eWNENEVGMWlnNlU4cVd1aGtDT0lLK1l2?=
 =?utf-8?B?ei9oRHkwWVFwYWYxbUZGN2VoZERDMk5zWTZsOXRSTUQrY1ZMeFRqamNWS2ZB?=
 =?utf-8?B?c09nc2hnYjdSbWI5NUlVWUlJK2czd1BncjFibEliOVhuNXRWS3FzMURPaW5s?=
 =?utf-8?B?eFgzZXdTdm9DMWc4T2phaHQyMVVVN3VHaFZVNjZHZ0p2bjhwakZSWHVNRkVP?=
 =?utf-8?B?UlVHT29SZHNPa3hPVFQrRjZzVXY2RXhncE1LSXBqOE9xUWROZnRBQndjMWor?=
 =?utf-8?B?MVB0UVZqN1BTZjZTVG1LYXVMVGRRc3QzVmdsQ1hFZFAwWjR0NFFMNGlBRWE4?=
 =?utf-8?B?SXF1eVNCem91WGpKTExHSlQyREQzRnJjcmJaYnNoOVkrL2d2ZDVYdjJ6M25w?=
 =?utf-8?B?ODBTbTNZZzRsbVZyTlY3NUl4dklHeGhMK1cwWURzQmMxbXprd29EaEx5TGRP?=
 =?utf-8?B?TWlZM2F3NGd6L2ZHSUhkdFlwQktYVk1NeThRM2h2OVdKc3Z3SFlOQ0d2d1Fk?=
 =?utf-8?B?TzBhaldlbVp6TlVSNzJwaDhZSjZXUXpPL2xneG1GcHczRXM4WXJZM08zZHBa?=
 =?utf-8?B?NDdsb3B6ekxxc0ZTZ1ZpN21URk04NnpVTEpPVVBocmtQUzM2a1VHS3cwZURX?=
 =?utf-8?B?MGVFdFg3M0JJR2prcFprMVVqUk1WQTE5OEYwTjdiZlNLZGZkaDQ5THdXMmc5?=
 =?utf-8?B?TW5ZSXpOK2doV2xSZVkrS2c3bmdrSndUT09aMWpUYWErZno1S0w5RHZ2ZWNN?=
 =?utf-8?B?NmQzbThxYXlKOE15aGt5b0pyVGExdEFpdU8vYy9oazBRTTZzdllTUUdsSDJu?=
 =?utf-8?B?OVZBN0t2Mkg0eC9hd0hsdFA3cUdvSUxCVXVlWmx4ZDN6dkRtNWpET2ltaXJI?=
 =?utf-8?B?bldpbVBFRC9kNmloOVlGVmMxQmF0MUFneFFzZXpZWXpzZndoNm0vZTRESkMx?=
 =?utf-8?B?dUZlRzQxZjFFQm9Xcy8vQ3ZzZEFSQzJtNVY5MjF5WUhNOVRlR3MyMng4MHI5?=
 =?utf-8?B?VUtRTFVpQUtHaUY5L2ZZMml5aFM4c292NjVsc2JsMitsZlk0bDZZejF4SDlU?=
 =?utf-8?B?WFkySkJKUjJrbnpsR2RhdFgrM1JQOTR0aDBNT3VZbFkzY1hxT0dOVmh4QUpD?=
 =?utf-8?B?Zy8yRkZLYjEvREJjS3dZWm54TDVmZktCR2ZkMWR6L1lWQk5LcUltdG5wT3g2?=
 =?utf-8?B?UE9Bamhha1dUTFg5bDBGakVWbGI5T3A4M2lHMnYwLzNPM2pxOU9ZRVc5OFpN?=
 =?utf-8?B?eVRRR2xMaHFtcXBLL0c3ZFgwaTJRb3RHTVNwc0o0d2h6RGtQdk5LK2FGbFYz?=
 =?utf-8?Q?H62UPyy2H8Shc?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae53e499-2baf-4888-966a-08d983324dec
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Sep 2021 10:17:13.1546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83M4CGyBYqSrVCFUH5E4wuUsm79KJB3+U8Y+LE+7kTxGcmB6HjBddsjB4+LvLnNP36y2wZZYatZg89+LHLjQkk+cPcB2ykuOEbbZDTiAbHo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4794
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 29, 2021 at 10:53:02AM +0200, Uwe Kleine-König wrote:
> struct pci_dev::driver holds (apart from a constant offset) the same
> data as struct pci_dev::dev->driver. With the goal to remove struct
> pci_dev::driver to get rid of data duplication replace getting the
> driver name by dev_driver_string() which implicitly makes use of struct
> pci_dev::dev->driver.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/crypto/hisilicon/qm.c                        | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c   | 2 +-
>  drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
>  drivers/net/ethernet/mellanox/mlxsw/pci.c            | 2 +-
>  drivers/net/ethernet/netronome/nfp/nfp_net_ethtool.c | 3 ++-
>  5 files changed, 6 insertions(+), 5 deletions(-)

Thanks Uwe.

For NFP:

Acked-by: Simon Horman <simon.horman@corigine.com>

