Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C7437315C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 22:25:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232744AbhEDU0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 16:26:30 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:15132 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229542AbhEDU03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 16:26:29 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 144K306L038770;
        Tue, 4 May 2021 16:24:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=mime-version :
 content-type : content-transfer-encoding : date : from : to : cc : subject
 : in-reply-to : references : message-id; s=pp1;
 bh=rLsfIxNLP/UVRes6rjgxtlr1FIJwNymAy7RIcEYMfyE=;
 b=qmrsT/UpToeDl6zgA/RJi4rb8z80IAxX82ljoxt9DeCadfV/vxqxhKtGHWVE3Twxw6ym
 D7yVspGiR8TzLvoAKg1EzG9G52guDbq8x3xnK2uPyjRQZ1MZgKJxbPsDqkzAuuLRXc7F
 bZmvYJwO6v8TIbj51MctnEkc12xvgrv/sA0E1ew/qh59O03NSpq4l4SETYPIfK2IqO5/
 EJ8LxlDinavQ7HPxQRF3VQaDJ8T/bUxYNtKz4P9uXArio3A54Y3WV1Sw+o3w76pRKKuY
 ZhEyaVZMfwwT5gItvREOZV9ty8zErztodyCl1HPIdl/EJnpis6DDwUclE6GiXr4aMjyy GA== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bbbuubkj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 16:24:59 -0400
Received: from m0098416.ppops.net (m0098416.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 144K3DYd040290;
        Tue, 4 May 2021 16:24:58 -0400
Received: from ppma03dal.us.ibm.com (b.bd.3ea9.ip4.static.sl-reverse.com [169.62.189.11])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38bbbuubkb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 16:24:58 -0400
Received: from pps.filterd (ppma03dal.us.ibm.com [127.0.0.1])
        by ppma03dal.us.ibm.com (8.16.0.43/8.16.0.43) with SMTP id 144KITtY031701;
        Tue, 4 May 2021 20:24:58 GMT
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
        by ppma03dal.us.ibm.com with ESMTP id 388xm9dtq4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 04 May 2021 20:24:58 +0000
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 144KOubn29229552
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 4 May 2021 20:24:56 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 9460E7805E;
        Tue,  4 May 2021 20:24:56 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id E13567805C;
        Tue,  4 May 2021 20:24:55 +0000 (GMT)
Received: from ltc.linux.ibm.com (unknown [9.10.229.42])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Tue,  4 May 2021 20:24:55 +0000 (GMT)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 04 May 2021 13:24:55 -0700
From:   Dany Madden <drt@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sukadev Bhattiprolu <sukadev@linux.ibm.com>,
        Thomas Falcon <tlfalcon@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH net v3] ibmvnic: Continue with reset if set link down
 failed
In-Reply-To: <CAOhMmr5ucF3pa4jp9RLEzJNs29oVT0qAXmywNnd+Xe2seoRJfg@mail.gmail.com>
References: <20210504191142.2872696-1-drt@linux.ibm.com>
 <CAOhMmr5T_BLkqGspnzck=xtiX0rPABv8oX4=LCRbH00T8-B6qw@mail.gmail.com>
 <CAOhMmr5ucF3pa4jp9RLEzJNs29oVT0qAXmywNnd+Xe2seoRJfg@mail.gmail.com>
Message-ID: <54060bf8c570a52eaa74a034b6096c99@imap.linux.ibm.com>
X-Sender: drt@linux.ibm.com
User-Agent: Roundcube Webmail/1.1.12
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Rv5ti_Orp05ATNNAzBEWQdZvsZ9G4gMl
X-Proofpoint-GUID: CQVYjC_lVQ0ZfQxJr0CZu733UcKdCcJI
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-04_15:2021-05-04,2021-05-04 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 mlxscore=0
 phishscore=0 clxscore=1015 mlxlogscore=999 spamscore=0 malwarescore=0
 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2105040134
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-05-04 12:31, Lijun Pan wrote:
> On Tue, May 4, 2021 at 2:27 PM Lijun Pan <lijunp213@gmail.com> wrote:
>> 
>> On Tue, May 4, 2021 at 2:14 PM Dany Madden <drt@linux.ibm.com> wrote:
>> >
>> > When ibmvnic gets a FATAL error message from the vnicserver, it marks
>> > the Command Respond Queue (CRQ) inactive and resets the adapter. If this
>> > FATAL reset fails and a transmission timeout reset follows, the CRQ is
>> > still inactive, ibmvnic's attempt to set link down will also fail. If
>> > ibmvnic abandons the reset because of this failed set link down and this
>> > is the last reset in the workqueue, then this adapter will be left in an
>> > inoperable state.
>> >
>> > Instead, make the driver ignore this link down failure and continue to
>> > free and re-register CRQ so that the adapter has an opportunity to
>> > recover.
>> >
>> > Fixes: ed651a10875f ("ibmvnic: Updated reset handling")
>> > Signed-off-by: Dany Madden <drt@linux.ibm.com>
>> > Reviewed-by: Rick Lindsley <ricklind@linux.ibm.com>
>> > Reviewed-by: Sukadev Bhattiprolu <sukadev@linux.ibm.com>
>> > ---
>> > Changes in V2:
>> > - Update description to clarify background for the patch
>> > - Include Reviewed-by tags
>> > Changes in V3:
>> > - Add comment above the code change
>> > ---
>> >  drivers/net/ethernet/ibm/ibmvnic.c | 11 +++++++++--
>> >  1 file changed, 9 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c b/drivers/net/ethernet/ibm/ibmvnic.c
>> > index 5788bb956d73..9e005a08d43b 100644
>> > --- a/drivers/net/ethernet/ibm/ibmvnic.c
>> > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
>> > @@ -2017,8 +2017,15 @@ static int do_reset(struct ibmvnic_adapter *adapter,
>> >                         rtnl_unlock();
>> >                         rc = set_link_state(adapter, IBMVNIC_LOGICAL_LNK_DN);
>> >                         rtnl_lock();
>> > -                       if (rc)
>> > -                               goto out;
>> > +
>> > +                       /* Attempted to set the link down. It could fail if the
>> > +                        * vnicserver has already torn down the CRQ. We will
>> > +                        * note it and continue with reset to reinit the CRQ.
>> > +                        */
>> > +                       if (rc) {
>> > +                               netdev_dbg(netdev,
>> > +                                          "Setting link down failed rc=%d. Continue anyway\n", rc);
>> > +                       }
>> 
>> There are other places which check and rely on the return value of
>> this function. Your change makes that inconsistent. Can you stop
> 
> To be more specific, __ibmvnic_close, __ibmvnic_open both call this
> set_link_state.
Inconsistent would have been not checking for the rc at all. Here we 
checked and noted it that there are times that it's ok to continue.

> 
>> posting new versions and soliciting the maintainer to accept it before
>> there is material change? There are many ways to make reset
>> successful. I think this is the worst approach of all.

Can you show me a patch that is better than this one, that has gone thru 
a 30+ hours of testing?

>> 
>> 
>> >
>> >                         if (adapter->state == VNIC_OPEN) {
>> >                                 /* When we dropped rtnl, ibmvnic_open() got
>> > --
>> > 2.18.2
>> >
