Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDC77462D3E
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 08:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238894AbhK3HDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 02:03:31 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:61422 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233863AbhK3HDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 02:03:30 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AU6kSIJ029061;
        Tue, 30 Nov 2021 06:59:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=Os54uh6+86z+9TMgn2hM1W+YHFgZck8Z4OqqtksIPCc=;
 b=morA2jHr2QT81DVyqznzdx25UC9RQOJd8yr+zgNCk14Ty0F+HHT+eEe4pCvUVGY7IUEd
 Mt2hMDDnQhtrJaystigLLHpYg3NPn4HH9/9xCkjBu62iopPzwVEGZ9uBiie0BSpROEdj
 GfOOs+0QVLt+4U3v59gn//hMYVCDe2hTYev0NIbuAXdSt7z8iEWiYIOZytcY8N1C7EjR
 y2jSltTkbDFHuNBpadawhG0Ph45pNpWv0ofgOycxtUhTKr0vblBTDvhaDrlLXwFffvdS
 tEg/dk27cKMsm1uWwVu0QDY7k/+rwHyLMvecMfRLbYcAqTDBuCXk9f41uunfUpE6G0r/ yw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnf00g7ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 06:59:44 +0000
Received: from m0098404.ppops.net (m0098404.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1AU6xhNp025035;
        Tue, 30 Nov 2021 06:59:43 GMT
Received: from ppma06ams.nl.ibm.com (66.31.33a9.ip4.static.sl-reverse.com [169.51.49.102])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3cnf00g7xd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 06:59:43 +0000
Received: from pps.filterd (ppma06ams.nl.ibm.com [127.0.0.1])
        by ppma06ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1AU6wEnh022674;
        Tue, 30 Nov 2021 06:59:41 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma06ams.nl.ibm.com with ESMTP id 3ckbxjubxr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 30 Nov 2021 06:59:41 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1AU6xcJD10027330
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Nov 2021 06:59:38 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CEB054C058;
        Tue, 30 Nov 2021 06:59:38 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C20B94C04A;
        Tue, 30 Nov 2021 06:59:37 +0000 (GMT)
Received: from [9.171.21.37] (unknown [9.171.21.37])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue, 30 Nov 2021 06:59:37 +0000 (GMT)
Message-ID: <0bdb87c5-a643-0d86-6dae-bc9bec9d6a92@linux.ibm.com>
Date:   Tue, 30 Nov 2021 08:59:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCHv2] ethernet: aquantia: Try MAC address from device tree
Content-Language: en-US
To:     Tianhao Chai <cth451@gmail.com>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>
References: <20211130045147.GA1456556@cth-desktop-dorm.mad.wi.cth451.me>
From:   Julian Wiedmann <jwi@linux.ibm.com>
In-Reply-To: <20211130045147.GA1456556@cth-desktop-dorm.mad.wi.cth451.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: uedZnYphQ7E1zBfpPDRwT2ZpfCkOxohH
X-Proofpoint-GUID: iPKwrgt3t7eJ9M0kuHbWAZKky8ZPLlPF
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-30_05,2021-11-28_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 clxscore=1011 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 mlxscore=0 phishscore=0 malwarescore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111300036
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30.11.21 06:51, Tianhao Chai wrote:
> Apple M1 Mac minis (2020) with 10GE NICs do not have MAC address in the
> card, but instead need to obtain MAC addresses from the device tree. In
> this case the hardware will report an invalid MAC.
> 
> Currently atlantic driver does not query the DT for MAC address and will
> randomly assign a MAC if the NIC doesn't have a permanent MAC burnt in.
> This patch causes the driver to perfer a valid MAC address from OF (if
> present) over HW self-reported MAC and only fall back to a random MAC
> address when neither of them is valid.
> 
> Signed-off-by: Tianhao Chai <cth451@gmail.com>
> ---
>  .../net/ethernet/aquantia/atlantic/aq_nic.c   | 27 ++++++++++++-------
>  1 file changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> index 1acf544afeb4..ad89721c1cf6 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
> @@ -316,18 +316,25 @@ int aq_nic_ndev_register(struct aq_nic_s *self)
>  	aq_macsec_init(self);
>  #endif
>  
> -	mutex_lock(&self->fwreq_mutex);
> -	err = self->aq_fw_ops->get_mac_permanent(self->aq_hw, addr);
> -	mutex_unlock(&self->fwreq_mutex);
> -	if (err)
> -		goto err_exit;
> +	if (eth_platform_get_mac_address(&self->pdev->dev, addr) == 0) {
> +		// DT supplied a valid MAC address
> +		eth_hw_addr_set(self->ndev, addr);

Can you use platform_get_ethdev_address() instead?
