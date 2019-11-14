Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83D4FFCC9C
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727344AbfKNSEH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:04:07 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:6112 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727296AbfKNSEG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:04:06 -0500
Received: from pps.filterd (m0098413.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id xAEHxGgL067341;
        Thu, 14 Nov 2019 13:04:04 -0500
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w9agbu30t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 13:04:03 -0500
Received: from m0098413.ppops.net (m0098413.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.27/8.16.0.27) with SMTP id xAEI0eqR073943;
        Thu, 14 Nov 2019 13:03:56 -0500
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2w9agbu30a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 13:03:56 -0500
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.27/8.16.0.27) with SMTP id xAEHtiPk010463;
        Thu, 14 Nov 2019 18:03:55 GMT
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
        by ppma04wdc.us.ibm.com with ESMTP id 2w5n36kgwa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 14 Nov 2019 18:03:55 +0000
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id xAEI3sSS35651994
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 14 Nov 2019 18:03:54 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id ABCA2AE063;
        Thu, 14 Nov 2019 18:03:54 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 90323AE05C;
        Thu, 14 Nov 2019 18:03:53 +0000 (GMT)
Received: from Criss-MacBook-Pro.local (unknown [9.24.11.85])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 14 Nov 2019 18:03:53 +0000 (GMT)
Subject: Re: [PATCH net-net v2] ibmveth: Detect unsupported packets before
 sending to the hypervisor
To:     netdev@vger.kernel.org
Cc:     tlfalcon@linux.ibm.com, davem@davemloft.net, f.fainelli@gmail.com
References: <20191113210616.55737-1-cforno12@linux.vnet.ibm.com>
From:   Cristobal Forno <cforno12@linux.vnet.ibm.com>
Message-ID: <3be004fb-5e00-2275-6f63-87c4605b8b0c@linux.vnet.ibm.com>
Date:   Thu, 14 Nov 2019 12:03:52 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191113210616.55737-1-cforno12@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-11-14_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=1 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1910280000 definitions=main-1911140154
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CC'd Florian and David. Please review changes as suggested.

On 13/11/2019 15:06, Cris Forno wrote:
> Currently, when ibmveth receive a loopback packet, it reports an
> ambiguous error message "tx: h_send_logical_lan failed with rc=-4"
> because the hypervisor rejects those types of packets. This fix
> detects loopback packet and assures the source packet's MAC address
> matches the driver's MAC address before transmitting to the
> hypervisor.
>
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
> changes in v2
> -demoted messages to netdev_dbg
> -reversed christmas tree ordering for local variables
> ---
>   drivers/net/ethernet/ibm/ibmveth.c | 26 ++++++++++++++++++++++++++
>   1 file changed, 26 insertions(+)
>
> diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
> index d654c23..1e0208f 100644
> --- a/drivers/net/ethernet/ibm/ibmveth.c
> +++ b/drivers/net/ethernet/ibm/ibmveth.c
> @@ -1011,6 +1011,29 @@ static int ibmveth_send(struct ibmveth_adapter *adapter,
>   	return 0;
>   }
>
> +static int ibmveth_is_packet_unsupported(struct sk_buff *skb,
> +					 struct net_device *netdev)
> +{
> +	struct ethhdr *ether_header;
> +	int ret = 0;
> +
> +	ether_header = eth_hdr(skb);
> +
> +	if (ether_addr_equal(ether_header->h_dest, netdev->dev_addr)) {
> +		netdev_dbg(netdev, "veth doesn't support loopback packets, dropping packet.\n");
> +		netdev->stats.tx_dropped++;
> +		ret = -EOPNOTSUPP;
> +	}
> +
> +	if (!ether_addr_equal(ether_header->h_source, netdev->dev_addr)) {
> +		netdev_dbg(netdev, "source packet MAC address does not match veth device's, dropping packet.\n");
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
