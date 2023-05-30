Return-Path: <netdev+bounces-6265-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E4C97156E7
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 09:36:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4A326281069
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:36:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6EE511CA2;
	Tue, 30 May 2023 07:36:43 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A576B107BD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 07:36:43 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2105.outbound.protection.outlook.com [40.107.93.105])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3317AA7;
	Tue, 30 May 2023 00:36:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bz2r9ELggCDoNW83Gm2n7+5E8/RMiDbQC9c0y7FxghkE56lIwYUaXJtdBN9Ni0uwQhazOPNlfm+QZZ3dimhtGdbZMQPsIYy8J3n3Af3Gvzbv6jCw2ZhzR5S0UCTDY24UHA1Y4KFK0OSNA/EryzkExWJ/tUjKQdLwvFKF4fKxKPf/eLeP7yX5Rq3diQetUkcjePhYE4Q8Fyt8bRBmVwtUGxLEtgExUXDP/0gJwDTUJP9YLTkVDklnMmYPT7g1om9FNV6fozHVerqeUNh2hclv0sifh+tTw/pOIqA51SYeOHnt7v0IRe+MssNIBDmpZ3QY+b63yLFkYYTgFeLBbglYnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0SLmHgOiiV180OOREp6QE0i57c4VM61vRoYjc3e9q0U=;
 b=cXLBv/3KNCH/IZnY79GXfymh+tf1xssx0QMjL6ho3FAWu4y/Kay7YWTUZSd8u06yTXSaoIEqIwA4Pq0b0Nq0xZauPBO5IkSAsQ3DtLKpgRVW1LbkjAf0Adu9qx1/PAztkprEJ6hAcKFtW57FlCnrBUwkrFxiX5XGPEv4/DeIM5ts/xGuW3DelZ+uYDbjCSX8y9+TAMS49z4OBC0BFOg9iQlDGbMeULgWsX0MyUtqPoxdacKkkUbBHpU8Pl2EFDnBks5OFgDZi2YS/8nncwvJ7CNsCBXXBJeNCA/73ylAFO89KCkL+PUIrsLBIKVZ2aKQNIq3MbVZ8FDnI7qNHZaCsg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0SLmHgOiiV180OOREp6QE0i57c4VM61vRoYjc3e9q0U=;
 b=T72aGu+OWeYDgmqMqaFtuFqpX5hjO/a0JSFTG5RWEz6lpiwPBowIGqtZz7i+nAIwWPYYOTq5z2RyVrBt78BwPT9ik6rhv6I3+H5wQvXLjWUxLp76hnA1PxsIbC+R/jBvCF9qMRCwBVnOqY7KoYREpOdZN+Z84Md/xxoebCt2acc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by CO6PR13MB6046.namprd13.prod.outlook.com (2603:10b6:303:14d::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.23; Tue, 30 May
 2023 07:36:36 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.022; Tue, 30 May 2023
 07:36:36 +0000
Date: Tue, 30 May 2023 09:36:30 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Marek Vasut <marex@denx.de>
Cc: linux-wireless@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Jilin Yuan <yuanjilin@cdjrlc.com>,
	Kalle Valo <kvalo@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH] wifi: rsi: Do not configure WoWlan in shutdown hook if
 not enabled
Message-ID: <ZHWnfhh26QVBZxi5@corigine.com>
References: <20230527222833.273741-1-marex@denx.de>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230527222833.273741-1-marex@denx.de>
X-ClientProxiedBy: AS4PR09CA0003.eurprd09.prod.outlook.com
 (2603:10a6:20b:5e0::6) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|CO6PR13MB6046:EE_
X-MS-Office365-Filtering-Correlation-Id: c8d9e3ea-5e48-4f46-f0f7-08db60e0991d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	W0QkGDUa/ANQcDAL0y1WzUkDGJEyMy0GHqbrlgXq0r12urEG73cLc3p2QWoH06UtG2XMEODvg37j+Phb3P9bh5mi/TCEH12et5ZpZDtaIHu1U7+G++ncG/5pLgZqt0oGeAmqnjNszhFgosy4gSwGJ1dXu4zsKKMMW6NaJzd05lR+YxuAlVL3EJyPffX34eiNT22KkfFETzAowZmrXb9ayNxmF2FiUCLKc0hRS+LTjFltACyOYoDF4FKSf95XBuDZDmF8lTPa0BXV84wg+8f4ZoqB5eKdYtG5ZBp3ZkZHN+lAPUVnGE4BX9uGtt3EFrxAu/vxHtAMLLsYBwl5G1i+nN1GxiIzzo5LNcuSgSlPxumhuPvc8nzYj7gbDdNa3XJY3LVoSTk83U1rElB5tne1Yqb4umDCqqglD520PkH17r6tY/eVXQZIgQKRCCb+65YxZtRtPkj7AkXLnU6EybeZUB0scjHyTBnXI4ku3HHK9jbsj5gf1SAN00KoxMAEGCUYSivQ8iD1ygJ0XOd7L+0smBx6xSKICk8G1OjnYHdZQ+z4XlLEW4WEltxI8/im4UKv
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(6029001)(4636009)(396003)(39830400003)(366004)(376002)(136003)(346002)(451199021)(6512007)(6506007)(4744005)(186003)(2616005)(2906002)(54906003)(478600001)(44832011)(83380400001)(8676002)(38100700002)(41300700001)(8936002)(6486002)(6666004)(66946007)(5660300002)(66476007)(66556008)(316002)(86362001)(36756003)(4326008)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?u/itf5AbA3ID1BM01QrdbBay6pgtHGaXDfhmG7yD0PCUY/s8VVlgxsKYtqHs?=
 =?us-ascii?Q?932WudgTGfCC0S2xdDjkWt3o5zJqT9VNRPLiO5F6AsxVxHS6oktQ8DN2/9Gu?=
 =?us-ascii?Q?km2o6OUyutmftduxpdD1GLOQ3Cl/P6KMfO25XKOtITPdMc4FhMqS8KcCsSok?=
 =?us-ascii?Q?FJMqERJS77se44mP8D9ivKbBqMyZUMXIYvC8Ddh1369cp2jt8/nVHZNVqKYX?=
 =?us-ascii?Q?OXN0BxCKjztyArO1/681+WgikZEw6Fv+23KLNbcxkzwpbRDzANIElRpFSlrr?=
 =?us-ascii?Q?0plLhwLYWupAMP6vdaHMfBzaR2ZLsc9uWC9H6rL7XW53XNn+bNz5fruY5gss?=
 =?us-ascii?Q?wg7nVrmAeoWhx9zLNtIM27bvCjV0EqNw4OP/sR/myO7p4oP8EslV1TbN0cpQ?=
 =?us-ascii?Q?NEuFGQ+m73+pfUjE4sm785nxiVaooLfek82QzWz5cr4dXsNdXDhsn5YwekhU?=
 =?us-ascii?Q?3OLyoTx3IOrxNbUse6kqjIEXkcf2FqP1n6VO5YCBQpUAwPq1Gw+jxwf+5A42?=
 =?us-ascii?Q?wX0kideCPgvjgK3pLrhCzdU6cjRnCXgz7DV7UOYwIHP6IFpfIRjik8Mg6w/+?=
 =?us-ascii?Q?xu1eailgj+lIUs9f1zt2r1ve2ARTU8Vb9HaxsYEKthCSnty3OmcCMf7hjUL5?=
 =?us-ascii?Q?A44scPMMZzr/ro/m42eeN9hFpiuLKzMlEAKfUo4g0NU0wmiZUZX5RxOaPxI1?=
 =?us-ascii?Q?DHqodSlOG58EMOjis8Uq8Ux91Fgw+tPBb4MGgnuAmSGxwRgXinNem6+I2Mmy?=
 =?us-ascii?Q?m8irUFi3xYreTJhiZ0vHYHirKf8NC5x+z9x8RfwDg1jeu1WoX1m8XTTro/Rr?=
 =?us-ascii?Q?oGqvXqhV6GUrp/AVwdOKH/jvzfVokS3UsXC4NroQtlyWzZOzazdOQEJyN68l?=
 =?us-ascii?Q?a/cv/h2ZvzdLDER1dZbp6V+lZtVtPMQJB3BTZLq2J/9JEIwRb/aNXtFWMjXt?=
 =?us-ascii?Q?yqS+N7MqhAFqSPHfdWf0LDJYaZ0ed0zHKONFZlO1fg7TFCslouilsaT0GqyE?=
 =?us-ascii?Q?zTqSwnrWD550V3QhkT+bHRHvZrQ6ZtgbJh+zk2WSjx+dreFaw4aHHvdeB5ci?=
 =?us-ascii?Q?oE7mPEOnTeBLK3IV3e+LfdjTnRlQDwisPKkCQzqEaedhRe57+GLQzQCdn5xa?=
 =?us-ascii?Q?yDxKdP+DrUrX9RDdDyDuZ9kT+Soh06BRZCaAOOsjAHnqpmCoeUGGcb0XJiWt?=
 =?us-ascii?Q?0VnTVVjjYhfhzVn9IGoAF9gaqBhQMhg66EHhUxxeguFbCdIil9qpTzMZo0s4?=
 =?us-ascii?Q?Dhf1P6gpCGZ9vb/l7oGjI3+dPLblY10NTD4ua3ba0qq6FhPUDNJ2InvYpW6O?=
 =?us-ascii?Q?H+Ucl308odiezU85HtSSqoEleGzEVBPkTkOyMgUtq+/UAB5Jj9VfBiNmRQfV?=
 =?us-ascii?Q?dw+ycqT7hVtW6aK/c/wVkzNg3ehzuDXUpO6tjVD25WUZhJyfsaLTO3mNdYxp?=
 =?us-ascii?Q?Te8XRx+Bcm5rnRYwmOH/U0dcxWlsQButPbdEfUWYSl9/TAwwXvTMJgq/E1Ys?=
 =?us-ascii?Q?cuPoWvNuLQF4of/ANKb1a2jIHaSiN6GC1RJOlzYVWl9w89m/9vxrX0j9xPyN?=
 =?us-ascii?Q?Ps6MfakemwUubORAb8+JfqMCZjeRL1t521C9MDdjHuRcfraGgd4OabnEbC/V?=
 =?us-ascii?Q?ZISeuPENBrqtfrebbMuOMCd1PWLix/hEdsFibPsOSfk76f7N+3Z9To08SH+/?=
 =?us-ascii?Q?fn+pMA=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8d9e3ea-5e48-4f46-f0f7-08db60e0991d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 May 2023 07:36:36.2129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3eVPuQ3rC/SY3mIoKF+kMQLY5GTR2/uN/aR4queJfxEFiVn8FF0kxLW88nAPxH1GyCoQxYAe3laR9KeJaPHXX3hAckL5rWKnxIZf5TmjQS8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB6046
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sun, May 28, 2023 at 12:28:33AM +0200, Marek Vasut wrote:
> In case WoWlan was never configured during the operation of the system,
> the hw->wiphy->wowlan_config will be NULL. rsi_config_wowlan() checks
> whether wowlan_config is non-NULL and if it is not, then WARNs about it.
> The warning is valid, as during normal operation the rsi_config_wowlan()
> should only ever be called with non-NULL wowlan_config. In shutdown this
> rsi_config_wowlan() should only ever be called if WoWlan was configured
> before by the user.
> 
> Add checks for non-NULL wowlan_config into the shutdown hook. While at it,
> check whether the wiphy is also non-NULL before accessing wowlan_config .
> Drop the single-use wowlan_config variable, just inline it into function
> call.
> 
> Fixes: 16bbc3eb8372 ("rsi: fix null pointer dereference during rsi_shutdown()")

nit: no blank line here

> Signed-off-by: Marek Vasut <marex@denx.de>

Reviewed-by: Simon Horman <simon.horman@corigine.com>

