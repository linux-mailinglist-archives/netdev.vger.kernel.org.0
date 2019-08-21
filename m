Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DC5DB9766D
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 11:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727300AbfHUJx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 05:53:26 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:46826 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726351AbfHUJxZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 05:53:25 -0400
Received: by mail-lf1-f65.google.com with SMTP id n19so1294948lfe.13;
        Wed, 21 Aug 2019 02:53:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZbCWqTCCmdG6rzrJdpHlHLL1ZK/pt1TUGb23KjeYCrk=;
        b=Z5HN6y3Fa+X293x4mbXB/cpswIJKvrRzaBdoN8a0vCex6N9RFjd75IVaZrGGGxThbu
         kTEarpXuQ6auBxtmlw3h5/uUguyAvlmydWP8FGaTBIhM1x0h5kR1s9G6k/xwpMLvljou
         rcevtv9bADrjXZgUZ3UsA/h4xV6+GygrrjSmlcoqHswtAA8ghRVNutm+Nnl1wnfvu6In
         XYuDjZFj04v9ijhlVexBIFIESS0EJLXPG1lDlc3HmAIvt4SGRnGlR5RFaYk8msVPOrDX
         bKCocPpn7osUx4RGeytTuQZiL4AZG/4ehlidKIkfYKp8prhK6FewbmPcERn1qK8FxnMx
         xqfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZbCWqTCCmdG6rzrJdpHlHLL1ZK/pt1TUGb23KjeYCrk=;
        b=c2OgRVdeoGVsdV9Vaco5EdN57n7g/WsxVPTgXWvzGmOTQYMhfsiDWEt0ER/V7/lP2R
         Mi1ASpCKKQFkLrIGINJphJH/OLgkNuc9FPx2jMi0Xi1+xCPj2T8Bv7nsb7i4snqZfN/2
         8qMdibUIO2xvUY2voM3AvYZNnkEdLYBuqUKlD1v924dVXR0UR3F+Pqv1hLSGtOBDg70Y
         RwsiGp9ugGLvW7hk0mKNZjbJ0ahhVCzzkuQ8YAWvjHb0m+og0e75iQJQcZdetaAGXGgW
         MIzuAPlP/iby8BcLzSU2etTImr737/HW3DoBhr/icFqAvkeJeScLmPvMPHgqGp+Fa8cj
         JiwQ==
X-Gm-Message-State: APjAAAWKlogoXmIwUChkBc5VZdZ+RXsXnFrB9jdSAdeb4JrnjnhzQTcP
        qF/sWnQulTmVCGxNDq04tsiz1IrVt8HfM1xWR5k=
X-Google-Smtp-Source: APXvYqwb2rhw7Ep1aXg+5V7885VdFhKAbEOFcIsvVA/tDR61O6uv5lTq8FlL5kROb/mZjKV9MKTSsnQzjrJUIYUChrU=
X-Received: by 2002:ac2:5976:: with SMTP id h22mr18101434lfp.79.1566381203762;
 Wed, 21 Aug 2019 02:53:23 -0700 (PDT)
MIME-Version: 1.0
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at> <20190820094903.GI891@localhost>
 <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
 <20190820142537.GL891@localhost> <20190820152306.GJ29991@lunn.ch>
 <20190820154005.GM891@localhost> <CAFfN3gUgpzMebyUt8_-9e+5vpm3q-DVVszWdkUEFAgZQ8ex73w@mail.gmail.com>
 <20190821080709.GO891@localhost>
In-Reply-To: <20190821080709.GO891@localhost>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Wed, 21 Aug 2019 11:53:12 +0200
Message-ID: <CAFfN3gXtkv=YjoQixN+MdZ9vLZRPBMwg1mefuBTHFf1_QENPsg@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation to mdiobus_write_sts
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am Mi., 21. Aug. 2019 um 10:07 Uhr schrieb Miroslav Lichvar
<mlichvar@redhat.com>:
> > Currently I do not see the benefit from this. The original intention was to
> > compensate for the remaining offset as good as possible.
>
> That's ok, but IMHO the change should not break the assumptions of
> existing application and users.
>
> > The current code
> > of phc2sys uses the delay only for the filtering of the measurement record
> > with the shortest delay and for reporting and statistics. Why not simple shift
> > the timestamps with the offset to the point where we expect the PHC timestamp
> > to be captured, and we have a very good result compared to where we came
> > from.
>
> Because those reports/statistics are important in calculation of
> maximum error. If someone had a requirement for a clock to be accurate
> to 1.5 microseconds and the ioctl returned a delay indicating a
> sufficient accuracy when in reality it could be worse, that would be a
> problem.
>
Ok, I understand your point. But including the MDIO completion into
delay calculation
will indicate a much wore precision as it actually is. When the MDIO
driver implements
the PTP system timestamping as follows ...

  ptp_read_system_prets(bus->ptp_sts);
  writel(value, mdio-reg)
  ptp_read_system_postts(bus->ptp_sts);

... then we catch already the error caused by interrupts which hit the
pre/post_ts section.
Now we only have the additional error of one MDIO clock cycle
(~400ns). Because I expect
the MDIO controller to shift out the MDIO frame on the next MDIO clock
cycle. So if I subtract
one MDIO clock cycle from pre_ts and add one MDIO clock cycle to
post_ts the error indication
would be sufficiently corrected IMHO. And then we can shift both
timestamps in the switch driver
(in the gettimex handler) to compensate the switch depending offset.
What do you think?

Hubert
