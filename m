Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE4C49E551
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 15:59:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238091AbiA0O7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 09:59:40 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:8698 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233473AbiA0O7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 09:59:39 -0500
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20REfigt030373;
        Thu, 27 Jan 2022 14:59:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=inKHah+VEsfzUdiYlIOFTgi2CaHuGDHs0qs6LOJQxU4=;
 b=C+J/v07JCuw58z4ZJtClNngqI7oAgRgWWbNsJIkvxiHoXmyUpaNnSojoa96IdeuM5WX3
 FhUQpD37dVmSe3iju/KIUBJ+n+Q/UcBBAT2D027g4V2XFMUiMhLsq4m1/0iHCzlMwBLf
 lWEGIrzpo2syoIJHANihX/PWJks/LMH5jI4KqB9wtfYZc1tZrNc8iCCV36Bb3zZD980U
 4zKxvOm9Sr37CoLj1eSkyoj0IMkJyrK+huz6SALvFZppXt3Wn+fmwiN6pVE1/sx1Xc8V
 qLigssC4VzIYw5AIQB39N2N9c5TXr/2iEEXIGdjGUGKbzhc/ZKlPsV9k+LfdclRAgwp1 kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3duta8vk94-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:59:37 +0000
Received: from m0098410.ppops.net (m0098410.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20REk3du013443;
        Thu, 27 Jan 2022 14:59:37 GMT
Received: from ppma04fra.de.ibm.com (6a.4a.5195.ip4.static.sl-reverse.com [149.81.74.106])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3duta8vk8e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:59:37 +0000
Received: from pps.filterd (ppma04fra.de.ibm.com [127.0.0.1])
        by ppma04fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20RErCUe026913;
        Thu, 27 Jan 2022 14:59:34 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma04fra.de.ibm.com with ESMTP id 3dr9j9y2nf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 27 Jan 2022 14:59:34 +0000
Received: from d06av22.portsmouth.uk.ibm.com (d06av22.portsmouth.uk.ibm.com [9.149.105.58])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20RExV3m46792972
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Jan 2022 14:59:31 GMT
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BAD694C04A;
        Thu, 27 Jan 2022 14:59:31 +0000 (GMT)
Received: from d06av22.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 783194C059;
        Thu, 27 Jan 2022 14:59:31 +0000 (GMT)
Received: from [9.152.222.35] (unknown [9.152.222.35])
        by d06av22.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Thu, 27 Jan 2022 14:59:31 +0000 (GMT)
Message-ID: <c32293df-44c2-fedf-7fee-40f3d01fd475@linux.ibm.com>
Date:   Thu, 27 Jan 2022 15:59:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next 0/2] net/smc: Spread workload over multiple cores
Content-Language: en-US
To:     Tony Lu <tonylu@linux.alibaba.com>, kuba@kernel.org,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
References: <20220126130140.66316-1-tonylu@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <20220126130140.66316-1-tonylu@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: upm9WjGLpsFHnmkH-8yvb8N71Y4Q9r-V
X-Proofpoint-ORIG-GUID: odXEawHBf9Zy_TDAqIns_WJcfksMic_a
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-27_03,2022-01-27_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 phishscore=0 malwarescore=0 suspectscore=0 mlxscore=0
 spamscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201270088
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 14:01, Tony Lu wrote:
> Currently, SMC creates one CQ per IB device, and shares this cq among
> all the QPs of links. Meanwhile, this CQ is always binded to the first
> completion vector, the IRQ affinity of this vector binds to some CPU
> core. 

As discussed in the RFC thread, please come back with the complete fix.

Thanks for the work you are putting in here!

And thanks for the feedback from the rdma side!
