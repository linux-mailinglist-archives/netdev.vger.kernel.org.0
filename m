Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB8082ADC40
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:40:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbgKJQku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:40:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726428AbgKJQku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:40:50 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC19C0613CF;
        Tue, 10 Nov 2020 08:40:49 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id q3so13433407edr.12;
        Tue, 10 Nov 2020 08:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=PAzk+IiLL4VQjNt2BB7c63LWPbJqcncXd/BODP2uNlY=;
        b=EzybYMlxks8I06e/D6L/W7lnoHnkHMoWpLen7cQgIzBRbacjScramSHF7joGsZd5jo
         6AQS019x0EviK/NiW4Lft3l57lRje2tI6H31dfF372AJwCh3K75qUEml3F23bxk2NhVX
         84T8RMjYSII9rK7wH1Cy/fKWM6RiGLGO677DJzBfbZputEs/rJ89mZr6w37BtKeh7jRM
         m8Y6AEMvLJWh4ws5tG2ajxQDpIwop/dYaYUGJpKj4463tGgT5xlcDb9lYX2K2F44dYpc
         MjMZSAeItewGECbUfSsYoh99ngY5vR+k3+CNbZ+y/10yO+mWdsQrEGwy03cn/9F/iHlk
         8SDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=PAzk+IiLL4VQjNt2BB7c63LWPbJqcncXd/BODP2uNlY=;
        b=gGx7m9UJWX9vl6tXp4LNIAE2fDwAJd7gNWgsoKStFi6AZJg3zHmFeVPneGvcWn44bw
         PZ95LXDXn95fqL+OsSshFJNyQLbQi0EZ3s6n9EJG4nIy+d+OjkDBc84I91WGu3fIKAbd
         txFGpaFPuZi1lxsPUEXlIFMA0JVLqTjz1DmRnf/d1w4QNFHP0zJXsNNS0tsACyNsqSTk
         ApXfunFENMv94QBLW+pLN0kbHOzVRykic0v9eLf4zB2cds4+9V6RqMlgqLAioV5KCDwq
         oyPdNyLaGQ7GRM1bqV29nkWjUz+gXk/51MX5oDWz37d9PyKUXqK7NSuz0EdlzngtsbXa
         DMNA==
X-Gm-Message-State: AOAM533eBoRSFkLOnEXxISCSKYq4DbTvVk3JVgtj70oVM517mH0kl6vF
        YYAqzmIyZclcGB6zIlku+B8=
X-Google-Smtp-Source: ABdhPJzjsvTmVs6oEZps4wi8Qr3KYx16qUkXPkx3xhBsgYh8RbFoopYH78adSxSXFOSHfA2JdgyHDw==
X-Received: by 2002:aa7:df04:: with SMTP id c4mr21927833edy.25.1605026448429;
        Tue, 10 Nov 2020 08:40:48 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id p4sm10708944ejw.101.2020.11.10.08.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 08:40:47 -0800 (PST)
Date:   Tue, 10 Nov 2020 18:40:45 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 7/9] net: dsa: microchip: ksz9477: add
 hardware time stamping support
Message-ID: <20201110164045.jqdwvmz5lq4hg54l@skbuf>
References: <20201019172435.4416-1-ceggers@arri.de>
 <5844018.3araiXeC39@n95hx1g2>
 <20201110014234.b3qdmc2e74poawpz@skbuf>
 <1909178.Ky26jPeFT0@n95hx1g2>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1909178.Ky26jPeFT0@n95hx1g2>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 10, 2020 at 03:36:02PM +0100, Christian Eggers wrote:
> On Tuesday, 10 November 2020, 02:42:34 CET, Vladimir Oltean wrote:
> > Sorry for getting back late to you. It did not compute when I read your
> > email the first time around, then I let it sit for a while.
> >
> > On Thu, Nov 05, 2020 at 09:18:04PM +0100, Christian Eggers wrote:
> > > unfortunately I made a mistake when testing. Actually the timestamp *must*
> > > be moved from the correction field (negative) to the egress tail tag.
> > That doesn't sound very good at all.
> I think that is no drawback. It is implemented and works.

It works, but how?

The reason why I'm asking you is this. I can guess that this hardware
plays by a very simple song when performing one-step TX timestamping.

correctionField_New = correctionField_Old + (t_TX - t_Tail_Tag)

It does this because, as far as the hardware is concerned, it needs to
make no difference between event messages, be they Sync, Pdelay_Req or
Pdelay_Resp messages.

First, let's see if we agree what happens for a Sync.

          |                    |
       t1 |------\ Sync        |
          |       ------\      |
          |              ----->| t2
Master    |                    |     Slave
Clock     |                    |     Clock
          |                    |

When receiving the one-step Sync message, the Slave Clock must add the
correctionField to the originTimestamp in order to figure out what is
the t1 it should use. Usually, the correctionField would only be updated
by transparent clocks. But when using one-step TX timestamping, it is
not mandatory for master clocks to send the correctionField as zero
(something which is mandatory for two-step). So they don't.

Here's what the IEEE 1588 standard says:

-----------------------------[cut here]-----------------------------
9.5.9.3 One-step clocks
-----------------------

The originTimestamp field of the Sync message shall be an estimate no
worse than ±1 s of the <syncEventEgressTimestamp> excluding any
fractional nanoseconds.
-----------------------------[cut here]-----------------------------

In practice, the Master Clock will probably set the originTimestamp to
something more or less arbitrary by reading the current PTP time of the
NIC, then it will let the MAC rewrite the correctionField with the
precise t_TX (hardware TX timestamp) minus the value from the
originTimestamp field*.

*Actually parsing the packet at that rate, while also rewriting and
timestamping it, might be too tricky and too late, so the MAC, instead
of reading the originTimestamp from the actual Sync message, will
actually require you, the driver writer, to pass them the value of the
originTimestamp twice, this time also through the tail tag (or through
whatever other buffer metadata that hardware might use).

So this formula would do that job:

correctionField_New = correctionField_Old + (t_TX - t_Tail_Tag)

where t_TX is the MAC TX timestamp and t_Tail_Tag should be the
approximate originTimestamp of the Sync message.

I am fairly confident that this is how your hardware works, because
that's also how peer delay wants to be timestamped, it seems. It's just
that in the case of Pdelay_Resp, t_Tail_Tag must be set to t2 (the
precise timestamp of the Pdelay_Req), in order for the correctionField
for that Pdelay_Resp message to contain (t3 - t2):

          |                    |
       t1 |------\ Pdelay_Req  |
          |       ------\      |
          |              ----->| t2
Clock A   |                    |     Clock B
          | Pdelay_Resp /------| t3
          |       ------       |
       t4 |<-----/             |
          |                    |

You don't do any of that here. So what must be happening in your case is
that the originTimestamp for Sync messages is always zero, and the
correctionField provides the rest of t1, in its entirety. That's because
in your tagger, you also leave the t_Tail_Tag as zero for Sync messages
(you only touch it for peer delay). Is that ok? Well, on paper yes,
because 0 + t1 = t1 + 0 = t1 (either the correctionField or the
originTimestamp could be zero, and they would add up to the same
number), but in practice, the bit width of the originTimestamp is 64
bits, whereas the correctionField only has 48 bits for nanoseconds, the
lower 16 bits being for fixed point. So if you're going to keep your
entire t1 into the correctionField, then in practice your master clock
can only advertise a time that holds 48 bits worth of nanoseconds, i.e.
3 1/4 days worth of TAI starting with Jan 1st 1970.  Then it would wrap
around. So how come this is not what happens in your case? I don't see
you update the originTimestamp nor the t_Tail_Tag for Sync messages.

The arithmetic that is done on the correctionField should be simple
48-bit two's complement. It should not matter if the correctionField is
positive or negative. The only case I believe it would matter that the
correctionField is negative is if the arithmetic is not actually on 48
bit two's complement, but on the partial timestamps directly (i.e. 32
bit two's complement). What I'm saying is that this formula is probably
calculated in hardware in two steps:

correctionField_New = correctionField_Old + (t_TX - t_Tail_Tag)

Step 1:
t_tmp = t_TX (32 bits) - t_Tail_Tag (32 bits), using 32-bit two's complement arithmetic

Step 2:
correctionField_New (48 bits) = correctionField_Old (48 bits) + t_tmp (32 bits),
using 48-bit two's complement arithmetic, and where t_tmp is probably
treated as an unsigned integer that is zero-padded up to 48 bits

I am getting the feeling that there are still some things we're missing
in this series. I would not hurry to send a v2 until they're clear.

I hope that you're not testing PTP just between yourself and yourself.
It's really easy for bugs to cancel out.
