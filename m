Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA083483016
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 11:52:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231479AbiACKwa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 05:52:30 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:24462 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229651AbiACKw3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 05:52:29 -0500
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 203ADPqs023973;
        Mon, 3 Jan 2022 10:52:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=pp1;
 bh=n6Xbthcr2r/+NQ+vvbKwFRU8b7SKMTkmNEAkxM2vAmQ=;
 b=BCtZdSr+Xqu/MfL80y//uW/6N6LToGN5Xoqs/RHUcyQnY+HbnhCoNxPhlIWY4fGbJU0S
 rlCikX2FeoXjbmAqlxo+gnhS8TyUZCWTk9oWex5DZwc4m7OBtzK6g+GYBFtdM4x5gMPc
 k7qjxcHXrFvo/AasmpFTxnWBDYhOhneA/U4bE9PvGC3+J/NCG8PnBc6XvvFOQl4wYAkF
 C3or5asBy9YN1XvfqmIJanCM1o3X2VBcnThzduju28JjKornTP9x8bmKsus8hW8rb69n
 IW6OH/egtKpESJJEdT9DsXB+oA+koMlL+paZTV/vEvnRM9xojFs5gysYe+Wo1JDR3ToM 2Q== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dby70gkhm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:52:27 +0000
Received: from m0098396.ppops.net (m0098396.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 203ApbSE018976;
        Mon, 3 Jan 2022 10:52:27 GMT
Received: from ppma04ams.nl.ibm.com (63.31.33a9.ip4.static.sl-reverse.com [169.51.49.99])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3dby70gkh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:52:27 +0000
Received: from pps.filterd (ppma04ams.nl.ibm.com [127.0.0.1])
        by ppma04ams.nl.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 203AnvIo017501;
        Mon, 3 Jan 2022 10:52:25 GMT
Received: from b06cxnps3074.portsmouth.uk.ibm.com (d06relay09.portsmouth.uk.ibm.com [9.149.109.194])
        by ppma04ams.nl.ibm.com with ESMTP id 3daek9svqt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 03 Jan 2022 10:52:24 +0000
Received: from d06av25.portsmouth.uk.ibm.com (d06av25.portsmouth.uk.ibm.com [9.149.105.61])
        by b06cxnps3074.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 203AqMmV47120718
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jan 2022 10:52:22 GMT
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 642FB11C04A;
        Mon,  3 Jan 2022 10:52:22 +0000 (GMT)
Received: from d06av25.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DE08411C050;
        Mon,  3 Jan 2022 10:52:21 +0000 (GMT)
Received: from [9.145.23.206] (unknown [9.145.23.206])
        by d06av25.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon,  3 Jan 2022 10:52:21 +0000 (GMT)
Message-ID: <3cef644a-aeb3-ee15-9809-e560f7b24a5c@linux.ibm.com>
Date:   Mon, 3 Jan 2022 11:52:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [RFC PATCH net] net/smc: Reset conn->lgr when link group
 registration fails
Content-Language: en-US
To:     Wen Gu <guwen@linux.alibaba.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dust Li <dust.li@linux.alibaba.com>,
        tonylu_linux <tonylu@linux.alibaba.com>
References: <1640677770-112053-1-git-send-email-guwen@linux.alibaba.com>
 <07930fec-4109-0dfd-7df4-286cb56ec75b@linux.ibm.com>
 <0082289b-d3dc-d202-ec37-844d8fe5303f@linux.alibaba.com>
From:   Karsten Graul <kgraul@linux.ibm.com>
Organization: IBM Deutschland Research & Development GmbH
In-Reply-To: <0082289b-d3dc-d202-ec37-844d8fe5303f@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: kjcXOSipcoxLMLl1XAASjP1Rk-ZEhroT
X-Proofpoint-GUID: hZYybA6DboBQYg6FnSW6WTRbCPo6E3Gw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-03_03,2022-01-01_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 lowpriorityscore=0 adultscore=0 mlxscore=0 malwarescore=0
 priorityscore=1501 impostorscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201030068
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/12/2021 04:50, Wen Gu wrote:
> Thanks for your reply.
> 
> On 2021/12/29 9:07 pm, Karsten Graul wrote:
>> On 28/12/2021 08:49, Wen Gu wrote:
>>> SMC connections might fail to be registered to a link group due to
>>> things like unable to find a link to assign to in its creation. As
>>> a result, connection creation will return a failure and most
>>> resources related to the connection won't be applied or initialized,
>>> such as conn->abort_work or conn->lnk.
>> What I do not understand is the extra step after the new label out_unreg: that
>> may invoke smc_lgr_schedule_free_work(). You did not talk about that one.
>> Is the idea to have a new link group get freed() when a connection could not
>> be registered on it?
> Maybe we should try to free the link group when the registration fails, no matter
> it is new created or already existing? If so, is it better to do it in the same
> place like label 'out_unreg'?

I agree with your idea. 

With the proposed change that conn->lgr gets not even set when the registration fails 
we would not need the "conn->lgr = NULL;" after label out_unreg?

And as far as I understand the invocation of smc_lgr_schedule_free_work(lgr) is only
needed after label "create", because when an existing link group was found and the registration
failed then its free work would already be started when no more connections are assigned
to the link group, right?

