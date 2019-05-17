Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D08E621279
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 05:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727640AbfEQDXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 23:23:12 -0400
Received: from mail-yw1-f46.google.com ([209.85.161.46]:44387 "EHLO
        mail-yw1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725929AbfEQDXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 23:23:12 -0400
Received: by mail-yw1-f46.google.com with SMTP id e74so2195929ywe.11
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 20:23:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JO2UG45zb1kIWYsX/kWseGG+NIsyRhC1AMAZ+Pb5C80=;
        b=elUC5i7OxNUHdaMOza7hQSQhV3SXY9siz80aCaUnUde7s9v9bnIprG1KYXrIdKaxyP
         1vXmYm4wfWoS7GRzOqrNPTAHUrf8qf7kEwAIbgBrGQ/Nkwh5hGlOfZNy8xZN/3UZa99b
         gBi/hCk9Ez4hXcPNWZoqUSLuZfR65/F0wJOozsea53VkjrQyDiOQRJ6hoMmcTjJssTAa
         N+CuZUsJ41JrU0ceHZQTEAimjkeDY+WMCTnQ5rEIfOjapa/h17stq/jRN+ZpdjBbOe6Q
         J+gknGLibsQT3/PbjyEg+++SftVQFNLLEFMjQhiQV7ZjlA8ti8HRhi7Mm5Hq5aoA3tTy
         VOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JO2UG45zb1kIWYsX/kWseGG+NIsyRhC1AMAZ+Pb5C80=;
        b=a3qrczwOpBuh2GpE5Zk1bqdi3B6Q5XpyrW4jgpx7JYYEnYVVvaO2qtjr0Jcez/e1gf
         I4NYCI6y7TEvK/bzbIaZ7hOhwmXDb5CEoC41HjYBEI5fXZwSFdsult6IkWoJh5VB5ui3
         ew2nHU1S2yd0assDynGDf1oPsle3pb19EWSUwljOqo4TD06CnN2Y5xaERFGkiibdJzvJ
         nGmuxrHempWliRZZK+j+NspiGpH0LSzYzu7rtJdh5x6UkIAbK3rSJyTMq4B5ZgEqGFVE
         KOXRqwy7wefHV3+rIFiRzXllL111iaIECoKEj47ymEtJGYpNJ+SFrDtpjQLL8wiXkcQz
         G6XA==
X-Gm-Message-State: APjAAAXU8SZ8L8sP6+opXf1tbnTdd21L64rvqyD3wCyQDxtrl9aKRj5T
        KXrj9PQUgVLcclAVGBwxhfIKmmg3
X-Google-Smtp-Source: APXvYqx21uPkITjTyRbGbZzmX4pkl/UmAyTSUAqISg5eghelLGyxwxWbQwQyzE5yFJTPqCB5Dt6lGQ==
X-Received: by 2002:a81:4c05:: with SMTP id z5mr25380108ywa.413.1558063390556;
        Thu, 16 May 2019 20:23:10 -0700 (PDT)
Received: from mail-yb1-f172.google.com (mail-yb1-f172.google.com. [209.85.219.172])
        by smtp.gmail.com with ESMTPSA id v144sm2314344ywv.15.2019.05.16.20.23.08
        for <netdev@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 20:23:09 -0700 (PDT)
Received: by mail-yb1-f172.google.com with SMTP id a13so2095415ybl.8
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 20:23:08 -0700 (PDT)
X-Received: by 2002:a25:1a45:: with SMTP id a66mr25990689yba.390.1558063388528;
 Thu, 16 May 2019 20:23:08 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com>
 <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com> <CABUuw67P+oZ+P4Ed4si5QB52aamhCKx80o47oU0jNjWzB6C3iw@mail.gmail.com>
In-Reply-To: <CABUuw67P+oZ+P4Ed4si5QB52aamhCKx80o47oU0jNjWzB6C3iw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Thu, 16 May 2019 23:22:32 -0400
X-Gmail-Original-Message-ID: <CA+FuTSdcik=QLc=XMjWSFWty=zEm6_0Q3xKMo=1zi2_zNjwjpw@mail.gmail.com>
Message-ID: <CA+FuTSdcik=QLc=XMjWSFWty=zEm6_0Q3xKMo=1zi2_zNjwjpw@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     Adam Urban <adam.urban@appleguru.org>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 16, 2019 at 8:27 PM Adam Urban <adam.urban@appleguru.org> wrote:
>
> And replying to your earlier comment about TTL, yes I think a TTL on
> arp_queues would be hugely helpful.
>
> In any environment where you are streaming time-sensitive UDP traffic,
> you really want the kernel to be tuned to immediately drop the
> outgoing packet if the destination isn't yet known/in the arp table
> already...

For packets that need to be sent immediately or not at all, you
probably do not want a TTL, but simply for the send call to fail
immediately with EAGAIN instead of queuing the packet for ARP
resolution at all. Which is approximated with unres_qlen 0.

The relation between unres_qlen_bytes, arp_queue and SO_SNDBUF is
pretty straightforward in principal. Packets can be queued on the arp
queue until the byte limit is reached. Any packets on this queue still
have their memory counted towards their socket send budget. If a
packet is queued that causes to exceed the threshold, older packets
are freed and dropped as needed. Calculating the exact numbers is not
as straightforward, as, for instance, skb->truesize is a kernel
implementation detail.

The simple solution is just to overprovision the socket SO_SNDBUF. If
there are few sockets in the system that perform this role, that seems
perfectly fine.

> Doesn't make sense to keep it around while it arps, since
> by the time it has an answer and gets it into the arp table, the UDP
> packet that it queued for sending while waiting on the arp reply is
> likely already out of date. (And if it doesn't get an answer, I
> definitely don't want it filling up buffers with useless/old packets!)
>
> On Thu, May 16, 2019 at 12:05 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
> >
> >
> >
> > On 5/16/19 7:47 AM, Willem de Bruijn wrote:
> > > On Wed, May 15, 2019 at 3:57 PM Adam Urban <adam.urban@appleguru.org> wrote:
> > >>
> > >> We have an application where we are use sendmsg() to send (lots of)
> > >> UDP packets to multiple destinations over a single socket, repeatedly,
> > >> and at a pretty constant rate using IPv4.
> > >>
> > >> In some cases, some of these destinations are no longer present on the
> > >> network, but we continue sending data to them anyways. The missing
> > >> devices are usually a temporary situation, but can last for
> > >> days/weeks/months.
> > >>
> > >> We are seeing an issue where packets sent even to destinations that
> > >> are present on the network are getting dropped while the kernel
> > >> performs arp updates.
> > >>
> > >> We see a -1 EAGAIN (Resource temporarily unavailable) return value
> > >> from the sendmsg() call when this is happening:
> > >>
> > >> sendmsg(72, {msg_name(16)={sa_family=AF_INET, sin_port=htons(1234),
> > >> sin_addr=inet_addr("10.1.2.3")}, msg_iov(1)=[{"\4\1"..., 96}],
> > >> msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 EAGAIN (Resource
> > >> temporarily unavailable)
> > >>
> > >> Looking at packet captures, during this time you see the kernel arping
> > >> for the devices that aren't on the network, timing out, arping again,
> > >> timing out, and then finally arping a 3rd time before setting the
> > >> INCOMPLETE state again (very briefly being in a FAILED state).
> > >>
> > >> "Good" packets don't start going out again until the 3rd timeout
> > >> happens, and then they go out for about 1s until the 3s delay from ARP
> > >> happens again.
> > >>
> > >> Interestingly, this isn't an all or nothing situation. With only a few
> > >> (2-3) devices missing, we don't run into this "blocking" situation and
> > >> data always goes out. But once 4 or more devices are missing, it
> > >> happens. Setting static ARP entries for the missing supplies, even if
> > >> they are bogus, resolves the issue, but of course results in packets
> > >> with a bogus destination going out on the wire instead of getting
> > >> dropped by the kernel.
> > >>
> > >> Can anyone explain why this is happening? I have tried tuning the
> > >> unres_qlen sysctl without effect and will next try to set the
> > >> MSG_DONTWAIT socket option to try and see if that helps. But I want to
> > >> make sure I understand what is going on.
> > >>
> > >> Are there any parameters we can tune so that UDP packets sent to
> > >> INCOMPLETE destinations are immediately dropped? What's the best way
> > >> to prevent a socket from being unavailable while arp operations are
> > >> happening (assuming arp is the cause)?
> > >
> > > Sounds like hitting SO_SNDBUF limit due to datagrams being held on the
> > > neighbor queue. Especially since the issue occurs only as the number
> > > of unreachable destinations exceeds some threshold. Does
> > > /proc/net/stat/ndisc_cache show unresolved_discards? Increasing
> > > unres_qlen may make matters only worse if more datagrams can get
> > > queued. See also the branch on NUD_INCOMPLETE in __neigh_event_send.
> > >
> >
> > We probably should add a ttl on arp queues.
> >
> > neigh_probe() could do that quite easily.
> >
