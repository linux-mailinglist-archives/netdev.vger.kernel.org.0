Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89A7D36659C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 08:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhDUGqc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 02:46:32 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47398 "EHLO
        mx0b-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234966AbhDUGq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 02:46:29 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 13L6XZif099323;
        Wed, 21 Apr 2021 02:45:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=Wr99daJ5LCLrKVJQQwcYjwTnR5ygMys3ePj3mAnH1Kw=;
 b=rn5DXPgJ4yr44SlH7TAqGp7ISW31LDnl5hpyNcI6EL055REo1CnPikgYAv9Fg1JQF54h
 i5MeEtYBXjH9f0ZkRgq1hmSS2dfGdJvM1QlK+6g1mlfy7xIX62uo09a2iMd1wJYwdZtM
 eJF5Anl3cFh2n7YleHE86v5DCc/PS6JXzXjGEle/hrlDR9/nzyS+7vX7virMpdj4DiCG
 c+nh5MFWUn8sGuOopexa1V7WRHl5mgomYt78vJBA+jVrZOoYVNOWOABR7LBvRqNTU9xh
 Bb9qZGrMQaIt8101s+pOlfIL25MP1wsBcDnbgxIThCIi8lrBnSckv8EzMy5KJ3q0dc5U aA== 
Received: from ppma04wdc.us.ibm.com (1a.90.2fa9.ip4.static.sl-reverse.com [169.47.144.26])
        by mx0a-001b2d01.pphosted.com with ESMTP id 382e5qhe7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 02:45:32 -0400
Received: from pps.filterd (ppma04wdc.us.ibm.com [127.0.0.1])
        by ppma04wdc.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 13L6gVH4023162;
        Wed, 21 Apr 2021 06:45:31 GMT
Received: from b03cxnp08028.gho.boulder.ibm.com (b03cxnp08028.gho.boulder.ibm.com [9.17.130.20])
        by ppma04wdc.us.ibm.com with ESMTP id 3813tarddk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 21 Apr 2021 06:45:31 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp08028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 13L6jUHq30015876
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 21 Apr 2021 06:45:30 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id AA54ABE051;
        Wed, 21 Apr 2021 06:45:30 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 77E8BBE054;
        Wed, 21 Apr 2021 06:45:30 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.204.101])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Wed, 21 Apr 2021 06:45:30 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 545A72E188A; Tue, 20 Apr 2021 23:45:27 -0700 (PDT)
Date:   Tue, 20 Apr 2021 23:45:27 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <ljp@linux.vnet.ibm.com>
Cc:     Dany Madden <drt@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Tom Falcon <tlfalcon@linux.ibm.com>, netdev@vger.kernel.org,
        paulus@samba.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH V2 net] ibmvnic: Continue with reset if set link down
 failed
Message-ID: <20210421064527.GA2648262@us.ibm.com>
References: <20210420213517.24171-1-drt@linux.ibm.com>
 <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60C99F56-617D-455B-9ACF-8CE1EED64D92@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: csMnvHEGnph8RIrAXXNizupgMkVXY60g
X-Proofpoint-ORIG-GUID: csMnvHEGnph8RIrAXXNizupgMkVXY60g
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-21_02:2021-04-20,2021-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 priorityscore=1501
 impostorscore=0 adultscore=0 clxscore=1011 suspectscore=0 mlxlogscore=999
 malwarescore=0 phishscore=0 bulkscore=0 lowpriorityscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104210052
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [ljp@linux.vnet.ibm.com] wrote:
> 
> 
> > On Apr 20, 2021, at 4:35 PM, Dany Madden <drt@linux.ibm.com> wrote:
> > 
> > When ibmvnic gets a FATAL error message from the vnicserver, it marks
> > the Command Respond Queue (CRQ) inactive and resets the adapter. If this
> > FATAL reset fails and a transmission timeout reset follows, the CRQ is
> > still inactive, ibmvnic's attempt to set link down will also fail. If
> > ibmvnic abandons the reset because of this failed set link down and this
> > is the last reset in the workqueue, then this adapter will be left in an
> > inoperable state.
> > 
> > Instead, make the driver ignore this link down failure and continue to
> > free and re-register CRQ so that the adapter has an opportunity to
> > recover.
> 
> This v2 does not adddress the concerns mentioned in v1.
> And I think it is better to exit with error from do_reset, and schedule a thorough
> do_hard_reset if the the adapter is already in unstable state.

We had a FATAL error and when handling it, we failed to send a 
link-down message to the VIOS. So what we need to try next is to 
reset the connection with the VIOS. For this we must talk to the 
firmware using the H_FREE_CRQ and H_REG_CRQ hcalls. do_reset()
does just that in ibmvnic_reset_crq().

Now, sure we can attempt a "thorough hard reset" which also does
the same hcalls to reestablish the connection. Is there any
other magic in do_hard_reset()? But in addition, it also frees lot
more Linux kernel buffers and reallocates them for instance.

If we are having a communication problem with the VIOS, what is
the point of freeing and reallocating Linux kernel buffers? Beside
being inefficient, it would expose us to even more errors during
reset under heavy workloads?

From what I understand so far, do_reset() is complicated because
it is attempting some optimizations.  If we are going to fall back
to hard reset for every error we might as well drop the do_reset()
and just do the "thorough hard reset" every time right?

The protocol spec is ambiguous and so far I did not get a clear
answer on whether the link-down is even needed. If it is needed,
then should we add it to do_hard_reset() also? If not, we should
remove it (like you mentioned your earlier) completely but am
waiting for confirmation on that. git history has not been helpful.

While there are other rough edges around do_reset() that we are
working on fixing separately (eg: ignore the error return from 
__ibmvnic_close() right above this change) I see a benefit to
the customer with this patch.

I am not convinced we should perform a hard reset just because
the link down failed.

Sukadev
