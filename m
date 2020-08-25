Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6881E251A0C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 15:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgHYNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:46:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49384 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726737AbgHYNq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 09:46:27 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 07PDXi1p153000;
        Tue, 25 Aug 2020 09:46:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=1Rp0P65mclnfxjQiUt++LdLKDCUo12LE/UVwbCf+g00=;
 b=i8z9Dab3k703PwN4I5VmM+rzVRNT0lmkvhfbTZMupko4CDnNNjLiw9OwSBKennmxWmDj
 doJEKBwzpaqSqwkonp7p7WIX+crruQTzDodg/9Bm6LfWDq6YIrIXqzLuepwsgY44pkDC
 v22BiBi7iBjPMsTdhyGF73nRnWBD/5ULrXgkXxTgf/L8skJ+vsooArNn5oa4wYh7uhLd
 TLamEA3fIfBaL/ojuyqSYn0EiZ3OsfeE7fo5bZrP6cuiw0XLEuJt5NbiGlMtIWONJSfT
 SK0WFHFmd+yrYaFn9hzUSovWe6rfkLGd0jQTimJZZIQPKOOs9Nc8lfl8db8KIDH1UxxD tA== 
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3353kw8eae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 09:46:13 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 07PDh4OJ004459;
        Tue, 25 Aug 2020 13:46:12 GMT
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by ppma01wdc.us.ibm.com with ESMTP id 332uwa9snw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Aug 2020 13:46:12 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 07PDkC1X55050558
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Aug 2020 13:46:12 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id EFD6AAE062;
        Tue, 25 Aug 2020 13:46:11 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E877AE05C;
        Tue, 25 Aug 2020 13:46:11 +0000 (GMT)
Received: from Brians-MBP (unknown [9.211.49.159])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTPS;
        Tue, 25 Aug 2020 13:46:11 +0000 (GMT)
Date:   Tue, 25 Aug 2020 08:45:55 -0500
From:   Brian W Hart <hartb@linux.vnet.ibm.com>
To:     Dany Madden <drt@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Mingming Cao <mmc@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net] ibmvnic fix NULL tx_pools and rx_tools issue at
 do_reset
Message-ID: <20200825134554.GA33239@Brians-MBP>
Mail-Followup-To: Dany Madden <drt@linux.ibm.com>, davem@davemloft.net,
        netdev@vger.kernel.org, Mingming Cao <mmc@linux.vnet.ibm.com>,
        linuxppc-dev@lists.ozlabs.org
References: <20200824234922.805858-1-drt@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824234922.805858-1-drt@linux.ibm.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-08-25_04:2020-08-25,2020-08-25 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1011 adultscore=0
 mlxscore=0 mlxlogscore=999 priorityscore=1501 bulkscore=0 malwarescore=0
 lowpriorityscore=0 suspectscore=0 phishscore=0 spamscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008250102
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 24, 2020 at 07:49:23PM -0400, Dany Madden wrote:
> From: Mingming Cao <mmc@linux.vnet.ibm.com>
> 
> At the time of do_reset, ibmvnic tries to re-initalize the tx_pools
> and rx_pools to avoid re-allocating the long term buffer. However
> there is a window inside do_reset that the tx_pools and
> rx_pools were freed before re-initialized making it possible to deference
> null pointers.
> 
> This patch fixes this issue by checking that the tx_pool
> and rx_pool are not NULL after ibmvnic_login. If so, re-allocating
> the pools. This will avoid getting into calling reset_tx/rx_pools with
> NULL adapter tx_pools/rx_pools pointer. Also add null pointer check in
> reset_tx_pools and reset_rx_pools to safe handle NULL pointer case.
> 
> Signed-off-by: Mingming Cao <mmc@linux.vnet.ibm.com>
> Signed-off-by: Dany Madden <drt@linux.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 5afb3c9c52d2..5ff48e55308b 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -479,6 +479,9 @@ static int reset_rx_pools(struct ibmvnic_adapter *adapter)
>  	int i, j, rc;
>  	u64 *size_array;
> 
> +	if (!adapter->tx_pool)
> +		return -1;
> +

Should this one be testing rx_pool?

brian

>  	size_array = (u64 *)((u8 *)(adapter->login_rsp_buf) +
>  		be32_to_cpu(adapter->login_rsp_buf->off_rxadd_buff_size));
> 
> @@ -649,6 +652,9 @@ static int reset_tx_pools(struct ibmvnic_adapter *adapter)
>  	int tx_scrqs;
>  	int i, rc;
> 
> +	if (!adapter->tx_pool)
> +		return -1;
> +
>  	tx_scrqs = be32_to_cpu(adapter->login_rsp_buf->num_txsubm_subcrqs);
>  	for (i = 0; i < tx_scrqs; i++) {
>  		rc = reset_one_tx_pool(adapter, &adapter->tso_pool[i]);
> @@ -2011,7 +2017,10 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>  		    adapter->req_rx_add_entries_per_subcrq !=
>  		    old_num_rx_slots ||
>  		    adapter->req_tx_entries_per_subcrq !=
> -		    old_num_tx_slots) {
> +		    old_num_tx_slots ||
> +			!adapter->rx_pool ||
> +			!adapter->tso_pool ||
> +			!adapter->tx_pool) {
>  			release_rx_pools(adapter);
>  			release_tx_pools(adapter);
>  			release_napi(adapter);
> @@ -2024,10 +2033,14 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>  		} else {
>  			rc = reset_tx_pools(adapter);
>  			if (rc)
> +				netdev_dbg(adapter->netdev, "reset tx pools failed (%d)\n",
> +						rc);
>  				goto out;
> 
>  			rc = reset_rx_pools(adapter);
>  			if (rc)
> +				netdev_dbg(adapter->netdev, "reset rx pools failed (%d)\n",
> +						rc);
>  				goto out;
>  		}
>  		ibmvnic_disable_irqs(adapter);
> -- 
> 2.18.2
> 
