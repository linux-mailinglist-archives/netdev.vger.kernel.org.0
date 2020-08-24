Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F115824FA1F
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 11:53:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgHXJxK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 05:53:10 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34620 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728271AbgHXJw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 05:52:59 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O9nAJn189449;
        Mon, 24 Aug 2020 09:52:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2020-01-29;
 bh=Ww/d3IUbFL+bGXtX95YfELstyo8GnB/9kJBk/e0Gx8s=;
 b=MBYlbK+P8G+ZDmi1DzhBHkCHRCma9SZCEJ4P2kLej2CFXFsQpCGZ4M8CX7Ir+oxt0e+8
 PBKRyrRS8kT34FxTEyN6kLqaJbYytJ57/vkEHRLzNKFlzNrLceQH6aFa22fh4fP9L5oc
 k2aTMmGDZ2/Z4DjoDC/tKM+2Lh2sseXM7R6YyqlMomZs/BA1jJSyvIYGCeLWWu9dmN5a
 z/+fRhMwIk0WU8ZdA+Gw8kqbTE9SHj+54oURR25DwCShw+JGZkgHVzyGww+vw/70ehHG
 aInYhNPc9QjqiojYwt4uITJBwEiCdV1rQK4HaylF6XYiq8kFP6JbuqBqAN9cI4sqIDE0 wg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 333w6tj4hh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 24 Aug 2020 09:52:52 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 07O9jD2c118769;
        Mon, 24 Aug 2020 09:50:51 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 333r9gy74n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 24 Aug 2020 09:50:51 +0000
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 07O9oo07023975;
        Mon, 24 Aug 2020 09:50:50 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 24 Aug 2020 02:50:49 -0700
Date:   Mon, 24 Aug 2020 12:50:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S . Miller" <davem@davemloft.net>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 01/12] staging: wfx: fix BA when device is AP and MFP is
 enabled
Message-ID: <20200824095042.GZ1793@kadam>
References: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200820155858.351292-1-Jerome.Pouiller@silabs.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2008240076
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9722 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 phishscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 clxscore=1011 mlxscore=0 lowpriorityscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008240076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 05:58:47PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> The protection of the management frames is mainly done by mac80211.
> However, frames for the management of the BlockAck sessions are directly
> sent by the device. These frames have to be protected if MFP is in use.
> So the driver has to pass the MFP configuration to the device.
> 
> Until now, the BlockAck management frames were completely unprotected
> whatever the status of the MFP negotiation. So, some devices dropped
> these frames.
> 
> The device has two knobs to control the MFP. One global and one per
> station. Normally, the driver should always enable global MFP. Then it
> should enable MFP on every station with which MFP was successfully
> negotiated. Unfortunately, the older firmwares only provide the
> global control.
> 
> So, this patch enable global MFP as it is exposed in the beacon. Then it
> marks every station with which the MFP is effective.
> 
> Thus, the support for the old firmwares is not so bad. It may only
> encounter some difficulties to negotiate BA sessions when the local
> device (the AP) is MFP capable (ieee80211w=1) but the station is not.
> The only solution for this case is to upgrade the firmware.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/sta.c | 22 +++++++++++++++++++++-
>  1 file changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/sta.c b/drivers/staging/wfx/sta.c
> index ad63332f690c..9c1c8223a49f 100644
> --- a/drivers/staging/wfx/sta.c
> +++ b/drivers/staging/wfx/sta.c
> @@ -434,7 +434,7 @@ int wfx_sta_add(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
>  	wvif->link_id_map |= BIT(sta_priv->link_id);
>  	WARN_ON(!sta_priv->link_id);
>  	WARN_ON(sta_priv->link_id >= HIF_LINK_ID_MAX);
> -	hif_map_link(wvif, sta->addr, 0, sta_priv->link_id);
> +	hif_map_link(wvif, sta->addr, sta->mfp ? 2 : 0, sta_priv->link_id);
>  
>  	return 0;
>  }
> @@ -474,6 +474,25 @@ static int wfx_upload_ap_templates(struct wfx_vif *wvif)
>  	return 0;
>  }
>  
> +static void wfx_set_mfp_ap(struct wfx_vif *wvif)
> +{
> +	struct sk_buff *skb = ieee80211_beacon_get(wvif->wdev->hw, wvif->vif);
> +	const int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
> +	const u16 *ptr = (u16 *)cfg80211_find_ie(WLAN_EID_RSN,
> +						 skb->data + ieoffset,
> +						 skb->len - ieoffset);
> +	const int pairwise_cipher_suite_count_offset = 8 / sizeof(u16);
> +	const int pairwise_cipher_suite_size = 4 / sizeof(u16);
> +	const int akm_suite_size = 4 / sizeof(u16);
> +
> +	if (ptr) {
> +		ptr += pairwise_cipher_suite_count_offset;
> +		ptr += 1 + pairwise_cipher_suite_size * *ptr;

The value of "*ptr" comes from skb->data.  How do we know that it
doesn't point to something beyond the end of the skb->data buffer?

> +		ptr += 1 + akm_suite_size * *ptr;
> +		hif_set_mfp(wvif, *ptr & BIT(7), *ptr & BIT(6));
> +	}
> +}

regards,
dan carpenter

