Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE698FB643
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 18:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKMRVM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 12:21:12 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:1314 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726210AbfKMRVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 12:21:12 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xADGwOxS195727
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 12:21:10 -0500
Received: from ppma05wdc.us.ibm.com (1b.90.2fa9.ip4.static.sl-reverse.com [169.47.144.27])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w8ms9c3dk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 12:21:10 -0500
Received: from pps.filterd (ppma05wdc.us.ibm.com [127.0.0.1])
        by ppma05wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xADHJso3025517
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 17:21:09 GMT
Received: from b03cxnp08027.gho.boulder.ibm.com (b03cxnp08027.gho.boulder.ibm.com [9.17.130.19])
        by ppma05wdc.us.ibm.com with ESMTP id 2w5n36hufq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 17:21:09 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp08027.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xADHL83R54985082
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Nov 2019 17:21:08 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 74C45C6057;
        Wed, 13 Nov 2019 17:21:08 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 09B50C6055;
        Wed, 13 Nov 2019 17:21:07 +0000 (GMT)
Received: from oc7186267434.ibm.com (unknown [9.80.198.248])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 13 Nov 2019 17:21:07 +0000 (GMT)
Subject: Re: [PATCH net-next] ibmveth: Detect unsupported packets before
 sending to the hypervisor
To:     Cris Forno <cforno12@linux.vnet.ibm.com>, netdev@vger.kernel.org
References: <20191113154407.50653-1-cforno12@linux.vnet.ibm.com>
From:   Thomas Falcon <tlfalcon@linux.ibm.com>
Message-ID: <6a3b6d64-8f12-7be7-6e0d-e158474f1d8c@linux.ibm.com>
Date:   Wed, 13 Nov 2019 11:21:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20191113154407.50653-1-cforno12@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-13_04:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=989 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911130147
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/13/19 9:44 AM, Cris Forno wrote:
> Currently, when ibmveth receive a loopback packet, it reports an
> ambiguous error message "tx: h_send_logical_lan failed with rc=-4"
> because the hypervisor rejects those types of packets. This fix
> detects loopback packet and assures the source packet's MAC address
> matches the driver's MAC address before transmitting to the
> hypervisor.
>
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>

Thanks, Cris!

Reviewed-by: Thomas Falcon <tlfalcon@linux.ibm.com>

> ---
>   drivers/net/ethernet/ibm/ibmveth.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index d654c23..e8bb6c7 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1011,6 +1011,29 @@ static int ibmveth_send(struct ibmveth_adapter *adapter,
>   	return 0;
>   }
>   
> +static int ibmveth_is_packet_unsupported(struct sk_buff *skb,
> +					 struct net_device *netdev)
> +{
> +	int ret = 0;
> +	struct ethhdr *ether_header;
> +
> +	ether_header = eth_hdr(skb);
> +
> +	if (ether_addr_equal(ether_header->h_dest, netdev->dev_addr)) {
> +		netdev_err(netdev, "veth doesn't support loopback packets, dropping packet.\n");
> +		netdev->stats.tx_dropped++;
> +		ret = -EOPNOTSUPP;
> +	}
> +
> +	if (!ether_addr_equal(ether_header->h_source, netdev->dev_addr)) {
> +		netdev_err(netdev, "source packet MAC address does not match veth device's, dropping packet.\n");
> +		netdev->stats.tx_dropped++;
> +		ret = -EOPNOTSUPP;
> +	}
> +
> +	return ret;
> +}
> +
>   static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
>   				      struct net_device *netdev)
>   {
> @@ -1022,6 +1045,9 @@ static netdev_tx_t ibmveth_start_xmit(struct sk_buff *skb,
>   	dma_addr_t dma_addr;
>   	unsigned long mss = 0;
>   
> +	if (ibmveth_is_packet_unsupported(skb, netdev))
> +		goto out;
> +
>   	/* veth doesn't handle frag_list, so linearize the skb.
>   	 * When GRO is enabled SKB's can have frag_list.
>   	 */
