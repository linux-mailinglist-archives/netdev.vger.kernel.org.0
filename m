Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B79622D95C6
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 11:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405857AbgLNKEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 05:04:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35258 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405695AbgLNKE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 05:04:29 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 0BEA3a1B125086;
        Mon, 14 Dec 2020 05:03:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Mu1kM1nFbeH7kmD6u8671jmJLXquVY5VCm/mIxZHOiE=;
 b=DGHjF35m7qyiO5Y3FUFKeFE8VVpywtvTduFuMKrKpiHjXceiyEEmiNHs/O6mxLGf+LPI
 4YTB7uICfzszhsvyRbxhqD9Pb41I/WNgPMj7TKb9DaNjmxyENOkrx9T1GV9oTmqp0ab7
 UPVhfUX81QOAhrwTmDMSHGsoW54h4J5thqiYMxm3ICFfSCgqo9XzDZZK7AT1ik+DICsW
 774FO+buaVt5wU8hRQzzQ8frd3WaB3ldrBXm1DpEeFp1mQ1LfIlcaGm3uysBwkNwi+4A
 QTOHbm0KV1H7xf/9dNwpjnIG7ZevX/JRSDjS15ySe3H8KqokiGvkIKkph9KlwNUz7bTT pg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35e4syj4fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 05:03:40 -0500
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 0BEA3diL125254;
        Mon, 14 Dec 2020 05:03:39 -0500
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0a-001b2d01.pphosted.com with ESMTP id 35e4syj48r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 05:03:39 -0500
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 0BEA1ocj019148;
        Mon, 14 Dec 2020 10:03:15 GMT
Received: from b06cxnps4074.portsmouth.uk.ibm.com (d06relay11.portsmouth.uk.ibm.com [9.149.109.196])
        by ppma03ams.nl.ibm.com with ESMTP id 35cng8a0ed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 14 Dec 2020 10:03:15 +0000
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (b06wcsmtp001.portsmouth.uk.ibm.com [9.149.105.160])
        by b06cxnps4074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 0BEA3D0r33096008
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 14 Dec 2020 10:03:13 GMT
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 02CB1A4054;
        Mon, 14 Dec 2020 10:03:13 +0000 (GMT)
Received: from b06wcsmtp001.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B3AEFA405B;
        Mon, 14 Dec 2020 10:03:12 +0000 (GMT)
Received: from [9.145.176.172] (unknown [9.145.176.172])
        by b06wcsmtp001.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 14 Dec 2020 10:03:12 +0000 (GMT)
Subject: Re: [PATCH] net: korina: remove busy skb free
To:     =?UTF-8?Q?Vincent_Stehl=c3=a9?= <vincent.stehle@laposte.net>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <florian.fainelli@telecomint.eu>
References: <20201213172052.12433-1-vincent.stehle@laposte.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <ecd7900f-8b54-23e2-2537-033237e08597@linux.ibm.com>
Date:   Mon, 14 Dec 2020 11:03:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201213172052.12433-1-vincent.stehle@laposte.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-14_04:2020-12-11,2020-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 bulkscore=0 phishscore=0
 spamscore=0 clxscore=1011 malwarescore=0 impostorscore=0 suspectscore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2012140071
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.12.20 18:20, Vincent Stehlé wrote:
> The ndo_start_xmit() method must not attempt to free the skb to transmit
> when returning NETDEV_TX_BUSY. Fix the korina_send_packet() function
> accordingly.
> 
> Fixes: ef11291bcd5f ("Add support the Korina (IDT RC32434) Ethernet MAC")
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Florian Fainelli <florian.fainelli@telecomint.eu>
> ---
>  drivers/net/ethernet/korina.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/korina.c b/drivers/net/ethernet/korina.c
> index bf48f0ded9c7d..9d84191de6824 100644
> --- a/drivers/net/ethernet/korina.c
> +++ b/drivers/net/ethernet/korina.c
> @@ -216,7 +216,6 @@ static int korina_send_packet(struct sk_buff *skb, struct net_device *dev)
>  			netif_stop_queue(dev);
>  		else {
>  			dev->stats.tx_dropped++;
> -			dev_kfree_skb_any(skb);
>  			spin_unlock_irqrestore(&lp->lock, flags);
>  
>  			return NETDEV_TX_BUSY;
> 

As this skb is returned to the stack (and not dropped), the tx_dropped
statistics increment looks bogus too.
