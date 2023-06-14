Return-Path: <netdev+bounces-10692-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1448172FD5D
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:49:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 11B851C20C51
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28CA88485;
	Wed, 14 Jun 2023 11:49:31 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1350179E1
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:49:30 +0000 (UTC)
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on20722.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e8a::722])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A8791FD5
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 04:49:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jcHkFYIPVaO9NgPwqRPk30cD4t9HLFDNobuQE9oytEztA67hZ2qRku8Z7hAQtsQPwzBbVeSxQ9Jfw7KtvfKsbXzQZsdz2UaCBAvdBEt3RbqkSR9Hrir4hegT4lzkbO8BjM9t627sOuSqaHDUV8eQviRdL8bA6SGp8A6L9ziDdmajXImRbXZS5JKE4z7W0Bq9WLwZbj2EXecjNXGlgiLL7QhVJcbwcJevSLElvSBuw2rBSctEF8L5w4+4mcV+U6+iFU1b9KTNLwUDJUyMsnq1e7SYPrAVy4Vd4V3lygIjgQZJrebxv65fIA575YJnedg11FJkl29mouDfu436Y577QQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kXXTRVe4XNz+8S0tHz5sl3MxVU8eNjz8fRyB/azmW5Y=;
 b=Tcu/zvF9DiA0hgAeiU0HGcJEaGv3iHvf8YlB408FIfbJpR8zXiYlJq8JvjTwncJPwaurBjI7FGYyfbwdON+TF+qTjTwtZRUEr6EDpHONK4CL+DpiyworvZurqbIeDekEgECbZiHhoH0NRVLxQLr/XxWEUFrS110FGRaJOlB3dmyq4jD8RTEiUEqlfO9xULRf8epL1LA+R97A2WKz/edYVVoEjFFhIS+MLgJI6X34FpZDjcluhITjxM/bPuMhkUeoCvtdD2zqvQHubqx7ACQncfg4GJO0gmsVZ6UjTeYEb2CA1i1xo2slU6o6rLdaVFIP5dzQu71EKD3yebeuLHaRTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kXXTRVe4XNz+8S0tHz5sl3MxVU8eNjz8fRyB/azmW5Y=;
 b=WSePB6pL2TDmh+qjBA/t8kaOwyRg9YOJnPVBSI5r8a9U+ekDZOm/0kPsUUxPz29OQrvdm29Q2kr897kvkWPWd0Y97JIt4UJ0+VOYtJjA31APUXsR9SAGB8KxhfRswN1oH7DUcY5lXnCV7M/kyyNGXCbr6DUQHtVKdpTo3sWnX5o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by BL3PR13MB5196.namprd13.prod.outlook.com (2603:10b6:208:343::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.37; Wed, 14 Jun
 2023 11:49:20 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::eb8f:e482:76e0:fe6e%4]) with mapi id 15.20.6477.028; Wed, 14 Jun 2023
 11:49:20 +0000
Date: Wed, 14 Jun 2023 13:49:13 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Xin Long <lucien.xin@gmail.com>
Cc: network dev <netdev@vger.kernel.org>, davem@davemloft.net,
	kuba@kernel.org, Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next] rtnetlink: move validate_linkmsg out of
 do_setlink
Message-ID: <ZImpOXa8A/q8eUby@corigine.com>
References: <cf2ef061e08251faf9e8be25ff0d61150c030475.1686585334.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cf2ef061e08251faf9e8be25ff0d61150c030475.1686585334.git.lucien.xin@gmail.com>
X-ClientProxiedBy: AM3PR04CA0135.eurprd04.prod.outlook.com (2603:10a6:207::19)
 To PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|BL3PR13MB5196:EE_
X-MS-Office365-Filtering-Correlation-Id: a6965e79-9ee6-4540-c6f4-08db6ccd640f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	G/8GYbBCUKFp3BiRLDEyFgx4FGWeRzsWrPxyAQWpl1PHHWgKKIeH5QvBsnOR+qD1gD9bG8LiNVh0lDCL6DQZFaYh6Qua6Ir91aJZHAfveJqXhkl1xjUAA4//CXA9BZBT0w31Z9atcMJWaU1PketX3/vxpXcZR/UznDPeFTv3nlO5KqEi/8BJUDi3hpowGadADIgtrw4Yt5fsfEYVqV3jMC8GiWjIjh6xnjCgkOQylhrH0UvGFOEq1pwU4Kp1YRsyF2ViugJAiluyI3x7v6IMGPXwbRZdvkr8pkAXhF2ZcjcyQ8BjPyPI6TNRxpTbmnIudpatvn6BZHdynf5RP/4SYhZWUNR3Gu0hGTCXhu7/0S818tnZo3JrolUCt98AXeWdcVF75Xq6pX1OsbT1jiYhO2rUlFRZFCBzZfnO107Q+DDzGzgaYwid0lFgLisxfA7UBnA9gpszX/s0s9vV5a0Ssu7VOyokpwKuQg8inl8MTwaIltKYoYpTPPzj7Nte/AOPAdpWtjQ//SCzQ/qomjTBSn2yiy4LJNyuYBBJExUP/khO+KJ7Tiuf9zlWPvAwzZuhktYQFWNK81nbWf9d2HqADbQqKEEPqxwfbObMKjeqln4=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(346002)(39840400004)(376002)(451199021)(8936002)(8676002)(4744005)(2906002)(15650500001)(38100700002)(5660300002)(66476007)(66556008)(66946007)(316002)(4326008)(6916009)(83380400001)(54906003)(41300700001)(2616005)(36756003)(478600001)(186003)(6512007)(6506007)(6666004)(6486002)(44832011)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?8opBu6Z49sPtcrRoVbbY0cQ7NyeeoJoj7px6LTr+pf+g/zc10Jmk5Lp6DqYv?=
 =?us-ascii?Q?VnQSheZrJkpzoRXwGPZyScpj+bYZBa4u91o8KrchUhBi2j6b6vg7tbP22DQD?=
 =?us-ascii?Q?A6Aor4k8+LAe1z0Y+8Mx3qYG50s0wR4fYBPYhpKTogqluqnyXmOpprTPxFwg?=
 =?us-ascii?Q?Uf4zOhwiY9H5Jwb2zyGSnwCLgcr2er403mpPB1fa+lpBfBqqgmYE46sQRNE+?=
 =?us-ascii?Q?Ev6aUUHZuPOkwv/f+cAKRXdXTauBxLRS26XOja1glZnHLiSQ4l7jwUXsvsDQ?=
 =?us-ascii?Q?ku+gWvdbpFOHd1HGsA8ITLZJmqB5XG1NbYq0mvmti0tnGpUMmQ/6rfpXMTHu?=
 =?us-ascii?Q?GtS4+I+SPjJp4Z6EPoDG0xVeSC+KtBrCwgh69P/md8/FDED5Cr9iLVu7VRjK?=
 =?us-ascii?Q?vwayKn6uWvGoJUcRVwSfLevjFWiyp0bhStMIoVXH7faOGoulOL0Bq5KQ5SCY?=
 =?us-ascii?Q?i6OS8fdBgYJAR5s8FH/yvbucXgPYOGYPHv0B6HBPE1rRtV3hKrdPOd0MU7s3?=
 =?us-ascii?Q?QktdKXNTu73edDkNc5P9V5lg7EvGvLSdZneLA+pZL+MBKT5COXVCa6kFRHm7?=
 =?us-ascii?Q?QZfbGHlmQhRZxii3ipsJp6qNae17KVPMHqoyYsA1PmhBsM9jlLL6QLszTNP2?=
 =?us-ascii?Q?CofBBPGgnVWdrA/p/keA5aolzYDZdtjrlL8M40/LWLQNegbGjiKg/JbGqbXJ?=
 =?us-ascii?Q?UQDsjZQPm6Nu/QaBiutSad0bS1BPS4n45Xwoypn+5dH5kHTeA2qwEWRN5ZTI?=
 =?us-ascii?Q?qrhX6VhevVFjlVavC9ngbMeWq92lQ2nUafBfBJ0ghnSTp4pD3KIdPt3/8K2K?=
 =?us-ascii?Q?IjuF0v12zgdpiZ3ZKoE66o2L9z0d+nD1yoI+VVQpwOTvc7+Aa1rzskhZSOVK?=
 =?us-ascii?Q?rw817UXLONdi7E4+l37eGqUETqxBpvCvPNU8dDSgVzkryFOIiuCmycA0bPu4?=
 =?us-ascii?Q?VfgCuKLe2e7IrdQkmzGfDk6pF00UBAP0zYec0fbZFsUwL+iFWfskSV0er5d4?=
 =?us-ascii?Q?1TX6HG4WOmXr/GILdhVOoQRFAyxQaN/H3QsVKI8oEevZLAWQJ7aWvjlUyl38?=
 =?us-ascii?Q?qvQQNZlkzqKHLxerfBH1/wzQOiZBXfswx5r3TJ6ifV2qdfziuGuJl33hnGOP?=
 =?us-ascii?Q?FXsgY6YrVOTzUq1P1OOA26BmND2uhzLlSJm5zjRkz8vpV4EGC/pvVmLhuORZ?=
 =?us-ascii?Q?oGeM+28J5VagzHFFIqE0TfnzypA6BIL/rng2SnvRh4prw5IJodXpzSZx3aKm?=
 =?us-ascii?Q?TMnVO7n6hS98qphXIy+XOloLBi/uKGFVg85fUEgYEYoBMuV/KaBqHHtI9fEz?=
 =?us-ascii?Q?TJi+h0X+yL+dngtyww/2v2/d9mxfIF3kc0ncdqLCHIGUcWeR/EjYTNotRwer?=
 =?us-ascii?Q?RGEw98/V6eu+V7hSmSezWjYuIizQzPGKwNOAZ69XSEkwMzk/dAkvCxX7Txju?=
 =?us-ascii?Q?CX9OvIdUeGH2egZq91S8QnVwjARycLyoXvu1hxGUd26lemcDSrFker6CGxvk?=
 =?us-ascii?Q?XvY4pOVyZIusUx8zsiWybt0ZVV7huAZXmHsQsYqL5Z2FdLDpg2/ZVaP87vyP?=
 =?us-ascii?Q?WpMMikbrdYvep/mksvzhVKHN32YL1kJLwPoJNdF8dy23dUpxAs87DPd0/2Zx?=
 =?us-ascii?Q?IFpXc9oOOKw4Gb2PTjONz8eVuczu3rnVD8oSZqKbtWJpjhRA0qFxdmsZpxbJ?=
 =?us-ascii?Q?YSLwnQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6965e79-9ee6-4540-c6f4-08db6ccd640f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jun 2023 11:49:20.7321
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+bVX9Gd7ac+gfxlMXFK6/PSMh1HlBb7HjoU86mn0uPIrUNZjfmBFSRSzaQkVM8k6kMKAuBrG/RasInykyyqnbT+rFlwgg9cZUHShce+Nd4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR13MB5196
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 11:55:34AM -0400, Xin Long wrote:
> This patch moves validate_linkmsg() out of do_setlink() to its callers
> and deletes the early validate_linkmsg() call in __rtnl_newlink(), so
> that it will not call validate_linkmsg() twice in either of the paths:
> 
>   - __rtnl_newlink() -> do_setlink()
>   - __rtnl_newlink() -> rtnl_newlink_create() -> rtnl_create_link()
> 
> Additionally, as validate_linkmsg() is now only called with a real
> dev, we can remove the NULL check for dev in validate_linkmsg().
> 
> Note that we moved validate_linkmsg() check to the places where it has
> not done any changes to the dev, as Jakub suggested.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@corigine.com>


