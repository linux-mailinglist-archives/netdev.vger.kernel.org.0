Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76B6BD1DD5
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 03:06:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732228AbfJJBGx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 21:06:53 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:47024 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731155AbfJJBGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 21:06:53 -0400
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.42/8.16.0.42) with SMTP id x9A16cSO028962;
        Thu, 10 Oct 2019 02:06:47 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=jan2016.eng;
 bh=KMTjYIaI2AwIG7Czpwdsb0nAWot+utHPdTrA+4IOSCc=;
 b=L8ghfgcHq8kgUj75E7xLosN2INEw/el7v5hW1RH+lXbJ8QdK/qYIaD/xg0dbu+8HkFam
 n/FEp7LddMEgsxrVP2Vrp+K7MSN9JnylPa6jDIMic6r9BVJ5aZWsi/YOLbNzZNRBsP8s
 Gs6skWlPyGIj5AVy4FMdNEV5UOP3Idp6eiyi3iu0FTW+YQTX7UXdKzuRozeinQQ85n5L
 c10Sz1cgSoDAmUskQd4B9uwpiDWGekFIkTdT1fY/Ym8ITLDtzGOGGMgUA3/49Jh6r0u+
 /kQlBm6OuaBbn2ab5MVShpIYFIEFiBjDg8tgEtvzAvVuy7DivUqKLXCE97stdfuNfs1r eA== 
Received: from prod-mail-ppoint3 (prod-mail-ppoint3.akamai.com [96.6.114.86] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 2vejq51rrc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 10 Oct 2019 02:06:47 +0100
Received: from pps.filterd (prod-mail-ppoint3.akamai.com [127.0.0.1])
        by prod-mail-ppoint3.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x9A124X1023618;
        Wed, 9 Oct 2019 21:06:46 -0400
Received: from prod-mail-relay14.akamai.com ([172.27.17.39])
        by prod-mail-ppoint3.akamai.com with ESMTP id 2veph09tq3-1;
        Wed, 09 Oct 2019 21:06:45 -0400
Received: from [0.0.0.0] (prod-ssh-gw02.sanmateo.corp.akamai.com [172.22.187.166])
        by prod-mail-relay14.akamai.com (Postfix) with ESMTP id 8008A80D1A;
        Thu, 10 Oct 2019 01:06:45 +0000 (GMT)
Subject: Re: [PATCH 2/3] ixgbe: Add UDP segmentation offload support
To:     netdev@vger.kernel.org, willemb@google.com,
        intel-wired-lan@lists.osuosl.org
Cc:     Alexander Duyck <alexander.h.duyck@intel.com>
References: <1570658777-13459-1-git-send-email-johunt@akamai.com>
 <1570658777-13459-3-git-send-email-johunt@akamai.com>
From:   Josh Hunt <johunt@akamai.com>
Message-ID: <22506786-c429-df87-54cb-c1c83b1b445b@akamai.com>
Date:   Wed, 9 Oct 2019 18:06:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1570658777-13459-3-git-send-email-johunt@akamai.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-10-09_11:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1908290000 definitions=main-1910100007
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-09_11:2019-10-08,2019-10-09 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 bulkscore=0 adultscore=0 mlxlogscore=999
 spamscore=0 clxscore=1015 impostorscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910100008
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/9/19 3:06 PM, Josh Hunt wrote:
> Repost from a series by Alexander Duyck to add UDP segmentation offload
> support to the igb driver:
> https://lore.kernel.org/netdev/20180504003916.4769.66271.stgit@localhost.localdomain/
> 
> CC: Alexander Duyck <alexander.h.duyck@intel.com>
> CC: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Josh Hunt <johunt@akamai.com>
> ---
>   drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 24 +++++++++++++++++++-----
>   1 file changed, 19 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> index 1ce2397306b9..2b01d264e5ce 100644
> --- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> +++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
> @@ -7946,6 +7946,7 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
>   	} ip;
>   	union {
>   		struct tcphdr *tcp;
> +		struct udphdr *udp;
>   		unsigned char *hdr;
>   	} l4;
>   	u32 paylen, l4_offset;
> @@ -7969,6 +7970,9 @@ static int ixgbe_tso(struct ixgbe_ring *tx_ring,
>   	l4.hdr = skb_checksum_start(skb);
>   
>   	/* ADV DTYP TUCMD MKRLOC/ISCSIHEDLEN */
> +	type_tucmd = (skb->csum_offset == offsetof(struct tcphdr, check)) ?
> +		      IXGBE_ADVTXD_TUCMD_L4T_TCP : IXGBE_ADVTXD_TUCMD_L4T_UDP;
> +
>   	type_tucmd = IXGBE_ADVTXD_TUCMD_L4T_TCP;

Copy/paste bug ^^. Will fix in v2.

Josh
