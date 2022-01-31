Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A12734A3E47
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 08:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbiAaHjx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 02:39:53 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:10272 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235089AbiAaHjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Jan 2022 02:39:53 -0500
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20V7XuvW027604;
        Mon, 31 Jan 2022 07:39:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=7iwIc/0uE4CQI9sIaooSotPFRwTQ6Q0TOGBw0+rbzVI=;
 b=V4Bnui0et6VzYKWMi/2UscyssXNBi5osQvrON9KGYXca9XkSElmm60w1RyZhhKW4vEUl
 whM6ZZG4xv+hE0XROjl/5Tn0TOmAHksOwGSt2itaYdSk4fiNTnHmbLad7ufkwNyjgkWL
 HMHX0zivavhBEkE07zKa+sDFkbB6IDoWtnr3NA1SfK3VVyNUO9ddSHsp77FO9U7ymaGI
 ODnImXapRkcPbDoQhpZxWGRDVakbvUzGFgJUBJTKTHsY/R7dSXUe4k1XKx5tTUd3Df08
 Do1Nw82gd+ZLd4PG2l5LbITyqIu58ceWSYkxsqITW5NSbL95LMrKuoRREBrJTeDgOhaW AQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dwexp4q9g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 07:39:42 +0000
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 20V7Z6uJ030865;
        Mon, 31 Jan 2022 07:39:41 GMT
Received: from ppma03ams.nl.ibm.com (62.31.33a9.ip4.static.sl-reverse.com [169.51.49.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dwexp4q98-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 07:39:41 +0000
Received: from pps.filterd (ppma03ams.nl.ibm.com [127.0.0.1])
        by ppma03ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20V7cF5h030563;
        Mon, 31 Jan 2022 07:39:39 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma03ams.nl.ibm.com with ESMTP id 3dvw798tbx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 31 Jan 2022 07:39:39 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20V7dbFk41943450
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 31 Jan 2022 07:39:37 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 550A611C052;
        Mon, 31 Jan 2022 07:39:37 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F386111C050;
        Mon, 31 Jan 2022 07:39:36 +0000 (GMT)
Received: from [9.145.79.147] (unknown [9.145.79.147])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 31 Jan 2022 07:39:36 +0000 (GMT)
Message-ID: <a11cc19d-a2c0-32e0-7534-11dac5f6753e@linux.ibm.com>
Date:   Mon, 31 Jan 2022 08:39:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net] net/smc: Forward wakeup to smc socket waitqueue after
 fallback
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1643211184-53645-1-git-send-email-guwen@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <1643211184-53645-1-git-send-email-guwen@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: MU1qctkQpv0rWYqh9LbEmKUDcYOrsmCD
X-Proofpoint-ORIG-GUID: 8yjufBpds7F-sxT2dp7SXWLbUdxFUSlD
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-31_02,2022-01-28_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 suspectscore=0 lowpriorityscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 phishscore=0 malwarescore=0 adultscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2201310050
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/01/2022 16:33, Wen Gu wrote:
> When we replace TCP with SMC and a fallback occurs, there may be
> some socket waitqueue entries remaining in smc socket->wq, such
> as eppoll_entries inserted by userspace applications.
> 
> After the fallback, data flows over TCP/IP and only clcsocket->wq
> will be woken up. Applications can't be notified by the entries
> which were inserted in smc socket->wq before fallback. So we need
> a mechanism to wake up smc socket->wq at the same time if some
> entries remaining in it.

Acked-by: Karsten Graul <kgraul@linux.ibm.com>
