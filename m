Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9151441F373
	for <lists+netdev@lfdr.de>; Fri,  1 Oct 2021 19:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354723AbhJARp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Oct 2021 13:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhJARp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Oct 2021 13:45:26 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 601C9C06177E
        for <netdev@vger.kernel.org>; Fri,  1 Oct 2021 10:43:41 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id o4-20020a05600c510400b0030d55d6449fso590640wms.5
        for <netdev@vger.kernel.org>; Fri, 01 Oct 2021 10:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ragnatech-se.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=JbCierPieNoW3/azUKor2WMUEq9XV26EWPgrT0BEXys=;
        b=q9m6EI2xLZu+udZrImKwlCmHMZmm+4wiTGo+A+DXi6zc/J5OOI1teKt18rla51wMx5
         y0V3xMNXQlxIA2yUEIvyvFZz9sr4SiIEUvdjgPWVK7kZdsKPLJgMFzxXfS8b5VGtXlKl
         YGvQxSrJqw5jcqkp6h/EcQuHBX6KBmnGeTLx/slusn1ct4G65vkS921sNaPEatJ3xjdd
         QLZONhOzuDVBGqDnMZHotx5FlHjTQDvMZe1qrne03hIsOIvQHS9RyA0hKzEVe9EmFW6o
         qF5AC7grcThH6vWoUpYM3kNq/Gb3XoAP1YOaEU65ngIpJkrYcbY2/rQygKA8mAGXjXUL
         dVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=JbCierPieNoW3/azUKor2WMUEq9XV26EWPgrT0BEXys=;
        b=a+IK/VrSQCNo/p82ruE1zhg9Z+hHUrIxMpSE3iwVx7ZqBhyJdIS3IBYINHx1wIzSXd
         y2KngRFU7xl+wMM0j2FZZLaqzBTEzKJcujH4u14BMkSPnwx9mZ6AlrqUF4158IUBgOyP
         kSNGklongHD810x+R+teg64uozWPVLxRE/ttcggQnoXAjVk2OPdh1muzvnAV3+NV+6D+
         8jIMGN2iyQAMAfkYi7IP4BqafIDx8FP+5I4zdlnVnK2xJoLDeySbr0BNGXcMHwKOoYS2
         d8w1n0/TQKMH1qoLRHTJVff8obVLyPBqVmrhp5dlfKt38ExqDy049KBYJVA0LX7Irtye
         PGGQ==
X-Gm-Message-State: AOAM532gs23W/U2pxX2hKNDGvUeloRZM9ZYM8w0woa0sWSLY3rTcfg/N
        P+mev8kaFvS3NW+yJSoXHdZzVw==
X-Google-Smtp-Source: ABdhPJxo8kSEMkub10r1oi30AJapWK4Rfku+hO0xbpjs793Z2l8po+6OQS+QuMKVY5ObMsqB0z+Y/A==
X-Received: by 2002:a05:600c:40c4:: with SMTP id m4mr3295317wmh.116.1633110219928;
        Fri, 01 Oct 2021 10:43:39 -0700 (PDT)
Received: from localhost (p54ac5892.dip0.t-ipconnect.de. [84.172.88.146])
        by smtp.gmail.com with ESMTPSA id k1sm6525203wrl.33.2021.10.01.10.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Oct 2021 10:43:39 -0700 (PDT)
Date:   Fri, 1 Oct 2021 19:43:39 +0200
From:   Niklas =?iso-8859-1?Q?S=F6derlund?= 
        <niklas.soderlund@ragnatech.se>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: renesas,etheravb: Update example to
 match reality
Message-ID: <YVdIy9JF3et1DFT8@bismarck.dyn.berto.se>
References: <7590361db25e8c8b22021d3a4e87f9d304773533.1633090409.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7590361db25e8c8b22021d3a4e87f9d304773533.1633090409.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Geert,

Thanks for your patch.

On 2021-10-01 14:13:55 +0200, Geert Uytterhoeven wrote:
>   - Add missing clock-names property,
>   - Add example compatible values for PHY subnode.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

> ---
>  Documentation/devicetree/bindings/net/renesas,etheravb.yaml | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> index 4c927d2c17d35d1b..bda821065a2b631f 100644
> --- a/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> +++ b/Documentation/devicetree/bindings/net/renesas,etheravb.yaml
> @@ -287,6 +287,7 @@ examples:
>                                "ch13", "ch14", "ch15", "ch16", "ch17", "ch18",
>                                "ch19", "ch20", "ch21", "ch22", "ch23", "ch24";
>              clocks = <&cpg CPG_MOD 812>;
> +            clock-names = "fck";
>              iommus = <&ipmmu_ds0 16>;
>              power-domains = <&sysc R8A7795_PD_ALWAYS_ON>;
>              resets = <&cpg 812>;
> @@ -298,6 +299,8 @@ examples:
>              #size-cells = <0>;
>  
>              phy0: ethernet-phy@0 {
> +                    compatible = "ethernet-phy-id0022.1622",
> +                                 "ethernet-phy-ieee802.3-c22";
>                      rxc-skew-ps = <1500>;
>                      reg = <0>;
>                      interrupt-parent = <&gpio2>;
> -- 
> 2.25.1
> 

-- 
Regards,
Niklas Söderlund
