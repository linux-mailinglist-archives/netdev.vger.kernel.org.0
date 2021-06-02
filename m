Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F18E399208
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 19:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhFBR77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:59:59 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53220 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229467AbhFBR76 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:59:58 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152HY4sP144054
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 13:58:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=HPkjmZo70f1gViHaF/TLHr4VK45rR1rC8rA+HZ9irHY=;
 b=kV0c4WkM9IXhgcow14kHIoUBjCrTbRRm5rSsqubAKgF4CPnXgh7f+sLC4ZJ97b9eKGks
 NZjH8VVu+2ICzvDpmasigxwnrAmYLTE8kiDtCkWJ+l+iatnXx3FCh3jQxc3NkNrmtWtE
 4mWGfjXbvW+v1WWLi+9S/AjYSHCOhtr2suhzOjm2MyxiaN17lzJEESVigVLI8qHncPJo
 L9O6k1ybipZrNAHRVCBxExSkjo39ZafbDhBf5wbBjmfh5P8aamaLQ6L21hAp+0TgLXTo
 0KB/QqR8e4u/kvK2GwDViIY2QPzPPK62iXqxFPQIH6r/P22FX/RlpMI+jNko5RUrKoQN Rg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38xdw8hk6r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 13:58:14 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152HYYso145382
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 13:58:14 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38xdw8hk6h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 13:58:14 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 152HkaMW017779;
        Wed, 2 Jun 2021 17:58:13 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma01dal.us.ibm.com with ESMTP id 38ud89sugg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 17:58:13 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 152HwCJ015729028
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 17:58:12 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB26C124058;
        Wed,  2 Jun 2021 17:58:12 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 97EFA124053;
        Wed,  2 Jun 2021 17:58:12 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 17:58:12 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 02 Jun 2021 10:58:12 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ibm: replenish rx pool and poll less
 frequently
In-Reply-To: <20210602170156.41643-1-lijunp213@gmail.com>
References: <20210602170156.41643-1-lijunp213@gmail.com>
Message-ID: <4765c54a8cb7b87ae1d7db928c44f40b@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: CRmJ2U4G2XHZxDwcSWJDmy9rnCEW1_U7
X-Proofpoint-ORIG-GUID: TjH1VU3BPbq-EgNKlFKQDLTeZqEJltHR
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_09:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0
 lowpriorityscore=0 bulkscore=0 spamscore=0 mlxlogscore=964 malwarescore=0
 suspectscore=0 phishscore=0 priorityscore=1501 clxscore=1011
 impostorscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106020111
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-06-02 10:01, Lijun Pan wrote:
> The old mechanism replenishes rx pool even only one frames is processed 
> in
> the poll function, which causes lots of overheads. The old mechanism
> restarts polling until processed frames reaches the budget, which can
> cause the poll function to loop into restart_poll 63 times at most and 
> to
> call replenish_rx_poll 63 times at most. This will cause soft lockup 
> very
> easily. So, don't replenish too often, and don't goto restart_poll in 
> each
> poll function. If there are pending descriptors, fetch them in the next
> poll instance.

Does this improve performance?

> 
> Signed-off-by: Lijun Pan <lijunp213@gmail.com>
> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index ffb2a91750c7..fae1eaa39dd0 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -2435,7 +2435,6 @@ static int ibmvnic_poll(struct napi_struct
> *napi, int budget)
>  	frames_processed = 0;
>  	rx_scrq = adapter->rx_scrq[scrq_num];
> 
> -restart_poll:
>  	while (frames_processed < budget) {
>  		struct sk_buff *skb;
>  		struct ibmvnic_rx_buff *rx_buff;
> @@ -2512,20 +2511,12 @@ static int ibmvnic_poll(struct napi_struct
> *napi, int budget)
>  	}
> 
>  	if (adapter->state != VNIC_CLOSING &&
> -	    ((atomic_read(&adapter->rx_pool[scrq_num].available) <
> -	      adapter->req_rx_add_entries_per_subcrq / 2) ||
> -	      frames_processed < budget))

There is a budget that the driver should adhere to. Even one frame, it 
should still process the frame within a budget.

> +	    (atomic_read(&adapter->rx_pool[scrq_num].available) <
> +	      adapter->req_rx_add_entries_per_subcrq / 2))
>  		replenish_rx_pool(adapter, &adapter->rx_pool[scrq_num]);
>  	if (frames_processed < budget) {
> -		if (napi_complete_done(napi, frames_processed)) {
> +		if (napi_complete_done(napi, frames_processed))
>  			enable_scrq_irq(adapter, rx_scrq);
> -			if (pending_scrq(adapter, rx_scrq)) {
> -				if (napi_reschedule(napi)) {
> -					disable_scrq_irq(adapter, rx_scrq);
> -					goto restart_poll;
> -				}
> -			}
> -		}
>  	}
>  	return frames_processed;
>  }
