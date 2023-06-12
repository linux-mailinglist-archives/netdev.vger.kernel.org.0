Return-Path: <netdev+bounces-10251-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F14172D36E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:38:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7C7D91C20B7E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:38:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6667223408;
	Mon, 12 Jun 2023 21:38:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 599B022D60
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:38:18 +0000 (UTC)
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2087.outbound.protection.outlook.com [40.107.20.87])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B3CC9
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:38:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QM7AARrvMqTh0Sq3IYHeyek+HAs0ZL5k2RUJwiDwFx3M7eakVGMO3DDw5zGFiv8ho78IpsAcoGrBJvYe0+hmCGOYmAXDAz7FA21UWc3G39xD8zPj1yGY7cYXOyWVrriNOp0neSQ7WPe/cKr/z4yAh8TNmPUsVzsl1gWt4Ld/BEouaxG17c7fduY3jlwnivIOpc955SqsMhYrraP98jO5LO/0zuwgb89m8HVMYKd+90+oj1GvKgnLRGKsW9s1CTEPCHAI6IOb2kRx7g6rqqVuPNq3Ix84c/EIgC4sq/AAOVbaza6DtDcqCVtOl/BHk9O/9MwHb0ra2aZU8gEJf7gHbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wg6IMaYeNfT2Cx3T+cbOpi1vBnYfDA7C3lhuMlvpdH4=;
 b=nvR2/vzRg9YVehBYiznKqgj5zryFZztyFhIh+JUoNIkdsjT4nQayThCwqHy8xeM6YL2QXDOdc2R0SMS6oQ/8Nr/rGs+My9I23HcJ9ZinwGd9XQBTTy3nNqMP3sQ3E5Gfon/9A+/ajJHqceem85Zjpk6Igcu0dgIw5DcASMyKSKDn2CMG8nJAH9EMIv3ncwKoJEnJoMKh8d39hmyMFkxnBmKqW4JssjuW1XXv9T43F/xdf/wv27G0cmmBsHqTAqZMCV3vu0vJ6bLYN/jBSYbMmaSkYGY3fnP4pK+/8ocvZfk6PMEGDmQke8tfuZhZvffnIGuneQMtB16EDfRXYu4jmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wg6IMaYeNfT2Cx3T+cbOpi1vBnYfDA7C3lhuMlvpdH4=;
 b=mFd+oFjWHrKkQHYgYWAjEQy9UM7/BEQK8DYVcfz21HbI9ywht9Fw1wrhHOvINpb9y58cHWfjR/BaQX+WGhhULbxK9XWW26Minhr+P3Nq0rUT/xzMZgxwCGaXboIk03Bz2gjMLsfIKSr5Yk0mLsDeZzYL2GNJYsT6AARLy2l70QE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by DB9PR04MB9913.eurprd04.prod.outlook.com (2603:10a6:10:4c4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.38; Mon, 12 Jun
 2023 21:38:13 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Mon, 12 Jun 2023
 21:38:12 +0000
Date: Tue, 13 Jun 2023 00:38:09 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: Zhengchao Shao <shaozhengchao@huawei.com>
Cc: netdev@vger.kernel.org, vinicius.gomes@intel.com, jhs@mojatatu.com,
	xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net] net/sched: taprio: drop packets when tc mapping to
 empty queue in taprio_enqueue
Message-ID: <20230612213809.upnxxlsk6e4mih7p@skbuf>
References: <20230612033115.3766791-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612033115.3766791-1-shaozhengchao@huawei.com>
X-ClientProxiedBy: AM9P250CA0002.EURP250.PROD.OUTLOOK.COM
 (2603:10a6:20b:21c::7) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|DB9PR04MB9913:EE_
X-MS-Office365-Filtering-Correlation-Id: ceafb197-5a42-45f1-fec1-08db6b8d52ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	HtCNpyumOMbxVsdkrHxy9kW7fOyvJzYxa1qH177TMm71VRaZ876oUYHQFWQQlGQfEEAdjXPQt7JaxSzDWYUh5299dP7+NfhKNxBfHR5HxTjMh9tz7mok8pZk9zFxb2KALT90ZE9tHUNSL+qlBATnQwU3RzmTp90Ubk94J3E9PTS//biLzTXhNRbT/EPgd0FMGOtdcBUZxahs36n8N+weNLUe9vkE+3lsZfTcObuWYv9aemj3685mE5LG9ieC1/SxHP5pDX43e5VR1rsUPtz/KRBGnSaFhZJpExbLiFpjODdG3zk+Gsj7nD4mJ5YkeUaDh2X/ipugpXSp1Oy8n/+tzKhLL/+mw66+TGIYVU8tcwAZbMPv8ZqmdQcOw/sUYFX90o4OgYZAa3t5xz6A3pLvNzxdyGQhAh248YdYRnatUwUmfqkPK9qoEqJM7zS5SjjJbtW5NOpFCetGYojGz+lurzjwQZd3gpoYXuwTh5Vazs9D/5vMyhIIeG0Qufio1ITbbrVAxYMIH2GUp9b+dL/qpMSM9em9LG9SqThdlismwUs=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(136003)(366004)(346002)(39860400002)(376002)(396003)(451199021)(41300700001)(7416002)(44832011)(966005)(478600001)(8676002)(66556008)(86362001)(66946007)(66476007)(316002)(38100700002)(8936002)(4326008)(5660300002)(6916009)(6486002)(6666004)(2906002)(4744005)(26005)(1076003)(33716001)(186003)(9686003)(6506007)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?OztuZX+qOZo0BRZPvg593y8Nid3zvJlqLHIL8RGJy1mHj+krLIga2zZos5Yt?=
 =?us-ascii?Q?MnZWquL6pgRSlHkTXwazxKSSgzIwf9f9RbLhtZZsbbMOfkZqA4vd9ZU7jb8L?=
 =?us-ascii?Q?sWFogac7FVKe0lYeYdI6EAeBkzX6uBvWepvFBb6T3ZPzIo3V3/3p0ESJV419?=
 =?us-ascii?Q?ufHzBMoGhf09fS9JTN+4teLKX6E6Znu4dUPqybc/gw+HyJOXTMCqQROrqVAu?=
 =?us-ascii?Q?rFLAP6xyIrPB3lq/TiBCjyJ8WYP0I2ZOEsw8HK7WDcJmtPSBZwua6QjMmrnA?=
 =?us-ascii?Q?6aPhVWgE0iHXbdFgLM9fRjRLdD4ADl9bhCJbWkAKpnCVNOt1oy+sFQABmXNN?=
 =?us-ascii?Q?s7OBSal8n9wfNGHnlqKZu/857kNCDYmwHH/t2V73uYxE1fM1PPmA/lxZ4t/y?=
 =?us-ascii?Q?bQTn7tc0WvVAM45K7LSQJSdmwYkZfXhEjR6+fJMi42hbo68NZjQ+3lBh0fer?=
 =?us-ascii?Q?goiEouxzZ0bFX1VTck6KVn61is46FvnXFGeSipq/oOtbcDuyKbwonUoYX1BT?=
 =?us-ascii?Q?LNzoa5p/QchM6GbwUqrBA2ESon8y+fI42a/1ytRvAFX5X6VmXj0FFpxTyao7?=
 =?us-ascii?Q?53ZGRpwrAmrMxr49AHVEbpytK+xLp6tDuQA6KuOsGGUsOiWhvBrLvti+T368?=
 =?us-ascii?Q?tkNTDLMkVD2KlOsePdSPL84/6IZorg3uUPfqk7LyHM9MNxcg9Kv+uv3pUmg1?=
 =?us-ascii?Q?RbxKUlhc1xZ219ngPyXe8ZSNDfqFFUM0NUNkS3tf45nu6X2Z2bL5v82wIVXw?=
 =?us-ascii?Q?lrHnhyThzgzu7r5a+q8J2+hQ3XZsv4ohg5FzObHi+aGzmL+nYccLnyXBed31?=
 =?us-ascii?Q?t9mtaYFRnOPL/GZNH8l3Yb4fJDc5tiOHfIhPqlqRvPaaZLvgx83Yo29oB5Yn?=
 =?us-ascii?Q?97GhOqFHhm57PQuSP2STbFrz8REcZ9Vbnw7D6bi3fyMp/ryTm3PGxSKSxBt5?=
 =?us-ascii?Q?1Q6nB3Y+JqBE/9sPwabg5lp6y590tfVTSHSYc4T7UKXzi2+BdT4hph2PCcRb?=
 =?us-ascii?Q?HKMSDEUmQSfO6e2pcp1bfTAxJOZMDLRJ1KEE+6HWWLbcyJHNToo0+3T8t0gF?=
 =?us-ascii?Q?iZ2oILXJQKCoPU/IzlksHqF9KBsiaCsPi94TLOnkjjs7mJUQFpNtJjKeOYBm?=
 =?us-ascii?Q?p07rctsbcKy+92VgqmTqAldnY7HCR65B754rooHmE5FrcIY1SOGxQR+FpyWI?=
 =?us-ascii?Q?pz0h1s+vMEtnw8L6iiT3scgMX/GrQslLfiRlJGQH/eG1OJmlTnpcJCwpS4/2?=
 =?us-ascii?Q?/PrUk2AyK5F3zyVbb4QaVoK+FUMGkx3zBumZzyOSKZZ4zUP4pr73JRXVNDrB?=
 =?us-ascii?Q?knZwoX4I1h5YlEOnproOVPumhprMao1QSITDmt+tjoQBLfbt6+FcBeQBuXo6?=
 =?us-ascii?Q?y/tLQYp3dLIH9NT8ofLEi/hJ57iujTLorV4144SnuL0ZdlCxRgj54hM3LI3d?=
 =?us-ascii?Q?0syZyL/A+48hjt2nBWXAirF8MOPUdEKCLgNfheEdoTMH1vhYEh+44dtUFmNw?=
 =?us-ascii?Q?SiaVZ62hHcCjBC8O9oU1EKcSDapmYPgA8An0EbXQYcWccolJC+xPvizV8fKV?=
 =?us-ascii?Q?kv9T8koo4lS89+GBKvK6+Lj5C24oo5KbdJKoAYMdXOrHAGBzB4J+qXmW55jJ?=
 =?us-ascii?Q?jQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ceafb197-5a42-45f1-fec1-08db6b8d52ba
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:38:12.7698
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FBSzudAef83DAS5HEX1UC8aqkrjbmwB1fgyXRVi2NcBUh9fL+IVfKVAe9Lqf+K+82cpC4ku5FVaY0qHGdxd5Vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9913
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:31:15AM +0800, Zhengchao Shao wrote:
> As discussed in link [1], queues setting (0@0) means TC mapped to the
> "empty set" queue. We should drop the packets from TCs mapped to the
> "empty set" queue (0@0) during enqueue().
> 
> [1] https://lore.kernel.org/all/20230608062756.3626573-1-shaozhengchao@huawei.com/
> Fixes: 2f530df76c8c ("net/sched: taprio: give higher priority to higher TCs in software dequeue mode")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---

Is there any reason at all why this patch is needed?

