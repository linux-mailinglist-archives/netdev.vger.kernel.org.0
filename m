Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A810544E810
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 15:02:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235090AbhKLOFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 09:05:08 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:51418 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235071AbhKLOFH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 09:05:07 -0500
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1ACDfZAZ015490;
        Fri, 12 Nov 2021 14:02:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=nDodJj57nnM0nM3L9GHbulclSK9+sUTDdF2zO6gw5wc=;
 b=CuEAwSEKWhv60po84XaJQ3FktK1FTgtULtrjIDNX4lUz8YbzSqeJvdBu0iFY/iR19tno
 GkVqSEL3at9wf1rARF+YyAX//xMjkHvO+MuZPh8D1fA1k/HQtMQ7OgkbN/sKGYzB8a1T
 CIivSXoiFwhzT14/HAv1XmejQTNJSgV0C6IQ8xKtl7nXmdJ7F2qnD677NFM2moHyvtd1
 K9uPnndLrcPwPGCt26HFZk58o3diQ0YGsWvYr3ywwX2/xvML89f2cF0bDO1gE/cYgM5C
 qBja93XlDds+nQx+qysFOzARZkD7Bma4UbvL/A1x5LiFlBQKhuHffBQAJRV2TPfw8Nrb eg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c9rhbhfqk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Nov 2021 14:02:15 +0000
Received: from m0098409.ppops.net (m0098409.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1ACE1LH5020171;
        Fri, 12 Nov 2021 14:02:15 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c9rhbhfpk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Nov 2021 14:02:15 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1ACDcrjP011123;
        Fri, 12 Nov 2021 14:02:13 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma06ams.nl.ibm.com with ESMTP id 3c5gykh11x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 12 Nov 2021 14:02:12 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1ACDtOEt61145432
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 12 Nov 2021 13:55:24 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6FE3511C04C;
        Fri, 12 Nov 2021 14:02:10 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 06CF811C052;
        Fri, 12 Nov 2021 14:02:10 +0000 (GMT)
Received: from osiris (unknown [9.145.153.146])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTPS;
        Fri, 12 Nov 2021 14:02:09 +0000 (GMT)
Date:   Fri, 12 Nov 2021 15:02:08 +0100
From:   Heiko Carstens <hca@linux.ibm.com>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tonylu@linux.alibaba.com,
        dust.li@linux.alibaba.com, xuanzhuo@linux.alibaba.com
Subject: Re: [PATCH net] net/smc: Transfer remaining wait queue entries
 during fallback
Message-ID: <YY5z4H5/CVpRtrwh@osiris>
References: <1636687839-38962-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1636687839-38962-1-git-send-email-guwen@linux.alibaba.com>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: hLZJsSYm8M3wCHpbbHJMnvZbmjW-nvnr
X-Proofpoint-GUID: aBw7o5ShLNFfLg7BX22CABdROqgtpRtZ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-12_05,2021-11-12_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 mlxscore=0
 phishscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=0
 suspectscore=0 spamscore=0 bulkscore=0 clxscore=1011 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111120080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 11:30:39AM +0800, Wen Gu wrote:
...
> +	wait_queue_head_t *smc_wait = sk_sleep(&smc->sk);
> +	wait_queue_head_t *clc_wait = sk_sleep(smc->clcsock->sk);
> +	unsigned long flags;
> +
>  	smc->use_fallback = true;
>  	smc->fallback_rsn = reason_code;
>  	smc_stat_fallback(smc);
> @@ -571,6 +575,16 @@ static void smc_switch_to_fallback(struct smc_sock *smc, int reason_code)
>  		smc->clcsock->file->private_data = smc->clcsock;
>  		smc->clcsock->wq.fasync_list =
>  			smc->sk.sk_socket->wq.fasync_list;
> +
> +		/* There might be some wait queue entries remaining
> +		 * in smc socket->wq, which should be removed to
> +		 * clcsocket->wq during the fallback.
> +		 */
> +		spin_lock_irqsave(&smc_wait->lock, flags);
> +		spin_lock_irqsave(&clc_wait->lock, flags);
> +		list_splice_init(&smc_wait->head, &clc_wait->head);
> +		spin_unlock_irqrestore(&clc_wait->lock, flags);
> +		spin_unlock_irqrestore(&smc_wait->lock, flags);

No idea if the rest of the patch makes sense, however this usage of
spin_lock_irqsave() is not correct. The second spin_lock_irqsave()
would always save a state with irqs disabled into "flags", and
therefore this path would always be left with irqs disabled,
regardless if irqs were enabled or disabled when entering.

You need to change it to something like

> +		spin_lock_irqsave(&smc_wait->lock, flags);
> +		spin_lock(&clc_wait->lock);
> +		list_splice_init(&smc_wait->head, &clc_wait->head);
> +		spin_unlock(&clc_wait->lock);
> +		spin_unlock_irqrestore(&smc_wait->lock, flags);
