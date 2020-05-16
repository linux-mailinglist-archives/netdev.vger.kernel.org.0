Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DBCD1D641D
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 23:03:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbgEPVDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 May 2020 17:03:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726592AbgEPVDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 May 2020 17:03:52 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A640C061A0C
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 14:03:52 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id nv1so5452505ejb.0
        for <netdev@vger.kernel.org>; Sat, 16 May 2020 14:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ws6axd/Aepsy0S9ene5LWIHvKeAxR5u9L8ytIPkfwAM=;
        b=mrZSxPWUIraWG5QkSf6SRCPvFHTNNvYCEw5vRRqiZtVJ6E0uvb0zYUZYiH/4IQm+R5
         09xkDHBZUUdEocX1wrdMBZijqpNwfsK+S81+2hczaBpYrg4E1UL8UN9Tl+kkwhXrYReg
         NJSwCuLZYrDuAVDNzcED0tkB6GMiuYlzBjgIRjuC+Kni26ns0XCoOTjaGIevPrl2cd98
         XMbkubIbV5lV8EvxX6YgVN7avVLhh0wUwylDUxK3n0rxksFYoDei2aov6IXvB6ulPU8Z
         yjFrojQahWSNTNJHTaI5ReRjklAAR1a2q/6IJ4ZaKdpH/9ccct3r6Zhj4FfnGs7QmKQO
         G9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Ws6axd/Aepsy0S9ene5LWIHvKeAxR5u9L8ytIPkfwAM=;
        b=egldXRYWcLtSmvu5dMPWEUbKoOO3oYRyY1cUtZUGmBN7turODFaprxpC7gv9zrMW0g
         yHjssOBxhfLpVxmnkEYBapIlaa14ftnTG2M0G6igDs8YXTvv0HGUkbKHfTsdDdXeg5WV
         9O8cr+NrEx4Du5B+ALG1Ut3HtQchEWEf0RmGar++bPBnTQ+9N8XRJi+JDx/1Tcq2ExWr
         QMwoSriPov6pa4EgGCWE9m64IynzM0wIcFS9dCwFXh97eGmluQfxbP1fU/pFQLIpFSxQ
         fYuP1sSemOFdJv+FoL3OR7ilEsbNfUlA43OXcOqsz/uCLWOV0KkYP3kWiybtE/uxW0xM
         rpgg==
X-Gm-Message-State: AOAM530LMi0o/CqdZMXwXcdHc8GPUJnDgwbcc8WGsF/BKqJIEQK125aW
        P8bpsouW8O/tNoiZHYncZGnPXdAGVTTna48DG94=
X-Google-Smtp-Source: ABdhPJy4lzFA92G+xErq1tkkUhiEOQCXeFA54VJXvTPO5tal0v8lAf6jrX/Q8mY5AAylAkNMtI1QQbtB8fyXMt/GzOI=
X-Received: by 2002:a17:906:dbcf:: with SMTP id yc15mr8830061ejb.176.1589663031078;
 Sat, 16 May 2020 14:03:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200516012948.3173993-1-vinicius.gomes@intel.com> <20200516.133739.285740119627243211.davem@davemloft.net>
In-Reply-To: <20200516.133739.285740119627243211.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sun, 17 May 2020 00:03:39 +0300
Message-ID: <CA+h21hoNW_++QHRob+NbWC2k7y7sFec3kotSjTL6s8eZGGT+2Q@mail.gmail.com>
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     David Miller <davem@davemloft.net>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        netdev <netdev@vger.kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Jose Abreu <Jose.Abreu@synopsys.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

On Sat, 16 May 2020 at 23:39, David Miller <davem@davemloft.net> wrote:
>
> From: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> Date: Fri, 15 May 2020 18:29:44 -0700
>
> > This series adds support for configuring frame preemption, as defined
> > by IEEE 802.1Q-2018 (previously IEEE 802.1Qbu) and IEEE 802.3br.
> >
> > Frame preemption allows a packet from a higher priority queue marked
> > as "express" to preempt a packet from lower priority queue marked as
> > "preemptible". The idea is that this can help reduce the latency for
> > higher priority traffic.
>
> Why do we need yet another name for something which is just basic
> traffic prioritization and why is this configured via ethtool instead
> of the "traffic classifier" which is where all of this stuff should
> be done?

It is not 'just another name for basic traffic prioritization'. With
basic traffic prioritization only, a high-priority packet still has to
wait in the egress queue of a switch until a (potentially large)
low-priority packet has finished transmission and has freed the
medium. Frame preemption changes that. Actually it requires hardware
support on both ends, because the way it is transmitted on the wire is
not compatible with regular Ethernet frames (it uses a special Start
Of Frame Delimiter to encode preemptible traffic).
I know we are talking about ridiculously low improvements in latency,
but the background is that Ethernet is making its way into the
industrial and process control fields, and for that type of
application you need to ensure minimally low and maximally consistent
end-to-end latencies. Frame preemption helps with the "minimally low"
part. The way it works is that typically there are 2 MACs per
interface (1 is "express" - equivalent to the legacy type, and the
other is "preemptible" - the new type) and this new IEEE 802.1Q clause
thing allows some arbitration/preemption event to happen between the
two MACs. When a preemption event happens, the preemptible MAC quickly
wraps up and aborts the frame it's currently transmitting (to come
back and continue later), making room for the express MAC to do its
thing because it's time-constrained. Then, after the express MAC
finishes, the preemptible MAC continues with the rest of the frame
fragments from where it was preempted.
As to why this doesn't go to tc but to ethtool: why would it go to tc?
You can't emulate such behavior in software. It's a hardware feature.
You only* (more or less) need to specify which traffic classes on a
port go to the preemptible MAC and which go to the express MAC. We
discussed about the possibility of extending tc-taprio to configure
frame preemption through it, but the consensus was that somebody might
want to use frame preemption as a standalone feature, without
scheduled traffic, and that inventing another qdisc for frame
preemption alone would be too much of a formalism. (I hope I didn't
omit anything important from the previous discussion on the topic)

Thanks,
-Vladimir
