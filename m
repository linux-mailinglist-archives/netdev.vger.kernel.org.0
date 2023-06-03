Return-Path: <netdev+bounces-7665-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 96B3E721056
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:07:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AC8A31C20B27
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:07:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A0E0D2E2;
	Sat,  3 Jun 2023 14:07:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28ADFC2FB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:07:12 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2117.outbound.protection.outlook.com [40.107.92.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A08B7B4
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:07:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q1g0Mpb17QLd2yIb3mvQhGZVncXnJKBbA4atkOdg/4HgSjgxh2Z5GfjFup59duNyf9sIDjqqYjo6yPOn9qvtsp7TN5ZK2JzNhX8FyqNs54FfZ0hLFIEcP8FcSOAKwkQP3znT4kEEwlFmRuh9cfMhwihxbCNwXFuVUANU7t85cpfq4sEPIrlBrBhhsdoXBYuVrlM3FAUhoI9BdrhumdcHenV+AuxZf4yXywaty2Y5E4IMp4Av7E8gcC4x74cJTRfxEzDj4gH4TSqwuWNCQdxE1gcITvh/glQ8xoguYjr3mP0Dw9pRfzW6t48EI34GQ+s5Nad3prqkleg10uLqEFbRsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jpeVytKW790rKkJ4s622hb2lN46uNT8/hHPFNjiuhkU=;
 b=h+MoWS5UoUSgrQI9aFKaaYsO4scC6c6ft1cusA3D0H6KXHJo8zyS36M1HvmzkpNM70XngJdCcTUykIj3DfxP11RB5vY14zW5vb1K7F84COrXuZxRuEe41zliL5IR4WXS9mQQKkjYT6TPQbD73b52GQ4SNzkWXmuIpIeISywGN7/QSfKKUicNJqipqJCELGzMmjDEiHNCqwMt2NRhgOrMOkcA3z2tABHcHpBO6w6qHj/UFX3a2ip40aRDPglHjTjv0QjfE5S6SKXYfwf9k2hHFRBHqcMtgB8NJ31QcQM36o2+dRpQ+RTSqhmpYYQVX5AyW2FrucVs80S4ignVGsVJHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jpeVytKW790rKkJ4s622hb2lN46uNT8/hHPFNjiuhkU=;
 b=UQWEm+EtTWYYYIKvLh2d3RocoZVkCc7F331UkzXj3qoGzNU+4zYnHdJIYLaDGXe2eJAjhf7yrh4u1t8DaPDIJXj+9AnlI1heHqBbxToj+5pemAylq/clt8TfCcE84hzvMlH1WWFiwAh0JXmmP5TailbRc2LSDMIeZ8tJWVhpqxU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH3PR13MB6536.namprd13.prod.outlook.com (2603:10b6:610:1ba::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.10; Sat, 3 Jun
 2023 14:07:07 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:07:07 +0000
Date: Sat, 3 Jun 2023 16:06:59 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
	edumazet@google.com, netdev@vger.kernel.org,
	Piotr Gardocki <piotrx.gardocki@intel.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Rafal Romanowski <rafal.romanowski@intel.com>
Subject: Re: [PATCH net-next 1/3] iavf: add check for current MAC address in
 set_mac callback
Message-ID: <ZHtJA8hrbSIVz5eD@corigine.com>
References: <20230602171302.745492-1-anthony.l.nguyen@intel.com>
 <20230602171302.745492-2-anthony.l.nguyen@intel.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230602171302.745492-2-anthony.l.nguyen@intel.com>
X-ClientProxiedBy: AM0P190CA0008.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::18) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH3PR13MB6536:EE_
X-MS-Office365-Filtering-Correlation-Id: 22321be4-7f25-46e7-dc2b-08db643bd086
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RgL6bs5DssXkBeaMoxL+Zdd1SqqqcXUvm7zeIJ1/FDfKg0ylIOHgsP2oeixZ/kBBPLLq1fiy6FKm4VLn8rzsp20YzGB9ankEU0TRxA84KtVs1H2+Z6BQT9dn6q4A8WduNZ94R5WsEVr23rcvfyJEY5ewezlg5oMEmNmJjfapjO1n75ZZE0g5BnCBmPVOGJJDkA+qs5PTqwdSy4GmQBWDP9GpYIntwsWd9gn43gayR0qBh4/whp/eZ72VNU74Iko41zmSLNqv9LpGQCDaTA6oEoQu+xq6d6t6uFKT2k1/WBLuiOaUeurh691pMtu4LSJwxx1/ydOH5nw6FRCcJMcnIhZ0wMs5a7E4afi4DXGkLtQmwuYU6VorCZmaF8zWdtUqI3xZjz8jo/ZMoGcWL5nabaBWYmQPmRxlOpYiLO3hJsp+oJ5rgoL3s8Dp30XqvZyyPwOYybPvVZj+QIZOKVBRhIIiPu/jlVvJ6JtJOfJv0xSnsFME6BYCYU11p6U8ckOmeadikWm6B2Q5iyQpM1PmOFr6Y09Y7iSwwYtWQFXvwYf7dc1UxPReLOTqvQppXEQE7Z/6hjf7z3k+m9laaVU9m+as2ICQa7XEBEE+Cxf6MTQ=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39830400003)(346002)(396003)(136003)(376002)(366004)(451199021)(54906003)(478600001)(8676002)(8936002)(4326008)(316002)(41300700001)(66476007)(2616005)(6916009)(66556008)(66946007)(38100700002)(186003)(83380400001)(6666004)(6486002)(6506007)(6512007)(36756003)(86362001)(5660300002)(44832011)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?6d8uF1KYBq9UALMYwI3HtTd8yOLqQ2ZadZiHJuzujSvEnzcqSKT4M6F4lbwD?=
 =?us-ascii?Q?+GM2dvAh1gMMllwwbp4sro/xTwiBcmSW+AIzz7dqZCcheVG+r2rVAdIGU3Ul?=
 =?us-ascii?Q?gJ2KEzo/62st6pgKumtvcOKNFS7WEvW43RYKHbhIgf1a1sMOUVCrFha3yAjD?=
 =?us-ascii?Q?+z0zEYkeGWu0Nqi/Z/4Fdcj/X5O/uXrahWktmDNDmzsyReQyZO1wm/EktB14?=
 =?us-ascii?Q?kQfVXPC0yOOMCUksEyi+8OsTCeIZC3+98U90iKztf+i8AOv/LtCQf1m+WXLn?=
 =?us-ascii?Q?e3gFMSn2/LNOsfXWRV761lWs8qmjd1Omm6q5xC9dAC5um82UP7ZCD4HOnCQh?=
 =?us-ascii?Q?Zazy+aXrdm9zZLZ7j0wxZ9ZL24nietXB7vQ4gzz7eX+irp+rx+0/Uqel+FJV?=
 =?us-ascii?Q?b2OoGC6FZA0KGweFBIIu7fO1U2HfCr+hkRDmxes17t4KekfYmHOySs7nxjaC?=
 =?us-ascii?Q?qfstr6dn+ukN42LQbMyF7TRcuuzQxo7FSDHFJXR+zzOD7+/voa0ABtteM8lB?=
 =?us-ascii?Q?ZBVbuW0Gj4JcDgUg/2HUluGgemHB4Qdkk36qdEaFay3sm4sbe89fRQDm00aV?=
 =?us-ascii?Q?c27T9DbsLRFMKNKJ9WWGdrPMMj+QFfw+k1eTa48wndSn/yYClHNNPwviedet?=
 =?us-ascii?Q?2G6PkWA/oC1bO9Vq3fFL26F9zWosZULrM/TjRYEJSBHYP/8ShVECC7sUFV55?=
 =?us-ascii?Q?lOGfTcG0LmrLRp7/AbMvToPVDVGeZt7JU/DAar2XP6DaOeNuyJEJb2eVqt5D?=
 =?us-ascii?Q?U2GZf+8RHNyuJkGvQLVQUuSAKcG1JbYv7Dx8DJnhBrhormBAXCucLQ71Du06?=
 =?us-ascii?Q?PxqUzwpZdgLz/kkciFbwk0AXHbmaUWy9cCXybZ+UPBIOZ4d7kOki3HqWk/h+?=
 =?us-ascii?Q?MVzErgu1KNEDccnvJ8j9Amnb19u3/WHDBkphdTC7NksVuuso7OVrWQZIq4Dq?=
 =?us-ascii?Q?se7w0oC8cItrgaB+SnC26w5cDvShpq6KWIdnOF/MV8lZoEm2UIfikHXtZezl?=
 =?us-ascii?Q?WQAjoqVCkJgGbwqxK69M4nbR/dgvTnuSA9TAYSgtAjZzuv8gAJimSQSM+Ti0?=
 =?us-ascii?Q?byEE5tsNLfFs2eaWFiZFg4uM8n4z27aBjOgPPZ2xv3QunxpTQxRYsz4xlVDW?=
 =?us-ascii?Q?kNLtxTB3KZ6YsNhf6AO0UXJNOQ0ORJvc1MI0J7MdShU6nkGGqM+g8Cm/yPC1?=
 =?us-ascii?Q?noJ6gOSjrobqvAWtYO6P1c1qnPgQq5TUxap2Ts3sAeVc4cB0mHBUIXkOYaeM?=
 =?us-ascii?Q?PhFii/N/loacUYMui5O1mnLLQSob0jxpRg4pkuyFpSjVO4or9Mnz8JymOipO?=
 =?us-ascii?Q?O1BbIEdUe5aqPrw2yI/XNoL6ipRBFsD1NSdiT2HVYv01BbpEeDHmty2Svn0D?=
 =?us-ascii?Q?9PN9GF9ymiuqABAJ7AqRcCOzIQOqMzCZ8Vm4e+2x6QL9jXAhWimdKBcLNfxj?=
 =?us-ascii?Q?CeGY62RtsLf4jl4y1eJpX8G/8X1pQFR7vApNMWMUDwovnl5pZnzewii3xfaR?=
 =?us-ascii?Q?DLRgN3hNLObheayS5DI0bbMjSy6KrDV1zXEbyPuemHoX2IEvNJZm9YJXd+Vb?=
 =?us-ascii?Q?9uBaHweEtqV74lgn20o646pfzQBtsq5BhRaRMZV7h9QlVGuT8pgZTgIKBkRM?=
 =?us-ascii?Q?iy0D4D3Z+qAlNtxriqlW3me8BS6Ccfv77NsFa1ULiFFsnXdMbhXZfgq06W5/?=
 =?us-ascii?Q?zlCUXA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22321be4-7f25-46e7-dc2b-08db643bd086
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:07:07.1299
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZhVr3O/+qaYmi1LfSygsIvynBZ2w9yJXxe7RoLKWbiu/azaqmuRggg45dJYUt6KnrjdC204tlblPgvdRy8S75NSqfGowGM5ewG7+R7nZOWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR13MB6536
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:13:00AM -0700, Tony Nguyen wrote:
> From: Piotr Gardocki <piotrx.gardocki@intel.com>
> 
> In some cases it is possible for kernel to come with request
> to change primary MAC address to the address that is actually
> already set on the given interface.
> 
> If the old and new MAC addresses are equal there is no need
> for going through entire routine, including AdminQ and
> waitqueue.
> 
> This patch adds proper check to return fast from the function
> in these cases. The same check can also be found in i40e and
> ice drivers.
> 
> An example of such case is adding an interface to bonding
> channel in balance-alb mode:
> modprobe bonding mode=balance-alb miimon=100 max_bonds=1
> ip link set bond0 up
> ifenslave bond0 <eth>
> 
> Signed-off-by: Piotr Gardocki <piotrx.gardocki@intel.com>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


