Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287F81BD0A1
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 01:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726381AbgD1Xd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 19:33:56 -0400
Received: from mail-am6eur05on2071.outbound.protection.outlook.com ([40.107.22.71]:22881
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726181AbgD1Xd4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 19:33:56 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UlBzOre2F3bFCgkzvMV6yBsaex5GTSedjtkinvw8JgIVjmNodoLqDxm6Nr9IQ1MTLSMKRyX8zrgSj+HyaXdv8V6Ir798aCgO4RDgdCHhrWjM/YGCdqNWard74JIFzjaC6lD4U581NCxLDsToBZ3fYleSpYJAU5SLqSOJqIE/qkZL8f7XY1ARC70ZQm+N96AQUsz/MzBEQHZFsQsJ7FqF8qOLLg4xjrlmio/qM+lTen/lHaiJlg+DjojEFfrQOytCusyaiOyoPxgY/Z6mRPhH2ZqB6MadFtk+VcorpvJ0ZArtSP2Rn4a2yjVKenZjT1fk6Bfc37oHc+amspvI+nK5sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEApjcxTWH6IFt1O2nPNDz9n8DPHY4n5OHsmNftYW2I=;
 b=PWM3PRyWFFfG302To4nJ/HB8icS15XByh6cnqezLgFlzy9ah/7sMhIDoSzUbn0egDgvure6bOsWTRCHeHBntdv/KS9ROU1Xn7N+ChdQnFrgP1NBBKZ0e8C8x4knD3A3KHDHHmXLC5NLZYl1QgOvRsqb+g+kSju9Yrf57Jo1YBpA2c5J7v9f+G4DToofjVEIQNWOd/K+iMlgh6LsALi3ps+Yj6qkjy6ydHyhXScWp5xWoscNbLTPyNUMiR9aEB4iUvlLDKn9EOXu0xZEc2b7zLNUCZI/7xEWJNYufCbO6AhOxMfQRT+hOWjW7Hj+c9+hX+0e9ke3cNK6WIP+UTlrSGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NEApjcxTWH6IFt1O2nPNDz9n8DPHY4n5OHsmNftYW2I=;
 b=FDJtpdYsdqleVZmrKKhghT5pzSVSOA10ZxrVJXBtYT0YSiD4uFV8+DH41LWhJXoO7VQaGadsaF1yLUIxV/bUK6pPAb8tTsFSfINSf0mvTASQJ+1481PwcaIgIJyt2JconlWA3k/9gCH9GNu+kENvl2mcc+MOyaUucwnsuKQjkHI=
Authentication-Results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
 by VI1PR05MB4576.eurprd05.prod.outlook.com (2603:10a6:802:68::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 23:33:52 +0000
Received: from VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e]) by VI1PR05MB4141.eurprd05.prod.outlook.com
 ([fe80::a47b:e3cd:7d6d:5d4e%6]) with mapi id 15.20.2937.020; Tue, 28 Apr 2020
 23:33:52 +0000
Date:   Tue, 28 Apr 2020 20:33:49 -0300
From:   Jason Gunthorpe <jgg@mellanox.com>
To:     Maor Gottlieb <maorg@mellanox.com>
Cc:     davem@davemloft.net, dledford@redhat.com, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, alexr@mellanox.com
Subject: Re: [PATCH V6 mlx5-next 12/16] RDMA/core: Get xmit slave for LAG
Message-ID: <20200428233349.GB13640@mellanox.com>
References: <20200426071717.17088-1-maorg@mellanox.com>
 <20200426071717.17088-13-maorg@mellanox.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200426071717.17088-13-maorg@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: MN2PR01CA0018.prod.exchangelabs.com (2603:10b6:208:10c::31)
 To VI1PR05MB4141.eurprd05.prod.outlook.com (2603:10a6:803:44::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.68.57.212) by MN2PR01CA0018.prod.exchangelabs.com (2603:10b6:208:10c::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13 via Frontend Transport; Tue, 28 Apr 2020 23:33:52 +0000
Received: from jgg by mlx.ziepe.ca with local (Exim 4.90_1)     (envelope-from <jgg@mellanox.com>)      id 1jTZjZ-0008Gd-Bc; Tue, 28 Apr 2020 20:33:49 -0300
X-Originating-IP: [142.68.57.212]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f5d185dd-21b9-4f99-8734-08d7ebcc9c1e
X-MS-TrafficTypeDiagnostic: VI1PR05MB4576:|VI1PR05MB4576:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB4576CE800375AFFCF14B6A7ECFAC0@VI1PR05MB4576.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1923;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB4141.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(366004)(136003)(346002)(39840400004)(376002)(66476007)(66946007)(33656002)(9746002)(6636002)(5660300002)(2906002)(107886003)(4326008)(6862004)(86362001)(9786002)(1076003)(2616005)(66556008)(8676002)(8936002)(478600001)(52116002)(36756003)(37006003)(26005)(316002)(186003)(24400500001);DIR:OUT;SFP:1101;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +DKSjjOM85E5Q4amtUFnlS3+axWsvHzXlhiHL6pXhtu1orCHAfBKg5v8GDIfWBbBy2QcKYEC6FQMBPnamy1GbvzbRSN/LBglR2Xl/Xjz8HIACnXa8xGjAF0UqVn68kC02nurunklgwt6kKvibCRn0AOeRbMAzfky/7ghNRbT4ERf2DwXGdJJtWPA1ma5JIKlWdjCyullAxeEZDtjPgE6sw9YDdC13vT3zViQ9g8vkHjwDvIv/EHYgrtJkBuupT3fXWzoQCBF21W+tAc+TYYzcgPCaLwxnHjz0nYcg/AE6URY2Yn4BgHhNI8R/nKroPqo1cME7O+702H6P9T3PJKCpsogFSujEiejl/wU6ua4bF5OGhnJKC7YfXQrEf5KHaVd9zc1s7FEpNzL6UJ8Prnl9ZYtOEY2mybOHp/0DYv6tvzU/jhJ9WCXJkLYl1UEmquZghbUn9tbAl8eFlIvtsqIWmX8Sr1sdeWlBOUV6lERl2StCzUq48uAAsENRtPZhmmg
X-MS-Exchange-AntiSpam-MessageData: 43zD7GVttMbjkI5uRWEnFBv4upISWV+6cNSyrp3uzEnUIFQ/aUfRVVBKFMDiG651eB1d903alqTxv/Dsqou1JjdSE/I2fZSR9xdN0/2PLE9XJKVsBA7SXE+HyWwN4lDutC7XjTcBTl5+uFEJ9UhLHs+dFsKc0LJWvVh8yFFJM+fp2qO+r2d9YWkA820A3QSqJ6nig2QcdcQ1VsZmDxzSXPclq3/tdCbnE6a/094nkxk83PVk3gu6RdzFItGhoRbrZs0cGOKYTUJH13kfshVZKKBJte1IvL7KYpnhqFAxDOXv9yyeUvfbWAQdQ7Ex3mNoHgh07ycVMFNXh5tb0dZjDCuZM+VAE0TYQZof6kwRobApBTStuYGZ8jUdisJftMGe0EfziUGmzxFIYlgWU/mCpWGLbT9AOcUPNzjjv6WcX8s4R1/eOQxY4ZssP+NP0Yj38couifLmWA7jVkTlBrl6rV3JpBtQBlaWyvz8/2eKKvBdLDtKdC8MOkRMLiebaWRnPBlZe8G0/sUX58OiB5femKlm78K+2rHcDsUk28r9vZw3PqRKJqCtqv3IoUeYd6FLkReOtu3g9LyEL29m8sizo1s4NNakEK3ymrc3+YEeUvXV/b94guSLnd7O3JuODxara/2e/Oa5S6AGFDaGm9UjK6kxzWqfKX6b6BG4oQTvRHPIXqRdkYuyk71WoK5YoAJjSKBCGhE2ojdtxOBumcvV6TD7VxasCslcUgGXR6uvB8eOsznL4bgga5lrPJ7eBNuSz8EA2F4BTKmryOYd37c8d0soHVAVr5kJafmVA9udPjk=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5d185dd-21b9-4f99-8734-08d7ebcc9c1e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 23:33:52.3035
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ip1tmeg1TL16EtsEadRdAgQiWkh+ZNOKiTRQkEKmHzTXPLKP5T4OVhCt0Y63QE/TrwbQl3aSo6WTEM8mhbi7yA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 26, 2020 at 10:17:13AM +0300, Maor Gottlieb wrote:
> Add a call to rdma_lag_get_ah_roce_slave when
> Address handle is created.
> Lower driver can use it to select the QP's affinity port.
> 
> Signed-off-by: Maor Gottlieb <maorg@mellanox.com>
> Reviewed-by: Leon Romanovsky <leonro@mellanox.com>
>  drivers/infiniband/core/verbs.c | 53 +++++++++++++++++++++++----------
>  include/rdma/ib_verbs.h         |  2 ++
>  2 files changed, 39 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
> index 86be8a54a2d6..36fb3d032330 100644
> +++ b/drivers/infiniband/core/verbs.c
> @@ -50,6 +50,7 @@
>  #include <rdma/ib_cache.h>
>  #include <rdma/ib_addr.h>
>  #include <rdma/rw.h>
> +#include <rdma/lag.h>
>  
>  #include "core_priv.h"
>  #include <trace/events/rdma_core.h>
> @@ -500,7 +501,8 @@ rdma_update_sgid_attr(struct rdma_ah_attr *ah_attr,
>  static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>  				     struct rdma_ah_attr *ah_attr,
>  				     u32 flags,
> -				     struct ib_udata *udata)
> +				     struct ib_udata *udata,
> +				     struct net_device *xmit_slave)
>
>  {
>  	struct rdma_ah_init_attr init_attr = {};
>  	struct ib_device *device = pd->device;
> @@ -524,6 +526,7 @@ static struct ib_ah *_rdma_create_ah(struct ib_pd *pd,
>  	ah->sgid_attr = rdma_update_sgid_attr(ah_attr, NULL);
>  	init_attr.ah_attr = ah_attr;
>  	init_attr.flags = flags;
> +	init_attr.xmit_slave = xmit_slave;
>  
>  	ret = device->ops.create_ah(ah, &init_attr, udata);
>  	if (ret) {
> @@ -550,6 +553,7 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
>  			     u32 flags)
>  {
>  	const struct ib_gid_attr *old_sgid_attr;
> +	struct net_device *slave;
>  	struct ib_ah *ah;
>  	int ret;
>  
> @@ -557,8 +561,14 @@ struct ib_ah *rdma_create_ah(struct ib_pd *pd, struct rdma_ah_attr *ah_attr,
>  	if (ret)
>  		return ERR_PTR(ret);
>  
> -	ah = _rdma_create_ah(pd, ah_attr, flags, NULL);
> +	ret = rdma_lag_get_ah_roce_slave(pd->device, ah_attr, &slave);
> +	if (ret) {
> +		rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
> +		return ERR_PTR(ret);
> +	}
>  
> +	ah = _rdma_create_ah(pd, ah_attr, flags, NULL, slave);
> +	rdma_lag_put_ah_roce_slave(slave);
>  	rdma_unfill_sgid_attr(ah_attr, old_sgid_attr);
>  	return ah;
>  }
> @@ -597,7 +607,8 @@ struct ib_ah *rdma_create_user_ah(struct ib_pd *pd,
>  		}
>  	}
>  
> -	ah = _rdma_create_ah(pd, ah_attr, RDMA_CREATE_AH_SLEEPABLE, udata);
> +	ah = _rdma_create_ah(pd, ah_attr, RDMA_CREATE_AH_SLEEPABLE,
> +			     udata, NULL);

Why doesn't the user space do the check too?

Jason
