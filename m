Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 724B919C158
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 14:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388294AbgDBMop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 08:44:45 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52160 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgDBMoo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 08:44:44 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Chd3N166886;
        Thu, 2 Apr 2020 12:44:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=x0huE/mMZHIQWX72jbyNEykJLzeJMXHbcFXfDWa7dW8=;
 b=eLhW1G3fnRko1c0gC+a4HrxWT3w6rocUTn1ahYM4d/m6x2caVtqU3KnWEbttWtFq1mJE
 ulnN2MY701BLGRw93KKn6R8yduUz8/q5IHaZdM7W2NeDCnbelZ5CA8DmldsT7G06l8vO
 UcwUPkbAkT5VN53GD2z+gCBTkO4xNn8mQDEH7pblzF/Jl6LcYV8xKA9sckhbbWPP60wh
 sHGj8zh5KeACpkL9JJT2FqA0FUtaTC9KQqk2cw/je/mFA6v7LkGbDbg25lVVY4/KAsh9
 cRblsnS/UzvlghlxdqqQOpgitxx1gV2ebAN3dXjS9GdWxpHcvzef8yECuyGPsVJ8q4BD Ng== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 303yundr5r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 12:44:34 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032Cg8Ad064328;
        Thu, 2 Apr 2020 12:42:33 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 302ga2bw5k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 12:42:33 +0000
Received: from abhmp0006.oracle.com (abhmp0006.oracle.com [141.146.116.12])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032CgVxX006017;
        Thu, 2 Apr 2020 12:42:31 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 05:42:31 -0700
Date:   Thu, 2 Apr 2020 15:42:23 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 01/32] staging: wfx: add sanity checks to hif_join()
Message-ID: <20200402124223.GQ2001@kadam>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
 <20200401110405.80282-2-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401110405.80282-2-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004020116
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020116
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 01:03:34PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Add a few check on start of hif_join().
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/hif_tx.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/staging/wfx/hif_tx.c b/drivers/staging/wfx/hif_tx.c
> index 77bca43aca42..445906035e9d 100644
> --- a/drivers/staging/wfx/hif_tx.c
> +++ b/drivers/staging/wfx/hif_tx.c
> @@ -297,6 +297,8 @@ int hif_join(struct wfx_vif *wvif, const struct ieee80211_bss_conf *conf,
>  	struct hif_req_join *body = wfx_alloc_hif(sizeof(*body), &hif);
                             ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
We've got an allocation here.  It's a mistake to put the allocation in
the declaration block because you're going to forget to check for
failure.

>  
>  	WARN_ON(!conf->basic_rates);
> +	WARN_ON(sizeof(body->ssid) < ssidlen);

Put the variable on the left.  WARN_ON(ssidlen > sizeof(body->ssid)).
I'm not a big fan of adding this sort of debug code, just audit the
callers to see if it's possible or not.

I have audited the caller for you, and I believe that this condition
*is possible* so we need to return -EINVAL in this situation to prevent
memory corruption.

	if (ssidlen > sizeof(body->ssid))
		return -EINVAL;

> +	WARN(!conf->ibss_joined && !ssidlen, "joining an unknown BSS");
>  	body->infrastructure_bss_mode = !conf->ibss_joined;
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Potential NULL dererefence because of the unchecked allocation.

regards,
dan carpenter

