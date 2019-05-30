Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9164C2FEAE
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 16:57:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfE3O5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 10:57:43 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41539 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726065AbfE3O5m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 10:57:42 -0400
Received: by mail-ed1-f66.google.com with SMTP id y15so3573069edo.8;
        Thu, 30 May 2019 07:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gUcLhVuM4u8ThLlgb5AD/BxYretrvQweG0sh8Y6YVsQ=;
        b=ap3UfpQYhfSmX+EQxxFZ+Ou73eB0So1oqkh7kGnfO3ROYDmxqk8AJGTDTYaMT8Lk5+
         89eB/zKGk0Be9WjtaEX76sLZmDM2lVx983WR7sjnnXCCzlj6hjjV+DijOgNJRIx+WaUs
         250X4RBksnDnyT1DJ+PmPUrYqtPpCPA74QfJQRDyhMt8Jift6YD/s3YScFjcifvPQJ1h
         dsfDBsgkiBAUoflJCLhb1/YuZq6oDNWvJvOtqaKbQ2Dwvxgr/rpesdnp1Q7ibWfeQOOJ
         0Z+OcfWY0rkzemEnGjJ97tvwIz2d/7ORe9DNe8itb4Xn0TjSTcUmDvH+Qb25BLNiOSoy
         8YRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gUcLhVuM4u8ThLlgb5AD/BxYretrvQweG0sh8Y6YVsQ=;
        b=AejEfjXu4HW8r5guDqxl0QMiFeIY+iQoC3dCrM5ePaUzB8nBem+fDRTYX2YlSrK+OS
         mH8HrsE+cUQQm8yG1/wf+LPoE0VRQOSEBzuX7qzDa/MB7emrnlV+utoMEUvuMklSfJXP
         6pxBAdaMPQl27Xlnq9D0AWClhFy7C9XOGkFV5pHOosMLxejHWgsQUXi0lw4A3Zqxjgad
         fRDyfbjTI2IZLT/foufB7DyvSBIFOvbmNODRGcLBIJXfp7GwUWOaPHrXW5Vh8fGxpLnD
         cXuoZSTG8ugZCRhb0fLvoTMdoMpy0MrsadHCyGkPLBPuBQWtSZxEDJmXGXiu4iFYlkY+
         vnzQ==
X-Gm-Message-State: APjAAAUpKwJ4jLUePVtzv3YXtMywHj7mrRDoXxgwKD14SE9LEo9vvROV
        6yih7rgOmEjGRkSXcdwLKiYjYbVeXHmhiT6F62w=
X-Google-Smtp-Source: APXvYqw7zpObGQB3C2POA85DrkRu6dZnPLYfC0oGlSNSGn3E+DbA6SQ1FgUNoticBxJCGrQrET23jX26Bbmbi2WgUjw=
X-Received: by 2002:aa7:c402:: with SMTP id j2mr5159229edq.165.1559228261213;
 Thu, 30 May 2019 07:57:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com> <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com> <20190530143037.iky5kk3h4ssmec3f@localhost>
In-Reply-To: <20190530143037.iky5kk3h4ssmec3f@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 30 May 2019 17:57:30 +0300
Message-ID: <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 May 2019 at 17:30, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, May 30, 2019 at 12:01:23PM +0300, Vladimir Oltean wrote:
> > In fact that's why it doesn't work: because linuxptp adds ptp_dst_mac
> > (01-1B-19-00-00-00) and (01-80-C2-00-00-0E) to the MAC's multicast
> > filter, but the switch in its great wisdom mangles bytes
> > 01-1B-19-xx-xx-00 of the DMAC to place the switch id and source port
> > there (a rudimentary tagging mechanism). So the frames are no longer
> > accepted by this multicast MAC filter on the DSA master port unless
> > it's put in ALLMULTI or PROMISC.
>
> IOW, it is not linuxptp's choice to use these modes, but rather this
> is caused by a limitation of your device.
>

Didn't want to suggest otherwise. I'll see how I'm going to address that.

> > If the meta frames weren't associated with the correct link-local
> > frame, then the whole expect_meta -> SJA1105_STATE_META_ARRIVED
> > mechanism would go haywire, but it doesn't.
>
> Not necessarily.  If two frames that arrive at nearly the same time
> get their timestamps mixed up, that would be enough to break the time
> values but without breaking your state machine.
>

This doesn't exactly sound like the type of thing I can check for.
The RX and TX timestamps *are* monotonically increasing with time for
all frames when I'm printing them in the {rx,tx}tstamp callbacks.

> > I was actually thinking it has something to do with the fact that I
> > shouldn't apply frequency corrections on timestamps of PTP delay
> > messages. Does that make any sense?
>
> What do you mean by that?  Is the driver altering PTP message fields?

No.
The driver returns free-running timestamps altered with a timecounter
frequency set by adjfine and offset set by adjtime.
I was wondering out loud if there's any value in identifying delay
messages in order to not apply this frequency adjustment for their
timestamps.

-Vladimir

>
> Thanks,
> Richard
