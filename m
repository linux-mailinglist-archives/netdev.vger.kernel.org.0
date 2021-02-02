Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B1A30B532
	for <lists+netdev@lfdr.de>; Tue,  2 Feb 2021 03:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhBBCWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 21:22:43 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:15938 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229556AbhBBCWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 21:22:41 -0500
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 11223ro8046459
        for <netdev@vger.kernel.org>; Mon, 1 Feb 2021 21:22:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=8PKHRa8pJRKjjQJ08JyKCoWKkDm7GflgR/Q1YxhulJ8=;
 b=Rg0aOgNBKM5mZEG+Ku/39oHsx0H8sQ9UJqjmXt0MXTRl5GCDSfhq64M7v+vFmyf0NQxZ
 0kODVbZQudW9H1xCs1O0glXpGnHrrCd7QHOy3fNvsyl39JjJr7Msj3rDeS7klLI5pIo7
 wYpQr/DarApvz/faIJjT7UKo5SaGzEzkyof+/iAoKRjZWVwtsktnYavdL5OUZ04fnRN2
 uy9rO1LhUNjSDCfBG6Vkgy41MBN04uYUL8Zkn2HfroLxWLEmEnedmUF9RFdGOmd/FEdb
 2Ks1M8Ayi4FUk6lamGM0//WmELKHV8CawJRPXIRz/t1Iiaf5A8lHzwJ8diNwXTmSFqYE Kg== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ewaj8pnh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Mon, 01 Feb 2021 21:22:00 -0500
Received: from m0187473.ppops.net (m0187473.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 11224ALf048900
        for <netdev@vger.kernel.org>; Mon, 1 Feb 2021 21:22:00 -0500
Received: from ppma04dal.us.ibm.com (7a.29.35a9.ip4.static.sl-reverse.com [169.53.41.122])
        by mx0a-001b2d01.pphosted.com with ESMTP id 36ewaj8pn5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 01 Feb 2021 21:22:00 -0500
Received: from pps.filterd (ppma04dal.us.ibm.com [127.0.0.1])
        by ppma04dal.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 1122G25Z015404;
        Tue, 2 Feb 2021 02:21:59 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma04dal.us.ibm.com with ESMTP id 36er4cjh10-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 02 Feb 2021 02:21:59 +0000
Received: from b03ledav005.gho.boulder.ibm.com (b03ledav005.gho.boulder.ibm.com [9.17.130.236])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 1122Lu6V29294928
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 2 Feb 2021 02:21:56 GMT
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2F75CBE054;
        Tue,  2 Feb 2021 02:21:56 +0000 (GMT)
Received: from b03ledav005.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 031B3BE051;
        Tue,  2 Feb 2021 02:21:55 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.151.157])
        by b03ledav005.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  2 Feb 2021 02:21:55 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 1621C2E18A5; Mon,  1 Feb 2021 18:21:52 -0800 (PST)
Date:   Mon, 1 Feb 2021 18:21:52 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        Rick Lindsley <ricklind@linux.ibm.com>, abdhalee@in.ibm.com
Subject: Re: [PATCH net 2/2] ibmvnic: fix race with multiple open/close
Message-ID: <20210202022152.GA615199@us.ibm.com>
References: <20210129034711.518250-1-sukadev@linux.ibm.com>
 <20210129034711.518250-2-sukadev@linux.ibm.com>
 <CAF=yD-+0Q86iZMedrBp2wDjVaNvd2_Wy7BcsXLef_e2wJmYm=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF=yD-+0Q86iZMedrBp2wDjVaNvd2_Wy7BcsXLef_e2wJmYm=A@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-01_14:2021-01-29,2021-02-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 malwarescore=0 suspectscore=0 impostorscore=0 mlxscore=0 clxscore=1015
 mlxlogscore=828 lowpriorityscore=0 bulkscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102020012
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Willem de Bruijn [willemdebruijn.kernel@gmail.com] wrote:
> On Thu, Jan 28, 2021 at 10:51 PM Sukadev Bhattiprolu
> <sukadev@linux.ibm.com> wrote:
> >
> > If two or more instances of 'ip link set' commands race and first one
> > already brings the interface up (or down), the subsequent instances
> > can simply return without redoing the up/down operation.
> >
> > Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
> > Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> > Tested-by: Abdul Haleem <abdhalee@in.ibm.com>
> > Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
> 
> Isn't this handled in the rtnetlink core based on IFF_UP?
> 
>         if ((old_flags ^ flags) & IFF_UP) {
>                 if (old_flags & IFF_UP)
>                         __dev_close(dev);
>                 else
>                         ret = __dev_open(dev, extack);
>         }

Good question. During our testing we hit the "adapter already open" debug
message a few times. Without this change, the core layer and dirver disagree
on the state and the adapter becomes unsuable.

I will debug this at the core layer also later this week.  

We are working on rewriting parts of driver surrounding locking/adapter
state and not sure if that will reveal any other cause for this behavior.

Sukadev
