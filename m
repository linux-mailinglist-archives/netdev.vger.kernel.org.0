Return-Path: <netdev+bounces-11978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F057735929
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 16:08:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 085E31C20835
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 14:08:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166CE11C93;
	Mon, 19 Jun 2023 14:08:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035D111C89
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 14:08:27 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2101.outbound.protection.outlook.com [40.107.244.101])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4919C;
	Mon, 19 Jun 2023 07:08:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=avBnym7Oze9Vee1jePaMdNZZwYL2XitOhpVomrBwyS5chTIWLHvfMZ8lptaBHN3vPVz3zci64Nhl+ZbBFxJHQW3H/7Vg+EDJxvpaWJ8XhZJyhIkg1+ChTe9IEPpMEWSdAf2WTSJJJPTHTVfJUavJ2uKUecB3dZ+aJJZ94yVqbzJgWTekYpjw94iE4qcfTiPf5KDeDLx72XHVPu2WPaRy6h1meVGbZnkiWvuNCd2B9axP60A1/yFTF/VLCUzdN65hHeg7DAZT6wjOqWwhgLGsDwAr4kfEqHeVqQJo0LG1VDJBy6aTZYFz3BMKTlQAhDC5/W5ixli9R+Ye6wtISW3Avw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSJRh2Y3uY39+OirL10MblAtdO7J27mUIYN5p28e280=;
 b=bNzK0Z+8IyoTvWfKh65Cib6T7OZNssRaMe0dY9IxiJeQvME6EPYMqKJo2ho0xWHRiMqVI26tA6vAkIni7Gie8MdPrb3kLUIITeGSIHNIx3JfJADx01RP7fe1a/DR0ltggwjd1kLS6Fv2ssBNHoTcyh3kr2HP1BdlmN94l3YkTZKxxuRe9arkVJZxqrD/VouWewZpBHcRlk08NbPKYUisl0b4vjjyr/qMdjTSRTDy65LlG/u1Np2NXrnmhoobEm0CY/z+rPKZuJmvOBgSvY7UdHjRdLh1VE3Es1PLqz8CVudAMmU8Hyhn1gg97+aaU1XgMyVxvTwzYhR3MMzgL19wqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSJRh2Y3uY39+OirL10MblAtdO7J27mUIYN5p28e280=;
 b=qNgUpeQ3iaX/cwS9QuDpmigCzEuWkwJGJe/o5xsG5VuPE7t6RCh9HGa7fN7tIl0mkpHI3uL5e+xWue6SM6WZNhUlJnB9zXOPwN0khJtsaU8jCqdrsOsOT/xrTe+aPAnlh7zem4qDAlMcQTzqZhjW+U1RgTJJSc635JVmawBucOM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3855.namprd13.prod.outlook.com (2603:10b6:208:1e9::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.36; Mon, 19 Jun
 2023 14:08:23 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 14:08:23 +0000
Date: Mon, 19 Jun 2023 16:08:16 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Paul Moore <paul@paul-moore.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Subject: Re: [PATCH net-next] netlabel: Reorder fields in 'struct
 netlbl_domaddr6_map'
Message-ID: <ZJBhUDrMxv7nT4AV@corigine.com>
References: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa109847260e51e174c823b6d1441f75be370f01.1687083361.git.christophe.jaillet@wanadoo.fr>
X-ClientProxiedBy: AM0P190CA0027.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::37) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3855:EE_
X-MS-Office365-Filtering-Correlation-Id: 29eb2bc8-cf80-4fd9-f54f-08db70cea48d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	B3dGFwrEOC29nAE83t/vKS5nFtn9nu1q1BFhhX5T1XD1u+L502HgDTh2fwE+gIpOptEfCpJtjIVhu5HEZfstjLFX0loCfDizA72/NaFj3q3swrBH9lkqRStXmV6WPKBUEOKVMWUJaBy5L1zhNekvySkEFZuVYqbh8HZT+2dAe+SMaiV174KNCatGTd+1zu55BLtJkHq6CoN5TAQTTGV9qvwPwkpeN+eYHLcdIwIe4wvbkEgxDK9avekxOspV/d5MPQRS8gmsV/F8t5DtUp+GxikNEGtQ6RODnlqiVh24U0L3e6fuTK+yzzGuHfeC+hvw9CBZsIL4TVrTjaa6jJpb5Vx1+Ivjeko66ONR7DdZYBv+QeFSrDq9sVTicOUd7C13nYDuZgkaeL0nIbw5/3e9AJzeXQ48jJNACqWqrMyou8PURVWkGqwobvxQ25S4SET+9MFq9qTEZ3tTj3rydhtNhZ6ZNBZxpeBVAuPWZma5uZJEHjsQbULflEsahMekD1CAtz560td5kssZ2gPkGZ1/4EO726HVksP51HzzZwb62HoAcX4XkhkkUSqI6Zh8PK6sHlVtKhuh2D5t4Nx/uuSROx2GJYzJbtM7trWwhAW6ot8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(39830400003)(366004)(136003)(396003)(451199021)(478600001)(4744005)(2906002)(6666004)(6486002)(54906003)(38100700002)(316002)(7416002)(5660300002)(41300700001)(66946007)(6916009)(44832011)(66476007)(66556008)(6512007)(6506007)(36756003)(86362001)(2616005)(8676002)(8936002)(186003)(4326008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?et9B7yHT/BNhushb9ubuxv39XgxTgK9SAqNIXkeSnXIJZRLHOxEqY4RLl3sA?=
 =?us-ascii?Q?7Xlhbbfc4d/Rscn75sTO5H3qfBiefE3STdFzelxQw1yNy7QsTaf4povKBKtX?=
 =?us-ascii?Q?twX3QAsvxaw7r5yOpnCjTWa7w0MkjTtW6X/vdBWjSrBS6GUFX+DbXQ8w9egY?=
 =?us-ascii?Q?wycq1fZ7Q5B365aFs2m7JMpYZplGWNtAUzoTINeJ3BMNoCe3RiDB/DNQXWeU?=
 =?us-ascii?Q?7iInvuFwo0EjJgFGAXREjCaZG/JFLrWRsZdY0ENuDBK4/B3zlx2e8XZ5hDnR?=
 =?us-ascii?Q?I3G0JTMGqVZlPeAnyIHde2c7grgoQ2bh//i5OILGq6q/tLZ2tMmSEmW/8mvH?=
 =?us-ascii?Q?nTesENcP0Wu63LMcSi1M45sW/4BkJCPy6MOJW7s2uHqZyeRtwdbuUnSi5QZC?=
 =?us-ascii?Q?CP8lnQhrxdydmsjAXaGprYq4NNqBAnIBrjejoSZzVTeuqb1a8LQKvqd2KZIL?=
 =?us-ascii?Q?AsE+Ai/gp4RztKtJUz2tFkTu33ZVuJ+2NKQrg/M2WaYCvrckAx+wQRtHjEKj?=
 =?us-ascii?Q?qGaKTOjiwQHUXoZ22Tf6ypj07d0qFv7XoLGoQJ5ZWiNNZ9IZmx1YRMxbIGjb?=
 =?us-ascii?Q?3b142bGI3A2E7gGRQFlM6deRavXna0rroYmnHTncuB+tYaxRSXa8T7iu/9WL?=
 =?us-ascii?Q?t93IM44eEueO3tt6Z7BdVPjw1tuw+xW3lp+BKopm7inNdR9LFbgUHFhFfAOG?=
 =?us-ascii?Q?HDgo9+0PHd3zVtOa1UAF4CVqM5WHOaTmn3MPwLFa88qwlmFxxNa9yoeH37Ol?=
 =?us-ascii?Q?+6cSfeTTIZkOoW6J1WDJ3KzGHIK9HPOMjKNRwns1rLVwqonlYpqpR12++omE?=
 =?us-ascii?Q?hihJNdrBHZwevrdYc2rc2fwfxkWiu0pzBIa9kUoUHUezaGT7ZWvgKmI5mJPy?=
 =?us-ascii?Q?dgoSrxMpkOqWRSdCza6XVBGJxbqbW5ufB4lNgEVmBzA8cwTX8Gb4o5o5Jmqt?=
 =?us-ascii?Q?mSTZT2xaAUK5BEvsTrt9CUPNKjFacRgI9+b53VeyWXHy2BXfjd+1oLnLZ3CH?=
 =?us-ascii?Q?RK58kkhazn+qlX+cMBq872Unk4VaGJVCg28jmfpH4Xt4XqwtazATCxjAE/kH?=
 =?us-ascii?Q?BzH4rlgT/tkYi3uoKEwn3FbL6zdY1z9hbH0tA7HExa313WjFN30G3+lcJbVS?=
 =?us-ascii?Q?mJfXkrgsScoANE1cZSwhGtNQu9YTr1u9MAFFwNNFffXcqyeF4UgfbJhv5sqD?=
 =?us-ascii?Q?q1AtE57TyrZfCH0u71+R4myUUeABc80AkMwjsJKizfUCcn9mwEKp+IJB6dJb?=
 =?us-ascii?Q?16tjq2hcMWoBSrXoiNasT1oHe20V/vjvd2i5RNG55qam0x3/2L3vWn8Yy6BK?=
 =?us-ascii?Q?dR1/aKxn2iVgwCNYzp0kgi/mFzpVNFXcv0N7CT6N6AArl2GvmJgurBcBGPfR?=
 =?us-ascii?Q?9Am0nMUWOjZG3DBUfUET3PBAkP0XKYPJawmXfyCo6od+4l83WL8+GHnPacMo?=
 =?us-ascii?Q?dRDkaU80Ssy8zhhOp66PmQLtGlYU0shWeiH/LZ7g+42YWs5ToHhsVGJqpj7/?=
 =?us-ascii?Q?FiSqYeYHzShcqyCAQrxUrOg/lfjxlMHYTdNbfvzVADju8TfKydsIVU9O0m5M?=
 =?us-ascii?Q?ghnse5A0rex0mQxCoWx1uInYYwFPtlTYSjI7FCzfhj2FC+TsGJ2hypNlgzQv?=
 =?us-ascii?Q?DQ/lfzU+x6wEqsYQVfXtUwp2S68aeahkub+Y6Kf51rUTmE0TnTfMp0zKOAF1?=
 =?us-ascii?Q?5iwXgg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29eb2bc8-cf80-4fd9-f54f-08db70cea48d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Jun 2023 14:08:23.0443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vFwX7dN7MQYQAiQutTJrBX7K6ziBS6CZP3BVNmm6XbV5CMcfELYqtz2IzemAQS2VaMWUAYezAMqugmhyK/TbWnzISEhoI2De7ZJXf/Dl2kk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3855
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, Jun 18, 2023 at 12:16:41PM +0200, Christophe JAILLET wrote:
> Group some variables based on their sizes to reduce hole and avoid padding.
> On x86_64, this shrinks the size of 'struct netlbl_domaddr6_map'
> from 72 to 64 bytes.
> 
> It saves a few bytes of memory and is more cache-line friendly.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


