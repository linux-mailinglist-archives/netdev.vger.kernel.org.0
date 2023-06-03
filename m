Return-Path: <netdev+bounces-7677-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C396C72108F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 16:47:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 697D22816CF
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 14:47:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A933D301;
	Sat,  3 Jun 2023 14:47:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BD820EB
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 14:47:24 +0000 (UTC)
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2114.outbound.protection.outlook.com [40.107.223.114])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9676518C
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 07:47:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut3fqb5LC91R2lmFj0jNfBsev0ZVYFggumP/9OiXFc90Sq6PBXAapDQE8Oap4exON1055y3byPNCoMgDSiLptBtfZkPegtwLujFR5eRL1Jk7eYUP2w3IVRUywL4xqyCzcDD6D2cM2iRDPx5IOR9kn3z2WkyeYnGi6yZvQhJr1WdAUjnk1xO5Xlx/cNjL7Y7kYSmhwCgPWlUareGV9MeKpuHvQEyUZ2lnKnbh8BtqSOPp5qzyHfgzUwoQie3kzbcdVBbfl4s/iYYzu5jlQTUSBxZP55PLjcQr8F0m3VgbZF2CAoXXpVa6bRYQZZs438kXwsHRomhTtPwqP3At5SEj7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RL+pCVXngysaFwdZ7T6FFzN8D0Ci2fLViTxZoWVfJQg=;
 b=l9jYOfQ3FC9wQ2KTKfZqCVFhuX2kmlD3YPQ0ESywwEdh6zSqZiPLIkdliquh1zbcH3JTd8ko962mtTmZN1uVv5ZEd+x3cmRoAPA3gngI/sDuU0w1O7KAOk6bq0olLFrK/b/KkbM5fQXE4T3ANhzCImJqEZ+e+vovGtzYkXc2rpsazaTeSL2CvPF7hIedDkXRxRynu/dU7sUfeuCG3GRmftsnXKdu7FZTnzNWyD114m1Lbc7McxzAH82pDPqu0zKuF0MsiGlDPIfTZ7EqTUSou/Qw6IsCwqq9PTXNUAopWjASef3hUYQaj2GrkllG41K02WtNOA3+17UsjT63sKp6jQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RL+pCVXngysaFwdZ7T6FFzN8D0Ci2fLViTxZoWVfJQg=;
 b=D4T/YkcaMqSbvFKwa0ouzImHgvlKcpjQb2TcR0Z1/T2Nh1CGmSsKRk2YEyg9TBZfL1QYDDeb9f3AJHdLUwGPsMbYEYrNfU/uuMb/XLcvdgAl2nSrb+H5I2tP1xbUJnG+UllHtKF2iwyqkKGbp8+19wmMJSuvbfaHIB2ZH15q0gA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SJ2PR13MB6118.namprd13.prod.outlook.com (2603:10b6:a03:4f5::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Sat, 3 Jun
 2023 14:47:17 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6455.028; Sat, 3 Jun 2023
 14:47:17 +0000
Date: Sat, 3 Jun 2023 16:47:10 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
	pabeni@redhat.com
Subject: Re: [PATCH net-next 2/4] tools: ynl: user space helpers
Message-ID: <ZHtSbn1oHl4KcfUL@corigine.com>
References: <20230603052547.631384-1-kuba@kernel.org>
 <20230603052547.631384-3-kuba@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230603052547.631384-3-kuba@kernel.org>
X-ClientProxiedBy: AM3PR03CA0076.eurprd03.prod.outlook.com
 (2603:10a6:207:5::34) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SJ2PR13MB6118:EE_
X-MS-Office365-Filtering-Correlation-Id: 8ddd5686-b953-47f0-f4ca-08db64416cf6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	3u2HuzfaS3VLTOn8ENm5x/2nUcuS7TBQkYZiSC7R8VepAUJelrgfadkJKtIwd03cBnloNX8FVCwn1cPHVZam92qHfZrIjwnFpz/UQnIBB/cI9JzI4yN7cWnHcRzaAMRHTcsQCB9v2y9By5xb8htyMHow5QplmyhFhRDd+mBi+j0nUsKz9vhu2uDSTJCyybTwDMSGUYttmRs4CfKe+JLyeSXw6EbwE1nVZEuZhrT9JfNWYyjxBiOKtkEiD6kALcXpUv1OTnsNxTtZT7M0m3+xNAKyi0wWkcamsDJrK6PFsmmk2M20N3vjVdBsGbumRxiZg+5gIpEEYxF+UwMpUCVVU1X5waWrTF22D0G8EvOXrJp6Cqo/HVJhdP6AOKFBCAsZBldpa06s5kGo8MluaM+hutlM5MwHUn77DMgf5gkhfHaw0aKUz1+Fs9BqtwqNlTgb45XCQiopR0041WVBbEbqz+Gj8IWLd/diRMqweDCyN8wJDkbMN/pkBZlgLQkT2uZ57zjM8PiDFDTWa8ex3lmGkjygvg60YzL6/NpWLjjPCE+8w9eiQrznj47FDwV9jTKh
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39830400003)(396003)(366004)(346002)(451199021)(6666004)(478600001)(38100700002)(186003)(2616005)(6506007)(36756003)(6512007)(83380400001)(6486002)(316002)(66556008)(66476007)(66946007)(4326008)(44832011)(8936002)(8676002)(6916009)(2906002)(5660300002)(41300700001)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DMJidg+OWhty4xXQHnCVlDITGwftz5c6l5GSMrQZkkl++ZRO0ZAWuIKdagiP?=
 =?us-ascii?Q?HhxMqlFXa4ya/aWmWTl/6JlZ+t4yNuHc9kfqiYR2Jutq0Ls18A9a5RXp5oYS?=
 =?us-ascii?Q?EufGBL2e18pioA7iLQme0UzcopTZuhi+s4y0QdqA5ta+v1Jc5BwD4EAPljcP?=
 =?us-ascii?Q?eHHLQ2ieXnGsuZD5kwg4VRJNpZQGdKJ3xRYF3xX3/77QHm231steWChIjkPI?=
 =?us-ascii?Q?fTfhZISbOTXMBGEjwtU6MOpDqxA7HZXPfoH7IPRig4gw6IskGG0q3vKEwjbZ?=
 =?us-ascii?Q?JI4z7fCsGVC4wIDTOe5QrsjZ1qLU3PfqfGhWMEgmCKxVSnlOS3cGla32uQ+A?=
 =?us-ascii?Q?y1v+AL99akNDRqiMVgMQyMQQcEX4Fqgfj9xTvdBHiDgAsuSjttxttZi//um9?=
 =?us-ascii?Q?pZiwitK1LdzNDkH3Y4Bw9jWBbMj1Je5GU1b/wZjXURclCLShzL3nG+A4CVn9?=
 =?us-ascii?Q?Gt858S2jjhGKc/MrH2BYuaxU9//AzL54uW13W8QIcWpOsZfdgmMN0ZuDwBZ7?=
 =?us-ascii?Q?TQRo2G9jHPz+0NQmYJAnqwBF4zZK5qbUhyXy560wmlX2cpm/P98Ud3Zo7p8S?=
 =?us-ascii?Q?RzG/Cea1C8xys07o8aAZA134b6ZEgfibmS4aU9pimA9A4c6niVWV8R8fhAJ1?=
 =?us-ascii?Q?R+MCBr8/mOtb5/VOIjqdHpNxjqbUxNsVRXKsESh5rFmNJsKrKCOEjlL5pyh2?=
 =?us-ascii?Q?TcZ8LxH8tJlFtAlMsqVPFVteLZ5IGGSnkqGubX1NxOK1JLzgOcIFeW/A1sy5?=
 =?us-ascii?Q?hl9/sn3iYVZldqrS7Ou0QInOwcgWcRkjHGF6Fw+5HkuhU3xZKSabE+AavhFQ?=
 =?us-ascii?Q?G7W5qoROx4/3hPvPbXul+dmb4JblZT23TbkaECG4hOA7HwBCwvvL34L8sWMw?=
 =?us-ascii?Q?it7t+963k5U4zrDa5ybQHMRxwjNA/7oRz1qb9Q2KLHOD+bvtOkJSLePOAfdb?=
 =?us-ascii?Q?gl54HZ3AOwP3Qk9D8dXwQSDkDagDnjE1Kbz71eMVAEZgF2WE+ZQaqfxWR5/P?=
 =?us-ascii?Q?1ljrIxYlyHJWk7Sl3nT4k1jcKVw/iqE0Ywy9AMAjCJzK1XZNESNfOMRIrq65?=
 =?us-ascii?Q?Kv2qAMs1rGq1boklfaj+dq0IG15C+7ODlMein7MqP1785ACOpycEMwU5c5JK?=
 =?us-ascii?Q?Et6CFtGIdrgHMoA4h3Di1/MmN/OAEx67rVK8DEIBEiSh99bOTRbMbsKjMHc+?=
 =?us-ascii?Q?d1yPeNRK3tEspsCyeDDFhkZn5k7qQ83oD/YsU7xiBTQL9GqRsge48NhEow+p?=
 =?us-ascii?Q?46CcFr08urtpnG3lNO1wMVYhlDrjPjKZ/6mh6Yu34LfWnhWqQz+FXebhI4Pq?=
 =?us-ascii?Q?liIvbi8wkPBMvt55kDp5laFgbk2r0MqPNbg7JSLbziqbcp+rOzxniu7AhC8N?=
 =?us-ascii?Q?CZZbktSawaL6868j1Z4Rh+HI3VWaSDFAWf9R4MXzgyQrmyW6xuhJ/QZjA5hQ?=
 =?us-ascii?Q?jvwPs+iOPHwT6DEzuh7XUo7jZe+UGlMlnw2ezC/KbyQxy8383I+00U91ah0x?=
 =?us-ascii?Q?h7h5Izc1IZMCuwYcUcqkDoYeGG8bBK6rvhcXK6xjfCvFUbAbKyljEppKKxDr?=
 =?us-ascii?Q?boDy522SJoIf0TaWYYlQmR1zx/AVa1GTe+JX46DVwfNHwU5QIzhkDJUDdt47?=
 =?us-ascii?Q?PETHxPP2n3E15wNnaNxVSkHp8XszRM43Co37NWogbBAPXwjOjCzQCIlNrthS?=
 =?us-ascii?Q?CmO7+A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ddd5686-b953-47f0-f4ca-08db64416cf6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2023 14:47:17.0728
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3dB9rISs+Zb8W6vkPhD+F91QbMijoztBfZg/kgiyPd8jROTzpsp6KTELaPl2hgZzUr9Ish3wutvJBdx5Yj4q3+RORsNpi4gRdZ10DnAGg3I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR13MB6118
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 02, 2023 at 10:25:45PM -0700, Jakub Kicinski wrote:
> Add "fixed" part of the user space Netlink Spec-based library.
> This will get linked with the protocol implementations to form
> a full API.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Hi Jakub,

some very minor nits from my side.

> +/**
> + * struct ynl_error - error encountered by YNL
> + * Users should interact with the err member of struct ynl_sock directly.
> + * The main exception to that rule is ynl_sock_create().

nit: As this is a kernel doc, maybe document the structure members here.

> + */
> +struct ynl_error {
> +	enum ynl_error_code code;
> +	unsigned int attr_offs;
> +	char msg[512];
> +};
> +
> +/**
> + * struct ynl_family - YNL family info
> + * Family description generated by codegen.

And here.

> + */
> +struct ynl_family {
> +	const char *name;
> +	const struct ynl_ntf_info *ntf_info;
> +	unsigned int ntf_info_size;
> +};

...

> +/**
> + * ynl_has_ntf() - check if socket has *parsed* notifications
> + * Note that this does not take into account notifications sitting
> + * in netlink socket, just the notifications which have already been
> + * read and parsed (e.g. during a ynl_ntf_check() call).

And the parameter of this function here.

> + */
> +static inline bool ynl_has_ntf(struct ynl_sock *ys)
> +{
> +	return ys->ntf_last_next != &ys->ntf_first;
> +}

...

