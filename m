Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2C027B4D3
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 20:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgI1SvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 14:51:25 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:48508 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726393AbgI1SvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 14:51:23 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SId0Rs144305;
        Mon, 28 Sep 2020 18:51:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=XlFlUHXTSXGBBDz6CdWohHjZKHnYselNdQIW5q45TnA=;
 b=uRPXvG2gr0Q+6Pw1Ed61b3th96SjDpS5NRmCgmQ8nWPFg/C4gSfU/jB4TamUZJCW1cGx
 nOiKQwOhlzTNN8K+kp7qYS8h3Q6JhYINtg1IIBd4I+oOx2i3PhVdu8b1p+dAFNj0Ek5C
 2tAX9s/HpYrv/DT7sR2dzBsWHUwIVOi58ow4RQexYnPVZuNArWENgCsP5rA66CymXBme
 Zz2zVZ276WKCCKnk1Nzm/bcMXs9EVecWSsEQb/twiKgI8nzCEP27jtBI7BVPm4GJRDNo
 xKrTk1N3q3AdkHyQmBLbsLZ0mtWBcK93g0J80IvOs2yj9ZcsBm2wv7e99jgoCLPQX3jI Zg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 33sx9mxpxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 28 Sep 2020 18:51:15 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 08SIenGi117463;
        Mon, 28 Sep 2020 18:51:14 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 33tf7kps3r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 28 Sep 2020 18:51:14 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 08SIpB5D000887;
        Mon, 28 Sep 2020 18:51:11 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 28 Sep 2020 11:51:11 -0700
Date:   Mon, 28 Sep 2020 21:51:03 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Ariel Levkovich <lariel@nvidia.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 1/2 net-next] net/mlx5e: TC: Fix IS_ERR() vs NULL checks
Message-ID: <20200928185103.GT4282@kadam>
References: <20200928174153.GA446008@mwanda>
 <3F057952-3C88-452F-BFC5-4DC2B87FAD67@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3F057952-3C88-452F-BFC5-4DC2B87FAD67@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 malwarescore=0 phishscore=0 bulkscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2009280143
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9758 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 phishscore=0 mlxscore=0 lowpriorityscore=0 adultscore=0 clxscore=1015
 spamscore=0 impostorscore=0 malwarescore=0 bulkscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2009280143
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 28, 2020 at 06:31:04PM +0000, Ariel Levkovich wrote:
> On Sep 28, 2020, at 13:42, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > 
> > ﻿The mlx5_tc_ct_init() function doesn't return error pointers it returns
> > NULL.  Also we need to set the error codes on this path.
> > 
> > Fixes: aedd133d17bc ("net/mlx5e: Support CT offload for tc nic flows")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 8 ++++++--
> > 1 file changed, 6 insertions(+), 2 deletions(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index 104b1c339de0..438fbcf478d1 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -5224,8 +5224,10 @@ int mlx5e_tc_nic_init(struct mlx5e_priv *priv)
> > 
> >    tc->ct = mlx5_tc_ct_init(priv, tc->chains, &priv->fs.tc.mod_hdr,
> >                 MLX5_FLOW_NAMESPACE_KERNEL);
> > -    if (IS_ERR(tc->ct))
> > +    if (!tc->ct) {
> > +        err = -ENOMEM;
> >        goto err_ct;
> > +    }
> 
> Hi Dan,
> That was implement like that on purpose. If mlx5_tc_init_ct returns
> NULL it means the device doesn’t support CT offload which can happen
> with older devices or old FW on the devices.
> However, in this case we want to continue with the rest of the Tc
> initialization because we can still support other TC offloads. No
> need to fail the entire TC init in this case. Only if mlx5_tc_init_ct
> return err_ptr that means the tc init failed not because of lack of
> support but due to a real error and only then we want to fail the rest
> of the tc init.
> 
> Your change will break compatibility for devices/FW versions that
> don’t have CT offload support.
> 

I should have looked at this more closely.  It seems the bug is in
mlx5_tc_ct_init().

drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
  1897  struct mlx5_tc_ct_priv *
  1898  mlx5_tc_ct_init(struct mlx5e_priv *priv, struct mlx5_fs_chains *chains,
  1899                  struct mod_hdr_tbl *mod_hdr,
  1900                  enum mlx5_flow_namespace_type ns_type)
  1901  {
  1902          struct mlx5_tc_ct_priv *ct_priv;
  1903          struct mlx5_core_dev *dev;
  1904          const char *msg;
  1905          int err;
  1906  
  1907          dev = priv->mdev;
  1908          err = mlx5_tc_ct_init_check_support(priv, ns_type, &msg);
  1909          if (err) {
  1910                  mlx5_core_warn(dev,
  1911                                 "tc ct offload not supported, %s\n",
  1912                                 msg);
  1913                  goto err_support;

This should probably return NULL and it does.

  1914          }
  1915  
  1916          ct_priv = kzalloc(sizeof(*ct_priv), GFP_KERNEL);
  1917          if (!ct_priv)
  1918                  goto err_alloc;

This should probably return an ERR_PTR(-ENOMEM) but it instead returns
NULL.

  1919  
  1920          ct_priv->zone_mapping = mapping_create(sizeof(u16), 0, true);
  1921          if (IS_ERR(ct_priv->zone_mapping)) {
  1922                  err = PTR_ERR(ct_priv->zone_mapping);
  1923                  goto err_mapping_zone;
                        ^^^^^^^^^^^^^^^^^^^^^^
This sets "err" but it still returns NULL.

Then in the caller if the mlx5_tc_ct_init() call returns an error
pointer, it should set the error code.  (NULL is a special case of
success etc).

Can you fix this and give me a reported-by tag?  I think my new analysis
is correct...

regards,
dan carpenter
