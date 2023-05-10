Return-Path: <netdev+bounces-1405-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B65E6FDB11
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:52:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 53C721C20C6E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:52:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1FD5A6AB7;
	Wed, 10 May 2023 09:52:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CE5520B41
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:52:21 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2122.outbound.protection.outlook.com [40.107.95.122])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CF461A4;
	Wed, 10 May 2023 02:52:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H2Q0Jd8aapiq0jT/6m/MXuidbAEBoneuDwAQE6nppJLPtgSaD3tTXFYrI4wtRnZjmLFZ8BCEJ5/pr96enXJHDQM1KWttK2bQGkcoeK8umrZGRfMMNqg+7+ntPqrMMFpc/GShF9EXMnllB/eyyWZvq2vmx0AUrJXtyCzuMwrQ+UbGTjiYxVhBZiclLE1Ffi3kRGM1INwUH+UJCRcz9+8QOAVBSQhQE/K4C7r1atDv2OWrX56/6ptNZN00X7TIqJbCKFSPe/AxQg6LAazmA+rMFpIRXmkqSFkoYC5gyWq5ejjLZmGfPZ3T3D8ksFMULvg40+ajDMAB8Vl52YtE+smMdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pWOQTNKGDvZVFK0Vo41Rvtn+rprcaqEmBDKOfXCPKwY=;
 b=Ur2JFGcvFNelow1ngY4gT2b4undF9kitONI+6OxhLWo2ecWojSzP63LtuqzucZ/MXUuYAmvWKc42YVtOGrUFDG2ok3lSA/qhAnQurk0uPm6OIZtD116j4OOauTwMCFbT01Af7W4NOxWK7R3bbV2Rm8q9SDuVHLU21TvBywlC0XtMydoOP13s/uzDKsinkbEDLNcdfeP6JTU7cgCAZkC4mQxQEVLFzBB1V8dXrY+AVGbIX0cFZw9GtcHBEgeHpibXMup2b21uVy7eY7rBFWIj+3d1iZ6KemDvz5rMbW0X+DqtTLZZUjHXSs+CvOgcRkjAzoW1d5yMhLVmoF3InQKEjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pWOQTNKGDvZVFK0Vo41Rvtn+rprcaqEmBDKOfXCPKwY=;
 b=EqD43JS4maoDBBB2diZ9BryVB8aRIYq+ym8C8Azqxvu63MS2wAgnrgNa7JZwI/JDQuV8dvOIwbkobo5Y1SmG5ZWW3XUtxJSS6yPv7YfnWDdohc8MN5u+9RssiggbDLaCLwNf9zEdGRkVA2UYC1zaSxgVcLIR/DKtZj/U2opOwzY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB4647.namprd13.prod.outlook.com (2603:10b6:408:129::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.33; Wed, 10 May
 2023 09:52:11 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6387.020; Wed, 10 May 2023
 09:52:11 +0000
Date: Wed, 10 May 2023 11:52:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Bagas Sanjaya <bagasdotme@gmail.com>
Cc: Linux Networking <netdev@vger.kernel.org>,
	Remote Direct Memory Access Kernel Subsystem <linux-rdma@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>, Gal Pressman <gal@nvidia.com>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Maher Sanalla <msanalla@nvidia.com>,
	Moshe Shemesh <moshe@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>
Subject: Re: [PATCH net v2 3/4] Documentation: net/mlx5: Add blank line
 separator before numbered lists
Message-ID: <ZFtpRCXAB5lzxklQ@corigine.com>
References: <20230510035415.16956-1-bagasdotme@gmail.com>
 <20230510035415.16956-4-bagasdotme@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230510035415.16956-4-bagasdotme@gmail.com>
X-ClientProxiedBy: AS4P189CA0039.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dd::16) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: 1d3e3aa7-3e94-4315-1630-08db513c39eb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	JU4CPaKvnke1KcP4VS7ks0BT6gOrgmU/O1pvmaebq7Z86lHCMNh5D1cAU13hnX5h69pi9s9g6Cscl7Wsd8GqArKAVy76rDVCHKpSn8w3/kDnlgbDuTh0JWJBYagmS95C1rboTdnDLJDy1EaQ8VzNAsm2JWiiruiDffC8SBgMDNzJDhsnHgzvSYUik+imDZlH7Pqiaeb9nqGI/6B7z6X0wA5W/PBD+31/h+M7lEio4WqxsXpPQ7wb54/exnVpfJ0rmCKOL872AywS/5RPTil9DasmZnBiSBzru6/5/rqNd1BlsfDOE2DWV/pRyGzt0MtMncMw0Yg7cizOKG78mzmHIPG7dHVj11bDYCP3GEnCNGSfS/Xo9nAhMx0TKoU3uOliO/jG+ahmy+bMlY8nscMavRBh9WNzgl6xuG7SjoZVLw1e8hXmQGpv9eDhhTcafQsdnWmnGpHESybjFnxF8C522UaWbzY2MevzOryWXSdREn+URyXWQabehGt8bMp6oPMOfKPOvCOegqshhXJn03jLQJMkARL4T45V1JegchJZ2FMvvYeiwu5sPj4ULJInucHO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(346002)(39840400004)(136003)(396003)(451199021)(4744005)(7416002)(2616005)(2906002)(186003)(44832011)(478600001)(36756003)(6486002)(6666004)(316002)(6506007)(41300700001)(6512007)(38100700002)(54906003)(66946007)(66476007)(6916009)(66556008)(4326008)(5660300002)(8936002)(86362001)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?23i15Hf0PdbTP91fWFbTGydWwX0AwYgoy90HUF6szrfx7hBCIK6pw4WPIw3R?=
 =?us-ascii?Q?87L0IcbgmF2ddgwPcEhvROKRv0V/kJMHO1FZ66XJiKj3CI1wdNsgLNk5pA/L?=
 =?us-ascii?Q?sqy2B8FgfJz+4Ep04WLC768/AV/2/Bqe8QsredJz0Cl76NGyA7Wezd0ElEBe?=
 =?us-ascii?Q?UFGuUPoHVcNrkCNfz1OhFaVE28WM0zqTWEVAdUvlt2iUOykyXASmhPi6hd02?=
 =?us-ascii?Q?UmZATQVuwcEFF0035TlGg3oToVMVj4oK1aula20qEl87HxIHQiZ1oVElRPMo?=
 =?us-ascii?Q?ia2Q5SH+4OSPD6GCwwmKCvmP3QpAMzFw2xOb7aaIdOzFo7cwISeqeaIp6+fv?=
 =?us-ascii?Q?z+QEzvaNto1smGl5tpxityFX4wFQj2UouAPZn3x3ENM1SQjNjGpdMiD52C9a?=
 =?us-ascii?Q?qgAd0lQp8sp2pxe/9MlF1qBzYjc3JlE5057hjMqyCKds3Znm2TdDgwjXh8Nb?=
 =?us-ascii?Q?7SVi61slln3KtZlW0gGcGfdXcj9pIhiHzgLfQyv3WmWqa0j1a/iY2bwX2v3i?=
 =?us-ascii?Q?gpOhND88ng2G9YcyqPo6YN98uDqX+17SRelvG4uEWPW9WLnr03Sl2I2Dxkbh?=
 =?us-ascii?Q?ym5bHiNNP4szz4tyc4b3OpdhBMGZFr4qfsmVQqZJaZpjIai7onZ92TNT85JG?=
 =?us-ascii?Q?z8ohiPe3t4ch2l0rnI0zpo0HykFNeq5BAElQy9i8kTJOncKuVrVhwJSmujJd?=
 =?us-ascii?Q?6EiH9iXnUj9KSFhO3W0blkjoQEUDFn3JqojvABzHH3szDV1Z/H9eYtwlo9vI?=
 =?us-ascii?Q?RUChL/lLpmKq6PJO0LFZtu6p1FaYNBaPYxMZvcm3kUEm1IahnE4jXUj3gdhI?=
 =?us-ascii?Q?x2P45jEq2KC4Oy1ygySSY/++KmjIDDhVHj+dluyaACd4QwPSdlynT2gRfNQJ?=
 =?us-ascii?Q?qu5iMpn8LOYKQvPiiYokqoq4mqGX+54s5Svwn9/BXdz4Gm5ryIgH4iA/znhy?=
 =?us-ascii?Q?6aifwzHK21UmhLbQ+Zi9e51l/CtpK1zrnCjzIHpeepkcqwrms9xx5xBbXK9f?=
 =?us-ascii?Q?HleHr2O65d6s6zRvMZPWGR8m5LRpKqAGjJt6KE6p9ojfDHwK3RSgbXxi/WTg?=
 =?us-ascii?Q?XJ+2Pv4gXP8WpgHLwqNJ1Q6JWhoiyDcgLRdtk+pI5lE1/71bfLp/USuMsO61?=
 =?us-ascii?Q?0HnrTZKpYT6BRM3FNKH3ejFVwrAoEUeKu61UdZg50zu08e6w90DYqn4tMocj?=
 =?us-ascii?Q?aAtR90HU3sGunj7eeOKg3P/ZuOoBgc+iXgqwYdUn7xqUNKRL3tdx6fQ13Zlk?=
 =?us-ascii?Q?Ki0nAPZAEf8BmulnrMlUoWz+89VnOOLo2r+DqEqrPfeJVifz89YSm3uOEiJH?=
 =?us-ascii?Q?aidV/XLJyXdjiZNmolKV2FTDxfRIF/TnfTv2CniwhBjjfzFnQQVeCFP9UHcO?=
 =?us-ascii?Q?oyJOAe8cxdZsEIOWFKFsspN2oHSA5nMmPb8xMaGNlZa5dGlyS4/HwyU3MNRO?=
 =?us-ascii?Q?AmKiVK+4RHud72R22oHdpkK3cbN0MRy4Thp6MZr/NFUtksTRxAlwBpqXX9r1?=
 =?us-ascii?Q?YDtdFpm6p8boqRskW3SmAkc2nllZmcGi+N2RmmEBEvImdZYUcTDBLGNVyjvK?=
 =?us-ascii?Q?FPpYUQ8mog/y0jXBrgTz2n6212/KrQFyFA1Z7Sw5a9bLAbkKp2jKNmx0+hnx?=
 =?us-ascii?Q?OFOZUIPmympGWiP0VpBdzIJhywLELOm6rGef2IWpT33ePZShPySR7Sy8QL9a?=
 =?us-ascii?Q?eWTRvQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1d3e3aa7-3e94-4315-1630-08db513c39eb
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 09:52:11.6176
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: obg3W1sZFa/ZjQzWw91vni9bKpNsQ0l26dHuXtQK/gjOAhU/VL53kM7Su1H8RLDEsY2Jua9ITQk7x/VqSnodVEoIF+i3RZK20JbemeRSk58=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB4647
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 10, 2023 at 10:54:14AM +0700, Bagas Sanjaya wrote:
> The doc forgets to add separator before numbered lists, which causes the
> lists to be appended to previous paragraph inline instead.
> 
> Add the missing separator.
> 
> Fixes: f2d51e579359b7 ("net/mlx5: Separate mlx5 driver documentation into multiple pages")
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


