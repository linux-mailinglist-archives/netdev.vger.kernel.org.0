Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1162519C1DB
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 15:14:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388233AbgDBNN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 09:13:57 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54976 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726252AbgDBNN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 09:13:57 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032DDVA1190996;
        Thu, 2 Apr 2020 13:13:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=cPgjp8plBz+5xeGlKxEPhHfH4nRghiekg4XCPlfD6EQ=;
 b=FhPAq+EOO/vL/rHO1GfPFZiynh9g+fQVGhuV2wqZO04SHZV2N/EVKPeMTyUYJEaLEh9a
 QSjGn4u9K+vj1+b5zwKYE9sqY2nVEyk0y08yDRpcQRBpE+VNM8PMXv5AvezV1fx/oGJu
 TabgzxiBE+DTurCUMZR86x7hceQaW174hFEtHvZSvRsM2ij+11eDYcwAsifjqceFUZRI
 9L/+iFPhb0caeB8e4IVUj5WYG/iPXPlHb0SjHovmFvMTO2dlAkNbUd3cZJS+ILNhE1F0
 YEnUgXsNJXkB70mtflOYtZgVCb/as2HE6bHs5eQUkU7vtyDGZ5+rVZnIkV+L+o1LYIBp DQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 303yundwks-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 13:13:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 032DD08x086520;
        Thu, 2 Apr 2020 13:13:48 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 302g2jjsvv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Apr 2020 13:13:48 +0000
Received: from abhmp0005.oracle.com (abhmp0005.oracle.com [141.146.116.11])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 032DDkQ7022406;
        Thu, 2 Apr 2020 13:13:47 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 02 Apr 2020 06:13:46 -0700
Date:   Thu, 2 Apr 2020 16:13:39 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 08/32] staging: wfx: simplify hif_handle_tx_data()
Message-ID: <20200402131338.GS2001@kadam>
References: <20200401110405.80282-1-Jerome.Pouiller@silabs.com>
 <20200401110405.80282-9-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200401110405.80282-9-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9578 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 mlxscore=0
 adultscore=0 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020120
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9579 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 lowpriorityscore=0
 malwarescore=0 adultscore=0 priorityscore=1501 mlxlogscore=999 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004020120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 01:03:41PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The last argument of hif_handle_tx_data() was now unused. In add,
> hif_handle_tx_data() has nothing to do with HIF layer and should be
> renamed. Finally, it not convenient to pass a wfx_vif as parameter. It
> is easier to let hif_handle_tx_data() find the interface itself.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/queue.c | 19 ++++++++++---------
>  1 file changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/staging/wfx/queue.c b/drivers/staging/wfx/queue.c
> index 2553f77522d9..8647731e02c0 100644
> --- a/drivers/staging/wfx/queue.c
> +++ b/drivers/staging/wfx/queue.c
> @@ -319,13 +319,17 @@ bool wfx_tx_queues_is_empty(struct wfx_dev *wdev)
>  	return ret;
>  }
>  
> -static bool hif_handle_tx_data(struct wfx_vif *wvif, struct sk_buff *skb,
> -			       struct wfx_queue *queue)
> +static bool wfx_handle_tx_data(struct wfx_dev *wdev, struct sk_buff *skb)
>  {
>  	struct hif_req_tx *req = wfx_skb_txreq(skb);
>  	struct ieee80211_key_conf *hw_key = wfx_skb_tx_priv(skb)->hw_key;
>  	struct ieee80211_hdr *frame =
>  		(struct ieee80211_hdr *)(req->frame + req->data_flags.fc_offset);
> +	struct wfx_vif *wvif =
> +		wdev_to_wvif(wdev, ((struct hif_msg *)skb->data)->interface);
                                                      ^^^^^^^^^
This is on the TX side so it's probably okay, but one problem I have
noticed is that we do this on the RX side as well with checking that

	if (skb->len < sizeof(struct hif_msg))
		return -EINVAL;

So we could be reading beyond the end of the skb.  If we got really
unlucky it could lead to an Oops.

regards,
dan carpenter

