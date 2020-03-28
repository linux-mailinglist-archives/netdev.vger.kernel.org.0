Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7437196512
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 11:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726197AbgC1KeP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 06:34:15 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:53542 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726156AbgC1KeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Mar 2020 06:34:15 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 02SAWMQL056763
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 06:34:14 -0400
Received: from e06smtp01.uk.ibm.com (e06smtp01.uk.ibm.com [195.75.94.97])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3022jsadf9-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Sat, 28 Mar 2020 06:34:14 -0400
Received: from localhost
        by e06smtp01.uk.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <netdev@vger.kernel.org> from <jwi@linux.ibm.com>;
        Sat, 28 Mar 2020 10:34:04 -0000
Received: from b06cxnps4075.portsmouth.uk.ibm.com (9.149.109.197)
        by e06smtp01.uk.ibm.com (192.168.101.131) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Sat, 28 Mar 2020 10:34:01 -0000
Received: from d06av26.portsmouth.uk.ibm.com (d06av26.portsmouth.uk.ibm.com [9.149.105.62])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 02SAY82i54067410
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 28 Mar 2020 10:34:08 GMT
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 0B559AE045;
        Sat, 28 Mar 2020 10:34:08 +0000 (GMT)
Received: from d06av26.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CB500AE051;
        Sat, 28 Mar 2020 10:34:07 +0000 (GMT)
Received: from [9.145.26.221] (unknown [9.145.26.221])
        by d06av26.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Sat, 28 Mar 2020 10:34:07 +0000 (GMT)
Subject: Re: [PATCH net] s390/qeth: support net namespaces for L3 devices
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, ubraun@linux.ibm.com
References: <20200327110042.50797-1-jwi@linux.ibm.com>
 <20200327.153902.1896503128370913021.davem@davemloft.net>
From:   Julian Wiedmann <jwi@linux.ibm.com>
Date:   Sat, 28 Mar 2020 11:34:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200327.153902.1896503128370913021.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
x-cbid: 20032810-4275-0000-0000-000003B4EDBB
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 20032810-4276-0000-0000-000038CA36B1
Message-Id: <f0db28f1-d1a2-7173-1ac7-123f514768b1@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.645
 definitions=2020-03-28_03:2020-03-27,2020-03-28 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 adultscore=0
 bulkscore=0 phishscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 clxscore=1015 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003280095
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.20 23:39, David Miller wrote:
> From: Julian Wiedmann <jwi@linux.ibm.com>
> Date: Fri, 27 Mar 2020 12:00:42 +0100
> 
>> Enable the L3 driver's IPv4 address notifier to watch for events on qeth
>> devices that have been moved into a net namespace. We need to program
>> those IPs into the HW just as usual, otherwise inbound traffic won't
>> flow.
>>
>> Fixes: 6133fb1aa137 ("[NETNS]: Disable inetaddr notifiers in namespaces other than initial.")
>> Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
> 
> This looks more like a feature, openning the L3 driver into multiple
> namespaces, rather than a critical fix.
> 

Definitely not 'critical', agreed. It's rather silly though that things
currently work just fine for IPv6, but not for IPv4.

Mind queueing this up for net-next then instead? Thanks.

