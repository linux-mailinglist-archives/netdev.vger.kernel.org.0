Return-Path: <netdev+bounces-10626-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C65A72F73B
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 10:02:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CD9D91C20BC7
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 08:02:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA0074422;
	Wed, 14 Jun 2023 08:02:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59837F
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 08:02:41 +0000 (UTC)
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2121.outbound.protection.outlook.com [40.107.95.121])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49B73212C;
	Wed, 14 Jun 2023 01:02:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PtslUd9Yy1FKS66iYHRLTit6cEWjJZIhI8Md08FwEqSB1eH3eKbeCo7jjtGaWG3w5owiAIA/NhpffvnLaTEM3GA4q3kBngzgTevuD5nInUDmkrU4QTMlvUgUTWMn2Hq8P/ziMp6qN1l0ICed/tWpQHROunR5e2F0elNdGYWdpk9NX5ZqCdWawxs9nEyH38h1MUUSm+Trn4CaAS1gzvOXGTTeRt4JWhqF4HRFmUE4Q4YiApADiONVXOAK38KZBNwDTP+vkRDfL37bX9As7MO/rtelmOW3Me5RPOtSBotk3gGowqy9yywGmvQ3KtZCb7XZFRltQOwGDP99xtLvWiucdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+T/lNGaxOLZgDxjj9t0pyXxVCx8n/7lTYw+dQFatdVU=;
 b=HmhpRW2Y0j38L7tQVnptROJ2BrvgZE+7bmVh4rs4SXjkq8yaWHQoeyAm9vzNp9SHQaoQU8KGVWbWYPYXmc/DPIxln89dZiPuIF3WlGC2eInLH+/kgjzlbQr6Ch9GHpzzNi0JyK0ZLeIh6Lav4UIv8TYXWXSWH6YGPaBo41Syp81JmFPEYbBzgfAGUXOoHxucsHnHz9OaWo0QRj1iikey5hHSKw8fgWzOGz7Ocwj52jOdmbphckxnCya68gJ9n5jEOZN4k7w6l4q1r133h0C3Dgr6YPt0JWVkjy+nOTvdO2SL81sfXl46HLWIRu2YgExEkC7/BC0MYJTcUrbaeDEZYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+T/lNGaxOLZgDxjj9t0pyXxVCx8n/7lTYw+dQFatdVU=;
 b=s2AFqF3SaDzJTHSojK2C9XHeURecCkXK4qaao/zsdvbV+AfCoau0GcSfslchWdn3bt3koFhXmvCrRkRGbUsN987nQTdveh5Tv9UXTNiJYIy22ueVYbemgz0E6rYc+3JAVhtAxphedIbvoEUQ96opSaMsaQE/rHlsM5ff9dg9BKE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BY3PR13MB4883.namprd13.prod.outlook.com (2603:10b6:a03:357::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 08:01:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 08:01:26 +0000
Date: Wed, 14 Jun 2023 10:01:19 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ravi Gunasekaran <r-gunasekaran@ti.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
	pabeni@redhat.com, bigeasy@linutronix.de, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, rogerq@kernel.org
Subject: Re: [PATCH] net: hsr: Disable promiscuous mode in offload mode
Message-ID: <ZIlzz14DL75kcaFO@corigine.com>
References: <20230612093933.13267-1-r-gunasekaran@ti.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612093933.13267-1-r-gunasekaran@ti.com>
X-ClientProxiedBy: AS4PR10CA0006.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:5dc::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BY3PR13MB4883:EE_
X-MS-Office365-Filtering-Correlation-Id: 63496178-6e49-4ea1-a07f-08db6cad8d6a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	z+93Ujpj6+Wa3mpYcT7S+V+jsyW9T5a3HVacIKSugkGKtEH7WmOcb9ZMZhFi+3186z2cC0FwyHGmpwy+fs7ispU144AvCuwP1MzjCsJbu7RANkqLxYdvx5pYbsH7IHBuDJ8AjtTtCcn06AwsKIammiH/70aMTw2y6nIJ9g0JJchPw6d/v3uOMsV6uL0nl0fuQ4JG2A3USN4BRRsBURQnZPaiafBDx6OCMwRUCgbG8SIlk8s+BcSk0119TyVshvTpY1Xg4cYMOxVGCq+Vxs6gpB07ScPVVkGe2IMGMZF7an60yvwHRygsvkYwIyZmNR0SVou8hmwTpEVxOXIxbPGboDhWiZmeR1480zbZc9kVJ3vT7i27Uj+hWkuyKwOPlqNC2X5pFZlXncTLH2lh/mOc6ts2ORI/ywSgoLMq9tWs0nlqZEVWcXMeRQTyhEhnliDsKSbGBtHLFWB8/yY5gSDXF3KjCngRYlz6hLmwPnuPRzdLiCuggbPIh8N4znX4ynekRhwHWhia4WXAUQQ0O8JLlkB5HiI8a6nBimMT52LQoCIvkNzYC/w8OI8VZbbn76UeiFpsc7OGkSFbCYiVduvaWdx4TiDBk7jPDA3nS4FrmIo=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(346002)(136003)(366004)(39840400004)(451199021)(44832011)(6486002)(2616005)(6666004)(478600001)(186003)(6512007)(66476007)(41300700001)(8676002)(8936002)(6506007)(4744005)(36756003)(316002)(5660300002)(4326008)(66946007)(2906002)(6916009)(66556008)(38100700002)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?Yq6rVoq5PM2DNQrqI7mcDXjFORLuzGTjjzEfUCO+HNPNBUFVNGl+e+SnMh5E?=
 =?us-ascii?Q?dJYv6OnINe2ktor+pEpWD/U/ALSN8TGd9nsqZ6H+Tuj0LJRxkh4Wfvv8TU1b?=
 =?us-ascii?Q?W3OSScsig3GgM2EPTmdDt2T7NIW+ZfJ+NP4MW9ZGrvTE18cv+DHMCOpd7co4?=
 =?us-ascii?Q?mgxHVpX9Mc4bLdtWYXaYF+XJs2GMdXK/S3VySZjCbmNQoLqCd8mXH8HnUFiz?=
 =?us-ascii?Q?aT2JPMvHY7Z7oVxFdxfjSJwzls8EFq/MsL2vzPbPdwdZ67QqmrcnHsH6GN5I?=
 =?us-ascii?Q?7aq9BEDFsOVFjX3ywdCafbT73z9cm3fxD1GcWys+Dyg0RFQiJz/s8sXzB20K?=
 =?us-ascii?Q?Vif3UDRxEJT3sIjmK+NF9DZktLFR5Y7gof1nz9PLTDKHmxCw7yiJ5w9njY/Z?=
 =?us-ascii?Q?anT/5FAHXyDJubo11YMP2hA0mNpTCAvJnnT1I9Kc7IJzCeY/7Uhyubo0ob6k?=
 =?us-ascii?Q?yIN0x4H8BwFClP1qT5hkSlwd6fwySJF5RheWBH0VNY5c/s4BLXM65rYKNWhX?=
 =?us-ascii?Q?tELMrTQQL2aRXwtV3O35r1oroFVC/80OPih6xM7bzt6WI1z+l9M4sR0oEC9V?=
 =?us-ascii?Q?V4QSZjyodvfL2CL0JJt2Lmxfx72AlbQUc8cxMMtr1msWqyTgh4A8RM9Azjik?=
 =?us-ascii?Q?dKjaDNaZLyBX0/cRlIC6QAOYwfQUuyTsqf8GeEa7VqXuapIJCRYzkbxMBcqA?=
 =?us-ascii?Q?DGVQfI8omyN/E+a5WbcnnQWZmqOT4zsUgzEfjZQ8RlYJDJV83fEK95j/O6lS?=
 =?us-ascii?Q?8GGW0+4ZYsbHy5UB8zFXz8lOiYJuiii4ltNQWhP8n/u2oVUMj7LtyRWxpZ3v?=
 =?us-ascii?Q?APXavQNY8QoWxHXe7gQf8tZLO7F3OIqgwQqtIW5Jo43p+Z9VF0uPzuSf8hPs?=
 =?us-ascii?Q?MfdKEkIDXVoEYlcQzKmct5zlPMaTKKVJsXUcoQ2syHW3Oa31aAWhZP67EaEC?=
 =?us-ascii?Q?0fv1NksmHF7+zfeHXhZaZrPDJYpeJz7GYitNqhTEYwkc8e4/qRUDnyj0FvcI?=
 =?us-ascii?Q?FbKVwmjlEJHtX/yC4dB6t2gm4El9U3JUAxH+2agA58zu7uwPRJ5AVMBGogaU?=
 =?us-ascii?Q?k58vNxdjF3uIx/6k3ehCbek9+Vp8k2JdA82divXEXJNJIGK3UAxAk/pk++q7?=
 =?us-ascii?Q?bxnIEe2KlZPRW59iPHsCnntbxs4d6wGyl/lROy7W5Mqu6MDuju0fqbjbluXy?=
 =?us-ascii?Q?mCEVBaJVY2blI6DWC8BLAKtGJOc6SYAl8qxtwOSUPyn+iGB5WavzUNaJhKrB?=
 =?us-ascii?Q?8fgSoRbBsCcgE9QWZSU4VdLZ0TiDC8mgLxSQeKLylo+aRNaRVSiJ11K6/KTK?=
 =?us-ascii?Q?Hvluf8/YF+f+XlQEjULqI1mRg4c9BLRAC8V4NN6AHn4cbuUn5jLA25pN7r6i?=
 =?us-ascii?Q?6aguQfAC6zzsLODvFP3cP4xOTyAPGRXw4xZ1T3uzWFMbjZiCc10QN/9JcnNa?=
 =?us-ascii?Q?5hV8rD8Zth+p82z7I71vvygdL/3ZvNJ35sj4gcqplnIQQy/nf5VQFgePYu5s?=
 =?us-ascii?Q?yFfe7tRsbMstPVS7nHLANmeGfc7HdEB/p3etjxxn0jecf0ruy6A6dvdhUdnU?=
 =?us-ascii?Q?4QhDrb6SB5XvKeIQ1WECYNH7qfuP8lAS8qu4sifQ1Tw3OxO3QOLvx/9mX6y9?=
 =?us-ascii?Q?JpHrHd+010p3GnYC29eU6yBMsxDNeHpaFbqzDIwfOZkg0Bn7bBQeXL6qxBEH?=
 =?us-ascii?Q?Ea11vg=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63496178-6e49-4ea1-a07f-08db6cad8d6a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 08:01:26.4194
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N/x/5eorxogwltNbKuCsEO+kygpW+ocSa5+jX8RwRaa6ebxk5zmZl0HahI+WBw85doZ0idYBfZOGy2lwENS7RVg5VgiRKEwx2VcWnWXdT9A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY3PR13MB4883
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 03:09:33PM +0530, Ravi Gunasekaran wrote:
> When port-to-port forwarding for interfaces in HSR node is enabled,
> disable promiscuous mode since L2 frame forward happens at the
> offloaded hardware.
> 
> Signed-off-by: Ravi Gunasekaran <r-gunasekaran@ti.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


