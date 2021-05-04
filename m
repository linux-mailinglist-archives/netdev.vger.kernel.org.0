Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8EEE37304A
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 21:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232016AbhEDTGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 15:06:54 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:35664 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231478AbhEDTGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 15:06:53 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144J2eIN017295;
        Tue, 4 May 2021 15:05:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=iQCVI9fVjb8+Qcrt7V8dfDFOPmoAemrEfQmmDk7YUCk=;
 b=XvIZGS60YmlLTT+/leut7nr+297u1zxtfUojTyKC68fXCvkbL7RvasbKXjvmkSDqQyLF
 yzvieRtoTlSsLPl1cynCvTckdcqdJvj4V0Jb48rMxTvSLJEVYZLV9CD3Kg5ugPM2FdIz
 SbWYEhfZmna0lSfKvf1YS45qZ+sRTJ7g5lLJF5jJ2tIGYXPQa7Ll615kiB0rD4W9W5Yx
 U6Ln/lUDinP8QqAzoMMpu2Du7NZPkD2cLQ/TTsoXyByp6qUev7KBeAJnL8Uu2oxnB4BQ
 ycEnB3VIVzX4vmhj+IAhMTviGHqHMpU5a/WJVGb7nhr8PD8Uek57w9FA99ximk4kUJAr TQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38b99t5t3p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 15:05:42 -0400
Received: from m0098394.ppops.net (m0098394.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 144J3IjZ021048;
        Tue, 4 May 2021 15:05:42 -0400
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 38b99t5t2t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 15:05:42 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 144IveVF002356;
        Tue, 4 May 2021 19:05:40 GMT
Received: from b03cxnp08025.gho.boulder.ibm.com (b03cxnp08025.gho.boulder.ibm.com [9.17.130.17])
        by ppma04wdc.us.ibm.com with ESMTP id 388xm8yh2d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 19:05:40 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08025.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 144J5dcT18481620
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 May 2021 19:05:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 7EE207805E;
        Tue,  4 May 2021 19:05:39 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id BDA047805F;
        Tue,  4 May 2021 19:05:38 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  4 May 2021 19:05:38 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Tue, 04 May 2021 12:05:38 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Rick Lindsley <ricklind@linux.vnet.ibm.com>
Cc:     =?UTF-8?Q?Michal_Such=C3=A1nek?= <msuchanek@suse.de>,
        Lijun Pan <lijunp213@gmail.com>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        netdev@vger.kernel.org, Lijun Pan <ljp@linux.vnet.ibm.com>,
        Tom Falcon <tlfalcon@linux.ibm.com>,
        Paul Mackerras <paulus@samba.org>,
        Jakub Kicinski <kuba@kernel.org>,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
In-Reply-To: <9e46d7ad-55dd-7caf-0a39-344b80bdceb3@linux.vnet.ibm.com>
References: <20210420213517.24171-1-drt@linux.ibm.com>
 <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
 <20210421064527.GA2648262@us.ibm.com>
 <CAOhMmr4ckVFTZtSeHFHNgGPUA12xYO8WcUoakx7WdwQfSKBJhA@mail.gmail.com>
 <20210422172135.GY6564@kitsune.suse.cz>
 <9e46d7ad-55dd-7caf-0a39-344b80bdceb3@linux.vnet.ibm.com>
Message-ID: <82a656fa1dd1efdfa196da8ffff19563@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: trEV6iAN75pMQy618XXq-Qq-RrAVEUoA
X-Proofpoint-GUID: DsgpkAi3l2hycl_a1PuaphM2e0or0_l8
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_12:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 suspectscore=0 mlxscore=0 bulkscore=0 malwarescore=0
 phishscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 lowpriorityscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2104060000 definitions=main-2105040125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-04-22 19:26, Rick Lindsley wrote:
> On 4/22/21 10:21 AM, Michal Suchánek wrote:
> 
>> Merging do_reset and do_hard_reset might be a good code cleanup which 
>> is
>> out of the scope of this fix.
> 
> I agree, on both points. Accepting the patch, and improving the reset
> path are not in conflict with each other.
> 
> My position is that improving the reset path is certainly on the table,
> but not with this bug or this fix.  Within the context of this 
> discovered
> problem, the issue is well understood, the fix is small and addresses 
> the
> immediate problem, and it has not generated new bugs under subsequent
> testing.  For those reasons, the submitted patch has my support.
> 
> Rick

Thanks for all the feedback on the patch. Refactoring the ibmvnic reset 
functions is something we plan to evaluate, as this would potentially 
simplify the reset code. In the mean time, the proposed patch is simple, 
and has been validated in our test environment to solve an issue 
resulting in vnic interfaces getting stuck in an offline state following 
a vnic timeout reset. Given that, I suggest we merge this patch while we 
look at further optimizations in future. I will submit a V3 patch 
shortly.

Dany
