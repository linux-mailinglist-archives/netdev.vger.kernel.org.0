Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A3DE6AC039
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:04:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbjCFNEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:04:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbjCFNEt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:04:49 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 118213ABC
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 05:04:48 -0800 (PST)
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 23D29412B6
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 13:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1678107886;
        bh=GVtu8wUlTQmI/OH1YDjpwQxG8xUfKX4sW1hVlYeaYkE=;
        h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
         To:Cc:Content-Type;
        b=pI4/S8RFRYIf5W0exo1m34g1YuaYb7Pno5haYLyCM9FbZs6TmcxDWOXQj2sXfuFAy
         376KG/sCnbSwMl+monifDBRosYxj4WEN99v6B1cVs3jfQBtK0t0Snu3PNwbIG26Bem
         VY+x/gSNPcH7F2qp5v1G2+DrU1D3XcTUdf2eNLm1zpGB/gq5XJ94OHjSb4Ayx79ygE
         obx+hLD0dB7f4iWOyas9YkYFyH0nS8un5CzbcZER05kevl7Ihbwo/RYEpyYtU1jyFc
         M+/aJAtTV8gWcWhBjrgtsOIORASouANwXINxumoqu7T378Lftt3thPQ5UbmYc1etXc
         EOAnn6ueAU64Q==
Received: by mail-qt1-f200.google.com with SMTP id x4-20020ac85384000000b003bfbb485e2dso5101072qtp.22
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 05:04:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678107884;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GVtu8wUlTQmI/OH1YDjpwQxG8xUfKX4sW1hVlYeaYkE=;
        b=sBzGr/flDQWttLIrZcZw80QZmPTk9f9B4F9wdLh3+4k+vbao1tD+9acCQ83ag/lC64
         eRcld4tz6/NBTqcaWo9ZcARQW21j87/bS/cBYFe+t2Q5HpYhmBFo16ju3RjrTuYnA+pg
         3Za+HEiuVf8dnieBC31a9hk8bv7LOif1WnjRRt1zaMgY9YFcIDoAU0bJVpsV3pL8k0EB
         Mdh+/hZQmijpIiK9wQ8q4ewqUcv/xxykKxXw0Q3yG6Ovsq3LEYx1nw0g8+o++krnyEBI
         iehBpCxiD5TxKrNPZyPp3hKZbLZd7GEc6ViVRcXStLwvcV9WK+ix94lHacF3WQFmnS0j
         eE+A==
X-Gm-Message-State: AO0yUKVBwdAvQEjLi0g/3syNfQgLOClW5rU3czc4WuLPW8Q5BBAC+f9D
        m3YUmbwvlnIXbkz3bqxgiPKLd3B390MocfMUQzFlugulNnRirOW6XTVpjLvmjY4vtgXhQyyMLYe
        NqkE3d4+x0YWu6Pqe/NBVqP5NIWCMnfcAa+SA/8WjjVipRcYg1w==
X-Received: by 2002:a05:6214:18c4:b0:56e:9089:a447 with SMTP id cy4-20020a05621418c400b0056e9089a447mr2646923qvb.0.1678107884407;
        Mon, 06 Mar 2023 05:04:44 -0800 (PST)
X-Google-Smtp-Source: AK7set8y6a5SSW6hPw+GDXCh+fqXFJP9UdQM/IWboALvjPkMRMhCZDeVIkVx5ql1CNUP6/Ugh0IafMD5qUh9dXlK4Pc=
X-Received: by 2002:a05:6214:18c4:b0:56e:9089:a447 with SMTP id
 cy4-20020a05621418c400b0056e9089a447mr2646908qvb.0.1678107884159; Mon, 06 Mar
 2023 05:04:44 -0800 (PST)
MIME-Version: 1.0
References: <20230303085928.4535-1-samin.guo@starfivetech.com> <20230303085928.4535-13-samin.guo@starfivetech.com>
In-Reply-To: <20230303085928.4535-13-samin.guo@starfivetech.com>
From:   Emil Renner Berthing <emil.renner.berthing@canonical.com>
Date:   Mon, 6 Mar 2023 14:04:28 +0100
Message-ID: <CAJM55Z-WpxJUshAa_gN5GD+mMp1VaxPbnF6AV-ua0HzsFWsB6w@mail.gmail.com>
Subject: Re: [PATCH v5 12/12] riscv: dts: starfive: visionfive 2: Enable gmac
 device tree node
To:     Samin Guo <samin.guo@starfivetech.com>
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
        Peter Geis <pgwipeout@gmail.com>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
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

On Fri, 3 Mar 2023 at 10:01, Samin Guo <samin.guo@starfivetech.com> wrote:
> From: Yanhong Wang <yanhong.wang@starfivetech.com>
>
> Update gmac device tree node status to okay.
>
> Signed-off-by: Yanhong Wang <yanhong.wang@starfivetech.com>
> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
> ---
>  .../dts/starfive/jh7110-starfive-visionfive-2.dtsi     | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
> index c2aa8946a0f1..d1c409f40014 100644
> --- a/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
> +++ b/arch/riscv/boot/dts/starfive/jh7110-starfive-visionfive-2.dtsi
> @@ -12,6 +12,8 @@
>  / {
>         aliases {
>                 serial0 = &uart0;
> +               ethernet0 = &gmac0;
> +               ethernet1 = &gmac1;

Please sort these alphabetically.

>                 i2c0 = &i2c0;
>                 i2c2 = &i2c2;
>                 i2c5 = &i2c5;
> @@ -92,6 +94,14 @@
>         status = "okay";
>  };
>
> +&gmac0 {
> +       status = "okay";
> +};
> +
> +&gmac1 {
> +       status = "okay";
> +};

Since you'll need to add to the gmac0 and gmac1 nodes in the board
specific files too and it's only one line, consider just dropping this
here and add the status = "okay" there instead.

>  &i2c0 {
>         clock-frequency = <100000>;
>         i2c-sda-hold-time-ns = <300>;
> --
> 2.17.1
>
>
> _______________________________________________
> linux-riscv mailing list
> linux-riscv@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-riscv
