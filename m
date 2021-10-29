Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3344055B
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 00:19:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbhJ2WVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 18:21:22 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:58326 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231552AbhJ2WVV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 18:21:21 -0400
Received: from pps.filterd (m0187473.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19TLgfSQ027100
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:18:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=qRr5Vp0CpyjQEKvZZ4+AgSKfaGPxHfuLDgPXDEzwMeU=;
 b=tAd2xsWPYZBT4GiagRQZvvAt6MC8FeBCaGdh6Smok3tpwFPB8/R4pza6K0Ko6I7rb+Gl
 Uno7Et87CePM8Wkj7B1pf1+wPdZVm3UoJ0FmDX5FspZ9AAiWdgBwlUS2tQlULuxoroCH
 00tvgVq4Vy49wJZszYQgKvhS0MRqITxlKWHt4I4XXH8dob9r+JiPkCinrJIeHQHk4LoO
 cNdFNyr7rGQyp0xjykNOxWYzhiffD+nuZqOikfKn8hsTFxO8x+7Wg94QzcNqIem52acM
 eo90XZKKKKch00/rA9xvwjBgMKGaNvaFoAcHGHjXb+YEp8aSD1lzEfAtbech8kynOm2p DQ== 
Received: from ppma02dal.us.ibm.com (a.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.10])
        by mx0a-001b2d01.pphosted.com with ESMTP id 3c0s408khp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:18:52 +0000
Received: from pps.filterd (ppma02dal.us.ibm.com [127.0.0.1])
        by ppma02dal.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 19TMDiqP029153
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:18:51 GMT
Received: from b03cxnp08026.gho.boulder.ibm.com (b03cxnp08026.gho.boulder.ibm.com [9.17.130.18])
        by ppma02dal.us.ibm.com with ESMTP id 3bx4f9q0be-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 22:18:51 +0000
Received: from b03ledav002.gho.boulder.ibm.com (b03ledav002.gho.boulder.ibm.com [9.17.130.233])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 19TMIlKs30409080
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Oct 2021 22:18:47 GMT
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 78E11136051;
        Fri, 29 Oct 2021 22:18:47 +0000 (GMT)
Received: from b03ledav002.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 16C8D13604F;
        Fri, 29 Oct 2021 22:18:46 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav002.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri, 29 Oct 2021 22:18:46 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 29 Oct 2021 15:18:46 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Sukadev Bhattiprolu <sukadev@linux.ibm.com>
Cc:     netdev@vger.kernel.org, Brian King <brking@linux.ibm.com>,
        abdhalee@in.ibm.com, vaish123@in.ibm.com
Subject: Re: [PATCH net 1/3] ibmvnic: don't stop queue in xmit
In-Reply-To: <20211029220316.2003519-1-sukadev@linux.ibm.com>
References: <20211029220316.2003519-1-sukadev@linux.ibm.com>
Message-ID: <07ba6c096974e74bcfbea9a9f6ecb524@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 0IKoMOsOZJ4yiML_kTWzWzhITr7ft2_i
X-Proofpoint-ORIG-GUID: 0IKoMOsOZJ4yiML_kTWzWzhITr7ft2_i
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-29_06,2021-10-29_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 clxscore=1011 impostorscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 mlxscore=0 bulkscore=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=659 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2110150000 definitions=main-2110290123
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-29 15:03, Sukadev Bhattiprolu wrote:
> If adapter's resetting bit is on, discard the packet but don't stop the
> transmit queue - instead leave that to the reset code. With this 
> change,
> it is possible that we may get several calls to ibmvnic_xmit() that 
> simply
> discard packets and return.
> 
> But if we stop the queue here, we might end up doing so just after
> __ibmvnic_open() started the queues (during a hard/soft reset) and 
> before
> the ->resetting bit was cleared. If that happens, there will be no one 
> to
> restart queue and transmissions will be blocked indefinitely.
> 
> This can cause a TIMEOUT reset and with auto priority failover enabled,
> an unnecessary FAILOVER reset to less favored backing device and then a
> FAILOVER back to the most favored backing device. If we hit the window
> repeatedly, we can get stuck in a loop of TIMEOUT, FAILOVER, FAILOVER
> resets leaving the adapter unusable for extended periods of time.
> 
> Fixes: 7f5b030830fe ("ibmvnic: Free skb's in cases of failure in 
> transmit")
> Reported-by: Abdul Haleem <abdhalee@in.ibm.com>
> Reported-by: Vaishnavi Bhat <vaish123@in.ibm.com>
> Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>

Reviewed-by: Dany Madden <drt@linux.ibm.com>
