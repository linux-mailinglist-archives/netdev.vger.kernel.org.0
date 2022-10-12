Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF92C5FC2F6
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 11:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiJLJUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 05:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229950AbiJLJTx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 05:19:53 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89339FAD4;
        Wed, 12 Oct 2022 02:19:52 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id g27so23614157edf.11;
        Wed, 12 Oct 2022 02:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pNSFAr2MGivBSLtf3MfcdCBQLmBdDr3TEf3ZiaGN4R8=;
        b=FDD9yc6U8Q8r+i6GYJu0VNwuSvFNAx40cBnTrpkBokdJzW31FSIB9lA0QnpQAgLOjo
         PKVXCCexLKAo8i2FAfU9IsiFRsUQxOMdOtHZbW5L9MpfpwfTFGjiZaF4jF0zZQbUTARs
         zel/hmruMzT9kykHnTY2ItDib7T07yeZzsZvJZ/Is3J8jI044GBbLKdVxxGfm88IDsUk
         33YTKntHYXEf7t2y8uP5s8RBD7gCeQ8CpPg3EcbTYu/QJconcAE8+QvBqOITjb4TqEjx
         Ju86wNLPdYTqHaRGmFq7r6YbIt01PxHEEiwve2KLNzv0TjsnV/WdZX7H4vna6WgOkYKl
         91Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNSFAr2MGivBSLtf3MfcdCBQLmBdDr3TEf3ZiaGN4R8=;
        b=Y5krs3gH4LstW35fFmtep+krlziDGaRKGYnnqCVNfC+2uio9hAjwiSd8BK8MAluNV9
         DbqRtUP8z4qm9b/eCfsprJtVJAp0Y1ZMFKMAnrpDywh08xKwXZ+7TJBsdFiE873TTJJV
         DrTjQ9HVSZ2xieo7eKzcNwmeThoGhSjvJrBjyo7AG8ZeAEN9nytPrd3Ua+VkvKiCq/Ef
         ja5jhecoQV4ea/LEmNh7+nfbt6MrX0ymQV4YmDMrDJjEn+U1W9jOR2OlPchZWQ8fQAIM
         F9CdGA4LmCy33c6br3zqOsFkiDUZymvFFTCbymcQChFSmOXSkaFWMoESj/1jsLrdpeCP
         6UEQ==
X-Gm-Message-State: ACrzQf3wINowk3MOWA24uTQNM4qeK5BdehR3kZ5KRuNdHr3IM19i0Fs0
        eagIUWm+T8BFIF+YARqaBbd0/AN6fQ7QIw==
X-Google-Smtp-Source: AMsMyM6bJSXO/d+EGXaKgWOUcUspbuz5Nz7fsjKtFF77ct5LATs5R5VsXUE1F00KHnOEfyVmIsI6Mw==
X-Received: by 2002:a05:6402:1909:b0:459:d0b8:1606 with SMTP id e9-20020a056402190900b00459d0b81606mr26027648edz.313.1665566390977;
        Wed, 12 Oct 2022 02:19:50 -0700 (PDT)
Received: from skbuf ([188.27.184.197])
        by smtp.gmail.com with ESMTPSA id d41-20020a056402402900b0045bef7cf489sm7093029eda.89.2022.10.12.02.19.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Oct 2022 02:19:50 -0700 (PDT)
Date:   Wed, 12 Oct 2022 12:19:47 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: Re: [RFC v4 net-next 03/17] net: mscc: ocelot: expose stats layout
 definition to be used by other drivers
Message-ID: <20221012091947.tdiglhtzy5cvfmpe@skbuf>
References: <20221008185152.2411007-1-colin.foster@in-advantage.com>
 <20221008185152.2411007-4-colin.foster@in-advantage.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221008185152.2411007-4-colin.foster@in-advantage.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 08, 2022 at 11:51:38AM -0700, Colin Foster wrote:
> The ocelot_stats_layout array is common between several different chips,
> some of which can only be controlled externally. Export this structure so
> it doesn't have to be duplicated in these other drivers.
> 
> Rename the structure as well, to follow the conventions of other shared
> resources.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
> ---

I see that ocelot->stats_layout has become a redundant indirection.
It no longer contains anything hardware-specific. The register offsets
are now part of the switch-specific sys_regmap.

Could you please refactor the code to use a single static const struct
ocelot_stats_layout in ocelot_stats.c, and remove felix->info->stats_layout
and ocelot->stats_layout?
