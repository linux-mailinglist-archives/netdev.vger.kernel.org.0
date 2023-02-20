Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C8B69CED1
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 15:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjBTOFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 09:05:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjBTOFk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 09:05:40 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBEF83F1
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:05:39 -0800 (PST)
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com [209.85.160.199])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id EB4553F585
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 14:05:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1676901933;
        bh=dzSoi4QFKSwQF6afiZkQC9N3RdyPdUsM3TO6tUG2yLg=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=oB1ImhX1lPfDvxu5WeGoHEkCEXYCBDiPw7CdOQGzQ8kYOxZa/o1dGVfxUcuJbcCbC
         HqnzioxWinbxLNk+r6XrKNGCqMWMazzw747r7hjdGqF6xEAtyvKlXc6f9Bgcwv3cKq
         aF0NlahJHR1fnzJTaHOCEMK7glSS2wbHmqwjf7dMiZ9t/8+186EFh5CKF2qrE0iEkg
         83Crfa4eeU6LrSYrP8YRE9U0zi1rEvuF/8WYJ6NmYOSYhizrs4C4E5cfcpojNi4Nj7
         XBBoQmJubcp4YfVN5J0XEeYn0/aYOzN5TmYMArYzeYKHqZuAYKXnr8X5/DhjFGruXh
         g7RX4aYUu3lVA==
Received: by mail-qt1-f199.google.com with SMTP id a10-20020ac8720a000000b003ba3c280fabso251839qtp.2
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 06:05:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dzSoi4QFKSwQF6afiZkQC9N3RdyPdUsM3TO6tUG2yLg=;
        b=UbBm1h0kjOAUyFonhJCd0dP5Qa5Vqmxgg5zq+Ua7MdfG0SfcYigwCuxtYhKzJu0Lbn
         6ucByPiTh8A4izgS0usOlrdvCpKNLeMHWO5B+6jPLqGczpnizhwizq3cg/sJE3YY8cDB
         4UyAP5J8I3+Tg9SM6WwU41XPGa7EuPdPSJbnkh2J8jSPJ5KBUHIfROQ507CmILVWWdGi
         n3fSRNxwHhqm7aGwHHdQ12hR2P7p738yN8vTRbKQx7fL2n/52iDFrV36IKr03ZKAwESX
         X7TbmKfI1m28/74I4op6VzHyPDlTjwT0jsNveudo2GqQxuU7FZ9NGc/1vXTxC18dE5Pj
         roeQ==
X-Gm-Message-State: AO0yUKW1vf6lQfZSMqMOjdYTPmsM1w+3mEXYmYbbH7l/9dIpvXm9PXk0
        sX89Ezj+1M53GsYh6wHg70suLXs5x9US9h+a4aJIE06ZRkXG0uaL3URh70liRZcNi2mLR7PglTE
        rVCfrT8TK3RCtua7Hp4/fbyJp8C5PC7YbzLzs/SYbGOO2bb2q1WCRct4=
X-Received: by 2002:a0c:d990:0:b0:570:fc87:4f2c with SMTP id y16-20020a0cd990000000b00570fc874f2cmr292633qvj.83.1676901932971;
        Mon, 20 Feb 2023 06:05:32 -0800 (PST)
X-Google-Smtp-Source: AK7set9+5IcIjvQKZqoR1+axj5VeZiHUAcZlLKVa9weRBzGDTEUyWaKv9QTowi0nMLky06a8W3KysbXpK45taPqjNlI=
X-Received: by 2002:a0c:d990:0:b0:570:fc87:4f2c with SMTP id
 y16-20020a0cd990000000b00570fc874f2cmr292626qvj.83.1676901932733; Mon, 20 Feb
 2023 06:05:32 -0800 (PST)
MIME-Version: 1.0
References: <20230118061701.30047-1-yanhong.wang@starfivetech.com> <20230118061701.30047-8-yanhong.wang@starfivetech.com>
In-Reply-To: <20230118061701.30047-8-yanhong.wang@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Mon, 20 Feb 2023 15:05:17 +0100
Message-ID: <CAJM55Z_a4SN9jYFZqnM9nrL2a-nDzLSGLbXdsTYuf0OrD-c0Fg@mail.gmail.com>
Subject: Re: [PATCH v4 7/7] riscv: dts: starfive: visionfive-v2: Enable gmac
 device tree node
To:     Yanhong Wang <yanhong.wang@starfivetech.com>
Cc:     linux-riscv@lists.infradead.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Jan 2023 at 07:19, Yanhong Wang
<yanhong.wang@starfivetech.com> wrote:
>
> Update gmac device tree node status to okay.
>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> ---
>  .../dts/starfive/jh7110-starfive-visionfive-v2.dts     | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> index c8946cf3a268..b22363d5f9dc 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-v2.dts
> @@ -15,6 +15,8 @@
>
>         aliases {
>                 serial0 = &uart0;
> +               ethernet0 = &gmac0;
> +               ethernet1 = &gmac1;

Hi Yanhong,

Please keep these sorted alphabetically so it's obvious where the next
additions go.

/Emil
>         };
>
>         chosen {
> @@ -114,3 +116,11 @@
>         pinctrl-0 = <&uart0_pins>;
>         status = "okay";
>  };
> +
> +&gmac0 {
> +       status = "okay";
> +};
> +
> +&gmac1 {
> +       status = "okay";
> +};
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
