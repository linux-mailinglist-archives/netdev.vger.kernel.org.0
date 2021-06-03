Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0D339A4F8
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 17:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbhFCPsb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 11:48:31 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:47084 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbhFCPsa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 11:48:30 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153Fj79S170845;
        Thu, 3 Jun 2021 15:46:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=JqeuEbZiTIXjC3KOdhlbcdTYqDxBV/Ur9X+bVkW1dA0=;
 b=a6geYAtXFfh1waSU7eu0TlnYw1ZWG7KK7KR236BxQtK6P7R/BYZg+B9GbK8PiRh6CvQh
 N1sz8RfGOeyZc4Vnfyi9cv6AZDnt3kByk/V81oA1SSt4XdnO3/0x3ZoLe3X5LFrVG/lc
 fuhLWRz4v0typYv4Pf2g9K2OxneZ4lvHMStq3/36kUlaiZOBjHlF1cGp9tvHIlxg+4ME
 PQaxlnwW6mqnFVXZJ3foO951o2Ahpvfl9GUWG/b925kGVMMe888LKJDRDXHEAZVNDGYK
 TbGoed6V/6OHDjjLyN7N88VYx1GAWf/bY3GK7tdUBbYNMojdeUbnmPLG+tnvZqWW1Pl6 xQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38ub4cutfs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 15:46:39 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 153Fkb8W064827;
        Thu, 3 Jun 2021 15:46:39 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3030.oracle.com with ESMTP id 38ubneyfv7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 15:46:39 +0000
Received: from aserp3030.oracle.com (aserp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 153Fkcki064974;
        Thu, 3 Jun 2021 15:46:38 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 38ubneyfuf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 03 Jun 2021 15:46:38 +0000
Received: from abhmp0003.oracle.com (abhmp0003.oracle.com [141.146.116.9])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 153FkXVW006379;
        Thu, 3 Jun 2021 15:46:33 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 03 Jun 2021 15:46:33 +0000
Date:   Thu, 3 Jun 2021 18:46:25 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, Paul Blakey <paulb@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] net/mlx5: check for allocation failure in
 mlx5_ft_pool_init()
Message-ID: <20210603154625.GI1955@kadam>
References: <YLjNfHuTQ817oUtX@mwanda>
 <YLjVRjAyP3UpzgVr@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YLjVRjAyP3UpzgVr@unreal>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-GUID: zKS5juQhn23kX7cRcPi15XDD2LSxMgNc
X-Proofpoint-ORIG-GUID: zKS5juQhn23kX7cRcPi15XDD2LSxMgNc
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 mlxscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 phishscore=0 lowpriorityscore=0
 clxscore=1015 impostorscore=0 adultscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106030106
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 04:12:38PM +0300, Leon Romanovsky wrote:
> On Thu, Jun 03, 2021 at 03:39:24PM +0300, Dan Carpenter wrote:
> > Add a check for if the kzalloc() fails.
> > 
> > Fixes: 4a98544d1827 ("net/mlx5: Move chains ft pool to be used by all firmware steering")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c | 2 ++
> >  1 file changed, 2 insertions(+)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> > index 526fbb669142..c14590acc772 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_ft_pool.c
> > @@ -27,6 +27,8 @@ int mlx5_ft_pool_init(struct mlx5_core_dev *dev)
> >  	int i;
> >  
> >  	ft_pool = kzalloc(sizeof(*ft_pool), GFP_KERNEL);
> > +	if (!ft_pool)
> > +		return -ENOMEM;
> >  
> >  	for (i = ARRAY_SIZE(FT_POOLS) - 1; i >= 0; i--)
> >  		ft_pool->ft_left[i] = FT_SIZE / FT_POOLS[i];
> 
> 
> Dan thanks for your patch.
> 
> When reviewed your patch, I spotted another error in the patch from the Fixes line.
> 
>   2955         err = mlx5_ft_pool_init(dev);
>   2956         if (err)
>   2957                 return err;
>   2958
>   2959         steering = kzalloc(sizeof(*steering), GFP_KERNEL);
>   2960         if (!steering)
>   2961                 goto err;
>                        ^^^^^^^^ it will return success, while should return ENOMEM.

Smatch prints a static checker warning for this, but I never finished
going through the backlog of old "missing error code" warnings.  At one
point I was down to 38 warnings left but now I see that the backlog is
62 warnings so people are adding new bugs faster than I'm reviewing
them...  :P

I will take care of this tomorrow as a separate patch.  I will just
report or the other 61 warnings and get the backlog cleared out so that
I can start checking these better in the future.

regards,
dan carpenter

