Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE29E6890FE
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:36:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbjBCHg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:36:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231459AbjBCHg0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:36:26 -0500
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 828D192EE0
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:36:25 -0800 (PST)
Received: by mail-vs1-xe34.google.com with SMTP id e9so4508128vsj.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XWd8ap96nAgAL415/EFATTI5RTX0TRS1PzjaGcltWi0=;
        b=LLwkDnkGD9sQPL8wNcGoHf3zoY3ly0UMsk+iFxlonWhNFTYJ0FR2EQHrQnnXqRUncG
         2751wL52GQaCRpODfNwXv3+N5/972sVR1ZaGP9hB4XdiaCmctuvEhuaYXFR+jkK+IaCq
         pyIiss9W94Iwia+BgiSSgWAwgqi2QgQ/XMat8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XWd8ap96nAgAL415/EFATTI5RTX0TRS1PzjaGcltWi0=;
        b=sbg+fI/SbNA/pXMeqA9oq6fFELCCULkRoB4Em9dVll+PMb1sZZ2HqokA8M9rGGo5XS
         ZfpHgFPtxpxUN9WLwL4ZAmlwHnlp1ik6XJvnmSKRGXRZ8nur2lopOIuozZwu2Puridgl
         rR+x7EFklUmZkMCAjv7G/2pQkR2NeVgD9so1tT3eSoSvUJJXKGFw35b1+4bBXZ0iRVbu
         oRR9Lfc8/YpJANe+PPGSJzDfyJCJpfG5/81bYDMrb0gz63erpfyZv6tWY8yfzhZTQpfe
         8w/oLHiqR3v9EJ6JXW5H8q5MNg8kemHoir27J9v/gcmT5TrjltxlMYqzC+JTLtdAwJL3
         XWKQ==
X-Gm-Message-State: AO0yUKXtExDRE2+pc0gNtG/KRgIBWIk1j0eXc6GNcIHLF2cBZQVn6MQ4
        sNwOQev6QhA8Jx34jmyYdUQr9Pe8NXst+Ej4q/tH6A==
X-Google-Smtp-Source: AK7set8M7H+RZ+wc2NkrqpEmbn3SZ1l1MIeIPiYShNT7awfF8mMd3QSxd4Wrz1xZcnMblvzNv11k8fjEOOa/6MUu4lM=
X-Received: by 2002:a05:6102:322a:b0:3fe:ae88:d22 with SMTP id
 x10-20020a056102322a00b003feae880d22mr1498238vsf.65.1675409784709; Thu, 02
 Feb 2023 23:36:24 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-19-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-19-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:36:13 +0800
Message-ID: <CAGXv+5FJJDqRdiHO2Pfx29NB9uRUz=t7KOHZ=HaREGcuAdph6g@mail.gmail.com>
Subject: Re: [PATCH v5 18/19] clk: mediatek: Add MT8188 imp i2c wrapper clock support
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:55 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 imp i2c wrapper clock controllers which provide clock gate
> control in I2C IP blocks.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
