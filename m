Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FF46890E4
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbjBCHcB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 02:32:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231261AbjBCHcA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 02:32:00 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92DC668105
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 23:31:58 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id j7so4471298vsl.11
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 23:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=20UFv4FYR0RNRhy2mEzLDHn9GdVhRKvFn1ySTJIDHWo=;
        b=RsxUC4vMRzdVnPDNIlpDSu6HWqexhlUr3/ndoqsY0EjcW+V0zfAdnJtijv7YsU+TcO
         KP5dbNn8LEe6vaxWWUeAbQkcVNYZxVRxSgG/V1wSR7AmvPlMMMOOGCYQGquKCmSUZ84T
         fQFD2VAWxBjKc9fP1AUSzWc+V61mf4ynPPAiQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=20UFv4FYR0RNRhy2mEzLDHn9GdVhRKvFn1ySTJIDHWo=;
        b=yRlfoB47uMwBhb29ZWbawAxtOmz4voQTTn1kIkwn3srLG/8eayvew+pYfNT1vzaEFg
         PAAi8x1v0CCjiNZ6xj17oUeJJgrh9odc+Rub5opyL6tWKyjZlyiECV4/t6z2fXjByijS
         rwyigrd98FAXpukgsVys2yaYQecOSmH4OjJe5TJhyaU/lXi3fmndfaKPxKpJv7qug6qG
         DIbvfBmhr5g5yVSmfKIm+qgOD2knKxyzUvpWx/nyDdPVI8ziJaCiqqhPGaBhdKV1icn8
         BPakwaVVMVYaTaXBuF01SkUja4NG+byBi2uu9QUmpdV4klF5wvYpZeLzuSq80udCwLhx
         xjnA==
X-Gm-Message-State: AO0yUKUqlTX7JBaP/Ov7PzAfS5HyqpNrRB74RdjpIBPmV2wxGL7fs+4o
        3hJAFw2aD75Lz0AZTMKSXEtRd1pEeJ7S3OHF31yTDg==
X-Google-Smtp-Source: AK7set/4FlDK7sISjom/UmIlvod48p3X4cFzfbV8Lo3q+4ml6FeokBpj89CDwYQ/JOIdYwgsnoY2RhpBJT1ZpU8fMvI=
X-Received: by 2002:a05:6102:23f2:b0:3ed:89c7:4bd2 with SMTP id
 p18-20020a05610223f200b003ed89c74bd2mr1677388vsc.26.1675409517750; Thu, 02
 Feb 2023 23:31:57 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-18-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-18-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 15:31:46 +0800
Message-ID: <CAGXv+5G4vvtZAcgO9SUczUDq4_94K4jF3G+YuSDYa8QvxpMp7A@mail.gmail.com>
Subject: Re: [PATCH v5 17/19] clk: mediatek: Add MT8188 wpesys clock support
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
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:54 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 wpesys clock controllers which provide clock gate
> control in Wrapping Engine.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
