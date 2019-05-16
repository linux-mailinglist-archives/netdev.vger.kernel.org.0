Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 302D721033
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 23:42:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbfEPVmQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 17:42:16 -0400
Received: from mail-qt1-f173.google.com ([209.85.160.173]:44621 "EHLO
        mail-qt1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726732AbfEPVmP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 17:42:15 -0400
Received: by mail-qt1-f173.google.com with SMTP id f24so5733168qtk.11
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 14:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appleguru.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PHWpDtZOMkGqPodDl06g2fLX04n5d+k5gHXUynXP0rc=;
        b=JFEXQznXKlatmo88labz5YWhrdWatlZJVAOzAq2WlqbPu9lEWjt364r2NcaMEJCVQ9
         VumdNu8jGzkcSi5RQyBzHR2m88iqZkncPcJ0HVqbn6KWpX1g2Wfp+MkUMOrsSGnbt7d6
         x00GpdS1F5PNba1AgJ4uHaQI/1WqZGb3m/glc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PHWpDtZOMkGqPodDl06g2fLX04n5d+k5gHXUynXP0rc=;
        b=RL25H46ejBcWUcP8MPdt+OIAijPqfnWMjB+mF82Bbhp0ERKhlvE0FL1J4EG2GOfH2F
         BH9dtmWHnOqZzCtBpYio6SI7dYInOyhEq1r64MsnWhz1rs0dyREhCIRqETsHNBrBo+Mb
         WG/u4eHrheEOWdWvzH4cpA94pQB1jA7laa+7Kz0ZdWJU5rRBi1yljvIJW/T16oThTHZJ
         yPKl+OsblE6JVLJ5MClzejxuwxtYlKfDO++P8bQip1qdXKHDwm+u2AJG2bxm0SDN4v67
         /rFRaNaWKrdmbwaTRO0UqtQzFbf+FH6uAE4XzuBlK/obVPN8SfuSru+k+URs+cf5vuzv
         rzsw==
X-Gm-Message-State: APjAAAXEiyODwVl3DJ0F5emQVFMbPk57ctpDNchm7axwSakb5qldqA0z
        NCDbMVfKjlaOHi75MKCW8UMkLc9PalQ=
X-Google-Smtp-Source: APXvYqyK0qSls2IL6enNBeJf7BPT7sfY2DDIS+z10gmIPTQ5gRfM9/MF94RXa8hdKXRq0Dj0UOSxqg==
X-Received: by 2002:aed:3598:: with SMTP id c24mr45013443qte.364.1558042934393;
        Thu, 16 May 2019 14:42:14 -0700 (PDT)
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com. [209.85.160.171])
        by smtp.gmail.com with ESMTPSA id a58sm2422622qtc.13.2019.05.16.14.42.13
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 14:42:13 -0700 (PDT)
Received: by mail-qt1-f171.google.com with SMTP id i26so5730459qtr.10
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 14:42:13 -0700 (PDT)
X-Received: by 2002:a0c:99ca:: with SMTP id y10mr37229365qve.8.1558042933449;
 Thu, 16 May 2019 14:42:13 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com> <18aefee7-4c47-d330-c6c1-7d1442551fa6@gmail.com>
 <CABUuw67crf5yb0G_KRR94WLBP8YYLgABBgv1SFW0SvKB_ntK4w@mail.gmail.com> <1f6a6c3f-d723-4739-da77-58a55cfa2170@gmail.com>
In-Reply-To: <1f6a6c3f-d723-4739-da77-58a55cfa2170@gmail.com>
From:   Adam Urban <adam.urban@appleguru.org>
Date:   Thu, 16 May 2019 17:42:02 -0400
X-Gmail-Original-Message-ID: <CABUuw65xvT0t+Eq881jCvU7yNg1W-PXZkHvaSDg891W_OP-2uw@mail.gmail.com>
Message-ID: <CABUuw65xvT0t+Eq881jCvU7yNg1W-PXZkHvaSDg891W_OP-2uw@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

How can I see if there is an active arp queue?

Regarding the qdisc, I don't think we're bumping up against that (at
least not in my tiny bench setup):

tc -s qdisc show
qdisc fq_codel 0: dev eth0 root refcnt 2 limit 10240p flows 1024
quantum 1514 target 5.0ms interval 100.0ms ecn
 Sent 925035443 bytes 8988011 pkt (dropped 0, overlimits 0 requeues 3)
 backlog 0b 0p requeues 3
  maxpacket 717 drop_overlimit 0 new_flow_count 1004 ecn_mark 0
  new_flows_len 0 old_flows_len 0

I'm not sure I still 100% understand the relationship between the
socket buffer (skb / wmem_default sysctl setting or SO_SNDBUF socket
option), arp queue (arp_queue), and the unres_qlen_bytes sysctl
setting. I've made a public google spreadsheet here to try and
calculate this value based on some input and assumptions. Can you take
a look and see if I got this somewhat correct?

https://docs.google.com/spreadsheets/d/1t9_UowY6sok8xvK8Tx_La_jB4iqpewJT5X4WANj39gg/edit?usp=sharing

On Thu, May 16, 2019 at 1:03 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/16/19 9:32 AM, Adam Urban wrote:
> > Eric, thanks. Increasing wmem_default from 229376 to 2293760 indeed
> > makes the issue go away on my test bench. What's a good way to
> > determine the optimal value here? I assume this is in bytes and needs
> > to be large enough so that the SO_SNDBUF doesn't fill up before the
> > kernel drops the packets. How often does that happen?
>
> You have to count the max number of arp queues your UDP socket could hit.
>
> Say this number is X
>
> Then wmem_default should be set  to X * unres_qlen_bytes + Y
>
> With Y =  229376  (the default  wmem_default)
>
> Then, you might need to increase the qdisc limits.
>
> If no arp queue is active, all UDP packets could be in the qdisc and might hit sooner
> the qdisc limit, thus dropping packets on the qdisc.
>
> (This is assuming your UDP application can blast packets at a rate above the link rate)
>
> >
> > On Thu, May 16, 2019 at 12:14 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >>
> >>
> >>
> >> On 5/16/19 9:05 AM, Eric Dumazet wrote:
> >>
> >>> We probably should add a ttl on arp queues.
> >>>
> >>> neigh_probe() could do that quite easily.
> >>>
> >>
> >> Adam, all you need to do is to increase UDP socket sndbuf.
> >>
> >> Either by increasing /proc/sys/net/core/wmem_default
> >>
> >> or using setsockopt( ... SO_SNDBUF ... )
> >>
