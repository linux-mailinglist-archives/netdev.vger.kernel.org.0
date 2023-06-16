Return-Path: <netdev+bounces-11375-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 68259732D13
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 12:08:46 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1CAD62815F7
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:08:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FAAE182B1;
	Fri, 16 Jun 2023 10:06:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6F279D3
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 10:06:55 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2132.outbound.protection.outlook.com [40.107.92.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B6E035A1;
	Fri, 16 Jun 2023 03:06:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RGA0/zNvyWOrBATzYt/je+ebbAps+RW9fwiZfv0+q6Q/ScNqsO4KUl0QYS2yfNLfs9qKtq44BM1ok9YiC41A+in7eOcb1mOh+8yxw4pacKarexfcL6f9PRGxNq6PU8kPv+tHlAGbsYktDkMvd2s/I9FF0uZJLbyW5iOafs+8awRO553c5CAqm9quTjJpJIGL90o2iIIhj/R/r1kkELu8ZG8TrcZFj8NOcXD1qwW0tDBTRphUwqvkgZsS2hKvlDsgAYtGJsgs6riX0qhoD1AfT7YmjKJEo1xU2dzyi7YSCXqn+i2MWScToKb6VW1skIUWE646duuPit72jE0nVfDtQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8sKV1AdVeDidj/7n+XHvMBhza280gxgIsjdhh54BPX8=;
 b=Vx2XfdnsyWtP6lGf9Iln4aCfYpDOmsd3BvOjohxFzEEEqXQoc7NscPYVME49ZWMmIr0dxq5gWmGuSY5A7ro/Gza9dNMOTI828UyIsigWuklJ+LUB+IPsYHoBJSJ+ZT2QTqW/oFQr+PXOW7VvfJJDpzpuGGUWsV0lkMJjFVwkE/d84OvX4+UQUBqC9RAZxHjuqJMGxRm2qoxmDGybX9PClrZPrt8ElplqBumP7PsRz3bPOJ0r7BCXq6Vp3jD20qp/rxaIUXFgScAMmD6Gip4JXfkrbmoAZjJXP9xlspwqsfbZSBIhcZqQlJpnlGkUw4pGVcGCiG7Bf1Lvrq8FX8x4VQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8sKV1AdVeDidj/7n+XHvMBhza280gxgIsjdhh54BPX8=;
 b=GxOv5Rpea6VFUZ90vV8r2elz+Mh5oZygBO6Vz8VF8VTDNrkPVQ+MopqkRr3Cv/q+wF6134VDOpCgxVMxUxEyUGgodeyW+cjh6/jFjvHv9SBWcTQwJQfzK2IveAK/EuvjLcqK4iP7ke0LxZ7t1iVyhu+qD04hePNp5Z7ljX+U5l0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM4PR13MB5860.namprd13.prod.outlook.com (2603:10b6:8:49::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.25; Fri, 16 Jun
 2023 10:06:35 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%5]) with mapi id 15.20.6500.025; Fri, 16 Jun 2023
 10:06:35 +0000
Date: Fri, 16 Jun 2023 12:06:29 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Edward Cree <ecree.xilinx@gmail.com>,
	Martin Habets <habetsm.xilinx@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Alejandro Lucero <alejandro.lucero-palau@amd.com>,
	Jiri Pirko <jiri@resnulli.us>,
	Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
	netdev@vger.kernel.org, linux-net-drivers@amd.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] sfc: add CONFIG_INET dependency for TC offload
Message-ID: <ZIw0JcSb/WvcA1/+@corigine.com>
References: <20230616090844.2677815-1-arnd@kernel.org>
 <20230616090844.2677815-2-arnd@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230616090844.2677815-2-arnd@kernel.org>
X-ClientProxiedBy: AM0PR02CA0204.eurprd02.prod.outlook.com
 (2603:10a6:20b:28f::11) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM4PR13MB5860:EE_
X-MS-Office365-Filtering-Correlation-Id: 5c882ff7-5469-41ba-9790-08db6e515e42
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	vU0DhiSD70mFc0yQAXnwB31R81U+2n6R41CAa7XtDRO4akACnjMhuENLOIpeMKPAxDZlMSokjDbRE7TOFaQ3lanNB1X7N6++tlPuEai2jrgTCy8/0GZuW3TE5R5h7p5jIXQjyN19e/0o/BBXkOiOd2PZfcm3i8zkXeXKxGEhanF9JHO/V5N9gf17vCFfwn1/ZKqHLzhKhI1istpTPdRejQqfVaMe3a7VyxwUrg7KrV9czrpM9YRGlxB7kGu6XpnDf1XX5qKODCexqaIvVYOxnwPZ7wjahm/DZYEHaYCqzDEjsrZ7b+pDHcN6qe+NsY6WwiPETnGYKlGTD/H968FJ00gPI3ZLmqP+60zSDHe4dl4n+z/RDNViKtkVTUwbiO1vrAug6TkbgLI7Pr8mu2ThImlZEBJzxdevyLtKzwDyd825xegQD2nZsstDhXGPVNzZ56cN7WbYI6Gtgvhtia0NLYxp8vZDhtf3nbKUlsMGWtny1ggv3WPGhTlzsuVlTmrrXnT0T+xTnmD/a7tjZVKQ6YSNPuygNGYiQV53hzjhk1rDsbFKfn4mhpATy/KSQuCzdXaFzc/Misd37xwSpPwLixoxpYfRzlIa/dQ3QFSAbLI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(136003)(376002)(366004)(396003)(346002)(451199021)(5660300002)(2616005)(38100700002)(83380400001)(186003)(2906002)(6506007)(6512007)(44832011)(7416002)(478600001)(6916009)(66476007)(6666004)(8936002)(316002)(6486002)(66556008)(66946007)(8676002)(41300700001)(86362001)(36756003)(4326008)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XxzYJy+fxq7Ej4EwC+U6DT4XUMeqYJSqA+nr2UUR5uajWxdTAqkPxv9U2Z59?=
 =?us-ascii?Q?C9BP2FGaVTd04FgeaEk/ES0lJnbUan55Mo1vxq2yeJlCVRpMxGxeW8shYQxa?=
 =?us-ascii?Q?zGi3ouQ5sQSDt4Cae2OaoHrSXEeF58uP04MMfAyqdvjLW0xEAvQQ+TElzJCU?=
 =?us-ascii?Q?OAgCxs3iFDKrETsmfRNMap7U+X5vc2ZQay+/U0bWDhZZE8q+Yx1GgDdvKvSc?=
 =?us-ascii?Q?lEFyFtxxk7eYhUdlRvsNBMbvRjSzHyL0ZRbA5gxOEyKLfB6+gAOPwyvqyWbH?=
 =?us-ascii?Q?0yKuIV+B+5j+RWH7+YZnb5OUe4CgTlLlM471Ma9454rzyJKIggsmXMKOTJ/J?=
 =?us-ascii?Q?Dv5wFpVSlGOwwm5d7OQ2GsPQXlD+nyS0VBMS26Reft7gX5yKZoRt1ZymsALl?=
 =?us-ascii?Q?UnJfXTbSFJDX4qpu+BTfAS4hzRD5q/lLiO9tqiRUOKPj27R3SZA6wsgZSMHy?=
 =?us-ascii?Q?683Qn7lTXLq/uomk3v9kjDWCy20gekfOBDzi2MzDcwiQ2RzKR1CNQXUwLDT/?=
 =?us-ascii?Q?HtEMkH5WRnOaPLtYvWfojLZERFkl9pXgV7+y3Ys0h7G4+uMPxMNffQ8L/Okf?=
 =?us-ascii?Q?a+Jp8vcuK/tzphQ9lH3BZZUYG8jgSj2jFsRtFCRNmc+Fmt1IJtqXMWi/3cSZ?=
 =?us-ascii?Q?GJF9mxPX9OPrHrLnu8BbAeRn7PPQ7PoMAKnCGHipx1/7DCUK1PtvN57dlBJI?=
 =?us-ascii?Q?V5RIK0BrsqAhFEzOHPW/yNFtuIMETTDBNCfndOl5zNC+OBxMQXdpdFNDY0yn?=
 =?us-ascii?Q?r01UkKFcbtwybihFTOmyit8e+sAtiw+SVrEpSn72Nt8i2ZwPh3hFIY0PYNkt?=
 =?us-ascii?Q?BdBuhFf3j6VYHF1FDXm7tdjTPn/fzkNq3llCz2J7hBB/JQLE+2zVWgWqui63?=
 =?us-ascii?Q?qwDWvkvZRmZiNX8XdrEVB7H07J8zmaBrgXnCFT0RH1pPa78kp262qqQxq77h?=
 =?us-ascii?Q?WMwwKK/Xq6ZcX0s+rz3basCN7WMpEbJOaJbBaiFmFEMM+PcuszXRTOjAtubS?=
 =?us-ascii?Q?q32WFPks6nMDh395sGSugePA3sWh2p1XrzTcnBgWkd01NgiBbsGkbuRcO+1V?=
 =?us-ascii?Q?n999280itGaSyA+H83x2naWqGP/8UFQNvxUfux8cHVSSsfaIAZHXzwbiDEsJ?=
 =?us-ascii?Q?OurenSpiNehQhhnqxSzBSlmxStApcQlkCGC3rNSx5OiLQFXeORyyiK112JLy?=
 =?us-ascii?Q?N9t7CNZH48jrvhc78rsmAXccGG7+dvOqHpAweh6APvoz+XVLHRE+WQCWhBjI?=
 =?us-ascii?Q?K5EXRUYPCoFNXFseBkmS0gJjMZTqivpIFWcAkechWSdSCpcNpn/YKLiHdHxP?=
 =?us-ascii?Q?KaQuY7LAeVXYfupiS3yHL/5TO0wgD8pxXlnP6nMmtI5lhGuFaJHIkoAQoxPy?=
 =?us-ascii?Q?bKZX443kVMEwXwKLuFGoo5RyjPo+uYBOghgOv/WDK/7K63lkl3HZAwzJW2oQ?=
 =?us-ascii?Q?yX+M8PXLAqJZmd3owODHVNbKQbqpHuyx82N2D7ekx+VOti9JE5QiyyvJNLCK?=
 =?us-ascii?Q?MnN4pE4JjJJlsJ7aiZQTCZqJ8a9F6qhI4SpevvARbhscd/bSlwwNPX2LYjOQ?=
 =?us-ascii?Q?dLaQlSblSGnlJGA77uHKSGO6fRj+dkNLl2oBKChkcwFRSCRQAOz0RRa3v9kB?=
 =?us-ascii?Q?1R8fe04n4vGma5shNprjiJ+fI8ZQY4maJ1ArXHQ99UyaJnnMtKqqApiyagIg?=
 =?us-ascii?Q?AqqTlA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5c882ff7-5469-41ba-9790-08db6e515e42
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2023 10:06:35.6860
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2ZmTGzCVAXmXiBCER0rYM2XGIhAEBPa6vEXQTvFx0ON2angXQY+PoRhmq4eh3lOjBwMj4aGqH8nxQbz28mz8VrwDIejA6DFTVXfKa8i+Exs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR13MB5860
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 16, 2023 at 11:08:19AM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> The driver now fails to link when CONFIG_INET is disabled, so
> add an explicit Kconfig dependency:
> 
> ld.lld: error: undefined symbol: ip_route_output_flow
> >>> referenced by tc_encap_actions.c
> >>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_flower_create_encap_md) in archive vmlinux.a
> 
> ld.lld: error: undefined symbol: ip_send_check
> >>> referenced by tc_encap_actions.c
> >>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_gen_encap_header) in archive vmlinux.a
> >>> referenced by tc_encap_actions.c
> >>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_gen_encap_header) in archive vmlinux.a
> 
> ld.lld: error: undefined symbol: arp_tbl
> >>> referenced by tc_encap_actions.c
> >>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_netevent_event) in archive vmlinux.a
> >>> referenced by tc_encap_actions.c
> >>>               drivers/net/ethernet/sfc/tc_encap_actions.o:(efx_tc_netevent_event) in archive vmlinux.a
> 
> Fixes: a1e82162af0b8 ("sfc: generate encap headers for TC offload")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


