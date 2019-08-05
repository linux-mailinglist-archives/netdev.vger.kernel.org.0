Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACF2815F7
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 11:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbfHEJzD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 05:55:03 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:46211 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727230AbfHEJzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 05:55:03 -0400
Received: by mail-ed1-f68.google.com with SMTP id d4so78123255edr.13;
        Mon, 05 Aug 2019 02:55:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XIpZT5CC7KoQUkvyA8aWybxS6kfkOZEodPhLoEB7MkU=;
        b=Z1Itd+Io2VQgvwk+BPSTCbiDlIkME8CUlw6u2YqkP22SVk6c1ECiMx20vOXb/Be4QZ
         1lB3/mLeXXliwe8qSkA49VFHQvL89316kFytfh2h0aahwaurbcxXEGDCYJWjs+N5+LUd
         UpWGA5P7EpdnE5xB90UI8eoZcYEUCKJANGfIIc8ZyuO6CTHe4O5hUyhsk7AMNmMAnPpV
         p5ceCOy2C00KDCj8yfYq+4RrKWFg97T4SqPpkp81REBtJOMz8ZbztTD5OYKkvHDhRzi/
         wv63hsuekbb4OJu5Dc54LSrUKYjprOLh84IKuxkGJfEjXpGh6YrNZmxQK2tl0siksZQ2
         TSxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XIpZT5CC7KoQUkvyA8aWybxS6kfkOZEodPhLoEB7MkU=;
        b=cio2WFAoBC9bG/6nTXuDLFYn4jl3MGENoEunQtg9NqZ3E1nANuO2CL1FQd6OPpqYq/
         j718KcBppmzNAKMjEVADoyfoRE9A74ZyURWRX69BSw73iMfqw6X8nE95KKrwzs9Ne2J6
         FamlV5fC9NXSte1LcLfciadgeVGDpcYaCQqfbuuu2DKejxfL/4xHDj5Bhqjp7jMDtbi6
         5S09YXplDuOw40BVlykpnVoC0BKCi7e5y/o1U1FkiO3e03e9eWCboW7LiD9yLVXpkWps
         oikMWUN+HAhwh1CJnk23UhTu7YaQTa8u37SIxSU5JlOxmOzygHpJcTkv/Id27e/VgZS0
         KMbw==
X-Gm-Message-State: APjAAAU/NWDRidK1fvJ7M0JeP8WwijJjx++niboQHXwJd4BQQUixB/UT
        RNQqeXqhPM5dLcxnEJuVWWLaX9rfOtbKqfrUt/A=
X-Google-Smtp-Source: APXvYqw2eikDYrtTRn25PZQL7Zb2pZmehqNo+kJn5RvRqOR+O7AB+G8+BLT/Abf74WV40+CzdMRZR/vPkafWVPknwNY=
X-Received: by 2002:aa7:c559:: with SMTP id s25mr33367209edr.117.1564998900552;
 Mon, 05 Aug 2019 02:55:00 -0700 (PDT)
MIME-Version: 1.0
References: <20190802163248.11152-1-h.feurstein@gmail.com>
In-Reply-To: <20190802163248.11152-1-h.feurstein@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Mon, 5 Aug 2019 12:54:49 +0300
Message-ID: <CA+h21hr835sdvtgVOA2M9SWeCXDOrDG1S3FnNgJd_9NP2X_TaQ@mail.gmail.com>
Subject: Re: [RFC] net: dsa: mv88e6xxx: ptp: improve phc2sys precision for
 mv88e6xxx switch in combination with imx6-fec
To:     Hubert Feurstein <h.feurstein@gmail.com>, mlichvar@redhat.com,
        Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hubert,

On Fri, 2 Aug 2019 at 19:33, Hubert Feurstein <h.feurstein@gmail.com> wrote:
>
> With this patch the phc2sys synchronisation precision improved to +/-500ns.
>
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---
>
> This patch should only be the base for a discussion about improving precision of
> phc2sys (from the linuxptp package) in combination with a mv88e6xxx switch and
> imx6-fec.
>
> When I started my work on PTP at the beginning of this week, I was positively
> supprised about the sync precision of ptp4l. After adding support for the
> MV88E6220 I was able to synchronize two of our boards within +/- 10 nanoseconds.
> Remebering that the PTP system in the MV88E6220 is clocked with 100MHz, this is
> I think the best what can be expected. Big thanks to Richard and the other
> developers who made this possible.
>
> But then I tried to synchornize the PTP clock with the system clock by using
> phc2sys (phc2sys -rr -amq -l6) and I quickly was very disapointed about the
> precision.
>
>   Min:          -17829 ns
>   Max:          21694 ns
>   StdDev:       8520 ns
>   Count:        127
>
> So I tried to find the reason for this. And as you probably already know, the
> reason for that is the MDIO latency, which is terrible (up to 800 usecs).
>
> As a next step, I tried to to implement the gettimex64 callback (see: "[PATCH]
> net: dsa: mv88e6xxx: extend PTP gettime function to read system clock"). With
> this in place (and a patched linuxptp-master version which really uses the
> PTP_SYS_OFFSET_EXTENDED-ioctl), I got the following results:
>
>   Min:          -12144 ns
>   Max:          10891 ns
>   StdDev:       4046,71 ns
>   Count:        112
>
> So, things improved, but this is still unacceptable. It was still not possible
> to compensate the MDIO latency issue.
>
> According to my understanding, the timestamps (by using
> ptp_read_system_{pre|post}ts) have to be captured at a place where we have an
> constant offset related to the PHC in the switch. The only point where these
> timestamps can be captured is the mdio_write callback in the imx_fec. Because,
> reading the PHC timestamp will result in the follwing MDIO accesses:
>
>   (several) reads of the AVB_CMD register (to poll for the busy-flag)
>   write AVB_CMD (AVBOp=110b Read with post-incerement of PHC timestamp)
>   read AVB_DATA (PTP Global Time [15:0])
>   read AVB_DATA (PTP Global Time [31:16])
>
> With this sequence in mind, the Marvell switch has to snapshot the PHC
> timestamp at the write-AVB_CMD in order to be able to get sane values later by
> reading AVB_DATA. So the best place to capture the system timestamps is this
> one and only write operation directly in the imx_fec. By using the patch below
> (without the changes to the system clock resolution) I got the following
> results:
>
>   Min:          -464 ns
>   Max:          525 ns
>   StdDev:       210,31 ns
>   Count:        401
>
> I would say that is a huge improvement.
>
> I realized, that the system clock (at least on the imx6) has a resolution of
> 333ns. So I tried to speed up this clock by using the PER-clock instead of
> OSC_PER. This gave me 15ns resolution. The results were:
>
>   Min:          -476 ns
>   Max:          439 ns
>   StdDev:       176,52 ns
>   Count:        630
>
> So, things got improved again a little bit (at least the StdDev).
>
> According to my understanding, this is almost the best which is possible,
> because there is one more clock which influences the results. This is the MDIO
> bus clock, which is just 2.5MHz (or 400ns). So, I would say that +/- 400ns
> jitter is caused only by the MDIO bus clock, since the changes in imx_fec should
> not introduce any unpredictable latencies.
>
> My question to the experienced kernel developers is, how can this be implemented
> in a more generic way? Because this hack only works under these circumstances,
> and of course can never be part of the mainline kernel.
>
> I am not 100% sure that all my statements or assumptions are correct, so feel
> free to correct me.
>
> Hubert
>

You guessed correctly (since you copied me) that I'm battling much of
the same issues with the sja1105 and its spi-fsl-dspi controller
driver.
In fact I will refrain from saying anything about your
PTP_SYS_OFFSET_EXTENDED solution/hack combo, but will ask some
questions instead:

- You said you patched linuxptp master. Could you share the patch? Is
there anything else that's needed except compiling against the board's
real kernel headers (aka point KBUILD_OUTPUT to the extracted location
of /sys/kernel/kheaders.tar.xz)? I've done that and I do see phc2sys
probing and using the new ioctl, but I don't see a big improvement in
my case (that's probably because my SPI interface has real jitter
caused by peripheral clock instability, but I really need to put a
scope on it to be sure, so that's a discussion for another time).
- I really wonder what your jitter is caused by. Maybe it is just
contention on the mii_bus->mdio_lock? If that's the case, maybe you
don't need to go all the way down to the driver level, and taking the
ptp_sts at the subsystem (MDIO, SPI, I2C, etc) level is "good enough".
- Along the lines of the above, I wonder how badly would the
maintainers shout at the proposal of adding a struct
ptp_system_timestamp pointer and its associated lock in struct device.
That way at least you don't have to change the API, like you did with
mdiobus_write_nested_ptp. Relatively speaking, this is the least
amount of intrusion (although, again, far from beautiful).
- The software timestamps help you in the particular case of phc2sys,
but are they enough to cover all your needs? I haven't spent even 1
second looking at Marvell switch datasheets, but is its free-running
timer only used for PTP timestamping? At least the sja1105 does also
support time-based egress scheduling and ingress policing, so for that
scenario, the timecounter/cyclecounter implementation will no longer
cut it (you do need to synchronize the hardware clock). If your
hardware supports these PTP-based features as well, I can only assume
the reason why mv88e6xxx went for a timecounter is the same as the
reason why I did: the MDIO/SPI jitter while accessing the frequency
and offset correction registers is bad enough that the servo loop goes
haywire. And implementing gettimex64 will not solve that.

I also added Miroslav Lichvar, who originally created the
PTP_SYS_OFFSET_EXTENDED ioctl, maybe he can share some ideas on how it
is best served.

>  drivers/clocksource/timer-imx-gpt.c       |  9 ++++++++-
>  drivers/net/dsa/mv88e6xxx/chip.h          |  2 ++
>  drivers/net/dsa/mv88e6xxx/ptp.c           | 11 +++++++----
>  drivers/net/dsa/mv88e6xxx/smi.c           |  2 +-
>  drivers/net/ethernet/freescale/fec_main.c | 24 ++++++++++++++++++-----
>  drivers/net/phy/mdio_bus.c                | 16 +++++++++++++++
>  include/linux/mdio.h                      |  2 ++
>  include/linux/phy.h                       |  1 +
>  8 files changed, 56 insertions(+), 11 deletions(-)
>
> diff --git a/drivers/clocksource/timer-imx-gpt.c b/drivers/clocksource/timer-imx-gpt.c
> index 706c0d0ff56c..84695a2d8ff7 100644
> --- a/drivers/clocksource/timer-imx-gpt.c
> +++ b/drivers/clocksource/timer-imx-gpt.c
> @@ -471,8 +471,15 @@ static int __init mxc_timer_init_dt(struct device_node *np,  enum imx_gpt_type t
>
>         /* Try osc_per first, and fall back to per otherwise */
>         imxtm->clk_per = of_clk_get_by_name(np, "osc_per");
> -       if (IS_ERR(imxtm->clk_per))
> +
> +       /* Force PER clock to be used, so we get 15ns instead of 333ns */
> +       //if (IS_ERR(imxtm->clk_per)) {
> +       if (1) {
>                 imxtm->clk_per = of_clk_get_by_name(np, "per");
> +               pr_info("==> Using PER clock\n");
> +       } else {
> +               pr_info("==> Using OSC_PER clock\n");
> +       }
>
>         imxtm->type = type;
>
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.h b/drivers/net/dsa/mv88e6xxx/chip.h
> index 01963ee94c50..9e14dc406415 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.h
> +++ b/drivers/net/dsa/mv88e6xxx/chip.h
> @@ -277,6 +277,8 @@ struct mv88e6xxx_chip {
>         struct ptp_clock_info   ptp_clock_info;
>         struct delayed_work     tai_event_work;
>         struct ptp_pin_desc     pin_config[MV88E6XXX_MAX_GPIO];
> +       struct ptp_system_timestamp *ptp_sts;
> +
>         u16 trig_config;
>         u16 evcap_config;
>         u16 enable_count;
> diff --git a/drivers/net/dsa/mv88e6xxx/ptp.c b/drivers/net/dsa/mv88e6xxx/ptp.c
> index 073cbd0bb91b..cf6e52ee9e0a 100644
> --- a/drivers/net/dsa/mv88e6xxx/ptp.c
> +++ b/drivers/net/dsa/mv88e6xxx/ptp.c
> @@ -235,14 +235,17 @@ static int mv88e6xxx_ptp_adjtime(struct ptp_clock_info *ptp, s64 delta)
>         return 0;
>  }
>
> -static int mv88e6xxx_ptp_gettime(struct ptp_clock_info *ptp,
> -                                struct timespec64 *ts)
> +static int mv88e6xxx_ptp_gettimex(struct ptp_clock_info *ptp,
> +                                 struct timespec64 *ts,
> +                                 struct ptp_system_timestamp *sts)
>  {
>         struct mv88e6xxx_chip *chip = ptp_to_chip(ptp);
>         u64 ns;
>
>         mv88e6xxx_reg_lock(chip);
> +       chip->ptp_sts = sts;
>         ns = timecounter_read(&chip->tstamp_tc);
> +       chip->ptp_sts = NULL;
>         mv88e6xxx_reg_unlock(chip);
>
>         *ts = ns_to_timespec64(ns);
> @@ -426,7 +429,7 @@ static void mv88e6xxx_ptp_overflow_check(struct work_struct *work)
>         struct mv88e6xxx_chip *chip = dw_overflow_to_chip(dw);
>         struct timespec64 ts;
>
> -       mv88e6xxx_ptp_gettime(&chip->ptp_clock_info, &ts);
> +       mv88e6xxx_ptp_gettimex(&chip->ptp_clock_info, &ts, NULL);
>
>         schedule_delayed_work(&chip->overflow_work,
>                               MV88E6XXX_TAI_OVERFLOW_PERIOD);
> @@ -472,7 +475,7 @@ int mv88e6xxx_ptp_setup(struct mv88e6xxx_chip *chip)
>         chip->ptp_clock_info.max_adj    = MV88E6XXX_MAX_ADJ_PPB;
>         chip->ptp_clock_info.adjfine    = mv88e6xxx_ptp_adjfine;
>         chip->ptp_clock_info.adjtime    = mv88e6xxx_ptp_adjtime;
> -       chip->ptp_clock_info.gettime64  = mv88e6xxx_ptp_gettime;
> +       chip->ptp_clock_info.gettimex64 = mv88e6xxx_ptp_gettimex;
>         chip->ptp_clock_info.settime64  = mv88e6xxx_ptp_settime;
>         chip->ptp_clock_info.enable     = ptp_ops->ptp_enable;
>         chip->ptp_clock_info.verify     = ptp_ops->ptp_verify;
> diff --git a/drivers/net/dsa/mv88e6xxx/smi.c b/drivers/net/dsa/mv88e6xxx/smi.c
> index 5fc78a063843..801fd4abba5a 100644
> --- a/drivers/net/dsa/mv88e6xxx/smi.c
> +++ b/drivers/net/dsa/mv88e6xxx/smi.c
> @@ -45,7 +45,7 @@ static int mv88e6xxx_smi_direct_write(struct mv88e6xxx_chip *chip,
>  {
>         int ret;
>
> -       ret = mdiobus_write_nested(chip->bus, dev, reg, data);
> +       ret = mdiobus_write_nested_ptp(chip->bus, dev, reg, data, chip->ptp_sts);
>         if (ret < 0)
>                 return ret;
>
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index 2f6057e7335d..20f589dc5b8b 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1814,11 +1814,25 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>
>         reinit_completion(&fep->mdio_done);
>
> -       /* start a write op */
> -       writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> -               FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> -               FEC_MMFR_TA | FEC_MMFR_DATA(value),
> -               fep->hwp + FEC_MII_DATA);
> +       if (bus->ptp_sts) {
> +               unsigned long flags = 0;
> +               local_irq_save(flags);
> +               __iowmb();
> +               /* >Take the timestamp *after* the memory barrier */
> +               ptp_read_system_prets(bus->ptp_sts);
> +               writel_relaxed(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> +                       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +                       FEC_MMFR_TA | FEC_MMFR_DATA(value),
> +                       fep->hwp + FEC_MII_DATA);
> +               ptp_read_system_postts(bus->ptp_sts);
> +               local_irq_restore(flags);
> +       } else {
> +               /* start a write op */
> +               writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
> +                       FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
> +                       FEC_MMFR_TA | FEC_MMFR_DATA(value),
> +                       fep->hwp + FEC_MII_DATA);
> +       }
>
>         /* wait for end of transfer */
>         time_left = wait_for_completion_timeout(&fep->mdio_done,
> diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> index bd04fe762056..f076487db11f 100644
> --- a/drivers/net/phy/mdio_bus.c
> +++ b/drivers/net/phy/mdio_bus.c
> @@ -672,6 +672,22 @@ int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val)
>  }
>  EXPORT_SYMBOL(mdiobus_write_nested);
>
> +int mdiobus_write_nested_ptp(struct mii_bus *bus, int addr, u32 regnum, u16 val, struct ptp_system_timestamp *ptp_sts)
> +{
> +       int err;
> +
> +       BUG_ON(in_interrupt());
> +
> +       mutex_lock_nested(&bus->mdio_lock, MDIO_MUTEX_NESTED);
> +       bus->ptp_sts = ptp_sts;
> +       err = __mdiobus_write(bus, addr, regnum, val);
> +       bus->ptp_sts = NULL;
> +       mutex_unlock(&bus->mdio_lock);
> +
> +       return err;
> +}
> +EXPORT_SYMBOL(mdiobus_write_nested_ptp);
> +
>  /**
>   * mdiobus_write - Convenience function for writing a given MII mgmt register
>   * @bus: the mii_bus struct
> diff --git a/include/linux/mdio.h b/include/linux/mdio.h
> index e8242ad88c81..7f9767babdc3 100644
> --- a/include/linux/mdio.h
> +++ b/include/linux/mdio.h
> @@ -9,6 +9,7 @@
>  #include <uapi/linux/mdio.h>
>  #include <linux/mod_devicetable.h>
>
> +struct ptp_system_timestamp;
>  struct gpio_desc;
>  struct mii_bus;
>
> @@ -310,6 +311,7 @@ int mdiobus_read(struct mii_bus *bus, int addr, u32 regnum);
>  int mdiobus_read_nested(struct mii_bus *bus, int addr, u32 regnum);
>  int mdiobus_write(struct mii_bus *bus, int addr, u32 regnum, u16 val);
>  int mdiobus_write_nested(struct mii_bus *bus, int addr, u32 regnum, u16 val);
> +int mdiobus_write_nested_ptp(struct mii_bus *bus, int addr, u32 regnum, u16 val, struct ptp_system_timestamp *ptp_sts);
>
>  int mdiobus_register_device(struct mdio_device *mdiodev);
>  int mdiobus_unregister_device(struct mdio_device *mdiodev);
> diff --git a/include/linux/phy.h b/include/linux/phy.h
> index 462b90b73f93..fd4e33654863 100644
> --- a/include/linux/phy.h
> +++ b/include/linux/phy.h
> @@ -252,6 +252,7 @@ struct mii_bus {
>         int reset_delay_us;
>         /* RESET GPIO descriptor pointer */
>         struct gpio_desc *reset_gpiod;
> +       struct ptp_system_timestamp *ptp_sts;
>  };
>  #define to_mii_bus(d) container_of(d, struct mii_bus, dev)
>
> --
> 2.22.0
>

Regards,
-Vladimir
