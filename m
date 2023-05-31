Return-Path: <netdev+bounces-6864-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E554718759
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 18:28:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DBA61281554
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 16:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E43E2182CE;
	Wed, 31 May 2023 16:28:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF87F182CC
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 16:28:20 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2109.outbound.protection.outlook.com [40.107.220.109])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F7698;
	Wed, 31 May 2023 09:28:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k1ZHNjbM/nj05073Gngu3l/LItwB0Wsxeft1aY6dobxI8efW154+By6s9ooxM435XffexBRrZd7/YCZYCQkDd/j3XEUun0tkIJdmlJGVRnTldAaxxXkHPgvYcUiIwreCzSxYZWE2fChOyqYopyh3aNx5BF3DEKOiueocvs8kwvD9XyB9M27I4TmdNIvjpzCZpmx0LrPNFWjt/4audXLZc1OE6RmPXnwreYlWhY1JPz/QzQaqH+4OfaZCas+LWA98U7+QGPXmF8ek6Q/TcTJs4Iznom6hB87OS9XjQex1fC8dwgj/SJeX/nOwklAj4co8lfgW7+tQOxKcQkj16a48zQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YBULw9AxaSt5ZrTaYDcS8nypVA9XadtdNWjNolZQRac=;
 b=kxkrqbZMw3JpXligeS29qTLreS5o2AdN5TjkTkZBj/gX/OHccBm4dN9LdCvjhsN/xHF+z/PtIfl510EPQ+gELY9LZ4wSkqmzTrBrfFG0OCF4NJ8Lx1+u4Z8IvUdwafU+iM7yoPv5EFOMyf7VxF0YsTwYUlnFiOF3U4kEi7gVBm4T66oNY9ze+2r2fAoI3mCT7cO+GzIFEVuAW3TtAfbFA0v5GdckO6laKmbYU8ykeZfmGf/4mcdfS9dZFIf4ggnfSDOZhHsmladUdeN3EhVLNN27hhRkUd0bTbXY5jJQ0CikMC68UlGI9HB+9e3/9lWW0SAqyAiavHLco/Gdf/WT9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YBULw9AxaSt5ZrTaYDcS8nypVA9XadtdNWjNolZQRac=;
 b=CPSZ2O93z+3a/U1+EHDsECqUmTcQY7XA5qu7YFjWVohnG7ot8SUaqLK0RuXN3HlJCZWMPcrHH6PlCy7PhQJsmTfcV/R6xzNJQOEyrFl1QTwuSTdvVWTooIV/d+T1vHVKR96EAQ4BxL6WDDIGHBjsl/SJnfD+ibQ024dk8qJSF4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by MW4PR13MB5990.namprd13.prod.outlook.com (2603:10b6:303:1ba::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 16:28:15 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::5e55:9a39:751f:55f6%3]) with mapi id 15.20.6433.024; Wed, 31 May 2023
 16:28:15 +0000
Date: Wed, 31 May 2023 18:28:08 +0200
From: Simon Horman <simon.horman@corigine.com>
To: Ying Hsu <yinghsu@chromium.org>
Cc: linux-bluetooth@vger.kernel.org,
	chromeos-bluetooth-upstreaming@chromium.org,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Johan Hedberg <johan.hedberg@gmail.com>,
	Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH v5] Bluetooth: Fix l2cap_disconnect_req deadlock
Message-ID: <ZHd1mPanIsBORpLE@corigine.com>
References: <20230531034522.375889-1-yinghsu@chromium.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230531034522.375889-1-yinghsu@chromium.org>
X-ClientProxiedBy: AM0PR08CA0032.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::45) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR13MB4842:EE_|MW4PR13MB5990:EE_
X-MS-Office365-Filtering-Correlation-Id: bcf58abf-066b-41d9-af91-08db61f408e1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	4zXVrpl6YItj9jUzJZ1ijf81T6K4XOeVWp71uAsdKUAE43TAsmPX+iu0LKJ8Qe8gbmvEGEuwpz3EkPuJljRHMnkoJAkhhj78nVwj6fF/SZL0UPYE1XbmFGYhQ5/Gys3G+7GPpZcCtfGb9WZSG4qxqSum+yNmGFLfdEtO4X7mbo0JWAxAqkjldfkml83hn/ZOKJevxCPbnUPkWY0Wl51KejfZVlL4lPv5nceHr1VytthVFqVErgLWsg845Piuyp+gpMHYXVOGUtea9Q5FZxXMhTQysgu6dv2iBJPmRYjbwbJYTEkBwbYOtze1/EqxWF8OtjQyYy3Iu7PwAJTGr9P9RBQFOo52+m8EIVXKLh32jIyytjzNVx9aEe51fIfDKkthjG7R3LeRj+SqzVRWXMYCM49dleTxHllTmhVtfgosGNpPQXCFyJ94E5YAwTDnB6y0zx9yIHUsLWZuxYr+JHMqtatyXO+gq+q6488L/JzNQELKzUexcwG78Ot978IFNI9zuDRK8pbxY3toJpLl1tZ9zFdiyWuhmMV/hokQFdanMUvNoI788W46iR8Q/cG6wrro
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39840400004)(396003)(366004)(376002)(346002)(136003)(451199021)(6486002)(316002)(6666004)(5660300002)(2616005)(8936002)(86362001)(83380400001)(41300700001)(8676002)(44832011)(7416002)(478600001)(38100700002)(186003)(6506007)(6512007)(54906003)(4326008)(6916009)(2906002)(4744005)(66946007)(36756003)(66476007)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?ivoAPdv0fp3Q4ULOHX4sbGsEVWh6nOhRnHlusM+hT6vTcuu7AxJLn6MSHmXw?=
 =?us-ascii?Q?NdvYhpAoOvCGdXWek5A2drOI3isetve+rqaINUmSWbpXm1Y19SLssqIl/VwI?=
 =?us-ascii?Q?6N+XGxz/8yR8fLZyztkCv1quJIUdmXa7bxTvXGYkj04N+HvNnZe/j+8ct1vD?=
 =?us-ascii?Q?D7i+S6n56Qt1/g/uMQjuTX3BmLZa0w7aWyv6jYVQ9CE53KSrhKAwTHhfeIng?=
 =?us-ascii?Q?4vCb6fbAUkG7kEzJ80UNuPHulhpkw/nHqRSM+QP0gxBnroEOCeGP7OJSFD2r?=
 =?us-ascii?Q?oHX/TKIaSwpa/fpn2R6QK3XJyD7feQc4YxVb/iMA4TVYnhFEE68nOtn1a0iV?=
 =?us-ascii?Q?NRcfqKuaiQi81+q4nlTVU7aoiZBIHYvFP0AWf2isQKl3DN+MI2eIjpROHP9f?=
 =?us-ascii?Q?+lefYWpuGCLG2xjt8Ii2ZM9cMlaJBpm7OJpmf9qwZaQ+kYwfJasGon/8h3NT?=
 =?us-ascii?Q?Jn/gnvZ91qg6Ks918fVttqegkCxqo7lhmH4fuArzI0qXAJ5rmWE8iSXlEK+A?=
 =?us-ascii?Q?HnQ3Qy+OmVnrwAOF7Ju7FIgBu3BcQGLq9OiMVTVKgtyiMgvqK4TH1dJmKabB?=
 =?us-ascii?Q?st0vhZnT8MROocQp7aKOxGgzRFEG+J3eiH3MkPs3ZxOW7IzwJZZ7fLb1LpcW?=
 =?us-ascii?Q?eQEzbz8wfLraQbRy2QcqNwqaa5M3nFjSG0d9aVJaXaH9H+RpeIW2HxM6Qbfd?=
 =?us-ascii?Q?qlJywjALHhGYRyvTKMmHUQ+CgP7+7gOyzvDzZDpabMoqMJkWwGHD5Rbtcf9n?=
 =?us-ascii?Q?0g/51H1OiCgn7II85mBVR+ZJClAiDJYZgmYuISrwwLJE1Cf/BC0Ug66POsmz?=
 =?us-ascii?Q?/BHAADWsLY9IRbGpbPKT6f5bpYdrv0ND6J+m51oBVdc9/m8u70DeeHje178V?=
 =?us-ascii?Q?IdsJ1Xihii7RIXQ0U3LloEshcYXLCJ7zO426jxnYk+uu0R/XNolObDHIEAgD?=
 =?us-ascii?Q?lg1FCNrI5myNoaTF/k8I8vS6kcJ2SRZpvoLYjm4mcgYREvJ/IHaQy6X9Gl8B?=
 =?us-ascii?Q?Yo0Hgg42j7QTAvT13Y8/XfxwBEq7nHou8e9G6baMUwsSubmtYBrPzvivyCea?=
 =?us-ascii?Q?Xeds+SL1xQ4hdkW+rSGvuyLK661QiFccBtDH9aVBhzMJ5YZ9eTHOHlBagYO8?=
 =?us-ascii?Q?hR00dmXUvhel8y6v6+f24IINJBrdoHi9Yu1T9yNyz+v4XJIgBqatXTqSZYDa?=
 =?us-ascii?Q?aim2R1gp5i4fBDnhltkIjorXEMMkUuIHxT3RxJZmyvicGPMENVM/U2GWywgT?=
 =?us-ascii?Q?xwm70FeWGOzUqPa1biDeT9lIamLRl6sL3bawstVgYd/EHYPlSgEQ4M5iToTG?=
 =?us-ascii?Q?t7C15Uai3wWgOXWGukegzlQ1Mq/sVp5XtuzqNS1ww5Vexurmpjor4eR/HSOi?=
 =?us-ascii?Q?hZnRx9XRjzVNsqsApCHTg8L20giV2s9sJx86XG3j1DRXfRZz7ES6zLvrliNf?=
 =?us-ascii?Q?DKCCQosxDVyW8nIDNc6b8iweIhpbNB6AEYOyLoPrHnNm4ytCb8lfHARKhIV5?=
 =?us-ascii?Q?06oW0YIHEHluMdJ/7DR+KeoBP8OeIie1Ch1eysea/5B6nRwh1Hb+UkyU1twU?=
 =?us-ascii?Q?BbMnCOd13TbzJ1BOrMKz07Q0MGcvyQWE2BqKrsbx+6gozRv8KpLO6aJroI+S?=
 =?us-ascii?Q?armvlUQlB/KHRmbo5F21VNWZweU6sGD7/J92gMn/chPm48PveHunoc5UsaZh?=
 =?us-ascii?Q?qjHIkw=3D=3D?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcf58abf-066b-41d9-af91-08db61f408e1
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2023 16:28:15.4669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5j+f4a3ht2ak211MSx41eyrMsTKms8zImT1JtyUdJ4iOLkvhxIHasIYhKdxkfkcqhLI202q43v7LV2Y/o1hY0D77gnO1njZhY34ij0W9LfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR13MB5990
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Wed, May 31, 2023 at 03:44:56AM +0000, Ying Hsu wrote:
> L2CAP assumes that the locks conn->chan_lock and chan->lock are
> acquired in the order conn->chan_lock, chan->lock to avoid
> potential deadlock.
> For example, l2sock_shutdown acquires these locks in the order:
>   mutex_lock(&conn->chan_lock)
>   l2cap_chan_lock(chan)
> 
> However, l2cap_disconnect_req acquires chan->lock in
> l2cap_get_chan_by_scid first and then acquires conn->chan_lock
> before calling l2cap_chan_del. This means that these locks are
> acquired in unexpected order, which leads to potential deadlock:
>   l2cap_chan_lock(c)
>   mutex_lock(&conn->chan_lock)
> 
> This patch releases chan->lock before acquiring the conn_chan_lock
> to avoid the potential deadlock.
> 
> Fixes: ("a2a9339e1c9d Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}")

nit: this should be

Fixes: a2a9339e1c9d ("Bluetooth: L2CAP: Fix use-after-free in l2cap_disconnect_{req,rsp}")

...

