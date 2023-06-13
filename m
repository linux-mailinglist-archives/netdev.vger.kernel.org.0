Return-Path: <netdev+bounces-10467-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7156F72EA12
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:41:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 156122810B8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 17:41:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 35E443B8CF;
	Tue, 13 Jun 2023 17:41:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2845233E3
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 17:41:22 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2134.outbound.protection.outlook.com [40.107.93.134])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390EEE52
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 10:41:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YsVrlsYWd5HYpHpHzVN+mZPhgMgqTN+qsXuYmaCFzDSmluEiyZ9JUjPdi/S4tlaKXNhXHcPWoU/pmQ90tZAf4HuUXuD/lc8ZSSqE4QmNLGNvp6h2QvA3QJr1VnnepIwM9oGrBnaRRiMSsqVaNVmp2GVQfxjQJHexkX4oewsx0ntj/1MZMu9GEB2yuScCxLMs8xksBuandUck7bN25R2gZXtAmUqeryM3As3tM/OUrsfa7d599nVdyCuez7mdCloSLroDWlJ/U8+N/YNZi5CY+gj3en2141CC5GX7DDzdxRNOBdm28T5TgYK+c3qXuv4CXVPZsEsRmIM0/pi3QZdS/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=i8qYkZffaBK6z5iXKDpKKzc1Vb8dqFsIR3E2ElfaM7w=;
 b=fQdneciDC6aDpckp9ANo3ZN82RYyLnLVqf6GSWDxrt5Gv09iICaAw8sDDIBgZwtJNGvZ5TNoQMoENauB9Ma0cwgCuELf8WBzOpLau8Qm1s5RV+gv4de2BnIjjKX+BHSI1eCfcccCxSLCGojMTTLFPrS5S0KqFC2KdsC78uobHNsQYB+Lg9RlUc+KKA3BGYJlTIGhdV3Px6gZ5HrXwtpDUlQnuzwAUCB9FS5zBeZpWTEVbQDVV0cruxy8+kr+7OvgFHQ8Ht6UCbl85YYtKeUBMiSFWC2S55rjclThOY6qnB4MRrB08+CQ8ui77wVgb7mqbzitg02/eibfIUyiholgJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=i8qYkZffaBK6z5iXKDpKKzc1Vb8dqFsIR3E2ElfaM7w=;
 b=i2ReW2v5Xsuv7Wq8GIMpV94Giw1X8JBwxrBncYsVil8GRK7Mk/vZWBWQrZ9lyMMJUN7Aug/UmhQKNbhRFXsC/BoracL7ZyQJA4Ofll74k7P/ceiqTjeiLr+gy+YfgXUz3wMOQ1TUFzUKOoburGJ8UsLVz7WVbb3P9xgT4oiz7mw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5066.namprd13.prod.outlook.com (2603:10b6:510:a0::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Tue, 13 Jun
 2023 17:41:13 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 17:41:12 +0000
Date: Tue, 13 Jun 2023 19:41:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Hao Lan <lanhao@huawei.com>
Cc: netdev@vger.kernel.org, yisen.zhuang@huawei.com, salil.mehta@huawei.com,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, richardcochran@gmail.com,
	wangpeiyang1@huawei.com, shenjian15@huawei.com,
	chenhao418@huawei.com, wangjie125@huawei.com, yuanjilin@cdjrlc.com,
	cai.huoqing@linux.dev, xiujianfeng@huawei.com
Subject: Re: [PATCH net-next v2 2/4] net: hns3: fix hns3 driver header file
 not self-contained issue
Message-ID: <ZIiqMMDMAV+asw7o@corigine.com>
References: <20230612122358.10586-1-lanhao@huawei.com>
 <20230612122358.10586-3-lanhao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612122358.10586-3-lanhao@huawei.com>
X-ClientProxiedBy: AS4P189CA0017.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::7) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5066:EE_
X-MS-Office365-Filtering-Correlation-Id: b0bcb8f6-e252-46be-ecce-08db6c35615e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	A9ZSoZ4Rj6NrhtABN4fFe3Sla+KO6isSruiiSbnCb5OYVRBhqYvt+p4PWwMRZS0cRxZ6VzrfhizDFbuCm+XI9tW0CV1xAsS4qr0KLqqJzYSy3o1khE1XSTW+H04Jk8g/oXysZ3F6A/XzUF6uSLcwQW06lVHJeraKmEKw58qlJehsgUvnrY4uSrDQMg9Od0Wr7jPgeOSgdra7h97/aTqMq6mdu/Bgw75ai61bZLJg4zcgrMVWxmA0u5mZFzVbEj/WUeBemQDn13PWLZoeCjMQYcg3dG8eceBCq1DkRxwDbBN8iVNk/oD6NzuleBKgPySXNnV2pkaN6BJBqBKx2ObgfEUdzhH0gPN4RFwKJxCjRGs8cLNRHtpdqtrCJvS1ePRM67yRLi3rfKEdN7oQVzOFPPgJcdFgB/Y/Mdaf397Q/rg5prQwYTFtKS/KGzoTR54DQZFDj6g0ORgx/hjKSws8OKXqZH1aYSeVQO6eSjGYPfEM9mHTzCRkOAsezwmzia8oVyoJg58QX418OTyTFYscQ6FeD7iz7SbQlbc1wiugamk3gp7hU+nDYfm6Wu1tDMJ76jyLFSP94txLv6lhCTAyxu1X4nIGIpqOfVac2vRxmPv8PWXik0wriiX5YqrJoK0lmIo9nyDCCPYSvJaamCm95fVNtpxrVRqxWCXQdw4ktQY=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(366004)(376002)(396003)(346002)(136003)(451199021)(186003)(6506007)(6512007)(38100700002)(86362001)(7416002)(44832011)(2616005)(83380400001)(2906002)(4744005)(41300700001)(36756003)(6666004)(316002)(6486002)(8676002)(6916009)(478600001)(66946007)(8936002)(66476007)(4326008)(66556008)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?5JW7HOSh0QP9xtfuM8bd4YUk2UhthHlSaUAtKTRn743HMtbr1xqGlX8CVNa4?=
 =?us-ascii?Q?AMKBGN4LfPxMPmm/QbDyzTN2VctPGoMOm6QR+BhlKrOQygOVo6+FVW78gh35?=
 =?us-ascii?Q?J3pQ0gwIT09jYAlHX/Nb3U7rf+Un8hlPVmY/EDZxqzZG1qi33LTHEsfGw8eF?=
 =?us-ascii?Q?9Lc9rYYCeCS8Sa6gp3+vslXj6dnioa2gLAglaeAgZpB2IEcDpI6LNB/nMYkA?=
 =?us-ascii?Q?/n5t67jtHBbw/+Xeq5y7QxUHRzCALfxfeZbRMjvP1cXt99AT6WmHmnNh6ktR?=
 =?us-ascii?Q?OzJCTUueStahsX8v07gIK4HzxUQRfhl7Dupt1o5KBiwGq5xotkGUua1aQmGQ?=
 =?us-ascii?Q?vMlPjHWO+OnE94vYYmYInuO6+Z3BO8JH6teHOeFoX6inIeqm3LBRQ9J6Qsh5?=
 =?us-ascii?Q?cOGGTyd7ftk2Sdp1TNcZk4Ukts7DYf2q5tf5mBMsuM5bN1Jk9rQTYdMsG2ki?=
 =?us-ascii?Q?SatggjKJ0k+MRkTZElCN5JaL6/BKvuLU1XL4nVaIJjgXknWevp5aslelFJkl?=
 =?us-ascii?Q?1blDZM2jecuQXG4FJrAI3F4dJ+yd8PkeRYATKsKyX0MW6G+SVForj9y2jZzG?=
 =?us-ascii?Q?p0kYUuQt7e39ODBokmwvBw+tpeOctQLeOLjt0BkT3mMjh5v9uu0OzIhiJB2c?=
 =?us-ascii?Q?ZZLWhW557v5svdO2g1rHZXa2d95XdiP5YXMssuj7u2QVaeo4pf916eihfWJb?=
 =?us-ascii?Q?wokFSKhhbiyQ0YY6EFcqR2QFSUGMV9YjuYz+lNa7vqqwvQOtV5SCJXEr3LR5?=
 =?us-ascii?Q?TIiSZeKjydrdcFx6g5GnSFE0Jn28oLOnNbMk2yvpN7CEOvcQIY09R4WOpU3S?=
 =?us-ascii?Q?dSZaGCHWP0xgKKPTE3G+5sn7mXvFtis/G2rOslyNJpdLgmD9S2oFpMDuqJgW?=
 =?us-ascii?Q?Qsbm6qmH+Rh7wEgP0k74SWkPnzNwvBS9XSJ8IOYv9zvfwmzDZg3vvg+FhmQ+?=
 =?us-ascii?Q?lY2o6rsOvsLqTr2O8GvS66C5mT6tDSNKA9nbsZ2SDRVcSxh+TwjXfGn2GzqK?=
 =?us-ascii?Q?6WFRtIFIfm+iRWChTuU0n81iR6x49JLWSziOFrx8Q0b7+4Gq39oohxqbZVOC?=
 =?us-ascii?Q?LWT3wGKol6jRIZvImDBbRwMq5FLvNw0GbAx+fAt5dAdonxcuGPxu0Bjixlc1?=
 =?us-ascii?Q?I2ZdxZAB1V1UgEz6yKqbmlM86xuNlqdbNZp8qTOktfk9hCP7thHhZs9f5UNC?=
 =?us-ascii?Q?tgNmJCVj+TkNgAcK/LZl4mcpUTDG7xsr1bQRNr3YdLYjt4rpfHcY+i0jqeAp?=
 =?us-ascii?Q?qdJ4nmlc67WzIFL0MCvFPtTmLeUbEapQQX1seGnwaYPGUJ4qzgXyzG8pOLOR?=
 =?us-ascii?Q?kOOdpjP/d+ljH1VKaufo9gKzIHC0vqfTAn/ViD91fFseCtur0sDutmcEyTqw?=
 =?us-ascii?Q?DoFbwRL8CAduR7A97hy3d6z2Hfdof01MJ6aJ5Vkn+c/UU79nAXPTvXx+5TMV?=
 =?us-ascii?Q?dD/rk0rycA/igcQgXzf2ViZ+wf1g+iHM7c5UNsVoUio2sceFFhX+Syksb1L2?=
 =?us-ascii?Q?AwNxUMSBE+FTZYSxPBEStQRsDaDmF8/dT7lwY3TmMTKLrC52SjjEnXkpSjSu?=
 =?us-ascii?Q?C4j5wFu7iM/o50+tAzblw4sLsiBH6Khu8JeZbmlgtq4zJxd7DZ2+5oGyP3X2?=
 =?us-ascii?Q?zZ1jwy+cAm90KnGimY8dL7GidCRJ7EK1ISZBP8KLLIwX5vPFPBwOqiNNju3u?=
 =?us-ascii?Q?dSI0Iw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0bcb8f6-e252-46be-ecce-08db6c35615e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jun 2023 17:41:12.7734
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qym+uhfDV4gVOePaMyhR+4i2yy542wvbzfetxsTIkjFEJ3dq6PuXsIRBbAALpzcPm/ING4GihJuGZPRTjTTwbx3uWcY9raNsUkEUO6b6ZJw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5066
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 08:23:56PM +0800, Hao Lan wrote:
> From: Hao Chen <chenhao418@huawei.com>
> 
> Hns3 driver header file uses the structure of other files, but does
> not include corresponding file, which causes a check warning that the
> header file is not self-contained by clang-tidy checker.
> 
> For example,
> 
> Use command clang-tidy -checks=-*,header-should-self-contain
> -p $build_dir  $src_file

Hi Hao Lan,

I tried this with clang-tidy-16 and src_file=".../hns3_enet.c"
but i get an error:

  Error: no checks enabled.
  USAGE: clang-tidy-16 [options] <source0> [... <sourceN>]

I feel that I'm missing something obvious here.

...

