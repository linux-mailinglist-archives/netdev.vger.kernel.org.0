Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA17496F42
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 01:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231883AbiAWAfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 19:35:31 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37582 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229542AbiAWAfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 19:35:30 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20MNY1PN016826
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:35:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=i+fYrThUhdG1XI2e/5eLVTtYMQ1N6GbecdkP/FIsMMY=;
 b=KB+bTK2AhrVdHD1wFDznVndYFFZDsZA4J+mLZOADs1Ygubjdj8N8+SvBOorxdkI2Q2NX
 i+5R/Jlrc18HMDzsGVgPDFOA/y7Uvsq79LbOd5ZyE/2Y9BrtCKXxxmLQl6hQaR1H+R+B
 Gm9kew8DcGGc/Y4u907kla5yAnnebgMb698mh4Xy9y8hmb3JcS/psJRSIX+HMntPL5Wd
 yjEuAAJnvLjAI4W6m0PxwZPzcUPeQjq9aieeSL176CHSerVE77wXRDjzo9YOjmETPcrH
 qLE4VNFtwcBqeOKH1rcPfOi3Oqr8eCNW+QmntXB6WCfK6lHVQIDQAiEzzqa8JfCD6xh4 BA== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3druq7rhep-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:35:29 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20N0CNiJ018087
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:30:57 GMT
Received: from b01cxnp23034.gho.pok.ibm.com (b01cxnp23034.gho.pok.ibm.com [9.57.198.29])
        by ppma02dal.us.ibm.com with ESMTP id 3dr9j945tu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sun, 23 Jan 2022 00:30:57 +0000
Received: from b01ledav001.gho.pok.ibm.com (b01ledav001.gho.pok.ibm.com [9.57.199.106])
        by b01cxnp23034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20N0UuZ232965078
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 00:30:56 GMT
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7250D28059;
        Sun, 23 Jan 2022 00:30:56 +0000 (GMT)
Received: from b01ledav001.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 307872805C;
        Sun, 23 Jan 2022 00:30:56 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b01ledav001.gho.pok.ibm.com (Postfix) with ESMTP;
        Sun, 23 Jan 2022 00:30:56 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 22 Jan 2022 16:30:55 -0800
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>
Subject: Re: [PATCH net 2/4] ibmvnic: init ->running_cap_crqs early
In-Reply-To: <20220122025921.199446-2-sukadev@linux.ibm.com>
References: <20220122025921.199446-1-sukadev@linux.ibm.com>
 <20220122025921.199446-2-sukadev@linux.ibm.com>
Message-ID: <07b59d228048498f75620e9660301006@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: GjTV6s5QHwY9NhMAPLwVPNo2xOeQyLMq
X-Proofpoint-GUID: GjTV6s5QHwY9NhMAPLwVPNo2xOeQyLMq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-22_10,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 mlxlogscore=999
 suspectscore=0 mlxscore=0 spamscore=0 impostorscore=0 clxscore=1015
 bulkscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201230001
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2022-01-21 18:59, Sukadev Bhattiprolu wrote:
> We use ->running_cap_crqs to determine when the ibmvnic_tasklet() 
> should
> send out the next protocol message type. i.e when we get back responses
> to all our QUERY_CAPABILITY CRQs we send out REQUEST_CAPABILITY crqs.
> Similiary, when we get responses to all the REQUEST_CAPABILITY crqs, we
> send out the QUERY_IP_OFFLOAD CRQ.
> 
> We currently increment ->running_cap_crqs as we send out each CRQ and
> have the ibmvnic_tasklet() send out the next message type, when this
> running_cap_crqs count drops to 0.
> 
> This assumes that all the CRQs of the current type were sent out before
> the count drops to 0. However it is possible that we send out say 6 
> CRQs,
> get preempted and receive all the 6 responses before we send out the
> remaining CRQs. This can result in ->running_cap_crqs count dropping to
> zero before all messages of the current type were sent and we end up
> sending the next protocol message too early.
> 
> Instead initialize the ->running_cap_crqs upfront so the tasklet will
> only send the next protocol message after all responses are received.
> 
> Use the cap_reqs local variable to also detect any discrepancy (either
> now or in future) in the number of capability requests we actually 
> send.
> 
> Currently only send_query_cap() is affected by this behavior (of 
> sending
> next message early) since it is called from the worker thread (during
> reset) and from application thread (during ->ndo_open()) and they can 
> be
> preempted. send_request_cap() is only called from the tasklet  which
> processes CRQ responses sequentially, is not be affected.  But to
> maintain the existing symmtery with send_query_capability() we update
> send_request_capability() also.
> 
> Fixes: 249168ad07cd ("ibmvnic: Make CRQ interrupt tasklet wait for all
> capabilities crqs")
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Reviewed-by: Dany Madden <drt@linux.ibm.com>

> ---
>  drivers/net/ethernet/ibm/ibmvnic.c | 106 +++++++++++++++++++----------
>  1 file changed, 71 insertions(+), 35 deletions(-)
> 
> 
> diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> b/drivers/net/ethernet/ibm/ibmvnic.c
> index 9b2d16ad76f1..acd488310bbc 100644
> --- a/drivers/net/ethernet/ibm/ibmvnic.c
> +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> @@ -3849,11 +3849,25 @@ static void send_request_cap(struct
> ibmvnic_adapter *adapter, int retry)
>  	struct device *dev = &adapter->vdev->dev;
>  	union ibmvnic_crq crq;
>  	int max_entries;
> +	int cap_reqs;
> +
> +	/* We send out 6 or 7 REQUEST_CAPABILITY CRQs below (depending on
> +	 * the PROMISC flag). Initialize this count upfront. When the tasklet
> +	 * receives a response to all of these, it will send the next 
> protocol
> +	 * message (QUERY_IP_OFFLOAD).
> +	 */
> +	if (!(adapter->netdev->flags & IFF_PROMISC) ||
> +	    adapter->promisc_supported)
> +		cap_reqs = 7;
> +	else
> +		cap_reqs = 6;
> 
>  	if (!retry) {
>  		/* Sub-CRQ entries are 32 byte long */
>  		int entries_page = 4 * PAGE_SIZE / (sizeof(u64) * 4);
> 
> +		atomic_set(&adapter->running_cap_crqs, cap_reqs);
> +
>  		if (adapter->min_tx_entries_per_subcrq > entries_page ||
>  		    adapter->min_rx_add_entries_per_subcrq > entries_page) {
>  			dev_err(dev, "Fatal, invalid entries per sub-crq\n");
> @@ -3914,44 +3928,45 @@ static void send_request_cap(struct
> ibmvnic_adapter *adapter, int retry)
>  					adapter->opt_rx_comp_queues;
> 
>  		adapter->req_rx_add_queues = adapter->max_rx_add_queues;
> +	} else {
> +		atomic_add(cap_reqs, &adapter->running_cap_crqs);
>  	}
> -
>  	memset(&crq, 0, sizeof(crq));
>  	crq.request_capability.first = IBMVNIC_CRQ_CMD;
>  	crq.request_capability.cmd = REQUEST_CAPABILITY;
> 
>  	crq.request_capability.capability = cpu_to_be16(REQ_TX_QUEUES);
>  	crq.request_capability.number = cpu_to_be64(adapter->req_tx_queues);
> -	atomic_inc(&adapter->running_cap_crqs);
> +	cap_reqs--;
>  	ibmvnic_send_crq(adapter, &crq);
> 
>  	crq.request_capability.capability = cpu_to_be16(REQ_RX_QUEUES);
>  	crq.request_capability.number = cpu_to_be64(adapter->req_rx_queues);
> -	atomic_inc(&adapter->running_cap_crqs);
> +	cap_reqs--;
>  	ibmvnic_send_crq(adapter, &crq);
> 
>  	crq.request_capability.capability = cpu_to_be16(REQ_RX_ADD_QUEUES);
>  	crq.request_capability.number = 
> cpu_to_be64(adapter->req_rx_add_queues);
> -	atomic_inc(&adapter->running_cap_crqs);
> +	cap_reqs--;
>  	ibmvnic_send_crq(adapter, &crq);
> 
>  	crq.request_capability.capability =
>  	    cpu_to_be16(REQ_TX_ENTRIES_PER_SUBCRQ);
>  	crq.request_capability.number =
>  	    cpu_to_be64(adapter->req_tx_entries_per_subcrq);
> -	atomic_inc(&adapter->running_cap_crqs);
> +	cap_reqs--;
>  	ibmvnic_send_crq(adapter, &crq);
> 
>  	crq.request_capability.capability =
>  	    cpu_to_be16(REQ_RX_ADD_ENTRIES_PER_SUBCRQ);
>  	crq.request_capability.number =
>  	    cpu_to_be64(adapter->req_rx_add_entries_per_subcrq);
> -	atomic_inc(&adapter->running_cap_crqs);
> +	cap_reqs--;
>  	ibmvnic_send_crq(adapter, &crq);
> 
>  	crq.request_capability.capability = cpu_to_be16(REQ_MTU);
>  	crq.request_capability.number = cpu_to_be64(adapter->req_mtu);
> -	atomic_inc(&adapter->running_cap_crqs);
> +	cap_reqs--;
>  	ibmvnic_send_crq(adapter, &crq);
> 
>  	if (adapter->netdev->flags & IFF_PROMISC) {
> @@ -3959,16 +3974,21 @@ static void send_request_cap(struct
> ibmvnic_adapter *adapter, int retry)
>  			crq.request_capability.capability =
>  			    cpu_to_be16(PROMISC_REQUESTED);
>  			crq.request_capability.number = cpu_to_be64(1);
> -			atomic_inc(&adapter->running_cap_crqs);
> +			cap_reqs--;
>  			ibmvnic_send_crq(adapter, &crq);
>  		}
>  	} else {
>  		crq.request_capability.capability =
>  		    cpu_to_be16(PROMISC_REQUESTED);
>  		crq.request_capability.number = cpu_to_be64(0);
> -		atomic_inc(&adapter->running_cap_crqs);
> +		cap_reqs--;
>  		ibmvnic_send_crq(adapter, &crq);
>  	}
> +
> +	/* Keep at end to catch any discrepancy between expected and actual
> +	 * CRQs sent.
> +	 */
> +	WARN_ON(cap_reqs != 0);
>  }
> 
>  static int pending_scrq(struct ibmvnic_adapter *adapter,
> @@ -4362,118 +4382,132 @@ static void send_query_map(struct
> ibmvnic_adapter *adapter)
>  static void send_query_cap(struct ibmvnic_adapter *adapter)
>  {
>  	union ibmvnic_crq crq;
> +	int cap_reqs;
> +
> +	/* We send out 25 QUERY_CAPABILITY CRQs below.  Initialize this count
> +	 * upfront. When the tasklet receives a response to all of these, it
> +	 * can send out the next protocol messaage (REQUEST_CAPABILITY).
> +	 */
> +	cap_reqs = 25;
> +
> +	atomic_set(&adapter->running_cap_crqs, cap_reqs);
> 
> -	atomic_set(&adapter->running_cap_crqs, 0);
>  	memset(&crq, 0, sizeof(crq));
>  	crq.query_capability.first = IBMVNIC_CRQ_CMD;
>  	crq.query_capability.cmd = QUERY_CAPABILITY;
> 
>  	crq.query_capability.capability = cpu_to_be16(MIN_TX_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MIN_RX_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MIN_RX_ADD_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MAX_TX_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MAX_RX_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MAX_RX_ADD_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  	    cpu_to_be16(MIN_TX_ENTRIES_PER_SUBCRQ);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  	    cpu_to_be16(MIN_RX_ADD_ENTRIES_PER_SUBCRQ);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  	    cpu_to_be16(MAX_TX_ENTRIES_PER_SUBCRQ);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  	    cpu_to_be16(MAX_RX_ADD_ENTRIES_PER_SUBCRQ);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(TCP_IP_OFFLOAD);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(PROMISC_SUPPORTED);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MIN_MTU);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MAX_MTU);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MAX_MULTICAST_FILTERS);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(VLAN_HEADER_INSERTION);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = 
> cpu_to_be16(RX_VLAN_HEADER_INSERTION);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(MAX_TX_SG_ENTRIES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(RX_SG_SUPPORTED);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = 
> cpu_to_be16(OPT_TX_COMP_SUB_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(OPT_RX_COMP_QUEUES);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  			cpu_to_be16(OPT_RX_BUFADD_Q_PER_RX_COMP_Q);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  			cpu_to_be16(OPT_TX_ENTRIES_PER_SUBCRQ);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability =
>  			cpu_to_be16(OPT_RXBA_ENTRIES_PER_SUBCRQ);
> -	atomic_inc(&adapter->running_cap_crqs);
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> 
>  	crq.query_capability.capability = cpu_to_be16(TX_RX_DESC_REQ);
> -	atomic_inc(&adapter->running_cap_crqs);
> +
>  	ibmvnic_send_crq(adapter, &crq);
> +	cap_reqs--;
> +
> +	/* Keep at end to catch any discrepancy between expected and actual
> +	 * CRQs sent.
> +	 */
> +	WARN_ON(cap_reqs != 0);
>  }
> 
>  static void send_query_ip_offload(struct ibmvnic_adapter *adapter)
> @@ -4777,6 +4811,8 @@ static void handle_request_cap_rsp(union 
> ibmvnic_crq *crq,
>  	char *name;
> 
>  	atomic_dec(&adapter->running_cap_crqs);
> +	netdev_dbg(adapter->netdev, "Outstanding request-caps: %d\n",
> +		   atomic_read(&adapter->running_cap_crqs));
>  	switch (be16_to_cpu(crq->request_capability_rsp.capability)) {
>  	case REQ_TX_QUEUES:
>  		req_value = &adapter->req_tx_queues;
