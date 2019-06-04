Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81ABD3414C
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 10:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfFDIN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 04:13:56 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41658 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfFDIN4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 04:13:56 -0400
Received: by mail-qt1-f195.google.com with SMTP id s57so5580411qte.8;
        Tue, 04 Jun 2019 01:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OlXBKw7HgP4DZult/XowRKn8oIkzj5I8Bd8HMNjnVco=;
        b=WM6UY//u3gKrc0uo6AsfF8nChVGhf0xjC7EpAbk4VMYXb4/+tNYkyOb+YzQp5QDF+F
         eATXSb0zT4e1tS4eHVzdmlE5htmqXImNh17u+QbK07ea8zHYXMfc93UVZD9mzC5lkgFf
         jW2YyBnearx5ncMLRsP6hmF4VtuyxzyJJTuHiEYTY4rjTctXn9T4FojidVlcmEbO+Czk
         KK2JY7zq6/hFcHFAk4At6DYq5ooPpxWGllOO6r4CyuS+0gAIIovda48sgtxPPWjB5B7W
         VhJcL99+Maezi626WOXoV0bAmEn2WArGh7xclwN9Rr5nyhNpkMi+fYWMGLUiFkvwvqk9
         ebOA==
X-Gm-Message-State: APjAAAUHRFZifjj64hotD1DGUzR/OQaMQ02RxR15vu9da26nwDX0TW9L
        AZyCatY999QurzjVJu5CvU59YVNFTrjc+vSH80c=
X-Google-Smtp-Source: APXvYqz5kir33J5AjmzplbKAfH30cVdEZ3sEoQzuyfFO20zuGZF8LYiKII1TI8KuvJglH3idinfKAhZ4lWT5LqRWGgc=
X-Received: by 2002:ac8:3ff5:: with SMTP id v50mr24492574qtk.142.1559636034539;
 Tue, 04 Jun 2019 01:13:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190531035348.7194-1-elder@linaro.org> <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org> <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org> <20190531233306.GB25597@minitux>
 <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org> <CAK8P3a0brT0zyZGNWiS2R0RMHHFF2JG=_ixQyvjhj3Ky39o0UA@mail.gmail.com>
 <040ce9cc-7173-d10a-a82c-5186d2fcd737@linaro.org>
In-Reply-To: <040ce9cc-7173-d10a-a82c-5186d2fcd737@linaro.org>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 4 Jun 2019 10:13:37 +0200
Message-ID: <CAK8P3a2U=RzfpVaAgRP1QwPhRpZiBNsG5qdWjzwG=tCKZefYHA@mail.gmail.com>
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
To:     Alex Elder <elder@linaro.org>
Cc:     Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Dan Williams <dcbw@redhat.com>,
        David Miller <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, abhishek.esse@gmail.com,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 3, 2019 at 3:32 PM Alex Elder <elder@linaro.org> wrote:
> On 6/3/19 5:04 AM, Arnd Bergmann wrote:
> > On Sat, Jun 1, 2019 at 1:59 AM Subash Abhinov Kasiviswanathan
> >
> > - What I'm worried about most here is the flow control handling on the
> >   transmit side. The IPA driver now uses the modern BQL method to
> >   control how much data gets submitted to the hardware at any time.
> >   The rmnet driver also uses flow control using the
> >   rmnet_map_command() function, that blocks tx on the higher
> >   level device when the remote side asks us to.
> >   I fear that doing flow control for a single physical device on two
> >   separate netdev instances is counterproductive and confuses
> >   both sides.
>
> I understand what you're saying here, and instinctively I think
> you're right.
>
> But BQL manages the *local* interface's ability to get rid of
> packets, whereas the QMAP flow control is initiated by the other
> end of the connection (the modem in this case).
>
> With multiplexing, it's possible that one of several logical
> devices on the modem side has exhausted a resource and must
> ask the source of the data on the host side to suspend the
> flow.  Meanwhile the other logical devices sharing the physical
> link might be fine, and should not be delayed by the first one.
>
> It is the multiplexing itself that confuses the BQL algorithm.
> The abstraction obscures the *real* rates at which individual
> logical connections are able to transmit data.

I would assume that the real rate constantly changes, at least
for wireless interfaces that are also shared with other users
on the same network. BQL is meant to deal with that, at least
when using a modern queuing algorithm.

> Even if the multiple logical interfaces implemented BQL, they
> would not get the feedback they need directly from the IPA
> driver, because transmitting over the physical interface might
> succeed even if the logical interface on the modem side can't
> handle more data.  So I think the flow control commands may be
> necessary, given multiplexing.

Can you describe what kind of multiplexing is actually going on?
I'm still unclear about what we actually use multiple logical
interfaces for here, and how they relate to one another.

> The rmnet driver could use BQL, and could return NETDEV_TX_BUSY
> for a logical interface when its TX flow has been stopped by a
> QMAP command.  That way the feedback for BQL on the logical
> interfaces would be provided in the right place.
>
> I have no good intuition about the interaction between
> two layered BQL managed queues though.

Returning NETDEV_TX_BUSY is usually a bad idea as that
leads to unnecessary frame drop.

I do think that using BQL and the QMAP flow command on
the /same/ device would be best, as that throttles the connection
when either of the two algorithms wants us to slow down.

The question is mainly which of the two devices that should be.
Doing it in the ipa driver is probably easier to implement here,
but ideally I think we'd only have a single queue visible to the
network stack, if we can come up with a way to do that.

> > - I was a little confused by the location of the rmnet driver in
> >   drivers/net/ethernet/... More conventionally, I think as a protocol
> >   handler it should go into net/qmap/, with the ipa driver going
> >   into drivers/net/qmap/ipa/, similar to what we have fo ethernet,
> >   wireless, ppp, appletalk, etc.
> >
> > - The rx_handler uses gro_cells, which as I understand is meant
> >   for generic tunnelling setups and takes another loop through
> >   NAPI to aggregate data from multiple queues, but in case of
> >   IPA's single-queue receive calling gro directly would be simpler
> >   and more efficient.
>
> I have been planning to investigate some of the generic GRO
> stuff for IPA but was going to wait on that until the basic
> code was upstream.

That's ok, that part can easily be changed after the fact, as it
does not impact the user interface or the general design.

> >   From the overall design and the rmnet Kconfig description, it
> >   appears as though the intention as that rmnet could be a
> >   generic wrapper on top of any device, but from the
> >   implementation it seems that IPA is not actually usable that
> >   way and would always go through IPA.
>
> As far as I know *nothing* upstream currently uses rmnet; the
> IPA driver will be the first, but as Bjorn said others seem to
> be on the way.  I'm not sure what you mean by "IPA is not
> usable that way."  Currently the IPA driver assumes a fixed
> configuration, and that configuration assumes the use of QMAP,
> and therefore assumes the rmnet driver is layered above it.
> That doesn't preclude rmnet from using a different back end.

Yes, that's what I meant above: IPA can only be used through
rmnet (I wrote "through IPA", sorry for the typo), but cannot be
used by itself.

       Arnd
