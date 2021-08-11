Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC323E9504
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 17:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233335AbhHKPt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Aug 2021 11:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233491AbhHKPty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Aug 2021 11:49:54 -0400
Received: from mail-oo1-xc2c.google.com (mail-oo1-xc2c.google.com [IPv6:2607:f8b0:4864:20::c2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358D6C06179B
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 08:49:28 -0700 (PDT)
Received: by mail-oo1-xc2c.google.com with SMTP id f33-20020a4a89240000b029027c19426fbeso837242ooi.8
        for <netdev@vger.kernel.org>; Wed, 11 Aug 2021 08:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iseV4vtLVpyFyuHkKGsgJupsfcGy1KwX5sLsBlQwAlQ=;
        b=MSEM7N8vXPO1U+EPMIwdSWrjE/vRnWpqg8maZE0Nha8L1zK7lOAdeJ7w9yBZ/gtFO4
         Tms1qGSJhsS9j/M6b6LrHOXqOJlterlrDJe55O2VKlkb781B3VFbsFZKoOvIBHLG1clj
         GFedUhXQFQrFzVgmfeFDJOWYsJ47B5YJD+r3XasfrSseTfiLjT2l5sG4Ojmyjm1jZSP6
         ZkeSMCI5TM/GpweMoHBv7BsnSX185RsTnQ0oOGY3VfP/3Zt/UjpOIs6EzddQZQ1bmTOk
         GGdtF10jrKdyh4U9stPyHHwt8jB76+PLrlfj/5mYSLMdq5DKTcSXM6N0/X1m8wFIhWDe
         ZrXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iseV4vtLVpyFyuHkKGsgJupsfcGy1KwX5sLsBlQwAlQ=;
        b=dFNmMBhdUzW3jcqE4fYhi8BK9gPB+pnDIm42NP016YYh5PmBr5KfGFUmgvcRPn/pZj
         0+As9iWMHxZ2sPUeOn9csVacxNNGVRo9xtfWa+SUH144Dv+OKF/Q3pTTbJCakU0B60CR
         sTLvAKydOaCObEhLehqxdVC4B7qcKtPaEy655Gbzp9Y9z1z2K1KVk81fSnKwJB2yCUcS
         qLo6lX5UNuYgOOvOEDVtMofUzcmM6jfRdTnFFxdb6BTm76deYaFe6XJ1nGVB2uFHbjwF
         64Z2LMJQ96rjh0c1/GFFOR5C7ILukimyMUq9uPWJk2HArTU5T8l5rDbUIWy/K5+ojC8j
         2b4A==
X-Gm-Message-State: AOAM533YCsFKTKj8CaODJpCNqVgdduDI8LEcS9REMxtT7Vpu6eawL43s
        TFZFuBN+ipjCAl1npo0Ilhs1o0cg5+nTCD/o+w==
X-Google-Smtp-Source: ABdhPJzda1iIk2zoAi/3uvkJlltS4nqR45xmPyRL+6jak+pR3BJUJ7sPg3TrzgdQztX+FFfYyE6rbr8YIsCQP4HGKRA=
X-Received: by 2002:a4a:e589:: with SMTP id o9mr22832501oov.43.1628696967585;
 Wed, 11 Aug 2021 08:49:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAFSKS=Pv4qjfikHcvyycneAkQWTXQkKS_0oEVQ3JyE5UL6H=MQ@mail.gmail.com>
 <YQHGe6Rv9T4+E3AG@lunn.ch> <20210728222457.GA10360@hoboy.vegasvil.org>
 <CAFSKS=OtAgLCo0MLe8CORUgkapZLRbe6hRiKU7QWSd5a70wgrw@mail.gmail.com> <YQKwXj8v+NFQs4dw@lunn.ch>
In-Reply-To: <YQKwXj8v+NFQs4dw@lunn.ch>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Wed, 11 Aug 2021 10:49:15 -0500
Message-ID: <CAFSKS=PJBpvtRJxrR4sG1hyxpnUnQpiHg4SrUNzAhkWnyt9ivg@mail.gmail.com>
Subject: Re: net: dsa: mv88e6xxx: no multicasts rx'd after enabling hw time stamping
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 29, 2021 at 8:42 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > Thanks for the feedback. The datasheet covers the 88E6390X, 88E6390,
> > 88E6290, 88E6190X, 88E6190 so I expect those work similarly but if
> > only the 6352 has been tested that could explain it. It certainly
> > helps to know that I'm working with something that may have never
> > worked rather than I'm just doing something dumb.
>
> I don't think you are doing something dumb.
>
> What i find interesting is that multicast works, until it does not
> work. I would try to find out what call into the driver causes that
> change.
>
> Also, general multicast traffic should not really be involved
> here. The switch should be identifying PTP packets as management, and
> sending them to the CPU port, independent of whatever multicast rules
> are set, flooding of unknown multicast etc. This is needed so that PTP
> frames get through a bridge which is in STP blocking mode. Do you see
> any other problems with management traffic? Do bridge PDUs also not
> work?

Sorry for the huge delay, I had to deal with some other things before
I could get back to this.
When the hardware timestamping is on I don't see packets of type
0x88f7 regardless of multicast destination address. If I change the
packet to 0x88f8 I see it. So, it looks like you are right. Before I
had just tried changing the multicast destination address. I'm still
following up on the other suggestions you've made and hopefully that
will lead to something.

Thanks,
George

>
>         Andrew
