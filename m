Return-Path: <netdev+bounces-5644-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EF93A7124F4
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 12:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9F4621C2102F
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 10:40:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A42C742C8;
	Fri, 26 May 2023 10:40:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 489AF8BE0
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 10:40:40 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E7F19C
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 03:40:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oMfmphZAKTEfrF5/W/G7E472f+x+IwLfp4IpaQBPJ2r8rH1Xgu7fwqhaHAo16H7WRUWNjb4lGuXzprjeZjuZfiuNDf5z5AK0qI4VB5Fo2TWn9C4QUXuteAjTMYDOLZyHXWnZCBK+AXtYH6a8aeb0zzgYNCYtHUwOu9q28Xm/LdlEEO2iIrUbP2h8fttSQ1jMs49PAkRJTuSI+uPiuhE1oVBcDg5c0MNzvGdOedB2viQdNBUjSknYxBOAFpRr1VDCt5srffiOPswO/F7UY/lHFAomxh7aOY2ZSaYakqRTINjUJlcxnphRIh06UnIpmt5HqdpoOuFPFLI0P8aV71cBSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qUnxgcYOaQdUojdakg1JCN11y1uegA5UBJXgrISNzBk=;
 b=fBoP/MgJPjNDe8BPRKCIL56U+b5hPy+hw50wez4BypZoCkP06uu+t8zUK3gjm5MxN7RpKNk+VW/39Bcsu/El4IzCifXS/5twQKohXOe1qvnfkOG81QweY3zpcLWa25krxwAXMWpRXqpbYPurEs/Wt0GU7355KmiPeByfA4w53teu6xQoXmehqcg+wiIOpDpbo/8D9UrTpqKaYCy1HdzVjhTMlkpdaD1W4R21Sln0pUbQwWQ2asylKdHGHoPvlEScMg16nBI8JWm9NkHgHfwkEndnX+McCnGJe1+2wJfuXBVODeyP+f7h3kEVBjXbOaC3w/+Sg3cDOBQlKUiExTFb3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qUnxgcYOaQdUojdakg1JCN11y1uegA5UBJXgrISNzBk=;
 b=NJ+ckP6aeH5VcvBEHJ63UHPyw9iUGWJizWv/qvZgFQMB6weg2cAWqgiJAmzrtuZ/JVp21Ptw96veLcefhAiegXIvUIww+tiP/L4KvxPH+VG/B5OztFNpGX+iW6rDVlt74X0qDnWfANskDc+/JpNlvqPZEeJP2XUNFjxpnO1Zg70=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by SA1PR13MB5465.namprd13.prod.outlook.com (2603:10b6:806:230::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.15; Fri, 26 May
 2023 10:40:26 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.017; Fri, 26 May 2023
 10:40:25 +0000
Date: Fri, 26 May 2023 12:40:18 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>, Thomas Graf <tgraf@infradead.org>,
	Alexander Duyck <alexanderduyck@fb.com>
Subject: Re: [PATCH net 1/3] rtnetlink: move validate_linkmsg into
 rtnl_create_link
Message-ID: <ZHCMksmHg5nk0ULX@corigine.com>
References: <cover.1685051273.git.lucien.xin@gmail.com>
 <7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fde1eac7583cc93bc5b1cb3b386c522b32a94c9.1685051273.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM9P195CA0009.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:20b:21f::14) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|SA1PR13MB5465:EE_
X-MS-Office365-Filtering-Correlation-Id: b64b8354-95eb-4e87-fff4-08db5dd59d5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	M55cHmxdJnQ3zXNIXQu4UVl0fEUlNSzJOqSbdJUCgYryHSXaiHhhFvvOQmcGBfKuVQDEd5sYcGTYAf8+6/mPuAMxKuIFot38lXERInszMOL5iPIoKncdYtpAhNLG5MzItfp+6q03+lvaWmzjRxpsyqWdvJbr07bm4Bn5ow9/k5Rk3jddFns07Aq04cKx+QHBrlNahjKxOMdMydJBGPenFTgGMjTgQBz1sfv7eHLKHiG2wExC4hHrezAdR2TtKk7izeHTtB0bG7Zo6bX1TgAVNQysUUCp90s6Ac+9Z/k/PToaZMJG2DBmOTPri0eYJ44FB50skBqjDtx4dhBmJILGISD1NTESJ1Na1zA/PpONGUkhItdgfVctfZC1XFSKTy7xebDEH9ZKN0notwRtE1rOJbtopn7eEdSkbPVpXHthBTc5Og0QQZZ/rJ7ajYDMVan8RB6wYgCcOkl1YQ9XGSUHoR9/hpgODttpF+JUBtJ8pU/KGIu0M+/SsVykOoTkT1RGIwRp5e5E2GAHKeCpo0fu1ZXuuLiivC4zqWwSfDuHWP7LbAwdba/MSy+ueUmBxZH+
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(366004)(136003)(376002)(346002)(451199021)(66946007)(6916009)(66476007)(4326008)(66556008)(36756003)(8936002)(8676002)(5660300002)(44832011)(316002)(54906003)(478600001)(6486002)(41300700001)(6666004)(38100700002)(6512007)(4744005)(186003)(2906002)(83380400001)(6506007)(15650500001)(86362001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ZWmPMlKCFgd15jFq8lNQzImusDzDj12+mTk1BYYq5JPhmds29tMkMzbKHIGG?=
 =?us-ascii?Q?I5LtdppdPJ1NTrfoF4W2eVhs+OniMnW4pWGjTt6esUqLvi+kp4w5+K+sMIyA?=
 =?us-ascii?Q?mx/F/EOBFtFzLrhCRSjW4b3+dBgKCNF8p495lyDq8Av7w+X/SiIfaf26bycy?=
 =?us-ascii?Q?9GZA9Q/71xrseqBiqxAc4Z6+Ul4VKMjdqUF3WIWoZJShWTnSKGvXO1JZIHY2?=
 =?us-ascii?Q?GTG0Hrxx/GZd7jeBe3G0+aMn+XwCV29otzghAa6rsRtzKpYAQwdS0ixSRiQO?=
 =?us-ascii?Q?mJxuCOAuCOFG629jgiJei/BXiwCocb9HgxQ23c3g837VVvSj6H5ytxPtsUGK?=
 =?us-ascii?Q?ZFUj7sv/Dp/Hj+HJoLaK8tT96S7f2DlTwaWxj94VtsImto6EsnncTZXqJjaT?=
 =?us-ascii?Q?HO5mEZDPNaP6qkd+cRiIQ+s4qUCdEKXMFETZH6qaW60nbH9Hdkqv4aUqbxJH?=
 =?us-ascii?Q?j730/J2t4+dR4r+CV5V9rMufK2HmhfZeDaN48VMFEnI02JoSkYN/OkLBdsSb?=
 =?us-ascii?Q?pqzZgTEWnGm0iN4T25QS3pE9Mjn/R5mVpv4SNoTfFMMBYXBDpYRnwY9r5KPZ?=
 =?us-ascii?Q?OUcYFo9hE6RStxqcTUlwT5iQlKvcL6R1LSjp/9ywpjY193XnBpGBsUwjIdVV?=
 =?us-ascii?Q?JzWQ3iK3MwSRfQblcWoaQXGrjswDO0VBQ01he0xYMsiXrWkSuezKxBUEbdxX?=
 =?us-ascii?Q?1mqv9MiEqrr63qtOnl3NmRnYv88FPRzx6fGLySsSfT157x8/Op2AkSVlMkww?=
 =?us-ascii?Q?D4q4UMH392O2FxIKAvZdxWSB4DU/7j1gzJPUDai7H2uyoddjStEtSrsFqbjM?=
 =?us-ascii?Q?yns5juMO7P3sz1yaUmaMvhro5KYZ1NNWVwC40EXneABaDPYjx5kTlkDCSOSC?=
 =?us-ascii?Q?XMHNrot3ZaLOVIEqYUAPgUMwnKrYybyULDs+ADcaeah30AAVxPr2QtDbevN9?=
 =?us-ascii?Q?eLPTZYYP4nezhBhXVPQ6mn2f98//AsFzJjSf5+RqMmZvMdNWYRsPC3hSs5OX?=
 =?us-ascii?Q?iTuvlZfnZj5oXeHszKw3UmL3y5qIRBlTjX1KTscv5BS/2tHQQ1jisDTpmEGR?=
 =?us-ascii?Q?o55M/qPM9mIV/SNnEkF1zhuTM3yXCOnn5qf8JwAflDZlTrDVQiEhlwTwA2Uq?=
 =?us-ascii?Q?fF6/K1JnOSQOFL7zqkJjsInF8odMmClv2jwqsVVsvU0Fjy07/+LzvjjPIgEN?=
 =?us-ascii?Q?QbHdYDU2TVCypYPt1Or4XX7GBpMxd7K3t7yJUDNjSIIkLIXgVw6Tj33iUQI/?=
 =?us-ascii?Q?JFuUXGxktIefo13pOwhUckNKN7dDiL2TcUMBgTytFtRG8CguOfrfeT9GRids?=
 =?us-ascii?Q?vJzsZy7GWklYbv8L63A4YNw7w1ejDcuV8BriVjDh5/0WO9YCeVaOPorhdX5J?=
 =?us-ascii?Q?ASP3Y5qywksOiZbRlEfPv1CLiM9veHeiD/9KPADZF+eaQ9S9mI9Z83dobrBu?=
 =?us-ascii?Q?l0lsTh78H3XIVD7EZK2YX5qcuzaZ/iuUZ+sL2NS+4bm8TsdWxRz9oNYqffqy?=
 =?us-ascii?Q?WQcJ5v7vCA8b3WDcYNt0xOIpwAa3T9qI+zAYqoMG+XoTxafwqvItHAqGgcSj?=
 =?us-ascii?Q?75qjXZDHhQrf7X/7bZIED/QNHqtvkYQ1y2ryUqVaz/Qe+2/E8hzETdjnSyR3?=
 =?us-ascii?Q?9dvV6GgnbPbaosPtZKcamIMuJ8urcXxTAtRxCLGbAGvgjNvet7QnbYguW31U?=
 =?us-ascii?Q?6uPzng=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b64b8354-95eb-4e87-fff4-08db5dd59d5b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2023 10:40:25.4440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4RswVn+Y6etyWyCBCvPAivv1hVMIzhXFjRus3anKjcH7rKj9oUUi9fbkhWW1Uvc8Wbfx7+DBq7vOsw9JzJ1PMESScmN+IBRBk2OaEuMY1hA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR13MB5465
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, May 25, 2023 at 05:49:15PM -0400, Xin Long wrote:
> In commit 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()"),
> it moved validate_linkmsg() from rtnl_setlink() to do_setlink(). However,
> as validate_linkmsg() is also called in __rtnl_newlink(), it caused
> validate_linkmsg() being called twice when running 'ip link set'.
> 
> The validate_linkmsg() was introduced by commit 1840bb13c22f5b ("[RTNL]:
> Validate hardware and broadcast address attribute for RTM_NEWLINK") for
> existing links. After adding it in do_setlink(), there's no need to call
> it in __rtnl_newlink().
> 
> Instead of deleting it from __rtnl_newlink(), this patch moves it to
> rtnl_create_link() to fix the missing validation for the new created
> links.
> 
> Fixes: 644c7eebbfd5 ("rtnetlink: validate attributes in do_setlink()")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


