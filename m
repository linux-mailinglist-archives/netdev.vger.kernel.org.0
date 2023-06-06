Return-Path: <netdev+bounces-8523-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1E9DA724734
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 17:05:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CD9A828100C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 15:05:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA37123C6A;
	Tue,  6 Jun 2023 15:05:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1ECF37B97;
	Tue,  6 Jun 2023 15:05:16 +0000 (UTC)
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam04on2092.outbound.protection.outlook.com [40.107.102.92])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1435E90;
	Tue,  6 Jun 2023 08:05:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yw9WTUSCyAOpsGu0+TyTSR78ulp+Dv319ZDV4joHxBV8FeFEPtJM9bAwu8mj9BtcrCmFVlxMo2uIWV0rzxp9lFlvh9dlf5AQz0ISopC+/4wCk1/mL8YM7A4/1XSVXhbBRy11HMuLmgj8UkNoNSnAaco12seiSL45voKj7rDFEdJ0iti5Ur43wFLI4J1mkvjLLllIcV2C+9VLCoy68TMoIpRoiEBFNgFepUoPU7snPDQzypiJkYln0cUq9ns9tvvX3F/zXNP9P2aFVVVSuMnUcfKVzak3R2UnrqHTuv2iHgOfBhRKJgrNxJpHjSflsHJnFqyPaNRnLcMrQXwrJLdfCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PpVYCCy0ekKz08GaGgoGaDsN7OcXxAxX71r0OJpgY9g=;
 b=anCqw1UClJvkkyTQFPy6MoaHfWJqmd4+gRwqFny2U51GDj3u8FzuqwaKtSBrcXN5fEPmvsMhJEDPAwWGqMXwWyFkPA1O18CRGOZvdy0/3YxqI94pueSM2IqOi1Wx5j+NidyXq8ksh+iaG3Zo4QlLqhq8qJ9wGM7NBQCHSIy1leMfZjibYbNb3i5Jc41xerLHtU+yOgPJu3Cp9to6EYO8hcsuLfZhRpQyucuIupo66FZBsdQzw0btOX1EZntfwz0MQ8tF9d7l+8nYAGxBhOeD+0q52oATAPLNsaenC+xmFxrUuFMMCDDMcjrjfTNoOccx8joWlQa6waCjXWR/M7wG+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PpVYCCy0ekKz08GaGgoGaDsN7OcXxAxX71r0OJpgY9g=;
 b=Vq/w2oBXfjqwOO0rZPveLFtNeKKg5z5Wpimfl5av1ZFd1FptZm713hQ48ibQYWUPa9PpA52Bcy7RGTNoMLShWbO632LapCyVhYDrwDo53hs5UOLdQdpMQbHipNCFL5N2RqypeReZVgaKokeZo804EfTWRMOWopHSf3HOkQ7pSRI=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CH0PR13MB4715.namprd13.prod.outlook.com (2603:10b6:610:de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Tue, 6 Jun
 2023 15:05:10 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 15:05:10 +0000
Date: Tue, 6 Jun 2023 17:05:04 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Daniel Borkmann <borkmann@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii.nakryiko@gmail.com>, bpf@vger.kernel.org,
	netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH bpf-next V1] selftests/bpf: Fix check_mtu using wrong
 variable type
Message-ID: <ZH9LINLJm6oLS4Ys@corigine.com>
References: <168605104733.3636467.17945947801753092590.stgit@firesoul>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <168605104733.3636467.17945947801753092590.stgit@firesoul>
X-ClientProxiedBy: AM0PR06CA0088.eurprd06.prod.outlook.com
 (2603:10a6:208:fa::29) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CH0PR13MB4715:EE_
X-MS-Office365-Filtering-Correlation-Id: 0526ce93-286d-40cc-6bd1-08db669f6bf3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	t0l2TXr1ETb872WYwThfKOeXWufJTvDhixMU8+pxObv6GipQWiyRF26E4J9DVIxWrqqlwYmcaj2K6Zn4kLKF28wuDZwQsGmSzY56AEUzcvkrprOHsYNpNfFnjHqtaUooxJXpv4oa6iWmIZvjsOzz2zZW80pMIacdvKZLoQGmGV4vwGwQWGvkx4A1K+Z82bXnVMmRZLz/caS0Rqyoj7sIcNvokEZgcjAIl+1vzSU6hnQ0lBT25PrJQiT+0Bxl3D7R+yCvaSYiD1wcos8+K0nINEKZ4szxehN8y9LJWIkLjHM/AEU++JNpU2kRiO2rOFTV+tHw/k49FNjMJN9XlOKQmz63GKnRXvpYn3S/r8MbyS9OHnjmaZuQKkRNCJieHsVh/lhPs3lXaRLkk42A24y5FHn8KpYRYegPgn11XjAh+cMTyfJoTPMaVr3Ad9uYPpJk4tYTyc7pnmI+AlTLdmk4dKv6Uy2GoqxtR7po+L4hw7m1iCe5pC+nxQWBhY5vZiMnJd4TqnUTwhuvwEE3RtALgosYlTWBxBMPV7JPVMqsS5TOBmS/UuHccGBE9+IrQT/YA60DRdcjjPwbEV3yvSzyAr3Sgkk67uAP0ofYIQZj2Mw=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(376002)(39840400004)(346002)(366004)(136003)(451199021)(4744005)(2906002)(478600001)(2616005)(6512007)(186003)(6506007)(86362001)(38100700002)(6486002)(6666004)(36756003)(5660300002)(6916009)(4326008)(316002)(8676002)(8936002)(66476007)(66556008)(54906003)(66946007)(44832011)(41300700001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zYmMaV8UTLgoP0bMvspG0dJfzUvv6dpkbTf1aJ4RB8+ScvE7NP6aPMKN0t88?=
 =?us-ascii?Q?TDq3AVlec2EE3tmzzwroAdjJlOrQ9VpZUr087ODbP7JsCUgM7rZMXOtZPkkE?=
 =?us-ascii?Q?r4oMwYvOM1d7a0lDgb7HdnhMGN/Fx7gv0ObYlkKc2HXZh18gfoLzcsE1cbh7?=
 =?us-ascii?Q?ohhZpoRB37POCA+6b5czuj3RzHvY7PGhjbL1IIdL8NyLaD0bxQQ2EHOyeHhR?=
 =?us-ascii?Q?P9bnjpGDyGAHihbFcclV8Y6BQbWw3EyQvw17kLP1vJ+tZJOX+gr6n4utUhpg?=
 =?us-ascii?Q?/eg1O81bOJv8phH0xZxO7GLBNFJ7fxZEykXZthPcnap5EduszLE2TX3MrEvS?=
 =?us-ascii?Q?TX9qrnXF/Dvk2dhiMSY5UfTU+JVDAFa0wfu/IYb6unu/Yxg4KdzwysYps5rD?=
 =?us-ascii?Q?r12A2m/cazZmWgMInuWRmGQ7neZvDP26Y5Kk6ns4rSzWlaMVGKAW74NSW1OG?=
 =?us-ascii?Q?l7Ak3aVx6IL9FohniF4e++6cQPA9C4VPY5bQjKit6cjzABev0pc8J5eS/8b8?=
 =?us-ascii?Q?sIV8e6udOu4kCLvNKT5bJabZURvcw4eVdOsbgmDbJSDPa2HiJSdWjRSvoe6j?=
 =?us-ascii?Q?QX6VLkw1abgdZBDplUYj+5HNMx84gRIfKMyMPYomkMfJcf2abO5cumZoBYWP?=
 =?us-ascii?Q?MVUFQc+acFIoKAYyfjybzgpWanWRcq3a6WoZUz1K+kvlyxXIwyf0zKR4AXtO?=
 =?us-ascii?Q?ie6od6EGV+mMQzO5AzO64uq4BbYNduZS+z1A/ZeVLYm+zqT8dtCtI7s5M0C0?=
 =?us-ascii?Q?XRBkpHK+pVNBKZ93blLtxYWSR3UbGDt4glLNEYeNmhyneRRYyF/KCbj81fGD?=
 =?us-ascii?Q?7qibdpKX2ERHn92rhgWDr5Z47qlPOOge1aaU4NzAvZ6Vh54CiRIgl9RpgTTl?=
 =?us-ascii?Q?4ltUo1AUts2heJCcZepMKPLpZinSgiyKG9lQZ5ZkvvmKsW2xPXfpn+zTQhk8?=
 =?us-ascii?Q?bRL+cfH0gzBbIg7MhYuRcqoZ6xsk4RvTw8CHE/t0hqYBr3jlQaPaTHzB99T1?=
 =?us-ascii?Q?Lwew4F//9UskTj+NaZONdTsT3h3deM1Qn/ATqGuLleqevWCZQqVMXbN+r+Ls?=
 =?us-ascii?Q?lCCa5tCuR2aetHLiyUyHvaf/oD+UTJPXFju17DfLBmC3pAv8gWviL0wN7kCJ?=
 =?us-ascii?Q?ewq+6BXZ0bTyuBiMkWLqdXD3Hk8J32a5GYcM9cz2ReOhxbF7TD4/khSITi2E?=
 =?us-ascii?Q?dgzIa7Hlsdi8cvVae/UNWBE6xB8njic7oPTmzO5uh5ZtdBC0ohLnq/ldtP4z?=
 =?us-ascii?Q?sEw/dS8QEyNp3aEBMPLGv3+Jq0ZHDKXxYyRrpWYysLCzFwxrGsBqaQBYFD4x?=
 =?us-ascii?Q?hJux6hEu+M7FnjhrAnm0NHnmTlOUTMCYeq5nud2jegEe2ImACStzB4j5Vxnj?=
 =?us-ascii?Q?X0W0Vgnel94/YoGibGayogEsmwaWdc/7QuTGFM5HKtSkL05u8Hz7OLjkPHwd?=
 =?us-ascii?Q?zWVMYVH4jT8fD+ndVUYsuTFntvSlPKJSkoQyZRVKBv1nDXAU20jpC6Am06ji?=
 =?us-ascii?Q?EJ+d/XeZBN+nVlNchnjHwKz6OPXS80Zp+EXtmTwk6iCKvPORMoTBLEJBU07n?=
 =?us-ascii?Q?ocHd8nkqoG49QnCRAupYBGmHK+JbuI6m3nlQhGlhNXtbkDSvrNKJnOusio01?=
 =?us-ascii?Q?VXo+SgYw7jdJPc5RAcrvul9MQ98jxx7SBaP8K99mVutmzjNrjPvVoBLL+bsH?=
 =?us-ascii?Q?6iKd1g=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0526ce93-286d-40cc-6bd1-08db669f6bf3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 15:05:10.1782
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yt/fEutyFrXmYoyEfsMVdA9haKLJxVEQrh7O6SAjGY8eNr6HU9fUD5YgVWVIBLC9UkcOcPEKZuCZ3jNjCJwCRvjdFHAZqMJ1PM82eKD/gvk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR13MB4715
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 06, 2023 at 01:30:47PM +0200, Jesper Dangaard Brouer wrote:
> Dan Carpenter found via Smatch static checker, that unsigned
> 'mtu_lo' is never less than zero.
> 
> Variable mtu_lo should have been an 'int', because read_mtu_device_lo()
> uses minus as error indications.
> 
> Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


