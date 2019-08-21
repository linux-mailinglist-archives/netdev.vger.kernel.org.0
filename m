Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AE9F97720
	for <lists+netdev@lfdr.de>; Wed, 21 Aug 2019 12:28:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfHUK2X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Aug 2019 06:28:23 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:38584 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726995AbfHUK2W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Aug 2019 06:28:22 -0400
Received: by mail-ed1-f68.google.com with SMTP id r12so2349141edo.5;
        Wed, 21 Aug 2019 03:28:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tH4C4SHneA684UXc3D0kikroiEy/mW4WtnOuT96rGAM=;
        b=BQwd3ES5iB5HttBbWB7MmvzhXgwGjN1tPwBc9rgjyI4dXXBt3RMxGIY+7W/suYq3NE
         lWNbrFE/pp+XVvg3D7gmSet9mqwvmzVB/Z3+Pgv/kZ/y5fmwTz/JAKG3xI10dX1TXYnI
         w/ODwpQpbHmD61JlwUh0Te793e6L6ezn1YCwjnAG8sEFuXhJNNzOMFLG3Tjb1eagSrNb
         g5ZNNnaRAaP6GtB8MrOwh0crnBqjHYtXmbYLH+JoE2XSY+4YBV7VWkTYfEY57TOmsufz
         k1VkjkKQaEbnV2JlDjwoXHnudSdDW+x6vX84e12dpNVk5y4WggJcR07ZgeAF8NTyLb1o
         4KFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tH4C4SHneA684UXc3D0kikroiEy/mW4WtnOuT96rGAM=;
        b=F79KTTxHHaa3L3dTvXrE/WQ4bRtDEAs/WG9Iaal/W3rQyMWleXpN/oQAGxtH+lZWlV
         8C3Wx9ZgJ8zVMM+kpuPswKg+JoA/lx5uZiUATkYS8hdiGncy2iIljQFyJYK6ZmevKlvz
         l1ILKUCtANtFjjeASuO0c8bqkimT1e9jM+/Be88QyFDDcp/PiKTLpk0L9wrwbTUngDZG
         jgAd/MaQvkowoZhlQXBQwAaifCrErZuMCDgOM5A3TaxATXqfZqJAH2qw5QY8yeYA7pj6
         fQYdSWlCDe0Heb74xaT0t8sgP1u2jT+GINeiym0/CnO2DWUCij5GUD5/DpC3rh+ze5ap
         PDBw==
X-Gm-Message-State: APjAAAUOX+bN9pqzlrcDyQywZgs8zCMBv+3ipkKS29swNqPwsvs2dRAv
        4LurPPoct+PYzkQY3NMxNxX2UWGOReV0pteP8+8=
X-Google-Smtp-Source: APXvYqzm1AMb1SdDCLl2PZqOX1rVW3GzxnXK3xzo7vqdb+GYSql0VNnjYrTZY+VKIhPl9/PtAF3T/yfx4M2nAKykGw8=
X-Received: by 2002:a50:c385:: with SMTP id h5mr35182112edf.18.1566383300730;
 Wed, 21 Aug 2019 03:28:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190820084833.6019-1-hubert.feurstein@vahle.at> <20190820084833.6019-5-hubert.feurstein@vahle.at>
In-Reply-To: <20190820084833.6019-5-hubert.feurstein@vahle.at>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Wed, 21 Aug 2019 13:28:09 +0300
Message-ID: <CA+h21ho6T=DdE-9XCCj00UBFZahe08oEMP4kbgv+CmfRYD5c_Q@mail.gmail.com>
Subject: Re: [PATCH net-next v3 4/4] net: fec: add support for PTP system
 timestamping for MDIO devices
To:     Hubert Feurstein <h.feurstein@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Richard Cochran <richardcochran@gmail.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Fugang Duan <fugang.duan@nxp.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 at 11:49, Hubert Feurstein <h.feurstein@gmail.com> wrote:
>
> From: Hubert Feurstein <h.feurstein@gmail.com>
>
> In order to improve the synchronisation precision of phc2sys (from
> the linuxptp project) for devices like switches which are attached
> to the MDIO bus, it is necessary the get the system timestamps as
> close as possible to the access which causes the PTP timestamp
> register to be snapshotted in the switch hardware. Usually this is
> triggered by an MDIO write access, the snapshotted timestamp is then
> transferred by several MDIO reads.
>
> The ptp_read_system_*ts functions already check the ptp_sts pointer.
>
> Signed-off-by: Hubert Feurstein <h.feurstein@gmail.com>
> ---
>  drivers/net/ethernet/freescale/fec_main.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
> index c01d3ec3e9af..dd1253683ac0 100644
> --- a/drivers/net/ethernet/freescale/fec_main.c
> +++ b/drivers/net/ethernet/freescale/fec_main.c
> @@ -1815,10 +1815,12 @@ static int fec_enet_mdio_write(struct mii_bus *bus, int mii_id, int regnum,
>         reinit_completion(&fep->mdio_done);
>
>         /* start a write op */
> +       ptp_read_system_prets(bus->ptp_sts);
>         writel(FEC_MMFR_ST | FEC_MMFR_OP_WRITE |
>                 FEC_MMFR_PA(mii_id) | FEC_MMFR_RA(regnum) |
>                 FEC_MMFR_TA | FEC_MMFR_DATA(value),
>                 fep->hwp + FEC_MII_DATA);
> +       ptp_read_system_postts(bus->ptp_sts);
>

How do you know the core will not service an interrupt here?
Why are you not disabling (postponing) local interrupts after this
critical section? (which you were in the RFC)
If the argument is that you didn't notice any issue with phc2sys -N 5,
that's not a good argument. "Unlikely for a condition to happen" does
not mean deterministic.
Here is an example of the system servicing an interrupt during the
transmission of a 12-byte SPI transfer (proof that they can occur
anywhere where they aren't disabled):
https://drive.google.com/file/d/1rUZpfkBKHJGwQN4orFUWks_5i70wn-mj/view?usp=sharing

>         /* wait for end of transfer */
>         time_left = wait_for_completion_timeout(&fep->mdio_done,
> @@ -1956,7 +1958,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>         struct fec_enet_private *fep = netdev_priv(ndev);
>         struct device_node *node;
>         int err = -ENXIO;
> -       u32 mii_speed, holdtime;
> +       u32 mii_speed, mii_period, holdtime;
>
>         /*
>          * The i.MX28 dual fec interfaces are not equal.
> @@ -1993,6 +1995,7 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>          * document.
>          */
>         mii_speed = DIV_ROUND_UP(clk_get_rate(fep->clk_ipg), 5000000);
> +       mii_period = div_u64((u64)mii_speed * 2 * NSEC_PER_SEC, clk_get_rate(fep->clk_ipg));
>         if (fep->quirks & FEC_QUIRK_ENET_MAC)
>                 mii_speed--;
>         if (mii_speed > 63) {
> @@ -2034,6 +2037,8 @@ static int fec_enet_mii_init(struct platform_device *pdev)
>                 pdev->name, fep->dev_id + 1);
>         fep->mii_bus->priv = fep;
>         fep->mii_bus->parent = &pdev->dev;
> +       fep->mii_bus->flags = MII_BUS_F_PTP_STS_SUPPORTED;
> +       fep->mii_bus->ptp_sts_offset = 32 * mii_period;
>
>         node = of_get_child_by_name(pdev->dev.of_node, "mdio");
>         err = of_mdiobus_register(fep->mii_bus, node);
> --
> 2.22.1
>

Regards,
-Vladimir
