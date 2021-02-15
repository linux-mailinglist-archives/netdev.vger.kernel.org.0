Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9832531B5EC
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 09:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230010AbhBOIby (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 03:31:54 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:39234 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbhBOIbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 03:31:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11F8U15B046899;
        Mon, 15 Feb 2021 08:31:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=lNJhPUBe/qt7sRGgOxmCt7Nkroau6aBus260lcLM7Zw=;
 b=PwQw9apyCEReriD+DdUGRc5mQ2de27n9pOJXCRFum6FgUM0dhjC33xio5D3hBpGWJkde
 qKHvlWqlqihWSr2I/JTvob+OLFhVfNYlxgnU4V6lOIIT9mDtIVc4BEaHAlClHQkGNTOp
 jkhpLy5zuCW1RSg7DItbeF6D61N5xKqas9qs0WKfZUI5xLuNZZjRZR2H7roUnOJPmCfw
 5QqVCpFmXxcNPJu4Qv4h4JsVEVOtqrNZyKAn8yUz85GazSD2fRciv4MMe5tPBOWfqj68
 ffHyIDRXVAIz6gRWfrie2YH3MV8lDCfLNR6ZNCqJoSvOT4v4ZBPs4GmZrtg3nQrUFRT4 7g== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 36pd9a2p9e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 08:31:03 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11F8TtOS032943;
        Mon, 15 Feb 2021 08:31:01 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 36prpvah3h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 15 Feb 2021 08:31:01 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 11F8UxR1002778;
        Mon, 15 Feb 2021 08:30:59 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 15 Feb 2021 00:30:59 -0800
Date:   Mon, 15 Feb 2021 11:30:51 +0300
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
Message-ID: <20210215083050.GA2222@kadam>
References: <20200928174153.GA446008@mwanda>
 <3F057952-3C88-452F-BFC5-4DC2B87FAD67@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3F057952-3C88-452F-BFC5-4DC2B87FAD67@nvidia.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-IMR: 1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9895 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxlogscore=999
 phishscore=0 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150071
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9895 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 impostorscore=0
 mlxscore=0 phishscore=0 mlxlogscore=999 spamscore=0 bulkscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 adultscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102150071
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
> That was implement like that on purpose. If mlx5_tc_init_ct returns NULL it means the device doesn’t support CT offload which can happen with older devices or old FW on the devices.
> However, in this case we want to continue with the rest of the Tc initialization because we can still support other TC offloads. No need to fail the entire TC init in this case. Only if mlx5_tc_init_ct return err_ptr that means the tc init failed not because of lack of support but due to a real error and only then we want to fail the rest of the tc init.
> 
> Your change will break compatibility for devices/FW versions that don’t have CT offload support.
> 

When we have a function like this which is optional then returning NULL
is a special kind of success as you say.  Returning NULL should not
generate a warning message.  At the same time, if the user enables the
option and the code fails because we are low on memory then returning an
error pointer is the correct behavior.  Just because the feature is
optional does not mean we should ignore what the user told us to do.

This code never returns error pointers.  It always returns NULL/success
when an allocation fails.  That triggers the first static checker
warning from last year.  Now Smatch is complaining about a new static
checker warning:

drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:4754
mlx5e_tc_esw_init() warn: missing error code here? 'IS_ERR()' failed. 'err' = '0'

  4708  int mlx5e_tc_esw_init(struct rhashtable *tc_ht)
  4709  {
  4710          const size_t sz_enc_opts = sizeof(struct tunnel_match_enc_opts);
  4711          struct mlx5_rep_uplink_priv *uplink_priv;
  4712          struct mlx5e_rep_priv *rpriv;
  4713          struct mapping_ctx *mapping;
  4714          struct mlx5_eswitch *esw;
  4715          struct mlx5e_priv *priv;
  4716          int err = 0;
  4717  
  4718          uplink_priv = container_of(tc_ht, struct mlx5_rep_uplink_priv, tc_ht);
  4719          rpriv = container_of(uplink_priv, struct mlx5e_rep_priv, uplink_priv);
  4720          priv = netdev_priv(rpriv->netdev);
  4721          esw = priv->mdev->priv.eswitch;
  4722  
  4723          uplink_priv->ct_priv = mlx5_tc_ct_init(netdev_priv(priv->netdev),
  4724                                                 esw_chains(esw),
  4725                                                 &esw->offloads.mod_hdr,
  4726                                                 MLX5_FLOW_NAMESPACE_FDB);
  4727          if (IS_ERR(uplink_priv->ct_priv))
  4728                  goto err_ct;

If mlx5_tc_ct_init() fails, which it should do if kmalloc() fails but
currently it does not, then the error should be propagated all the way
back.  So this code should preserve the error code instead of returning
success.

  4729  
  4730          mapping = mapping_create(sizeof(struct tunnel_match_key),
  4731                                   TUNNEL_INFO_BITS_MASK, true);

regards,
dan carpenter

