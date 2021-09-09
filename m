Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84A4404556
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 08:02:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351064AbhIIGDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 02:03:17 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:22922 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1351007AbhIIGDP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Sep 2021 02:03:15 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1895XYsd160903;
        Thu, 9 Sep 2021 02:02:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pp1;
 bh=Bniqri9MMZkWL4BcC80wpYalGB3I9kfht9xfS/+NPuA=;
 b=fnrm/lYQqShOZO23oZuijEowgc3frhlDwQ5LyTprvvXE1N+qmQ5ycNyHdB4+rjmgkOWW
 a7R1CUGNraOvu9tfIadu33AGU0RovGYDp6VbqaCV6ybut3X0KDuNMuLmDFCeTH7Aq5u6
 yLgYsYRSXW+PrlVH9qgrByNu5JXgCt1iMd0xIzMdBK8T3D/RP64M71aeJ5B091TMINGU
 TTC2Moefnxd3zT3dmRtSjgl+vrRMhEIZi6SbHGheMtgpueTbac4B/IWNhUeppN4qMgsB
 gN51T2wB7oKaiKWOZ/lIIz6XeO8CFZgoUezGwmzijHbC/0q5mrYjRHHU4CYgOE7pIT+h CA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ay3cwttcf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 02:02:06 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 1895qk8U030249;
        Thu, 9 Sep 2021 02:02:05 -0400
Received: from ppma02fra.de.ibm.com (47.49.7a9f.ip4.static.sl-reverse.com [159.122.73.71])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3ay3cwttbs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 02:02:05 -0400
Received: from pps.filterd (ppma02fra.de.ibm.com [127.0.0.1])
        by ppma02fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1895wHS9018989;
        Thu, 9 Sep 2021 06:02:03 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma02fra.de.ibm.com with ESMTP id 3axcnk84d7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 09 Sep 2021 06:02:03 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 189620oK50266522
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 9 Sep 2021 06:02:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 65F5042047;
        Thu,  9 Sep 2021 06:02:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id C04074204F;
        Thu,  9 Sep 2021 06:01:59 +0000 (GMT)
Received: from [9.171.14.134] (unknown [9.171.14.134])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu,  9 Sep 2021 06:01:59 +0000 (GMT)
Subject: Re: [PATCH] s390/ism: switch from 'pci_' to 'dma_' API
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jwi@linux.ibm.com, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@de.ibm.com
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <04d96a44cad009f15334876321aa236dc169b24c.1629753393.git.christophe.jaillet@wanadoo.fr>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
Message-ID: <e57bb882-fc43-e24e-361b-1fd26996aebe@linux.ibm.com>
Date:   Thu, 9 Sep 2021 08:02:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <04d96a44cad009f15334876321aa236dc169b24c.1629753393.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: _6SuNhk299Qng7ujndXRjzl6QAYjp0dx
X-Proofpoint-ORIG-GUID: k4QMLt1AAXR98gcYOiMUX9-KvP5U18HV
Content-Transfer-Encoding: 7bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-09-09_01:2021-09-07,2021-09-09 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 spamscore=0 mlxscore=0 impostorscore=0 phishscore=0
 adultscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011 malwarescore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109090033
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23/08/2021 23:17, Christophe JAILLET wrote:
> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below.
> 
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=kernel-janitors&m=158745678307186&w=4
> 
> This has *NOT* been compile tested because I don't have the needed
> configuration.
> ---
>  drivers/s390/net/ism_drv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thank you for the patch. I compile tested successfully, we will 
include the patch in our next submission for the net-next tree.
