Return-Path: <netdev+bounces-9473-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 71505729586
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:38:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2CD1C281886
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:38:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A805313AC1;
	Fri,  9 Jun 2023 09:38:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9577C125D7
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:38:18 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on20731.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe5a::731])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FB072A2
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:37:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LTnKLeQjtGitjI8mEzAqq3JNPt268s5b9m7ltfrjjuNEBjQlm8ObX5orwBT1+I0YxlLKkAj05mUvi9YekmvKiSwKyciGPGac56XzF2KVJDzB4hC/yTkZ1DyddixsJYzVAPjOi6neioQnVTOY8Lu6gWNcmB8swHqRDPE9UrOJVNCAw2GFKpkhJXTpY7VtN26gDVsg6lDdBy9ODpPPBcsa6eEbKe+7gy0EDjGyDfRpom8xr4H3AN2VxO3eIVCgJ9HYNzzmNxHA7Vae2GT1GEA6aQhW9h1KyUwqm34DVzZLwfLK1Hlz/mcEbeBfgJsqWeBvPJ21BkyqvcMjaQsQI4+pXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kqcDlagX7yjmpMfwjZO655T94K4l394nOORugVM/ryE=;
 b=LQvX7A0efGwDA95Un3xLtsjbxqk1ZqL9qwXsHfyOuX1+F+QVWTFQudCiYRj+ih69ruBkBnzv876k1L/GEW5YYyq6nL/XKI3hm51iZnXRf3iJvcOMP368BqSjJHbARo/niWSnUr1RJsXSSlK53dxiGBaIVJmu+rsx0m+ft60xotL4DBlhGRWe9GK/Eh7Vr6MavXMk10N9QfiLfRJ5oAKVh5eCbS7rpjRlQfuQLUDNSz5GJkORC2B8hAMQR/PE8WKaaWjp6DCCsVgpA9MGtGNtxBNmmQIX2sxCMtcbvnlae57WKuUWfjFCz7U6aaBhwn2Sn3zXO992o+qCQBXqxgH3xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kqcDlagX7yjmpMfwjZO655T94K4l394nOORugVM/ryE=;
 b=GLtNyOKBWcRNP046YQPlDNOYzycck13xRhV4HWFgKU0U/2sDzCa53pjjCD4/KhXsM4+BAftFTXSH/b799IRkSLlkhgiQRHJOYkYltnrN6PlI36v8see5MbOmc49EG4kEMBE9jEYaBwQMxoRXDxRvqZRWUm8Hu4wBgAJ+W25baoc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ0PR13MB5569.namprd13.prod.outlook.com (2603:10b6:a03:424::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Fri, 9 Jun
 2023 09:37:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:37:26 +0000
Date: Fri, 9 Jun 2023 11:37:20 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
Subject: Re: [PATCH v2 net-next 1/6] sfc: add fallback action-set-lists for
 TC offload
Message-ID: <ZILy0ObbkpbpgpfB@corigine.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <096d731b63e7edbec1a64283387ec5da378664c9.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <096d731b63e7edbec1a64283387ec5da378664c9.1686240142.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AM3PR07CA0145.eurprd07.prod.outlook.com
 (2603:10a6:207:8::31) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ0PR13MB5569:EE_
X-MS-Office365-Filtering-Correlation-Id: 814c5fa8-d4fa-4cab-5212-08db68cd2273
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	8xtkl3KnSJK4oRzxC5LmJwfGCn2I4OWjKbmmurWI2W+mupWVdCvuAqqn0CPfH2l92vwRyi+jcyNmLLbdtIDpNRnDYn5nrXWKDcDb6CyrMeKUVrMbbAtXBv9k78yBaM77H/pf0eSopf/2Px8tqLD8c5koNusO0PWN497MZQF4QAuqvVTDn9jmv01VcHqp2DbLDh4DFQiHmAYZkv6XbMDh3EAOltZk46p1pL1/eLtI8u/h255vxJ5nObyAELm+aD8+tB61UAqiUGldhQBa38FMlWaJ4P2KpxBwyiwsFrwXW0biWTicTNvnkiI5A6aKxncxUc7nnrHRZQPvmuX+8YnfG8MrPPSPShFtQRR8+9n2MI9jKqVSU8IwSY5GC88kdgpQb5Q+7n7gEvNor4ZNaYTVs/e/dX5IVvTd2F9k0vjqkHaySVRO8CeNRYbgsWU+BW572UwrVId7fgiP960/re7FBVfoyX5TbX9bz51AdkWjXayJ8n6kJF7eLwtOywKbJZRjRPvOcaBHiLpuE2JMdklCSmu53Iq6yxdMSF5AzQRdG/4A+aMFbagQKsEgfM9IUP3S
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(366004)(376002)(396003)(39840400004)(136003)(451199021)(6506007)(6512007)(186003)(2616005)(7416002)(83380400001)(6666004)(6486002)(2906002)(44832011)(8676002)(54906003)(8936002)(478600001)(41300700001)(36756003)(86362001)(4326008)(5660300002)(38100700002)(6916009)(66556008)(316002)(66476007)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?JX4K2iWni2x0YFLLh5zmWLET3PzmoQrVXwsR1X/57kWDNHtECdflxqliBz8S?=
 =?us-ascii?Q?vnhWXQjBtypLn7n+5cjoz6PgNRQxIabntIjyM6pmyVxJdlVhJVMnQbh74URZ?=
 =?us-ascii?Q?OOhBnpWMVPVqyexlvk+AKxsFO4x4jjo/1Vedge4ugxuEPdI/nVGi5mVDpHSS?=
 =?us-ascii?Q?LDWbxV/1zsn+DqW1zNr5RAjWIo1oHBmObb7jZTpCDucKoNjy1rUQeTtON0ES?=
 =?us-ascii?Q?51UvMfh1ek3N60pFFhZ13Z6m7kTnS/2gnNR9wz+xeA9CNLWNPWtBOgltT11Y?=
 =?us-ascii?Q?JYfduUe3QmVz30ydhwSwomzpJ9U+7ZXjn3AjmQp/r8zcj8EXwATkcmu72w9D?=
 =?us-ascii?Q?iP32C3VgRoWkVfyi0FTGVcPI1YRd8z03kf2RUAKpzNp5ANITywF/GD1ObquG?=
 =?us-ascii?Q?Yx3DS+MDxjYhACePQdb2vmFP5shmJe0ZIEq9DwA97eGutmKEYUDLNlE6r0rA?=
 =?us-ascii?Q?lSuEjsqU6DgtxvvAKFXlqUpDLz0n72T5b6ePxyfr1vefH6+Qt8LBxhk8SSAU?=
 =?us-ascii?Q?qFv/8pvUsEtDPCtzsz8ts5FcGvR11RZ1E1GS59927bgCluIjt40cpF3A3RE7?=
 =?us-ascii?Q?mpnnmS6dwezyK6U96M0f352a4+Ff6lr1sZQEni9oZPrSDgzpjGJMhMdOBQKL?=
 =?us-ascii?Q?A294+PWAwwKJO1esMqTQFpNuofYpuGG19evVegGn1G3a0pIQ05p3ooi9yY+s?=
 =?us-ascii?Q?FanPjcDaLhgijYG0XAvIkQauVlblim6GPdtQxxuKsOl7YeFIblLPabob7Xb/?=
 =?us-ascii?Q?3TDIblKdP8uy77GoiG14oIhmIutX8bW44QHGi7Dtaszah4utd/15sa07sKbu?=
 =?us-ascii?Q?O4Yk/71McCSNq1zdi1lAsgpWdVnYbUHTajhNBuVVVf0gQaw5nVjremcN7KNr?=
 =?us-ascii?Q?F6pyW1YOLsnl9BYNmPnoDkIACqBy2AGsT/fdXWBzzW+02GWqxm88f00IfiwK?=
 =?us-ascii?Q?CIf+yEDglibViza5DrWhfQh4G/9PtWuz25WuHZxqdycuQfRk+gw3Tp9l607I?=
 =?us-ascii?Q?IgF5sEdvk1oawj8DgNvTWOOvJcX8XVdlzKMnDKiEDMEqPZFR7ULemfvFWDks?=
 =?us-ascii?Q?1jbuXY+3x/68aOmkQykOKz+gt3lrqW5/UyHDYUQ2IRvTCOf5GLLUd9PkQu9h?=
 =?us-ascii?Q?+xhvtPYAJ3DXaR0qwuCmelPzwRsXG9babcNjovAeHdi95XpwUKPmXyvW2nug?=
 =?us-ascii?Q?HMVWCVWxCCNduYD20qOR29kIh8N22uc2F0pwPgOvsVNWHPzzfRjIndjg1FDe?=
 =?us-ascii?Q?8DvsEQbTOqzLARb3IIM0W401OeQ6JvuTq/cn4fAMrGzfY+ZcMKDnufw8J0bn?=
 =?us-ascii?Q?xlrC1luTQ5YuLka8kNcT6v+XqByXWGy8Ef3ZoAMsL94NvfRbt+M+7AHmN/8e?=
 =?us-ascii?Q?YfpUahORrCfsJ9EfNa3lqBMvADvusSimLEMal71IUQ1fuC8H1T9F7rO5ktl7?=
 =?us-ascii?Q?IQYw8sOdxaGB9tFgTdJbW6LR9mqEJPmaGUVoVkO9D3eDUwDb83yM4MdHQWeh?=
 =?us-ascii?Q?zSd1fkmjrV1jch7GoqCS7xKNvjN5ql29bvAghaX/pJ6X5qlCqUdfFRluXVFf?=
 =?us-ascii?Q?q/OYGQCEt/8eAKojKBUnwbmptS/ZUcLiN+XrnCVUhdDXYYqoqyWHzs69TBp3?=
 =?us-ascii?Q?MaVzZXhfUL66kfPzHCxyxCPzJwNAukBF8vgcmNOiFeEzuJ0UU69tMv8jcU+D?=
 =?us-ascii?Q?FIsA4w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 814c5fa8-d4fa-4cab-5212-08db68cd2273
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:37:25.9631
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OKD2MQcK7W+wedDehS0YdeHzjbZ3dTBSarO6+bN7ZVt3y7mSmaOIb3aspfASTDM37t9okSutv8VH1DkeBOno//xLw9eM1ryibtrxpwNDw5Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR13MB5569
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:42:30PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> When offloading a TC encap action, the action information for the
>  hardware might not be "ready": if there's currently no neighbour entry
>  available for the destination address, we can't construct the Ethernet
>  header to prepend to the packet.  In this case, we still offload the
>  flow rule, but with its action-set-list ID pointing at a "fallback"
>  action which simply delivers the packet to its default destination (as
>  though no flow rule had matched), thus allowing software TC to handle
>  it.  Later, when we receive a neighbouring update that allows us to
>  construct the encap header, the rule will become "ready" and we will
>  update its action-set-list ID in hardware to point at the actual
>  offloaded actions.
> This patch sets up these fallback ASLs, but does not yet use them.
> 
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


