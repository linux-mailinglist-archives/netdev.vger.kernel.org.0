Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C18E03873F
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 11:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727933AbfFGJnT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 05:43:19 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:38091 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfFGJnS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 05:43:18 -0400
Received: by mail-ed1-f65.google.com with SMTP id g13so2124944edu.5;
        Fri, 07 Jun 2019 02:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J7QcgrWkSAFsej/rko9HTCODh2HodcbGMIhhGvJpZMY=;
        b=RIe7cDSEB9dVHPlF58YojVZV76Cv64m0YUIrrb2RtjbA2NhRxdUbeoOc5Lug62nQdT
         P+PBlzQgRRZmBPe7xoP25eQuHyl+ZRqaNUDnWoxi6CapwAfxfw3UkriVxLB8QlqwFLcS
         vbNhOA2oJ9fVszRJ5bDIZ4bhgvw+jdjFCqv71APjLyT45uN2mO+5OHCC/0gz26UmWz13
         UibvghNEVCBacIgpyRKvw9jOc2Tyh9LyVhKUDaOIM5fZ+SeL2a5LN7ahUCY/B6G9lcXj
         Ix/bh3b6ty+8EizB31p5XUiWksb2sCSt4BIPAUwwFBv4QANkkLLpFg6P4zeGluomXtd2
         aI+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J7QcgrWkSAFsej/rko9HTCODh2HodcbGMIhhGvJpZMY=;
        b=CzDybA9yirvrthihgUghz5uiJ+bpzcw42s7seduM+b/XO3Z71j3hJWuhZFtR39YRXA
         dJvH4qDDVeTRs6ZLsmaHWVY7EKA6G0DXHUMxm6fOc5+psUPA3xLjzgOjVFav9Hlrwt/F
         Mee7FjQoez8FBtat0BH92z8Rnlv+Uhmp3Btcxxk3J9cLKNMZXmo9s44uxeanlmUI1AZg
         WHnXpY23Zo8v/CoOSJVAR59ZpgK5znO4m9hYnUQbRfsKc7R/ivVcco2M6SiiqQ8tNQXF
         ea96gUwSI8TmbUKy6dhPzUbQDPSB8kASlYuadVRyB0WUfJnvc3bokIUUo17JxVlYCop8
         Idtw==
X-Gm-Message-State: APjAAAVRyHPdLzYo1BvWTxMx7Rspq28LhJdEVKZ4hdh3s6rpb8I5ZasQ
        ru3NcORoVvsqSsrRZl++CdzKx/pQuw5Lj3Fs+ak=
X-Google-Smtp-Source: APXvYqwrsZSk/YdKpS4BMDFb0IJglKZzZn5HteH5JVRjUk0BOybK3YN3CZistVbvLYAlDL0TMHBMBkC59SkhcrIAuks=
X-Received: by 2002:a17:906:4e8f:: with SMTP id v15mr14429327eju.47.1559900596768;
 Fri, 07 Jun 2019 02:43:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190604170756.14338-1-olteanv@gmail.com> <20190604.202258.1443410652869724565.davem@davemloft.net>
 <CA+h21hq1_wcB6_ffYdtOEyz8-aE=c7MiZP4en_VKOBodo=3VSQ@mail.gmail.com>
 <CA+h21hrJYm4GLn+LpJ623_dpgxE2z-k3xTMD=z1QQ9WqXg7zrQ@mail.gmail.com>
 <20190605174547.b4rwbfrzjqzujxno@localhost> <CA+h21hqdmu3+YQVMXyvckrUjXW7mstjG1MDafWGy4qFHB9zdtg@mail.gmail.com>
 <20190606031135.6lyydjb6hqfeuzt3@localhost> <CA+h21hosUmUu98QdzKTJPUd2PEwa+sUg1SNY1ti95kD6kOqE6A@mail.gmail.com>
 <20190607033242.expuqccmzhxdkwzq@localhost>
In-Reply-To: <20190607033242.expuqccmzhxdkwzq@localhost>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 7 Jun 2019 12:43:05 +0300
Message-ID: <CA+h21hpS=1Xq3y0C79KEZV9EX3g+aRm4c9NkCwiD7vDhyTwi=w@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 00/17] PTP support for the SJA1105 DSA driver
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
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

On Fri, 7 Jun 2019 at 06:32, Richard Cochran <richardcochran@gmail.com> wrote:
>
> On Thu, Jun 06, 2019 at 04:40:19PM +0300, Vladimir Oltean wrote:
> > Plain and simply because it doesn't work very well.
> > Even phc2sys from the system clock to the hardware (no timestamps
> > involved) has trouble staying put (under 1000 ns offset).
> > And using the hardware-corrected timestamps triggers a lot of clockchecks.
>
> It sounds like a bug in reading or adjusting the HW clock.  Is the HW
> clock stable when you don't adjust its frequency?

How can I tell that for sure?

>
> Thanks,
> Richard
