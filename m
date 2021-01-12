Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6A382F3502
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 17:06:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406141AbhALQDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 11:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404473AbhALQDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 11:03:39 -0500
Received: from mx0a-00190b01.pphosted.com (mx0a-00190b01.pphosted.com [IPv6:2620:100:9001:583::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECCD6C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 08:02:58 -0800 (PST)
Received: from pps.filterd (m0050095.ppops.net [127.0.0.1])
        by m0050095.ppops.net-00190b01. (8.16.0.43/8.16.0.43) with SMTP id 10CFxZ9d028347;
        Tue, 12 Jan 2021 16:02:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from : to :
 cc : subject : in-reply-to : references; s=jan2016.eng;
 bh=rWuBCZC9i6gI+2nb315ephtNwrhGD5W1CJNRaXFssQU=;
 b=XhpdHNRoAtDnJ3zHPt9wASS53Y6gL8ij6chXqMFPFt+KHkKKL4HA6CM3SzxLVEBG1VXd
 VIwpNo/mJWIcuXvjhqpS44ceYVqG4rnLcth5QImiqdDvjdJrVURcRJ7NqDi6/j8IQdpi
 Y7YIBPCd5YwM3j8cKdb0rqAYV8BfCG8ZeuYPYmDF3cSwqEQlfbUP1/0HPJNxNoVTC6mu
 PVI095UY7sDucWsNF6xn9HKK+/1fLVQls2u7xOnpKpImXK6Vqhi37zwVENJX5t64Ssk9
 Wtee11BvEe1y5rJ2pg5xzdk22OiV5qOsSbsRy8aWu8y1mI3/fRh7tqjXD1zfT0o1AN/M sw== 
Received: from prod-mail-ppoint5 (prod-mail-ppoint5.akamai.com [184.51.33.60] (may be forged))
        by m0050095.ppops.net-00190b01. with ESMTP id 35y5h9hrbn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 16:02:55 +0000
Received: from pps.filterd (prod-mail-ppoint5.akamai.com [127.0.0.1])
        by prod-mail-ppoint5.akamai.com (8.16.0.43/8.16.0.43) with SMTP id 10CFXVmW026138;
        Tue, 12 Jan 2021 08:02:54 -0800
Received: from email.msg.corp.akamai.com ([172.27.123.32])
        by prod-mail-ppoint5.akamai.com with ESMTP id 35ybbe5w2b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 12 Jan 2021 08:02:53 -0800
Received: from usma1ex-cas4.msg.corp.akamai.com (172.27.123.57) by
 usma1ex-dag3mb6.msg.corp.akamai.com (172.27.123.54) with Microsoft SMTP
 Server (TLS) id 15.0.1497.2; Tue, 12 Jan 2021 11:02:53 -0500
Received: from bos-lhvedt (172.28.223.201) by usma1ex-cas4.msg.corp.akamai.com
 (172.27.123.57) with Microsoft SMTP Server (TLS) id 15.0.1497.2 via Frontend
 Transport; Tue, 12 Jan 2021 11:02:53 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <24573.51244.563087.333291@gargle.gargle.HOWL>
Date:   Tue, 12 Jan 2021 08:02:52 -0800
From:   Heath Caldwell <hcaldwel@akamai.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     netdev <netdev@vger.kernel.org>, Yuchung Cheng <ycheng@google.com>,
        Josh Hunt <johunt@akamai.com>, Ji Li <jli@akamai.com>
Subject: Re: [PATCH net-next 4/4] tcp: remove limit on initial receive window
In-Reply-To: <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
References: <20210111222411.232916-1-hcaldwel@akamai.com>
        <20210111222411.232916-5-hcaldwel@akamai.com>
        <CANn89iLheJ+a0AZ_JZyitsZK5RCVsadzgsBK=DeHs-7ko5OMuQ@mail.gmail.com>
X-Mailer: VM 8.2.0b under 28.0.50 (x86_64-pc-linux-gnu)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120090
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-12_10:2021-01-12,2021-01-12 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 phishscore=0 suspectscore=0 impostorscore=0 spamscore=0 lowpriorityscore=0
 bulkscore=0 priorityscore=1501 mlxscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101120091
X-Agari-Authentication-Results: mx.akamai.com; spf=${SPFResult} (sender IP is 184.51.33.60)
 smtp.mailfrom=hcaldwel@akamai.com smtp.helo=prod-mail-ppoint5
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-01-12 09:30 (+0100), Eric Dumazet <edumazet@google.com> wrote:
> I think the whole patch series is an attempt to badly break TCP stack.

Can you explain the concern that you have about how these changes might
break the TCP stack?

Patches 1 and 3 fix clear bugs.

Patches 2 and 4 might be arguable, though.

Is you objection primarily about the limit removed by patch 4?

> Hint : 64K is really the max allowed by TCP standards. Yes, this is
> sad, but this is it.

Do you mean the limit imposed by the size of the "Window Size" header
field?  This limitation is directly addressed by the check in
__tcp_transmit_skb():

	if (likely(!(tcb->tcp_flags & TCPHDR_SYN))) {
		th->window      = htons(tcp_select_window(sk));
		tcp_ecn_send(sk, skb, th, tcp_header_size);
	} else {
		/* RFC1323: The window in SYN & SYN/ACK segments
		 * is never scaled.
		 */
		th->window	= htons(min(tp->rcv_wnd, 65535U));
	}

and checking (and capping it there) allows for the field to not overflow
while also not artificially restricting the size of the window which
will later be advertised (once window scaling is negotiated).

> I will not spend hours of work running  packetdrill tests over your
> changes, but I am sure they are now quite broken.
> 
> If you believe auto tuning is broken, fix it properly, without trying
> to change all the code so that you can understand it.

The removal of the limit specifically addresses the situation where auto
tuning cannot work: on the initial burst.  There is no way to know
whether an installation desires to receive a larger first burst unless
it is specifically configured - and this limit prevents such
configuration.

> I strongly advise you read RFC 7323 before doing any changes in TCP
> stack, and asking us to spend time reviewing your patches.

Can you point out the part of the RFC which would be violated by
initially (that is, the first packet after the SYN) advertising a window
larger than 64KB?

> If you want to do research, this is fine, but please do not break
> production TCP stack.
> 
> Thank you.
