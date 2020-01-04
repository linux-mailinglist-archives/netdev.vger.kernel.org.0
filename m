Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 26BFE1303EC
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 19:56:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgADS4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 13:56:25 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:36502 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADS4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 13:56:25 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so44282967edp.3
        for <netdev@vger.kernel.org>; Sat, 04 Jan 2020 10:56:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jW7tPRFkHNRyXAbT6GVCqQk946j889Z2luYYMpWEUxE=;
        b=OQhT+0nNx6dOWXf3qsLl9QRLMSGPRuosEBDwCKZVF/OSaOp90c8w5yQShia0D1gGq/
         mRyaGDR5aV1TMjOqDeeKfpw4K56pOeefEPlx8e3eSde69bBK/QD+XiZQhMOBtIrU4OV+
         vT8Rnl4Vh1HF4BIsscziZyQ9p2oP2JGuTxFsCXnt/yp2dIfMG9NXgh/FG4FMUwNjts29
         jofPgFwFH0/MI+DiPXl7ld6Rtq24BkzlJ4KxlrGnwm14B/C9I+3Th+/OlEt0hgOdgADU
         5PwPQAx2kkHsDmpRfi9WI2qsEnA5Rz4isoKxLM3wYNLDFEE7zn/YWK0tkvg4TWeRB1x2
         IA0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jW7tPRFkHNRyXAbT6GVCqQk946j889Z2luYYMpWEUxE=;
        b=pqVdcfX3lnHltz0XoQICPKxrq0qFmU/bevJL0d+1aINLZBeSuu0qbPlDw7uAnP15ta
         gsBGtjppKs2anIZCD1WSyOIoL6ALXFMXU+jCA8Fy+mUY5l9WnSQ8qNbM0/Md0gTLkve0
         wnk+peyUNEugnL+xd8v+IGdtq579AQYDlwsfByuTfT++ZnI0/TLwzmwmEnw6U63UNiVE
         r77mqyUOc8lFk48QNgvtTiB6VDyT99NtjN90AVC3CKQ5x6tsr9BBXRI301ffhiphsqo+
         BUGUXjryZCplU668HXxRvvXxYmetbaV1slaavyJsvBq6JABXwta8b5vQtvnAtj/wbXXj
         gV3g==
X-Gm-Message-State: APjAAAVZY28Gb9ZTa1PmW59Zy+sPNVzUy8fGFOdZ85M7VmEN2HSyDQif
        mZWwerha5a+x4etJMzyg5NrmOpIu/T1PQ6953Ko=
X-Google-Smtp-Source: APXvYqx7FwZFjX4kUGOcckpBiqtC2ViHgegNn1yW0FKapyPWVG0peiKrUb1gO1KmfrqboiDyjpxmcK1WPfmJdoWAVdk=
X-Received: by 2002:a50:fb96:: with SMTP id e22mr98779255edq.18.1578164183161;
 Sat, 04 Jan 2020 10:56:23 -0800 (PST)
MIME-Version: 1.0
References: <20200104161335.27662-1-andrew@lunn.ch>
In-Reply-To: <20200104161335.27662-1-andrew@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 4 Jan 2020 20:56:12 +0200
Message-ID: <CA+h21hoxY=4L53JGFmRTx5=CGbjY0pNpTSKd=ynDLdP_-CTO5g@mail.gmail.com>
Subject: Re: [PATCH net] net: dsa: mv88e6xxx: Preserve priority went setting
 CPU port.
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Chris Healy <Chris.Healy@zii.aero>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

Is there a typo in the commit message? (went -> when)

On Sat, 4 Jan 2020 at 18:16, Andrew Lunn <andrew@lunn.ch> wrote:
>
> The 6390 family uses an extended register to set the port connected to
> the CPU. The lower 5 bits indicate the port, the upper three bits are
> the priority of the frames as they pass through the switch, what
> egress queue they should use, etc. Since frames being set to the CPU
> are typically management frames, BPDU, IGMP, ARP, etc set the priority
> to 7, the reset default, and the highest.
>
> Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---

Offtopic: Does the switch look at VLAN PCP for these frames at all, or
is the priority fixed to the value from this register?

>  drivers/net/dsa/mv88e6xxx/global1.c | 5 +++++
>  drivers/net/dsa/mv88e6xxx/global1.h | 1 +
>  2 files changed, 6 insertions(+)
>
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.c b/drivers/net/dsa/mv88e6xxx/global1.c
> index 120a65d3e3ef..ce03f155e9fb 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.c
> +++ b/drivers/net/dsa/mv88e6xxx/global1.c
> @@ -360,6 +360,11 @@ int mv88e6390_g1_set_cpu_port(struct mv88e6xxx_chip *chip, int port)
>  {
>         u16 ptr = MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST;
>
> +       /* Use the default high priority for manegement frames sent to

management

> +        * the CPU.
> +        */
> +       port |= MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI;
> +
>         return mv88e6390_g1_monitor_write(chip, ptr, port);
>  }
>
> diff --git a/drivers/net/dsa/mv88e6xxx/global1.h b/drivers/net/dsa/mv88e6xxx/global1.h
> index bc5a6b2bb1e4..5324c6f4ae90 100644
> --- a/drivers/net/dsa/mv88e6xxx/global1.h
> +++ b/drivers/net/dsa/mv88e6xxx/global1.h
> @@ -211,6 +211,7 @@
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_INGRESS_DEST         0x2000
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_EGRESS_DEST          0x2100
>  #define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST             0x3000
> +#define MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI     0x00e0

I suppose this could be more nicely expressed as
MV88E6390_G1_MONITOR_MGMT_CTL_PTR_CPU_DEST_MGMTPRI(x)    ((x) << 5 &
GENMASK(7, 5)), in case somebody wants to change it from 7?

>  #define MV88E6390_G1_MONITOR_MGMT_CTL_DATA_MASK                        0x00ff
>
>  /* Offset 0x1C: Global Control 2 */
> --
> 2.24.0
>

Regards,
-Vladimir
