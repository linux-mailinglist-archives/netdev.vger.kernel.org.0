Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FAF31022
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 16:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfEaO12 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 10:27:28 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:33301 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726418AbfEaO12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 10:27:28 -0400
Received: by mail-ed1-f66.google.com with SMTP id n17so14871973edb.0;
        Fri, 31 May 2019 07:27:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6UNAHPK4lxioobAoRT0BGcdwVsps1KJ7DZZuOajW11o=;
        b=mfpiwchZ+bgLDbE1e8JO0/GVcJgomLJqDptBY16xc1eBCHIV2EQybuV+y2mZiTKbBR
         HcnLEt8skfwuwZs9OlT3gAAj718u57nEtViwwgbVLNv/ohiiV+0EVEnecjgQbEof6AOl
         y2stmiNGs85OeqsLZ+DBrgPsqvA6G2SxBzSKRUzMjx9/8GdSkbZW2F66tpQc36H+PgAL
         CxLwnklncY4eUmZ6AkXZe8EmZV4TnWaDgerELea+KgqNadNDOD5wxS1THgnA62cuNLGr
         oA2hGXNjqkTJbswnxf8xxLkR2huiBxf5Aq5gzcejVBLzw5oCT26pT/TX++NVuLff/k84
         aDqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6UNAHPK4lxioobAoRT0BGcdwVsps1KJ7DZZuOajW11o=;
        b=gFQKR0+I59sDStQMrhPMWKdE21g6zhNC5AfAkp1Kkx0pJPWrHERb9GCvtSiv7QDMak
         60kTbrd/wcdoRQm5zoqDzsYoZ5XrT2gnn/YYiXOCeu6Av7XyeA8DiIOy9BRUB8jjVGnb
         tZIYCXJcgQN3es6IqB/grBA1q2L5/Q+LK/wfxBTGrU3T/MM7NHDzfCegk1jF1wjz+mVt
         uvnAr/xmYrh/2Jg01oz6EC0Mi1ZuvsmH0RscPf+PX5UMF3JjDEKTi7edqGnp6dn4e971
         IFARSs71Y4z2TtHlGmVcs+HcvvdHHAXebGC0t88qBLjlidEe12ZR/qsWdA9AqI6WZ5vg
         BBVQ==
X-Gm-Message-State: APjAAAUhXv6GmF2byk5N3ePjVedkBBnheVWc84c2DIAxqoi0+Cok1GPP
        EM8HVBJ2TIrdry8sbLZV43RAnzU3dWbN25Q9zCw=
X-Google-Smtp-Source: APXvYqzyD3X2JQXbWFIbYGfT0jLlLQh/OrIvjzKfXY8ufWrGQhEKlq8kd1Da5N/85EUdu19P7iNRb34Lo6wLYSf0668=
X-Received: by 2002:a17:906:4b12:: with SMTP id y18mr9397146eju.32.1559312846324;
 Fri, 31 May 2019 07:27:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190529045207.fzvhuu6d6jf5p65t@localhost> <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com>
 <20190530034555.wv35efen3igwwzjq@localhost> <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost> <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost> <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost> <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
 <20190531140841.j4f72rlojmaayqr5@localhost>
In-Reply-To: <20190531140841.j4f72rlojmaayqr5@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 31 May 2019 17:27:15 +0300
Message-ID: <CA+h21hroywaij3gyO0u6v+GFVO2Fv_dP_a+L3oMGpQH8mQgJ5g@mail.gmail.com>
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

On Fri, 31 May 2019 at 17:08, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Fri, May 31, 2019 at 04:23:24PM +0300, Vladimir Oltean wrote:
> > The switch has internal logic to not send any other frame to the CPU
> > between a link-local and a meta frame.
>
> So this is guarantied by the switch?  What happens when multiple PTP
> frames arrive at the same time on different ports?  Does the switch
> buffer them and ensure strict ordering at the CPU port?
>
> In any case, the switch's guarantee is an important fact to state
> clearly in your series!
>

Yes, ports with lower index take priority.

> > Hence, if the MAC of the DSA master drops some of these frames, it
> > does not "spoil any chance" except if, out of the sequence LL n ->
> > META n -> LL n+1 -> META n+1, it persistently drops only META n and LL
> > n+1.
>
> LL = link layer?
>

Yes, link-local in this case means trapped frames in the
01-80-C2-xx-xx-xx or 01:1B:C9:xx:xx:xx space.

> > So I'd like to re-state the problem towards what should be done to
> > prevent LL and META frames getting reordered in the DSA master driver
> > on multi-queue/multi-core systems.
>
> Ok.
>
> > At the most basic level, there
> > should exist a rule that makes only a single core process these
> > frames.
>
> This can be done simply using a data structure in the driver with an
> appropriate locking mechanism.  Then you don't have to worry which
> core the driver code runs on.
>

Actually you do. DSA is special because it is not the first net device
in the RX path that processes the frames. Something needs to be done
on the master port.

> Thanks,
> Richard
