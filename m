Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E61E736706C
	for <lists+netdev@lfdr.de>; Wed, 21 Apr 2021 18:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244390AbhDUQqj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Apr 2021 12:46:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238199AbhDUQqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Apr 2021 12:46:30 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 377F9C06174A
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 09:45:56 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id h4so33006549wrt.12
        for <netdev@vger.kernel.org>; Wed, 21 Apr 2021 09:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BLwYcqJ6UcNz3X6OS9ZPBF9VijP9qaPjSIQPm+2ZeF4=;
        b=YZjDJg6WZvk0vHuhjp7OGbOTJI0KQH7YRmkk9+rQZOT0S+yR+cJm65Zawbb2hUUaes
         YGjvEufFoS9NByC2oydxaGQ5F6lBuqvYPMdeYxr2VNOLZ8+Hg/G/dErNOZwdSj2yKNnc
         XlGhgOX4MYupGtUDEWzcWW+pZudojlWlyuw8TR7xwbZJnqQ9QjInoI1kIpxs5FH1ndsj
         JiBNzGvDT38dXh04BhIQr6ClbuLnPDOgwmmcR5B3K61NpQYlh3Puk0h+YAoBPZxxvQ7y
         pa0cb0bVHvaYayLKaj1O2cVAWteJyFPcBaRocIoZhHqEpsN+3ZlDYD8xjTjWXT2iniKR
         9d7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BLwYcqJ6UcNz3X6OS9ZPBF9VijP9qaPjSIQPm+2ZeF4=;
        b=C3pIbORaKyEpbjdiNmxvbfpD+VowYh48WUjc0bUDHBaZ7LDpdX77JMuopWWfaMVC/v
         4+OinHdggxujhd/OhtTbfzr1gf4qtVDo+HgBdbYf5rMEzFMuSTCqOVUfZxHFqqFXLYz6
         UR2JUrbRNXtw99H4dbQL6AIoumQ02NUfZfrVbfwEsNHk/MfYmFnjuy9lisJtxifhgEEP
         kk+S+auysSgrv/6sb0duz7sZgFnUhv2HDm7mPfT5e+O6apZJuZKq9h/AYf7GcJRrVKlC
         sUhd88GnoG5uukO4tPG8KNQ3VIhePYE+QvXW+AJPX8wMXkFG5ChCZZF2LE4gQ90KH7RE
         pvOw==
X-Gm-Message-State: AOAM530VfdrGTZggnNFhsjpDWBQzlMGkqOdeqTfvL/tcDU2q6oXpJZ5u
        chvgNcNdpSC/RpkaHIT8o9er6vmCB+TLi65L3XH44Q==
X-Google-Smtp-Source: ABdhPJwkfmMvaQ+1LA+nhCeYuUt8FBtc52TexF/XJKjA5LC9WerIyIPZgMqnNiYQG3EULO148fjeP4yO5v2Hd+3HdZE=
X-Received: by 2002:a05:6000:1249:: with SMTP id j9mr27716991wrx.416.1619023554782;
 Wed, 21 Apr 2021 09:45:54 -0700 (PDT)
MIME-Version: 1.0
References: <d7fbf3d3a2490d0a9e99945593ada243da58e0f8.1619000255.git.cdleonard@gmail.com>
 <CADVnQynLSDQHxgMN6=mU2m58t_JKUyugmw0j6g1UDG+jLxTfAw@mail.gmail.com> <CAH56bmDBGsHOSjJpo=TseUATOh0cZqTMFyFO1sqtQmMrTPHtrA@mail.gmail.com>
In-Reply-To: <CAH56bmDBGsHOSjJpo=TseUATOh0cZqTMFyFO1sqtQmMrTPHtrA@mail.gmail.com>
From:   Matt Mathis <mattmathis@google.com>
Date:   Wed, 21 Apr 2021 09:45:42 -0700
Message-ID: <CAH56bmCp8eRqsdoMTmAmCaEnubwEy317OJKQ9UjqMvDwrkcMdQ@mail.gmail.com>
Subject: Fwd: [RFC] tcp: Delay sending non-probes for RFC4821 mtu probing
To:     Leonard Crestez <cdleonard@gmail.com>
Cc:     "Cc: Willem de Bruijn" <willemb@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Ilya Lesokhin <ilyal@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, Wei Wang <weiwan@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        netdev <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(Resending in plain text mode)

Surely there is a way to adapt tcp_tso_should_defer(), it is trying to
solve a similar problem.

If I were to implement PLPMTUD today, I would more deeply entwine it
into TCP's support for TSO.  e.g. successful deferring segments
sometimes enables TSO and sometimes enables PLPMTUD.

But there is a deeper question:  John Heffner and I invested a huge
amount of energy in trying to make PLPMTUD work for opportunistic
Jumbo discovery, only to discover that we had moved the problem down
to the device driver/nic, were it isn't so readily solvable.

The driver needs to carve nic buffer memory before it can communicate
with a switch (to either ask or measure the MTU), and once it has done
that it needs to either re-carve the memory or run with suboptimal
carving.  Both of these are problematic.

There is also a problem that many link technologies will
non-deterministically deliver jumbo frames at greatly increased error
rates.   This issue requires a long conversation on it's own.

Thanks,
--MM--
The best way to predict the future is to create it.  - Alan Kay

We must not tolerate intolerance;
       however our response must be carefully measured:
            too strong would be hypocritical and risks spiraling out of control;
            too weak risks being mistaken for tacit approval.


On Wed, Apr 21, 2021 at 5:48 AM Neal Cardwell <ncardwell@google.com> wrote:
>
> On Wed, Apr 21, 2021 at 6:21 AM Leonard Crestez <cdleonard@gmail.com> wrote:
> >
> > According to RFC4821 Section 7.4 "Protocols MAY delay sending non-probes
> > in order to accumulate enough data" but linux almost never does that.
> >
> > Linux waits for probe_size + (1 + retries) * mss_cache to be available
> > in the send buffer and if that condition is not met it will send anyway
> > using the current MSS. The feature can be made to work by sending very
> > large chunks of data from userspace (for example 128k) but for small writes
> > on fast links probes almost never happen.
> >
> > This patch tries to implement the "MAY" by adding an extra flag
> > "wait_data" to icsk_mtup which is set to 1 if a probe is possible but
> > insufficient data is available. Then data is held back in
> > tcp_write_xmit until a probe is sent, probing conditions are no longer
> > met, or 500ms pass.
> >
> > Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> >
> > ---
> >  Documentation/networking/ip-sysctl.rst |  4 ++
> >  include/net/inet_connection_sock.h     |  7 +++-
> >  include/net/netns/ipv4.h               |  1 +
> >  include/net/tcp.h                      |  2 +
> >  net/ipv4/sysctl_net_ipv4.c             |  7 ++++
> >  net/ipv4/tcp_ipv4.c                    |  1 +
> >  net/ipv4/tcp_output.c                  | 54 ++++++++++++++++++++++++--
> >  7 files changed, 71 insertions(+), 5 deletions(-)
> >
> > My tests are here: https://github.com/cdleonard/test-tcp-mtu-probing
> >
> > This patch makes the test pass quite reliably with
> > ICMP_BLACKHOLE=1 TCP_MTU_PROBING=1 IPERF_WINDOW=256k IPERF_LEN=8k while
> > before it only worked with much higher IPERF_LEN=256k
> >
> > In my loopback tests I also observed another issue when tcp_retries
> > increases because of SACKReorder. This makes the original problem worse
> > (since the retries amount factors in buffer requirement) and seems to be
> > unrelated issue. Maybe when loss happens due to MTU shrinkage the sender
> > sack logic is confused somehow?
> >
> > I know it's towards the end of the cycle but this is mostly just intended for
> > discussion.
>
> Thanks for raising the question of how to trigger PMTU probes more often!
>
> AFAICT this approach would cause unacceptable performance impacts by
> often injecting unnecessary 500ms delays when there is no need to do
> so.
>
> If the goal is to increase the frequency of PMTU probes, which seems
> like a valid goal, I would suggest that we rethink the Linux heuristic
> for triggering PMTU probes in the light of the fact that the loss
> detection mechanism is now RACK-TLP, which provides quick recovery in
> a much wider variety of scenarios.
>
> After all, https://tools.ietf.org/html/rfc4821#section-7.4 says:
>
>    In addition, the timely loss detection algorithms in most protocols
>    have pre-conditions that SHOULD be satisfied before sending a probe.
>
> And we know that the "timely loss detection algorithms" have advanced
> since this RFC was written in 2007.
>
> You mention:
> > Linux waits for probe_size + (1 + retries) * mss_cache to be available
>
> The code in question seems to be:
>
>   size_needed = probe_size + (tp->reordering + 1) * tp->mss_cache;
>
> How about just changing this to:
>
>   size_needed = probe_size + tp->mss_cache;
>
> The rationale would be that if that amount of data is available, then
> the sender can send one probe and one following current-mss-size
> packet. If the path MTU has not increased to allow the probe of size
> probe_size to pass through the network, then the following
> current-mss-size packet will likely pass through the network, generate
> a SACK, and trigger a RACK fast recovery 1/4*min_rtt later, when the
> RACK reorder timer fires.
>
> A secondary rationale for this heuristic would be: if the flow never
> accumulates roughly two packets worth of data, then does the flow
> really need a bigger packet size?
>
> IMHO, just reducing the size_needed seems far preferable to needlessly
> injecting 500ms delays.
>
> best,
> neal
