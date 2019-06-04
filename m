Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4F8E34118
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfFDIEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:04:08 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42678 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726925AbfFDIEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 04:04:08 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x5482hLZ015683
        for <netdev@vger.kernel.org>; Tue, 4 Jun 2019 04:04:07 -0400
Received: from e06smtp02.uk.ibm.com (e06smtp02.uk.ibm.com [195.75.94.98])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2swkqk337d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 04:04:06 -0400
Received: from localhost
        by e06smtp02.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Tue, 4 Jun 2019 09:04:04 +0100
Received: from b06cxnps3074.portsmouth.uk.ibm.com (9.149.109.194)
        by e06smtp02.uk.ibm.com (192.168.101.132) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 4 Jun 2019 09:04:01 +0100
Received: from d06av24.portsmouth.uk.ibm.com (mk.ibm.com [9.149.105.60])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x54840Zn51249238
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 Jun 2019 08:04:00 GMT
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 4BE064203F;
        Tue,  4 Jun 2019 08:04:00 +0000 (GMT)
Received: from d06av24.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0855542045;
        Tue,  4 Jun 2019 08:04:00 +0000 (GMT)
Received: from [9.152.222.52] (unknown [9.152.222.52])
        by d06av24.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Tue,  4 Jun 2019 08:03:59 +0000 (GMT)
Subject: Re: [PATCH net 2/4] s390/qeth: don't use obsolete dst entry
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, raspl@linux.ibm.com,
        ubraun@linux.ibm.com
References: <20190603150446.23351-1-jwi@linux.ibm.com>
 <20190603150446.23351-3-jwi@linux.ibm.com>
 <20190603.124348.5212561789204100.davem@davemloft.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Tue, 4 Jun 2019 10:03:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190603.124348.5212561789204100.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 19060408-0008-0000-0000-000002EDE626
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19060408-0009-0000-0000-0000225AC8D5
Message-Id: <06972ee2-43ac-045f-8d7e-568752908ecd@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-04_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=932 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906040055
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.06.19 21:43, David Miller wrote:
> From: Julian Wiedmann <jwi@linux.ibm.com>
> Date: Mon,  3 Jun 2019 17:04:44 +0200
> 
>> While qeth_l3 uses netif_keep_dst() to hold onto the dst, a skb's dst
>> may still have been obsoleted (via dst_dev_put()) by the time that we
>> end up using it. The dst then points to the loopback interface, which
>> means the neighbour lookup in qeth_l3_get_cast_type() determines a bogus
>> cast type of RTN_BROADCAST.
>> For IQD interfaces this causes us to place such skbs on the wrong
>> HW queue, resulting in TX errors.
>>
>> Fix-up the various call sites to check whether the dst is obsolete, and
>> fall back accordingly.
>>
>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> 
> Please use "dst_check()".
> 
> Some routes have DST_OBSOLETE_FORCE_CHK set on them from the very beginning
> so that uses of the route are forced through the dst->ops->check() method.
> 
> Simply use dst_check() and then you can just retain the 'rt == NULL' logic
> as-is.
> 
> Thanks.
> 
Alright - I was hesitant to go down that path in the context of a driver,
but looks like rt6_get_cookie() should do the trick. v2 coming up... thanks.

