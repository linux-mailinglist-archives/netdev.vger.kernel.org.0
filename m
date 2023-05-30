Return-Path: <netdev+bounces-6269-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 82D75715743
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:43:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3ECDD2810DE
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:43:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5BBA125C8;
	Tue, 30 May 2023 07:43:07 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94555125B9
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:43:05 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2124.outbound.protection.outlook.com [40.107.93.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FCD4E46;
	Tue, 30 May 2023 00:42:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUA/TKDOtgLVZP5+7JrD8J6OblR06w8s63NJJ8xraumWO8/bEnJq8WUOE6wuVXaBHhyZgRixRbnYfwFFFk7IRpfr6wRqF+kkivz54p/lp3yFQMH9m6Rv3o+50X1B2I9sGowhsSC5XmrQO3HFaYxOerd39b8EEzcm62D4wFThuK154tWmPbogUsqzxi6rhlSlWmJ9NMcdMHrdKSkEv+pb4whZZT093dOof+U6UCULRhPmOxSJFdS7WZPz4VRAxN2cWdOgO7G5Pv2BG2S7KOGTUmBEhHu2WIpr4o3z7hK1JlwasLCIX9tgkypjVaKgNc5GkJw31YdDeR2iy4LiJzXMhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A0iTJoOUKYcCHUVonbCEsrr0Qn+TXSrDhfbjQeh8Mgs=;
 b=IjpuOAqa6dCQVoUIvdjwmtadplDBZWd5YK5fE4tJaj3zZ+r0m58bYRmHLW1fMD3Px6zVadEYgGai/R5LxitrWCZ50k/LNI9XTLEdYZl5dr9BdIoWpLbFiLrsFHFjfaN0FaQ5X5uI2uCfehN5WR6lmxwDOQgc96Ttguj9xRIQrgpmyWOFnrqUqc+ZFWPjJ4gANTD9viTBNRTRTpatZi4q6qmcUQvjXRyh+4ywyKsY+Y7osJAdEfk1RPS9qTnO8DUzL/n0vg/DwdBn8LqPFHUiq3SY2nT21bxwACThRyxrPNeQ8xglnt2e2BxS0bpJWb2wXh3xEEUgmGzUjJgTbGecog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A0iTJoOUKYcCHUVonbCEsrr0Qn+TXSrDhfbjQeh8Mgs=;
 b=aXvzQD3Zyn27kXKCq9DC8R+23hhMrRKXtoXRep0wUJFFbEFhm/xpKAAduRVl/lGY2Us6F8paXlE+IksTs0OqESqySv0Rn3QH/lWLYf6d1N5UY/AiTLLHFHQ2hJvH33QuX18oTVMWCJhnqBhel0bM8En6P0YDe0T4RoO3f1L4Lbk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by LV8PR13MB6494.namprd13.prod.outlook.com (2603:10b6:408:190::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.21; Tue, 30 May
 2023 07:42:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:42:26 +0000
Date: Tue, 30 May 2023 09:42:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Stefan Schmidt <stefan@datenfreihafen.org>, linux-wpan@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	Alexander Aring <alex.aring@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next v1 1/1] ieee802154: ca8210: Remove stray
 gpiod_unexport() call
Message-ID: <ZHWo3LHLunOkXaqW@corigine.com>
References: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230528140938.34034-1-andriy.shevchenko@linux.intel.com>
X-ClientProxiedBy: AS4P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5db::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|LV8PR13MB6494:EE_
X-MS-Office365-Filtering-Correlation-Id: 147bafe8-0630-40b2-7bd6-08db60e169b9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	yIx8WZlsgCbrXKLR2DHKBdZmyv8lMGjLelfncKv9MItdhM1nZnIjxzAnh5lvBdcZoNSolHQGnvpIT9/552RN7rfX7d6TMnxPUBVa62vyXKx4egf4cHjBFljMYv7Wda2GpFBZfl9b2wb9Z69UR4Csffx5Rmiqo02gpeiZD4NehiwVnURuQiDVhAzdlfruXXyB1oztAOPOU9KIjxyzi/qmZzaki4+Matawi4ewvpX3/HkVHC4sMTPFthu622pasCGlt929q9j8s4bJWK6wAofiojO1lAw4Tpm8hxSk8Kg2pZomHRlCR0eIjxcMArK5zDkCYhTsgMwtX80WKXv1NugOqK5qja12h9LybzVYkmu6cTfEXVM3UCql74gb2fb7HAYwpY4N7coBFnIDwjdg7DZb9V148XEbQ9Tj0rxN9kD5b3UzNNNqfLAvZzfoFP+5JsgpNrbLs8e1tO/9M2/+BLV96Mn6+oDdadT326c2CpnW02Q7RB/xzNR9wqqcwwXHOSS/uHIVzhLs+6v57q1M0IbXpuX7lHRjWFR0pv+Ix2Rve4Hw7Kr60wYNECiidrgOUxPm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(346002)(376002)(366004)(136003)(451199021)(478600001)(54906003)(8676002)(8936002)(7416002)(44832011)(5660300002)(36756003)(2906002)(4744005)(86362001)(4326008)(6916009)(66556008)(66476007)(66946007)(316002)(38100700002)(41300700001)(2616005)(186003)(6506007)(6512007)(6486002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JmCjG4Sp4T1ByPBNA06rVgXOe1TpcqGHATgK2Cc8tqItJWPzbOMMv1wcoFg6?=
 =?us-ascii?Q?J6dUNCylMD1opbaNPuX+yPs+0maNDk5Zkv/jg92FFz8SouWHy23KkEk4Idfs?=
 =?us-ascii?Q?JzzB6fi+jlq1hYqDGUDeZWWLWRZenFarb82NvdtyF5m28E8BVvApHHQ0Ka7M?=
 =?us-ascii?Q?liE9dareWgbFhZFM3A+JY1rx/V3HzZJDf9mDvjg9GUQwHQ3G/j1zGXkt2pDg?=
 =?us-ascii?Q?jwx78SYTtHXZKzE+uwh36unP2dyttZqEy/4TjK70HXKSNzTKG4smU66JQVh1?=
 =?us-ascii?Q?okvzga/53sxwyiEcQ6CxXQ9atxHkg2LWqS2iBZ86niQKC65XTZLN7bVvFfon?=
 =?us-ascii?Q?JQTfsr5TWagyij9U0vMLy8mOa/+2N7RjayMwQMUI9w+7u65JuULxB90mXvMS?=
 =?us-ascii?Q?QB0AvDSDeIx1ihHuMjDFkRSf5KrkmbCjT2cXjFiivGA9aIEzirfAOAaF7WOw?=
 =?us-ascii?Q?e5Y6Alhia9Z33j/PO2Pub/mlHObaozLtybxPq+1PMsh/QLSZK62nNGB36HrQ?=
 =?us-ascii?Q?hBaqC4I4nhuO4KHZGp7+YYnVDAvj9iSLtbsCaMB3ZQibA8gZlLYUeDmbqKNl?=
 =?us-ascii?Q?naN+MFrO7f0ntLoD7v1lFRulBnQvQkqR34PJU3RnnKXvCM11Zhr9bOOr3AGm?=
 =?us-ascii?Q?QarZNxnsNCyELT3EvUHeM+2bm5mMdF0HvSDnxosV97o7JPxkSPfgcxht1kxQ?=
 =?us-ascii?Q?tmba8pRzsVZvYaVYr105FjuWDwgONGyNC9af+fdZmM+z4Fuez8XrITnLlRnY?=
 =?us-ascii?Q?Kl7GDxyz5pNRo5/gpXl625XJ/0ig5Tt94/a6emOAuVAtrwls+WcUC3iCGTcJ?=
 =?us-ascii?Q?uSOKoPd3U8eX3Uot+L0a8k6SaAbsihcPBzDuUfSfSEJsN71wb7Fr8W7TnVDj?=
 =?us-ascii?Q?cfttr/uuFPzAc+nyd6ktxxGac4VUemtjIdw5vSDKGK9T08ipuibeW2hXPDUu?=
 =?us-ascii?Q?o+3Y5lC7MGysIb5+BbygblVhlX4g6JT9fQbD5zKDoGo/M8JNaf7Xx4WyT2vm?=
 =?us-ascii?Q?GVKJcQCgjI3qkyq5xw1u02PHPOpD/+SLerJv8A9P+VNWxwF8AN6wSWOLXDbe?=
 =?us-ascii?Q?IrPgiLMaO615Fra5ZI2oLuwGHrlaRYbnZzUoWRm3I+r1gamUAqzm6RuvbiKC?=
 =?us-ascii?Q?HwuaBYGCbPLm7YDhWeJvOQBJzGCHrNtqDXfsePGiaGVeziOY5EEKH7ysFYCt?=
 =?us-ascii?Q?TayICZRytZhPQ2LstB3AxHEPH+lPShjAe1CCewGa/4WRmTVYowcKbI1H5ej7?=
 =?us-ascii?Q?t6NBx1tHnIEj7+w99uekdAtvuiL8XOusmScUAlsRsp9eXyFk2eoCmELpkYg6?=
 =?us-ascii?Q?Pe42VF66PeLPWn3DCzgfjnXfyVlYEslqsP3Rpw1QDJnaDLK3I5phC9DlAeu0?=
 =?us-ascii?Q?EBN9v/COZgYV77W4V0ltjWG7IxIWMPYUdITzDCDuetuAvRgkaksJBYfYPgqH?=
 =?us-ascii?Q?Ll2P8jnKnhBpRD/umMhACMY4thGnxd5Xr2y1+sRLrH/8UfZf0RfQKjdP85pI?=
 =?us-ascii?Q?MKQvx+wWnaXl1YzJzvVdDLiKWCX59hbXXPSk/V9sc1bVi+7NJ1yZU56wc2A3?=
 =?us-ascii?Q?gg9Ro7zC4TF7Y6eYkEPbUCbBcKmWwz5/NzvJNfQaCHym80Z/IRZtBuJYfuC5?=
 =?us-ascii?Q?xrNrmBmVRG7u1ZQ1bYEWt9pmlJ8L2FwrSrWKGjgINBG8QWH3qag/WxTMZyjQ?=
 =?us-ascii?Q?mYjaKA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 147bafe8-0630-40b2-7bd6-08db60e169b9
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:42:26.2517
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Etn4apLQLs655MVtJCHO1BpWYEhPV3srsuCRCss9M+n0BHOEo5Ouq/GwtehdNyK7EyB2zV/RI5ynTxgVBBwFJJ7avpyFQGJEbRx5P14hEX4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV8PR13MB6494
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 05:09:38PM +0300, Andy Shevchenko wrote:
> There is no gpiod_export() and gpiod_unexport() looks pretty much stray.
> The gpiod_export() and gpiod_unexport() shouldn't be used in the code,
> GPIO sysfs is deprecated. That said, simply drop the stray call.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


