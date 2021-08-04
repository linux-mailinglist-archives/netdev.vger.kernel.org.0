Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C563DFB79
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 08:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235571AbhHDGge (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 02:36:34 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37500 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234591AbhHDGgd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Aug 2021 02:36:33 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1746YVnN136551;
        Wed, 4 Aug 2021 02:36:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7uhHyolhhabnaBZToujkywYbLmOYIOBSlAGjyBfoCC4=;
 b=RQeei9YZomsmoJvR/ZPCoz4ekrSojNL3imrt7bxI761EIZ0oay8yXYr+YPHUWpAd7ePA
 kjrv93+t12Iv6rTLFOW8NpC0nTqKLBK0XKf4DtZ6SZbrKTGaY8BePb0oP2oqQkJykVg7
 eP2Vt6kpK7yoC5j0IWOKXr3z4u/xsmBbjmcTwK4W4WrOYtz7td69NyHC1T6JRjTdi2IM
 NWq3kwJbWC9UsV87LgdtKTQeS30cj++56h1o7kgKmxQwQFaEj/KYNkTtiQ1JLpmQudYV
 YD46Jqog6JasqDpuePO2XjowFunGIQrM6enyYata90S0T8iue2+GlO6frn/ZMnJ1Dxdr Bg== 
Received: from ppma05fra.de.ibm.com (6c.4a.5195.ip4.static.sl-reverse.com [149.81.74.108])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3a7342e5t3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 02:36:09 -0400
Received: from pps.filterd (ppma05fra.de.ibm.com [127.0.0.1])
        by ppma05fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 1746BiZM013303;
        Wed, 4 Aug 2021 06:36:07 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma05fra.de.ibm.com with ESMTP id 3a4x58fsg5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 04 Aug 2021 06:36:06 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1746a4U755509278
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 4 Aug 2021 06:36:04 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59C5642097;
        Wed,  4 Aug 2021 06:36:04 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4889242083;
        Wed,  4 Aug 2021 06:36:03 +0000 (GMT)
Received: from [9.145.13.232] (unknown [9.145.13.232])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Wed,  4 Aug 2021 06:36:03 +0000 (GMT)
Subject: Re: [PATCH 22/38] net/af_iucv: Replace deprecated CPU-hotplug
 functions.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Cc:     tglx@linutronix.de, Peter Zijlstra <peterz@infradead.org>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org
References: <20210803141621.780504-1-bigeasy@linutronix.de>
 <20210803141621.780504-23-bigeasy@linutronix.de>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <9c86b167-c657-435e-3f23-a3e798797069@linux.ibm.com>
Date:   Wed, 4 Aug 2021 09:36:02 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210803141621.780504-23-bigeasy@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: BVdelk-Abp68oFLz4UVuLcwpyLp9r2Ve
X-Proofpoint-GUID: BVdelk-Abp68oFLz4UVuLcwpyLp9r2Ve
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-08-04_02:2021-08-03,2021-08-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999
 malwarescore=0 adultscore=0 spamscore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 impostorscore=0 phishscore=0 suspectscore=0
 clxscore=1011 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108040035
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.08.21 17:16, Sebastian Andrzej Siewior wrote:
> The functions get_online_cpus() and put_online_cpus() have been
> deprecated during the CPU hotplug rework. They map directly to
> cpus_read_lock() and cpus_read_unlock().
> 
> Replace deprecated CPU-hotplug functions with the official version.
> The behavior remains unchanged.
> 
> Cc: Julian Wiedmann <jwi@linux.ibm.com>
> Cc: Karsten Graul <kgraul@linux.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: linux-s390@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  net/iucv/iucv.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 

Applied, thanks.

I fixed up the subject to say "net/iucv: ...", as the change is in
the iucv base-layer and not the socket code.
