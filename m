Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E596688FCA
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 07:48:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbjBCGrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 01:47:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232712AbjBCGqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 01:46:39 -0500
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB9D8C432
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 22:45:39 -0800 (PST)
Received: by mail-vk1-xa2b.google.com with SMTP id bs10so2120371vkb.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 22:45:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DXxrQE0DVwanxphrseUxAjJiqhp6uGNf7pcWwsgpWEg=;
        b=nWROuR0pj1Pl1TSRysKSwzECG02ERncxdz5Du78MZoQovrXI7EnpmAXBHYV5IJbpU4
         NMvgfqCm5s1STqR13XA1OTJIeUbSOpfB4XZ06Pv9JsGb8y1l23NZr2iCmtEjTorgnC+Z
         2JY5IQuTGFbBtjM9mVNKXtzsroj8K8xFseTYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DXxrQE0DVwanxphrseUxAjJiqhp6uGNf7pcWwsgpWEg=;
        b=JSgsU61491tBtn0qSEhWlA8wbO6r7BO6tmwyARau9WlxfMyxG15QBSyD46UQSwjlgG
         AIU/GvFifUCsXYTpkFrlgH8Xk1ZZCC75PithY2gvP7pT+MKoZO/WJ8adDm5vzAaqoMhO
         Cnmb9mdwD6Ko+PFmU7L5yhJgoTcsU62KB1XxOgI6xNRzgOddhQK+yF/TaPR4Cl6Mv96A
         Avr/XqozmYNkLGIb+kzO0kKqb7eQLi7QeA3dvUNt/mHhhPQf1Xnf88nHhAoqEJcMQ2fk
         cYk6wCutazlNDD6wik0egnGrfZtpKxE6MUrHHklw5cxnDDF5qjCREvuBkGr1SG7c2lb2
         y/mw==
X-Gm-Message-State: AO0yUKUOqwWxVFz/ZA31gawZvbyyUsTO9wLfBrUjGv8/SG1/LsL6uuZU
        AkhKZHyuyciK0zspyXno4DnvcsWGqUumijy9X/jK7w==
X-Google-Smtp-Source: AK7set9N7s5GDlQRAmXm5uyJjoUg5jz6AF6KZ8lCLWBstusXFXE/r5U/501lgDv8HqpdHYNuecgcaP+dbJ30rnvNNUU=
X-Received: by 2002:a05:6122:131:b0:3e8:8f:f3a7 with SMTP id
 a17-20020a056122013100b003e8008ff3a7mr1316397vko.30.1675406738947; Thu, 02
 Feb 2023 22:45:38 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-5-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-5-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 14:45:28 +0800
Message-ID: <CAGXv+5GBG2Ehkth8atwueajdkdEGzb3UK5w8H4G98uRVd7U+Vw@mail.gmail.com>
Subject: Re: [PATCH v5 04/19] clk: mediatek: Add MT8188 peripheral clock support
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

On Thu, Jan 19, 2023 at 8:51 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 peripheral clock controller which provides clock
> gate control for ethernet/flashif/pcie/ssusb.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
