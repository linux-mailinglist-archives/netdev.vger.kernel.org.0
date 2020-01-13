Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A031A138D31
	for <lists+netdev@lfdr.de>; Mon, 13 Jan 2020 09:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbgAMItS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jan 2020 03:49:18 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49288 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728783AbgAMItR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jan 2020 03:49:17 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00D8mev4053829;
        Mon, 13 Jan 2020 08:49:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 content-transfer-encoding : in-reply-to; s=corp-2019-08-05;
 bh=lMx21tGcjb+jsEbRtABZz15Zz4x8qwLIqH7vx+tLHy0=;
 b=QAtIetbIzElkUUiTe/pxyaKmXwng6vbZ1v5NDNRT6l/qp1JS3dBkZkyiM/1dtc1qwIwu
 E0a6NJRrmGjM8dcXr8cuk449QA3F4Xj0ibSDrO/mtExqscsX5n9seKFhYEFRsx+GB7C0
 AIrxB2FjJM7mW6+0ihQhgU61iuQaQM+DoQISkaGyM5+8x2wAaChEZ7dnsu2VOVKxvIjM
 0yrNFv2/J/JzI6WzXtoRMzV1XPZjwKha7z7xssCN/3YOMkyHkA16kWehp54NBajgsBYl
 MoglJSF6brE6dEgxZZ8pXGfaaWpsEKuKBELD+XanouscNtmkghxuuMnxTdX109e6OsKt 4w== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2120.oracle.com with ESMTP id 2xf73tdgdy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 08:49:08 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id 00D8n4gM117794;
        Mon, 13 Jan 2020 08:49:08 GMT
Received: from aserv0122.oracle.com (aserv0122.oracle.com [141.146.126.236])
        by aserp3020.oracle.com with ESMTP id 2xfqvpxaen-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 13 Jan 2020 08:49:07 +0000
Received: from abhmp0019.oracle.com (abhmp0019.oracle.com [141.146.116.25])
        by aserv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 00D8m2Ue014690;
        Mon, 13 Jan 2020 08:48:02 GMT
Received: from kadam (/129.205.23.165)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 13 Jan 2020 00:48:01 -0800
Date:   Mon, 13 Jan 2020 11:47:53 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Colin King <colin.king@canonical.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Kernel Janitors <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] ath11k: avoid null pointer dereference when
 pointer band is null
Message-ID: <20200113084753.GA9510@kadam>
References: <05d5d54e035e4d69ad4ffb4a835a495a@huawei.com>
 <64797126-0c77-4c2c-ad2b-29d7af452c13@wanadoo.fr>
 <17571eee-9d72-98cb-00f5-d714a28b853b@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17571eee-9d72-98cb-00f5-d714a28b853b@wanadoo.fr>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9498 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-2001130074
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9498 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-2001130074
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 11, 2020 at 12:57:11PM +0100, Marion & Christophe JAILLET wrote:
> Le 11/01/2020 à 10:50, linmiaohe a écrit :
> > Colin Ian King<colin.king@canonical.com>  wrote：
> > > From: Colin Ian King<colin.king@canonical.com>
> > > 
> > > In the unlikely event that cap->supported_bands has neither WMI_HOST_WLAN_2G_CAP set or WMI_HOST_WLAN_5G_CAP set then pointer band is null and a null dereference occurs when assigning
> > > band->n_iftype_data.  Move the assignment to the if blocks to
> > > avoid this.  Cleans up static analysis warnings.
> > > 
> > > Addresses-Coverity: ("Explicit null dereference")
> > > Fixes: 9f056ed8ee01 ("ath11k: add HE support")
> > > Signed-off-by: Colin Ian King<colin.king@canonical.com>
> > > ---
> > > drivers/net/wireless/ath/ath11k/mac.c | 8 ++++----
> > > 1 file changed, 4 insertions(+), 4 deletions(-)
> > It looks fine for me. Thanks.
> > Reviewed-by: Miaohe Lin<linmiaohe@huawei.com>
> (sorry for incomplete mail and mailing list addresses, my newsreader ate
> them, and I cannot get the list from get_maintainer.pl because my (outdated)
> tree does not have ath11k/...
> I've only including the ones in memory of my mail writer.
> 
> Please forward if needed)
> 
> 
> Hi
> 
> Shouldn't there be a
> 
> |
> 
> - band->n_iftype_data  =  count; at the end of the patch if the assignment
> is *moved*? Without it, 'band' (as well as 'count') could be un-initialized,
> and lead to memory corruption. Just my 2c. CJ |

You must be looking at different code.  There is no uninitialized
variable.  The patched code looks like:

drivers/net/wireless/ath/ath11k/mac.c
  3520  static void ath11k_mac_setup_he_cap(struct ath11k *ar,
  3521                                      struct ath11k_pdev_cap *cap)
  3522  {
  3523          struct ieee80211_supported_band *band;
  3524          int count;
  3525  
  3526          if (cap->supported_bands & WMI_HOST_WLAN_2G_CAP) {
  3527                  count = ath11k_mac_copy_he_cap(ar, cap,
  3528                                                 ar->mac.iftype[NL80211_BAND_2GHZ],
  3529                                                 NL80211_BAND_2GHZ);
  3530                  band = &ar->mac.sbands[NL80211_BAND_2GHZ];
  3531                  band->iftype_data = ar->mac.iftype[NL80211_BAND_2GHZ];
  3532                  band->n_iftype_data = count;
  3533          }
  3534  
  3535          if (cap->supported_bands & WMI_HOST_WLAN_5G_CAP) {
  3536                  count = ath11k_mac_copy_he_cap(ar, cap,
  3537                                                 ar->mac.iftype[NL80211_BAND_5GHZ],
  3538                                                 NL80211_BAND_5GHZ);
  3539                  band = &ar->mac.sbands[NL80211_BAND_5GHZ];
  3540                  band->iftype_data = ar->mac.iftype[NL80211_BAND_5GHZ];
  3541                  band->n_iftype_data = count;
  3542          }
  3543  }

regards,
dan carpenter
