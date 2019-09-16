Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3820B3D93
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 17:21:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389085AbfIPPVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 11:21:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48630 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388625AbfIPPVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 11:21:53 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x8GFFOZc096063
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 11:21:52 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2v2a1m7sgc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 11:21:50 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id x8GFKH7k017340
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 15:21:49 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01wdc.us.ibm.com with ESMTP id 2v0sw4sang-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 15:21:49 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x8GFLmw138535470
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 16 Sep 2019 15:21:48 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9232CAC059;
        Mon, 16 Sep 2019 15:21:48 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4D318AC064;
        Mon, 16 Sep 2019 15:21:48 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.85.220.176])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Mon, 16 Sep 2019 15:21:48 +0000 (GMT)
Subject: Re: [PATCH net] ibmvnic: Warn unknown speed message only when carrier
 is present
To:     Murilo Fossa Vicentini <muvic@linux.ibm.com>,
        netdev@vger.kernel.org
Cc:     muvic@br.ibm.com, abdhalee@linux.vnet.ibm.com
References: <20190916145037.77376-1-muvic@linux.ibm.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <de449a43-0313-f231-c6cc-40b6f4966a5a@linux.ibm.com>
Date:   Mon, 16 Sep 2019 10:21:47 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190916145037.77376-1-muvic@linux.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-09-16_07:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1908290000 definitions=main-1909160156
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/19 9:50 AM, Murilo Fossa Vicentini wrote:
> With commit 0655f9943df2 ("net/ibmvnic: Update carrier state after link
> state change") we are now able to detect when the carrier is properly
> present in the device, so only report an unexpected unknown speed when it
> is properly detected. Unknown speed is expected to be seen by the device
> in case the backing device has no link detected.
>
> Reported-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Tested-by: Abdul Haleem <abdhalee@linux.vnet.ibm.com>
> Signed-off-by: Murilo Fossa Vicentini <muvic@linux.ibm.com>
> ---

Thanks, Murilo!

Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>

>   drivers/net/ethernet/ibm/ibmvnic.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
> index 5cb55ea671e3..3a6725daf7dc 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -4312,13 +4312,14 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
>   {
>   	struct net_device *netdev = adapter->netdev;
>   	int rc;
> +	__be32 rspeed = cpu_to_be32(crq->query_phys_parms_rsp.speed);
>   
>   	rc = crq->query_phys_parms_rsp.rc.code;
>   	if (rc) {
>   		netdev_err(netdev, "Error %d in QUERY_PHYS_PARMS\n", rc);
>   		return rc;
>   	}
> -	switch (cpu_to_be32(crq->query_phys_parms_rsp.speed)) {
> +	switch (rspeed) {
>   	case IBMVNIC_10MBPS:
>   		adapter->speed = SPEED_10;
>   		break;
> @@ -4344,8 +4345,8 @@ static int handle_query_phys_parms_rsp(union ibmvnic_crq *crq,
>   		adapter->speed = SPEED_100000;
>   		break;
>   	default:
> -		netdev_warn(netdev, "Unknown speed 0x%08x\n",
> -			    cpu_to_be32(crq->query_phys_parms_rsp.speed));
> +		if (netif_carrier_ok(netdev))
> +			netdev_warn(netdev, "Unknown speed 0x%08x\n", rspeed);
>   		adapter->speed = SPEED_UNKNOWN;
>   	}
>   	if (crq->query_phys_parms_rsp.flags1 & IBMVNIC_FULL_DUPLEX)
