Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37FA823B7
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 19:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbfHERMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 13:12:54 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:40961 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHERMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 13:12:54 -0400
Received: by mail-lj1-f195.google.com with SMTP id d24so79903980ljg.8;
        Mon, 05 Aug 2019 10:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6iMFYFH4X6s+euARV6rmBikYFkTBSANC3KZNWbKeoRE=;
        b=oUhe72XNXdkWmwMaT/hrGFo5VJt24LUh2fBVLDDel/o4FkSgRcor6fpnt3799gAXgy
         kpe4vWp1XwW6BuQuM2q6rv8LD41/pBjjHbl0lgW5xUA63Mab2x0R1Do6cpAPxAHcvJb6
         /Zbl/NVdL3hdWYuAflUScdD56lzj29n1wKXnUEp+fjINWXZyaUZg6o2GAbLOxS9Lj62v
         wIyuP6tPLbOR0VWJtfNiFAbqKEXS1MYkQX69t6mQWUnPe8SH6j0eNWTNKFkqpD90ym9G
         oXhfaorobpf4OlxmOKk+ltEA3ORcJUBH3hpmj6+4j+54KERPagnE1VjGR4sBX7UceWCB
         utyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6iMFYFH4X6s+euARV6rmBikYFkTBSANC3KZNWbKeoRE=;
        b=DxKECsCUjJws7Im3Z9knrRGOCA7chgy0RwRalAyq6JtHWHrMIq0LZFO2u+knOWdy+V
         r/J6S+L4p6n3B2Ded+9NVsh4iPQgTW4P0Rw3wLIUq5pOncxC3OuHg8Ax0jbutCdJDuZI
         3hCGcANp4FmyP1qZsdzYjtpXQCgjto9C6Ubpl39YQrhl1VwDX20rA9IbrR4Ukph5MGoS
         lz5edlTnynhmDcigXWKonKMxX7CbM9Lf29G1uQn/ZO0xLVo8CdYT/sZvAl0JL8FR1Tbd
         0Gvi0NJJ76lYyUBhnfVH1KkSa1NekjOP6HXGL4h6HQa8iLKuVFucqXhLlJRpNwLwV5y3
         mAPg==
X-Gm-Message-State: APjAAAUMoCnUd+VqGycfgalcUwQqMA7gj30NsbFEbFAn9AQgUHuc2YZB
        a7LA27vMf67wbF28UDsDM4+9q5vlhlOGvN7496Y=
X-Google-Smtp-Source: APXvYqyOxuBNnWh5fzHJCZG6flBd7htxzjei/Y+Qkgew54DbRQVPBFjeho3mRJxhHOVHDscNELViQcHp7RopywNeJoE=
X-Received: by 2002:a2e:b048:: with SMTP id d8mr37936260ljl.118.1565025172165;
 Mon, 05 Aug 2019 10:12:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190805082642.12873-1-hubert.feurstein@vahle.at> <20190805135838.GF24275@lunn.ch>
In-Reply-To: <20190805135838.GF24275@lunn.ch>
From:   Hubert Feurstein <h.feurstein@gmail.com>
Date:   Mon, 5 Aug 2019 19:12:40 +0200
Message-ID: <CAFfN3gVFjb0uaF_NSHSOZN2knNn7nK3ZKRnvZDSN9A=+1qa-+A@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: mv88e6xxx: extend PTP gettime
 function to read system clock
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Am Mo., 5. Aug. 2019 um 15:58 Uhr schrieb Andrew Lunn <andrew@lunn.ch>:
>
> On Mon, Aug 05, 2019 at 10:26:42AM +0200, Hubert Feurstein wrote:
> > From: Hubert Feurstein <h.feurstein@gmail.com>
>
> Hi Hubert
>
> In your RFC patch, there was some interesting numbers. Can you provide
> numbers of just this patch? How much of an improvement does it make?
>
> Your RFC patch pushed these ptp_read_system_{pre|post}ts() calls down
> into the MDIO driver. This patch is much less invasive, but i wonder
> how much a penalty you paid?

I mentioned the numbers already in my RFC mail.
Without this patch a quick test-run gave me this result:
  Min:          -17829 ns
  Max:          21694 ns
  StdDev:       8520 ns
  Count:        127

With this patch applied, the results improved:
  Min:          -12144 ns
  Max:          10891 ns
  StdDev:       4046,71 ns
  Count:        112

I know, the sample count for the statistics (only 112 samples!) is not
really big.
However, even with this low number of samples I already got too high min / max
values.

>
> Did you also try moving these calls into global2_avb.c, around the one
> write that really matters?
>
> It was speculated that the jitter comes from contention on the mdio
> bus lock. Did you investigate this? If you can prove this true, one
> thing to try is to take the mdio bus lock in the mv88e6xxx driver,
> take the start timestamp, call __mdiobus_write(), and then the end
> timestamp. The bus contention is then outside your time snapshot.
>

I've tested this now:

diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
index 801fd4abba5a..fc7f9318df52 100644
--- a/drivers/net/dsa/mv88e6xxx/smi.c
+++ b/drivers/net/dsa/mv88e6xxx/smi.c
@@ -40,12 +40,27 @@ static int mv88e6xxx_smi_direct_read(struct
mv88e6xxx_chip *chip,
       return 0;
}

+static int mv88e6xxx_mdiobus_write_nested(struct mv88e6xxx_chip
*chip, int addr, u32 regnum, u16 val)
+{
+       int err;
+
+       BUG_ON(in_interrupt());
+
+       mutex_lock_nested(&chip->bus->mdio_lock, MDIO_MUTEX_NESTED);
+       ptp_read_system_prets(chip->ptp_sts);
+       err = __mdiobus_write(chip->bus, addr, regnum, val);
+       ptp_read_system_postts(chip->ptp_sts);
+       mutex_unlock(&chip->bus->mdio_lock);
+
+       return err;
+}
+
static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
                                     int dev, int reg, u16 data)
{
       int ret;

-       ret = mdiobus_write_nested_ptp(chip->bus, dev, reg, data,
chip->ptp_sts);
+       ret = mv88e6xxx_mdiobus_write_nested(chip, dev, reg, data);
       if (ret < 0)
               return ret;

The result was:
Min:  -8052
Max:  9988
StdDev: 2490.17
Count: 3592

It got improved, but you still have the unpredictable latencies caused by the
mdio_done-completion (=> wait_for_completion_timeout) in imx_fec.

> We could even think about adding a mdiobus_write variant which does
> all this. I'm sure other DSA drivers would find it useful, if it
> really does help.
>
>            Andrew

Hubert
