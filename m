Return-Path: <netdev+bounces-7799-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9370F7218D1
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 19:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37C3B281127
	for <lists+netdev@lfdr.de>; Sun,  4 Jun 2023 17:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7941C101FB;
	Sun,  4 Jun 2023 17:30:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A1E623A5
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 17:30:47 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2137.outbound.protection.outlook.com [40.107.237.137])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E828D3
	for <netdev@vger.kernel.org>; Sun,  4 Jun 2023 10:30:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkTAgpFN6tww2/o6xmubtQ4cypwoFWuzqyL8JpUJw1q94lqPX5satlKx+whjifOYZN5R/+wA/wJZDQ54yU6lJHWarm8KM9lNv47J4vaC0AILmHUelYchApnRWO+PvF7JRy9LOWKiAlLkIVBZgstLFNaPF8S+2/sTD8Enygq7z3M4vkouDCEQ7haqG6ajHLizH9CA5wj1IZVvuheIVCC1YdzxtESnQ1wE8P8N7Jf3UQWYWPl7TfkhDQpl0GHAfNf/cYEifLxsy9qh61m6IYDeecFpTmqCVLDulD9cXy1ZznPGXMH96XAu4UIK/tb19nu/e7l9D7n44T6VJGvKS3UuuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/nwRwdwqWC5lN5cnX3FwLfa7NGRXjTGDcdpjsrptSJ8=;
 b=dnvWWjv8ue6vGUA/yGUixS9UuZnj3IVEQJNz8L8+jOOiplwcIOxQn3llEsdWgIuBiYyl9t99/G4EpXRMh1OCi3BzBtu7BKTza86dkp5oNFcCPTIXjQd3Bwbu14ekCe3IhhB3SOychR51sTp6rtDBzoCG/2/bJFc/Rdm/6taWkoB+4dBb9IKcInW5q/7ofCWhdN3Us7+TpfpJ1hfgvtB4kX8OzuEEtSD58+MAg4w99+a8XhdiQzqnSwxjfaK22jLmNgWfAzcBUvkZPDfheTv+5+/PP9P+Aya0yHMsT8w+CT4715zXcIUMj6vb5dFXKT6SUZtkDBv/hU9kHatjN9Et5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/nwRwdwqWC5lN5cnX3FwLfa7NGRXjTGDcdpjsrptSJ8=;
 b=CosaB8oEyzg+nyF4AVg3qnoPgRu3VFWKuB9xzWPSGR5tXZ6+jCXYCCwGoq/pyaivnTsyNmhj6AHg3JsjbCxdHRBLnyk/C9VBAngqjx4gmh15WROOViLla7Zj0qDuCU+EGAYB3Z5zinkUz5LVqgpx4XLtQk8Cufuq072FG+PfAbs=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH2PR13MB3895.namprd13.prod.outlook.com (2603:10b6:610:94::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Sun, 4 Jun
 2023 17:30:41 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.030; Sun, 4 Jun 2023
 17:30:41 +0000
Date: Sun, 4 Jun 2023 19:30:34 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Wojciech Drewek <wojciech.drewek@intel.com>
Cc: intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
	alexandr.lobakin@intel.com, david.m.ertman@intel.com,
	michal.swiatkowski@linux.intel.com, marcin.szycik@linux.intel.com,
	pawel.chmielewski@intel.com, sridhar.samudrala@intel.com,
	pmenzel@molgen.mpg.de, dan.carpenter@linaro.org
Subject: Re: [PATCH iwl-next v4 11/13] ice: implement bridge port vlan
Message-ID: <ZHzKOpY7f0/WnQ37@corigine.com>
References: <20230524122121.15012-1-wojciech.drewek@intel.com>
 <20230524122121.15012-12-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230524122121.15012-12-wojciech.drewek@intel.com>
X-ClientProxiedBy: AM0PR01CA0165.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:aa::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH2PR13MB3895:EE_
X-MS-Office365-Filtering-Correlation-Id: 580aca95-6478-44f0-09cc-08db65216b35
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	/+Gg++ly1G3kmNwk0AfIyO0U2nQZ5+OBCrSvqP2XnJNpOqHmTF0CHOmj4Fogqh/iTt9A6AQigXQsLCZ+C4z8uD3mSPTH06u52OzfbbS0OL9BHXseZbUDjRMOmEQb0Sxl0DTDLAo3ONxe6rd2MpFNgUWEdk/EWBZLu6v5o60tiDbJ3FmI35HOnRT+tmMWfukwi7x7lxxZI61+PSHdlKQ5r7j6GLYT0Bpl4t4DfWXFVlfKU2j+s16aWIwAX8u1U0cFqLzjTWtjMEfX4QWeqrjxsDnLVFuk9S45o+b1A1TpV56U54rOYIqMh6pvlytY7qVyIKCzIzeeWu8blZJ7lU24StDs96a1AhyqJZoBvcl5BGqfFQe1FfphDn97AQyYt1+rcQqipyYh6+HV3HrbNF6T0cj3fRctH5MI0PcAKvoBcHlzCGwIEEFVfYgzI1oTo24sxdxhxAfwZaV3F498pzfx6ezo3eRbNU3vfTB1tyztFVMhhjU4SNMaa04dQg32gEomcKdUzAuYPh26zQqEMyJau4tW8SfAf6AagOCHNLEFTXWkHcjd8OSFlPhZz5IOnjLLmjTHS6JKztQbgJBUGRMKAaRgnDFTlH2Ttf8XB+lcUKE=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(366004)(39830400003)(136003)(346002)(451199021)(7416002)(44832011)(6506007)(6512007)(83380400001)(36756003)(186003)(2906002)(316002)(5660300002)(86362001)(41300700001)(8936002)(8676002)(2616005)(6916009)(6666004)(38100700002)(66556008)(66946007)(66476007)(4326008)(478600001)(6486002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GKkigSAFte17LWMmu0XdQ8Wca0FUeG7uX/1y8B3h41jSTC8keyM+ioPh8E5p?=
 =?us-ascii?Q?+rdWrtvxaB57LB8dQj/42fuixXAfGfrqN2Txbg2C6tsx9PDt0upotoku9cLS?=
 =?us-ascii?Q?G4nwUayxkhZ07dcXyATzXN7thpbi2VQ4EqwjGTUyxp71JNU7EQGWga1ma4I1?=
 =?us-ascii?Q?zf1M5tdRNXN+pF7vrVQL4VcJxtzH4D1I1NyMH41ggwrwcElUtCFnuvAI42z2?=
 =?us-ascii?Q?XI+WOcim2mo99XQChgwkuXlOIXUG9eSHXQYGE1SYufJ935+mN9Wd1mpHqcJJ?=
 =?us-ascii?Q?dd8COEN951ULgAglvOSpq6qUfTYpI95/8d0IyOHMSjaYHO8V+RyBrWQ6xDov?=
 =?us-ascii?Q?ETbtHxWxKEInvxoVrYVI8A/toJFp+2rwk9ncehJfHr9NBkI9bVH5x86BnYOk?=
 =?us-ascii?Q?6K/YTwpB9BJqhDCnyy58o55cWcvsac+lwYQnb9iJikcOiP/VGmTYTSLF+fZe?=
 =?us-ascii?Q?E5hLfh4sYSdP5ZFK2eLQJi0sU944xr+l5nkqcXnAY7YQC87YzL8nN+sFTpPR?=
 =?us-ascii?Q?f9AkfapMmBF1pbKkV/nnxh2xx3YYKpNLoBwDAFtUrH0yVQRwL0ZC5zZTo3xN?=
 =?us-ascii?Q?ieFZaDIl7v0HVXDJ18FuLqWjUg7fxiA2IPgCLcEWhrWXsgcmjOdsGEDBUVLv?=
 =?us-ascii?Q?GL3yHOPMr5WYp7J/0uavOHLhz6jlREqgwu4jdiOF5gJ1Yw4QveJ53mWOQRzW?=
 =?us-ascii?Q?qgChv3RrSkTd9q/NXT3mQb6ct29PqrGI0W2YbulxNuYD8XsYRNrDAgyhNg8U?=
 =?us-ascii?Q?2p6xu7tkZwgYV68fz/KluUtDxZEkH7ZOiF5PjHZ16Dln3utICqIoPdBJoLbc?=
 =?us-ascii?Q?RAEAXq9V9BJcf85jvB8RcaTxLPhV9YvzOAF2LKBdvboDknEQmFd+eyokiryK?=
 =?us-ascii?Q?mak7u22/3fd7a56E6uig/4q04nfU3chsxopYRG9KADI4wpmPWP3nzuYprdLq?=
 =?us-ascii?Q?hfzsTm2u5NT6z8QLLPeXxXWBPQ6SK4r7oLCR0z/mTrPrhPKWajSP0s/Qgze6?=
 =?us-ascii?Q?PT0Gx5UNEw328bz0YISj3hOcMEq0RHdYm8iEKGqBElPZAZvrFTMoZmyam3+i?=
 =?us-ascii?Q?TDo3OP3L0yeKpOb6eyEIKN2HnjzC61yDNoD47GNWhp010AamWaoTx3yTE6rr?=
 =?us-ascii?Q?4UsmTZKXAqwuPmEli1f6IgvO8TM8jJSrYFZx/aGc9kjhlMWsgzcs31XAXbxV?=
 =?us-ascii?Q?9BCPQLdrsKEfw2NQJ/CrzdRhtE+fNHogTYZG/Lw4O4G40qZrYSqntZvr2Ktg?=
 =?us-ascii?Q?RpY7Ko5XrcGhzM0hASZMCfhrQd7oxSpYX7GFVX1aGS149pQHqlVxMNM1UNKw?=
 =?us-ascii?Q?IiDIyvO0fGGdgkUMUwzd/7jmau5IOnsydYFU1HQIkLByXWcZr4JwuYZdFi4Y?=
 =?us-ascii?Q?V5QG4bmPkFkcR9dIObKZwfjFHRfQK10jEsr1uU0RTxm4q+ruXyHoiaepd1A9?=
 =?us-ascii?Q?lygXnvcFMHxwm+8bSXS2UnMPziw+me0A1vylJAWsjivSZVo4qWf4crLJy0Lv?=
 =?us-ascii?Q?5eSpsx+XL18cfDfoUhUCX543im7aR6x+xp2576/sILkW0/f4iO8qcdFecO/g?=
 =?us-ascii?Q?n/WF82oqs1IqWRkCt3Np2b8gHNagEFq0oFSfUSm/G4GhvmVQPcFmhr0ngVhU?=
 =?us-ascii?Q?LrKbL3jFqyRJrwBp8DGLY+IM1ldTsl7ro8ASv2y5sSb/w+mPghGv9ORr/9+1?=
 =?us-ascii?Q?5lglOw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 580aca95-6478-44f0-09cc-08db65216b35
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2023 17:30:41.1525
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +S2jqNDpCWV/b38pTY7tjxXd9zj9kJyzYpAj4iTvRp53OPeEx01PFly+pCc7rE7HQn2SfpdswOvv3Tr7M4TWvjbLZUhrdmAVM+xi7AvWEc8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR13MB3895
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 24, 2023 at 02:21:19PM +0200, Wojciech Drewek wrote:
> From: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> 
> Port VLAN in this case means push and pop VLAN action on specific vid.
> There are a few limitation in hardware:
> - push and pop can't be used separately
> - if port VLAN is used there can't be any trunk VLANs, because pop
>   action is done on all traffic received by VSI in port VLAN mode
> - port VLAN mode on uplink port isn't supported
> 
> Reflect these limitations in code using dev_info to inform the user
> about unsupported configuration.
> 
> In bridge mode there is a need to configure port vlan without resetting
> VFs. To do that implement ice_port_vlan_on/off() functions. They are
> only configuring correct vlan_ops to allow setting port vlan.
> 
> We also need to clear port vlan without resetting the VF which is not
> supported right now. Change it by implementing clear_port_vlan ops.
> As previous VLAN configuration isn't always the same, store current
> config while creating port vlan and restore it in clear function.
> 
> Configuration steps:
> - configure switchdev with bridge
> - #bridge vlan add dev eth0 vid 120 pvid untagged
> - #bridge vlan add dev eth1 vid 120 pvid untagged
> - ping from VF0 to VF1
> 
> Signed-off-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


