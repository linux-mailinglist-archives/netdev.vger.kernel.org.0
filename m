Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D25F74970D0
	for <lists+netdev@lfdr.de>; Sun, 23 Jan 2022 10:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbiAWJvJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Jan 2022 04:51:09 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50356 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232476AbiAWJvH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Jan 2022 04:51:07 -0500
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20N5HWoY012517;
        Sun, 23 Jan 2022 09:50:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Z7Dj5lGb1uOT+vTLr/6uVEOh+q9MaDlOmh6nUv3kIoI=;
 b=GNIcCzTNv+1DUxx9ey5vckqo6yCjSbowHI+yBe/YaNeKz/hoOtN2VDygwldc/EHqsn+7
 tPd1+nd9EMdCFx3tWH3G+guZfyhlsVmqElNeHQMYBesN4xAch+s7Sxa9KKa0s1awOMnN
 BEy/nrHzo44t+HK+qBGfYdszt/PTk/L4s9fJU13HtLjnqC9IOnVohdCKKH5gtBMakvOm
 l5B4ofzQhcqeCxXJioeGzpVH8nHlfToJChS3QDYfEZoHK9OGV7b5MXNsxMLbPjstcUhX
 4dg1YCTsamPHlVL9kl2c7c1dlhQk9Bs0T6rzg0IBEITN1M6vYIvd2gyudPgfAgrMPaW+ fA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ds0r4k8ag-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Jan 2022 09:50:57 +0000
Received: from m0098393.ppops.net (m0098393.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20N9ounY013652;
        Sun, 23 Jan 2022 09:50:56 GMT
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3ds0r4k8a5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Jan 2022 09:50:56 +0000
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20N9lr9c022163;
        Sun, 23 Jan 2022 09:50:54 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma05fra.de.ibm.com with ESMTP id 3dr9j8d17e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sun, 23 Jan 2022 09:50:54 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20N9opDD44171674
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 23 Jan 2022 09:50:51 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A5CC7A404D;
        Sun, 23 Jan 2022 09:50:51 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 556A6A4040;
        Sun, 23 Jan 2022 09:50:51 +0000 (GMT)
Received: from osiris (unknown [9.145.22.167])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Sun, 23 Jan 2022 09:50:51 +0000 (GMT)
Date:   Sun, 23 Jan 2022 10:50:49 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net 2/2] net: Flush deferred skb free on socket destroy
Message-ID: <Ye0k+Z9nD4JY0OMd@osiris>
References: <20220117092733.6627-1-gal@nvidia.com>
 <20220117092733.6627-3-gal@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220117092733.6627-3-gal@nvidia.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: Q7IIc9GlfKYWh3MvF6Xo4YFq_DHzwBOp
X-Proofpoint-ORIG-GUID: NhYBjeXEYUceDqze4eRhNlHv4NkcLAFW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-23_02,2022-01-21_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0
 priorityscore=1501 impostorscore=0 clxscore=1011 lowpriorityscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 malwarescore=0 adultscore=0
 mlxscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201230074
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 17, 2022 at 11:27:33AM +0200, Gal Pressman wrote:
> The cited Fixes patch moved to a deferred skb approach where the skbs
> are not freed immediately under the socket lock.  Add a WARN_ON_ONCE()
> to verify the deferred list is empty on socket destroy, and empty it to
> prevent potential memory leaks.
> 
> Fixes: f35f821935d8 ("tcp: defer skb freeing after socket lock is released")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  net/core/sock.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/net/core/sock.c b/net/core/sock.c
> index f32ec08a0c37..4ff806d71921 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -2049,6 +2049,9 @@ void sk_destruct(struct sock *sk)
>  {
>  	bool use_call_rcu = sock_flag(sk, SOCK_RCU_FREE);
>  
> +	WARN_ON_ONCE(!llist_empty(&sk->defer_list));
> +	sk_defer_free_flush(sk);
> +

This leads to a link error if CONFIG_INET is not set:

s390x-11.2.0-ld: net/core/sock.o: in function `sk_defer_free_flush':
linux/./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'
make: *** [Makefile:1155: vmlinux] Error 1
