Return-Path: <netdev+bounces-8361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 26D10723CDA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:17:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D7EA1C20DB2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:17:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D28332910A;
	Tue,  6 Jun 2023 09:16:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72D3290EA
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:16:47 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2085.outbound.protection.outlook.com [40.107.21.85])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AF0B10D9;
	Tue,  6 Jun 2023 02:16:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LyMMZwoeoBJWv9NFvlR8QtV4VK6kc1QA4ommnRWG70GJhGRYo9/vfwRMB6CBvoL38XImz5ic2JgNQS9z9Lk+48FOTFnPWuq2+IPpqOO3heYe6rVyyujHw8QlsS4nUPcHTzgWXFzcVGa6St5XTpBMrvqgK/eDqtwXBj7IkNiTp8lMw+DneyIzxpQaposx/uywzgp4YcM+FDB86gdZgQS/xw924tCFsejt0ZWZBiCPX+VZZxeeuEIt5D9lHa/JZvSEfw1mSFNdamdNidJKX+EBu1oXOw02+R8/J29tJeTf0cxLHpcMNbGFJGGT9wszWxaOSVH+avNEzm4tCYgHTlfZuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cZ2SdVcyCB6HJLPcgVXm1rPYGrnBQzLG2k71kHZf7u8=;
 b=T3s1kDRREk64jYr0q1kIbIVsi8KbsB8HUh05S5for0nLEHZlu6AO+sYZOYRnGP8FtY/EGBThRNfbZlVb5aYz0CgOZaPQ5AUtTM5lD3SsG3RW/WY4Zo34mCUmEJ+osAM2yKYRpJqVYQRl3vLFHLRAe5Pu9+4PtmBfHAoAcil+1egoRGBLh0gzqfUTcyEUqKVvenW5CTZakftIrPbFk8agAdIh7+66Kxv1L2uLb6FNo8fBv8tWou3nGtXD7Npt70M70MX8oLXsBSFHoAP/HjMoVQW2UOYLDW/dC4Hy8ymoXK319wf1elgatYYdHcd3BV5RTvuTR6DMICCz+IezdPRqLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cZ2SdVcyCB6HJLPcgVXm1rPYGrnBQzLG2k71kHZf7u8=;
 b=ejygKjIEFKIWfGE+4FBh0GpjKC0p95AjsLsd44YHmEjziBCGDgEYouEiyQpHPOn/GiyRu1t6joam4bRWN8BCUz4YXTtQdOb0HdK71RbXWdd/HiB/yyOseFPL/nmpyhFbSo7QAI2uJ7YK1fvGehTfhenCijWSgP34Q8OfWD2dUQA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com (2603:10a6:10:103::19)
 by DB9PR04MB8409.eurprd04.prod.outlook.com (2603:10a6:10:244::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:16:35 +0000
Received: from DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40]) by DB8PR04MB6459.eurprd04.prod.outlook.com
 ([fe80::5ca3:2022:337:7c40%7]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:16:35 +0000
Date: Tue, 6 Jun 2023 12:16:31 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: wei.fang@nxp.com
Cc: claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: enetc: correct the indexes of highest and 2nd
 highest TCs
Message-ID: <20230606091631.xqof3ponylrpnoo4@skbuf>
References: <20230606084618.1126471-1-wei.fang@nxp.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606084618.1126471-1-wei.fang@nxp.com>
X-ClientProxiedBy: FR0P281CA0189.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:ab::20) To DB8PR04MB6459.eurprd04.prod.outlook.com
 (2603:10a6:10:103::19)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB8PR04MB6459:EE_|DB9PR04MB8409:EE_
X-MS-Office365-Filtering-Correlation-Id: d3c491ad-926d-4cb6-ab1c-08db666eb9cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	h63sBn7VS4MLmfrl4DdJWg9lB7WI/KQ2dSZqt70g3/Pls/P4gsy/khcMHqz/F6+55jPS4qtFkBZ3CaGhKJkI/NkjVimPfLY3tKkOruT+5r+M2EJlWwPZKKJJYwgHMGhpTAuxSCaE3/pmQHbNmJA8mzFt7V5qLi35OxTMrhzSssPdCt/a/G2PQ9371cOk9XotgySlmncmfnJl34PJ6m1AJfwGDSVe18ocDa3k2WUPzbLhHGfwSEMj7ahgTdQx/R8ydo29ngKkSuvue1JyMf4c50IcnP9PX586igtLS50s3OsHdWkaAOoZg62JEgN6bnGM2oSPh63vce1s+dEf8LaeEYo/+6gHbulgKuAjZhz2zzp9BBbN/H0Kh4+sI4+kJtBQGNKeQnBQHWpALqbtV56Wv7O6bBUu4SGlN7CpN7OOZE12blMPjsv+OlwXFioP7JvWLuMyqR5ZXB3lq1N/8lmeRl2cHkpu0NH0AHwNRv3JI86jDMGCwnF7YBkH99c6V3F2zAmxGGLxnbUyPVeR5VBREQJJYy0kSEPGBwssjbX2qnM0wLlAiDiCWvoDx3VRP7ZO
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6459.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(7916004)(346002)(136003)(39860400002)(396003)(366004)(376002)(451199021)(33716001)(6506007)(9686003)(1076003)(186003)(26005)(6512007)(83380400001)(6486002)(6666004)(2906002)(8676002)(8936002)(34206002)(44832011)(478600001)(5660300002)(86362001)(6636002)(38100700002)(4326008)(66476007)(41300700001)(316002)(66556008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Z+FZyWjaDjmjwxXxhRSaSqHUuA4CFIgxyjDhmMDFHm9lOQoIii0wAGC5hKc+?=
 =?us-ascii?Q?/wNjw47ebpOmT9SHhMM0Cv1jW3dCu0l7wmlghWF9SALHZ34iz6Pg2gBMrluo?=
 =?us-ascii?Q?1MkkhmKUEd93f/qdGTlRk+Lu0brilPpgBEDNwDFi8ZbZYLC/HSkrCNTZiC2K?=
 =?us-ascii?Q?4l/0R56n7+Qtlj04QYJYOc4OQJegeP8z8s8WPivuAo6tWzjz0MtU4Rn2D1/j?=
 =?us-ascii?Q?B7K7mA4X99CYmwHJRaFy0GfkJeg8Cow06QKqOA0ikKrK5aGqz3md4wQjaktu?=
 =?us-ascii?Q?LEVPX7tOnbWbAomVOgk+xtOT7RkFPLchjghQc7BF4Na1JvlHX/S+YI4SskhX?=
 =?us-ascii?Q?CrMyJ3dTxmzRS5EW+ASUmM8F25HDE4Gma6o1jPkeUIVnn3AJod8ZF3ZdFT9v?=
 =?us-ascii?Q?6gCA2jO1FnTIjC9Wz/6uaCXjthwHNWjMxZilpf4nIaLAPSf1v7WL8xn3cZ6b?=
 =?us-ascii?Q?uAFK3mhVznFZjOuE3UfJql9oWx8TPX+SabaJlj9jQCW0p12EYtdQPVKXEQZy?=
 =?us-ascii?Q?IFrpVqhv0r3YkuWqp3Q9q96dhCwjbfHmq7vavbagY5SWhPo6aziZ0HVWXU2d?=
 =?us-ascii?Q?Z4A8NKVOXowpJti6tKwL33IvXOW+oohisVNAKhWzb7OUzdTN31PUfjL87UZ2?=
 =?us-ascii?Q?4jt5rEdFT6PXUR97pu+LUPvguw2LuXsmz5wk4pY7erFR6H4dUkGICmXylmH6?=
 =?us-ascii?Q?2fFtE6lPjq+oWqB5agVhJSQNOfD0dPOcbgnh3Ws1xgJP28nESq10ZT6WAOI3?=
 =?us-ascii?Q?fLTAzyj41IJHd0MkOQCMcuC7f/WyNbN3LPbWpUINPz+7cVsG45aisqvw+p8q?=
 =?us-ascii?Q?pbsEaXXHKC1Vdk/BwE7CcHBFpnCO5poudzFLD7aN9915fXrqudRKm97PErQa?=
 =?us-ascii?Q?4f4rx3d8WBM1siYB2cN+lJecvlkkpT+uoYLn6fTO08NzUfK7ZH4nJiL3EW4/?=
 =?us-ascii?Q?T1R9T2aocKfrxXIll6DarAPjvC52sjMLbOdcgGl+xyMYmVDXaBEJAOThxQbZ?=
 =?us-ascii?Q?B9lrexyETG76qFXTrgkITce4PKqK+SNEMfpkS9P5FY0xOFkqhATmmzR6gwmI?=
 =?us-ascii?Q?joYJzbT+xOpxcLuqPG4yb51TLyE834jvGyrjDCQYSkQLApaqmflzUmtUnLXS?=
 =?us-ascii?Q?tK529woNKGvVuJpQCiaS6wJMxlu6SIpun2UpeBsP+xemlelWoZVZHWgYAdpH?=
 =?us-ascii?Q?h+gaBIHhFuSY3mPsmjdsosHpBh2Bpyf+Knl3/FK2lhWk99KFosnRcGwg41nM?=
 =?us-ascii?Q?jrPQgNmpmaBWsBLVsGuMSm8DtoTtOdgKF01TEC3ksJZDO6tOmsRKFBPi31Q3?=
 =?us-ascii?Q?5eDYGVIeznhMLct1FkiHEaCnp4dHVfSsPktBQQowE5zVZJw2UHFemWCNUXq6?=
 =?us-ascii?Q?ml6f8K84kJP9GmLoNcSurjDF41Q/BuPmMM/WQaPVl5PiWjY114HpvLCPfQAy?=
 =?us-ascii?Q?WGuK+VT7kWzBIX+1NPdWwPbzJSJ8COrMzoMSL+SIsjwrGogk15LMX0lKLO5B?=
 =?us-ascii?Q?ZAMO7SZGDA+/0OpaU9dRwj779WYQRKPHoiz/l7Ejk+sp0bdTrwpKAYZdpXke?=
 =?us-ascii?Q?mu0Q6DzsOvziY7v+0friRyIRxSkx2qMKQSS+Iq6uUGtREjGGDPlRGLt2q1KH?=
 =?us-ascii?Q?xA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3c491ad-926d-4cb6-ab1c-08db666eb9cd
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6459.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:16:35.4329
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 1t35pPMZgugoIVGDE/i6HaZpKTEoMQAvByOMBTRvFdQe4KnJXB+2+PhGC6mwo+PFtUDFsnpcwAYdq3LMDMEI1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB8409
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 04:46:18PM +0800, wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> For ENETC hardware, the TCs are numbered from 0 to N-1, where N
> is the number of TCs. Numerically higher TC has higher priority.
> It's obvious that the highest priority TC index should be N-1 and
> the 2nd highest priority TC index should be N-2.
> However, the previous logic uses netdev_get_prio_tc_map() to get
> the indexes of highest priority and 2nd highest priority TCs, it
> does not make sense and is incorrect. It may get wrong indexes of
> the two TCs and make the CBS unconfigurable. e.g.

Well, you need to consider that prior to commit 1a353111b6d4 ("net:
enetc: act upon the requested mqprio queue configuration"), the driver
would always set up an identity mapping between priorities, traffic
classes, rings and netdev queues.

So, yes, giving a "tc" argument to netdev_get_prio_tc_map() is
semantically incorrect, but it only started being a problem when the
identity mapping started being configurable.

> $ tc qdisc add dev eno0 parent root handle 100: mqprio num_tc 6 \
> 	map 0 0 1 1 2 3 4 5 queues 1@0 1@1 1@2 1@3 2@4 2@6 hw 1
> $ tc qdisc replace dev eno0 parent 100:6 cbs idleslope 100000 \
> 	sendslope -900000 hicredit 12 locredit -113 offload 1
> $ Error: Specified device failed to setup cbs hardware offload.
>   ^^^^^

ok.

> 
> Fixes: c431047c4efe ("enetc: add support Credit Based Shaper(CBS) for hardware offload")

In principle, there shouldn't be an issue with backporting the fix that
far (v5.5), even if it is unnecessary beyond commit 1a353111b6d4 (v6.3).
If you want to respin the patch to clarify the situation, fine. If not,
also fine.

> Signed-off-by: Wei Fang <wei.fang@nxp.com>
> ---

Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>

