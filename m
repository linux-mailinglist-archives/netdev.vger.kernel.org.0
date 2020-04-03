Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 568DE19D94F
	for <lists+netdev@lfdr.de>; Fri,  3 Apr 2020 16:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403964AbgDCOks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 10:40:48 -0400
Received: from mail-vs1-f67.google.com ([209.85.217.67]:38057 "EHLO
        mail-vs1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728066AbgDCOks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Apr 2020 10:40:48 -0400
Received: by mail-vs1-f67.google.com with SMTP id x206so5069734vsx.5
        for <netdev@vger.kernel.org>; Fri, 03 Apr 2020 07:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=U/zCzhksdngaQjNZejGpm7ikceQ2KU0elB3t9jdP0r0=;
        b=M+aM2LriiqARtQ57HrbsWUEmaKILhHC+BzEygPYP25HcX47QGwUqmsCvNRL6Obr0P4
         y/BYioPBLQNKP9Dne33SY+NAl3zA6F4+/PIB0wyOOC9+XxZzxbkcodtw9YF0kTuQl0zb
         Y5vOBA436LrzWOs2VXeZEXWTUfv9KXLOli+Kv+SsEvTNS7M4m1f2xBdUfqL3Jx0HaFHx
         DjcF0fgpKy+iqkndtEpf/+ba3GPo9nBtw9HCJryk2q6Ba1xnAv9kDD6U4PbiP1JAwonQ
         8UxahXofc7oEknO2Z13NbiMJwdg5nrKKHdQiJg+uyDPVfb1+XW6SuGNC81h4imuwMFNE
         KfWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=U/zCzhksdngaQjNZejGpm7ikceQ2KU0elB3t9jdP0r0=;
        b=bGLFyJ8gEKQdeXhCVg1Y5S0JhSVLYeh0tkSR6EFIAzV5pzBFO6ytUZz1CUNrnAizsN
         yeoAY9vBEM7uWED8walgAwpw/tqiuyTNVut+qxbikRSMzWFDjSRZMY5A1i8qxvU5loLj
         n7INm1KQOHlD1CFSUFNa3hp47uYTE5CCi04Va3xQ/2st5eVJlC35nF0LxIqNzr0cB3Zg
         fh2D7s3BlfmSdjHHJAcNaGCTiGLz/J0T8TqEI1gCgbNdnvwUBKUrC4XKmEcDM6WBOzGZ
         7Yx7hWW32kW3/YjxpyNcQHckRljBlkWPUnNI5UusJ0oJDnTDUivJ93mrZTghIcxbiQtU
         TPhg==
X-Gm-Message-State: AGi0PubKIJ3eGcfPUuKm5zYD7DE5bunaRUoWxSJCOsK11gL/n67ltuFI
        dDVzeMW9cZhI1HL/Q0TrQXYIBTD+k/unpwjTOwvybA==
X-Google-Smtp-Source: APiQypInpy4bEUeCa0afV4DnzPnQsf7ozusAiw+/RPWGCPgzDlV5udQm9HHX2xu1rA9F4UEYTSZhYCc7XLW4xikot4E=
X-Received: by 2002:a05:6102:116d:: with SMTP id k13mr6332551vsg.79.1585924844920;
 Fri, 03 Apr 2020 07:40:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200326094252.157914-1-brambonne@google.com> <20200326.114550.2060060414897819387.davem@davemloft.net>
 <CABWXKLwamYiLhwUHsb5nZHnyZb4=6RrrdUg3CiX7CZOuVime7g@mail.gmail.com>
 <a50808d0-df80-4fbc-a0aa-5a3342067378@www.fastmail.com> <CABWXKLz-+wmhypzZGRMCtsWkGzg0-hj8qzjC2M=JYZXRWXFjEQ@mail.gmail.com>
 <55ad4be2-3b0d-4f2c-9020-d06dafab2b55@www.fastmail.com>
In-Reply-To: <55ad4be2-3b0d-4f2c-9020-d06dafab2b55@www.fastmail.com>
From:   =?UTF-8?Q?Bram_Bonn=C3=A9?= <brambonne@google.com>
Date:   Fri, 3 Apr 2020 16:40:31 +0200
Message-ID: <CABWXKLzCt5bbzjx4U29Hjm--j3eY4GCwNZLFr34CxxEp1qOGmQ@mail.gmail.com>
Subject: Re: [RFC PATCH] ipv6: Use dev_addr in stable-privacy address generation
To:     Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc:     David Miller <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, kuba@kernel.org,
        netdev@vger.kernel.org, Lorenzo Colitti <lorenzo@google.com>,
        Jeffrey Vander Stoep <jeffv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Hannes and David,

Thank you so much for working this through with me, and apologies for
the delayed response; I wanted to take some time to check my
assumptions with members from the Android team as well.

On Fri, Mar 27, 2020 at 9:52 PM Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> Okay, I understand. This is an additional scenario that wasn't on my
> radar so far. Is the MAC address randomized on the (E)SSID or the BSSID?
> I assume later as the ESSID might be stable across operators, but
> anyways that's just nit picking.

Connected MAC address randomization in Android is based on the ESSID
by default, to allow devices to roam across different access points
from the same operator using the MAC address as part of their
authentication. However, nothing prevents the user from changing their
MAC address over time, rather than per-SSID.

> In this scenario you would like to blind all unique identifiers on the
> network of a device in a "stable way". The MAC address is already
> blinded, thus it would be possible to just inherit it as the link local
> address, nothing seems to be lost then? Same for the globally scoped
> generated addresses stemming from this randomized MAC address?
>
> Using EUI-48 address generation mode here would give you the benefit of
> having no unique identifier (managed by the randomized mac address), a
> stable link-local address and global addresses per ESSID and not having
> to maintain the stable address generation secret. Seems to me to be the
> easiest way forward. I wonder what the implications regarding duplicate
> MAC address detection and thus IPv6 address selection are, but that's
> another topic.

I think this is an excellent proposal, and I agree with your
assessment that a randomized MAC address essentially acts as a
link-local address as far as privacy properties are concerned.
However, I think this proposal has a few drawbacks compared to using
regular IPv6 stable privacy addresses:

* Depending on whether the current network has MAC address
randomization enabled, the interface would have to be continuously
reconfigured to use either stable privacy address generation or
EUI-48.
* Repurposing EUI-48 here would require an additional step to ensure
that the generated address is unique (which is not an issue EUI-48
address generation has to deal with currently). David, is this what
you were hinting at in your message from 27 March as well?
* EUI-48-generated IPv6 addresses have fewer random bits than those
generated using the stable privacy method, as you mentioned.

> Additionally for the global scoped address generation I think it makes
> sense to still enable use_tempaddr=2, as it makes sure that for longer
> lasting associations to an AP new addresses are phased in and old ones
> are phased out regularly.

Agreed.

> If you like to keep the semantics of having ipv6 stable addresses as per
> spec, I would not object a patch adding a new mode like e.g.
> IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC (or some better name) on an
> interface and consequently using the admin-mac address. For me the sole
> benefit seems to be that the generated global addresses would
> additionally depend on the prefix announced by the operator in that
> particular network. This would only help if use_tempaddr=2 is not
> enabled or applications deliberately bind to a non temp addresses
> circumventing the source address selection.

If you're still OK with this, and if my aforementioned comments seem
reasonable to you, I will create a patch next week implementing this
proposal as a separate mode (IN6_ADDR_GEN_MODE_STABLE_PRIVACY_SOFTMAC
sounds good to me), and we can take it from there. I like that this
lets us adhere to the RFC, where this mode would allow us to
implicitly use the MAC address as both the Net_Iface and the
Network_ID parameter. If you have any other suggestions, please let me
know. Happy to incorporate any feedback you have.

> Off topic: does Android also deal with sockets that are still bound to
> old addresses, which potentially (I am not sure) generate packets that
> are black holed because of wrong source address but still recognizable
> by an network operator?

I will let Lorenzo (also on this thread) respond here, as he'll
certainly know more about this than I do.

Thank you once again for thinking this through with me, and for the
thorough explanation. And as always, please let me know if I
misunderstood anything.

Kind regards,
Bram
