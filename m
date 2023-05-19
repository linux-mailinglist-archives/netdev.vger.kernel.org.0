Return-Path: <netdev+bounces-3861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 620667093E8
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 11:44:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1844C281A42
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 09:44:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2FE2C6139;
	Fri, 19 May 2023 09:44:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F103D6108;
	Fri, 19 May 2023 09:44:02 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20722.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::722])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3DBB2101;
	Fri, 19 May 2023 02:43:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gh+xq9RCNgNi5Ticp5RKaP5cEBUPYzfOp4UbD7XwSh86p/2XyK8HrBm+rFOxxJ+oZbJZHcYtnvrg2oroXcKwrjbXefhAfLrI6q5oJHFw4HSiNhKiLz5YoQcJVtRm4wzJnlrf1RDlL/DPV2WeF2I4A5Ag227nGkSpHXCqJNAoM2y+4ZsVhYdGHi6dCekyu7fs34j5JR5Yps/h1DHmNJj9lOhmLaLoIw1u/qJiDUaIVY/lAQhmITP3JoWd/3D6rBW95pikv4FZfg/2CR3pUydfYj8Y5K99Ly0AhwXWo/gpOfLWG4Fn+PwbuEpv8r/8jg6z39iC0B1L2Z96qnMaGEnbPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CcQt3TRLpg+7CP3QeRHxF1qaLgCj3ocbnyxikfAz0os=;
 b=UaB4EmvU9fj8DGlf5Sp9uuDCfJPRVZJ4+EM95dxYYCGWRXQ5Tt+Lx29pyNSIfUaZsUBIxkQvDXTf/8wFZ6QTnIhyfq5XT074/hpUd+UaQ1XMULYI54Fj4szauOH5ipbigZHgWFI/6sIrfrl/OJddMKEuflaoXULCuuAGiRl1HRwLf2z2r/m81VjX8Do4U5vL1wrtD3vydJNp3qv7SyypMr0WDQdpVk9wj1X9DSDGr0CyHIR4sihzKVbIL09FW0IHEOUNIBqai/JpmcGyzEq3MKwvtmjIXHQeqwBgWX8pIVESgeSSO7xdus9tBsTduRUHl0oZDBbA6d2HORs8gs88XA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CcQt3TRLpg+7CP3QeRHxF1qaLgCj3ocbnyxikfAz0os=;
 b=o8dOQhMQW5KIsmRnQ+xEGCHsFOTseq1ZrsHNW8ybUrtkqKLDxhmrsuxQxYA/AJCNozkqMDP4jOyL0c1NKGw1asgSSPDA7gjbZYVWJ2u/4/bxeaF9tVE/s7ibCWrS5qOgCK4LxsbbR+Ju5d6Bx/RIWVzbqUMDmET7HWtlvnDq9WU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB5567.namprd13.prod.outlook.com (2603:10b6:510:12a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Fri, 19 May
 2023 09:43:02 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6411.021; Fri, 19 May 2023
 09:43:01 +0000
Date: Fri, 19 May 2023 11:42:55 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
	andrii@kernel.org, netdev@vger.kernel.org,
	magnus.karlsson@intel.com, tirthendu.sarkar@intel.com,
	bjorn@kernel.org
Subject: Re: [PATCH bpf-next 05/21] xsk: add support for AF_XDP multi-buffer
 on Rx path
Message-ID: <ZGdEn1BLbdcLx/FU@corigine.com>
References: <20230518180545.159100-1-maciej.fijalkowski@intel.com>
 <20230518180545.159100-6-maciej.fijalkowski@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230518180545.159100-6-maciej.fijalkowski@intel.com>
X-ClientProxiedBy: AM0PR04CA0031.eurprd04.prod.outlook.com
 (2603:10a6:208:122::44) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH0PR13MB5567:EE_
X-MS-Office365-Filtering-Correlation-Id: dc44f323-4aef-48bf-0cee-08db584d6fb6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	OngVhmV06vFVnkPFHhhKTkbNniEWtjGFR+Nis7dvP2GEI5cGu2FalxEZOaAbA+KrLf/zDwd8duLSuV+U6b9YMVeBkTmI4QnuZPbcyl8K5y4kyRCCxgBOYFsCLqDC+9xVdQPtwhzsLWM5e/Lr+zGwlSd43JbjKqwmlv1ep0LjO1nAI8UV3heLAZxhjlPJHdKwVwgMP10pn8kaoS+9YkNCEAs8tZnApeKfwiJfE3TWW7jofjkRHAytkoMOzwrbuxglIr0jSYPe5g7zdOZTIYo2ppGyNagUSnQJPMN1TzU02G8nXqOGAz4p98nsZ8ifVj3FVJqvJKqeNHI2GrTjO8RMIl8GskuoRoYkKZEqoy8jdTaxTwNHI6goc2AOFSBTWuia3c9l2k2o5lnD0pOLDkOy0uSivs0jQp6r342jVN6asDkylnYUN0OltTcOMpBtbm3Re160ehHnlRqWw2QbsX3aXkjLm5mmUDBqmuk8OWwrYY87O9fvIuSk8YCVrk3OJq6+xa+a6ErI4rn74s92MPUuMqaKh0yn7g2FEOf3wLTEkk5bnz95Go8nitJNjTO0PHXR
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(376002)(39840400004)(366004)(451199021)(86362001)(8676002)(8936002)(5660300002)(44832011)(66946007)(6916009)(66556008)(4744005)(2906002)(66476007)(38100700002)(478600001)(41300700001)(83380400001)(6486002)(2616005)(4326008)(316002)(186003)(6512007)(6666004)(6506007)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?hJ0DSmbr+bujNFY+mgL55R6t1ctPzwybPB8vgIB77Zc43bn5xVmHz1WHsngT?=
 =?us-ascii?Q?krMTXsghqG0Iy4Tz+QdLFODuBJNbKhoFljZ3Uuls7igVZDll0uV6KYvF3rD5?=
 =?us-ascii?Q?edHXZCyTTCIBGjT+TCvgN90n43DuuivFIBySEQW2NBKD09QNC/9mhveuGNOl?=
 =?us-ascii?Q?vRUYkLu6I1c4YDtyXpuQ8zQLE3TRFDFCmuWBkBjuwkVN9ybt+rzta7/bt867?=
 =?us-ascii?Q?S8/oArcACpPQQQctdiIrTROSkABYKEwFRE+s9ybNvIRwvtTrrPgPkDxtrTDv?=
 =?us-ascii?Q?KJlWq0WtddjXVxQ38sKkafE0cPqwpQS57TmAh6VyqDI6HqT4OzeS1zJ3mXmE?=
 =?us-ascii?Q?33Jl1QIJ4ABMtraNFPv8tpk0Yyecu0yQFKrOAtE+FxcjUGekEEggGWGbHSMr?=
 =?us-ascii?Q?C5YCG2b21cqNXAv/1/hEmWEdkM9D2gFfrTDhWy1822o1NsFUdtLHuJaVq6nU?=
 =?us-ascii?Q?uZm96pMAMk4eQaF3I79NmD0yJp/5OqUFp1bMbX8Ku3hkqs+BeVcJEArO9dKN?=
 =?us-ascii?Q?d9H8JmZNNahS9x8eMyY1GCN+i2pd18Iucq7tnNad9p3xGn4uracsLq8v34HP?=
 =?us-ascii?Q?xTcCtaczotCH7/Hiw2YxDvEepMJ0FAiNZ/JMIkqTcYeePGtIoLxKe/yEApP9?=
 =?us-ascii?Q?0oUUWYh+729cuMv9ck+bAXW++dvGMGqeUCR6VKKVaqUMeAN7AsMaMTyytfOT?=
 =?us-ascii?Q?Pl9j9VybEKCyyISLpzlAD4xHOLeKRw+hi+M6Cx9bgP29JWNHuP1ok3hQiRoS?=
 =?us-ascii?Q?bvEcboXXB/bNRJFg/skH6z2rLlKdTXpVk3ByGRqtOgdGho3wKcfxMliGP4pt?=
 =?us-ascii?Q?oRXmi6VBsEqYD4dHdDjZyYIfwWMh4IgVVEYmr0ViWnexi2hEEHhb/dTEDfoX?=
 =?us-ascii?Q?V86jCHNn43cSzYGkuTp/AqSy9W1KZxbTt9y+UuW8A2bmgo6u8C4c5RSuXzyW?=
 =?us-ascii?Q?1aMBJS60oyJohekAyPp5PK1Py6G682A1bjosE1/eFKz329LwY0I3ld2p2tQb?=
 =?us-ascii?Q?M0S+ZQEP8ypB9tGITd0oOWx7G8vczcivPDX1tRVUb6M5dKe+0Awyve2hPKWx?=
 =?us-ascii?Q?wcon+bUMFIIn0udxExQsMhICjq4+WXLWI/UCErhu6rGd2oI1fj/thrkSs4Lk?=
 =?us-ascii?Q?NbxpLLt6KA/yWzdJ3l31dBnZpTkyguZWDBc/Q9hwMroohMw7q47gN7JAcQ78?=
 =?us-ascii?Q?BcSilqDkXL5K33CYUjmNnYFxJbzsJsEZI7W+2Unk/0vP+j5H/EAo6p6f79E4?=
 =?us-ascii?Q?efRUHw7zg7E1rXwoY/MrbKq0u3ajbeedIyT3Xozj5B9nI7b8SGGDBjXtWeFl?=
 =?us-ascii?Q?M95GqoqV6K+2W7J6SLv0BS9MYdBXssCrW+/s6z7fNKtzbtWr3op7uJs3o7TX?=
 =?us-ascii?Q?bO8oMoqmAkuNRcVS1272dOhWsfO46hFGkOS/UOt45bstYv1j6KBy7KPpNxRz?=
 =?us-ascii?Q?u9N593+6zQBs1385NDH5AUAP2T6AqtetkcSwJgiiNJg3Qn/1ktJaNVb0+eNH?=
 =?us-ascii?Q?V501vjHfyXHlE7IIAHGK8tbcmS5zj+DVqF37Wsv9uJ88DyukduToX+Ceo2kn?=
 =?us-ascii?Q?Jy9x5fJbpxbAE2XXrLSJxJjq2qwUL3oU/nLMhuAyqTE4KNOgrVMNN7jba92P?=
 =?us-ascii?Q?ffXlgH8nj4qnvAH3htkkFlR3ven09LA1NxjYrEP3YInHEuOvGLClaeNO6pJx?=
 =?us-ascii?Q?MH4d+Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc44f323-4aef-48bf-0cee-08db584d6fb6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2023 09:43:01.4633
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 44PwarhFTjRIdnt87Tt4XrTZBz76biOiNfxMyuqW1WxUR5x8J4vw6tKZHdeyVel7X/lPBXO5EBm2NTth1KlRJcmlCr26NIfalbbnqQ5NGm4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB5567
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 18, 2023 at 08:05:29PM +0200, Maciej Fijalkowski wrote:
> From: Tirthendu Sarkar <tirthendu.sarkar@intel.com>
> 
> Add multi-buffer support for AF_XDP by extending the XDP multi-buffer
> support to be reflected in user-space when a packet is redirected to
> an AF_XDP socket.
> 
> In the XDP implementation, the NIC driver builds the xdp_buff from the
> first frag of the packet and adds any subsequent frags in the skb_shinfo
> area of the xdp_buff. In AF_XDP core, XDP buffers are allocated from
> xdp_sock's pool and data is copied from the driver's xdp_buff and frags.
> 
> Once an allocated XDP buffer is full and there is still data to be
> copied, the 'XDP_PKT_CONTD' flag in'options' field of the corresponding
> xdp ring decriptor is set and passed to the application. When application

nit: checkpatch.pl --codespell says:

:291: WARNING: 'decriptor' may be misspelled - perhaps 'descriptor'?
xdp ring decriptor is set and passed to the application. When application
         ^^^^^^^^^

...

