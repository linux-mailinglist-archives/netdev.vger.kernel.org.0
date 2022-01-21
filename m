Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74A4F495C42
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 09:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235602AbiAUIqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 03:46:48 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:37980 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S234529AbiAUIqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 03:46:47 -0500
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20L5hDpn008234;
        Fri, 21 Jan 2022 08:46:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=0+LT8LI/K75QPhuUQ2TZ/IDnueUkgYGAAxwBnnu+IQY=;
 b=oF2z25b8vkEFMFSsI0W7yzcqVZNtxRaAGWqQAFdxaSi8u0ZWSbD9jPrj4R2uV62x7cOE
 eAbcinXdbaRw1zTZR2SYaIS3NH9agMm6g2U+1zDf7IVLW21kNgKsqUN55qcOzFHJZJ4w
 XXlbkBeAABDRSMGJZX90vPdupjaB7KmFka7h1cbZguRdX9kMesmpHdbzM8bpPszGXSoO
 YQuR1Rj+BtlDDI7tI6PrnY4uG6YULlEzGoWzj6ptRgMicKrN328P0XO2ZFQZDJIRwI0X
 ebhZ7wMyY1hdw/6hndbeH83G/A2Uik7g05/o/QAafYgMU/D26o9mN9JyfNohKOU/qs9D zw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqpx2332x-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 08:46:38 +0000
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20L8kb5v004316;
        Fri, 21 Jan 2022 08:46:37 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dqpx2332c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 08:46:37 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20L8cIPJ013061;
        Fri, 21 Jan 2022 08:46:35 GMT
Received: from b06cxnps4076.portsmouth.uk.ibm.com (d06relay13.portsmouth.uk.ibm.com [9.149.109.198])
        by ppma03ams.nl.ibm.com with ESMTP id 3dqjdpjnpw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 21 Jan 2022 08:46:35 +0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4076.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20L8kX9941156914
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 Jan 2022 08:46:33 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 634F8AE053;
        Fri, 21 Jan 2022 08:46:33 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 13CACAE055;
        Fri, 21 Jan 2022 08:46:33 +0000 (GMT)
Received: from [9.145.9.162] (unknown [9.145.9.162])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 21 Jan 2022 08:46:32 +0000 (GMT)
Message-ID: <d001482c-669d-de3e-34c3-324793c48442@linux.ibm.com>
Date:   Fri, 21 Jan 2022 09:46:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] net/smc: Transitional solution for clcsock race issue
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1642086177-130611-1-git-send-email-guwen@linux.alibaba.com>
 <ad5c1c9b-5d9e-cd0f-88c7-4420bc9ed0e5@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <ad5c1c9b-5d9e-cd0f-88c7-4420bc9ed0e5@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GoDfJJCAjvUnrsCPA5HfvrhT9PyvE_Mk
X-Proofpoint-ORIG-GUID: ZYqL5pGaiQwOkETQe0qFt6TS6INMAWjO
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_06,2022-01-20_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 phishscore=0 bulkscore=0 adultscore=0 impostorscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 spamscore=0 mlxlogscore=875
 clxscore=1015 suspectscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2201110000 definitions=main-2201210056
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/01/2022 08:05, Wen Gu wrote:
> On 2022/1/13 11:02 pm, Wen Gu wrote:
> Sorry for bothering, just wonder if this patch needs further improvements?

Can you resend the patch and add the Fixes: tag? This should be done for all patches sent to the net tree.

Other than that as discussed before:

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
