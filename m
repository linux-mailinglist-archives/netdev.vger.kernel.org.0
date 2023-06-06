Return-Path: <netdev+bounces-8388-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 21692723DE7
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:40:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C1B562815A2
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CFB68294EB;
	Tue,  6 Jun 2023 09:40:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE29C125AB
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:40:19 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2121.outbound.protection.outlook.com [40.107.220.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39420126
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:40:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gbcVEFuO8O+gBtCYCSiPIyPiSs/Lzsh/Afhr950zu4BlOAkcvwEOECiQcdwXJXgycOjlCs2hI7QXEqjiurkc+0/jAOXgMgZDXg6aofhXWp2OqB4U90pa93aOMxhkhdL8KH+Jxr5Ez55SY5+FoIpA42Epc1gH//hpiQ0bZhm3toT7+bLIFUHE3c03oqsC1viqLSZ3mg47Sa2vJfbPWygvbWpNv0Yj2o9HpgUQuEVI4DbW2H1+xIuFjlKcP5REqQZ4zM/iUu4iOZqmdTEhvE+wo0lDExO3xo2GjD86izSZe+kCt92luOlDEWcDWdSYoB8Y246BF4+SvBgg1Gl7w3qB3w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fLW8lsYuA0xfPlDyri971QlLcZ7ItQvD/DpcOgOr04w=;
 b=P1oefk60r3+JmG5OajWgpD97kyySIYij168FkLGgV+FRomV+vV4rcpOx53Mu1qX/pO5PaeCRhDgabNTlvEqGmI3tQQ25a0Yb3g6ltFVfUyHc/fQbVsIhT9IJuwKbMOYcAf7JDBo8vRlRIJEPFlCmkxY3VpPx/GCJEVOYr35LeqGdVmJC6l8vUgKCtYdCTj5v1eFfV769kjC7vrJXFe7/ak8AxfOBGWWfT3zU13+E8Ic6CDQyonoPi7gz/KJk9YazZ5Yzix24ys4OTySP09K4ghzIy94YHiuvMNPXHdmhMAm1RThzKnjoKUW7cSfKaq1TLMfVU/LV1tO0cvrfjrLX5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fLW8lsYuA0xfPlDyri971QlLcZ7ItQvD/DpcOgOr04w=;
 b=S/P1mL2Oc8IYjtayYeAbKGD1Qtthor1eFedpIcqlYXt1ONdAmQY3PDp5X54ffI4lcp1ZfaeAPMX2ZSZGT8vLR7MBxwOmGJaSfTNr6dW2SvOxMUW4Lr9MY9wslqyyLJ/TabuDh221fQrULXbdA7ix6vnKevA+tBnQmaaJzKHRvGE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW5PR13MB5946.namprd13.prod.outlook.com (2603:10b6:303:1c3::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.32; Tue, 6 Jun
 2023 09:40:08 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:40:08 +0000
Date: Tue, 6 Jun 2023 11:40:03 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Eric Dumazet <edumazet@google.com>
Cc: "David S . Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH v2 net 1/2] rfs: annotate lockless accesses to
 sk->sk_rxhash
Message-ID: <ZH7+8xU9uVBpaXQl@corigine.com>
References: <20230606074115.3789733-1-edumazet@google.com>
 <20230606074115.3789733-2-edumazet@google.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230606074115.3789733-2-edumazet@google.com>
X-ClientProxiedBy: AS4PR09CA0019.eurprd09.prod.outlook.com
 (2603:10a6:20b:5d4::10) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW5PR13MB5946:EE_
X-MS-Office365-Filtering-Correlation-Id: e666878e-1f54-4358-4fac-08db667203f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	slMfhABuCaJ/dBvf4ndYlJKXnjzxLcoBLHVzW8W971hovvva8KViqOol3HWKvVGRvfxLU5LB9RMQpsikqLske1pUopRACqjCm7zD4corTi48P0TwNURsi8Zc7crsxvN1etxm/lyEFSllTrGMjvw3eiEQNysXlDUJdCmJxkmbdDOS5A3Za7ge3S4rdVvREjkH6p/vyfJiSFOG8jRLhCUGoXkwttP/9y/zyvMjIK+s+dIm3n7Zz3DQLmObwuFzBjcjpTk7SkHcrJRT7ONnYlmHbjnhyPSZdMCNvCJ2rfpl5crbGNwg/I2iivJDEXiuw0GB1r2mjBu/hWCbXl/pAyqH9Zs/O+IZXF89o1Epro21kvl/wu8MKSGl/Xx4FQYsnbYb1t6bxTYFFZctpJHFAfGDd+VK4daKZg+NZTPqeL8e90cAtp3ves26z7L62KAdNNymZXkM6LT1MJkTlodQuZ9L924oUGm/wHN7aS21ZS/OvREya1O8dMWqT7+2kxqR1+XJXeqTQkVBaxu/VcS6LvO/PtKua8MYC/tCE990nGD6uX2V4tFNZv6fJ0lP6eDd6S4CXrM8pUoGMfoNwu6TMpRyW09W3zRiaMOYb30TLtO+hgk=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(346002)(376002)(396003)(366004)(136003)(451199021)(44832011)(2906002)(4744005)(36756003)(38100700002)(86362001)(54906003)(186003)(6666004)(478600001)(6486002)(8936002)(5660300002)(66556008)(316002)(6916009)(66476007)(66946007)(41300700001)(4326008)(8676002)(83380400001)(2616005)(6506007)(6512007)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Cu2qg6fSlK/xwThFGQxbO5IpiDMBs0yi2fNEeejGXqxWGsFcwoyDmJ10ssNe?=
 =?us-ascii?Q?EPcaNLWGcUv7VDFEwHnGZUSmJU2XUG/L2UkLh71xrG1ZceVU4Eucn8Xprle7?=
 =?us-ascii?Q?TkWQ4tplEBmNYHICjHToCOwhksnY2b9K1p0L9hX05IRjpzAeFFilGiucNju0?=
 =?us-ascii?Q?pME4T1fcq5IanVKtr9G0Bp3w6fuEqnBo+T2H0iRpEnPtwGHne2AtuZf45nSW?=
 =?us-ascii?Q?u597oZDEoG5eAmEdhnb2DAUYenh4ijiVpwuG6TrjcIfJU3JLEmZMsbtIPqWz?=
 =?us-ascii?Q?6cAfTkmvPCd1bhEnbJNlMNGjPNavGaQE27MN72iUdTkQf0Fu9jZt+Ki6TRbB?=
 =?us-ascii?Q?ljZ2Thp8LsMU7GUYz53kmKxdcTt/Nvcw95NkXvz37qSmbk/OcmK32l//Hcia?=
 =?us-ascii?Q?J87rkavkcT8y0pWlgVE6JjXQJgqgi2ZHFkzj2zQEhOXOOZbncdXB827IgPVY?=
 =?us-ascii?Q?b5pgd/st3B2wbAauz7mzY/3rKLqtOj98F7KVep7claPyzbLXomFwZOG/3UiD?=
 =?us-ascii?Q?21h56q+1wKB/BVSoANk1mH/hHYP99rjRJaq660H31AhYidMSPxBXq33RJhKO?=
 =?us-ascii?Q?WwQ9AiL6S9fHGmdc55Uy/CHiMS0oRsxyDlh+guTgMTkU5LkEZaDExPEHS6yK?=
 =?us-ascii?Q?p12WSlwdAgtoI00KfAJl+HSdkwXbB1V8So/TK9nQJLA3fYWXauH5Fw9J6Ngg?=
 =?us-ascii?Q?KxXQ6iCsMw0bkCxGjdnCkibudJkz7m1EsmOY1vwlytJu+CTNr4XBU4u4CANW?=
 =?us-ascii?Q?zJIEcrivWItyT3iWIU0Rp1kRNOtXhsSi3SYk8gMnS1S3CriKsprA0RWT8GGT?=
 =?us-ascii?Q?xXDIWJcxpei+IYtzrST9xjXdd572ry+aPct5ExNI+7FonDa+3DhQUcM4aJ8U?=
 =?us-ascii?Q?A+Mgv+2t7wRdZXkz7+CBjBp5QqxTfGuzS7hKC+gW9ukRgPU1BdqFLk/IurBe?=
 =?us-ascii?Q?Q3oHCkluT1n0ivJQS8gxeQYfZodLmYRBKLagdl8cwVDpX9NsL2TCVMuwsyks?=
 =?us-ascii?Q?7VLFaKnwq/a8X47wIXqV5/U4RerRHYoN4mh4c9XXLA2MDIEWnJ1mhjyBqKqw?=
 =?us-ascii?Q?2vWHfBufBMlUCMiT7+j4rQ04VlxLL0COiTc/O91M9ZG42EUP+kLdsHQNtwcs?=
 =?us-ascii?Q?w/GUPX2D3C0XIJYTgAV8zNp6v5DV4X2KOCthQVEaaj4axOWTmwMGXWrN0uXf?=
 =?us-ascii?Q?AeyaC42SJORQty/cSFKOHbea3dRMMpk6hVw5HQ9CpKQAkpBUtay2TgvzW2VB?=
 =?us-ascii?Q?mz2bepr7RNi4LrTTQuGDP0BWJOdM2c2HdVeldPM5tkdvedhiR5e8vW+99C4d?=
 =?us-ascii?Q?Br/WzbN0gdM7PyT9ZN/gMqslGmIuKW8hkIm5FtxzoAJzDIa5SqVEpgn9J6JZ?=
 =?us-ascii?Q?F6dzm19wJCUnEjMFoFuvKEMaLh++rAXV4iBPpeFdcNRWHdfEVPkDhvC/LOPp?=
 =?us-ascii?Q?riWlBzzhsc3dZap6Ywj4rL+3ER5VNwlkx1fGOthph3qhVCXwD8qfavvvT3DP?=
 =?us-ascii?Q?gs3VE1HxXZ3K6jfYZMvJatLm3BA/ENrihpb0QyG9p4f1ARHiJsCHEMKZl0K+?=
 =?us-ascii?Q?uJJqk+I3UeScEzAU3pUn5qZNHBbGvOuJabDNkElwJvqVBZYOwXzBPSy2PvEu?=
 =?us-ascii?Q?ND55mcDimabqObR0iPDVmtmsMVfZDPIPK8J8VNmNJTojbxkomR6QoAaGgf/f?=
 =?us-ascii?Q?ZIsteQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e666878e-1f54-4358-4fac-08db667203f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:40:08.2778
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xpgsWIlPpAcCs8kRHbOitZSO23GEKmP7RA2x6J3d3FcWWZ7mjaiK3DHgxqOwguZaMpS/B7yJ7z3kmKNcFX4NYB3s8WvJWUBewpVRSi4aLmc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR13MB5946
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 07:41:14AM +0000, Eric Dumazet wrote:
> Add READ_ONCE()/WRITE_ONCE() on accesses to sk->sk_rxhash.
> 
> This also prevents a (smart ?) compiler to remove the condition in:
> 
> if (sk->sk_rxhash != newval)
> 	sk->sk_rxhash = newval;
> 
> We need the condition to avoid dirtying a shared cache line.
> 
> Fixes: fec5e652e58f ("rfs: Receive Flow Steering")
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


