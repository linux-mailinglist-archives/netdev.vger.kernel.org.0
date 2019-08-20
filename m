Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E06995E89
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729261AbfHTM3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:29:41 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:43983 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728283AbfHTM3l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 08:29:41 -0400
Received: by mail-lf1-f68.google.com with SMTP id c19so3965867lfm.10;
        Tue, 20 Aug 2019 05:29:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UlsVz1wHMj3PeZoLHKBkC0BOhpKbI3sl0Y6Cv32qL3I=;
        b=MiXwt7rHY9qY4rkKeJaLv/LhyfMJM5wRQKwG3ZNSH0DK2a+gpY7eFAqnWDSNawLnvL
         IVTKPK4Q7dxg2eqcD6HAr4zkxsaKUR65lD/4luLy87pnqelxY7EVWnKBAEd10tottXr3
         2/oh5vMs1dcxpFrzzDx4YwI2bxoI1PjSPXqvw7M66qUeQyVm7PbwIc1OVZ1pfOvfqTEC
         HlYNZgy+JNDV0R8VnYvqLogThqKsumGn0q7aT88MmZPQ3aI92uimdUThlTJs/3kqp8w5
         ZO408ihISvAkIOD+DPmdr4R/5vUJ47Fi69fc1zDpW+PsyUdeECLBiGXFebdwkJIfu2Mm
         CR9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UlsVz1wHMj3PeZoLHKBkC0BOhpKbI3sl0Y6Cv32qL3I=;
        b=ai4dA3H/9Ju0AfC/vgI5vy7ngGMEtaKgvlMGyTCqCf2b9Or6cXyl+sPr/VCRzPZFJE
         0En7N3qVv/LQT7+TrMTyAzKBeTIys9uGQ5DnX/0UAR6r/byRLrUtp8X2+eY7D853bTpS
         fe3/oHk1OBDe+SrU/6Hzr1faoxXAjTEIPzA2EhfIwHR4GSmBD+/ONwbk0R2n9/kp08JV
         HEFVm7T9aTbAwPRmAUZwjOFuRN9CWOWORIovo+fHCAIpAC3ii3nQ4EXNgIykHXPQbqML
         nokEgLUR3Y224sMveJYYqXhDPgsyDsG6PwZeZp1p7FsWvamI1j84MpBymrq2OLMHdJbC
         gzcA==
X-Gm-Message-State: APjAAAWA8S1eL7dl/57DXqBHTWpDsQREkpwk/D9XSH53H+DHbhB8TtXd
        GKQHeemsFlerAV7rRVlIQEVCWMUntH6dPOsSItOyXxG0gP0=
X-Google-Smtp-Source: APXvYqxCwXgM0YhO+BWt3S4UIRimEbH9NiAmt9e0a1uzWjsue+nj3eGGkKBNaGMvlNlsRfFBGht1m48KT7xfoKSU2DA=
X-Received: by 2002:ac2:456d:: with SMTP id k13mr14800801lfm.77.1566304179141;
 Tue, 20 Aug 2019 05:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190820084833.6019-1-hubert.feurstein@vahle.at>
 <20190820084833.6019-3-hubert.feurstein@vahle.at> <20190820094903.GI891@localhost>
In-Reply-To: <20190820094903.GI891@localhost>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Tue, 20 Aug 2019 14:29:27 +0200
Message-ID: <CAFfN3gW-4avfnrV7t-2nC+cVt3sgMD33L44P4PGU-MCAtuR+XA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 2/4] net: mdio: add PTP offset compensation to mdiobus_write_sts
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
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

Hi Miroslav,

Am Di., 20. Aug. 2019 um 11:49 Uhr schrieb Miroslav Lichvar
<mlichvar@redhat.com>:
>
> On Tue, Aug 20, 2019 at 10:48:31AM +0200, Hubert Feurstein wrote:
>
> > +     /* PTP offset compensation:
> > +      * After the MDIO access is completed (from the chip perspective), the
> > +      * switch chip will snapshot the PHC timestamp. To make sure our system
> > +      * timestamp corresponds to the PHC timestamp, we have to add the
> > +      * duration of this MDIO access to sts->post_ts. Linuxptp's phc2sys
> > +      * takes the average of pre_ts and post_ts to calculate the final
> > +      * system timestamp. With this in mind, we have to add ptp_sts_offset
> > +      * twice to post_ts, in order to not introduce an constant time offset.
> > +      */
> > +     if (sts)
> > +             timespec64_add_ns(&sts->post_ts, 2 * bus->ptp_sts_offset);
>
> This correction looks good to me.
>
> Is the MDIO write delay constant in reality, or does it at least have
> an upper bound? That is, is it always true that the post_ts timestamp
> does not point to a time before the PHC timestamp was actually taken?
>
> This is important to not break the estimation of maximum error in the
> measured offset. Applications using the ioctl may assume that the
> maximum error is (post_ts-pre_ts)/2 (i.e. half of the delay printed by
> phc2sys). That would not work if the delay could be occasionally 50
> microseconds for instance, i.e. the post_ts timestamp would be earlier
> than the PHC timestamp.
>
If the timestamps are taken in the MDIO driver (imx-fec in my case), then
everything is quite deterministic (see results in the cover letter). Of course,
it still can be improved slightly, by splitting up the writel into iowmb and
write_relaxed and disable the interrupts while capturing the timestamps
(as I did in my original RFC patch). But phc2sys takes by default 5 measurements
and uses the one with the smallest delay, so this shouldn't be necessary.

Although, by adding 2 * ptp_sts_offset the system timestamp to post_ts
the timestamp is aligned with the PHC timestamp, but this also increases
the delay which is reported by phc2sys (~26us). But the maximum error
which must be expected is definitely much less (< 1us). So maybe it is better
to shift both timestamps pre_ts and post_ts by ptp_sts_offset.

Hubert
