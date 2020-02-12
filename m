Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57C2415AB37
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 15:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728422AbgBLOqg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 09:46:36 -0500
Received: from mo4-p02-ob.smtp.rzone.de ([85.215.255.80]:12465 "EHLO
        mo4-p02-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727092AbgBLOqf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 09:46:35 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1581518792;
        s=strato-dkim-0002; d=goldelico.com;
        h=To:References:Message-Id:Cc:Date:In-Reply-To:From:Subject:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=eF0eU+wT6Jz3VQhXmG5csiS9c3rSC4Z9DeL2XQYqdFw=;
        b=SCsGmzWDrloScq92rU+PXSYfAOu0RbAOZ7agPUad+rT+j1Pxyx3f5duf4L0nRwk5mq
        Ms349kTulXSgOtFYrxgy9fRdKaWvGo0wMPOlBKgA/pdpUcHZWVOVcazrl+v76CBuSx6n
        fqmnkzGxlu0fKPkrsui8bbTF7FagUzUESnORojltiAyJMRDel7TpT7MuBuRyfIbEc2sd
        Bos3qm9owufelou5Uk9Ov8wjoATpYpUcoOtCJ6aB4JfFhJGFr9rztH/9K9rzw3OEKwXh
        Jf83TygUD4bZ55MZBFg7838F0xDjroI2h4ynbVy5iGY/wF5aNlIa8aO6Y7EmCXVunOWf
        KqIg==
X-RZG-AUTH: ":JGIXVUS7cutRB/49FwqZ7WcJeFKiMgPgp8VKxflSZ1P34KBj5Qpw97WFDlSbXAgODw=="
X-RZG-CLASS-ID: mo00
Received: from imac.fritz.box
        by smtp.strato.de (RZmta 46.1.12 DYNA|AUTH)
        with ESMTPSA id U06217w1CEkJ4uk
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (curve X9_62_prime256v1 with 256 ECDH bits, eq. 3072 bits RSA))
        (Client did not present a certificate);
        Wed, 12 Feb 2020 15:46:19 +0100 (CET)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 9.3 \(3124\))
Subject: Re: i2c: jz4780: silence log flood on txabrt
From:   "H. Nikolaus Schaller" <hns@goldelico.com>
In-Reply-To: <20200212094628.GB1143@ninjato>
Date:   Wed, 12 Feb 2020 15:46:19 +0100
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        =?utf-8?Q?Petr_=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <213C52CC-E5DC-4641-BE68-3D5C4FEA1FB5@goldelico.com>
References: <cover.1581457290.git.hns@goldelico.com> <7facef52af9cff6ebe26ff321a7fd4f1ac640f74.1581457290.git.hns@goldelico.com> <20200212094628.GB1143@ninjato>
To:     Wolfram Sang <wsa@the-dreams.de>
X-Mailer: Apple Mail (2.3124)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Am 12.02.2020 um 10:46 schrieb Wolfram Sang <wsa@the-dreams.de>:
>=20
>=20
> The printout for txabrt is way too talkative. Reduce it to the =
minimum,
> the rest can be gained by I2C core debugging and datasheet =
information.
> Also, make it a debug printout, it won't help the regular user.
>=20
> Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>=20
> Sorry, normally I don't do counter patches. Yet, this time I realized
> that it would be faster to actually do what I envisioned than to
> describe it in words. I hope you don't feel offended.

No problem. I had thought a little about that myself, but did not
dare to solve more than my problem...

> This driver has
> way too many dev_err anyhow, so this may be a start.
>=20
> Obviously, I can't test, does it work for you?

Yes,it works.

Do you want to push your patch yourself, or should I add it to my
patch series and resubmit in a v2?

BR and thanks,
Nikolaus

>=20
> drivers/i2c/busses/i2c-jz4780.c | 36 ++-------------------------------
> 1 file changed, 2 insertions(+), 34 deletions(-)
>=20
> diff --git a/drivers/i2c/busses/i2c-jz4780.c =
b/drivers/i2c/busses/i2c-jz4780.c
> index 16a67a64284a..b426fc956938 100644
> --- a/drivers/i2c/busses/i2c-jz4780.c
> +++ b/drivers/i2c/busses/i2c-jz4780.c
> @@ -78,25 +78,6 @@
>=20
> #define X1000_I2C_DC_STOP		BIT(9)
>=20
> -static const char * const jz4780_i2c_abrt_src[] =3D {
> -	"ABRT_7B_ADDR_NOACK",
> -	"ABRT_10ADDR1_NOACK",
> -	"ABRT_10ADDR2_NOACK",
> -	"ABRT_XDATA_NOACK",
> -	"ABRT_GCALL_NOACK",
> -	"ABRT_GCALL_READ",
> -	"ABRT_HS_ACKD",
> -	"SBYTE_ACKDET",
> -	"ABRT_HS_NORSTRT",
> -	"SBYTE_NORSTRT",
> -	"ABRT_10B_RD_NORSTRT",
> -	"ABRT_MASTER_DIS",
> -	"ARB_LOST",
> -	"SLVFLUSH_TXFIFO",
> -	"SLV_ARBLOST",
> -	"SLVRD_INTX",
> -};
> -
> #define JZ4780_I2C_INTST_IGC		BIT(11)
> #define JZ4780_I2C_INTST_ISTT		BIT(10)
> #define JZ4780_I2C_INTST_ISTP		BIT(9)
> @@ -576,21 +557,8 @@ static irqreturn_t jz4780_i2c_irq(int irqno, void =
*dev_id)
>=20
> static void jz4780_i2c_txabrt(struct jz4780_i2c *i2c, int src)
> {
> -	int i;
> -
> -	dev_err(&i2c->adap.dev, "txabrt: 0x%08x\n", src);
> -	dev_err(&i2c->adap.dev, "device addr=3D%x\n",
> -		jz4780_i2c_readw(i2c, JZ4780_I2C_TAR));
> -	dev_err(&i2c->adap.dev, "send cmd count:%d  %d\n",
> -		i2c->cmd, i2c->cmd_buf[i2c->cmd]);
> -	dev_err(&i2c->adap.dev, "receive data count:%d  %d\n",
> -		i2c->cmd, i2c->data_buf[i2c->cmd]);
> -
> -	for (i =3D 0; i < 16; i++) {
> -		if (src & BIT(i))
> -			dev_dbg(&i2c->adap.dev, "I2C TXABRT[%d]=3D%s\n",
> -				i, jz4780_i2c_abrt_src[i]);
> -	}
> +	dev_dbg(&i2c->adap.dev, "txabrt: 0x%08x, cmd: %d, send: %d, =
recv: %d\n",
> +		src, i2c->cmd, i2c->cmd_buf[i2c->cmd], =
i2c->data_buf[i2c->cmd]);
> }
>=20
> static inline int jz4780_i2c_xfer_read(struct jz4780_i2c *i2c,
> --=20
> 2.20.1
>=20

