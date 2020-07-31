Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E215123407F
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 09:50:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731738AbgGaHuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 03:50:52 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:29620 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731702AbgGaHuw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 03:50:52 -0400
Received: from pps.filterd (m0127361.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 06V7YKQ5168076;
        Fri, 31 Jul 2020 03:50:49 -0400
Received: from ppma03fra.de.ibm.com (6b.4a.5195.ip4.static.sl-reverse.com [149.81.74.107])
        by mx0a-001b2d01.pphosted.com with ESMTP id 32md1yu2ye-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 03:50:48 -0400
Received: from pps.filterd (ppma03fra.de.ibm.com [127.0.0.1])
        by ppma03fra.de.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 06V7im39030341;
        Fri, 31 Jul 2020 07:50:47 GMT
Received: from b06avi18878370.portsmouth.uk.ibm.com (b06avi18878370.portsmouth.uk.ibm.com [9.149.26.194])
        by ppma03fra.de.ibm.com with ESMTP id 32gcr0m9ec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 31 Jul 2020 07:50:47 +0000
Received: from d06av24.portsmouth.uk.ibm.com (d06av24.portsmouth.uk.ibm.com [9.149.105.60])
        by b06avi18878370.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 06V7oipN63045902
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 31 Jul 2020 07:50:44 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 1835F4204C;
        Fri, 31 Jul 2020 07:50:44 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9D4EC4203F;
        Fri, 31 Jul 2020 07:50:43 +0000 (GMT)
Received: from [9.145.25.216] (unknown [9.145.25.216])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Fri, 31 Jul 2020 07:50:43 +0000 (GMT)
Subject: Re: [PATCH net-next 4/4] s390/qeth: use all configured RX buffers
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
References: <20200730150121.18005-1-jwi@linux.ibm.com>
 <20200730150121.18005-5-jwi@linux.ibm.com>
 <20200730163714.7d6a5017@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Message-ID: <dcc95391-0dea-e7d4-1901-25c00c7a3c60@linux.ibm.com>
Date:   Fri, 31 Jul 2020 09:50:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200730163714.7d6a5017@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.235,18.0.687
 definitions=2020-07-31_02:2020-07-31,2020-07-31 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 clxscore=1015 priorityscore=1501 malwarescore=0 mlxlogscore=999
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=2
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007310054
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.07.20 01:37, Jakub Kicinski wrote:
> On Thu, 30 Jul 2020 17:01:21 +0200 Julian Wiedmann wrote:
>> The (misplaced) comment doesn't make any sense, enforcing an
>> uninitialized RX buffer won't help with IRQ reduction.
>>
>> So make the best use of all available RX buffers.
> 
> Often one entry in the ring is left free to make it easy to
> differentiate between empty and full conditions. 
> 
> Is this not the reason here?
> 

Hmm no, the HW architecture works slightly different.

There's no index register that we could query for HW progress,
each ring entry has an associated state byte that needs to be
inspected and indicates HW progress (among other things).

So this was more likely just a mis-interpretation of how the
(quirky) IRQ reduction mechanism works in HW, or maybe part of
a code path that got removed during the NAPI conversion.
