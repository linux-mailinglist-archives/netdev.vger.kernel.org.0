Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F72135F459
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 14:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbhDNMyv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 08:54:51 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:25686 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1346114AbhDNMyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 08:54:05 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13ECY3iN152457;
        Wed, 14 Apr 2021 08:53:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=bj2dxdd+sQQyos6SQ+/N/VxYtpAOiaXsmFw+bq73wNk=;
 b=tnxsQ4hkf4nfctFEDZM68Py9Of1Qd5h32hNFp7hEMqxszH/Wz5CoPLYR+PnHg+V4skP+
 x0B8/oXal2X6jvCbA3cEU5BibfA4OoRIKDFAYu7d+iy0P8DXTeXceF6E1sqA3sWZAy2U
 PcQ4A3SWYMV6OfJ0yP/bGInLqvPIUxQHt9sKog65r17Rbyr6gqm+mM9RNIqEDixiW5vl
 dHWwfAHA4al+U2WlyjXmuw4tNMzYxa88U0i8yYEBNecmFvVhkrDCERjoqsbMzEifS4gh
 RU5Lt0cJMUAticMg9+WM4QZrkKjmpr+KJr1pc/2xvioDYg/6Jko7ULMJW6kkbDerV9qw HQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37wvvy6jw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 08:53:32 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13ECbK1a172677;
        Wed, 14 Apr 2021 08:53:32 -0400
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37wvvy6jvg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 08:53:32 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13ECkwgc026263;
        Wed, 14 Apr 2021 12:53:30 GMT
Received: from b06cxnps3075.portsmouth.uk.ibm.com (d06relay10.portsmouth.uk.ibm.com [9.149.109.195])
        by ppma05fra.de.ibm.com with ESMTP id 37u3n89rwx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 14 Apr 2021 12:53:30 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps3075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13ECrRdX47513894
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 14 Apr 2021 12:53:27 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B12974204D;
        Wed, 14 Apr 2021 12:53:27 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 50D7142042;
        Wed, 14 Apr 2021 12:53:27 +0000 (GMT)
Received: from [9.145.63.72] (unknown [9.145.63.72])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed, 14 Apr 2021 12:53:27 +0000 (GMT)
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210409003904.8957-1-TheSven73@gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <0bf00feb-a588-12e1-d606-4a5d7d45e0b3@linux.ibm.com>
Date:   Wed, 14 Apr 2021 14:53:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <20210409003904.8957-1-TheSven73@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: d2MFi7cJ9AXuRPAfi1fhQSdb4ESStZUQ
X-Proofpoint-ORIG-GUID: NJPlD7miOxWFUTMZuW2vgbdheh3khZEL
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-14_07:2021-04-14,2021-04-14 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 priorityscore=1501 spamscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104140086
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09.04.21 02:39, Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> The ethernet frame length is calculated incorrectly. Depending on
> the value of RX_HEAD_PADDING, this may result in ethernet frames
> that are too short (cut off at the end), or too long (garbage added
> to the end).
> 
> Fix by calculating the ethernet frame length correctly. For added
> clarity, use the ETH_FCS_LEN constant in the calculation.
> 
> Many thanks to Heiner Kallweit for suggesting this solution. 
> 
> Fixes: 3e21a10fdea3 ("lan743x: trim all 4 bytes of the FCS; not just 2")
> Link: https://lore.kernel.org/lkml/20210408172353.21143-1-TheSven73@gmail.com/
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
> 
> Tree: git://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git # 864db232dc70
> 
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> To: George McCollister <george.mccollister@gmail.com>
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: UNGLinuxDriver@microchip.com
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
>  drivers/net/ethernet/microchip/lan743x_main.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 1c3e204d727c..7b6794aa8ea9 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -885,8 +885,8 @@ static int lan743x_mac_set_mtu(struct lan743x_adapter *adapter, int new_mtu)
>  	}
>  
>  	mac_rx &= ~(MAC_RX_MAX_SIZE_MASK_);
> -	mac_rx |= (((new_mtu + ETH_HLEN + 4) << MAC_RX_MAX_SIZE_SHIFT_) &
> -		  MAC_RX_MAX_SIZE_MASK_);
> +	mac_rx |= (((new_mtu + ETH_HLEN + ETH_FCS_LEN)
> +		  << MAC_RX_MAX_SIZE_SHIFT_) & MAC_RX_MAX_SIZE_MASK_);
>  	lan743x_csr_write(adapter, MAC_RX, mac_rx);
>  
>  	if (enabled) {
> @@ -1944,7 +1944,7 @@ static int lan743x_rx_init_ring_element(struct lan743x_rx *rx, int index)
>  	struct sk_buff *skb;
>  	dma_addr_t dma_ptr;
>  
> -	buffer_length = netdev->mtu + ETH_HLEN + 4 + RX_HEAD_PADDING;
> +	buffer_length = netdev->mtu + ETH_HLEN + ETH_FCS_LEN + RX_HEAD_PADDING;
>  

On a cursory glance, using __netdev_alloc_skb_ip_align() here should
allow you to get rid of all the RX_HEAD_PADDING gymnastics.

And also avoid the need for setting RX_CFG_B_RX_PAD_2_, as the
NET_IP_ALIGN part would no longer get dma-mapped.

>  	descriptor = &rx->ring_cpu_ptr[index];
>  	buffer_info = &rx->buffer_info[index];
> @@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
>  		dev_kfree_skb_irq(skb);
>  		return NULL;
>  	}
> -	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
> +	frame_length = max_t(int, 0, frame_length - ETH_FCS_LEN);
>  	if (skb->len > frame_length) {
>  		skb->tail -= skb->len - frame_length;
>  		skb->len = frame_length;
> 

