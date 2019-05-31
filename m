Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC5DE30EC6
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 15:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfEaNXh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 09:23:37 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:37409 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbfEaNXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 09:23:37 -0400
Received: by mail-ed1-f68.google.com with SMTP id w37so14543868edw.4;
        Fri, 31 May 2019 06:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EsB/RmjAYgDdW2zn1umfyAGb1C0nPPgFCzeHw85tmA8=;
        b=jZqeYbVh7g1KBV63TeWP0D7Njhp8thY4SV1wQQw4KCzAZGkyx0JbCDAjtA/8cB65v9
         JjSb0qmBbsz7vyd5s2coT0KEs7KVPpGPrAWgQszo4cPBdv0+xdcoIvEJg28WiyQEa7XQ
         rdHS2NjCiRPRkaS4tZEi3aI1rMrFX3183nRCNl6SLkVVLRZD2296PtCJWlfiejVW02UK
         U0eVdjqm7/VMMBNZXEvc29HCK23lBr+xoVFAqp0l9YziXnyiHf46a8m2pmCmskY6bxei
         kQ3LmLyHhmnJH/hwyzDBOIJboQJW5aGnfONNxZMCSBfMo1koIMDA6CbZXCgVA940qA9F
         65sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EsB/RmjAYgDdW2zn1umfyAGb1C0nPPgFCzeHw85tmA8=;
        b=lhZt79t5pfY4yquWFC5KHkD5KP7nPw5xHQgmLSb0KNHMDLw8EFkvTJAMywTVFB49a4
         auDpklmRgkmS4sc/kywiqucD6rHEklxoTHHAePM5ONJkk+n5yYHFQ6aM3LYG2eCZ4z73
         XHRuf3SiBliwmvx3ak5z1pOlB1ZjDUIUNYEQ2ablgXInQ/rvDQrgeAzI1nTdb9eY/EF9
         Jr6RGMObGiGwbr1w5U1KQzQgoU4NCMk/VNwCqSEiOup3DV9DADuKA19d/McETUP4OiJR
         2sSFg+LWE2OnNWNn2SljBxTcLdWnnRY6nQ0adxK2nMGVQarZmfmxER7rUQjrkZdP6dL/
         ONsg==
X-Gm-Message-State: APjAAAUEB0SafNwM1G+JuVpCXIM+vCup6IntJ2uw+7oQ0h7mt77PGCTV
        oLQVnMZgb4zkgRnwZ+Ndmd1EarKvwN8oCgS/JIE=
X-Google-Smtp-Source: APXvYqxkD9sCI6fWIijRdaYeTF017tYfKWpLu2uuXRLqUmusVUFWsVVg2i3NOSazKu+kpp6Uh3pRx+u3Be3b9sMRkKw=
X-Received: by 2002:a50:fd0a:: with SMTP id i10mr11144161eds.117.1559309015649;
 Fri, 31 May 2019 06:23:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190528235627.1315-1-olteanv@gmail.com> <20190529045207.fzvhuu6d6jf5p65t@localhost>
 <dbe0a38f-8b48-06dd-cc2c-676e92ba0e74@gmail.com> <20190530034555.wv35efen3igwwzjq@localhost>
 <CA+h21hpjsC=ie5G7Gx3EcPpazyxze6X_k+8eC+vw7JBvEO2zNg@mail.gmail.com>
 <20190530143037.iky5kk3h4ssmec3f@localhost> <CA+h21hpp68AEEykxr8bJB=uJ+b0tg881Z7Ao_OfbTAXNxS8WgQ@mail.gmail.com>
 <20190530150557.iur7fruhyf5bs3qw@localhost> <CA+h21hrBwR4Sow7q0_rS1u2md1M4bSAJt8FO5+VLFiu9UGnvjA@mail.gmail.com>
 <20190531043417.6phscbpmo6krvxam@localhost>
In-Reply-To: <20190531043417.6phscbpmo6krvxam@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 31 May 2019 16:23:24 +0300
Message-ID: <CA+h21hp9DfW3wFy4YbHMU31rBHyrnUTdF4kKwX36h9vHOW2COw@mail.gmail.com>
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

On Fri, 31 May 2019 at 07:34, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, May 30, 2019 at 06:23:09PM +0300, Vladimir Oltean wrote:
> > On Thu, 30 May 2019 at 18:06, Richard Cochran <richardcochran@gmail.com> wrote:
> > >
> > > But are the frames received in the same order?  What happens your MAC
> > > drops a frame?
> > >
> >
> > If it drops a normal frame, it carries on.
> > If it drops a meta frame, it prints "Expected meta frame", resets the
> > state machine and carries on.
> > If it drops a timestampable frame, it prints "Unexpected meta frame",
> > resets the state machine and carries on.
>
> What I meant was, consider how dropped frames in the MAC will spoil
> any chance that the driver has to correctly match time stamps with
> frames.
>
> Thanks,
> Richard

I think you are still looking at this through the perspective of
sequence numbers.
I am *not* proposing to add sequence numbers for link-local and for
meta in software, and then try to match them, as that would lead to
complete chaos as you're suggesting.
The switch has internal logic to not send any other frame to the CPU
between a link-local and a meta frame.
Hence, if the MAC of the DSA master drops some of these frames, it
does not "spoil any chance" except if, out of the sequence LL n ->
META n -> LL n+1 -> META n+1, it persistently drops only META n and LL
n+1. If it drops less than 2 frames, the system recovers. And if it
drops more, oh well, there are more pressing issues to deal with..
So I'd like to re-state the problem towards what should be done to
prevent LL and META frames getting reordered in the DSA master driver
on multi-queue/multi-core systems. At the most basic level, there
should exist a rule that makes only a single core process these
frames.

Regards,
-Vladimir
