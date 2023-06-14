Return-Path: <netdev+bounces-10668-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 79B4972FA33
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 968B51C20C23
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 547C86AD8;
	Wed, 14 Jun 2023 10:13:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402E86110
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 10:13:08 +0000 (UTC)
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2046.outbound.protection.outlook.com [40.107.6.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98798195
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 03:13:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=erbURBUJMI1hL2l0ltLQcAfKs2qW8bNoDk32BjuvIoXG6hAFD9tUHSXswCajWV2noPa2jGph8C1cs/IxDU2WoaG9kOH28VZdZdnVI3ihOVbvSZ5rWWshZUpjxDe2deQIL4t+i9LBEElQhq8dx330VbwgN+/ATP5Oy9EpYctvH5JwgOENmIc9zAYu0e8HMBGwjPl+T9aOv3PXoC9bTtYuMnbAtMtdbEwB5MzlFiPYRX1FAEUnzagdZnpm0pbqKLQKuij4JB7IGsspunx1EIFG08Ss7Zr2LyoL4DON8jIE2tA9qiZbR7uDLdF20LZmnRKbsvUoCpATcWTYyrtqIZu1iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1R0bBaiOCd5q+v3OGVwFIeE2LvGuYKgzVpgTZ7+tl2Y=;
 b=PBIbsmCdYI0tOWg7xnMwdixZVrb0bypdw2AsBLjgre9smivrsTifh44JMWVxkrHxXZDycWhhTcDC2d381x9LFmNEJ3meqG9BkApQ8FAnWA2N0178N8++abTkLHSaxX817w1T8Ye8sFYFHqKaJyKVl7QOBSAca7VzDSvO7HwpX6W56hOJwLTvXvcMygpfqUka24MBAle5+alc3Jycyud9bSuahstsyCEQt1z21LFoDyDDY242GMEBa2ciHwDki/gXOJoMl7xpG/tcIvJ9jRHufYCJ/m0vLMEV7AlLX1qYmGgOWPmS3znejMJDOKqoW8sDv/WPTcgjWL2msRIY+T3BVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1R0bBaiOCd5q+v3OGVwFIeE2LvGuYKgzVpgTZ7+tl2Y=;
 b=VLCdb/71B2gX0ZC/wjcD/IP1jVVQ+OJ7sYyP0ulSiNxwV7+4zQC0OFwvqP1Y73vqjvVohn37A7EZzp2aD8xPAfJ87+FxAuBHgz0kc+/77YaL1c5IumfQDLmwx5/IKdyLTxOh5lU0eRgcuzJ9MD9CtD+5ioSnaQkimFS4PpOyQC0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com (2603:10a6:208:16d::21)
 by VI1PR04MB7088.eurprd04.prod.outlook.com (2603:10a6:800:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Wed, 14 Jun
 2023 10:13:02 +0000
Received: from AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460]) by AM0PR04MB6452.eurprd04.prod.outlook.com
 ([fe80::c40e:d76:fd88:f460%4]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 10:13:02 +0000
Date: Wed, 14 Jun 2023 13:12:58 +0300
From: Vladimir Oltean <vladimir.oltean@nxp.com>
To: shaozhengchao <shaozhengchao@huawei.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>, netdev@vger.kernel.org,
	jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
	davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, weiyongjun1@huawei.com, yuehaibing@huawei.com
Subject: Re: [PATCH net,v2] net/sched: taprio: fix slab-out-of-bounds Read in
 taprio_dequeue_from_txq
Message-ID: <20230614101258.hezbrkw42fls622x@skbuf>
References: <20230608062756.3626573-1-shaozhengchao@huawei.com>
 <87zg59sbzb.fsf@intel.com>
 <e01c0675-da18-b1a9-64b1-4eaa1627fcb8@huawei.com>
 <20230609094542.y3doavs6t4qk2jlo@skbuf>
 <a6b677b2-b2bf-c91d-a6ae-d043081f9026@huawei.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6b677b2-b2bf-c91d-a6ae-d043081f9026@huawei.com>
X-ClientProxiedBy: VI1PR07CA0129.eurprd07.prod.outlook.com
 (2603:10a6:802:16::16) To AM0PR04MB6452.eurprd04.prod.outlook.com
 (2603:10a6:208:16d::21)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM0PR04MB6452:EE_|VI1PR04MB7088:EE_
X-MS-Office365-Filtering-Correlation-Id: 6991392a-4bea-4fc1-0189-08db6cbfefe4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fiM8SBqdgHFLCSqwJdvITrjquBdKui/3N7I1rgXlwR4EDKmUc8AnqdPbBFGG6S4ADZ1DtFy6Bl/CQguhrseiLHebF30xxw3rjITBAqGZnKcAQMp+tzcKG7bNoyIWISg68gAaaMiUJFWYlYuDjI1TZ4g8uRo4AimCk44q0Xd53n+4BSV20YCrDawa7Cr6otJ5jUZM3nROToYGXv6Pzjldtk0DkImm0jtWEFn2ta6Cf/KLmwnvWH44kS8QwG7yupmWVxqPyxYru2iOqFJOQD+RYDHBtpNqzGspsWxO+SvzoG+FOY2KJL6Y0wiXtHZ43vcpxq7/9MFMnnvbXfSFliOyvufeWGp8E7dGFgLdYfnwkg9McSOebzx+wgm4M4OOEZTfFBBoQnwK11Lbtp4AFonH+LZbcg2VcjcGLplxfkKcIS+4mZ11GnZLT1TTbRO9zAJx8ZK2WFjiq+fD+4Rhv7grlt8N65lcHxVZTOwPt9X+hq/CQqVvEUjC2Lei0WQao/9MtmNDQ5PkTLeiWtfooJkGYA==
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB6452.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199021)(86362001)(38100700002)(33716001)(478600001)(44832011)(8936002)(6486002)(6666004)(966005)(8676002)(2906002)(4744005)(4326008)(5660300002)(7416002)(66476007)(66946007)(66556008)(316002)(186003)(41300700001)(6916009)(6512007)(26005)(1076003)(9686003)(6506007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?a42dqiafS1Rc3w7eIXyZwWSuuPoqXELau/JTUiRVN8Qna7+3LHXVT94D6kxk?=
 =?us-ascii?Q?0QTVPY6gUKGei5pnoN78t15qAwea8unZjuFQQH6vukwWXjVa+yl6ODdr/f6L?=
 =?us-ascii?Q?OzlT1raAHrMgSOib8emQ6PAfdoaGof4R+Y+5wy4ZeXTjsKESrlufCWHs8Lm8?=
 =?us-ascii?Q?ucHqQ0gctsRw7DFxBPt6hDjFzGsxiNMBt1ooKDADvMBVgEth6rW2nyzytpU4?=
 =?us-ascii?Q?JXI+AsGCoLVggfCswY7ER4zHyTFb2r1mi+l+ZEUfc9CDgLwbZgTyQdwNiqtb?=
 =?us-ascii?Q?vELq+4zKuTdiYJVYhMnLN0WEQmefZgfUNyYu2QYtn0Fjf2r/M3PpYu9nEFr1?=
 =?us-ascii?Q?9zFKc9NaubhHFXqmWP+KWuCbhIkse3gLDp6xe5gARo+heqqRRAMO/fvJNLVJ?=
 =?us-ascii?Q?7C22ux+UlsFmhVUGGhJ1KfsoNMQix+cU7Rh3KQFXDDS++2FMgnc8ODY5pTGw?=
 =?us-ascii?Q?BNmsp2QRcKTM8yDuAbvJqa8Ss8kekUJVwJzr7mB47NZ+p8eteUHsx1azH54v?=
 =?us-ascii?Q?hanK2wn+DynZcOcr3R68YPrVuIT748vEC9naHIB/2EH3HQJQq5XyhY3jg2QJ?=
 =?us-ascii?Q?k1rTbvc7hvjyQXK6jQM0OPwpAVhnszi1A7vZdufDC4GGAEi4bSYV3V+Xo2y3?=
 =?us-ascii?Q?dVj1obWb7G/JyWv+MQEqHHvzqbdInz2WV26btckDcg7gasU1zX926cqPIrPq?=
 =?us-ascii?Q?Q1PwCJhy/KQRo4cmKHgvLU0kdilUSvps3tQJfjrwaWcb7AgnW2BMUKe7NH1o?=
 =?us-ascii?Q?PMojv3XJj4auBk+R0ShNpAAHa+c4hfL7hXGUvVtRG4X2jd2QBlhE1aslb/Zo?=
 =?us-ascii?Q?BwBfhM7lidEa7BxFVKmINNgWJNUgqLH0ghqrCHKbi6P3hR3uRMCpk/s8GJ9K?=
 =?us-ascii?Q?dFgVYPhjhtIoMhnzPShnExKu5fundAx4etV/XvoB3gV+rDQeJgSYZFuHTe74?=
 =?us-ascii?Q?CXbyqhNtBepLs+Pkrcapor0maw2uoYCgSVoA6aONMA8QFSI/rGFAvlsGa07a?=
 =?us-ascii?Q?u3/IEfv/KzoCTkiRZFFudB4lN2Z2KInH3voWZEf7N0eDSWHisE+bX9/202gQ?=
 =?us-ascii?Q?stOezmZePHBdiBu3gW/Ue3P5wFF4VH7oQhm/mallTs345isbMI7go3ZKSPFF?=
 =?us-ascii?Q?gHfIDASdS49E+SpIvZSJlY7jcm5jGbMjbQw/0U5R5qJNVH2IL3bvBWxFqwn3?=
 =?us-ascii?Q?CYmReM7oNNMKa3aIKPAuaUVJVqn7AsiRJAPGilDI94v4TGgwcOsUxD4Fdbe9?=
 =?us-ascii?Q?hk5IBRt5hKW1xZh3O74+Qjxjk2E3Pa1OP2euwdXlafDax6K0QKV/Lef0K7G8?=
 =?us-ascii?Q?ALv1x4/I3VKEjBgmFjS3zb5zlYqnpN5EeKIu/2eyxMSw90FUEOiC6n0+d8w/?=
 =?us-ascii?Q?wotsWqfFkHgbZiDTybQBMBRj6TOROMD3G9WsJSFe/DRcUVCCytX+zYm3DS2J?=
 =?us-ascii?Q?KR800mxswy3DvtW5Keh3o2gbpVLEd0RkABth+9X6F8i0PQ5gz7MOq/WyFrJn?=
 =?us-ascii?Q?wMlM3ULKC3VjshebLWJBBxaV7amsdeo6MB2gZ58szwB0TPpJbOPtcCwwu2xC?=
 =?us-ascii?Q?jGarq+dw1c9cbStQ0KSx8tWBSKIg3G2/iWz66oFRmCfgytzsZA3jxZR1fjPV?=
 =?us-ascii?Q?8Q=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6991392a-4bea-4fc1-0189-08db6cbfefe4
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB6452.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 10:13:02.3867
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zMoPQIjTT2We++NWXtLbTdu3ymU5Maa2xNoKKqne4EM16uNDa/rvJfvs4P+omkuWQqsyJTzwRmdgFikVXVM3KQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB7088
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 08:49:53AM +0800, shaozhengchao wrote:
> > Is there a reproducer for the bug?
> Only the syz reproduction program.
> https://groups.google.com/g/syzkaller-bugs/c/_lYOKgkBVMg
> Thank you.

Sorry, I don't really have time to become familiar with the syzbot right
now. Can someone help me translate that syz repro into a C program?

