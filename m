Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C96BA2BB97C
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbgKTWz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:55:56 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59696 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728197AbgKTWz4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:55:56 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMVuOw109790
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:55:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=caBHxwEvN2EquZF8r4yIi0K5ncolQSSrjWOBqO8sI/w=;
 b=HHqsrtK9OZSxWFAIp32nmBqTBD8+4BlzMBb6+1RcCCUf5FHj3G9ie1rkb3c3mIiQ8mOz
 mBberPrjzKi2wpJBtWDNyhqpOlheM3TJABEKiGHNl18aqNwKFWkZqbtx1gR3c9DKY3xa
 uKtXYkAK07kt+xn9/RHwG8quKZBd1oqgRhNCO8VH8LA+XxAuXOJc9lG2BisCRTLXWk9V
 Mmu3SdSKt6VpJt+BSL6/ink57if8MnPDJrINen6Macob6sJRSCtaTAQgA9mEVww1kYv0
 aLMmqrtLmCTgKaKT6OVusyEC2gV6aGo2Lbjxsr+PBHZlqGskDohNEOPl8HpitMKP9QTe vA== 
Received: from ppma02wdc.us.ibm.com (aa.5b.37a9.ip4.static.sl-reverse.com [169.55.91.170])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xgf549hr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:55:54 -0500
Received: from pps.filterd (ppma02wdc.us.ibm.com [127.0.0.1])
        by ppma02wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMrpvL031161
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:55:54 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma02wdc.us.ibm.com with ESMTP id 34w5w8tqa0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:55:54 +0000
Received: from b01ledav004.gho.pok.ibm.com (b01ledav004.gho.pok.ibm.com [9.57.199.109])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMtrom14680844
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:55:53 GMT
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C2016112062;
        Fri, 20 Nov 2020 22:55:53 +0000 (GMT)
Received: from b01ledav004.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3E286112061;
        Fri, 20 Nov 2020 22:55:53 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b01ledav004.gho.pok.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:55:53 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 20 Nov 2020 14:55:52 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com,
        Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH net v2 3/3] ibmvnic: skip tx timeout reset while in
 resetting
In-Reply-To: <20201120224013.46891-4-ljp@linux.ibm.com>
References: <20201120224013.46891-1-ljp@linux.ibm.com>
 <20201120224013.46891-4-ljp@linux.ibm.com>
Message-ID: <9065e0c55422e19e8e9417f26cca469a@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 lowpriorityscore=0 malwarescore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 mlxscore=0 impostorscore=0 bulkscore=0
 adultscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 14:40, Lijun Pan wrote:
> Sometimes it takes longer than 5 seconds (watchdog timeout) to complete
> failover, migration, and other resets. In stead of scheduling another
> timeout reset, we wait for the current one to complete.
> 
> Suggested-by: Brian King <brking@linux.vnet.ibm.com>
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
> v2: no change
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 9665532a9ed2..2aa40b2f225c 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2356,6 +2356,12 @@ static void ibmvnic_tx_timeout(struct
> net_device *dev, unsigned int txqueue)
>  {
>  	struct ibmvnic_adapter *adapter = netdev_priv(dev);
> 
> +	if (test_bit(0, &adapter->resetting)) {
> +		netdev_err(adapter->netdev,
> +			   "Adapter is resetting, skip timeout reset\n");
> +		return;
> +	}
> +
>  	ibmvnic_reset(adapter, VNIC_RESET_TIMEOUT);
>  }
