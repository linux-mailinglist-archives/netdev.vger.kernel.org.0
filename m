Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E469388EF9
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 15:23:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353628AbhESNYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 09:24:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52874 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353607AbhESNYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 09:24:36 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JDElrk071678;
        Wed, 19 May 2021 13:23:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=dbAsbTNAyldJwWwMuFtj3r4hxMZRTSguPdcI1GwuH40=;
 b=QdZz0Hl5nSa/Uidj0tHMSBFSy6gyXsI92GrC9zwpbEnjjedIXACf6npMcVuM007gTY1F
 8mFIVNha5mrJu/Da14dcFv3orE/bqo45GEBm107ZSDvd1GtaWIvJ6qegcA7w4dBBBjDf
 cuIzhjlQIFNq/rnkzOpGuaSpG3Jq6sf5Homqmw1mM6cZKMW/cZ+gR/QQulk9PipE+50I
 datebS1R4cej8aicCtqS3EpgH0ivUC5fLjSV8MCG1txFk2ZAJmImiAIJMq93QTVAVmVh
 3M6oBzrGZ8dODFowUUYiVpydDGxRsWvWRBwT+FBob4kTD2pXMggZVzEDvCuMc6PGva3n hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 38j68mhgt7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 13:23:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14JDGO5S088832;
        Wed, 19 May 2021 13:23:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38megkfkf7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 13:23:13 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14JDI4mH092986;
        Wed, 19 May 2021 13:23:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 38megkfket-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 19 May 2021 13:23:13 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14JDNBf4026975;
        Wed, 19 May 2021 13:23:12 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 19 May 2021 06:23:11 -0700
Date:   Wed, 19 May 2021 16:23:04 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Johan Hovold <johan@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: hso: bail out on interrupt URB allocation
 failure
Message-ID: <20210519132304.GD32682@kadam>
References: <20210519124717.31144-1-johan@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210519124717.31144-1-johan@kernel.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: uETD26MYV9CbyQCB8OZIdC9rxmvomalP
X-Proofpoint-GUID: uETD26MYV9CbyQCB8OZIdC9rxmvomalP
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9988 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105190082
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 19, 2021 at 02:47:17PM +0200, Johan Hovold wrote:
> Commit 31db0dbd7244 ("net: hso: check for allocation failure in
> hso_create_bulk_serial_device()") recently started returning an error
> when the driver fails to allocate resources for the interrupt endpoint
> and tiocmget functionality.
> 
> For consistency let's bail out from probe also if the URB allocation
> fails.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>
> ---
>  drivers/net/usb/hso.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
> index 260f850d69eb..b48b2a25210c 100644
> --- a/drivers/net/usb/hso.c
> +++ b/drivers/net/usb/hso.c
> @@ -2635,14 +2635,14 @@ static struct hso_device *hso_create_bulk_serial_device(
>  		}
>  
>  		tiocmget->urb = usb_alloc_urb(0, GFP_KERNEL);
> -		if (tiocmget->urb) {
> -			mutex_init(&tiocmget->mutex);
> -			init_waitqueue_head(&tiocmget->waitq);
> -		} else
> -			hso_free_tiomget(serial);

Thanks!  The original code works, but it's so suspicious looking because
you would think hso_free_tiomget() lead to a use after free later.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter
