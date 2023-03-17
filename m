Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B5566BF20A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 21:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCQUA1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 16:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbjCQUA0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 16:00:26 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FD9FBCFFB;
        Fri, 17 Mar 2023 13:00:25 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id t14so6263227ljd.5;
        Fri, 17 Mar 2023 13:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679083223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xc2lGHPpgu/DRCKreLgHiZtKJKO1+G4Y1srFLcfZF4E=;
        b=AIfEy5L0L388FXvjyfX1/OqmVKv+7boQbZdzn41UyftfP07C7yOEyV8NCpju9VtldA
         YLF0ynxmyPf2luAXSUt5NLS8g1OB3iRc3ojv1d/5t8FkjkNLr/K/N9xmmEPRhFfJNx4/
         LTnogvUnDK0iIizdLvkXilI/ykdSUqhAumWDISrFesJT/XBcrgzDf/wWKjflYWsuHMTO
         vTMXvDacmVZkuEpmj50siEGn9YKoAbjVPZTAFoRCTwh44IVckaU1N2Gl+DQfRRvvZU0F
         JVcH9dePvXZkgg2naJ85K8FXkZvC3McxVlvgjJEm074AFG0BbUgCMrDTwVHCbYW38FJE
         RTHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679083223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Xc2lGHPpgu/DRCKreLgHiZtKJKO1+G4Y1srFLcfZF4E=;
        b=a0NiS8aXFkZTUXJqWB1pPcwf0qqYymCSDk5AsUE8IFijEE/alTLNz5JoZ7jy/tvPkZ
         +UxvYLLwK7PRQfXE4vUZrlKe3BQTHwR41RaqcdH7ZN7BN9lDSZQd+n37MwayX6Cw7864
         Ss6IkaQQ5YwVaoDalGElB6pA6XkXEHNr9oL5dvLqB7txKLgywirHXGeyfxIHRDzs9UDM
         hDQHHAnLnf+h63TWEMU6+bhdsreMMFbyNLDBA+y42b2keEwxUNDRYtNK8q7udW8+nOD9
         3ghfREq2QdTeZHDEoJnvHF3tRtw+pRyO5sRFF71VEV6lC0DWCNz90AUfM+lBkwO7AIq5
         Q8/w==
X-Gm-Message-State: AO0yUKWwRXgSEdFuxY68VsnFjzw3lIB1caZBSkBBfceCclEoya1iYV1+
        7gmbNkoL4DqKAWO+U3Z7gxyXw36V3RyySNCwTjT+NJVx
X-Google-Smtp-Source: AK7set8skRhUDSDeo0pVL2XjF3zMvdW33sDmsS/iDjL7o4uZId2qyxOoofkIH2f/tKbtbjlE0DqhoIrmT/93S/NOL0w=
X-Received: by 2002:a2e:3005:0:b0:299:ac68:4801 with SMTP id
 w5-20020a2e3005000000b00299ac684801mr1950772ljw.0.1679083223248; Fri, 17 Mar
 2023 13:00:23 -0700 (PDT)
MIME-Version: 1.0
References: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
In-Reply-To: <20230316172214.3899786-1-neeraj.sanjaykale@nxp.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Fri, 17 Mar 2023 13:00:11 -0700
Message-ID: <CABBYNZ+DM+DKYVb-EqRX+WwW2hCrcVeMh29PVjqTM0WW2+HBuw@mail.gmail.com>
Subject: Re: [PATCH v13 0/4] Add support for NXP bluetooth chipsets
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, gregkh@linuxfoundation.org,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Neeraj,

On Thu, Mar 16, 2023 at 10:22=E2=80=AFAM Neeraj Sanjay Kale
<neeraj.sanjaykale@nxp.com> wrote:
>
> This patch adds a driver for NXP bluetooth chipsets.
>
> The driver is based on H4 protocol, and uses serdev APIs. It supports hos=
t
> to chip power save feature, which is signalled by the host by asserting
> break over UART TX lines, to put the chip into sleep state.
>
> To support this feature, break_ctl has also been added to serdev-tty alon=
g
> with a new serdev API serdev_device_break_ctl().
>
> This driver is capable of downloading firmware into the chip over UART.
>
> The document specifying device tree bindings for this driver is also
> included in this patch series.
>
> Neeraj Sanjay Kale (4):
>   serdev: Replace all instances of ENOTSUPP with EOPNOTSUPP
>   serdev: Add method to assert break signal over tty UART port
>   dt-bindings: net: bluetooth: Add NXP bluetooth support
>   Bluetooth: NXP: Add protocol support for NXP Bluetooth chipsets
>
>  .../net/bluetooth/nxp,88w8987-bt.yaml         |   45 +
>  MAINTAINERS                                   |    7 +
>  drivers/bluetooth/Kconfig                     |   12 +
>  drivers/bluetooth/Makefile                    |    1 +
>  drivers/bluetooth/btnxpuart.c                 | 1297 +++++++++++++++++
>  drivers/tty/serdev/core.c                     |   17 +-
>  drivers/tty/serdev/serdev-ttyport.c           |   16 +-
>  include/linux/serdev.h                        |   10 +-
>  8 files changed, 1398 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,8=
8w8987-bt.yaml
>  create mode 100644 drivers/bluetooth/btnxpuart.c
>
> --
> 2.34.1

If there are no new comments to be addressed by the end of the day I'm
planning to merge this into bluetooth-next.

--=20
Luiz Augusto von Dentz
