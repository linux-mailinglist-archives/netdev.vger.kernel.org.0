Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158DF30A964
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 15:12:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbhBAOLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 09:11:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:7522 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229500AbhBAOLi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 09:11:38 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 111E33rv088288;
        Mon, 1 Feb 2021 09:10:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=kFfdiVRSosOPGBsI44S5SiAq787FhllDr5Y5F5u5cYQ=;
 b=cs8rpuv8dySai1YarWb142wHJt556SoyMPcuFzcwp/hyMhhz9qnOko+MBSlIlr4LGGBx
 qdh79pg3YjpLZv3J76TZF/TOkFBKnJK+yUWPkJ5DsaiaL+aUwPTrHb38b4LPazQrKvwB
 GascykC2BjdBQuHzxWOfyV3o54rGpoEx3fXR7x6YV8XT/TZUQGmi7MU0yN0JsYWF66oJ
 U67TsnkaZV5ced82dUM2xDXPz30M/FnOi9iQuTuaBA2KZGCsKPbWbVCSq5N7ut2V7o3k
 sD4oKDZ5P/dNvk+vGhWRYQPj2USdEq6nqcNdHe+q6RlXUdfKToIUm6w74LlTLyEr3r6J NA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ejj0sjs3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 09:10:53 -0500
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 111E39Iq088662;
        Mon, 1 Feb 2021 09:10:51 -0500
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ejj0sjq1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 09:10:51 -0500
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 111E4DIf021029;
        Mon, 1 Feb 2021 14:10:48 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma02fra.de.ibm.com with ESMTP id 36cy38904p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 14:10:47 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 111EAbMX32440762
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 1 Feb 2021 14:10:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BB97011C052;
        Mon,  1 Feb 2021 14:10:45 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 73DBB11C04C;
        Mon,  1 Feb 2021 14:10:45 +0000 (GMT)
Received: from [9.145.70.87] (unknown [9.145.70.87])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  1 Feb 2021 14:10:45 +0000 (GMT)
Subject: Re: [PATCH net] net: lapb: Copy the skb before sending a packet
To:     Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Martin Schiller <ms@dev.tdt.de>
References: <20210201055706.415842-1-xie.he.0141@gmail.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <4d1988d9-6439-ae37-697c-d2b970450498@linux.ibm.com>
Date:   Mon, 1 Feb 2021 15:10:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210201055706.415842-1-xie.he.0141@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_05:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 malwarescore=0
 mlxscore=0 bulkscore=0 suspectscore=0 adultscore=0 impostorscore=0
 phishscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102010068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.02.21 06:57, Xie He wrote:
> When sending a packet, we will prepend it with an LAPB header.
> This modifies the shared parts of a cloned skb, so we should copy the
> skb rather than just clone it, before we prepend the header.
> 
> In "Documentation/networking/driver.rst" (the 2nd point), it states
> that drivers shouldn't modify the shared parts of a cloned skb when
> transmitting.
> 

This sounds a bit like you want skb_cow_head() ... ?

> The "dev_queue_xmit_nit" function in "net/core/dev.c", which is called
> when an skb is being sent, clones the skb and sents the clone to
> AF_PACKET sockets. Because the LAPB drivers first remove a 1-byte
> pseudo-header before handing over the skb to us, if we don't copy the
> skb before prepending the LAPB header, the first byte of the packets
> received on AF_PACKET sockets can be corrupted.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: Martin Schiller <ms@dev.tdt.de>
> Signed-off-by: Xie He <xie.he.0141@gmail.com>
> ---
>  net/lapb/lapb_out.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/net/lapb/lapb_out.c b/net/lapb/lapb_out.c
> index 7a4d0715d1c3..a966d29c772d 100644
> --- a/net/lapb/lapb_out.c
> +++ b/net/lapb/lapb_out.c
> @@ -82,7 +82,8 @@ void lapb_kick(struct lapb_cb *lapb)
>  		skb = skb_dequeue(&lapb->write_queue);
>  
>  		do {
> -			if ((skbn = skb_clone(skb, GFP_ATOMIC)) == NULL) {
> +			skbn = skb_copy(skb, GFP_ATOMIC);
> +			if (!skbn) {
>  				skb_queue_head(&lapb->write_queue, skb);
>  				break;
>  			}
> 

