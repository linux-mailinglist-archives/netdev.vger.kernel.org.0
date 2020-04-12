Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D13B91A5DD3
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 11:37:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726658AbgDLJhu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 05:37:50 -0400
Received: from smtp-fw-9101.amazon.com ([207.171.184.25]:45385 "EHLO
        smtp-fw-9101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725832AbgDLJhu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 05:37:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1586684271; x=1618220271;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=FgZO8pxUZGALjDJ81M+76TTc4tj9QTK3LKdaztb4PFU=;
  b=CBhxTckAI7MJqmMH90/EI9L9Taz7GBYeqUmwkMtdA0PxQcRbvzEYRirv
   C8YcZ32M7XmXsWH31bE3PKdmoUOR5r6fSzdpo/mKbg3Fp68Nry734wJPo
   ORdFy03eNFiDLtiEqECFvEUaboi73/t2MisxwjsLRbTQAnFL1ghWRyGm/
   0=;
IronPort-SDR: pzbsOi3X3Ao8axIdhhiCdVsB/4MT1EbhQzz78Yk7oM/2IrQsiblEgMBPxpBhJ8O8SYvrcTXQF9
 bUZ4aVk45nNw==
X-IronPort-AV: E=Sophos;i="5.72,374,1580774400"; 
   d="scan'208";a="28239324"
Subject: RE: Re: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Thread-Topic: Re: [PATCH] ena: Speed up initialization 90x by reducing poll delays
Received: from sea32-co-svc-lb4-vlan3.sea.corp.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.47.23.38])
  by smtp-border-fw-out-9101.sea19.amazon.com with ESMTP; 12 Apr 2020 09:37:49 +0000
Received: from EX13MTAUEA002.ant.amazon.com (pdx4-ws-svc-p6-lb7-vlan3.pdx.amazon.com [10.170.41.166])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 5FB14A2620;
        Sun, 12 Apr 2020 09:37:48 +0000 (UTC)
Received: from EX13D10EUB002.ant.amazon.com (10.43.166.66) by
 EX13MTAUEA002.ant.amazon.com (10.43.61.77) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Apr 2020 09:37:48 +0000
Received: from EX13D11EUB003.ant.amazon.com (10.43.166.58) by
 EX13D10EUB002.ant.amazon.com (10.43.166.66) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Sun, 12 Apr 2020 09:37:46 +0000
Received: from EX13D11EUB003.ant.amazon.com ([10.43.166.58]) by
 EX13D11EUB003.ant.amazon.com ([10.43.166.58]) with mapi id 15.00.1497.006;
 Sun, 12 Apr 2020 09:37:46 +0000
From:   "Jubran, Samih" <sameehj@amazon.com>
To:     Josh Triplett <josh@joshtriplett.org>
CC:     "Machulsky, Zorik" <zorik@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Tzalik, Guy" <gtzalik@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Thread-Index: AdX3p3qv2ZVxWOLdSTS1k/4T+/7WlwBi2jwABd6e1pA=
Date:   Sun, 12 Apr 2020 09:37:22 +0000
Deferred-Delivery: Sun, 12 Apr 2020 09:36:51 +0000
Message-ID: <1679d519016c4984b67eeb510d50e4b4@EX13D11EUB003.ant.amazon.com>
References: <eb427583ff2444dcae18e1e37fb27918@EX13D11EUB003.ant.amazon.com>
 <20200313122824.GA1389@localhost>
In-Reply-To: <20200313122824.GA1389@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.43.166.225]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Josh,

I wanted to let you know that we are still looking into your patch.=20
After some careful considerations we have decided to set the value of=20
ENA_POLL_US to 100us. The rationale behind this choice is that the=20
device might take up to 1ms to complete the reset operation and we=20
don't want to bombard device. We do agree with most of your patch=20
and we will be sending one based on it for review.

Thanks,
Sameeh

> -----Original Message-----
> From: Josh Triplett <josh@joshtriplett.org>
> Sent: Friday, March 13, 2020 2:28 PM
> To: Jubran, Samih <sameehj@amazon.com>
> Cc: Machulsky, Zorik <zorik@amazon.com>; Belgazal, Netanel
> <netanel@amazon.com>; Kiyanovski, Arthur <akiyano@amazon.com>;
> Tzalik, Guy <gtzalik@amazon.com>; Bshara, Saeed <saeedb@amazon.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: RE: [EXTERNAL]Re: [PATCH] ena: Speed up initialization 90x by
> reducing poll delays
>=20
> CAUTION: This email originated from outside of the organization. Do not c=
lick
> links or open attachments unless you can confirm the sender and know the
> content is safe.
>=20
>=20
>=20
> On Wed, Mar 11, 2020 at 01:24:17PM +0000, Jubran, Samih wrote:
> > Hi Josh,
> >
> > Thanks for taking the time to write this patch. I have faced a bug whil=
e
> testing it that I haven't pinpointed yet the root cause of the issue, but=
 it
> seems to me like a race in the netlink infrastructure.
> >
> > Here is the bug scenario:
> > 1. created ac  c5.24xlarge instance in AWS in v_virginia region using
> > the default amazon Linux 2 AMI 2. apply your patch won top of net-next
> > v5.2 and install the kernel (currently I'm able to boot net-next v5.2
> > only, higher versions of net-next suffer from errors during boot time)
> > 3. run "rmmod ena && insmod ena.ko" twice
> >
> > Result:
> > The interface is not in up state
> >
> > Expected result:
> > The interface should be in up state
> >
> > What I know so far:
> > * ena_probe() seems to finish with no errors whatsoever
> > * adding prints / delays to ena_probe() causes the bug to vanish or
> > less likely to occur depending on the amount of delays I add
> > * ena_up() is not called at all when the bug occurs, so it's something
> > to do with netlink not invoking dev_open()
> >
> > Did you face such issues? Do you have any idea what might be causing th=
is?
>=20
> I haven't observed anything like this. I didn't test with Amazon Linux 2,
> though.
>=20
> To rule out some possibilities, could you try disabling *all* userspace
> networking bits, so that userspace does nothing with a newly discovered
> interface, and then testing again? (The interface wouldn't be "up" in tha=
t
> case, but it should still have a link detected.)
>=20
> If that works, then I wonder if the userspace used in Amazon Linux 2 migh=
t
> have some kind of race where it's still using the previous incarnation of=
 the
> device when you rmmod and insmod? Perhaps the previous delays made it
> difficult or impossible to trigger that race?
>=20
> - Josh Triplett
