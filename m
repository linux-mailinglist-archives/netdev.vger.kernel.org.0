Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 095AC903A1
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 16:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbfHPOGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 10:06:07 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:38286 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727252AbfHPOGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 10:06:06 -0400
Received: by mail-ed1-f67.google.com with SMTP id r12so5241691edo.5;
        Fri, 16 Aug 2019 07:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8e7Z0p2sBGPUJzObsUt4mu3Xwz8ikmNkfBbWkS9jRyE=;
        b=GpGPsFoXG+hpRJPpDXHOSYuzTkQZpccsp66KsUvo1dVVlRRtGqezako/96GoKG7N55
         zUBQzSlqlGrHt5p3B7u4sNgG4MLKgvsD0c8gCzPcoLRwtRbLsfmZ7RQVCRxuoaiF3kXe
         t7IMwYARFBCD8QhtHxBOs8qbsvfDVbNXvTVrMGrYc/23/hX7hMNjpR9AL1O9GxYVgjG+
         DgdAxPAlHlUHOji3mjWLHq8F5STxqTVq/0h+en6x/j6M3Qgl013DajZVsRr/nhx10Nki
         T9k0+QD2IeqhvwdFNdr3NCkRGrPf6t0nXTZenk090HdVK1ceGQxQ26vPtxhlMduBc6fM
         U/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8e7Z0p2sBGPUJzObsUt4mu3Xwz8ikmNkfBbWkS9jRyE=;
        b=FVOitc9g5INvMRywSCnDqNNYhS4YovoBfXelOY9f8rB/SL+o8VKkEfjc5CMuLtSWxi
         AEXP+OxJtXDG6OgUYFsqvGgZOSs2foD7sq+ZkPb3hJDH+f9XilurW53h0nRppgvAXBFd
         r5xiQRktwkrJEwXZhOSopEaeKznDqqvGyQWeJwSG68M9sPo4pLbaFX/mWrvEMJTzf1NT
         Gb5aupl2JDjct/l/cSRxof5A7G4U/qHR0500+aKWOUuPJCHW9y26FEQEqNV+G3pP6Stm
         ByBvwk20IOmZWmViq3avzRTxnKYrrqHTXQsQEIORD0JF2Q3X1lbF9sVezzWbApzu/sWJ
         FaBQ==
X-Gm-Message-State: APjAAAU8L+QdA4DvezKbUIXtJABT663TaymBkl46ncO9zepkWO5sH6J1
        AvXnBEqpVGxsQsMXyDUFL4KgTql3pqtAPSnmjqk=
X-Google-Smtp-Source: APXvYqxP6KpjVu8D9+MCbXjqKCqDIEjZp1N7n4Mku54AV4tX1b2vzYSgZgLaVi0qXD4JEb7g27IqtWJxee/DQ0JJW5Q=
X-Received: by 2002:a17:906:d298:: with SMTP id ay24mr9552094ejb.230.1565964364249;
 Fri, 16 Aug 2019 07:06:04 -0700 (PDT)
MIME-Version: 1.0
References: <20190816004449.10100-1-olteanv@gmail.com> <20190816004449.10100-4-olteanv@gmail.com>
 <20190816121837.GD4039@sirena.co.uk> <CA+h21hqatTeS2shV9QSiPzkjSeNj2Z4SOTrycffDjRHj=9s=nQ@mail.gmail.com>
 <20190816125820.GF4039@sirena.co.uk>
In-Reply-To: <20190816125820.GF4039@sirena.co.uk>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 16 Aug 2019 17:05:53 +0300
Message-ID: <CA+h21hrZbun_j+oABJFP+P+V3zHP2x0mAhv-1ocF38miCvZHew@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 03/11] spi: Add a PTP system timestamp to the
 transfer structure
To:     Mark Brown <broonie@kernel.org>
Cc:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        linux-spi@vger.kernel.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 16 Aug 2019 at 15:58, Mark Brown <broonie@kernel.org> wrote:
>
> On Fri, Aug 16, 2019 at 03:35:30PM +0300, Vladimir Oltean wrote:
> > On Fri, 16 Aug 2019 at 15:18, Mark Brown <broonie@kernel.org> wrote:
> > > On Fri, Aug 16, 2019 at 03:44:41AM +0300, Vladimir Oltean wrote:
>
> > > > @@ -842,6 +843,9 @@ struct spi_transfer {
> > > >
> > > >       u32             effective_speed_hz;
> > > >
> > > > +     struct ptp_system_timestamp *ptp_sts;
> > > > +     unsigned int    ptp_sts_word_offset;
> > > > +
>
> > > You've not documented these fields at all so it's not clear what the
> > > intended usage is.
>
> > Thanks for looking into this.
> > Indeed I didn't document them as the patch is part of a RFC and I
> > thought the purpose was more clear from the context (cover letter
> > etc).
> > If I do ever send a patchset for submission I will document the newly
> > introduced fields properly.
>
> The issue I'm having is that I have zero idea about the PTP API so I've
> got nothing to go on when thinking about if this approach makes any
> sense unless I go do some research.
>
> > So let me clarify:
> > The SPI slave device driver is populating these fields to indicate to
> > the controller driver that it wants word number @ptp_sts_word_offset
> > from the tx buffer snapshotted. The controller driver is supposed to
> > put the snapshot into the @ptp_sts field, which is a pointer to a
> > memory location under the control of the SPI slave device driver.
>
> Snapshot here basically meaning recording a timestamp?  This interface
> does seem like it basically precludes DMA based controllers from using
> it unless someone happened to implement some very specific stuff in
> hardware which seems implausible.  I'd be inclined to just require that
> users can only snapshot the first (and possibly also the last, though
> DMA completions make that fun) word of a transfer, we could then pull
> this out into the core a bit by providing a wrapper function drivers
> should call at the appropriate moment.
>

I'm not sure how to respond to this, because I don't know anything
about the timing of DMA transfers.
Maybe snapshotting DMA transfers the same way is not possible (if at
all). Maybe they are not exactly adequate for this sort of application
anyway. Maybe it depends.
But the switch I'm working on is issuing an internal read transaction
of the PTP timer exactly at the 4th-to-last bit of the 3rd byte. This
is so that it has time (4 SPI clock cycles, to be precise) for the
result of the read transaction to become available again to the SPI
block, for output. It is impossible to know exactly when the switch
will snapshot the time internally (because there are several clock
domain crossings from the SPI interface towards its core) but for
certain it takes place during the latter part of the 3rd SPI byte. I
believe other devices are similar in this regard.
In other words, from a purely performance perspective, I am against
limiting the API to just snapshotting the first and last byte. At this
level of "zoom", if I change the offset of the byte to anything other
than 3, the synchronization offset refuses to converge towards zero,
because the snapshot is incurring a constant offset that the servo
loop from userspace (phc2sys) can't compensate for.
Maybe the SPI master driver should just report what sort of
snapshotting capability it can offer, ranging from none (default
unless otherwise specified), to transfer-level (DMA style) or
byte-level.
I'm afraid more actual experimentation is needed with DMA-based
controllers to understand what can be expected from them, and as a
result, how the API should map around them.
MDIO bus controllers are in a similar situation (with Hubert's patch)
but at least there the frame size is fixed and I haven't heard of an
MDIO controller to use DMA.
I'm not really sure what the next step would be. In the other thread,
Richard Cochran mentioned something about a two-part write API,
although I didn't quite understand the idea behind it.


> > It is ok if the ptp_sts pointer is NULL (no need to check), because
> > the API for taking snapshots already checks for that.
> > At the moment there is yet no proposed mechanism for the SPI slave
> > driver to ensure that the controller will really act upon this
> > request. That would be really nice to have, since some SPI slave
> > devices are time-sensitive and warning early is a good way to prevent
> > unnecessary troubleshooting.
>
> Yes, that's one of the things I was thinking about looking at the series
> - we should at least be able to warn if we can't timestamp so nobody
> gets confused, possibly error out if the calling code particularly
> depends on it.

Regards,
-Vladimir
