Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED90935E014
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 15:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244196AbhDMNaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 09:30:22 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:49770 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231682AbhDMNaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 09:30:21 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13DD3ZZ0163472
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:30:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : in-reply-to : references : date : message-id : mime-version :
 content-type; s=pp1; bh=0h4TXQT+v6doJkPM1KxWfYTgCrtpfk8cazGjxAVTHq4=;
 b=c/Ia8KcRsAgECQGqT6aVZHXvTy5dXiA16/ICdOTk3q/6l+34/RLA/ih5bU/qKkjHPj9e
 BZ1Aej3pfxrzKEU0tVwAzm2Yhwk9q6eVuuGqDzFpKJAjIKpmXgefaebgl7A5fpUTjdKB
 yMG+Mn18+sb0c5KCvmZJhT69hTruqh4OwxLKBclxJVN3R6EfGgrq3bUiotHSyj5Wveex
 pUTxHo0A4VMTC9WEz0ksTMrwEOoDjuAsixILPXIEkw0qU6O46HZUFMNuDmeA7u7TsYfD
 SJNNFfq/nBV6vz1qkAaGGn9u1WFvsgSyVgCl9pG1AGVtzy/8ToCK/Vum/Po9hOITf+pY ig== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vkd6atgg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:30:01 -0400
Received: from m0098419.ppops.net (m0098419.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 13DD4aN1168500
        for <netdev@vger.kernel.org>; Tue, 13 Apr 2021 09:30:00 -0400
Received: from ppma01dal.us.ibm.com (83.d6.3fa9.ip4.static.sl-reverse.com [169.63.214.131])
        by mx0b-001b2d01.pphosted.com with ESMTP id 37vkd6atg9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 09:30:00 -0400
Received: from pps.filterd (ppma01dal.us.ibm.com [127.0.0.1])
        by ppma01dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13DDRo23009871;
        Tue, 13 Apr 2021 13:30:00 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma01dal.us.ibm.com with ESMTP id 37u3n9f2tm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 13 Apr 2021 13:30:00 +0000
Received: from b03ledav006.gho.boulder.ibm.com (b03ledav006.gho.boulder.ibm.com [9.17.130.237])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13DDTwi328442918
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 13:29:59 GMT
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id DB324C6057;
        Tue, 13 Apr 2021 13:29:58 +0000 (GMT)
Received: from b03ledav006.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id B8E02C6059;
        Tue, 13 Apr 2021 13:29:58 +0000 (GMT)
Received: from localhost (unknown [9.163.8.142])
        by b03ledav006.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue, 13 Apr 2021 13:29:58 +0000 (GMT)
From:   Nathan Lynch <nathanl@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ibmvnic: queue reset work in system_long_wq
In-Reply-To: <20210413083233.10479-1-lijunp213@gmail.com>
References: <20210413083233.10479-1-lijunp213@gmail.com>
Date:   Tue, 13 Apr 2021 08:29:58 -0500
Message-ID: <87h7kafh2h.fsf@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 3UB8G-HYanryc_mGhbAnhLtEqP7eUa1V
X-Proofpoint-ORIG-GUID: cuONPVNM6JLcKmn1PfcXi2GcFZ3HT3me
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-13_07:2021-04-13,2021-04-13 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=936 phishscore=0
 spamscore=0 impostorscore=0 adultscore=0 clxscore=1011 malwarescore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130091
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lijun,

Lijun Pan <lijunp213@gmail.com> writes:
> When the linux system is under stress or the VIOS server is
> responding slowly, the vnic driver may hit multiple timeouts during the
> reset process. Instead of queueing the reset requests to system_wq,
> queueing the relatively slow reset job to the system_long_wq.

I think the commit message should better justify the change. I suggested
this because the reset process for ibmvnic commonly takes multiple
seconds, clearly making it inappropriate for schedule_work/system_wq:

(workqueue.h)
 * system_wq is the one used by schedule[_delayed]_work[_on]().
 * Multi-CPU multi-threaded.  There are users which expect relatively
 * short queue flush time.  Don't queue works which can run for too
 * long.
...
 * system_long_wq is similar to system_wq but may host long running
 * works.  Queue flushing might take relatively long.

If the reset process isn't completing before some kind of deadline (is
this the nature of the timeouts you mention?), changing to
system_long_wq is unlikely to help that. The reason to make this change
is that ibmvnic's use of the default system-wide workqueue for a
relatively long-running work item can negatively affect other workqueue
users.
