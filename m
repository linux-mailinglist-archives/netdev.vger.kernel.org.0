Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D602D33BC9
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 01:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbfFCXNb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 19:13:31 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:35770 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726097AbfFCXNa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 19:13:30 -0400
Received: by mail-ed1-f68.google.com with SMTP id p26so29212777edr.2;
        Mon, 03 Jun 2019 16:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nri5hU1JrVEqtA4r+2sZlw3+yvE80eWqFfb9xwcT2OY=;
        b=uR6AEwG7x0FN4XSTCsDC/ZRDJJ2DQb0nwwu5Jna57WNv9cfuW7BjDNTWh0LT4Ge2bC
         Rso37okspkqVW0kbIoclPtj0BA0tkUamEA+1JiMxOIyCWu3XpZfnyNG4Wd2wQsBNOKgz
         uu21lqZ9Tq/zCSuqpP3KSQsn1T3QxJfk04PhEldAaLdl1S1Foq1wxMuLUcBsYLzQtUA5
         6l8QmZpMUZTze6GlYSdZyfQaM4DyUnteGKyMWpKBAInD7oK7h/A9nlyxWpzLqLmNUX3G
         Xtn2+c0C/GThuppxKhYUqd7Ye/6p87WAthvwOmgwqoY1Jav+ltNYoXsYj4I3KK1e3Jel
         z85Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nri5hU1JrVEqtA4r+2sZlw3+yvE80eWqFfb9xwcT2OY=;
        b=qaQHIGpzx4XnKwivpZ9olJF6TPiaSjC/Rn2HTvVW5GcROjWkfh6mLJidRjUstek9XV
         23KpH1gmcUS4I3s1X0ZeyACADAqZujk6H7R70sQyfm6pjGb1G3B0Bps1PCvHlMfb3Bj+
         r4oNQsXwWbcaKqa0DRhjywI20ppjQ6PKl9N1w72/QgBPmfc3Xk9m2dcfviPmuElE6dut
         O0DMrZFdvUm66XOuTqpZtL0Qv3o4Du7VJn6KX+ihHkEevPBf9YIWh/ca+BJ1UvejHFE2
         0nC0YCSuZQ19AXyeYww3ohe5QL+NFIgptAcXJ40tRFOZ9p5yZpym5iJuaJHlH7x8vUn+
         PN6A==
X-Gm-Message-State: APjAAAUAq5upYwBQU35zl1yxVbK7C9U0KrBreT65YeFH/dPLxnLpOWuA
        CUfmBAmr1/K8pxJAbwvkbrj0yZX481KF/HsdWyk=
X-Google-Smtp-Source: APXvYqwNRwNzukAWmwUOs3YBExLPE65Lglm3cahyu+HYVKD5XpIhE3R9PwPs42PHvMqXauefLRQpfW4YHq7DEwfME0Y=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr30998950eds.117.1559603608065;
 Mon, 03 Jun 2019 16:13:28 -0700 (PDT)
MIME-Version: 1.0
References: <20190602213926.2290-1-olteanv@gmail.com>
In-Reply-To: <20190602213926.2290-1-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 4 Jun 2019 02:13:16 +0300
Message-ID: <CA+h21hoOO1apNWXer01LE572pgdnVdmf_e7-Tnp6jgJuTPbGHg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 00/10] PTP support for the SJA1105 DSA driver
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>
Cc:     lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Jun 2019 at 00:40, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> This patchset adds the following:
>
>  - A timecounter/cyclecounter based PHC for the free-running
>    timestamping clock of this switch.
>
>  - A state machine implemented in the DSA tagger for SJA1105, which
>    keeps track of metadata follow-up Ethernet frames (the switch's way
>    of transmitting RX timestamps).
>
> Clock manipulations on the actual hardware PTP clock will have to be
> implemented anyway, for the TTEthernet block and the time-based ingress
> policer.
>
> This depends upon the "FDB updates for SJA1105 DSA driver" series at:
> https://patchwork.ozlabs.org/project/netdev/list/?series=111354&state=*
>
> v1 patchset can be found at:
> https://lkml.org/lkml/2019/5/28/1093
>
> Changes from v1:
>
> - Removed the addition of the DSA .can_timestamp callback.
>
> - Waiting for meta frames is done completely inside the tagger, and all
>   frames emitted on RX are already partially timestamped.
>
> - Added a global data structure for the tagger common to all ports.
>
> - Made PTP work with ports in standalone mode, by limiting use of the
>   DMAC-mangling "incl_srcpt" mode only when ports are bridged, aka when
>   the DSA master is already promiscuous and can receive anything.
>   Also changed meta frames to be sent at the 01-80-C2-00-00-0E DMAC.
>
> - Made some progress w.r.t. observed negative path delay.  Apparently it
>   only appears when the delay mechanism is the delay request-response
>   (end-to-end) one. If peer delay is used (-P), the path delay is
>   positive and appears reasonable for an 1000Base-T link (485 ns in
>   steady state).
>
>   SJA1105 as PTP slave (OC) with E2E path delay:
>
> ptp4l[55.600]: master offset          8 s2 freq  +83677 path delay     -2390
> ptp4l[56.600]: master offset         17 s2 freq  +83688 path delay     -2391
> ptp4l[57.601]: master offset          6 s2 freq  +83682 path delay     -2391
> ptp4l[58.601]: master offset         -1 s2 freq  +83677 path delay     -2391
>
>   SJA1105 as PTP slave (OC) with P2P path delay:
>
> ptp4l[48.343]: master offset          5 s2 freq  +83715 path delay       484
> ptp4l[48.468]: master offset         -3 s2 freq  +83705 path delay       485
> ptp4l[48.593]: master offset          0 s2 freq  +83708 path delay       485
> ptp4l[48.718]: master offset          1 s2 freq  +83710 path delay       485
> ptp4l[48.844]: master offset          1 s2 freq  +83710 path delay       485
> ptp4l[48.969]: master offset         -5 s2 freq  +83702 path delay       485
> ptp4l[49.094]: master offset          3 s2 freq  +83712 path delay       485
> ptp4l[49.219]: master offset          4 s2 freq  +83714 path delay       485
> ptp4l[49.344]: master offset         -5 s2 freq  +83702 path delay       485
> ptp4l[49.469]: master offset          3 s2 freq  +83713 path delay       487
>
> Vladimir Oltean (10):
>   net: dsa: Keep a pointer to the skb clone for TX timestamping
>   net: dsa: Add teardown callback for drivers
>   net: dsa: tag_8021q: Create helper function for removing VLAN header
>   net: dsa: sja1105: Move sja1105_change_tpid into
>     sja1105_vlan_filtering
>   net: dsa: sja1105: Limit use of incl_srcpt to bridge+vlan mode
>   net: dsa: sja1105: Add support for the PTP clock
>   net: dsa: sja1105: Move sja1105_is_link_local to include/linux
>   net: dsa: sja1105: Make sja1105_is_link_local not match meta frames
>   net: dsa: sja1105: Add support for PTP timestamping
>   net: dsa: sja1105: Increase priority of CPU-trapped frames
>
>  drivers/net/dsa/sja1105/Kconfig               |   7 +
>  drivers/net/dsa/sja1105/Makefile              |   1 +
>  drivers/net/dsa/sja1105/sja1105.h             |  29 ++
>  .../net/dsa/sja1105/sja1105_dynamic_config.c  |   2 +
>  drivers/net/dsa/sja1105/sja1105_main.c        | 317 ++++++++++++--
>  drivers/net/dsa/sja1105/sja1105_ptp.c         | 392 ++++++++++++++++++
>  drivers/net/dsa/sja1105/sja1105_ptp.h         |  64 +++
>  drivers/net/dsa/sja1105/sja1105_spi.c         |  33 ++
>  .../net/dsa/sja1105/sja1105_static_config.c   |  59 +++
>  .../net/dsa/sja1105/sja1105_static_config.h   |  10 +
>  include/linux/dsa/8021q.h                     |   7 +
>  include/linux/dsa/sja1105.h                   |  51 +++
>  include/net/dsa.h                             |   1 +
>  net/dsa/dsa2.c                                |   3 +
>  net/dsa/slave.c                               |   3 +
>  net/dsa/tag_8021q.c                           |  15 +
>  net/dsa/tag_sja1105.c                         | 203 ++++++++-
>  17 files changed, 1150 insertions(+), 47 deletions(-)
>  create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.c
>  create mode 100644 drivers/net/dsa/sja1105/sja1105_ptp.h
>
> --
> 2.17.1
>

Hi Dave,

This series appears in patchwork as "superseded":
https://patchwork.ozlabs.org/project/netdev/list/?series=111356&state=*
Perhaps it got mixed up with another one?

Thanks,
-Vladimir
