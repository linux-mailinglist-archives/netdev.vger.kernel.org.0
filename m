Return-Path: <netdev+bounces-9469-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A35B729572
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 11:37:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44F75281885
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 09:37:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD04B12B8F;
	Fri,  9 Jun 2023 09:37:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A963413AC1
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:37:26 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2117.outbound.protection.outlook.com [40.107.237.117])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C9F524B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 02:37:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RbDe22iRoSKX+vkMGow1LUEWQYk6v63hJ7lnwEthMsWaubzpiBTam8NMun/m+0eOcdNivRFCIg2OGV+9Q45TnDsmkr8hKobbiw1dqBSdHjlhcZuY3ioDw/zSw8SUHxvmz9Mqp3QjK7ryfU9UbvZ8NNH3tiQda8kpsDuCsBmEHsNrPp7d1u6z6gIowjsbzsuZX1C4pobWHO9oiB54NGNd6VuxA0ltVwIBh7yuPQ4/UVCpVYQQvBkDUYyVdWSRKEvXbJbxKZPYgxH1CX4ZLsZVPEUUJf1IlbDktsLg+kxou8Ku3/NM/kmUZqh3J8W9EYQ+kO658S7ag3u1hNd+TZCWzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n5YqF5s/kOAXpi64U8RnsTTu+py7Mp9SDXpNcS1RLiw=;
 b=UtNNBq934IOqymU7pwyEfYPdKyZRumK8Bm8/ugcYrtJyk57jWdy4KmCWnqy3hvI+Gp3AIVCSDvyCDVLpVJJO3ts+IXs8EDLGD527JAfXIBgbCiCff30GphsMGTwDRBLLs3ZJeRY4i27ek7ciXdc3pR88TM9xh0Gy8qQlX4YMLQnpRC+yzQMvg7TbjfnujldJ7XebCKpbKszCcYYWlBz5NBmdm1OugBA9pRIrCbLOu7XguFRaEZIFZELsO7bMhB+koVKhatlYbiJT06oaDloON1elQ8CVugdUVOCeCn/k6dCNt1E9QnZlUjeoarH50YKpRXZeGnfzQGSwIaMa8JC3OQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n5YqF5s/kOAXpi64U8RnsTTu+py7Mp9SDXpNcS1RLiw=;
 b=rZnbtez/lH1+sAHI4vgJaEor011MoVQs1rP3bFdAaEmK37puZgNxbbzqp6h7IE5VlXmfHVHXDiWJlIL2G46B1K8wu6kECKFVlELJRUPMafa44nlxAN00Ot9pCeZtpEyqDuYeZlh+EwH0XYFLpTFoR8JjZquycEXYKuaEtVzZvcw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by DM8PR13MB5078.namprd13.prod.outlook.com (2603:10b6:8:21::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Fri, 9 Jun
 2023 09:36:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 09:36:21 +0000
Date: Fri, 9 Jun 2023 11:36:15 +0200
From: Simon Horman <simon.horman@corigine.com>
To: edward.cree@amd.com
Cc: linux-net-drivers@amd.com, davem@davemloft.net, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com,
	Edward Cree <ecree.xilinx@gmail.com>, netdev@vger.kernel.org,
	habetsm.xilinx@gmail.com
Subject: Re: [PATCH v2 net-next 6/6] sfc: generate encap headers for TC
 offload
Message-ID: <ZILyj3sr0GAbGBKM@corigine.com>
References: <cover.1686240142.git.ecree.xilinx@gmail.com>
 <ac117b151d7a47b6083b166c75cb261369dd26e4.1686240142.git.ecree.xilinx@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ac117b151d7a47b6083b166c75cb261369dd26e4.1686240142.git.ecree.xilinx@gmail.com>
X-ClientProxiedBy: AS4P192CA0046.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:658::26) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|DM8PR13MB5078:EE_
X-MS-Office365-Filtering-Correlation-Id: 9839ff87-5b68-4984-b3dd-08db68ccfc0c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	BpXY/LwdeQTGvm0RRhXKhByCGrWU+HQHx2AktecgEhELQ02vw9eakZhmFEgS7UPl5LFglPm69l9q2JBE7cEKvv8WzqRMydRf844JhNInekJ5/LOdR9ZtOkWA1Xd95mEzXabMhZ3yuBC6StBTshSBRRgdAsbeQ8YcFR5owL9t7a9usydHN717W3QiPxjXYj9vaMYmTkR7l182HGeHWFh980jb244wTciNUNRp+60Oq96ZuLyCt81Qm8w3IP42jBxdHmbiy/mVUbE3Qsc9c8L+SvhZyhpXKFtMy3+D0Lojdizugii05mmGw2z7fFXe3lBR+x93oPNhixn/lExjX4nV+SwxXvq0b/yIAkVroTBeNvOgpqhtSsSYJeRkEe45xX2WmAe+SDNftDlNkK7f1s0Cxgqatt+bgvW5QerqsqYaYEUiGaHoAOp5tpL0QbfqXDBRY2a4zrrx4HN2sJiN7vTU2v6qA87YEDDXSMkZCP99wSDujqydXnIAcIYdkERNDxq8GbCoHFdRRMcivAKB4zyIQrUYkfjQIHdO2UplcDNdv5uZxo1DewyavmBAnxMWOvFy476PL3oZZ0HtpSfCc/7q8Ny4X51wflUCr12NGicLJLo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(39830400003)(376002)(396003)(366004)(346002)(451199021)(8936002)(8676002)(44832011)(5660300002)(6666004)(4326008)(66476007)(66556008)(66946007)(38100700002)(6916009)(316002)(6486002)(36756003)(41300700001)(86362001)(478600001)(2616005)(186003)(4744005)(6506007)(6512007)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Pr9shBvASunoXFV8gRqpbOUMpLyQXwqIDjaSr0lgEQCF8L2kk31AK2utglx8?=
 =?us-ascii?Q?D2xJIYmgst8X5IiXIjV8Yoi29TZ7K+ygA/htfIo8K1anPM6ALezqGh+BBnD6?=
 =?us-ascii?Q?vCNtc8MvMxhOKbT/niFg1x2BDomZ8TaJjJrla1hnft/Oy6i+AmigfzlyDDpB?=
 =?us-ascii?Q?lGQWm+vGSdLouIuxB6XuEKdqoXQ1HaPYZHFBdN2vgA4LqnHSkO61mHVbsFMS?=
 =?us-ascii?Q?1OJxf2tP4OcHSS4tplwOkXUCcZqksNlchvYUpG4p1XUp1JCXccf6Gamg/L7A?=
 =?us-ascii?Q?2Bg41Ar3ZTQqsbk6kAPRcht5FnPc3DGoDoH/f8MUShBd3FM5vAMqTNKCNo3K?=
 =?us-ascii?Q?P5eL0PbNv2PwU73Ouf2zfqtiL/B0+FFDpxqwUDoligYo7mtz4LfFRn7DoMnr?=
 =?us-ascii?Q?dNtF/u+p4AcuW2D7X7dX9wpI6CWYIjbwadtqv8Acb9Le2qgkxxy5y4yr9oiC?=
 =?us-ascii?Q?HzC0gUeGBmtRX/MzrNzoLgVaTUYRE79wYYwdRNSbM3ykXdaI7ezMg7HbIjfE?=
 =?us-ascii?Q?u0kgtEqPF9IhyzidkNTRFSARMcKcmcn/O6moRkw2X3isIiqWdKpPLt7DZP2O?=
 =?us-ascii?Q?bDdFQgtdRlRdKqy46PjV3tAZLBxrdIu6RMWAheqo3qRZ3+bo+mbTNV2l1Zca?=
 =?us-ascii?Q?RKyx4QspHLRrmLNdZF9Fsj6voW9x0SUUFVbJ/RXbxP3INXhDgkqYsNw7Ehjz?=
 =?us-ascii?Q?Hr3YcA9HfkGr86BSRjrwvkEkaxEfy5gX1+iy9TFY8HADiDNJIzr0BQ6gz3OZ?=
 =?us-ascii?Q?9nC0PCe17SM6ZWswqugYNQMCigbMtas95kF2bksZB9/ecMbnV8yU8ZU4tawP?=
 =?us-ascii?Q?ohWUSjoW+LyPvYR77HttB1LST/jzNuOqx3f0uL9IUEOuadrvw6kXWOKWJGKB?=
 =?us-ascii?Q?a9XRP1hSKiMQ4wcQdQRBuNQl/XqabCmeBkUsliEsOqABF0YYRcr4nGt2HswW?=
 =?us-ascii?Q?DQTDGbOpnL+Ux3t/XEOCRbjZRpxVKvRpdlomd50OuP7+Rl3OS8tpXDqtfu+l?=
 =?us-ascii?Q?oR7KcDQzwzaLJnS6vSEBT+r73NxzpzMki0WJ4d29C3GO40lxLybJNR1ExVlo?=
 =?us-ascii?Q?sXZ1Sq0PR06nNn4zmWbMqBGYi+je27aAuRhu4tVMUQpFrL9kqtu5yzk79dj1?=
 =?us-ascii?Q?15pfDZUB02r73yU1gUd1AdObADNeomr5lq8ID/jY/vvk1rUxHF+iZnkPEgGC?=
 =?us-ascii?Q?zxGCdE+kcBcOtYbRgYdilcG+jmcy599jTEuZcZf5qvhDB057m/Jx3GA3nNfo?=
 =?us-ascii?Q?7vnXMQGp/XhYsotY8xhxN3PK7J7bSoP/DxNOu83sS6bgMK0tSAbrEExxmM8i?=
 =?us-ascii?Q?2AaoHGKM6sFoGY9TufZmMRD7ec/9/echKGifaGV5BDOJdpQEtnB4Dp82Y/0H?=
 =?us-ascii?Q?gJW74hU6XYSFrjq5xZuj4U8/vdxVUQb5YeXUqdni4kC4yZfcSpFO4GeIYieP?=
 =?us-ascii?Q?NVN1q07N2tCMERBt9YdV6MtPQ/jS+g7y8Vr9YObedf5bvFUzzDUsdGwygyIo?=
 =?us-ascii?Q?5c9vCy5WEKSY71DzZpODnOLNoS1/1lj6WLsMGV7yl8KAWCEQ8egYcyNvQPQK?=
 =?us-ascii?Q?aG2PBFEpyeH9PmTwB1niMkwV+ylWW4Jja9YLKqDF1QpEU9m9VNvm3TInOqUU?=
 =?us-ascii?Q?OgsjTbO1O/kGf7MnuvAiFnDjMz3GRWvlDMx/7zvDbVJa/5cSUxpODw+HiFSa?=
 =?us-ascii?Q?6Myh1w=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9839ff87-5b68-4984-b3dd-08db68ccfc0c
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jun 2023 09:36:21.5402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FwuKFSNNAEpWz8l2TqZs42ULLTalsV6whus7DK9EDDP8FMBBYFSI9MdDI2hu1IZ9+XAKA0hx37ZDKSnyGl/Th1AwcFaLZYmxZXUQzWuzv3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR13MB5078
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 08, 2023 at 05:42:35PM +0100, edward.cree@amd.com wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> Support constructing VxLAN and GENEVE headers, on either IPv4 or IPv6,
>  using the neighbouring information obtained in encap->neigh to
>  populate the Ethernet header.
> Note that the ef100 hardware does not insert UDP checksums when
>  performing encap, so for IPv6 the remote endpoint will need to be
>  configured with udp6zerocsumrx or equivalent.
> 
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


