Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4862E5504F
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 15:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729403AbfFYN1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 09:27:07 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:41316 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbfFYN1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 09:27:07 -0400
Received: by mail-io1-f68.google.com with SMTP id w25so2317290ioc.8
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 06:27:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Zv7Xrp3RDQyK8vV4GaEsgDM8ZAX0HpEWqpywwsMBro=;
        b=XDErJH2rO4D6OZe8UgTZIJCLTi/cTyIzhYvzLT8/2FAvZqf1MaKC3tvKOuDnWza49G
         g6gbFDzyqol/K8M/IJK5emSlGGjMhlVSnHtRRqmiVNQ3m69pcyV/QNs+JQLzJt0lo+Kk
         Nu7nkYGvJm40IUwB1bwdSLs7mqjZQnS8tVoQeDwXpQjVeb7lGzYxFB4UDHYo77ZWws2k
         dfWCmIk8Ve5qqO0E36YUlG6th+jy8+SwzxrtqDzhevc3f3msf51G5N8oxWCjuBzeRs3A
         9Dk/Yrk1ExKZxO3mrfgzmWCtKZ2rHjqiaHt4c7PrZO11dh+onr99KpdvPOPUZnAEbwL5
         q3eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Zv7Xrp3RDQyK8vV4GaEsgDM8ZAX0HpEWqpywwsMBro=;
        b=UCYr4xbFWzJNA8ezzoxM7eahisPi16woIXeNSFn8YBGmKW3Ed9Wgg5WjRLoeWUZ8xJ
         RZW2TMiZ4Wddlvg7JrP9kYtfGi7A15kDS4my2kqr9TkMcNSm7HZaIVbwW2B4ml+R/3qQ
         KWCtUBerJ8qxlY2jYhOJICFo6WX7Sc66iXZXbH+TJcnXmmkNFQ6nnAhxB2WMhpV3rTK/
         qa2Ktq7L7jIqkzECNyMEbv+v250LQD0n3ihicDLFKaJ8w9x6V4BePMf0GJqYdsUxQyGn
         9kkuS6gIfUIkLrTPhkm0zd6Yv4xl9Y3wRHjhMEm5ile78rGbmHZV94Zt+yNoeB6zULjg
         C8vQ==
X-Gm-Message-State: APjAAAXQa8Psy6EOwR6iyMU5FdBLJhzLGNBk0qUb534NJtah+8ODqEh0
        hBNM/ypJqDbxcJSe1ZjwEWJsQsY2E39PNu0Xrx7N9Q==
X-Google-Smtp-Source: APXvYqy3uDjYmwbQNqTwfjUW0k0ZnzJNoVhVNlmgUNuBLMZM2NEwUmegXIyzuQBxfjuB97Hgw8wrIwM3QlKCJuBJznM=
X-Received: by 2002:a02:600c:: with SMTP id i12mr18512771jac.108.1561469226441;
 Tue, 25 Jun 2019 06:27:06 -0700 (PDT)
MIME-Version: 1.0
References: <1561414416-29732-1-git-send-email-john.hurley@netronome.com> <108a6e4b-379c-ba43-5de0-27e31ade3470@mojatatu.com>
In-Reply-To: <108a6e4b-379c-ba43-5de0-27e31ade3470@mojatatu.com>
From:   John Hurley <john.hurley@netronome.com>
Date:   Tue, 25 Jun 2019 14:26:55 +0100
Message-ID: <CAK+XE=mtkJV2vYT0kH2Rp1x0EObSSbJD2gAppW=dTxi82WLC+Q@mail.gmail.com>
Subject: Re: [PATCH net-next 0/2] Track recursive calls in TC act_mirred
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Simon Horman <simon.horman@netronome.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        oss-drivers@netronome.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 25, 2019 at 12:18 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2019-06-24 6:13 p.m., John Hurley wrote:
> > These patches aim to prevent act_mirred causing stack overflow events from
> > recursively calling packet xmit or receive functions. Such events can
> > occur with poor TC configuration that causes packets to travel in loops
> > within the system.
> >
> > Florian Westphal advises that a recursion crash and packets looping are
> > separate issues and should be treated as such. David Miller futher points
> > out that pcpu counters cannot track the precise skb context required to
> > detect loops. Hence these patches are not aimed at detecting packet loops,
> > rather, preventing stack flows arising from such loops.
>
> Sigh. So we are still trying to save 2 bits?
> John, you said ovs has introduced a similar loop handling code;
> Is their approach similar to this? Bigger question: Is this approach
> "good enough"?
>

Hi Jamal.
Yes, OvS implements a similar approach to prevent recursion:
https://elixir.bootlin.com/linux/v5.2-rc6/source/net/openvswitch/actions.c#L1530

It was discussed on a previous thread that there are really 2 issues
here (even if it is the same thing that triggers them).
Firstly, the infinite looping of packets caused by poor config and,
secondly, the kernel panic caused by a stack overflow due to the
recursion in use.
These patches target the latter.
I think this approach is good enough to deal with the crashes as it
tracks a packets recursive calls (through act_mirred) on the network
stack.
If the packet is scheduled and releases the CPU then the counter is reset.
The packet may still loop but it will not cause stack overflows.


> Not to put more work for you, but one suggestion is to use skb metadata
> approach which is performance unfriendly (could be argued to more
> correct).
>
> Also: Please consider submitting a test case or two for tdc.
>
> cheers,
> jamal
>
