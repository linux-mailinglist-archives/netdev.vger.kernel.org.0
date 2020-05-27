Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27E641E51F8
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgE0XqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 19:46:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgE0XqU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 19:46:20 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87622C08C5C1;
        Wed, 27 May 2020 16:46:16 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id z5so30117870ejb.3;
        Wed, 27 May 2020 16:46:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AdKVO2Q7xtOtZd00IpF5kdS9NRgMnyg+vSOXHZlKsRw=;
        b=FJQ2iAHVdTtJGGfIpKgWMx6kF9SVLMHDrN3eCUSypHJSvqoSNr4fDZpN4U5KCSH4gb
         /g0SmOtaTq8RD6zLQOXfl18Hd70vxFotKSO2VmSnkx/vLO/uzjaxpaxbhm/gYHErnzPK
         OqAqvs4vxMj5UAIMrjeabActGqbeuDReP49RnAJAbTnyCr1f8bEGoJiV4GBYSsbpKIt/
         pa9gxqtSvVYAaf3F3/wimrqrACRhMS91Vwe6+hHIaRFOgx7DuB0O3Z/DjQ9k91KG1uzi
         VdIjcjNYbuX+i9vmteXDMC9wMjYzUH/ANOkCyEImJXc4mWrqtAVIMORrKy98SR4cD0He
         K5vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AdKVO2Q7xtOtZd00IpF5kdS9NRgMnyg+vSOXHZlKsRw=;
        b=rdyVU+1ny7uNKVfeHAzZrWftX97IMPDCzzmUw+UrDuWHe95lF+RMs5Uyj9dG8B5p1m
         UnrMU5QQ5kyONJ2QfUkn+A1i64e0W+VhR9Is5YhK/ckJBYkFJ7bAPcx2t2TMHJ86R2C7
         93AQJdG/LsP6OaTC3+ef9nRSITs03nRjztB0ZtaTu6XHXIwkDbD5nGmYue2LipAEsux2
         JtiJLWLURdWGpBBh5SC0DZGPyWAO7AeXq773m5b5rluMalyXCEqzEQZq6fiswHdFwFZa
         dROWY3RuN4RncBIWm4EetXhQMI5nKlbTGXVZwOuZgHawKTxZWahVqjW7NA0Uk96+M8ua
         jP+w==
X-Gm-Message-State: AOAM532b+f+4JnLtwcUet6PVMHP41HHwAum3iz6+lOuevlEuokKFXgPx
        rYGj3DUdfqqIZmTVdY3aCd3Ie9PFdOY9kpr8nO0=
X-Google-Smtp-Source: ABdhPJwjJaywda3/670EGBi9Gbl6rkX2/3ATn18lKzo7v3hZconRH62B7H2FE1ugyViMQT4N9qG5CHpPklncySUgfAI=
X-Received: by 2002:a17:906:a0c2:: with SMTP id bh2mr661749ejb.406.1590623175261;
 Wed, 27 May 2020 16:46:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200527234113.2491988-1-olteanv@gmail.com> <20200527234113.2491988-2-olteanv@gmail.com>
In-Reply-To: <20200527234113.2491988-2-olteanv@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Thu, 28 May 2020 02:46:04 +0300
Message-ID: <CA+h21hpdVuZXh38ZG-V6v745oNjo6BpiZtEdKookOn4FDeM0qg@mail.gmail.com>
Subject: Re: [PATCH net-next 01/11] regmap: add helper for per-port regfield initialization
To:     "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Antoine Tenart <antoine.tenart@bootlin.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 at 02:41, Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Similar to the standalone regfields, add an initializer for the users
> who need to set .id_size and .id_offset in order to use the
> regmap_fields_update_bits_base API.
>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---

Oops, looks like I forgot to copy Mark on this patch, sorry...
Since you don't have this series in your inbox, here's the patchwork link to it:
https://patchwork.ozlabs.org/project/netdev/cover/20200527234113.2491988-1-olteanv@gmail.com/

>  include/linux/regmap.h | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/include/linux/regmap.h b/include/linux/regmap.h
> index 40b07168fd8e..87703d105191 100644
> --- a/include/linux/regmap.h
> +++ b/include/linux/regmap.h
> @@ -1134,6 +1134,14 @@ struct reg_field {
>                                 .msb = _msb,    \
>                                 }
>
> +#define REG_FIELD_ID(_reg, _lsb, _msb, _size, _offset) {       \
> +                               .reg = _reg,                    \
> +                               .lsb = _lsb,                    \
> +                               .msb = _msb,                    \
> +                               .id_size = _size,               \
> +                               .id_offset = _offset,           \
> +                               }
> +
>  struct regmap_field *regmap_field_alloc(struct regmap *regmap,
>                 struct reg_field reg_field);
>  void regmap_field_free(struct regmap_field *field);
> --
> 2.25.1
>

Regards,
-Vladimir
