Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43AC2BB979
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:55:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727780AbgKTWwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:52:51 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:49218 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726719AbgKTWwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:52:50 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMY8bf140785
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version : date :
 from : to : cc : subject : in-reply-to : references : message-id :
 content-type : content-transfer-encoding; s=pp1;
 bh=7B5mik3Q8xOOWnWI5S1+bJIGF83QJ+5KDPEzZjnL6Gk=;
 b=VhANIf/UIsEhJr4xm4Qjx7lKnLk72o5vz46d3I86YMM27coEhzu5zxsJcm643Htut/LU
 1ERHvS2v/fJbDDOVGksHWhw0D4ZpWFnxD6lrkEgJTo4qwoXPiDNE0XlI/jq9WntqAC8X
 /1RWmXm2l4f3fmiWCnpAgOn8uPpW+b6zWGAMASTiC1rmrh3K5NHh03s+gE5A0OHkF5w/
 uGfVDM2TDhxpwyer92SCyjSvioNh2hx/fwzZWOKL0Y/T0TlyxjpA4GU/5c9LCo/REWie
 09k17Li8TnJelTY+UPMpcWeTcLv0fhVyqVuPDin4Hwm/nNWZBtD77OSUQF4XDM0FUs6U yQ== 
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 34xj7v7fs1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:52:50 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0AKMqjCc009791
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:52:49 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma04dal.us.ibm.com with ESMTP id 34t6va6a4v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 22:52:49 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0AKMqdgW14156324
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 Nov 2020 22:52:39 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0087F136051;
        Fri, 20 Nov 2020 22:52:48 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C86CE13604F;
        Fri, 20 Nov 2020 22:52:47 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.16.170.189])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 20 Nov 2020 22:52:47 +0000 (GMT)
MIME-Version: 1.0
Date:   Fri, 20 Nov 2020 14:52:47 -0800
From:   drt <drt@linux.vnet.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Subject: Re: [PATCH net v2 1/3] ibmvnic: fix call_netdevice_notifiers in
 do_reset
In-Reply-To: <20201120224013.46891-2-ljp@linux.ibm.com>
References: <20201120224013.46891-1-ljp@linux.ibm.com>
 <20201120224013.46891-2-ljp@linux.ibm.com>
Message-ID: <475d23e065164464facef1fedf3ea466@linux.vnet.ibm.com>
X-Sender: drt@linux.vnet.ibm.com
User-Agent: Roundcube Webmail/1.0.1
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.312,18.0.737
 definitions=2020-11-20_16:2020-11-20,2020-11-20 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 mlxlogscore=999 suspectscore=0 lowpriorityscore=0 impostorscore=0
 mlxscore=0 clxscore=1015 malwarescore=0 spamscore=0 priorityscore=1501
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2011200144
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-20 14:40, Lijun Pan wrote:
> When netdev_notify_peers was substituted in
> commit 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device 
> reset"),
> call_netdevice_notifiers(NETDEV_RESEND_IGMP, dev) was missed.
> Fix it now.
> 
> Fixes: 986103e7920c ("net/ibmvnic: Fix RTNL deadlock during device 
> reset")
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
> v2: split from v1's 1/2
> 
>  drivers/net/ethernet/ibm/ibmvnic.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index da15913879f8..eface3543b2c 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2074,8 +2074,10 @@ static int do_reset(struct ibmvnic_adapter 
> *adapter,
>  	for (i = 0; i < adapter->req_rx_queues; i++)
>  		napi_schedule(&adapter->napi[i]);
> 
> -	if (adapter->reset_reason != VNIC_RESET_FAILOVER)
> +	if (adapter->reset_reason != VNIC_RESET_FAILOVER) {
>  		call_netdevice_notifiers(NETDEV_NOTIFY_PEERS, netdev);
> +		call_netdevice_notifiers(NETDEV_RESEND_IGMP, netdev);
> +	}
> 
>  	rc = 0;
