Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 074423FD0BF
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 03:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241500AbhIABdZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 21:33:25 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58494 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234036AbhIABdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 21:33:21 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 18112Zmp123416
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:32:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=bYzcYjyWBc/agk0GbHV9JMDn0N9SFvVfMNXkSSKpshA=;
 b=H1jjX/kgKYT8s+HMR60ZsZsx08xpd85cvabRNuuzaQDvUmePodJi00gXP4c5vWQU4gGw
 LhW64q/6fu/oDtMGyPpMfoINhcYnzBR3idUxiYGpetTxgadzl4813fqf49KLYe+Ked7D
 0fG1bk8jjL8PeEdlDSciag6ZiR49WyfawvWjsZ+u7++z4eelKBicXfmOuI4TCKsq/509
 6EET2/XiDauApvCW5JAdjI/9N3bc7BU9k15ZJ1DBTqC+jWDi5Xv5wlBX8Oh10Ga5gdpp
 qm1e5y5D+t0GQl8mjeR1MxFRA+Q/PA+AhThyhU9r/80izyhO+aS4jMGhRELCLXVkHWm5 rQ== 
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3aswpwapg4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 21:32:24 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1811RpFq017638
        for <netdev@vger.kernel.org>; Wed, 1 Sep 2021 01:32:24 GMT
Received: from b03cxnp07027.gho.boulder.ibm.com (b03cxnp07027.gho.boulder.ibm.com [9.17.130.14])
        by ppma01dal.us.ibm.com with ESMTP id 3astd103uc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 01:32:24 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1811WMoe30933476
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 1 Sep 2021 01:32:22 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 729FDBE056;
        Wed,  1 Sep 2021 01:32:22 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09DB5BE04F;
        Wed,  1 Sep 2021 01:32:21 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed,  1 Sep 2021 01:32:21 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 31 Aug 2021 18:32:21 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        cforno12@linux.ibm.com, Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net-next 5/9] ibmvnic: init_tx_pools move loop-invariant
 code out
In-Reply-To: <20210901000812.120968-6-sukadev@linux.ibm.com>
References: <20210901000812.120968-1-sukadev@linux.ibm.com>
 <20210901000812.120968-6-sukadev@linux.ibm.com>
Message-ID: <57a9c388b925ad9ba9336a0f6dd73b5e@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: NfswA6RlLwQ6Me6Ec5fTB9dc1G8ZQZTF
X-Proofpoint-GUID: NfswA6RlLwQ6Me6Ec5fTB9dc1G8ZQZTF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-31_10:2021-08-31,2021-08-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 adultscore=0
 clxscore=1015 bulkscore=0 mlxscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 impostorscore=0 spamscore=0 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2109010005
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-08-31 17:08, Sukadev Bhattiprolu wrote:
> In init_tx_pools() move some loop-invariant code out of the loop.
> 
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 4c6739b250df..8894afdb3cb3 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -839,11 +839,10 @@ static int init_tx_pools(struct net_device 
> *netdev)
>  	 * allocation, release_tx_pools() will know how many to look for.
>  	 */
>  	adapter->num_active_tx_pools = num_pools;
> +	buff_size = adapter->req_mtu + VLAN_HLEN;
> +	buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> 
>  	for (i = 0; i < num_pools; i++) {
> -		buff_size = adapter->req_mtu + VLAN_HLEN;
> -		buff_size = ALIGN(buff_size, L1_CACHE_BYTES);
> -
>  		dev_dbg(dev, "Init tx pool %d [%llu, %llu]\n",
>  			i, adapter->req_tx_entries_per_subcrq, buff_size);
