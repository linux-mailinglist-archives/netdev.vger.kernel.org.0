Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47133399378
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 21:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbhFBT0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 15:26:55 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:52046 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229583AbhFBT0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 15:26:54 -0400
Received: from pps.filterd (m0098414.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 152J2sXK152710
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 15:25:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=2IrVkn99KnLniNrAWI8BvzUxF6VuVy5njx57gpCJyuw=;
 b=Y3y7vl7YCHpxn+JP6pBfseYIecXy8VFcZRE+DKRa5fiHMZ2KP+DOQTLd2ESN8QBN97qK
 RYHpsgH9wQCMPBCnxjiv3EgrP3CKL18An0MdgaYhwul3vxcfi6VT4MyVJusDw+vhh3qz
 QI8272WzSZFLtzWtHmNdocNGKD8t4wfi1CRvwCFlKL41eeJ8ldTu+j3Mo1TEpnwCP8VX
 Qgmh3H61JY33hVPr4DFV4hqiaW87oK2NfpaJd1FcZKCxzhu9AL4atAT9pVIblrbRbMok
 0yHw3zay3P6PojlQevV5y7axGESqI6KMJkQJG7rqNg2mAwogQem9N8IMadZCzXqXTXIY Aw== 
Received: from pps.reinject (localhost [127.0.0.1])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38xbsqg7u5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 15:25:11 -0400
Received: from m0098414.ppops.net (m0098414.ppops.net [127.0.0.1])
        by pps.reinject (8.16.0.43/8.16.0.43) with SMTP id 152J2u43152928
        for <netdev@vger.kernel.org>; Wed, 2 Jun 2021 15:25:10 -0400
Received: from ppma01wdc.us.ibm.com (fd.55.37a9.ip4.static.sl-reverse.com [169.55.85.253])
        by mx0b-001b2d01.pphosted.com with ESMTP id 38xbsqg7tw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 15:25:10 -0400
Received: from pps.filterd (ppma01wdc.us.ibm.com [127.0.0.1])
        by ppma01wdc.us.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 152JCQQV029411;
        Wed, 2 Jun 2021 19:25:10 GMT
Received: from b01cxnp22035.gho.pok.ibm.com (b01cxnp22035.gho.pok.ibm.com [9.57.198.25])
        by ppma01wdc.us.ibm.com with ESMTP id 38ud89a1t5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 02 Jun 2021 19:25:10 +0000
Received: from b01ledav006.gho.pok.ibm.com (b01ledav006.gho.pok.ibm.com [9.57.199.111])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 152JP9sm38863268
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 2 Jun 2021 19:25:09 GMT
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 8AA27AC07D;
        Wed,  2 Jun 2021 19:25:09 +0000 (GMT)
Received: from b01ledav006.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 6A9C9AC073;
        Wed,  2 Jun 2021 19:25:09 +0000 (GMT)
Received: from suka-w540.localdomain (unknown [9.85.128.141])
        by b01ledav006.gho.pok.ibm.com (Postfix) with ESMTP;
        Wed,  2 Jun 2021 19:25:09 +0000 (GMT)
Received: by suka-w540.localdomain (Postfix, from userid 1000)
        id EA04C2E0AF7; Wed,  2 Jun 2021 12:25:06 -0700 (PDT)
Date:   Wed, 2 Jun 2021 12:25:06 -0700
From:   Sukadev Bhattiprolu <sukadev@linux.ibm.com>
To:     Lijun Pan <lijunp213@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ibm: replenish rx pool and poll less
 frequently
Message-ID: <YLfbEjiu671HApgi@us.ibm.com>
References: <20210602170156.41643-1-lijunp213@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602170156.41643-1-lijunp213@gmail.com>
X-Operating-System: Linux 2.0.32 on an i486
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Fa3lUfb3YF8A-xSE2Zr3PTw2WnCZZJFU
X-Proofpoint-GUID: HCh-mPiUeAy9iZBy4p5YYqVh5aPwl7ZF
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-06-02_10:2021-06-02,2021-06-02 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 phishscore=0
 mlxlogscore=982 spamscore=0 malwarescore=0 priorityscore=1501 mlxscore=0
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2106020122
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lijun Pan [lijunp213@gmail.com] wrote:
> The old mechanism replenishes rx pool even only one frames is processed in
> the poll function, which causes lots of overheads. The old mechanism

The soft lockup is not seen when replenishing a small number of buffers at
a time. Its only under some conditions when replenishing a _large_ number
at once - appears to be because the netdev_alloc_skb() calls collectively
take a long time.

Replenishing a small number at a time is not a problem.

> restarts polling until processed frames reaches the budget, which can
> cause the poll function to loop into restart_poll 63 times at most and to
> call replenish_rx_poll 63 times at most. This will cause soft lockup very
> easily. So, don't replenish too often, and don't goto restart_poll in each

The 64 is from the budget the system gave us. And for us to hit the goto
restart_loop:
	a. pending_scrq() in the while loop must not have a found a packet,
	   and
	b. by the time we replenished the pool, completed napi etc we must
	   have found a packet

For this to happen 64 times, we must find
	- exactly zero packets in a. and
	- exactly one packet in b, and
	- the tight sequence must occur 64 times.

IOW its more theoretical right?

Even if it did happen a handful of times, the only "overheads" in the
replenish are the netdev_alloc_skb() and the send-subcrq-indirect hcall.

The skb alloc cannot be avoided - we must do it now or in the future
anyway. The hcall is issued every 16 skbs. If we issue it for <16 skbs
it means the traffic is extremely low. No point optimizing for that.
Besides the hcalls are not very expensive.

There was a lot of testing done in Nov 2020 when the subcrq-indirect
hcall support was added. We would need to repeat that testing at the
least.

Thanks,

Sukadev
