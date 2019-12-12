Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 948DC11D14C
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 16:47:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfLLPrh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 10:47:37 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:43966 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729013AbfLLPrg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 10:47:36 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.3)
        (envelope-from <johannes@sipsolutions.net>)
        id 1ifQgf-007QNn-GP; Thu, 12 Dec 2019 16:47:33 +0100
Message-ID: <f4670ce0f4399fe82e7168fb9c491d8eb718e8d8.camel@sipsolutions.net>
Subject: Re: debugging TCP stalls on high-speed wifi
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Neal Cardwell <ncardwell@google.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@redhat.com>,
        linux-wireless@vger.kernel.org, Netdev <netdev@vger.kernel.org>
Date:   Thu, 12 Dec 2019 16:47:30 +0100
In-Reply-To: <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com> (sfid-20191212_161133_657244_F94C6EAB)
References: <14cedbb9300f887fecc399ebcdb70c153955f876.camel@sipsolutions.net>
         <CADVnQym_CNktZ917q0-9dVY9dhtiJVRRotGTrPNdZUpkjd3vyw@mail.gmail.com>
         (sfid-20191212_161133_657244_F94C6EAB)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neal,

On Thu, 2019-12-12 at 10:11 -0500, Neal Cardwell wrote:
> On Thu, Dec 12, 2019 at 9:50 AM Johannes Berg <johannes@sipsolutions.net> wrote:
> > If you have any thoughts on this, I'd appreciate it.
> 
> Thanks for the detailed report!

Well, it wasn't. For example, I neglected to mention that I have to
actually use at least 2 TCP streams (but have tried up to 20) in order
to not run into the gbit link limit on the AP :-)

> I was curious:
> 
> o What's the sender's qdisc configuration?

There's none, mac80211 bypasses qdiscs in favour of its internal TXQs
with FQ/codel.

> o Would you be able to log periodic dumps (e.g. every 50ms or 100ms)
> of the test connection using a recent "ss" binary and "ss -tinm", to
> hopefully get a sense of buffer parameters, and whether the flow in
> these cases is being cwnd-limited, pacing-limited,
> send-buffer-limited, or receive-window-limited?

Sure, though I'm not sure my ss is recent enough for what you had in
mind - if not I'll have to rebuild it (it was iproute2-ss190708).

https://p.sipsolutions.net/3e515625bf13fa69.txt

Note there are 4 connections (iperf is being used) but two are control
and two are data. Easy to see the difference really :-)

> o Would you be able to share a headers-only tcpdump pcap trace?

I'm not sure how to do headers-only, but I guess -s100 will work.

https://johannes.sipsolutions.net/files/he-tcp.pcap.xz

Note that this is from a different run than the ss stats.

johannes

