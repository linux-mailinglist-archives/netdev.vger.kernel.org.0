Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72808614F82
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 17:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230149AbiKAQic (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 12:38:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiKAQiL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 12:38:11 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 463431D311
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 09:34:55 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id AB603336C7;
        Tue,  1 Nov 2022 16:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1667320493; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/13DTSZFA3WBuAFiBibBMR7YZsK757/JO/ZkO2qL+3w=;
        b=Ipw3i7FQOlZY10AsvojpziTP0GcQLVnVv/S15VqNGu6ajI/VbGN7NGozHxUSx/CyFjwYzz
        S+Ukbk2YW4hNIglXa0yxg8RyAlrBl8cVsBwAcIkJdrenv1qjS3a7RZn1N0NloaqRdUY4aV
        MYUTW4lEAmHoz8Cz0pzMZvwBhqWkN1k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1667320493;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/13DTSZFA3WBuAFiBibBMR7YZsK757/JO/ZkO2qL+3w=;
        b=xHdYt7JzIVC11cwXmNTA9iG5H0z5OTbJTQxR6Jy+HyaUYnw9dbBavRWeDtyZqmm5O/iuCl
        7RGEydUJ/s9YBTAQ==
Received: from lion.mk-sys.cz (unknown [10.100.200.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9E39C2C141;
        Tue,  1 Nov 2022 16:34:53 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 73CDD60410; Tue,  1 Nov 2022 17:34:53 +0100 (CET)
Date:   Tue, 1 Nov 2022 17:34:53 +0100
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH ethtool] fsl_enetc: add support for NXP ENETC driver
Message-ID: <20221101163453.jtouqmz3m6hrnftz@lion.mk-sys.cz>
References: <20221026190552.2415266-1-vladimir.oltean@nxp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="x6efmyvh5j354i5q"
Content-Disposition: inline
In-Reply-To: <20221026190552.2415266-1-vladimir.oltean@nxp.com>
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_SOFTFAIL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--x6efmyvh5j354i5q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 26, 2022 at 10:05:52PM +0300, Vladimir Oltean wrote:
> Add pretty printer for the registers which the enetc PF and VF drivers
> support since their introduction in kernel v5.1. The selection of
> registers parsed is the selection exported by the kernel as of v6.1-rc2.
> Unparsed registers are printed as raw.
>=20
> One register is printed field by field (MAC COMMAND_CONFIG), I didn't
> have time/interest in printing more than 1. The rest are printed in hex.
>=20
> Sample output:
>=20
> $ ethtool -d eno0
> SI mode register: 0x80000000
> SI primary MAC address register 0: 0x59f0400
> SI primary MAC address register 1: 0x27f6
> SI control BDR mode register: 0x40000000
> SI control BDR status register: 0x0
> SI control BDR base address register 0: 0x8262f000
> SI control BDR base address register 1: 0x20
> SI control BDR producer index register: 0x3a
> SI control BDR consumer index register: 0x3a
> SI control BDR length register: 0x40
> SI capability register 0: 0x10080008
> SI capability register 1: 0x20002
> SI uncorrectable error frame drop count register: 0x0
> TX BDR 0 mode register: 0x80000200
> TX BDR 0 status register: 0x0
> TX BDR 0 base address register 0: 0xebfa0000
> TX BDR 0 base address register 1: 0x0
> TX BDR 0 producer index register: 0x12
> TX BDR 0 consumer index register: 0x12
> TX BDR 0 length register: 0x800
> TX BDR 0 interrupt enable register: 0x1
> TX BDR 0 interrupt coalescing register 0: 0x80000008
> TX BDR 0 interrupt coalescing register 1: 0x3a980
> (repeats for other TX rings)
> RX BDR 0 mode register: 0x80000034
> RX BDR 0 status register: 0x0
> RX BDR 0 buffer size register: 0x680
> RX BDR 0 consumer index register: 0x7ff
> RX BDR 0 base address register 0: 0xec430000
> RX BDR 0 base address register 1: 0x0
> RX BDR 0 producer index register: 0x0
> RX BDR 0 length register: 0x800
> RX BDR 0 interrupt enable register: 0x1
> RX BDR 0 interrupt coalescing register 0: 0x80000100
> RX BDR 0 interrupt coalescing register 1: 0x1
> (repeats for other RX rings)
> Port mode register: 0x70200
> Port status register: 0x0
> Port SI promiscuous mode register: 0x0
> Port SI0 primary MAC address register 0: 0x59f0400
> Port SI0 primary MAC address register 1: 0x27f6
> Port HTA transmit memory buffer allocation register: 0xc390
> Port capability register 0: 0x10101b3c
> Port capability register 1: 0x2070
> Port SI0 configuration register 0: 0x3080008
> Port RFS capability register: 0x2
> Port traffic class 0 maximum SDU register: 0x2580
> Port eMAC Command and Configuration Register: 0x8813
>         MG 0
>         RXSTP 0
>         REG_LOWP_RXETY 0
>         TX_LOWP_ENA 0
>         SFD 0
>         NO_LEN_CHK 0
>         SEND_IDLE 0
>         CNT_FRM_EN 0
>         SWR 0
>         TXP 1
>         XGLP 0
>         TX_ADDR_INS 0
>         PAUSE_IGN 0
>         PAUSE_FWD 0
>         CRC 0
>         PAD 0
>         PROMIS 1
>         WAN 0
>         RX_EN 1
>         TX_EN 1
> Port eMAC Maximum Frame Length Register: 0x2580
> Port eMAC Interface Mode Control Register: 0x1002
>=20
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Looks good to me, just a cosmetic issue below.

[...]
> diff --git a/fsl_enetc.c b/fsl_enetc.c
> new file mode 100644
> index 000000000000..c39f5cb3ce3f
> --- /dev/null
> +++ b/fsl_enetc.c
> @@ -0,0 +1,259 @@
> +/* Code to dump registers for the Freescale/NXP ENETC controller.
> + *
> + * Copyright 2022 NXP
> + */
> +#include <stdio.h>
> +#include "internal.h"
> +
> +#define BIT(x)			(1 << (x))

This macro is only used to mask bits of a u32 value, wouldn't "1U" be
more appropriate?

Michal

[...]
> +#define ENETC_PM0_CMD_TX_EN		BIT(0)
> +#define ENETC_PM0_CMD_RX_EN		BIT(1)
> +#define ENETC_PM0_CMD_WAN		BIT(3)
> +#define ENETC_PM0_CMD_PROMISC		BIT(4)
> +#define ENETC_PM0_CMD_PAD		BIT(5)
> +#define ENETC_PM0_CMD_CRC		BIT(6)
> +#define ENETC_PM0_CMD_PAUSE_FWD		BIT(7)
> +#define ENETC_PM0_CMD_PAUSE_IGN		BIT(8)
> +#define ENETC_PM0_CMD_TX_ADDR_INS	BIT(9)
> +#define ENETC_PM0_CMD_XGLP		BIT(10)
> +#define ENETC_PM0_CMD_TXP		BIT(11)
> +#define ENETC_PM0_CMD_SWR		BIT(12)
> +#define ENETC_PM0_CMD_CNT_FRM_EN	BIT(13)
> +#define ENETC_PM0_CMD_SEND_IDLE		BIT(16)
> +#define ENETC_PM0_CMD_NO_LEN_CHK	BIT(17)
> +#define ENETC_PM0_CMD_SFD		BIT(21)
> +#define ENETC_PM0_CMD_TX_LOWP_ENA	BIT(23)
> +#define ENETC_PM0_CMD_REG_LOWP_RXETY	BIT(24)
> +#define ENETC_PM0_CMD_RXSTP		BIT(29)
> +#define ENETC_PM0_CMD_MG		BIT(31)
[...]
> +static void decode_cmd_cfg(u32 val, char *buf)
> +{
> +	sprintf(buf, "\tMG %d\n\tRXSTP %d\n\tREG_LOWP_RXETY %d\n"
> +		"\tTX_LOWP_ENA %d\n\tSFD %d\n\tNO_LEN_CHK %d\n\tSEND_IDLE %d\n"
> +		"\tCNT_FRM_EN %d\n\tSWR %d\n\tTXP %d\n\tXGLP %d\n"
> +		"\tTX_ADDR_INS %d\n\tPAUSE_IGN %d\n\tPAUSE_FWD %d\n\tCRC %d\n"
> +		"\tPAD %d\n\tPROMIS %d\n\tWAN %d\n\tRX_EN %d\n\tTX_EN %d\n",
> +		!!(val & ENETC_PM0_CMD_MG),
> +		!!(val & ENETC_PM0_CMD_RXSTP),
> +		!!(val & ENETC_PM0_CMD_REG_LOWP_RXETY),
> +		!!(val & ENETC_PM0_CMD_TX_LOWP_ENA),
> +		!!(val & ENETC_PM0_CMD_SFD),
> +		!!(val & ENETC_PM0_CMD_NO_LEN_CHK),
> +		!!(val & ENETC_PM0_CMD_SEND_IDLE),
> +		!!(val & ENETC_PM0_CMD_CNT_FRM_EN),
> +		!!(val & ENETC_PM0_CMD_SWR),
> +		!!(val & ENETC_PM0_CMD_TXP),
> +		!!(val & ENETC_PM0_CMD_XGLP),
> +		!!(val & ENETC_PM0_CMD_TX_ADDR_INS),
> +		!!(val & ENETC_PM0_CMD_PAUSE_IGN),
> +		!!(val & ENETC_PM0_CMD_PAUSE_FWD),
> +		!!(val & ENETC_PM0_CMD_CRC),
> +		!!(val & ENETC_PM0_CMD_PAD),
> +		!!(val & ENETC_PM0_CMD_PROMISC),
> +		!!(val & ENETC_PM0_CMD_WAN),
> +		!!(val & ENETC_PM0_CMD_RX_EN),
> +		!!(val & ENETC_PM0_CMD_TX_EN));
> +}

--x6efmyvh5j354i5q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEWN3j3bieVmp26mKO538sG/LRdpUFAmNhSqgACgkQ538sG/LR
dpVqPgf/XZNVFVsMB/svYqB8gE2e/vtquQWm49/hIavGozbH79DKxPL9llnE2HYd
2ubra4KothZ+U6S7FN+GJtvv8iT/53FZZGc/gQTxdTC0spGpR7GUZVXrD4XttHUk
dvCT1nsdIKuqAUo1VZroNxd9bSdvL8/Ag/z6v9kdGfxIylnnmYHwmk1fpLGtyont
FQy52cwi7ABeJPAbVqkij/6aSfgIV/oBm7qHRDCmrCDTH4/TvCUyv1gjOgdAA0Hd
JaOeUPZdt5XfvrHQ5D0RBsZ95dATz+CSSPgdw+zTX9ZdAOfRGUc2nNO78P2jqBWE
QAmGFKEB44w57EQqxBxjvvoktKFF0A==
=7ofu
-----END PGP SIGNATURE-----

--x6efmyvh5j354i5q--
