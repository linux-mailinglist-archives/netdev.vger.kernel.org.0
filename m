Return-Path: <netdev+bounces-570-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7713A6F839E
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:15:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC32C1C21844
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:15:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC727BA57;
	Fri,  5 May 2023 13:15:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88C1A935
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:15:14 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98FFB1E986
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 06:15:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f3wDjd15QfMsy1PMLBGv4if768lCP0uwGB9iPVE8Vv+iYkJnyqQTOQtqLdOviVdIg/XUA5KbRGIv8oJ3l5OXFpKzsXMVCunNs36n+LxqhS9tVGd4H4xSbowSgp8UcKGgDQg7nw2YSUPWhzmk+94KgYQbGdgCRv5FvPn3kTD1FlvaEO2HNszh4IvXGNB6VqCabaHJAkXlrnloNlUgR7RN5jY0CW7KSJWzyEZvDPoo4HlQSokjcyETcbpf0SOlP/x7T8jEwiyazzRqnFUTXXNCArnntqhR9pRHyeeBQD/YhK97htYxlWo1kesR4yFxSjPiPla4rxryrvnuMhZd7uPaHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Khr0ut7VSMxibw2WLhNCHNdhJJGDP5kqEFc/1Tpk9q4=;
 b=fQnsoRVRUwH7Y5BEIg1MHaz2+y+NCABbL0A1221LgS3sgp6Ui7mcvNzdTImntXtWfyUq8GYd6LL6Czfclgq/U/vr/LyR7Rz29J9lHMUrSeMwmkLl3Pj7tjYROinQuOeG5fNOiDtAoSfoWyzzgsSlxKAwc0+gJuZWMiAflgOBT2LkbvFP0vN5Z/WA6RjtgGgrdKMg6R2sXfZGcrb4WhvCfkZDYOtqshSCONyGTs1Sx5VIhAdLRvHys8Utfj0o1GgTESAPWTKjiI8JwrcEujm8vA3H/EJ/RlxoPO9VKVQrBdH5fSpZMPQLMyQba0ld02GYjsG7nw0IPGf7GlR6dJqCBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Khr0ut7VSMxibw2WLhNCHNdhJJGDP5kqEFc/1Tpk9q4=;
 b=aFYLlxQaYTiB7AjYh31vfIw1FXU15p+duw4/awjb84VM2UGjyLcO/0E6+7Zk0vEZr9b0UHkzLtLT9PQHP40I11BXRlRz1G93KbMgwWs8AiFcJ33ZPqCEotPQww5S9pZZGNZ2DBwbgmYQA0aHdKok9YJsdx/rRFtOZ+kKR0AmX+c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BN0PR13MB5216.namprd13.prod.outlook.com (2603:10b6:408:158::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.27; Fri, 5 May
 2023 13:15:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::f416:544d:18b7:bb34%5]) with mapi id 15.20.6363.026; Fri, 5 May 2023
 13:15:10 +0000
Date: Fri, 5 May 2023 15:15:05 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Chuck Lever <cel@kernel.org>
Cc: kernel-tls-handshake@lists.linux.dev, netdev@vger.kernel.org,
	dan.carpenter@linaro.org
Subject: Re: [PATCH 3/5] net/handshake: Fix uninitialized local variable
Message-ID: <ZFUBWcCTRPkQRdty@corigine.com>
References: <168321371754.16695.4217960864733718685.stgit@oracle-102.nfsv4bat.org>
 <168321392193.16695.5713194659624553982.stgit@oracle-102.nfsv4bat.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168321392193.16695.5713194659624553982.stgit@oracle-102.nfsv4bat.org>
X-ClientProxiedBy: AM3PR03CA0054.eurprd03.prod.outlook.com
 (2603:10a6:207:5::12) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BN0PR13MB5216:EE_
X-MS-Office365-Filtering-Correlation-Id: 1015b7d6-ba65-4df6-305a-08db4d6ac0d0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	j3m6JEEQB3aukXrIj/ihABFdp0DcVQxMDICzVw0HH7Hip7EzYLB788o1ITlRcmNIezosZF92irPSwiaK3bIqBNEEb7RD1PxKSLQ+Z/vCBFCFS5WYwfepGGSGkTqBkDd2P3EiLEFMmx4Hb9RR9pNQ/yWLNiGlkzmZSOrT2OMCJbGHASe6ybe5Mq/1fpFZ9JL4yxDEc7uUfabaSJdc5eFiVVnrEN1o4psWQRdJXs+/2wtMreN7CjpUSkTs1J/tBExgeLANgzI+8v9y2lZDCDxZ3Xkb8fOR0GERh+Ji/bDpVrb3JlNLJZnyEPawPGz4rTKHd7LM9TKK126SxMUS7XoDvK88gOcxwDXMXoj41ca7gT28mMqVlCcqU56vS91NgqAnW8OMATNF1t8eAl/Tb3U4oBM0f1ChfO45X16JxwNHF2E3fxmdtnWtrmjiHULGizfCDNNZ+5nfFN6zzVQ593VDDAfXdOoEFyHKJ8Dj0N6kczzzrf1vJ1IrTxvtfXLYc3GeOjeQPQeHfl1NZAcU5d1OfX2bNVdM3+NjYH1kpr0iyuRvKz3KjNj+lY/qQ4JtZu0f
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(136003)(366004)(346002)(376002)(451199021)(66946007)(4326008)(66556008)(66476007)(6916009)(6666004)(478600001)(316002)(36756003)(6486002)(86362001)(83380400001)(2616005)(6512007)(6506007)(8936002)(5660300002)(8676002)(44832011)(2906002)(41300700001)(4744005)(186003)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?WrRqCQgqivGnv44c3n+P4XhHIG1Mapc7iZHVxGpJn6wnpc65X9+OBSUNpDWH?=
 =?us-ascii?Q?ZHYP45VTI8cRy2EI1k+bTAuXp4L8PBHD1yTjGjASiKLRHrhiz23dn3xrrh4m?=
 =?us-ascii?Q?bFMhUc3JzBH02DKqJeuNadfGiwznZdX9i+++yICeqXQIoVou1T/bWAXMOwEb?=
 =?us-ascii?Q?SyjS9KuCczeMSOIaSoyJtWk00IGm4fwFqkojl+vjOFtUbgee8AbhtbHvRCUc?=
 =?us-ascii?Q?V2P1Ls6JihkCut64L/QsxMJzwvo8LbR51+56FndeRi9veVnrzu6ykVBj++g6?=
 =?us-ascii?Q?fDj2gXFrNrGq6XpUylpvuWIXJMWzowPNhXpxS2OpSxzSb/XaN7anyJUyNhJ7?=
 =?us-ascii?Q?1zRS93zH/8kBm76s63zaFJ756TMf6Hg01A00C0gdM/EK9rCkn+XKuUK3kvLx?=
 =?us-ascii?Q?oGmMmBUEYn5dMqNRDOsWZDV88SaR+IrYP2GLF56ZO7RT1EzcZBwY9xglgAp4?=
 =?us-ascii?Q?dIo2kfUjfbZgQ1f6xMCL1XxNthPOqXREgTA266kVwDto+Vq5VZ4BYOIGucod?=
 =?us-ascii?Q?ARRVd8118jcX6kgpcZ2zikJn8MRwHqP9SPFsFabLMFt7p31gaWOrIzx4zUpp?=
 =?us-ascii?Q?dU1oU0WpcJTebE9UBVAn4UCG/hNJbBiKZuJOdZUypuhfLxdhqWBwzvPfnpCh?=
 =?us-ascii?Q?6TOvmZmUGaWQuD8+T+HFtR4N5/tQzkoV64MQtSJWX06/CURN2xpTFd2W/ShV?=
 =?us-ascii?Q?JSTWzG7xD6CMuC5iIRlLCU0RsW24zUYZXBGWFeRJDDsCrEjM1qBdR8qhzenc?=
 =?us-ascii?Q?nM12Kvokyuv7SgoGSLLAKZWyz4gowN85l5A1lUK1oL3RRlOxO8VrY703ecFR?=
 =?us-ascii?Q?BHURZRlPNNygiXH6N85mC95HPap3k1EsTe2AMxr29yAyEiD6V1NdBLMk1XDZ?=
 =?us-ascii?Q?nLsC1ZspBQVx99GT/OXHzpZ9kSmnVpnM1T0fUo+lZBi8tfrc2kMjErOzIk7n?=
 =?us-ascii?Q?Ny3voxOBwyuaaTv7i0xIyOzdrPLjgCWLTKqBhp17DPKPRCiQQaJpHb38zM0R?=
 =?us-ascii?Q?cEMmZKRw5EJMTlXIni368zrZbkp+HjdJcsJEjhXQc+/SvpKN7vzTHKp+e433?=
 =?us-ascii?Q?0nv1LFoq1JvRg34gGm7rz5J9zKvq3AAfYHVtP2xcb4W/z9ZVzksfuaR2NEIG?=
 =?us-ascii?Q?CBNNo5vHioUWY8bqkgShyFcrRq6YFwWXb0jFskzYw7AELi0LEL27x2N50Dqu?=
 =?us-ascii?Q?V7q6yfvCIyo4BwsE11cYiG6/6RHltHQ9dnRSmcqw1lHQTFu1kqk0IBa6WQmI?=
 =?us-ascii?Q?y7kv2Ey7Xw/vdlp5ULl+XgmdeGNqs8FYkpIQ7cup6UeWgDiO1d04RTLIcm4A?=
 =?us-ascii?Q?9y/lUbt7cMer8sIxBvFc8sMUiY1cP/cpp6psn2UxNdqGi/itQnTXdC1La42N?=
 =?us-ascii?Q?MzJqlPvgtLPDZtyrHxes6j1t0s5Y5IRigR5wK8sP1Kg35Q1xixVE7sJiOuWG?=
 =?us-ascii?Q?NN1DA2lBOle/plimXA16w+mbtpdaVgXapuShbe5dyT4tenhtoD66Zj9UwV3/?=
 =?us-ascii?Q?wnDONWB/bjgWtxXPeJE3/K2T+m4TJnZZxm5dAA+x0EanChZig1k1/m6xwNiC?=
 =?us-ascii?Q?CkFf1g9KC4bx2jfAvUZkLpPgpQ3y6f0itBuVOZr0bs7d0QEfdwj2R2rpYJ0F?=
 =?us-ascii?Q?0X6Wz4f+5EWtJHMt9xouwiWLNtdJGEcdytmC9xQCbNDPtsAnqL7gwvQi9b6p?=
 =?us-ascii?Q?MIbE3Q=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1015b7d6-ba65-4df6-305a-08db4d6ac0d0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 May 2023 13:15:10.2966
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3ynTPy8kzhX8G3F9bsoFVElu4VO2tETituiWtMj9VckuGZo+UAFmWmYYSjGwmt3hK1gTsgq2R8W9Pd2bVZYlbq/7r2jbJzJfFWP2JY2UvB8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR13MB5216
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 04, 2023 at 11:25:32AM -0400, Chuck Lever wrote:
> From: Chuck Lever <chuck.lever@oracle.com>
> 
> trace_handshake_cmd_done_err() simply records the pointer in @req,
> so initializing it to NULL is sufficient and safe.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Fixes: 3b3009ea8abb ("net/handshake: Create a NETLINK service for handling handshake requests")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


