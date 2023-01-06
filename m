Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 981EB660533
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 18:00:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232411AbjAFRAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 12:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjAFRAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 12:00:38 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B1578A7A;
        Fri,  6 Jan 2023 09:00:37 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id q2so2045460ljp.6;
        Fri, 06 Jan 2023 09:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=POLRBla4fWO4DDMyrna7D/MzpTf8F2YLX+r/78ZrUW8=;
        b=a1G1K9KNr9j1bT/MzbZJizjMJHw/9D7ZJJXDzWaUYa0pvsXwbmAABskVdggHKPaV9S
         Mw4HS+E17YTEjN3ffdnsUMXyqMGeb4QLEZ1cedvdy4lgc1XERZ485uEM8eoOVzR+CmJS
         yoQMx/xP8kXNGqkZcPN5yMe2y0w30mg1zSLPcWvecMgynRFT6L/OBmACKsPBzc3fPlvl
         qH6lwkqyroj0SQsp8pTWTzJI8mRAPIBRmAgwwhReYp+JmtlBjFCdLBUcGoFkRguJJwwS
         Vrf0SZZPULirnDA40TVz/3+tMiLHMWFz/E7vVZD4OijIL4MiGvLcswvID5S8086vHhi9
         pCWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=POLRBla4fWO4DDMyrna7D/MzpTf8F2YLX+r/78ZrUW8=;
        b=J9AtWPOPK4//lzymXoguaxG78+0+TGNY+9+dRwfDmk2psY34P6cYjkYw+bCRP3PKrE
         7QrEBFPHmLFRSSnmPMDhVLn00iZ1w6DcV3M+N+VHULkOKkyFn3FHqMVgTL+zWN5HqzmP
         Yv36A+sOc+T5Pk3cVH3dcD8AhndOAv7hJEP96Kkg18f/dOX1Qk0rUajbbFkQOBz1Z8Li
         CerWUPCtLjsQejIZJxet2yXDDAduGNFg2dqduNyZpGsQ4F6VbTkg6TDY7zPHGCK0rkMK
         T3PDKpYrbttAsb/hDd4olhpRzqcvPMyo3mVLPIUQFXoLOyo4MeBY5neDCq7oAl/bgO7l
         OGrQ==
X-Gm-Message-State: AFqh2kofCHMNvJ9JSyhW+Cp4/8CWkYxMP5OBwdq1u/8dT+zsR7RQBHZS
        isUc+qQlZsk6RUHqf/7SFh4w1wl9SEHVbf+tY6aXGkfjCRA6LfW8
X-Google-Smtp-Source: AMrXdXvJse1KDy0QTt2SO3flLiTDVx3NApWbGOr/2H5WEL2Wg9RerY4810wmbeXLv6A0Dx69VS4w5OLUyIvebmds9kk=
X-Received: by 2002:a2e:9d0a:0:b0:27f:d80a:f361 with SMTP id
 t10-20020a2e9d0a000000b0027fd80af361mr2366332lji.433.1673024435790; Fri, 06
 Jan 2023 09:00:35 -0800 (PST)
MIME-Version: 1.0
References: <20230106131905.81854-1-iivanov@suse.de>
In-Reply-To: <20230106131905.81854-1-iivanov@suse.de>
From:   Peter Robinson <pbrobinson@gmail.com>
Date:   Fri, 6 Jan 2023 17:00:24 +0000
Message-ID: <CALeDE9M_AOs_hMdjBtFCYGXXMQzZ-uXK=x8=19GruC+UQN1ESg@mail.gmail.com>
Subject: Re: [PATCH v2] brcmfmac: Prefer DT board type over DMI board type
To:     "Ivan T. Ivanov" <iivanov@suse.de>
Cc:     aspriel@gmail.com, marcan@marcan.st, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, rmk+kernel@armlinux.org.uk,
        stefan.wahren@i2se.com, jforbes@fedoraproject.org,
        kvalo@kernel.org, davem@davemloft.net, devicetree@vger.kernel.org,
        edumazet@google.com, krzysztof.kozlowski+dt@linaro.org,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 6, 2023 at 1:19 PM Ivan T. Ivanov <iivanov@suse.de> wrote:
>
> The introduction of support for Apple board types inadvertently changed
> the precedence order, causing hybrid SMBIOS+DT platforms to look up the
> firmware using the DMI information instead of the device tree compatible
> to generate the board type. Revert back to the old behavior,
> as affected platforms use firmwares named after the DT compatible.
>
> Fixes: 7682de8b3351 ("wifi: brcmfmac: of: Fetch Apple properties")
>
> [1] https://bugzilla.opensuse.org/show_bug.cgi?id=1206697#c13
>
> Cc: stable@vger.kernel.org
> Signed-off-by: Ivan T. Ivanov <iivanov@suse.de>
> Reviewed-by: Hector Martin <marcan@marcan.st>
Tested-by: Peter Robinson <pbrobinson@gmail.com>

Tested on a RPi3B+, a RPi4B and a Rockchips device with 6.2rc2 and it
fixed the issue I had seen on Fedora.

Thanks

> ---
> Changes since v1
> Rewrite commit message according feedback.
> https://lore.kernel.org/all/20230106072746.29516-1-iivanov@suse.de/
>
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> index a83699de01ec..fdd0c9abc1a1 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
> @@ -79,7 +79,8 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>         /* Apple ARM64 platforms have their own idea of board type, passed in
>          * via the device tree. They also have an antenna SKU parameter
>          */
> -       if (!of_property_read_string(np, "brcm,board-type", &prop))
> +       err = of_property_read_string(np, "brcm,board-type", &prop);
> +       if (!err)
>                 settings->board_type = prop;
>
>         if (!of_property_read_string(np, "apple,antenna-sku", &prop))
> @@ -87,7 +88,7 @@ void brcmf_of_probe(struct device *dev, enum brcmf_bus_type bus_type,
>
>         /* Set board-type to the first string of the machine compatible prop */
>         root = of_find_node_by_path("/");
> -       if (root && !settings->board_type) {
> +       if (root && err) {
>                 char *board_type;
>                 const char *tmp;
>
> --
> 2.35.3
>
