Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 161289AE07
	for <lists+netdev@lfdr.de>; Fri, 23 Aug 2019 13:24:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732768AbfHWLX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 07:23:57 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:39274 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732503AbfHWLX5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 07:23:57 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NBNlkR149956;
        Fri, 23 Aug 2019 11:23:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=SdNd7drI7dBuyeCQbZ8YKtn/6WhBqgp8Qth2Lct/Uqc=;
 b=RD8NISLgLJq2hDUy6AQZt1HKW0j2MUCmqL8gi6dxto3Bw5KU9ov5bn7QBZBtiLQDN9aA
 kiIELxEoOwKbUjloR2wllpTKSrsmiLI3JPcSFNLhqWlVMGNqHGQMNPomGt1nforqbqTJ
 kudhmuXPv6FmXtaIqbdkr0ya+lgMdsC+OGmAMcVmbEYflG+4ROM5e5FBDNfHu7qvPTXW
 Yt7ZPOaFgD8Bck6ujNbXw95IrjTXzoBCfG3aI1Ee/e2pZ7V+TT/HX+CV/HnYrdB9K/v4
 mNtUxJ5oTO6Vqri9Jv5hiaKk6IDAh7oWRXZIqTqRIKhZCibl4JRZFGHHN/eSfB2hSq6M pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2120.oracle.com with ESMTP id 2uea7rc6je-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 11:23:47 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x7NBNSCQ011888;
        Fri, 23 Aug 2019 11:23:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3020.oracle.com with ESMTP id 2uj1y0dqnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 23 Aug 2019 11:23:46 +0000
Received: from abhmp0013.oracle.com (abhmp0013.oracle.com [141.146.116.19])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x7NBNjpX028469;
        Fri, 23 Aug 2019 11:23:46 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 23 Aug 2019 04:23:45 -0700
Date:   Fri, 23 Aug 2019 14:23:37 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wimax/i2400m: fix calculation of index, remove sizeof
Message-ID: <20190823112337.GB23408@kadam>
References: <20190823085230.6225-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190823085230.6225-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1906280000 definitions=main-1908230121
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9357 signatures=668684
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1906280000
 definitions=main-1908230121
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 23, 2019 at 09:52:30AM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The subtraction of the two pointers is automatically scaled by the
> size of the size of the object the pointers point to, so the division
> by sizeof(*i2400m->barker) is incorrect.  Fix this by removing the
> division.  Also make index an unsigned int to clean up a checkpatch
> warning.
> 
> Addresses-Coverity: ("Extra sizeof expression")
> Fixes: aba3792ac2d7 ("wimax/i2400m: rework bootrom initialization to be more flexible")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/wimax/i2400m/fw.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/wimax/i2400m/fw.c b/drivers/net/wimax/i2400m/fw.c
> index 489cba9b284d..599a703af6eb 100644
> --- a/drivers/net/wimax/i2400m/fw.c
> +++ b/drivers/net/wimax/i2400m/fw.c
> @@ -399,8 +399,7 @@ int i2400m_is_boot_barker(struct i2400m *i2400m,
>  	 * associated with the device. */
>  	if (i2400m->barker
>  	    && !memcmp(buf, i2400m->barker, sizeof(i2400m->barker->data))) {
> -		unsigned index = (i2400m->barker - i2400m_barker_db)
> -			/ sizeof(*i2400m->barker);
> +		unsigned int index = i2400m->barker - i2400m_barker_db;
>  		d_printf(2, dev, "boot barker cache-confirmed #%u/%08x\n",
>  			 index, le32_to_cpu(i2400m->barker->data[0]));

It's only used for this debug output.  You may as well just delete it.

>  		return 0;

regards,
dan carpenter

