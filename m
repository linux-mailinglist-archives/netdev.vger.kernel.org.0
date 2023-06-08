Return-Path: <netdev+bounces-9184-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9B147727D2A
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:49:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49E6A280D51
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:49:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7241FC2CF;
	Thu,  8 Jun 2023 10:49:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B293BA2E
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:49:30 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2121.outbound.protection.outlook.com [40.107.243.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75D122D46;
	Thu,  8 Jun 2023 03:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BDi3+bQiXUqsY9qADoug3+hxCD0apGXO0nqz2t5Gt4uLIcoW/c3GiIuV8Skrn/fNYL+6rwNAPBfQlcjqPKBD+XWL8xtOfBAqzRVrLQlTXf3uQsFEq9tDeUFMPPIo0XCwF5ZmI6dY0LbhZrw78jSQ29eEZOU2j36n5zcbqWOwUl38uOeoTjXax5ghf8hopKK6e7aamy2o0w42kE9YODhmwZJhclvQDu44ljRoviTv07qFkQBxMmX/GSISzLvLwJNdmA4V87OZ1St1sf+2OVM/ZDtZi5q1P3OhFyg+jxktlyinvSmrSI83Infs9J7CD4nodGDVznL2+P2V2tFskBM/Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q+cR2mIDvwag+qeQZBuJbI4wmjM3ho6/mkFxr6MDEDU=;
 b=Nci6Gqj4cNFCge4hDINyCMtJCjwKLLSJFVyTh007+tpSLaSjZVxkr7XzKI9ojNkfUaIdnk2zmJJSWXpAv+NJ7bgKD0fE475LxTwDKejBZLdK7/svXdaCo4+xH8DNUa+Rnz2GEvqIEnXHwiCYoqb5F2U0+j0yGntABTGk/b5LnSqGhrq4+YNGyd7mRkbtIPzT2UoyxfKPG/SOvFE5qTthQ5EqOVPERRJG42zEpaA4/5plV1mE6sgymmVeBN/+xqUklSQgcUHVC7vzf4llXJdiKDt0uCpjnlKHHnpid8dDrA3Y4S8RMyMErpeHN0g+oWNRCN6Sl0ZrFM6t4HXc1Hk4hA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q+cR2mIDvwag+qeQZBuJbI4wmjM3ho6/mkFxr6MDEDU=;
 b=Baa2nn8IAwm9zgINzssT2fJ8yLwKdCnk/QEVRbrwgCxZrqhNqM7V5OKjEXi3lChB6r6gl9QIOMLVUE+E3rXddzUCm6MIS5zl3k48BEZ248QEM2B1I940S4gmoFw5Sha2c1xdK0P3AyO2iTHFUEjrHxhS5HBYN0DCWymuM0vFqUA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB5044.namprd13.prod.outlook.com (2603:10b6:a03:362::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 10:49:21 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 10:49:21 +0000
Date: Thu, 8 Jun 2023 12:49:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ivan Mikhaylov <fr0st61te@gmail.com>
Cc: Samuel Mendoza-Jonas <sam@mendozajonas.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Vijay Khemka <vijaykhemka@fb.com>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, openbmc@lists.ozlabs.org,
	stable@vger.kernel.org, Paul Fertser <fercerpav@gmail.com>
Subject: Re: [PATCH v3 2/2] net/ncsi: change from ndo_set_mac_address to
 dev_set_mac_address
Message-ID: <ZIGyKQV2yHTa+cI4@corigine.com>
References: <20230607151742.6699-1-fr0st61te@gmail.com>
 <20230607151742.6699-3-fr0st61te@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230607151742.6699-3-fr0st61te@gmail.com>
X-ClientProxiedBy: AM0PR04CA0062.eurprd04.prod.outlook.com
 (2603:10a6:208:1::39) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB5044:EE_
X-MS-Office365-Filtering-Correlation-Id: 79de3500-5785-4ad2-eee5-08db680e03fd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	sInn21JMfzGTwvqbx/7Qx+ammILNeJNIz2BARYjDr1WAbXUpJv3/7QWvnKvbmKa/Ft6lr0MTuK2wKAJq0q8YuwJhFYuKCuzsy47hq+uOFtKQDJZtJPmzFOAWAR4OjZJImqij/lTDMXpoLu3s1YJXsBETMGEQ0mQFRrvLgDYfHDKrigC1J6+CoEa1qWpfE08g5Q8NMvZ0pTby4UJ5N3YRSGKC3ufR9WBin4lY+x7nRtINpzp8f7JUaRqpvoP8h0t5zy/YqRAZNEyGNDOUR8X9G3MYFW8eBDOloNAFlsBJrWJqbosbx3iNJbTOKMercZnqnau8uKREl+xAEZEiPu5LE2vRRm4X+yBz/wyrIzTJCyNR0hjgVXaaxjvRN7N9cJGQP8idIEmimzgEQ6PJBPRJDiuyFN5WeTC7OWR4o8NAqaCu90XZ+9+1NOc0A7ivbWzxk/z3tZIoJjWYe6UIhYVMqdCBi+tlZcgkQ3E0u9hFIwlyUeEGNUGUJUeFBNng3RTQ/FCX5kHFz+HvVS70dMpVbNYjXMK4gV0wS2q91q9dOCRpNeRpYMH2inTyIHmFoW/vT+ti7p1ENlDz2zqG+NdapOn0O0uKnry6GJrm1pYbdsc=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(366004)(376002)(39840400004)(346002)(396003)(451199021)(86362001)(4744005)(2906002)(36756003)(44832011)(7416002)(6666004)(6486002)(83380400001)(186003)(6506007)(6512007)(478600001)(54906003)(6916009)(66556008)(66476007)(316002)(66946007)(8676002)(8936002)(4326008)(38100700002)(2616005)(41300700001)(5660300002)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ptQqlahjc7Qj6HwDkA4mqSdAJJ0D46627c+TQycmPqbD4IXe/E/DFCZg/zL5?=
 =?us-ascii?Q?6qFNZZYtIpc9hKm6Ul5PkEHTeROdsNP6YHgrGcOKxlSnqVGmNaL2A4qBeN1K?=
 =?us-ascii?Q?YIpvTvyijQTaumRVsW/OAnF3qQE5yFQj+uGB5PnXAIrrT3OrZZZpNR8E/b4n?=
 =?us-ascii?Q?Vskn/n2JaVcGBvXKJclN6hnnRkCwDplLEHNqXvFXtSqSETRDbCGIykKFB7tr?=
 =?us-ascii?Q?kxeEDPWg2SIhs9QzBda7GG9C4PRrFVcYU8oeTIRo8Z6ICpa/LXMj96fxHWNm?=
 =?us-ascii?Q?9Qde0IvOOMbolZRUqGBs1vR3xdpaa6zIKx8RtJ3skAbie3ABEPch0g7bItKJ?=
 =?us-ascii?Q?7Z3CgDkrQeg5pe84aVzCSrfGwrvVuE6P4cWms7eFrQ016y06UdR7CW/WTNiN?=
 =?us-ascii?Q?twmLi39NdkSf9yq9jB4srT5dHWgbZgUktrjZzYSPqCdZ+kvEQoaTcLG6dIhN?=
 =?us-ascii?Q?0Rl2L89xZvTGWjV4SrzRBjcs0c7+KvswJpPigKQqaKBAmZYGI7xBEIkdNY6g?=
 =?us-ascii?Q?7dDMzAf2pLR3oWHDmBmehvz4f0I6YnhhG2VFhIZ1X9Gq4rY2CtqVD1gG3LRf?=
 =?us-ascii?Q?T/5gxh98rSvD5g872fescu2izKNKLgTkDriwlqk7KzfjgIj9FQY5RgI+A6Ax?=
 =?us-ascii?Q?pjhpWflUjGyuTjvNIBj7zekk4zPabHXFwmqpPGuMfvrYl+Xpvji7LZT57Y6I?=
 =?us-ascii?Q?ey5ZtUKXB+JBlEqGRhyS8n9Hj7WVags5//RSsD/E9v9WNTP0fVOl7Ab2uo7L?=
 =?us-ascii?Q?k3QJCpzvApD6NJONjWBsSPcrpQAd1lbLsit0VT7BwI4qOoFoLPBGaenq/9/i?=
 =?us-ascii?Q?dBxRD4HKymOJDf1cRLQcfuUM0rYKmVwMQ2Kd1wCjJxcmiiti9qtCyct0LB9P?=
 =?us-ascii?Q?fb22mrow+eS/FjPUPFId2F6EqnNoBbTP8dMVYjYgmsoTW+mZt2qXtJ2vLB6I?=
 =?us-ascii?Q?UF5+qg7NeXdVmImoYWRRaI/6YINWK43Do9V+YU4k78jFkoo/PDhZZHR9xmCi?=
 =?us-ascii?Q?0sh989k2bXq+JXE62qUfX+sbs2rVZeB1S+r0w8e3GURKUYGNJJUBPVmR12H0?=
 =?us-ascii?Q?AxmU1tbs0lscRTYIWGsHbV1AYNQ4cWT4kPCZVAoAzyDNNbhVVoGpv7l4N6HE?=
 =?us-ascii?Q?Hfxn2L6Jpb1L/RZ2KdbvnRzhYmfg7fuCWEh9ygwbxolkpcoYGU4X21M52zu3?=
 =?us-ascii?Q?6+cVcBL29OgYLfC3lGs0B37Jli7ujvPxR5qfOwcPmHmIvPUDiaafixmbWIZs?=
 =?us-ascii?Q?9VpESwpvrii45a2d5GAJ7xapNXVsKXIDHwi03rt6/H1He3HSxfhL18ocfpW9?=
 =?us-ascii?Q?1dq72lf9nwqIgYeEpg7C+r+viMuhXGBcQ92DcBbjpMvHXBBzRh+0QbTqln4Y?=
 =?us-ascii?Q?EqxsgxQe8Rja/iitQb/w2PT8isqnSgJw2Ikcu7AQ+ON8fcmYfTUfVppuyCyk?=
 =?us-ascii?Q?T9yd6FMnx1IvFO21ugcPYX+8uG440EHTAz3vxLGgBSJCz4TChrC9WhCUpEJT?=
 =?us-ascii?Q?uXxUSaVh97NpYU2gME8SSqlUMY3E2YGECyDN1w6zmrdatYqXyhRBg7RI4hSp?=
 =?us-ascii?Q?mFUYRcK/2jCHML4opegkJMBbI6m89YuL8trVKI73aJgIELlxq/XEAtA4zH6C?=
 =?us-ascii?Q?xD+Iz/1igHclZ4xFhvi/7XuHJs2FlfntmbrV+SIuLKnM3CGSP0XvhEO/R43u?=
 =?us-ascii?Q?azNsPg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 79de3500-5785-4ad2-eee5-08db680e03fd
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 10:49:21.1251
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qjof1PCD6X55MvolL2gvjxHxCs3BG3yq86ZImSrybrvn0j6ilT9BaF06xboTRrzsjAi0iCCSW5gtlX8OBqbvncH5rTcrVtYzen68bkJNO+Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB5044
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, Jun 07, 2023 at 06:17:42PM +0300, Ivan Mikhaylov wrote:
> Change ndo_set_mac_address to dev_set_mac_address because
> dev_set_mac_address provides a way to notify network layer about MAC
> change. In other case, services may not aware about MAC change and keep
> using old one which set from network adapter driver.
> 
> As example, DHCP client from systemd do not update MAC address without
> notification from net subsystem which leads to the problem with acquiring
> the right address from DHCP server.
> 
> Fixes: cb10c7c0dfd9e ("net/ncsi: Add NCSI Broadcom OEM command")
> Cc: stable@vger.kernel.org # v6.0+ 2f38e84 net/ncsi: make one oem_gma function for all mfr id
> Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> Signed-off-by: Ivan Mikhaylov <fr0st61te@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


