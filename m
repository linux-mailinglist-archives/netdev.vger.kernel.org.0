Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564F097700
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbfHUKTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:19:25 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42228 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbfHUKTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 06:19:24 -0400
Received: by mail-ed1-f68.google.com with SMTP id m44so2288010edd.9;
        Wed, 21 Aug 2019 03:19:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0j0aLbF37mxr0p4tOgL1Wqo0ymRU6Jzah6uHZ9y7XhA=;
        b=by0zxMIC8CA0LYBrVXAyJ1cpW9JX3DO0Io4PD9hXj3gKSJI6/JK38qOq4Wc5uIpI4F
         aAgc9zM64oy87SzjcASlQF0aBmd5J/xm01U6Rd0S9w1oOC6Tj/tGI6ufoj21FoW0q1Wj
         +bA5mro6vmQnjSZgTOwVh3mXMUi92BFvLtnPc5WvnTePqF1JF7tcViUCiMbQlDhu90F2
         hRleiL/zdAwtlkRzJKrxYIBMC7utuCUzh56xKfgKxE/3zUZ6DYO4skiLfIB9qyJ/Q4Nf
         78oLrZfKIesSuhWj1dxbfkIwBLAIIApOZIB+6GDPlFFV9icfy/GrvwJdYhvIcurTY5so
         HH+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0j0aLbF37mxr0p4tOgL1Wqo0ymRU6Jzah6uHZ9y7XhA=;
        b=pT4h5LGQNm2gR8hzIVI6VEQGol72ZQa7r35jVphf1syRqrwyz/NT2YfzHNcSCGYlVr
         SY4btxt7kyu3vGQO4qkzXzjtw2jRTLf2Id+9WUgTJahzBDr2OpzlclTD+6eHFyHzJv+I
         qrLh3QcW5Fud50tpLmSGHKXcyM7d+oblNIvwG/9TUawV3plhk22Y3/YXPNJi0q0re2eV
         f9ncbwSVrqfrcIWRYfB/EYXhJzKvvDCSwp2cMdevZgcej9eRWgkWVlx+dbInC7IFL+1p
         qxXdly2bYuM4mJ1hW3DZ898U2GUUt8TKjb0aoTZMn2zbHvs1tnJ/KWlEpRGsc0QH7SD0
         lK8g==
X-Gm-Message-State: APjAAAUGaRFxmsXjhe5Q1q1dU97eK/qxcBKytIwidM35qwNlMfoQE22z
        QqCPLbKsQTEAAf/iqUhzc3lD3Wsl9axK0AeYK00=
X-Google-Smtp-Source: APXvYqyCMQRXTysHNv654vgFXFGTPCCGCtvgVuo3D1GkUGPfi+zNusDVSWaOl5IuZKD5FXrnfv2WsKIM52PU64UxOdg=
X-Received: by 2002:a17:906:1484:: with SMTP id x4mr2757504ejc.204.1566382762303;
 Wed, 21 Aug 2019 03:19:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at> <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost> <20190820152306.GJ29991@lunn.ch>
 <20190820154005.GM891@localhost> <CAFfN3gUgpzMebyUt8_-9e+5vpm3q-DVVszWdkUEFAgZQ8ex73w@mail.gmail.com>
 <20190821080709.GO891@localhost> <CAFfN3gXtkv=YjoQixN+MdZ9vLZRPBMwg1mefuBTHFf1_QENPsg@mail.gmail.com>
In-Reply-To: <CAFfN3gXtkv=YjoQixN+MdZ9vLZRPBMwg1mefuBTHFf1_QENPsg@mail.gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 21 Aug 2019 13:19:11 +0300
Message-ID: <CA+h21hoM_P5jYn+VBaxP1a8iLMP4qoAb1C3+EzuRZcASDKP5Dw@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation to mdiobus_write_sts
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     Miroslav Lichvar <mlichvar@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 21 Aug 2019 at 12:53, Hubert Feurstein <h.feurstein@gmail.com> wrote:
>
> Am Mi., 21. Aug. 2019 um 10:07 Uhr schrieb Miroslav Lichvar
> <mlichvar@redhat.com>:
> > > Currently I do not see the benefit from this. The original intention was to
> > > compensate for the remaining offset as good as possible.
> >
> > That's ok, but IMHO the change should not break the assumptions of
> > existing application and users.
> >
> > > The current code
> > > of phc2sys uses the delay only for the filtering of the measurement record
> > > with the shortest delay and for reporting and statistics. Why not simple shift
> > > the timestamps with the offset to the point where we expect the PHC timestamp
> > > to be captured, and we have a very good result compared to where we came
> > > from.
> >
> > Because those reports/statistics are important in calculation of
> > maximum error. If someone had a requirement for a clock to be accurate
> > to 1.5 microseconds and the ioctl returned a delay indicating a
> > sufficient accuracy when in reality it could be worse, that would be a
> > problem.
> >
> Ok, I understand your point. But including the MDIO completion into
> delay calculation
> will indicate a much wore precision as it actually is. When the MDIO
> driver implements
> the PTP system timestamping as follows ...
>
>   ptp_read_system_prets(bus->ptp_sts);
>   writel(value, mdio-reg)
>   ptp_read_system_postts(bus->ptp_sts);
>
> ... then we catch already the error caused by interrupts which hit the
> pre/post_ts section.
> Now we only have the additional error of one MDIO clock cycle
> (~400ns). Because I expect
> the MDIO controller to shift out the MDIO frame on the next MDIO clock
> cycle. So if I subtract

How do you know?
The MDIO controller is a memory-mapped peripheral so there will be a
transaction on the core <-> peripheral interconnect in the SoC.
Depending on the system load, the transaction might not be
instantaneous as you think. Additionally there will be clock domain
crossings in the MDIO controller when transferring the command from
the platform clock to the peripheral clock, which might also add some
jitter.
MDIO frames may also begin with 32 bits of preamble, with some
controllers being able to suppress it. Have you checked/accounted for
this?
The only reliable moment when you know the MDIO command has completed
is when the controller says it has. If there is additional jitter in
waiting for the completion event caused by the GIC and the scheduling
of the ISR, then just switch the driver to poll mode, like everybody
else.

> one MDIO clock cycle from pre_ts and add one MDIO clock cycle to
> post_ts the error indication
> would be sufficiently corrected IMHO. And then we can shift both
> timestamps in the switch driver
> (in the gettimex handler) to compensate the switch depending offset.
> What do you think?
>
> Hubert

Regards,
-Vladimir
