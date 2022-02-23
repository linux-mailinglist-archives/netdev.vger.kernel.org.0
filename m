Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2BEA4C13FD
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 14:21:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240862AbiBWNWF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 08:22:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238995AbiBWNWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 08:22:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FB1289AD;
        Wed, 23 Feb 2022 05:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3051D6153B;
        Wed, 23 Feb 2022 13:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286A5C340E7;
        Wed, 23 Feb 2022 13:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645622495;
        bh=NEjAGJEK2EcBardBGhHASG5mWZ52oSsb0u9p5fsBxHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qsYu9OdjVbZZNIo6c4pxuj/joNxKPgeIJx3K2j+B1z1tfLFzAJHvwcdPwNS3yr5aP
         js+YdCyBpKT6W4nik30bgfDXJIT+X/+WAtYiqG73tlsbwP8nLPgItGSPYX0ltW+dl5
         06iF6ycvCQAgsVDoUCTxKnB4t/iBbypNSvMv44XOWG1H2PXCmEXrZ0VuD9/EEAjsCD
         U2VdiihFoJnbKW0lUQgZLL1dgp+AHDK1pXZgKCXzYHWAV9IETlGakz5PXgiXRth2oM
         JUyMWT8gGy1uGq3tu/nw6GxH7f9b+qBnysTlf7PmW2pm6rCI8O5U64jPxW1+ap+kK+
         NPEDOLDXIUW1A==
Date:   Wed, 23 Feb 2022 14:21:32 +0100
From:   Wolfram Sang <wsa@kernel.org>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: [PATCH v4 2/7] i2c: core: Use generic_handle_irq_safe() in
 i2c_handle_smbus_host_notify().
Message-ID: <YhY03EojmT3eaIcR@ninjato>
Mail-Followup-To: Wolfram Sang <wsa@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        greybus-dev@lists.linaro.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-staging@lists.linux.dev,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, Johan Hovold <johan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        Rui Miguel Silva <rmfrfs@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Michael Below <below@judiz.de>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Oleksandr Natalenko <oleksandr@natalenko.name>
References: <20220211181500.1856198-1-bigeasy@linutronix.de>
 <20220211181500.1856198-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Ixnn+B+i7E7l+PX4"
Content-Disposition: inline
In-Reply-To: <20220211181500.1856198-3-bigeasy@linutronix.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Ixnn+B+i7E7l+PX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 11, 2022 at 07:14:55PM +0100, Sebastian Andrzej Siewior wrote:
> The i2c-i801 driver invokes i2c_handle_smbus_host_notify() from his
> interrupt service routine. On PREEMPT_RT i2c-i801's handler is forced
> threaded with enabled interrupts which leads to a warning by
> handle_irq_event_percpu() assuming that irq_default_primary_handler()
> enabled interrupts.
>=20
> i2c-i801's interrupt handler can't be made non-threaded because the
> interrupt line is shared with other devices.
>=20
> Use generic_handle_irq_safe() which can invoked with disabled and enabled
> interrupts.
>=20
> Reported-by: Michael Below <below@judiz.de>
> Link: https://bugs.debian.org/1002537
> Cc: Salvatore Bonaccorso <carnil@debian.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Reviewed-by: Oleksandr Natalenko <oleksandr@natalenko.name>
> Acked-by: Wolfram Sang <wsa@kernel.org>

Is this 5.17 material? Or is 5.18 fine, too?


--Ixnn+B+i7E7l+PX4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAmIWNNwACgkQFA3kzBSg
Kbb+Og/7B9GjktvWSjvXyGx8u6zTRmbP8AqckDqW20DFq10TBwnbZX+Qrqyq2fIs
pJwKZ0d95Q1wWJGGRQP7VVHOeuH5SLPkc8P2QMMpR8y4L87MXcPR/+mx5a+Pbjcw
5DpXa6uKUGD42GoqnoKWLM60ettiXIaGQJeRKM9/1ZKnKH1BtOcur3AocKnRXOJI
g0X33ZFF8XFVw2GeuLIaPALgue4Y2CgPUmPMoDqEFHd7ycedpE/7GS7RUQeusmor
IZbCnofT2yldiBT6T76HZXJ/T/gVlyAnMpJeei9ynp+/kfej+kUXeE/GjfV33mGd
0gBaBeek1ED5f7+bpSV5ZHlnxWLvk4UQ+Kq3hR7iVPHz8dCUuqay+rDdhxVHp2BT
d4KiQyqRoZKjnxz7Zu200XK1wm2aADq/jFd0AD/I3AiHz1KYu8U2YZOOyya9xOGb
cxLZgOna7N++nUXigjzUAhIUgEsuR8S67kp4Rv3NRB5UY9RIzP9lA+DYuHSwR4FJ
+SWRZuhHjGyNCg+wQ+IS4tR9WPLNKbVfELmrbrg0ccR1Tk0rVZWfkGuQ+UkYhjc1
NA3QlYy8cHie9GTf7HbeknoNOT9ABZkClWiEXEK9P7jyjp+7Jot2iDrP25U1935Z
Lj3j30pCuU4zO+B/y/q5KIyKOaj1fbSeS/8wcNdZnqLU8CkYfR8=
=xJ1C
-----END PGP SIGNATURE-----

--Ixnn+B+i7E7l+PX4--
