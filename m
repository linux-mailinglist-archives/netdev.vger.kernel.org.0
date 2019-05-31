Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E993831136
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 17:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfEaPXr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 11:23:47 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38773 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEaPXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 11:23:47 -0400
Received: by mail-ed1-f65.google.com with SMTP id g13so15096054edu.5;
        Fri, 31 May 2019 08:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0/ovLauDCtIyBdqO9jHJhkEsV0yp4ngvTWZtWEi/FFQ=;
        b=CeIGVQtVdvzXlmkTPelOg36bvXkKOiS8Nj1+a9yS8LpAiEfVtwUFIQZiMeC6IqJiav
         YqBPOR9dchgSKF6zxFvzkYkZVsVMQi0QkrwiMNKMmcI+oqEEsHDfhPF8OkPjSUlgck5u
         0wAnGzz7M0ZTUkCcmfK37QoX0ZDLDav1fnASvdT9+EBLgocPFiAMZ5x/lhiPFRKoGZKn
         wckBMTjEeAyr/q3hVFM/wq0YsB3a+3B8kPw0Ry/3vuCuuLHmtUQiJuZ+nORbpf1+2JGv
         JIC5aT1nXhvgSXO3jRwHnNNVh+TRVIyY5P1ghNbrSGJDQZzewd0dCtDyIIL6sOIydWVv
         AcBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0/ovLauDCtIyBdqO9jHJhkEsV0yp4ngvTWZtWEi/FFQ=;
        b=pS2aTEXLxTqEchEEYjwsfhQiorBuulaictDgVjlPgV0WuClaedX+ZNywZU1kjG+3pf
         7/59PqoVXEdJkVKO/wQd1JBYlLbZLPWSoElw/5bG3LEVyovW1hGuoECWuBt+mbB9VkKe
         3Iyb2bqOwnmuCv+wAmY3JJUtwoWo8fuwPvpayatpvwlVZWnMoN/PlH6cwubYdIad5ffC
         zp3SBOJnIcU1NvGeUgL7i9DlIRgaQEUI5iM4IDHxZyJrgcoAVWzpKpyGsmrZyq7KuinA
         kIQtBOJrRjPgHwxtE099cNpMHd43ZFe/kJAjrouTSjuo/r4zEZjTgo5uHJ9FS4W7Zs/m
         hNPw==
X-Gm-Message-State: APjAAAUOYdc7Yf4uTuHmHqE2iv0wfOeMxe+i3oQglZi3bt4L/HSIjqj5
        UOrn2QYlaYH5vdDXBRPbNZq3+oJuujSISroVaFE=
X-Google-Smtp-Source: APXvYqw0OlbWL16oe54SUMdm6DbHmf40TMFdUctUiyiLCSycjO2k7rRXMRha3Or7kW/fXz2L6cAUOPsdVK71nNAvmIs=
X-Received: by 2002:a50:92a3:: with SMTP id k32mr12055185eda.123.1559316225574;
 Fri, 31 May 2019 08:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190530034555.wv35efen3igwwzjq@localhost> <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost> <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost> <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost> <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost> <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
 <20190531151151.k3a2wdf5f334qmqh@localhost>
In-Reply-To: <20190531151151.k3a2wdf5f334qmqh@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 31 May 2019 18:23:34 +0300
Message-ID: <CA+h21hpHKbTc8toPZf0iprW1b4v6ErnRaSM=C6vk-GCiXM8NvA@mail.gmail.com>
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

On Fri, 31 May 2019 at 18:11, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 05:27:15PM +0300, Vladimir Oltean wrote:
> > On Fri, 31 May 2019 at 17:08, Richard Cochran <richardcochran@gmail.com> wrote:
> > > This can be done simply using a data structure in the driver with an
> > > appropriate locking mechanism.  Then you don't have to worry which
> > > core the driver code runs on.
> > >
> >
> > Actually you do. DSA is special because it is not the first net device
> > in the RX path that processes the frames. Something needs to be done
> > on the master port.
>
> Before you said,
>
>         the switch in its great wisdom mangles bytes 01-1B-19-xx-xx-00
>         of the DMAC to place the switch id and source port there (a
>         rudimentary tagging mechanism).
>
> So why not simply save each frame in a per-switch/port data structure?
>

You mean to queue it and subvert DSA's own RX timestamping callback?
Why would I do that? Just so as not to introduce my .can_timestamp
callback?

> Now I'm starting to understand your series.  I think it can be done in
> simpler way...
>
> sja1105_rcv_meta_state_machine - can and should be at the driver level
> and not at the port level.
>

Can: yes. Should: why?

> sja1105_port_rxtstamp_work - isn't needed at all.
>
> How about this?
>
> 1. When the driver receives a deferred PTP frame, save it into a
>    per-switch,port slot at the driver (not port) level.
>
> 2. When the driver receives a META frame, match it to the
>    per-switch,port slot.  If there is a PTP frame in that slot, then
>    deliver it with the time stamp from the META frame.
>

One important aspect makes this need be a little bit more complicated:
reconstructing these RX timestamps.
You see, there is a mutex on the SPI bus, so in practice I do need the
sja1105_port_rxtstamp_work for exactly this purpose - to read the
timestamping clock over SPI.

> Thanks,
> Richard
