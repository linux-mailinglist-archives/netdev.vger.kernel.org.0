Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AF3631473
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 20:12:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbfEaSMQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 14:12:16 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46374 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726638AbfEaSMQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 14:12:16 -0400
Received: by mail-ed1-f68.google.com with SMTP id h10so365661edi.13;
        Fri, 31 May 2019 11:12:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrIShjfSxGVT757Xsm3x/4ZEg8b0wChy310aBAra+AI=;
        b=MrXdRVTio+B5pALqrLzQaClKZjUd/GeBNi5K9/Jfn/Ea7hhy5kJtUDqOkJlBUTyC7Q
         uQCM5tFUy9Qs+UiIsTTwD6xfeZoLvC2KSbloV2TWKsSZ42kzD+hC55bE3x98ndEbPzAo
         d5bbOcFSz4BKbmVK9uwITISYN5oYp8x/yq8uJF+bczqSgR4XJjsmitbyynaV856GXrlm
         vZVbcegnkHvg3++hrz5PAm9d/vzPOcZFyQiovH1fzMCDgWoBtmSXHJSbZyD/G4era+0+
         0SR1t5oXt1as7RLewFKM75I1rV+GU8T34DtSe7mBmJMkzXot/rsbIBcePzsOTJT1NbPv
         DsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrIShjfSxGVT757Xsm3x/4ZEg8b0wChy310aBAra+AI=;
        b=h0mp9EsRkDocnABeRgQ+4zqGu7tPFSyFP6xhqt6DaWlobFLDo6LGTYy3qztjLSV+W/
         zHDKsi9S445A0fv7GLQ0swpWU2hz3xTlxXmLcQeggRIAFaT6acWNS0aJ/wCnHKhtWfDH
         6D8XGEElikTs/UVNb5z12XMx0wBwEfq1OH69nQyTDoXBXzoHsFF6W1STbJYSNJwZFZvZ
         N616g4kQUhj1UODRf44xmXrCdWaPNsyAfJSKQNvWd2dHH++dV3HzE7NRkRA1YadvJ7wG
         rob6W6Cx6pwBSn0zcVch3chBfPW03bpWT+jwOAhspY0yejiM63WCysc2kfh02yKZ9Tgt
         rJRw==
X-Gm-Message-State: APjAAAVYDUnPESqjcsmaNV+I8NvsuYxRtYmYYJJoZh0eLeJdhEx0mobP
        Xo/19kkqzKNX4h58ySM5Y+K0YZi2Mwti7APFh1g=
X-Google-Smtp-Source: APXvYqykhwjqUioDCu0cqe39CqYT8A9qm9cvsCdP89/hmjOyKew9Gi6mfkKjUSgty6i8E0kwpshCSgmJ31p2pa1miQI=
X-Received: by 2002:a17:906:4b12:: with SMTP id y18mr10514712eju.32.1559326334401;
 Fri, 31 May 2019 11:12:14 -0700 (PDT)
MIME-Version: 1.0
References: <20190530143037.iky5kk3h4ssmec3f@localhost> <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost> <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost> <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost> <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost> <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
 <20190531160909.jh43saqvichukv7p@localhost> <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
In-Reply-To: <CA+h21hpVrVNJTFj4DHHV+zphs2MjyRO-XZsM3D-STra+BYYHtw@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 31 May 2019 21:12:03 +0300
Message-ID: <CA+h21houLC7TGJYQ28LxiUxyBE7ju2ZiRcUd41aGo_=uAhgVgQ@mail.gmail.com>
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

On Fri, 31 May 2019 at 19:16, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> On Fri, 31 May 2019 at 19:09, Richard Cochran <richardcochran@gmail.com> wrote:
> >
> > On Fri, May 31, 2019 at 06:23:34PM +0300, Vladimir Oltean wrote:
> > > You mean to queue it and subvert DSA's own RX timestamping callback?
> >
> > No, use the callback.
> >
> > > Why would I do that? Just so as not to introduce my .can_timestamp
> > > callback?
> >
> > Right, the .can_timestamp is unneeded, AFAICT.
> >
> > > > Now I'm starting to understand your series.  I think it can be done in
> > > > simpler way...
> > > >
> > > > sja1105_rcv_meta_state_machine - can and should be at the driver level
> > > > and not at the port level.
> > > >
> > >
> > > Can: yes. Should: why?
> >
> > To keep it simple and robust.
> >
> > > One important aspect makes this need be a little bit more complicated:
> > > reconstructing these RX timestamps.
> > > You see, there is a mutex on the SPI bus, so in practice I do need the
> > > sja1105_port_rxtstamp_work for exactly this purpose - to read the
> > > timestamping clock over SPI.
> >
> > Sure.  But you schedule the work after a META frame.  And no busy
> > waiting is needed.
>
> Ok, I suppose this could work.
> But now comes the question on what to do on error cases - the meta
> frame didn't arrive. Should I just drop the skb waiting for it? Right
> now I "goto rcv_anyway" - which linuxptp doesn't like btw.
>

Actually I've been there before, just forgot it.
It won't work unless I make changes to dsa_switch_rcv.
Right now taggers can only return a pointer to the skb, or NULL, case
in which DSA will free it.
I'd need a mechanism to signal DSA that I'm holding up the skb for a
little bit more time, then re-engage the dsa_switch_rcv path once the
meta frame arrived.

> >
> > Thanks,
> > Richard
