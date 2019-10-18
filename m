Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A457DBDB3
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 08:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504426AbfJRGev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 02:34:51 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39347 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504412AbfJRGev (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 02:34:51 -0400
Received: by mail-lj1-f194.google.com with SMTP id y3so5001032ljj.6
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 23:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8T2/vXRyndokZ7vX22/2/a6/WD2miv7Rl3m7zj32Fp8=;
        b=RleO9eahI+6+oDfh4+1oA/eaxv7Y8exCVau2aGeY/8KpYjK40X7M+6LITZAx3nXB+Z
         ztsWMwbhCoVq9899EAjgvngkW1IT5gJaSR0pC9Q2HXJSPMPPv0MPvkFrbnS0U1ds/k/u
         HpNO4f6D5o2utUi44GwrMkq1yYC7m/BzEUv4g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8T2/vXRyndokZ7vX22/2/a6/WD2miv7Rl3m7zj32Fp8=;
        b=XkCNbbffWGpDNDF7/6pg96uTgLPsQqPevVicVtBjOPBDATk6RD6m2zUQ7hYKnRmq8U
         Qf+E0s0bWgoj7CDldMTmq0zp04EMlekmIAN7y1PPq7shpxB2MS96GL/7Fm1JugV4P9mp
         YawC1kgDTe0fpGoO+R2QeP5XwqkXTHAKooLVtAXxatMX7nwygm5fJFFU3if9qfEqUvwS
         gfLq9is9v44KHh/sYy6fw2ZDpwwOr8YAT1oEmkBt+vlLc6N2P2k1NL3ox9zNfo/ynwFm
         awP9qlZ7Wfpje5oHzZX918g4SGOFOzIhOEbZRWsbsDksd3PwNU+jDKW1hfJ+6a8wzepQ
         1OpQ==
X-Gm-Message-State: APjAAAXrnq23BZx8yNceY4COu1EfcGE6QJtbKO6DBOvN9Kl8e9s/K+nj
        Gwu/wY+y6vh37e+cYH0A5Kn2H6EtBd0gZi8SYlL3og==
X-Google-Smtp-Source: APXvYqzoULge8k0SiIQ1m/UX1jeSbqNQL9TYXvJJ92W0m8hejRJbuLyqGKZAjxJbVqlLyx8rqRF5S1yW0+oCJUx9wgM=
X-Received: by 2002:a2e:8505:: with SMTP id j5mr4945355lji.154.1571380487610;
 Thu, 17 Oct 2019 23:34:47 -0700 (PDT)
MIME-Version: 1.0
References: <1571313682-28900-1-git-send-email-sheetal.tigadoli@broadcom.com>
 <1571313682-28900-4-git-send-email-sheetal.tigadoli@broadcom.com> <20191017122156.4d5262ac@cakuba.netronome.com>
In-Reply-To: <20191017122156.4d5262ac@cakuba.netronome.com>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Fri, 18 Oct 2019 12:04:35 +0530
Message-ID: <CAACQVJrO_PN8LBY0ovwkdxGsyvW_gGN7C3MxnuW+jjdS_75Hhw@mail.gmail.com>
Subject: Re: [PATCH V2 3/3] bnxt_en: Add support to collect crash dump via ethtool
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 12:52 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 17 Oct 2019 17:31:22 +0530, Sheetal Tigadoli wrote:
> > From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> >
> > Driver supports 2 types of core dumps.
> >
> > 1. Live dump - Firmware dump when system is up and running.
> > 2. Crash dump - Dump which is collected during firmware crash
> >                 that can be retrieved after recovery.
> > Crash dump is currently supported only on specific 58800 chips
> > which can be retrieved using OP-TEE API only, as firmware cannot
> > access this region directly.
> >
> > User needs to set the dump flag using following command before
> > initiating the dump collection:
> >
> >     $ ethtool -W|--set-dump eth0 N
> >
> > Where N is "0" for live dump and "1" for crash dump
> >
> > Command to collect the dump after setting the flag:
> >
> >     $ ethtool -w eth0 data Filename
> >
> > Cc: Michael Chan <michael.chan@broadcom.com>
> > Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
> > Signed-off-by: Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>
> > ---
> >  drivers/net/ethernet/broadcom/bnxt/bnxt.h         |  3 ++
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 36 +++++++++++++++++++++--
> >  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |  2 ++
> >  3 files changed, 39 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > index 0943715..3e7d1fb 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
> > @@ -1807,6 +1807,9 @@ struct bnxt {
> >
> >       u8                      num_leds;
> >       struct bnxt_led_info    leds[BNXT_MAX_LED];
> > +     u16                     dump_flag;
> > +#define BNXT_DUMP_LIVE               0
> > +#define BNXT_DUMP_CRASH              1
> >
> >       struct bpf_prog         *xdp_prog;
> >
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > index 51c1404..1596221 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
> > @@ -3311,6 +3311,23 @@ static int bnxt_get_coredump(struct bnxt *bp, void *buf, u32 *dump_len)
> >       return rc;
> >  }
> >
> > +static int bnxt_set_dump(struct net_device *dev, struct ethtool_dump *dump)
> > +{
> > +     struct bnxt *bp = netdev_priv(dev);
> > +
> > +#ifndef CONFIG_TEE_BNXT_FW
> > +     return -EOPNOTSUPP;
> > +#endif
>
>         if (!IS_ENABLED(...))
>                 return x;
>
> reads better IMHO
Okay.

>
> But also you seem to be breaking live dump for systems with
> CONFIG_TEE_BNXT_FW=n
Yes, we are supporting set_dump only if crash dump is supported.

>
> > +     if (dump->flag > BNXT_DUMP_CRASH) {
> > +             netdev_err(dev, "Supports only Live(0) and Crash(1) dumps.\n");
>
> more of an _info than _err, if at all
I made this err, as we are returning error on invalid flag value. I
can modify the log to
something like "Invalid dump flag. Supports only Live(0) and Crash(1)
dumps.\n" to make
it more like error log.

>
> > +             return -EINVAL;
> > +     }
> > +
> > +     bp->dump_flag = dump->flag;
> > +     return 0;
> > +}
> > +
> >  static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
> >  {
> >       struct bnxt *bp = netdev_priv(dev);
> > @@ -3323,7 +3340,12 @@ static int bnxt_get_dump_flag(struct net_device *dev, struct ethtool_dump *dump)
> >                       bp->ver_resp.hwrm_fw_bld_8b << 8 |
> >                       bp->ver_resp.hwrm_fw_rsvd_8b;
> >
> > -     return bnxt_get_coredump(bp, NULL, &dump->len);
> > +     dump->flag = bp->dump_flag;
> > +     if (bp->dump_flag == BNXT_DUMP_CRASH)
> > +             dump->len = BNXT_CRASH_DUMP_LEN;
> > +     else
> > +             bnxt_get_coredump(bp, NULL, &dump->len);
> > +     return 0;
> >  }
> >
> >  static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
> > @@ -3336,7 +3358,16 @@ static int bnxt_get_dump_data(struct net_device *dev, struct ethtool_dump *dump,
> >
> >       memset(buf, 0, dump->len);
> >
> > -     return bnxt_get_coredump(bp, buf, &dump->len);
> > +     dump->flag = bp->dump_flag;
> > +     if (dump->flag == BNXT_DUMP_CRASH) {
> > +#ifdef CONFIG_TEE_BNXT_FW
> > +             return tee_bnxt_copy_coredump(buf, 0, dump->len);
> > +#endif
> > +     } else {
> > +             return bnxt_get_coredump(bp, buf, &dump->len);
> > +     }
> > +
> > +     return 0;
> >  }
> >
> >  void bnxt_ethtool_init(struct bnxt *bp)
> > @@ -3446,6 +3477,7 @@ void bnxt_ethtool_free(struct bnxt *bp)
> >       .set_phys_id            = bnxt_set_phys_id,
> >       .self_test              = bnxt_self_test,
> >       .reset                  = bnxt_reset,
> > +     .set_dump               = bnxt_set_dump,
> >       .get_dump_flag          = bnxt_get_dump_flag,
> >       .get_dump_data          = bnxt_get_dump_data,
> >  };
> > diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> > index b5b65b3..01de7e7 100644
> > --- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> > +++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h
> > @@ -59,6 +59,8 @@ struct hwrm_dbg_cmn_output {
> >       #define HWRM_DBG_CMN_FLAGS_MORE 1
> >  };
> >
> > +#define BNXT_CRASH_DUMP_LEN  (8 << 20)
> > +
> >  #define BNXT_LED_DFLT_ENA                            \
> >       (PORT_LED_CFG_REQ_ENABLES_LED0_ID |             \
> >        PORT_LED_CFG_REQ_ENABLES_LED0_STATE |          \
>
Thanks,
Vasundhara
