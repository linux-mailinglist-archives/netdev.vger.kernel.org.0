Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5506B18F254
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 11:02:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbgCWKCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 06:02:35 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51942 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727809AbgCWKCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 06:02:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02N9tfgU009650;
        Mon, 23 Mar 2020 10:02:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=mMG7dvfUB+0AmeYy+0Q1hFybzDI3+DQAX7xSQz0D3zc=;
 b=VCB/lLjYyK8y7TE7SsuQ/NDDW1xWI5mqzqE7Q8oI0yspCLaayurNU8YfgM2VcraEh6jg
 lT/we+UI4VN7fsbGzFCf62rv8KU8RQWi9xTr+y0OijSh55CtzF6hSEzaiJYutz6fM80m
 rgj/t1FXqS2R4nlFtU0QljZ4MQhWq5eeZZ0ZKstNzF7vp9Y5xsQPIFx/StIb1okS0twq
 AChygfUI9kFeutE7uN3Qr8263/2HO+Kxs1e470hEsfupd14jqugoR7DeEZggbHcel1Sm
 YM5XAzLtcvjdGUC6hvuYw/TrG0rCOg2OTfCEWl0btBl17XZf1hNc02jMp3vDajNssn36 xA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2ywabqwp4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 10:02:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02N9quXq024518;
        Mon, 23 Mar 2020 10:02:25 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3030.oracle.com with ESMTP id 2ywwuhqayr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 23 Mar 2020 10:02:25 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02NA2Onl013398;
        Mon, 23 Mar 2020 10:02:24 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 23 Mar 2020 03:02:23 -0700
Date:   Mon, 23 Mar 2020 13:02:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     Paul Blakey <paulb@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Roi Dayan <roid@mellanox.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Oz Shlomo <ozsh@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: Fix actions_match_supported() return
Message-ID: <20200323100215.GB26299@kadam>
References: <20200320132305.GB95012@mwanda>
 <35fcb57643c0522b051318e75b106100422fb1dc.camel@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35fcb57643c0522b051318e75b106100422fb1dc.camel@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003230058
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003230058
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 21, 2020 at 02:43:08AM +0000, Saeed Mahameed wrote:
> On Fri, 2020-03-20 at 16:23 +0300, Dan Carpenter wrote:
> > The actions_match_supported() function returns a bool, true for
> > success
> > and false for failure.  This error path is returning a negative which
> > is cast to true but it should return false.
> > 
> > Fixes: 4c3844d9e97e ("net/mlx5e: CT: Introduce connection tracking")
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> >  drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > index 044891a03be3..e5de7d2bac2b 100644
> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
> > @@ -3058,7 +3058,7 @@ static bool actions_match_supported(struct
> > mlx5e_priv *priv,
> >  			 */
> >  			NL_SET_ERR_MSG_MOD(extack,
> >  					   "Can't offload mirroring
> > with action ct");
> > -			return -EOPNOTSUPP;
> > +			return false;
> >  		}
> >  	} else {
> >  		actions = flow->nic_attr->action;
> 
> applied to net-next-mlx5 

I can never figure out which tree these are supposed to be applied to.
:(  Is there a trick to it?

regards,
dan carpenter

