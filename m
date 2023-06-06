Return-Path: <netdev+bounces-8355-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 23395723CB5
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 11:13:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 894C61C20E60
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:13:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A12E290F6;
	Tue,  6 Jun 2023 09:13:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 588D3125C0
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 09:13:06 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2139.outbound.protection.outlook.com [40.107.237.139])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8718510C4
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 02:12:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jFqzqZbUG1zlYvihIkDE28+URIslWq9zlUqPuG/pAJ/N79ue1lAPJgfc612z0Qnefc1qJhr5j60+1MqG/JbATDvZUBTKAN1XX0hPL85guKHR+l7IqLSjMSm7CAX904WowgTGoVKA7owyC2OBVdxy9S/eEqi40r9ivvRNOktSh7Ihplb+kz4lgQu6xdt/AMVNc3BYr8AhuwD/cmdFthASPc+CP+YJtejbu+BrhICYzQ47YeVARaN9vgnmc/TIzUgBPeEN16uPIOKB2iP64jtdkmUW8gpfCpY8vUfPvW7RsS8wseJX9Op9xfV/dU8032vKGZLPauLk5cLXkInK+wcMgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aUhe9iULvc00/8W5NNykb8vhjr1f/vmdWtcMYrP6+II=;
 b=WpyWIFzP947SKLXMIxaoQdNl2GHkUx1KpxpTDZjdeTug4lVMNggo0u78RZXnBE6ULNuP3W1EgFM1WmyPjmIuM52q8GijJQDBHNo0pV+B4AsyfW/LEax3Ifupz7De76lNJJ4o8uh7A5KuJH0o74Hrbx6jocWvNLTrzgrKBzEvCy6R0Kjz2PzXMfOb1boKs2dy1iXiiX3HyqG34KNGC9b35ixI/9wQmTnKhfhwkh5pTsCptl6pu1oeRcrJWjZabDqY53MxkWs+9U/khuSCMtJQC9XFOpgRzVmK5JJo7XQnb4WLD/Adne9RnvSMoGzjHSB+tP+QiekObeSqciv6iwV5KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aUhe9iULvc00/8W5NNykb8vhjr1f/vmdWtcMYrP6+II=;
 b=vYgKG9HcCCAKRnG11VQvgGbCE+w3z5L4SHOkWfI45x/nPgPBX9VWJxBQyvya69UQpD77KZAnd4P83cv8C/+ZHpLvWBRSaz6kniybtBfspwZhR38ermxrVMRHN4c6rBuhwPIJNBsx6dWFIJTZlHnsrgwWqXMWaPOYtqRxMBKVrmk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH7PR13MB6366.namprd13.prod.outlook.com (2603:10b6:510:2f8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.19; Tue, 6 Jun
 2023 09:12:55 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6455.030; Tue, 6 Jun 2023
 09:12:55 +0000
Date: Tue, 6 Jun 2023 11:12:48 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Leon Romanovsky <leon@kernel.org>
Cc: Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leonro@nvidia.com>,
	Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
	Paolo Abeni <pabeni@redhat.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Raed Salem <raeds@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH net 3/4] net/mlx5e: Drop XFRM state lock when modifying
 flow steering
Message-ID: <ZH74kFXcey96w9/7@corigine.com>
References: <cover.1685950599.git.leonro@nvidia.com>
 <63612a659fe38ec043f2f791acb95ab3134e577d.1685950599.git.leonro@nvidia.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63612a659fe38ec043f2f791acb95ab3134e577d.1685950599.git.leonro@nvidia.com>
X-ClientProxiedBy: AM0PR06CA0118.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::23) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|PH7PR13MB6366:EE_
X-MS-Office365-Filtering-Correlation-Id: 142e5c13-50b9-4e25-66ae-08db666e365e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	fc2G2BhztAju2cN/GuKRrk/r0PENKC85c3cjP7pKRFLb7f4aIuJCYmoxa89DGBtgO9MJRFvRmvS6mbTXkbNXDYIdw4GjFYJlMhwx7Dz+ZAwAUzl0Ju0fvBA0nHG52m/uxKCfwag3cr5Zjo2uZdPFvEZcTc/JJoG3jhLVjAffdt8ieE/1Ylsuh9WsxJGhHp2iruvjJ6W3+jrCpLLoH/jKN8Psu5BnkbmSITxOjnmxxWJ3e145PnPxrbqRsp9zfxgh6kOXIzAhq5ouBkhIxiIiz+4/UCAroADo7r5c+eq1pFOsI6Y53octaJzmbpCUoSGE6ZiFgBhPgun2Eax72SwS7eYMbIAaiQ5u9wDjWV0eDNClxiR9uDk2+zCcnXkngFx0xjKvratJYnR/8nIof5v0amt0aViqz2waE9m9MS1EZucmMcMUQqOBNi57/NEJSmli4+bO2S95GdrVG1e500WQNz8NRcKUYFVOMSGe+Jr5Jn6hprIig59uFNkMFe1hlSwFmvYTIphAcwjjzr5Vqf+gePXV82glfsRPZqyrC5LT9aTFqRYFQfhqMYrMuZkCxhTPrwSxmMTv5KzZxP66veElLpovPrItjE2hVHSKmfT7Oc8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(376002)(366004)(396003)(346002)(136003)(451199021)(6486002)(6666004)(2906002)(4744005)(66946007)(66556008)(66476007)(54906003)(44832011)(38100700002)(5660300002)(8936002)(36756003)(7416002)(86362001)(8676002)(41300700001)(6916009)(4326008)(316002)(478600001)(2616005)(6512007)(6506007)(186003)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2a3As6d0eUWQmMSGPolLtGbjbjSRJHmwXd/DmZKC/r/ZYptp47Dt+Y1fTBxH?=
 =?us-ascii?Q?1EoPwCZ9PhlORbBNzlWglAtpPJKLbHTbaBL6eYDNKdglG4yacA4HGbFnXhC1?=
 =?us-ascii?Q?cEKD9fws3nSvZG6jXqO8xpi0Kwy/O0L8+nScQw7w2a2USrhoDbxNXQOQuL+q?=
 =?us-ascii?Q?JlC5MdR+eP2AsKVzgkwdCkxUSNzW1vUR3VmAzVnkG8vyiLCeXal9+6/x2gXJ?=
 =?us-ascii?Q?lH4/+WMBPesPdUNm+HMW/m9Y34Zeyd30teNW9yVooSbEIv4lnyejH0k3SbPy?=
 =?us-ascii?Q?NH2eZmMWkD+pR7IXFJF2Ajh/kweYNGaIo6GskKsWZw1wkGc5/ZcFcNrTg+G/?=
 =?us-ascii?Q?hOJgoDOuEHwfFEwAFfcoZVFyQNDMYs3if22jZK/NrHu9rlmo5tJf1E2a9/Ji?=
 =?us-ascii?Q?srcyWIvIXhyNc5kwFoKbaIpOGiY2sV5u2tLnv0rRzx4pXslo/3q0Hl2s52K9?=
 =?us-ascii?Q?TUCpbFq56h7KUK+2NDRDWUcTA4PMLlC/7Gderc4meG4ImdDKdimy/F7UWe1X?=
 =?us-ascii?Q?4RqPkx6zo5K41+zazx7DGIlHh0r5tbFqNL1/9jsmwIoPREeNAlP5ALma8g+J?=
 =?us-ascii?Q?KcKkQZE03s5P5wDAyoeIi2OlIhOO5keiiAgy1leJv/tazQxGu2K4l+C8g69P?=
 =?us-ascii?Q?buXxSF/gjemCdB7z+K1umiQC7RZrMeye+FdhRti6L4XkUXogwuo9QsVeiz2B?=
 =?us-ascii?Q?7upSecD2dw3fzzmD/mZmdJ39pSW6m/jYkf5pjXwBF93U6lVdMT6LdeZz8NP5?=
 =?us-ascii?Q?sOK4nV93Gge2l7c+hQcgYIJMctjROReIMnrAALzgNVg5hrLIcTM0h+b27bKP?=
 =?us-ascii?Q?O0+bKYkooM95VIFmDFFo/CTehNT8/2K2LV1pqcIhkZzXZQO+l6koIytHgwoH?=
 =?us-ascii?Q?U25vy73tcXILBkkRR/SbAFbsXsV2ZsRurllUzOmmyveXED9iFfxSbIlWPbVL?=
 =?us-ascii?Q?7+CcsP/TGk/XmMJ5R6GdJ+LJtoRZBMYkmm+UccpxYFFFODil1QBE/4GRO9MI?=
 =?us-ascii?Q?/pN4YQrMqIigOCokHywUdpzdf+26MGbKo6i9R31kpucAYHHpN8QFsFz2i/fO?=
 =?us-ascii?Q?LmGE8v4FMpZ3bu9s4qxDmfpzniwWogCabiXlFralH7aFbpMWNV8omqpoBdiA?=
 =?us-ascii?Q?R6866MVR3Q+ZEhKgz/EyiHNzLOXkxmwkTp2KYCr5fPE1IKo7ZW7VAhKx97Cx?=
 =?us-ascii?Q?+EI0kpCRrIMpNs745p4wbqvm1gHCBbvXTh2swyFNHCbWnKfFqXAnMWNrO0+r?=
 =?us-ascii?Q?jnHwHnwI6Yfhfa9UUFd3L/HGQ71o586PAvLXJsRHP52lqPPrHvMpPPB6R1C6?=
 =?us-ascii?Q?ffTk3AfmsBVCkyjSiCots/RhzTPx+fXX2gz2DRhBisldu1xi0aEldszB7z/6?=
 =?us-ascii?Q?wb2tqw0XNMtrax4TriX/QNmwpKkmk6SQLIl06zE9fPqAA3FmTFkMgzvA/GlZ?=
 =?us-ascii?Q?Q5giwYCR7491UkKBVEWBy55v9hkygSl0b+uOdEga5nNd9T/lDqYVfB4EQHi3?=
 =?us-ascii?Q?VEJjaDOoMlCMWTKoY7+WpSaQtdtMdZlv3MQ+k7v90ZwlSfZhWMiLuRSMNgqQ?=
 =?us-ascii?Q?qerFupGPletmO4wmwm9+pg4SUYb/boW77JMbDPMzAbcFQe+ho9yUf2o2u/T5?=
 =?us-ascii?Q?I4NAJZLLk0vx8SVzOk4tAZpMVHOc/NQ/n7ZV9P71b+zqwem/9SwybfuG6uN6?=
 =?us-ascii?Q?KDkR8A=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 142e5c13-50b9-4e25-66ae-08db666e365e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jun 2023 09:12:54.9577
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /zn3GU3aO6SP/GNn1jbFBeNQsDR/dWHKOiq46Yku0nys/Fl8x+njHWIHVBg6f/jsttER4Ai1cNAxqxQBXj0Rnx3SK+DeP2eq9oZUbcGQ6sk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR13MB6366
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 05, 2023 at 11:09:51AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> XFRM state which is changed to be XFRM_STATE_EXPIRED doesn't really
> need to hold lock while modifying flow steering rules to drop traffic.
> 
> That state can be deleted only and as such mlx5e_ipsec_handle_tx_limit()
> work will be canceled anyway and won't run in parallel.
> 
> Fixes: b2f7b01d36a9 ("net/mlx5e: Simulate missing IPsec TX limits hardware functionality")
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


