Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 603EA4571C6
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 16:39:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235398AbhKSPmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 10:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235434AbhKSPmE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 10:42:04 -0500
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9A5C061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:39:01 -0800 (PST)
Received: by mail-lf1-x12e.google.com with SMTP id b40so45243441lfv.10
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 07:39:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:in-reply-to:references:date:message-id
         :mime-version;
        bh=APqJtg3f8yGxkPCZQJ2BGKyNcy78gv7d+5nwLgrMSYU=;
        b=FFBfbx69g/v+rHsyJqu9iUe/C5/dVkBKQH9e20Cr/S2G+fTHCJ4hJ3jqFFRuXvZvaS
         NuOU1IudG5AfcUDH0f2gQQeUdAoYb6BPgB578Xksu60YEGb4ug/iH2UPBm48d+fw0Qie
         dkElgIZQ0xoclY94sQwiZW1rrpYfOb3Rt6rTpgmn7CU1cZbg51txEgzdtISey8N2nUNR
         u5jJS/FP1rcKnbCEeHtUZ6t/zm0NPlVlSeAABlLReqGJQ12yZ27f/pqQtPSU74Orq77J
         6sypKlUNho6+RPp5qbCxwSLlnC1TMoLbPoNq96ImjgXXWk+2o0KeZ5oJZBr0nbED71CU
         c0rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=APqJtg3f8yGxkPCZQJ2BGKyNcy78gv7d+5nwLgrMSYU=;
        b=q3kmajc/rXpy+M7mxTK39pTvRtteVf4IudnShMrHK9GK7VlVo1bSodkVItNtOGnNti
         dcbnhg4yuTeM5I3lhRlE9PFP86HEWYNAwbKPrl43nP/GfPgV1CPyyhJSSDvFcCB/jiY1
         T7LbOsS19LMHqwm4C6bQ2wnCQBZ5LuudvU99u9tHiirVdxDOYnJcvweZrKbUg6ARk4kO
         iHcTyk8e3cB3w2KqzjRR5v6vlH4M0MOsmTHTTsXQv2ecpoqw7SZaK1s6VfqMiQTjWGwS
         jFmde/0qpzIVSOI7EHkTdFqgNGu6tsjB4EQ0S5akIBPmY2uGegAQSFGGwr1j0VVWMvCT
         3CxQ==
X-Gm-Message-State: AOAM531tNfLQaB/cLGTuZGohKGUx/mRSMMiZpegdpe4lX3TfSFDMlxVW
        MlDdfBc3/Bmb9sUnwYbI5j3b4g==
X-Google-Smtp-Source: ABdhPJxNWhzUW/WI8aovzFhAYgVW7dBWR35JQeoiTKjgyTsRindliXQXe34sHxNl5rVAUg31Ln6F+Q==
X-Received: by 2002:a05:6512:11cf:: with SMTP id h15mr34370609lfr.138.1637336340156;
        Fri, 19 Nov 2021 07:39:00 -0800 (PST)
Received: from wkz-x280 (static-193-12-47-89.cust.tele2.se. [193.12.47.89])
        by smtp.gmail.com with ESMTPSA id br24sm16645lfb.104.2021.11.19.07.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 07:38:59 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: Re: [RFC PATCH net-next 6/6] net: dsa: eliminate dsa_switch_ops ::
 port_bridge_tx_fwd_{,un}offload
In-Reply-To: <20211026162625.1385035-7-vladimir.oltean@nxp.com>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
 <20211026162625.1385035-7-vladimir.oltean@nxp.com>
Date:   Fri, 19 Nov 2021 16:38:58 +0100
Message-ID: <878rxkjgtp.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 26, 2021 at 19:26, Vladimir Oltean <vladimir.oltean@nxp.com> wrote:
> We don't really need new switch API for these, and with new switches
> which intend to add support for this feature, it will become cumbersome
> to maintain.
>
> Simply pass a boolean argument to ->port_bridge_join which the driver
> must set to true if it implements the TX forwarding offload feature.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/dsa/b53/b53_common.c       |  3 +-
>  drivers/net/dsa/b53/b53_priv.h         |  3 +-
>  drivers/net/dsa/dsa_loop.c             |  3 +-
>  drivers/net/dsa/hirschmann/hellcreek.c |  3 +-
>  drivers/net/dsa/lan9303-core.c         |  3 +-
>  drivers/net/dsa/lantiq_gswip.c         |  3 +-
>  drivers/net/dsa/microchip/ksz_common.c |  3 +-
>  drivers/net/dsa/microchip/ksz_common.h |  2 +-
>  drivers/net/dsa/mt7530.c               |  2 +-
>  drivers/net/dsa/mv88e6xxx/chip.c       | 71 ++++++++++++--------------
>  drivers/net/dsa/ocelot/felix.c         |  2 +-
>  drivers/net/dsa/qca8k.c                |  3 +-
>  drivers/net/dsa/rtl8366rb.c            |  3 +-
>  drivers/net/dsa/sja1105/sja1105_main.c | 22 ++++++--
>  drivers/net/dsa/xrs700x/xrs700x.c      |  2 +-
>  include/net/dsa.h                      | 10 ++--
>  net/dsa/dsa_priv.h                     |  1 +
>  net/dsa/port.c                         | 39 ++------------
>  net/dsa/switch.c                       |  3 +-
>  19 files changed, 81 insertions(+), 100 deletions(-)
>
...
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index 73613a667f6c..0aac71dece29 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -2448,8 +2448,27 @@ static int mv88e6xxx_bridge_map(struct mv88e6xxx_chip *chip,
>  	return 0;
>  }
>  
> +/* Treat the software bridge as a virtual single-port switch behind the
> + * CPU and map in the PVT. First dst->last_switch elements are taken by
> + * physical switches, so start from beyond that range.
> + */
> +static int mv88e6xxx_map_virtual_bridge_to_pvt(struct dsa_switch *ds,
> +					       unsigned int bridge_num)
> +{
> +	u8 dev = bridge_num + ds->dst->last_switch;
> +	struct mv88e6xxx_chip *chip = ds->priv;
> +	int err;
> +
> +	mv88e6xxx_reg_lock(chip);

This deadlocks every time. The caller already holds this lock from both
call sites.

> +	err = mv88e6xxx_pvt_map(chip, dev, 0);
> +	mv88e6xxx_reg_unlock(chip);
> +
> +	return err;
> +}
> +
...
