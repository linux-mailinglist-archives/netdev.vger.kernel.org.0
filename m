Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A22329CB8
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 19:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731460AbfEXRKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 13:10:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:33571 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725777AbfEXRKK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 May 2019 13:10:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 May 2019 10:10:09 -0700
X-ExtLoop1: 1
Received: from ellie.jf.intel.com (HELO ellie) ([10.54.70.22])
  by fmsmga006.fm.intel.com with ESMTP; 24 May 2019 10:10:07 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, edumazet@google.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net-next v2] selftests/net: SO_TXTIME with ETF and FQ
In-Reply-To: <20190523174846.84394-1-willemdebruijn.kernel@gmail.com>
References: <20190523174846.84394-1-willemdebruijn.kernel@gmail.com>
Date:   Fri, 24 May 2019 10:10:08 -0700
Message-ID: <8736l3n5hr.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Willem de Bruijn <willemdebruijn.kernel@gmail.com> writes:

> From: Willem de Bruijn <willemb@google.com>
>
> The SO_TXTIME API enables packet tranmission with delayed delivery.
> This is currently supported by the ETF and FQ packet schedulers.
>
> Evaluate the interface with both schedulers. Install the scheduler
> and send a variety of packets streams: without delay, with one
> delayed packet, with multiple ordered delays and with reordering.
> Verify that packets are released by the scheduler in expected order.
>
> The ETF qdisc requires a timestamp in the future on every packet. It
> needs a delay on the qdisc else the packet is dropped on dequeue for
> having a delivery time in the past. The test value is experimentally
> derived. ETF requires clock_id CLOCK_TAI. It checks this base and
> drops for non-conformance.
>
> The FQ qdisc expects clock_id CLOCK_MONOTONIC, the base used by TCP
> as of commit fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC").
> Within a flow there is an expecation of ordered delivery, as shown by
> delivery times of test 4. The FQ qdisc does not require all packets to
> have timestamps and does not drop for non-conformance.
>
> The large (msec) delays are chosen to avoid flakiness.
>
> 	Output:
>
> 	SO_TXTIME ipv6 clock monotonic
> 	payload:a delay:28 expected:0 (us)
>
> 	SO_TXTIME ipv4 clock monotonic
> 	payload:a delay:38 expected:0 (us)
>
> 	SO_TXTIME ipv6 clock monotonic
> 	payload:a delay:40 expected:0 (us)
>
> 	SO_TXTIME ipv4 clock monotonic
> 	payload:a delay:33 expected:0 (us)
>
> 	SO_TXTIME ipv6 clock monotonic
> 	payload:a delay:10120 expected:10000 (us)
>
> 	SO_TXTIME ipv4 clock monotonic
> 	payload:a delay:10102 expected:10000 (us)
>
> 	[.. etc ..]
>
> 	OK. All tests passed
>
> Changes v1->v2: update commit message output
>
> Signed-off-by: Willem de Bruijn <willemb@google.com>
> Acked-by: Eric Dumazet <edumazet@google.com>

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>


Cheers,
--
Vinicius
