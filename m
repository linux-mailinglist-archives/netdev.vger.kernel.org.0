Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 473CE6CBB0D
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbjC1JbO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 05:31:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbjC1JaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 05:30:23 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 628B1769D
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:29:18 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id cf7so14202969ybb.5
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 02:29:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google; t=1679995751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yFB98fl8c+VxJhat2aITQJylt85+D41Na+tueFpnBAE=;
        b=h6Vz5hHsFbSVlybmIlvV3llRGY6zxdMBPqd7vuRnJb91gssIrU+JkHC8x3k8jk99aZ
         TUV+/AV65p6lGjzaxQBmfrutizEWwOo+EZeXN/NHKK4LwatIFW/QwCXbyNZ7bW8Vvnd5
         K2dz4isaG3Fg9/yhee6xJqIWq4kl98h+rwO8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679995751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yFB98fl8c+VxJhat2aITQJylt85+D41Na+tueFpnBAE=;
        b=utArIi5VB59QvXjSVaEJfOnYtGiTIrrv/5U+McT/W6TI63REgMI0fF3960ZQkM9nES
         vUq7zZPiw0odnlEN/UPJdS4jtPgItHNYXGn9azWP3yDeC+Q+5xMcqS8E4xy4bSRaF4lG
         vBK7/LdixHq9HvwtO1/hwMTNYvzXAJhUwbIM75NVe5K3AyOnbSXYs6/8JPBEsta2Q3iZ
         D6rSuYZWI/P001AT9uGlLQFHyi/fc9kkCq3lFFf9LvmVylD+HIU8nmWcyljwXX5zCj7j
         ylMKhp8DQ1cRQSCWAvgkikqG9gvvtpg0mcigR3VpVjMg8qt5QcKrnjDtsgvKxOda9dXP
         /I0g==
X-Gm-Message-State: AAQBX9cDooR/uR6faaQHGkpQawZK4pbYmuZzy9WVpRCmVYOMXjwbCBiy
        khzpP/mEoRm4rFkFru8gquSMr9o8ICMLmWdsHNgyPA==
X-Google-Smtp-Source: AKy350afBwmCZQBALVcAA/Tbw4Xqq5Zxd871dGI57F78yPyqoxYIijJLMdgmt6M0w+Y8hISHOAZdDyJishaV0ICRHKo=
X-Received: by 2002:a05:6902:188f:b0:b78:bced:2e3d with SMTP id
 cj15-20020a056902188f00b00b78bced2e3dmr7396712ybb.3.1679995751012; Tue, 28
 Mar 2023 02:29:11 -0700 (PDT)
MIME-Version: 1.0
References: <20230328073328.3949796-1-dario.binacchi@amarulasolutions.com> <20230328084710.jnrwvydewx3atxti@pengutronix.de>
In-Reply-To: <20230328084710.jnrwvydewx3atxti@pengutronix.de>
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
Date:   Tue, 28 Mar 2023 11:28:59 +0200
Message-ID: <CABGWkvq0gOMw2J9GpLS=w+qg-3xhAst6KN9kvCuZnV9bSBJ3CA@mail.gmail.com>
Subject: Re: [PATCH v10 0/5] can: bxcan: add support for ST bxCAN controller
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-kernel@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Rob Herring <robh@kernel.org>,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        michael@amarulasolutions.com,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Christophe Roullier <christophe.roullier@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Mark Brown <broonie@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Wolfgang Grandegger <wg@grandegger.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-can@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On Tue, Mar 28, 2023 at 10:47=E2=80=AFAM Marc Kleine-Budde <mkl@pengutronix=
.de> wrote:
>
> On 28.03.2023 09:33:23, Dario Binacchi wrote:
> > The series adds support for the basic extended CAN controller (bxCAN)
> > found in many low- to middle-end STM32 SoCs.
> >
> > The driver has been tested on the stm32f469i-discovery board with a
> > kernel version 5.19.0-rc2 in loopback + silent mode:
> >
> > ip link set can0 type can bitrate 125000 loopback on listen-only on
> > ip link set up can0
> > candump can0 -L &
> > cansend can0 300#AC.AB.AD.AE.75.49.AD.D1
> >
> > For uboot and kernel compilation, as well as for rootfs creation I used
> > buildroot:
> >
> > make stm32f469_disco_sd_defconfig
> > make
> >
> > but I had to patch can-utils and busybox as can-utils and iproute are
> > not compiled for MMU-less microcotrollers. In the case of can-utils,
> > replacing the calls to fork() with vfork(), I was able to compile the
> > package with working candump and cansend applications, while in the
> > case of iproute, I ran into more than one problem and finally I decided
> > to extend busybox's ip link command for CAN-type devices. I'm still
> > wondering if it was really necessary, but this way I was able to test
> > the driver.
>
> Applied to linux-can-next.

Just one last question:
To test this series, as described in the cover letter, I could not use
the iproute2
package since the microcontroller is without MMU. I then extended busybox f=
or
the ip link command. I actually also added the rtnl-link-can.c
application to the
libmnl library. So now I find myself with two applications that have
been useful
to me for this type of use case.
Did I do useless work because I could use other tools? If instead the tools=
 for
this use case are missing, what do you think is better to do?
Submit to their respective repos or add this functionality to another
project that
I haven't considered ?

Thanks and regards,
Dario

>
> Thanks,
> Marc
>
> --
> Pengutronix e.K.                 | Marc Kleine-Budde           |
> Embedded Linux                   | https://www.pengutronix.de  |
> Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
> Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |



--=20

Dario Binacchi

Senior Embedded Linux Developer

dario.binacchi@amarulasolutions.com

__________________________________


Amarula Solutions SRL

Via Le Canevare 30, 31100 Treviso, Veneto, IT

T. +39 042 243 5310
info@amarulasolutions.com

www.amarulasolutions.com
