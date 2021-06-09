Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61D013A0FA5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 11:28:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238026AbhFIJaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 05:30:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:50370 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237993AbhFIJaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 05:30:15 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599F4M9170872;
        Wed, 9 Jun 2021 09:28:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=sFRB38PhM3Ekerd+v4R3UAA8bG0qfH1+I7ZpFgJhBJw=;
 b=COylQu9qMY6lp5Y7V+RoGiQH6T+Q1Zwx32s0RqipC41mcKiGvA0EyVuFoXEGjncXuPtd
 sKGT1iJ46xpi1QW/D58jnsiQfsdDGRAqdXicF8Ee0gocqtQY+toEx88hMG733mps7m+8
 F3JRqre9T4JZVMqNzgug7D4XdSvQHEFQ3qV/mSkEGxgjvEvg1VpO18MHYx1XvZxT1oQa
 +/qTkkS2PDnCFylblJR0uUvrFwZoMFhk2iG1NkS+rajooFNK0+OaGC9owkUuBEy88ZBE
 hIeSfO1J64sLnNti3DznK7veke7qqLPAym0kkTwIEVvEo0aqWLzOAoGVWruaZxQucntz +g== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 3914quq3kf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:28:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1599P4D5128183;
        Wed, 9 Jun 2021 09:28:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3020.oracle.com with ESMTP id 390k1rs898-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:28:11 +0000
Received: from userp3020.oracle.com (userp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 1599SB0I138997;
        Wed, 9 Jun 2021 09:28:11 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3020.oracle.com with ESMTP id 390k1rs892-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Jun 2021 09:28:10 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 1599S5E5031717;
        Wed, 9 Jun 2021 09:28:05 GMT
Received: from kadam (/41.212.42.34)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 09 Jun 2021 02:28:04 -0700
Date:   Wed, 9 Jun 2021 12:27:57 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2][next] net: usb: asix: Fix less than zero comparison
 of a u16
Message-ID: <20210609092757.GF1955@kadam>
References: <20210608152249.160333-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608152249.160333-1-colin.king@canonical.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: QVXrQoM-CFcb2Tyn9bZFrzTPnJArQoeC
X-Proofpoint-GUID: QVXrQoM-CFcb2Tyn9bZFrzTPnJArQoeC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10009 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 spamscore=0 malwarescore=0 clxscore=1015 lowpriorityscore=0
 priorityscore=1501 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106090042
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 08, 2021 at 04:22:48PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The comparison of the u16 priv->phy_addr < 0 is always false because
> phy_addr is unsigned. Fix this by assigning the return from the call
> to function asix_read_phy_addr to int ret and using this for the
> less than zero error check comparison.
> 
> Addresses-Coverity: ("Unsigned compared against 0")
> Fixes: e532a096be0e ("net: usb: asix: ax88772: add phylib support")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/net/usb/asix_devices.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/net/usb/asix_devices.c b/drivers/net/usb/asix_devices.c
> index 57dafb3262d9..211c5a87eb15 100644
> --- a/drivers/net/usb/asix_devices.c
> +++ b/drivers/net/usb/asix_devices.c
> @@ -704,9 +704,10 @@ static int ax88772_init_phy(struct usbnet *dev)
>  	struct asix_common_private *priv = dev->driver_priv;
>  	int ret;
>  
> -	priv->phy_addr = asix_read_phy_addr(dev, true);
> -	if (priv->phy_addr < 0)
> +	ret = asix_read_phy_addr(dev, true);
> +	if (ret < 0)
>  		return priv->phy_addr;

		return ret;

regards,
dan carpenter

