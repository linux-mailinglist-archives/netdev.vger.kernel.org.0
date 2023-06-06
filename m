Return-Path: <netdev+bounces-8395-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 06238723E59
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 61A1C2815B4
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:52:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B98762A6E6;
	Tue,  6 Jun 2023 09:52:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B9E294DC
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:52:11 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2102.outbound.protection.outlook.com [40.107.244.102])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC207E77;
	Tue,  6 Jun 2023 02:52:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S+5/ksfjVYFka/zA2axv1+NYLRxMWe6kOq7WjE39lMlkEkIHfsUli3H7Qj2ytTNKNRC3JoRQWmbiCwPdAy7tMqZUlUL/EKWPJ8VXfGbu8R2Y1xVwDRzfOWAZE1a3kRN9JB2rDROD/ZiA05fE22HA1U+qVGl+V3WDILBG1FmRdukfDHNKLTZhp96V3CMCBZcVVReW+qwkRxq9xok7FKkpN2HATfPSR3yJuQ1Lcvx81XM/BFPRG0rAE1epE58XOMi+57TQGk4YmgaSiAmD57yUjHuPy8z574qI2NHF1Cee+FqfQf17b/0o/luREYpGWnyU+hl+KQrGhuUpQJNSCgoKHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AEc8Gp935aVOc2UAQrYUn1ViRFIJSpPT27h+pxQHNDU=;
 b=VTkWh9jUdy6OeBcm+HpNeimsmCQb3U84HSK3bRQhlNClbdpA0uBGlgrrBbO57GwCBzj4euYgUjdx/aFInCMZfe/0ioxZ74PQ/Fxla3lnAonN6V4KNwudV4n0Lc0DeAFFE116hUFUMD3JLRq6G7gVE+/BzcDfkvZYzm4cccER0l+DMFZPow1zxHQfrpmMOc/uJ/TJWFWsXAJExHEQZi+COkD6mVcIIYnD3hazbi+X//M7taXsKSZm/0UlOKPxhVn4TIbx2C6ypCp1eL7PWbUMsJTb1VWJqhS6RCWQ+Y8cJ2IHG9hpM9hAH4dIDtAHYJOZBDSoREN/jMtUNoD1Tudeog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AEc8Gp935aVOc2UAQrYUn1ViRFIJSpPT27h+pxQHNDU=;
 b=uZB3vxtRhb3KnnQKf3s2745QC7ofQpPROnG9J30PgUJSwu8Wvcz5RnCMSnaygmJCBTbOUAF+14e9THXY+9EJU7ItRiNnR/fNXLQajnuwTXa2O+UGke7dFrD9WBUL57ASarCf/PIXIMAWhoRNR+3WmKbp4eZjNaBzUnq6F3nbbI0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MN2PR13MB3928.namprd13.prod.outlook.com (2603:10b6:208:26d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.27; Tue, 6 Jun
 2023 09:52:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:52:06 +0000
Date: Tue, 6 Jun 2023 11:51:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Shradha Gupta <shradhagupta@linux.microsoft.com>
Cc: linux-kernel@vger.kernel.org, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Michael Kelley <mikelley@microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steen Hegelund <steen.hegelund@microchip.com>,
	Praveen Kumar <kumarpraveen@linux.microsoft.com>
Subject: Re: [PATCH v6] hv_netvsc: Allocate rx indirection table size
 dynamically
Message-ID: <ZH8Bv624GxCf1PKq@corigine.com>
References: <1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com>
X-ClientProxiedBy: AS4P190CA0034.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5d1::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MN2PR13MB3928:EE_
X-MS-Office365-Filtering-Correlation-Id: f3236244-8913-4f44-0088-08db6673b03b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	VcoaWO1YWiOSFcqaghYq8aRbvNoe6emTNRzEJbhGSVCBW/z7UUNFUiLLHwmiVplD+77xkLg0yMMEIjKiT6UJqT/6APKBoqAVeXB/8uhzAR2CxUJglV93VEepnIK2KSC23lwN0Jo5LhLbJUg/0FwhHj3ccwNy3WzDlVuco1/NV7XhLb7FXA9hvoJSgdVdjIn+kcPc3U5XK0iDhOZH66gi6aCYjTaJ+edLXiftrPD0hmbqGLj380qPmhbrWNpzGX16nMh11fUCWHc9J6nccOe9fY9M3gU/xz+82YL0/NfJdi2sjvANlJgcnu0xO2INZ5hc/Nz7/iFq0pPlq2Ilkl3tHt/PfLidZdPwdZ3mPC/JyWMDAyAFys0YTVcCH63HlHXwKVmmqvS8F9Fxv9krv6yvbUdvRp1wGhZlYUpaOg5oE70US9+AAbi+KFK99/tfbFP4u6QGSHqCoR+GkWwRn0U9kYYoAO3/bYLZHBi3IOFarc/5Mb5aPwbrepMOLyzmiVih69g0wMLVI9/1ZtZU4kIPWwLzi0ThFeFQvCAcTJV7EC50MtAYgNUGZy8pkvqL7Mn2IvHnwg3GU88xCpdUX5PXAWU5NXPax62stDM2OAuLvcw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(376002)(136003)(396003)(39840400004)(346002)(451199021)(83380400001)(2616005)(36756003)(2906002)(4744005)(38100700002)(966005)(41300700001)(6486002)(6666004)(316002)(4326008)(86362001)(5660300002)(8936002)(8676002)(6916009)(54906003)(478600001)(66556008)(66946007)(66476007)(45080400002)(6512007)(6506007)(186003)(44832011)(7416002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Weqm80Q4snuSZ79NDOeVEp0BfwZJFW7Uzz726tPm7FhGaQoGQ7MGzCxdBgbL?=
 =?us-ascii?Q?3l1YlBH0v+OS1U72Wj96yxN1DlTWjyARju94eh0Mf9JRFuX4DR3pBKoM3aLe?=
 =?us-ascii?Q?ps42uaNKCjKy+Us3Atnx5N3jdUXc9YL/r9pM3aAn2BiSA+2+AhqL2iDAp5jo?=
 =?us-ascii?Q?p+2ROFMDV9ei/zrB4uvbDzkcZIFcYqPZ3rBqfBtxCEOtKnrK4LSx+pES8EpZ?=
 =?us-ascii?Q?6jKNN9ojfzJeXHJdiPaUg+mWtH24epuQXNQBD4/yEi9xpd1wtCAbk6DFnAMH?=
 =?us-ascii?Q?vq9pA3/2wByCs80P8A+Z/+lOzMSgVrUEgAVFL/1h8hcjfOUIywbRxkZfksI6?=
 =?us-ascii?Q?w85Ss4ywIlgS5CILifxvhwmUI2gbaJAqgJY3Kc6dS9LkX5Y0Skv8p2RWpFYc?=
 =?us-ascii?Q?IQHRi2wxYqqu4nUeqemsP0WUsq/xmrPnZLBy8KQvvf4s+dBdlGrpUoFvp512?=
 =?us-ascii?Q?6mGT+4C5ufWiwCozaZe9MKhwPldHig3EDScXzcC68qhmrd0K6QELcBJzLZrR?=
 =?us-ascii?Q?WExbOso/ksE+0ZcFcJzXs3JKV0vH69YAuyksYnCS5WrMY5mhdwcgQmOaj7+y?=
 =?us-ascii?Q?YCDyqVTmjkZ1RG4Zd7SxzTL1tgUrQvTwDw475XHP6AkSr8rFm4T7fKwLHqM+?=
 =?us-ascii?Q?uIocaiRya7pLjQdVakIWjQVNPyhyF8vhkt/xAt3ETPO/umL6/MSM+88MRttF?=
 =?us-ascii?Q?rDUlz+OHBpgMgg9OhXEkm8snQqUDy7td/NSdRdLmf5qJLFlDuT+qMUDYlNOp?=
 =?us-ascii?Q?1QvPUf49+d5opikqQMIu6V25NaJwrkKBjxrxjzOup3X5DNpV7NYGaCzi2cjc?=
 =?us-ascii?Q?tvV5qXXrAe39/P9+cqhcQ1pAcSLorfNAEFCrwXSC16fJQTKxukl3fPIaWHnm?=
 =?us-ascii?Q?X/5MxLYttt+AhDXl1K3lo/pN8Di00CBsAiYlgs8gXYwu6I/KMAaoHsILq0Tp?=
 =?us-ascii?Q?RhNOIaRR+61UAaV49iha0BRyX+ANhOaxzvq7EvI+xlNW0llLMiwm8Vk3rB21?=
 =?us-ascii?Q?BDQT9abDfqDTXNoTChnoMjakaXPUeg35q3+xOVYqtRadZ4CvGHd/6NAKUbGI?=
 =?us-ascii?Q?ELPC3LQQNsOXo500P5fEpAUwea5xalanzCOP8XwYRRULXkjsrsUqt7lVref8?=
 =?us-ascii?Q?xb2cMbJiXcNZlErUVoL0CAdu0Ojd92Qi2abwvaZKHEQ/ccd5MZJNJP9xnolV?=
 =?us-ascii?Q?oIaoRTX+MzufQ9I3ynJgKzUHODMOs7k3QlmWLc9Y1T3Y8rpQO/kklfu6jrCR?=
 =?us-ascii?Q?jbugqw/Gh4RtHIMvt8xboTRQX209cXG9oTE+lbPhd/Rk5Mn9WVqMrdgg18Iu?=
 =?us-ascii?Q?f9Nj+tgSw6j6rA2KC1TXv4pLCdyeufzfuZIJR37raO8eHrqIMNVtZoW13TAh?=
 =?us-ascii?Q?vQjHVVa5RWLBdGJkXI4CrDu2YMrjRWeacW8z6V/JPAfuvw7gN1A6JqiB3EBE?=
 =?us-ascii?Q?qaWmGJrgretOMWBXNCYY53b4l/rFc3W0kfHd2KwQfr8bE4bfkv5G8gbySmli?=
 =?us-ascii?Q?qEXxhlFdQqtkHdU0djc4YOomTZ8oAdxraevaA2LigL+ZjlhmKzDLnbS/NgTc?=
 =?us-ascii?Q?LzpZJUYFt73PJUIrZ/HQcSJSTYJZnyhGHH+W9IXSi0xXUjSVWyeu0eakvF4b?=
 =?us-ascii?Q?J9JZkmTvUJ8jve7hnzvTYwLLsJdtwWmL7b/Gkrj653vArgrYLYTjPMBAsrvm?=
 =?us-ascii?Q?Mg2niw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f3236244-8913-4f44-0088-08db6673b03b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:52:06.8029
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wdMEEWxTgu6G4bo/lFgrSEKI9kXUZdNX9cLAnurU8Gx/lgytt01u1fcIGrL2VyfTwowP5AC4TTbltrjeitWfOjcHFga3lDyO3Ztfh1UV6bY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR13MB3928
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

+ Praveen Kumar

On Mon, Jun 05, 2023 at 04:30:06AM -0700, Shradha Gupta wrote:
> Allocate the size of rx indirection table dynamically in netvsc
> from the value of size provided by OID_GEN_RECEIVE_SCALE_CAPABILITIES
> query instead of using a constant value of ITAB_NUM.
> 
> Signed-off-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
> Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
> Tested-on: Ubuntu22 (azure VM, SKU size: Standard_F72s_v2)
> Testcases:
> 1. ethtool -x eth0 output
> 2. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-Synthetic
> 3. LISA testcase:PERF-NETWORK-TCP-THROUGHPUT-MULTICONNECTION-NTTTCP-SRIOV

Hi Praveen, all,

it seems that there has not been any non-trivial review of this
patchset since v3. But at that point there was some feedback
from you. So I'd like to ask if you have any feedback on v6 [1].

[1] https://lore.kernel.org/all/1685964606-24690-1-git-send-email-shradhagupta@linux.microsoft.com/


