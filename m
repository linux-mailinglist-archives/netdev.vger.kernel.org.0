Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51D9D2FF81B
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 23:41:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727098AbhAUWjy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 17:39:54 -0500
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:17310 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726575AbhAUWje (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 17:39:34 -0500
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 10LMWc8N150608;
        Thu, 21 Jan 2021 17:38:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=V9pkF9N+hZpa0Vz2hTWbrqRBmqHOHgaZE8NC6FKusVA=;
 b=QuQNZ9BnMVrIlIv8QxhCd+IpImdRK2fV55FxflmKsPjqifEzNgTVomYq5G6DjY5j7LhV
 nk9d7INzVVV+1DcTnU8MX0mAd+bMDizjSnvWD8vMy7SX7MyKUN4GRVXmZvlgZgGCA8LH
 SN0SssSJc98NUxer32Fhz8nMGhUG1AhLWZT1cJCxlRJFZeIaSq7553rKeqyDIW2oMi9A
 fX9USi30dKKF1nQ5jR5w8jEtv97cEkXzQAvkSC9tmO/p7ZQEg9MGsHUnGlKhAKbHJaPn
 le/dj9XOIDgiECd9xBMLH25vcedr4Ad60mO4OS1DcrNos5Jhk2QJbT2ZUEFWXt5Zsomp qQ== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367j5w0h8k-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 17:38:16 -0500
Received: from m0098399.ppops.net (m0098399.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 10LMXYx4157432;
        Thu, 21 Jan 2021 17:38:15 -0500
Received: from ppma03wdc.us.ibm.com (ba.79.3fa9.ip4.static.sl-reverse.com [169.63.121.186])
        by mx0a-001b2d01.pphosted.com with ESMTP id 367j5w0h82-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 17:38:15 -0500
Received: from pps.filterd (ppma03wdc.us.ibm.com [127.0.0.1])
        by ppma03wdc.us.ibm.com (8.16.0.42/8.16.0.42) with SMTP id 10LMVaRE014495;
        Thu, 21 Jan 2021 22:38:13 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma03wdc.us.ibm.com with ESMTP id 3668pc7fk7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 21 Jan 2021 22:38:13 +0000
Received: from b01ledav002.gho.pok.ibm.com (b01ledav002.gho.pok.ibm.com [9.57.199.107])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 10LMcDR228443046
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Jan 2021 22:38:13 GMT
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 59D7812407D;
        Thu, 21 Jan 2021 22:38:13 +0000 (GMT)
Received: from b01ledav002.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3507912407F;
        Thu, 21 Jan 2021 22:38:13 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.147.100])
        by b01ledav002.gho.pok.ibm.com (Postfix) with ESMTP;
        Thu, 21 Jan 2021 22:38:13 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id 65DA72E2718; Thu, 21 Jan 2021 14:38:10 -0800 (PST)
Date:   Thu, 21 Jan 2021 14:38:10 -0800
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     Dany Madden <drt@linux.ibm.com>, Lijun Pan <ljp@linux.ibm.com>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, julietk@linux.vnet.ibm.com,
        benh@kernel.crashing.org, paulus@samba.org, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>, gregkh@linuxfoundation.org,
        kernel@pengutronix.de,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH net] ibmvnic: device remove has higher precedence over
 reset
Message-ID: <20210121223810.GA374395@us.ibm.com>
References: <20210121062005.53271-1-ljp@linux.ibm.com>
 <c34816a13d857b7f5d1a25991b58ec63@imap.linux.ibm.com>
 <CAOhMmr78mzJpfPBSwp9JWmE+KwLxd6JtqpwaA9tmqxU5fCjcgg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOhMmr78mzJpfPBSwp9JWmE+KwLxd6JtqpwaA9tmqxU5fCjcgg@mail.gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-21_10:2021-01-21,2021-01-21 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 impostorscore=0 bulkscore=0 spamscore=0 mlxscore=0 clxscore=1011
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101210115
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [lijunp213@gmail.com] wrote:
> > > diff --git a/drivers/net/ethernet/ibm/ibmvnic.c
> > > b/drivers/net/ethernet/ibm/ibmvnic.c
> > > index aed985e08e8a..11f28fd03057 100644
> > > --- a/drivers/net/ethernet/ibm/ibmvnic.c
> > > +++ b/drivers/net/ethernet/ibm/ibmvnic.c
> > > @@ -2235,8 +2235,7 @@ static void __ibmvnic_reset(struct work_struct
> > > *work)
> > >       while (rwi) {
> > >               spin_lock_irqsave(&adapter->state_lock, flags);
> > >
> > > -             if (adapter->state == VNIC_REMOVING ||
> > > -                 adapter->state == VNIC_REMOVED) {
> > > +             if (adapter->state == VNIC_REMOVED) {

If the adapter is in REMOVING state, there is no point going
through the reset process. We could just bail out here. We
should also drain any other resets in the queue (something
my other patch set was addressing).

Sukadev

> >
> > If we do get here, we would crash because ibmvnic_remove() happened. It
> > frees the adapter struct already.
> 
> Not exactly. viodev is gone; netdev is gone; ibmvnic_adapter is still there.
> 
> Lijun

