Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B02C6ADEA8
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 13:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231177AbjCGM0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 07:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbjCGM0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 07:26:39 -0500
Received: from mail-lj1-x22e.google.com (mail-lj1-x22e.google.com [IPv6:2a00:1450:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32745769DD
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 04:26:34 -0800 (PST)
Received: by mail-lj1-x22e.google.com with SMTP id f16so12919390ljq.10
        for <netdev@vger.kernel.org>; Tue, 07 Mar 2023 04:26:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20210112.gappssmtp.com; s=20210112; t=1678191992;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/OEdPV91yfX2/+4I17IoxuO2WNbLZIKUCMJCjGB1wIc=;
        b=ckIdwELevonqyF+EE3+wONQeHT5/SZw9d+Vpy8thxp/R9CuENKQwt6UI0prnRdBDh7
         QEoHIYTFou1M5xu6AwjSAwLC21FT9M4+qHYBzJky5Y0/wvubg6YJd1i0oslq3hoyCwNQ
         QhMiuyVbvR/0RAHUQSVav7rXBrjIiw0/kYXaNAWRT/WusDofgAIq0+Pvyd0gepJKF5xz
         9t0418GEmN/2QtgySDyaFaIS2NXOc+NBRkIphQZjaZjQ2s8YwNA4XPfqDa9g8AKxjHcF
         IN4aguvv53YPyV4wFHFKodRn7tIjpzUrNjkN6zyzR1wSRQgpAWC94qzn2ywSnB6++Owi
         6GjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678191992;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/OEdPV91yfX2/+4I17IoxuO2WNbLZIKUCMJCjGB1wIc=;
        b=7QiQM0crmcOfN3qih5vwmfGhfaSViH9M3SVTSCOW/OhzEhneieV26GSA9OQv9DZ1zX
         Qgxfp7JGer3Ch1KxHmkGg7QbButrXKYpSdS6iKXhX1fh7qCpxvJK0SXi/iJWpq918CNc
         CxWEDI/vWEovcXTLDhmVgYvUUkYWa6UIHuHg1/jr/BB9b5jwrvXYdyKkWQSOzXTNkQRN
         rcvWRgYdtwUnEo/pbHZfA1lQNB4bTYjjaLYUmxYbje7ZWWRU1CftUWrKJXIiEqmQQ68+
         v7vwRJ1HFwe9HqQ3DWp7hZZ5qBiHbCIkwSzJbvXiU5SKCE3mqNsIzySWpisBoo8KTnnq
         Jovg==
X-Gm-Message-State: AO0yUKUt3Rr5EJ9icQe83tq3d8Swz4bxjPBg4FvB5fuD+6bzRVBg1lyw
        0hSUS+kvJS0UKxD+tht9o34RgDLEw+/tzrsT9JI=
X-Google-Smtp-Source: AK7set+LzfDdU1MYJvLtQMFKgYYbPbRwOnXsc+P/e3cAl2WfmWRESugiqVytbVc05DDYy6sCZwwe/A==
X-Received: by 2002:a05:651c:508:b0:295:9ba0:6411 with SMTP id o8-20020a05651c050800b002959ba06411mr7137068ljp.15.1678191992123;
        Tue, 07 Mar 2023 04:26:32 -0800 (PST)
Received: from wkz-x13 (a124.broadband3.quicknet.se. [46.17.184.124])
        by smtp.gmail.com with ESMTPSA id c13-20020a05651c014d00b002945b851ea5sm2150112ljd.21.2023.03.07.04.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 04:26:31 -0800 (PST)
From:   Tobias Waldekranz <tobias@waldekranz.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sean Anderson <sean.anderson@seco.com>
Subject: Re: [PATCH net-next] net: mdio: Add netlink interface
In-Reply-To: <20230306204517.1953122-1-sean.anderson@seco.com>
References: <20230306204517.1953122-1-sean.anderson@seco.com>
Date:   Tue, 07 Mar 2023 13:26:30 +0100
Message-ID: <874jqwkart.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On m=C3=A5n, mar 06, 2023 at 15:45, Sean Anderson <sean.anderson@seco.com> =
wrote:
> This adds a netlink interface to make reads/writes to mdio buses. This
> makes it easier to debug devices. This is especially useful when there
> is a PCS involved (and the ethtool reads are faked), when there is no
> MAC associated with a PHY, or when the MDIO device is not a PHY.
>
> The closest existing in-kernel interfaces are the SIOCG/SMIIREG ioctls, b=
ut
> they have several drawbacks:
>
> 1. "Write register" is not always exactly that. The kernel will try to
>    be extra helpful and do things behind the scenes if it detects a
>    write to the reset bit of a PHY for example.
>
> 2. Only one op per syscall. This means that is impossible to implement
>    many operations in a safe manner. Something as simple as a
>    read/mask/write cycle can race against an in-kernel driver.
>
> 3. Addressing is awkward since you don't address the MDIO bus
>    directly, rather "the MDIO bus to which this netdev's PHY is
>    connected". This makes it hard to talk to devices on buses to which
>    no PHYs are connected, the typical case being Ethernet switches.
>
> To address these shortcomings, this adds a GENL interface with which a us=
er
> can interact with an MDIO bus directly.  The user sends a program that
> mdio-netlink executes, possibly emitting data back to the user. I.e. it
> implements a very simple VM. Read/mask/write operations could be
> implemented by dedicated commands, but when you start looking at more
> advanced things like reading out the VLAN database of a switch you need
> state and branching.
>
> To prevent userspace phy drivers, writes are disabled by default, and can
> only be enabled by editing the source. This is the same strategy used by
> regmap for debugfs writes. Unfortunately, this disallows several useful
> features, including
>
> - Register writes (obviously)
> - C45-over-C22
> - Atomic access to paged registers
> - Better MDIO emulation for e.g. QEMU
>
> However, the read-only interface remains broadly useful for debugging.
> Users who want to use the above features can re-enable them by defining
> MDIO_NETLINK_ALLOW_WRITE and recompiling their kernel.

What about taking a page from the BPF playbook and require all loaded
programs (MDIO_GENL_XFERs) to be licensed under GPL?  That would mean
that the userspace program that generated it would also have to be
GPLed.

My view has always been that a vendor looking to build a userspace SDK
won't be deterred by this limitation.  They can easily build
mdio-netlink.ko from mdio-tools and use that to drive it, or (more
likely) they already have their own implementation that they are stuck
with for legacy reasons.  In other words: we are only punishing
legitimate users (mdio-tools being one of them, IMO).

Perhaps with this approach we could have our cake and eat it too.

> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> This driver was written by Tobias Waldekranz. It is adapted from the
> version he released with mdio-tools [1]. This was last discussed 2.5
> years ago [2], and I have incorperated his cover letter into this commit
> message. The discussion mainly centered around the write capability
> allowing for userspace phy drivers. Although it comes with reduced
> functionality, I hope this new approach satisfies Andrew. I have also
> made several minor changes for style and to stay abrest of changing
> APIs.
>
> Tobias, I've taken the liberty of adding some copyright notices
> attributing this to you.

Fine by me :)

> [1] https://github.com/wkz/mdio-tools
> [2] https://lore.kernel.org/netdev/C42DZQLTPHM5.2THDSRK84BI3T@wkz-x280/
>
>  drivers/net/mdio/Kconfig          |   8 +
>  drivers/net/mdio/Makefile         |   1 +
>  drivers/net/mdio/mdio-netlink.c   | 464 ++++++++++++++++++++++++++++++
>  include/uapi/linux/mdio-netlink.h |  61 ++++
>  4 files changed, 534 insertions(+)
>  create mode 100644 drivers/net/mdio/mdio-netlink.c
>  create mode 100644 include/uapi/linux/mdio-netlink.h
>
> diff --git a/drivers/net/mdio/Kconfig b/drivers/net/mdio/Kconfig
> index 90309980686e..8a01978e5b51 100644
> --- a/drivers/net/mdio/Kconfig
> +++ b/drivers/net/mdio/Kconfig
> @@ -43,6 +43,14 @@ config ACPI_MDIO
>=20=20
>  if MDIO_BUS
>=20=20
> +config MDIO_NETLINK
> +	tristate "Netlink interface for MDIO buses"
> +	help
> +	  Enable a netlink interface to allow reading MDIO buses from
> +	  userspace. A small virtual machine allows implementing complex
> +	  operations, such as conditional reads or polling. All operations
> +	  submitted in the same program are evaluated atomically.
> +
>  config MDIO_DEVRES
>  	tristate
>=20=20
> diff --git a/drivers/net/mdio/Makefile b/drivers/net/mdio/Makefile
> index 7d4cb4c11e4e..5583d5b8d174 100644
> --- a/drivers/net/mdio/Makefile
> +++ b/drivers/net/mdio/Makefile
> @@ -4,6 +4,7 @@
>  obj-$(CONFIG_ACPI_MDIO)		+=3D acpi_mdio.o
>  obj-$(CONFIG_FWNODE_MDIO)	+=3D fwnode_mdio.o
>  obj-$(CONFIG_OF_MDIO)		+=3D of_mdio.o
> +obj-$(CONFIG_MDIO_NETLINK)	+=3D mdio-netlink.o
>=20=20
>  obj-$(CONFIG_MDIO_ASPEED)		+=3D mdio-aspeed.o
>  obj-$(CONFIG_MDIO_BCM_IPROC)		+=3D mdio-bcm-iproc.o
> diff --git a/drivers/net/mdio/mdio-netlink.c b/drivers/net/mdio/mdio-netl=
ink.c
> new file mode 100644
> index 000000000000..3e32d1a9bab3
> --- /dev/null
> +++ b/drivers/net/mdio/mdio-netlink.c
> @@ -0,0 +1,464 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) 2022-23 Sean Anderson <sean.anderson@seco.com>
> + * Copyright (C) 2020-22 Tobias Waldekranz <tobias@waldekranz.com>
> + */
> +
> +#include <linux/init.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/netlink.h>
> +#include <linux/phy.h>
> +#include <net/genetlink.h>
> +#include <net/netlink.h>
> +#include <uapi/linux/mdio-netlink.h>
> +
> +struct mdio_nl_xfer {
> +	struct genl_info *info;
> +	struct sk_buff *msg;
> +	void *hdr;
> +	struct nlattr *data;
> +
> +	struct mii_bus *mdio;
> +	int timeout_ms;
> +
> +	int prog_len;
> +	struct mdio_nl_insn *prog;
> +};
> +
> +static int mdio_nl_open(struct mdio_nl_xfer *xfer);
> +static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr);
> +
> +static int mdio_nl_flush(struct mdio_nl_xfer *xfer)
> +{
> +	int err;
> +
> +	err =3D mdio_nl_close(xfer, false, 0);
> +	if (err)
> +		return err;
> +
> +	return mdio_nl_open(xfer);
> +}
> +
> +static int mdio_nl_emit(struct mdio_nl_xfer *xfer, u32 datum)
> +{
> +	int err =3D 0;
> +
> +	if (!nla_put_nohdr(xfer->msg, sizeof(datum), &datum))
> +		return 0;
> +
> +	err =3D mdio_nl_flush(xfer);
> +	if (err)
> +		return err;
> +
> +	return nla_put_nohdr(xfer->msg, sizeof(datum), &datum);
> +}
> +
> +static inline u16 *__arg_r(u32 arg, u16 *regs)
> +{
> +	WARN_ON_ONCE(arg >> 16 !=3D MDIO_NL_ARG_REG);
> +
> +	return &regs[arg & 0x7];
> +}
> +
> +static inline u16 __arg_i(u32 arg)
> +{
> +	WARN_ON_ONCE(arg >> 16 !=3D MDIO_NL_ARG_IMM);
> +
> +	return arg & 0xffff;
> +}
> +
> +static inline u16 __arg_ri(u32 arg, u16 *regs)
> +{
> +	switch ((enum mdio_nl_argmode)(arg >> 16)) {
> +	case MDIO_NL_ARG_IMM:
> +		return arg & 0xffff;
> +	case MDIO_NL_ARG_REG:
> +		return regs[arg & 7];
> +	default:
> +		WARN_ON_ONCE(1);
> +		return 0;
> +	}
> +}
> +
> +/* To prevent out-of-tree drivers from being implemented through this
> + * interface, disallow writes by default. This does disallow read-only u=
ses,
> + * such as c45-over-c22 or reading phys with pages. However, with a such=
 a
> + * flexible interface, we must use a big hammer. People who want to use =
this
> + * will need to modify the source code directly.
> + */
> +#undef MDIO_NETLINK_ALLOW_WRITE
> +
> +static int mdio_nl_eval(struct mdio_nl_xfer *xfer)
> +{
> +	struct mdio_nl_insn *insn;
> +	unsigned long timeout;
> +	u16 regs[8] =3D { 0 };
> +	int pc, ret =3D 0;
> +	int phy_id, reg, prtad, devad, val;
> +
> +	timeout =3D jiffies + msecs_to_jiffies(xfer->timeout_ms);
> +
> +	mutex_lock(&xfer->mdio->mdio_lock);
> +
> +	for (insn =3D xfer->prog, pc =3D 0;
> +	     pc < xfer->prog_len;
> +	     insn =3D &xfer->prog[++pc]) {
> +		if (time_after(jiffies, timeout)) {
> +			ret =3D -ETIMEDOUT;
> +			break;
> +		}
> +
> +		switch ((enum mdio_nl_op)insn->op) {
> +		case MDIO_NL_OP_READ:
> +			phy_id =3D __arg_ri(insn->arg0, regs);
> +			prtad =3D mdio_phy_id_prtad(phy_id);
> +			devad =3D mdio_phy_id_devad(phy_id);
> +			reg =3D __arg_ri(insn->arg1, regs);
> +
> +			if (mdio_phy_id_is_c45(phy_id))
> +				ret =3D __mdiobus_c45_read(xfer->mdio, prtad,
> +							 devad, reg);
> +			else
> +				ret =3D __mdiobus_read(xfer->mdio, phy_id, reg);
> +
> +			if (ret < 0)
> +				goto exit;
> +			*__arg_r(insn->arg2, regs) =3D ret;
> +			ret =3D 0;
> +			break;
> +
> +		case MDIO_NL_OP_WRITE:
> +			phy_id =3D __arg_ri(insn->arg0, regs);
> +			prtad =3D mdio_phy_id_prtad(phy_id);
> +			devad =3D mdio_phy_id_devad(phy_id);
> +			reg =3D __arg_ri(insn->arg1, regs);
> +			val =3D __arg_ri(insn->arg2, regs);
> +
> +#ifdef MDIO_NETLINK_ALLOW_WRITE
> +			add_taint(TAINT_USER, LOCKDEP_STILL_OK);
> +			if (mdio_phy_id_is_c45(phy_id))
> +				ret =3D __mdiobus_c45_write(xfer->mdio, prtad,
> +							  devad, reg, val
> +			else
> +				ret =3D __mdiobus_write(xfer->mdio, dev, reg,
> +						      val);
> +#else
> +			ret =3D -EPERM;
> +#endif
> +			if (ret < 0)
> +				goto exit;
> +			ret =3D 0;
> +			break;
> +
> +		case MDIO_NL_OP_AND:
> +			*__arg_r(insn->arg2, regs) =3D
> +				__arg_ri(insn->arg0, regs) &
> +				__arg_ri(insn->arg1, regs);
> +			break;
> +
> +		case MDIO_NL_OP_OR:
> +			*__arg_r(insn->arg2, regs) =3D
> +				__arg_ri(insn->arg0, regs) |
> +				__arg_ri(insn->arg1, regs);
> +			break;
> +
> +		case MDIO_NL_OP_ADD:
> +			*__arg_r(insn->arg2, regs) =3D
> +				__arg_ri(insn->arg0, regs) +
> +				__arg_ri(insn->arg1, regs);
> +			break;
> +
> +		case MDIO_NL_OP_JEQ:
> +			if (__arg_ri(insn->arg0, regs) =3D=3D
> +			    __arg_ri(insn->arg1, regs))
> +				pc +=3D (s16)__arg_i(insn->arg2);
> +			break;
> +
> +		case MDIO_NL_OP_JNE:
> +			if (__arg_ri(insn->arg0, regs) !=3D
> +			    __arg_ri(insn->arg1, regs))
> +				pc +=3D (s16)__arg_i(insn->arg2);
> +			break;
> +
> +		case MDIO_NL_OP_EMIT:
> +			ret =3D mdio_nl_emit(xfer, __arg_ri(insn->arg0, regs));
> +			if (ret < 0)
> +				goto exit;
> +			ret =3D 0;
> +			break;
> +
> +		case MDIO_NL_OP_UNSPEC:
> +		default:
> +			ret =3D -EINVAL;
> +			goto exit;
> +		}
> +	}
> +exit:
> +	mutex_unlock(&xfer->mdio->mdio_lock);
> +	return ret;
> +}
> +
> +struct mdio_nl_op_proto {
> +	u8 arg0;
> +	u8 arg1;
> +	u8 arg2;
> +};
> +
> +static const struct mdio_nl_op_proto mdio_nl_op_protos[MDIO_NL_OP_MAX + =
1] =3D {
> +	[MDIO_NL_OP_READ] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_REG),
> +	},
> +	[MDIO_NL_OP_WRITE] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +	},
> +	[MDIO_NL_OP_AND] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_REG),
> +	},
> +	[MDIO_NL_OP_OR] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_REG),
> +	},
> +	[MDIO_NL_OP_ADD] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_REG),
> +	},
> +	[MDIO_NL_OP_JEQ] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_IMM),
> +	},
> +	[MDIO_NL_OP_JNE] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg2 =3D BIT(MDIO_NL_ARG_IMM),
> +	},
> +	[MDIO_NL_OP_EMIT] =3D {
> +		.arg0 =3D BIT(MDIO_NL_ARG_REG) | BIT(MDIO_NL_ARG_IMM),
> +		.arg1 =3D BIT(MDIO_NL_ARG_NONE),
> +		.arg2 =3D BIT(MDIO_NL_ARG_NONE),
> +	},
> +};
> +
> +static int mdio_nl_validate_insn(const struct nlattr *attr,
> +				 struct netlink_ext_ack *extack,
> +				 const struct mdio_nl_insn *insn)
> +{
> +	const struct mdio_nl_op_proto *proto;
> +
> +	if (insn->op > MDIO_NL_OP_MAX) {
> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Illegal instruction");
> +		return -EINVAL;
> +	}
> +
> +	proto =3D &mdio_nl_op_protos[insn->op];
> +
> +	if (!(BIT(insn->arg0 >> 16) & proto->arg0)) {
> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 0 invalid");
> +		return -EINVAL;
> +	}
> +
> +	if (!(BIT(insn->arg1 >> 16) & proto->arg1)) {
> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 1 invalid");
> +		return -EINVAL;
> +	}
> +
> +	if (!(BIT(insn->arg2 >> 16) & proto->arg2)) {
> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Argument 2 invalid");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static int mdio_nl_validate_prog(const struct nlattr *attr,
> +				 struct netlink_ext_ack *extack)
> +{
> +	const struct mdio_nl_insn *prog =3D nla_data(attr);
> +	int len =3D nla_len(attr);
> +	int i, err =3D 0;
> +
> +	if (len % sizeof(*prog)) {
> +		NL_SET_ERR_MSG_ATTR(extack, attr, "Unaligned instruction");
> +		return -EINVAL;
> +	}
> +
> +	len /=3D sizeof(*prog);
> +	for (i =3D 0; i < len; i++) {
> +		err =3D mdio_nl_validate_insn(attr, extack, &prog[i]);
> +		if (err)
> +			break;
> +	}
> +
> +	return err;
> +}
> +
> +static const struct nla_policy mdio_nl_policy[MDIO_NLA_MAX + 1] =3D {
> +	[MDIO_NLA_UNSPEC]  =3D { .type =3D NLA_UNSPEC, },
> +	[MDIO_NLA_BUS_ID]  =3D { .type =3D NLA_STRING, .len =3D MII_BUS_ID_SIZE=
 },
> +	[MDIO_NLA_TIMEOUT] =3D NLA_POLICY_MAX(NLA_U16, 10 * MSEC_PER_SEC),
> +	[MDIO_NLA_PROG]    =3D NLA_POLICY_VALIDATE_FN(NLA_BINARY,
> +						    mdio_nl_validate_prog,
> +						    0x1000),
> +	[MDIO_NLA_DATA]    =3D { .type =3D NLA_NESTED },
> +	[MDIO_NLA_ERROR]   =3D { .type =3D NLA_S32, },
> +};
> +
> +static struct genl_family mdio_nl_family;
> +
> +static int mdio_nl_open(struct mdio_nl_xfer *xfer)
> +{
> +	int err;
> +
> +	xfer->msg =3D nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
> +	if (!xfer->msg) {
> +		err =3D -ENOMEM;
> +		goto err;
> +	}
> +
> +	xfer->hdr =3D genlmsg_put(xfer->msg, xfer->info->snd_portid,
> +				xfer->info->snd_seq, &mdio_nl_family,
> +				NLM_F_ACK | NLM_F_MULTI, MDIO_GENL_XFER);
> +	if (!xfer->hdr) {
> +		err =3D -EMSGSIZE;
> +		goto err_free;
> +	}
> +
> +	xfer->data =3D nla_nest_start(xfer->msg, MDIO_NLA_DATA);
> +	if (!xfer->data) {
> +		err =3D -EMSGSIZE;
> +		goto err_free;
> +	}
> +
> +	return 0;
> +
> +err_free:
> +	nlmsg_free(xfer->msg);
> +err:
> +	return err;
> +}
> +
> +static int mdio_nl_close(struct mdio_nl_xfer *xfer, bool last, int xerr)
> +{
> +	struct nlmsghdr *end;
> +	int err;
> +
> +	nla_nest_end(xfer->msg, xfer->data);
> +
> +	if (xerr && nla_put_s32(xfer->msg, MDIO_NLA_ERROR, xerr)) {
> +		err =3D mdio_nl_flush(xfer);
> +		if (err)
> +			goto err_free;
> +
> +		if (nla_put_s32(xfer->msg, MDIO_NLA_ERROR, xerr)) {
> +			err =3D -EMSGSIZE;
> +			goto err_free;
> +		}
> +	}
> +
> +	genlmsg_end(xfer->msg, xfer->hdr);
> +
> +	if (last) {
> +		end =3D nlmsg_put(xfer->msg, xfer->info->snd_portid,
> +				xfer->info->snd_seq, NLMSG_DONE, 0,
> +				NLM_F_ACK | NLM_F_MULTI);
> +		if (!end) {
> +			err =3D mdio_nl_flush(xfer);
> +			if (err)
> +				goto err_free;
> +
> +			end =3D nlmsg_put(xfer->msg, xfer->info->snd_portid,
> +					xfer->info->snd_seq, NLMSG_DONE, 0,
> +					NLM_F_ACK | NLM_F_MULTI);
> +			if (!end) {
> +				err =3D -EMSGSIZE;
> +				goto err_free;
> +			}
> +		}
> +	}
> +
> +	return genlmsg_unicast(genl_info_net(xfer->info), xfer->msg,
> +			       xfer->info->snd_portid);
> +
> +err_free:
> +	nlmsg_free(xfer->msg);
> +	return err;
> +}
> +
> +static int mdio_nl_cmd_xfer(struct sk_buff *skb, struct genl_info *info)
> +{
> +	struct mdio_nl_xfer xfer;
> +	int err;
> +
> +	if (!info->attrs[MDIO_NLA_BUS_ID] ||
> +	    !info->attrs[MDIO_NLA_PROG]   ||
> +	     info->attrs[MDIO_NLA_DATA]   ||
> +	     info->attrs[MDIO_NLA_ERROR])
> +		return -EINVAL;
> +
> +	xfer.mdio =3D mdio_find_bus(nla_data(info->attrs[MDIO_NLA_BUS_ID]));
> +	if (!xfer.mdio)
> +		return -ENODEV;
> +
> +	if (info->attrs[MDIO_NLA_TIMEOUT])
> +		xfer.timeout_ms =3D nla_get_u32(info->attrs[MDIO_NLA_TIMEOUT]);
> +	else
> +		xfer.timeout_ms =3D 100;
> +
> +	xfer.info =3D info;
> +	xfer.prog_len =3D nla_len(info->attrs[MDIO_NLA_PROG]) / sizeof(*xfer.pr=
og);
> +	xfer.prog =3D nla_data(info->attrs[MDIO_NLA_PROG]);
> +
> +	err =3D mdio_nl_open(&xfer);
> +	if (err)
> +		return err;
> +
> +	err =3D mdio_nl_eval(&xfer);
> +
> +	err =3D mdio_nl_close(&xfer, true, err);
> +	return err;
> +}
> +
> +static const struct genl_ops mdio_nl_ops[] =3D {
> +	{
> +		.cmd =3D MDIO_GENL_XFER,
> +		.doit =3D mdio_nl_cmd_xfer,
> +		.flags =3D GENL_ADMIN_PERM,
> +	},
> +};
> +
> +static struct genl_family mdio_nl_family =3D {
> +	.name     =3D "mdio",
> +	.version  =3D 1,
> +	.maxattr  =3D MDIO_NLA_MAX,
> +	.netnsok  =3D false,
> +	.module   =3D THIS_MODULE,
> +	.ops      =3D mdio_nl_ops,
> +	.n_ops    =3D ARRAY_SIZE(mdio_nl_ops),
> +	.policy   =3D mdio_nl_policy,
> +};
> +
> +static int __init mdio_nl_init(void)
> +{
> +	return genl_register_family(&mdio_nl_family);
> +}
> +
> +static void __exit mdio_nl_exit(void)
> +{
> +	genl_unregister_family(&mdio_nl_family);
> +}
> +
> +MODULE_AUTHOR("Tobias Waldekranz <tobias@waldekranz.com>");
> +MODULE_DESCRIPTION("MDIO Netlink Interface");
> +MODULE_LICENSE("GPL");
> +
> +module_init(mdio_nl_init);
> +module_exit(mdio_nl_exit);
> diff --git a/include/uapi/linux/mdio-netlink.h b/include/uapi/linux/mdio-=
netlink.h
> new file mode 100644
> index 000000000000..bebd3b45c882
> --- /dev/null
> +++ b/include/uapi/linux/mdio-netlink.h
> @@ -0,0 +1,61 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +/*
> + * Copyright (C) 2020-22 Tobias Waldekranz <tobias@waldekranz.com>
> + */
> +
> +#ifndef _UAPI_LINUX_MDIO_NETLINK_H
> +#define _UAPI_LINUX_MDIO_NETLINK_H
> +
> +#include <linux/types.h>
> +
> +enum {
> +	MDIO_GENL_UNSPEC,
> +	MDIO_GENL_XFER,
> +
> +	__MDIO_GENL_MAX,
> +	MDIO_GENL_MAX =3D __MDIO_GENL_MAX - 1
> +};
> +
> +enum {
> +	MDIO_NLA_UNSPEC,
> +	MDIO_NLA_BUS_ID,  /* string */
> +	MDIO_NLA_TIMEOUT, /* u32 */
> +	MDIO_NLA_PROG,    /* struct mdio_nl_insn[] */
> +	MDIO_NLA_DATA,    /* nest */
> +	MDIO_NLA_ERROR,   /* s32 */
> +
> +	__MDIO_NLA_MAX,
> +	MDIO_NLA_MAX =3D __MDIO_NLA_MAX - 1
> +};
> +
> +enum mdio_nl_op {
> +	MDIO_NL_OP_UNSPEC,
> +	MDIO_NL_OP_READ,	/* read  dev(RI), port(RI), dst(R) */
> +	MDIO_NL_OP_WRITE,	/* write dev(RI), port(RI), src(RI) */
> +	MDIO_NL_OP_AND,		/* and   a(RI),   b(RI),    dst(R) */
> +	MDIO_NL_OP_OR,		/* or    a(RI),   b(RI),    dst(R) */
> +	MDIO_NL_OP_ADD,		/* add   a(RI),   b(RI),    dst(R) */
> +	MDIO_NL_OP_JEQ,		/* jeq   a(RI),   b(RI),    jmp(I) */
> +	MDIO_NL_OP_JNE,		/* jeq   a(RI),   b(RI),    jmp(I) */
> +	MDIO_NL_OP_EMIT,	/* emit  src(RI) */
> +
> +	__MDIO_NL_OP_MAX,
> +	MDIO_NL_OP_MAX =3D __MDIO_NL_OP_MAX - 1
> +};
> +
> +enum mdio_nl_argmode {
> +	MDIO_NL_ARG_NONE,
> +	MDIO_NL_ARG_REG,
> +	MDIO_NL_ARG_IMM,
> +	MDIO_NL_ARG_RESERVED
> +};
> +
> +struct mdio_nl_insn {
> +	__u64 op:8;
> +	__u64 reserved:2;
> +	__u64 arg0:18;
> +	__u64 arg1:18;
> +	__u64 arg2:18;
> +};
> +
> +#endif /* _UAPI_LINUX_MDIO_NETLINK_H */
> --=20
> 2.35.1.1320.gc452695387.dirty
