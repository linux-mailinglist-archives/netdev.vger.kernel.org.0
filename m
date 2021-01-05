Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9E92EAB84
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 14:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729786AbhAENHI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 08:07:08 -0500
Received: from mail-oo1-f41.google.com ([209.85.161.41]:44451 "EHLO
        mail-oo1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729620AbhAENHH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 08:07:07 -0500
Received: by mail-oo1-f41.google.com with SMTP id j21so7047536oou.11;
        Tue, 05 Jan 2021 05:06:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dT9NJPB47K2vdQIzb8wF435sR/DGiQQ5DKYTXkvvtR8=;
        b=GKN7JTAsnZ9fl034iGENAg6+byW68dkRbBOOVlAxKVtD87RWPUn9YanDBRfTivy764
         F65uJI19MGWYLEhbtpbY5v/BJg4qzZUvJluurJm+nTfCxkXqP3HeH4mtt7OuCSaxEYO9
         jISEPZ9tmGLRZEoKQwAJM8VPmjlq+WDdlIzC5wcupxandyYCjh7SyemXEfpcX9Kditow
         oifGAnaPO+tZ13Y89syX5eQgbM4tO0vD6JvZ7IlzXyp+sejbwPxP20e/Ez4RFafYZovF
         0jwS86LhT3EGqT+eBLG/KfkSyQkt6laf34UqlcpJnrYmy6MMhT9RXoZR+SGj3BaT5iT3
         npdw==
X-Gm-Message-State: AOAM530tAx5jMYau3k6apoVL4UFb3gwXJfXxOnyiAQ8ez08noVzkMf0x
        Tyrt69/zy2LR4RXesGoWSOmWG2n+l6Z/Cyk7T7Q=
X-Google-Smtp-Source: ABdhPJw6Jr+xDiE7gT045dIEp0A/HetgqtB4/A7vUAniSvrWqo1EZbaLC2kASXOTywmacMmlxtehR7NU7EALegUrog4=
X-Received: by 2002:a4a:c191:: with SMTP id w17mr53201745oop.1.1609851986553;
 Tue, 05 Jan 2021 05:06:26 -0800 (PST)
MIME-Version: 1.0
References: <20201227130407.10991-1-wsa+renesas@sang-engineering.com> <20201227130407.10991-2-wsa+renesas@sang-engineering.com>
In-Reply-To: <20201227130407.10991-2-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 5 Jan 2021 14:06:15 +0100
Message-ID: <CAMuHMdXOQTXfZE1YOWiVdmtwO0ohtS4gkZsxh-+=euJCq=ZCdQ@mail.gmail.com>
Subject: Re: [PATCH 1/5] dt-bindings: net: renesas,etheravb: Add r8a779a0 support
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Sun, Dec 27, 2020 at 2:06 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> Document the compatible value for the RAVB block in the Renesas R-Car
> V3U (R8A779A0) SoC. This variant has no stream buffer, so we only need
> to add the new compatible.
>
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

Thanks for your patch!

> --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> @@ -40,6 +40,7 @@ properties:
>                - renesas,etheravb-r8a77980     # R-Car V3H
>                - renesas,etheravb-r8a77990     # R-Car E3
>                - renesas,etheravb-r8a77995     # R-Car D3
> +              - renesas,etheravb-r8a779a0     # R-Car V3U
>            - const: renesas,etheravb-rcar-gen3 # R-Car Gen3 and RZ/G2
>
>    reg: true

EtherAVB on R-Car V3U does have the Tx clock internal Delay Mode
bit in the APSR register, so its compatible value should be added to
the list of SoCs where tx-internal-delay-ps is required.

With that fixed:
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

The various Counter Registers starting at offset 0x700 are limited to
16-bit values, like on R-Car Gen2, while they support 32-bit values on
other R-Car Gen3 variants. The driver uses only the Transmit Retry Over
Counter Register (TROCR), for statistics, so we can just ignore that
difference.

V3U also has a new block of registers related to UDP/IP support (offset
0x800 and up).  I guess we can just ignore them too, for now.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
