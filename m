Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCD039B7C6
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 13:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbhFDLTy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 07:19:54 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:42648 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhFDLTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 07:19:53 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154BEeLu138655;
        Fri, 4 Jun 2021 11:17:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=MMylIK4zseFUYz5Hll2RNkGfjyxVdtOYHdtIFMXc2nI=;
 b=lZyywsosM509WEkkRffBwIktLSeSXtERcYoa6LF/eACACUnr6DwV92pYDV8CVXkA3Ypx
 00tsUdwCgYE8MhsQ3acljZr7drlDuV6egSTI/D8G5W3sDKyDv4M3Zb2X6ncXMi22Wqrp
 VDXDC2JmqjmutJSNxcOmWB4iwstS2kHRRN8U6e17vRhpJnEheTks+WkzN2YJS+Su0HzF
 aYHCkFfFabeEPuEe30Bl55Rz/3Gluyl76EbQMH996zzI47VSw5S2+fiD6Rz0B3E/0Sh5
 zrzoCv3wvH1yShDhWszuI5ItQ4M51zHpuyhsnq2B6kozzeZkQxn1BhKoluYV1M96QuDW mg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38ud1snp7m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 11:17:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 154BGkqt137024;
        Fri, 4 Jun 2021 11:17:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 38x1beup0j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 11:17:55 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 154BHsH4138103;
        Fri, 4 Jun 2021 11:17:54 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3020.oracle.com with ESMTP id 38x1beup0c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 04 Jun 2021 11:17:54 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 154BHrqT020566;
        Fri, 4 Jun 2021 11:17:53 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 04 Jun 2021 04:17:52 -0700
Date:   Fri, 4 Jun 2021 14:17:41 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Dmytro Linkin <dlinkin@nvidia.com>,
        Yuval Avnery <yuvalav@nvidia.com>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netdevsim: Fix unsigned being compared to less
 than zero
Message-ID: <20210604111741.GK1955@kadam>
References: <20210603215657.154776-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603215657.154776-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: donZffhOxdxd-RccTzL0OET_5nhH8K7Q
X-Proofpoint-GUID: donZffhOxdxd-RccTzL0OET_5nhH8K7Q
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10004 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 lowpriorityscore=0 mlxlogscore=999
 malwarescore=0 clxscore=1011 spamscore=0 impostorscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106040089
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 10:56:57PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of len < 0 is always false because len is a size_t. Fix
> this by making len a ssize_t instead.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: d395381909a3 ("netdevsim: Add max_vfs to bus_dev")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/netdevsim/bus.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> index b56003dfe3cc..ccec29970d5b 100644
> --- a/drivers/net/netdevsim/bus.c
> +++ b/drivers/net/netdevsim/bus.c
> @@ -111,7 +111,7 @@ ssize_t nsim_bus_dev_max_vfs_read(struct file *file,
>  {
>  	struct nsim_bus_dev *nsim_bus_dev = file->private_data;
>  	char buf[11];
> -	size_t len;
> +	ssize_t len;
>  
>  	len = snprintf(buf, sizeof(buf), "%u\n", nsim_bus_dev->max_vfs);
>  	if (len < 0)

The snprintf() in the kernel can't return negatives, but if there isn't
enough space then it returns >= sizeof(buf) so this would lead to an
information leak.  So the right thing to do is change it to scnprintf()
and delete the check if (len < 0) check.

regards,
dan carpenter

