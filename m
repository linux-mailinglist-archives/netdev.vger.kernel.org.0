Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C530F12F603
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 10:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727468AbgACJVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 04:21:41 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:36388 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725972AbgACJVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 04:21:41 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0039JSOL147608;
        Fri, 3 Jan 2020 09:21:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=bkC+gH1gD70/cKhu2SkRir3vZoci85ALB0n5zKjNm3A=;
 b=E9vg9kmgQfkLWml1NQoxKfNmZyH9oTPOUolivhsXlWGzKH4Ep+g0WmmexnDI8rmeUCYU
 rGMg9oeKM0eVxzejBxqZWZi2fDdEC4ZxSMOb7b9rhNFj6iJRx50ZFLFX+3oPSGu6LFGx
 C3poSDXrvvTq58ygWynFXEt19j0/cKxBDOSdfoQMy7pG6P4dD0+ESCL/Wu2x4oJGcORk
 nuGQf+sMSsVTTEHbKWQzAxEZhBtDd0/A2BOy/G7XM1Ff/dLRHwCjP7v79mOTlF/HAz+D
 6AA+Bk3iwqvUo0/25bROi2m6UQ2TafscFE1aw/RLtQrarwfcAkgaEY/7joOoT/nmp9BV Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 2x5ypqubqj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 09:21:29 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 0039JL6v002296;
        Fri, 3 Jan 2020 09:21:28 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by aserp3030.oracle.com with ESMTP id 2x9jm766xj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jan 2020 09:21:28 +0000
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 0039LQRH012272;
        Fri, 3 Jan 2020 09:21:26 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Fri, 03 Jan 2020 01:21:25 -0800
Date:   Fri, 3 Jan 2020 12:21:16 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     =?iso-8859-1?B?Suly9G1l?= Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 13/55] staging: wfx: avoid double warning when no more tx
 policy are available
Message-ID: <20200103092116.GB3911@kadam>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <20191216170302.29543-14-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20191216170302.29543-14-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=2 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001030088
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9488 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=2 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001030088
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 16, 2019 at 05:03:40PM +0000, Jérôme Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Currently, number of available tx retry policies is checked two times.
> Only one is sufficient.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/data_tx.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/data_tx.c b/drivers/staging/wfx/data_tx.c
> index 32e269becd75..c9dea627661f 100644
> --- a/drivers/staging/wfx/data_tx.c
> +++ b/drivers/staging/wfx/data_tx.c
> @@ -169,7 +169,8 @@ static int wfx_tx_policy_get(struct wfx_vif *wvif,
>  	wfx_tx_policy_build(wvif, &wanted, rates);
>  
>  	spin_lock_bh(&cache->lock);
> -	if (WARN_ON(list_empty(&cache->free))) {
> +	if (list_empty(&cache->free)) {
> +		WARN(1, "unable to get a valid Tx policy");
>  		spin_unlock_bh(&cache->lock);
>  		return WFX_INVALID_RATE_ID;

This warning is more clear than the original which is good, but that's
not what the commit message says.  How does this fix a double warning?

regards,
dan carpenter

