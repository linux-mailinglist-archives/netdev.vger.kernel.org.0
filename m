Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8712721144
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 02:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726910AbfEQA1U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 20:27:20 -0400
Received: from mail-qt1-f182.google.com ([209.85.160.182]:33026 "EHLO
        mail-qt1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfEQA1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 20:27:20 -0400
Received: by mail-qt1-f182.google.com with SMTP id m32so6205954qtf.0
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 17:27:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=appleguru.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5LvSWvIhQBMtK4j72u8v/YdanC6cFnSPv5nQ9F/C5bw=;
        b=ONY0aQP1u+kD352LUmxuEeiD+UHGrqJLIINor4xW8jiCRY4FbJherjod7t+kaAWjV7
         DpwzmRPruet3r3KlPdtyAtX8sMrWvfHMoIMmL/I3rV3Wr7ViKNGbqk+uJ5P+iH55Lp/5
         0BzrZFC1EoQ4NE2BylNCMYXFXjPNXJb19nbQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5LvSWvIhQBMtK4j72u8v/YdanC6cFnSPv5nQ9F/C5bw=;
        b=MQXpaVLGRusLUOAUZ2izZ1bx69gJNb7t1raMF5FwvzhSNF4TvUCOmA3uVdWkTYmRNG
         dgpyzw23pDbVIG1sYKRWKoHggDNb7igOpDN03VJX7VxjvsokMcTdQEHaMBM4oPvTHC2g
         psgi9wqACCM3mOt1hmfiCrXxl/96vEm0uveYFviju3dgCxvK0HCy9ksUEv+n+f7JoY0e
         VvkmblxiH+6EjRgWI8PsdHKK75EGD9MSGF92xGdUC5auQzHvIBdpp8v0b6ygeQ+5NOOu
         /ejX59tjNE0iPt7LO0z381qQrEY+lHjM3yOtcBXTGOiN4HUFhEiSGS0zMfO1s3iJIa9e
         n/ng==
X-Gm-Message-State: APjAAAXvvRFHinRh8PlRpL3/STXuw1qqdugXPhxahCkuv95W8bG057Gs
        TjbvW5Xt07l3kzKXe6T0FdhRVu/gl7U+eQ==
X-Google-Smtp-Source: APXvYqwHKn0GT0lB7xE/j9z3ZtmNznqwKKwjAIhhO6Xh+BWBUnWWVpzAPuaTSAV083+6CmhZGBTvKQ==
X-Received: by 2002:a0c:997d:: with SMTP id i58mr30655936qvd.84.1558052838812;
        Thu, 16 May 2019 17:27:18 -0700 (PDT)
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com. [209.85.160.172])
        by smtp.gmail.com with ESMTPSA id l40sm4985522qtc.32.2019.05.16.17.27.17
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 17:27:17 -0700 (PDT)
Received: by mail-qt1-f172.google.com with SMTP id z19so6079193qtz.13
        for <netdev@vger.kernel.org>; Thu, 16 May 2019 17:27:17 -0700 (PDT)
X-Received: by 2002:a0c:9acb:: with SMTP id k11mr23054063qvf.85.1558052837572;
 Thu, 16 May 2019 17:27:17 -0700 (PDT)
MIME-Version: 1.0
References: <CABUuw65R3or9HeHsMT_isVx1f-7B6eCPPdr+bNR6f6wbKPnHOQ@mail.gmail.com>
 <CAF=yD-Kdb4UrgzOJmeEhiqmeKndb9-X5WwttR-X4xd5m7DE5Dw@mail.gmail.com> <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
In-Reply-To: <0d50023e-0a3b-b92b-59d6-39d0c02fa182@gmail.com>
From:   Adam Urban <adam.urban@appleguru.org>
Date:   Thu, 16 May 2019 20:27:06 -0400
X-Gmail-Original-Message-ID: <CABUuw67P+oZ+P4Ed4si5QB52aamhCKx80o47oU0jNjWzB6C3iw@mail.gmail.com>
Message-ID: <CABUuw67P+oZ+P4Ed4si5QB52aamhCKx80o47oU0jNjWzB6C3iw@mail.gmail.com>
Subject: Re: Kernel UDP behavior with missing destinations
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

And replying to your earlier comment about TTL, yes I think a TTL on
arp_queues would be hugely helpful.

In any environment where you are streaming time-sensitive UDP traffic,
you really want the kernel to be tuned to immediately drop the
outgoing packet if the destination isn't yet known/in the arp table
already... Doesn't make sense to keep it around while it arps, since
by the time it has an answer and gets it into the arp table, the UDP
packet that it queued for sending while waiting on the arp reply is
likely already out of date. (And if it doesn't get an answer, I
definitely don't want it filling up buffers with useless/old packets!)

On Thu, May 16, 2019 at 12:05 PM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
>
>
> On 5/16/19 7:47 AM, Willem de Bruijn wrote:
> > On Wed, May 15, 2019 at 3:57 PM Adam Urban <adam.urban@appleguru.org> wrote:
> >>
> >> We have an application where we are use sendmsg() to send (lots of)
> >> UDP packets to multiple destinations over a single socket, repeatedly,
> >> and at a pretty constant rate using IPv4.
> >>
> >> In some cases, some of these destinations are no longer present on the
> >> network, but we continue sending data to them anyways. The missing
> >> devices are usually a temporary situation, but can last for
> >> days/weeks/months.
> >>
> >> We are seeing an issue where packets sent even to destinations that
> >> are present on the network are getting dropped while the kernel
> >> performs arp updates.
> >>
> >> We see a -1 EAGAIN (Resource temporarily unavailable) return value
> >> from the sendmsg() call when this is happening:
> >>
> >> sendmsg(72, {msg_name(16)={sa_family=AF_INET, sin_port=htons(1234),
> >> sin_addr=inet_addr("10.1.2.3")}, msg_iov(1)=[{"\4\1"..., 96}],
> >> msg_controllen=0, msg_flags=0}, MSG_NOSIGNAL) = -1 EAGAIN (Resource
> >> temporarily unavailable)
> >>
> >> Looking at packet captures, during this time you see the kernel arping
> >> for the devices that aren't on the network, timing out, arping again,
> >> timing out, and then finally arping a 3rd time before setting the
> >> INCOMPLETE state again (very briefly being in a FAILED state).
> >>
> >> "Good" packets don't start going out again until the 3rd timeout
> >> happens, and then they go out for about 1s until the 3s delay from ARP
> >> happens again.
> >>
> >> Interestingly, this isn't an all or nothing situation. With only a few
> >> (2-3) devices missing, we don't run into this "blocking" situation and
> >> data always goes out. But once 4 or more devices are missing, it
> >> happens. Setting static ARP entries for the missing supplies, even if
> >> they are bogus, resolves the issue, but of course results in packets
> >> with a bogus destination going out on the wire instead of getting
> >> dropped by the kernel.
> >>
> >> Can anyone explain why this is happening? I have tried tuning the
> >> unres_qlen sysctl without effect and will next try to set the
> >> MSG_DONTWAIT socket option to try and see if that helps. But I want to
> >> make sure I understand what is going on.
> >>
> >> Are there any parameters we can tune so that UDP packets sent to
> >> INCOMPLETE destinations are immediately dropped? What's the best way
> >> to prevent a socket from being unavailable while arp operations are
> >> happening (assuming arp is the cause)?
> >
> > Sounds like hitting SO_SNDBUF limit due to datagrams being held on the
> > neighbor queue. Especially since the issue occurs only as the number
> > of unreachable destinations exceeds some threshold. Does
> > /proc/net/stat/ndisc_cache show unresolved_discards? Increasing
> > unres_qlen may make matters only worse if more datagrams can get
> > queued. See also the branch on NUD_INCOMPLETE in __neigh_event_send.
> >
>
> We probably should add a ttl on arp queues.
>
> neigh_probe() could do that quite easily.
>
