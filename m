Return-Path: <netdev+bounces-1333-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9218C6FD694
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 08:11:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 584FB1C20CC3
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 06:11:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25AC7568A;
	Wed, 10 May 2023 06:11:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1837765A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 06:11:17 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2108.outbound.protection.outlook.com [40.107.100.108])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05D311B;
	Tue,  9 May 2023 23:11:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H9ehqdmAVrGbNwW/Y/fV0oUQWv4QNgRG0sj3ePIz73K6XL3qDaLS244YEhFdqq8DBXXlbD7oiBwuJCOJB/9PHx/QoOa6bQglwkcJw/rkxmuEIIjH5eMUiWECERXM1T/k+NKP8alPFO2WKDSlOTNgkQFmFnbm2WfMaqSeW9+YdFU+WG0ESUQHMadea04GjAKqKVXD6H17dgWd9ty5UQiZ67N295rpuE3SX1MmCrzMT5PnQ9UMJfzdbt3PXrKQ4z5qTXFKyc4V31RjuQ3pjfLOJL/+dN1iZi+SW/i5mIqwAA+U0PyhG4VwK4ljyxHrbKgz8+UVcUr0C3yrKAoz73gpfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dGD9CbQZPKhaiMlfT04i9xBNfjWVgM4A65cQBY8oVHI=;
 b=l+hOdWxJHGTkPg0RlVX3+fvargOEjmjdByLzmPdCADmd+KkFpKyb/f12RxbyhqdlHsFJPYLaayT1yU8iW7hkHDLe5CEycvAnxBzAWh74TtgfhWrHqZJQ80/mCDwRbBTHkD8PZpnridLpwnXJOgcPuxDV92qffROunG4ljSEUXmvFIDrF+Ffs01JqrFgUiK5DOscG+LmHZKmfP+drySBmYVnFughGipoHf6ZPBCIeD4wWoezadzs/bx0MbpS5+o6o1IqhtPvF9WLqEFnWMSqEq/b482f3eD9r5D0+eotTQnRyruFqId7DM1wlIOWV56ynBF6zS2e+cpDERjq4E7AdKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dGD9CbQZPKhaiMlfT04i9xBNfjWVgM4A65cQBY8oVHI=;
 b=Cd/wWM7zjJElfZgVXSogxeDhqoGWbw96a9+UJsjrXCqHgAXgKuO+Y9qRAqaTzfmTiQtJyN42zTX01mX1CT3+33hlZjQZ9AggNls+33i5spP5ZTtffBA5tZ7TukI3S/aTatx75IzQXADKeREUTzZr8JUn0j7rDkUTPrZt9AUrC4U=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from DM6PR13MB4249.namprd13.prod.outlook.com (2603:10b6:5:7b::25) by
 CO6PR13MB5307.namprd13.prod.outlook.com (2603:10b6:303:14d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6363.33; Wed, 10 May 2023 06:11:10 +0000
Received: from DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e]) by DM6PR13MB4249.namprd13.prod.outlook.com
 ([fe80::47e:11b:a728:c09e%7]) with mapi id 15.20.6363.032; Wed, 10 May 2023
 06:11:10 +0000
Date: Wed, 10 May 2023 08:10:59 +0200
From: Louis Peens <louis.peens@corigine.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: David Miller <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org,
	stable@vger.kernel.org, oss-drivers@corigine.com
Subject: Re: [PATCH net] nfp: fix rcu_read_lock/unlock while rcu_derefrencing
Message-ID: <ZFs1c2VLJIJTj0+B@LouisNoVo>
References: <20230509060632.8233-1-louis.peens@corigine.com>
 <20230509194013.3c73ffbb@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509194013.3c73ffbb@kernel.org>
X-ClientProxiedBy: ZR0P278CA0053.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:1d::22) To DM6PR13MB4249.namprd13.prod.outlook.com
 (2603:10b6:5:7b::25)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR13MB4249:EE_|CO6PR13MB5307:EE_
X-MS-Office365-Filtering-Correlation-Id: 08f7e12e-2a57-49a1-fea8-08db511d5980
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	86IFmxtf+qxWxTj2st0UiP+ggeIhO5LhjE0kHMa9/DL4sDUTUb+1h6+3gTl70Jq7oqURXurXF53PoWa2rQU3zDeGrkGBfnwHkFTY3suUeH75bkmRHVqca+PzNdIvLWUVbiTazEkpIkSnCkJRp+mV9gvSsQm3FiPUdQ+wJvF8iq+N6VWQwHHdxoki6LyNjm/XaNEersPwji5N2hP3s7VmMLyF4QK4AuvXGFzVSKoHTWFCfIMDw+c1fNBtTOSpGDcClvWrobnayrXtRdFiIiqx3wqg4aq0UdAptxkrqnfldJ/nZP78DPVBkgPtxvLaX8cdLK4lqbM0SlXAEqn3GAdKX6aUyB4Oi35/IgjGgJGnx4faFRVbJi6wd44zBxaFuOYqy/uDba8le5BxzkIDOfRYlNjpmXcBST3OuL1NM9XwXkMRGU2SnWFHMqU+nobu7d5iNuUc1OM+J3+F/VNRuRjnvjL8z52S9rF6w9jOoUMuQcLnfyr0et2sFg9u7wpYPKeM0gYrLYQpKqMyD9UPlGuXLrWg9eiRZ/R1Fa9nlPINE9wdEw0AtagMTf4H2v8o9V2xzGAk4BCBXGD8WQR2eRQJxO+iStcEuNWp+vuFk09TlCA=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR13MB4249.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(7916004)(4636009)(376002)(346002)(39840400004)(136003)(366004)(396003)(451199021)(83380400001)(54906003)(8676002)(8936002)(316002)(6666004)(66946007)(4326008)(6486002)(6916009)(44832011)(5660300002)(66476007)(66556008)(478600001)(2906002)(86362001)(186003)(6506007)(6512007)(9686003)(107886003)(38100700002)(41300700001)(26005)(33716001)(67856001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?W8Qv+ZaeUnAdTOr1v5vE9gxqL8zAKjjM9yxyvQbc+LwFThcI98LQE5xWnvRp?=
 =?us-ascii?Q?FJQuOzm8CILjxDXQ937Z5xHQ2CrDw0oX6hbarxS3Vxohw6qe62L6kDMEa7c5?=
 =?us-ascii?Q?GYagLwI7bEza8PFU9Ao6+azdcsW3AIDeFe97pLc73gn37DAh9WFf+2paVnpU?=
 =?us-ascii?Q?OgNQBCGqGBeEDDL7VumkDMD7qD3438Msz5pXiyIJk5a2NIw4jVtgFfMCYys4?=
 =?us-ascii?Q?ezJv6kLvn8vTlqrDQlDjGK+RvG9iNaF1vX6XFaq06tfm/rfK0hmPL+c9araL?=
 =?us-ascii?Q?5BTijzG6VEzsSGKuptmUvPPm37r1HIhcN+s+RJegiRUKBNXdpAIF22gfVZ9e?=
 =?us-ascii?Q?tPTXM59oX1vl1mw7oJ3MUHLiWiTXhYGqk1h8rS2V6uPLqRXRbz0KJPGO/t5N?=
 =?us-ascii?Q?y+mPGehIVDFZ5RoWJafMv/ARv+PC/pMmbQcVpHhCZl0YYJKbWvDmgIS/GLah?=
 =?us-ascii?Q?hyAT3oeR2L6u6djjqBhpmBY3szj9OeO3AnR7CVyrjfE+9JO5cOSXkX9rFn76?=
 =?us-ascii?Q?8oEhLH0hvd8DoHyDqfGX8qsZ+mGLOOzAtKRnJkUsALIQW3p3cFyBNJTlFNAE?=
 =?us-ascii?Q?d68JFu3wmWTn6Fw3Yskby9bU6+1sWggSgNrAmvMXFnt6QJYK/85TEnHKGBGZ?=
 =?us-ascii?Q?t8bvw4QJ+neJnABdu+5kl9Lb3qeNpe76EBQOF6bz/tpCIHbbry3qHrJEgH8N?=
 =?us-ascii?Q?GhdW8zPyqBK/yxfFKoZrvNrvnCXzt13DiDrzfaXz1v0dqLieYhVADySgPeCU?=
 =?us-ascii?Q?S9eEihlkHMw9dMau7j0bz8yqrHiLO02ZSLpA/560nVolxrKg7LSFlaKvM7nk?=
 =?us-ascii?Q?pPusdIQ8XHWZUhrw80zxrw/JlEKJgeHdi/R/hjKwU4C/+jovjLv9JanreoSt?=
 =?us-ascii?Q?eD2IEFUZBnQlvldI3P6A1dsSYQI3bVfPGs9mevsJSwq72CVKC0rThh1gQB+E?=
 =?us-ascii?Q?Lfb1L+lJIExybf702ezEMnCBeZVGRPtYOwQBgiV9F6r8gwH2LiWOk766nUei?=
 =?us-ascii?Q?xiuOY6OZjHbm+16F6rtSMKUUXckrKHBXI4WSqu8BCALmFy8R0mrQQDwS2iyQ?=
 =?us-ascii?Q?rwFNmV6bPK/ULLfrIgnpXglZ4V71Ozw/4iiaONudaGR2LUYBc/wZVkgmlxD9?=
 =?us-ascii?Q?rMB7+6ajLCw5kYthdduSmfQb6QG0IS+G+9thAzq5HtmInieIw6/BqbQq+laB?=
 =?us-ascii?Q?IiF8rMli2UPRHoJ92phSYTTZ8EAPM+EInLNaxaO4kbVz9e9nxZnArzPS3BlX?=
 =?us-ascii?Q?EqhRCIDmqmrGKAijqUs3t0VxjH6UnJ/gfDOWFdeBI7hEGCThZiHSfjUzioy4?=
 =?us-ascii?Q?QOIE/D1ToZ0Zm+MftJUNKDWQuPhXLEmx5wKFQiHPdWSm3gnasMfadkxMcND5?=
 =?us-ascii?Q?En6/wwrIyFsGJphOGB1n7Fn+xyPBLsTdIRPRyfEsc+FjwwcSTD3mwZ+TiLUI?=
 =?us-ascii?Q?GApssGyxV1UdiagjnPXUm5n/wA0neVrYpJlz30c+oNNkaP1H2MXGJ2UFcWHy?=
 =?us-ascii?Q?HWFEMN18DQTctRU9CBzqSOMfx+I5yd2Gye3UTsHq5dQfisZdbsPla+GyEmKm?=
 =?us-ascii?Q?55XXh3yc2H48EuzMGptKtYaqF+zV0ANbc9I/MqYo4a14KP4Kaleuv8WFER2X?=
 =?us-ascii?Q?iQ=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08f7e12e-2a57-49a1-fea8-08db511d5980
X-MS-Exchange-CrossTenant-AuthSource: DM6PR13MB4249.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 06:11:10.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y51dSWCsgCRk7SCKL7N5C12lZpWMtWCQ0pSGNdeBJo/X79DMkQiwsmbwzLRlnNoFvB2+mbpKNgufWCcHGAfKhVqhBlNboUzGbCiRIZLTHfI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR13MB5307
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 09, 2023 at 07:40:13PM -0700, Jakub Kicinski wrote:
> On Tue,  9 May 2023 08:06:32 +0200 Louis Peens wrote:
> > +static inline
> > +struct net_device *nfp_app_dev_get_locked(struct nfp_app *app, u32 id,
> 
> _locked() in what way? RCU functions typically use an _rcu suffix, no?
We were discussing the naming during internal review, for some reason didn't
think about using _rcu, will update if there is a v2.
> 
> > +					  bool *redir_egress)
> > +{
> > +	struct net_device *dev;
> > +
> > +	if (unlikely(!app || !app->type->dev_get))
> > +		return NULL;
> > +
> > +	rcu_read_lock();
> > +	dev = app->type->dev_get(app, id, redir_egress);
> > +	rcu_read_unlock();
> > +
> > +	return dev;
> 
> this looks very suspicious, RCU takes care primarily of the lifetime of
> objects, in this case dev. Returning it after dropping the lock seems
> wrong.
> 
> If the context is safe maybe it's a better idea to change the 
> condition in rcu_dereference_check() to include rcu_read_lock_bh_held()?
Thanks, will take a closer look at this.
> -- 
> pw-bot: cr
> 

