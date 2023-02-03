Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A520688FED
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 07:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbjBCG6s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 01:58:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjBCG6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 01:58:47 -0500
Received: from mail-vs1-xe2a.google.com (mail-vs1-xe2a.google.com [IPv6:2607:f8b0:4864:20::e2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEAD65EC3
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 22:58:46 -0800 (PST)
Received: by mail-vs1-xe2a.google.com with SMTP id e9so4435547vsj.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 22:58:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=BPezifRRh17LMgbOCetI5RBHb7FvOfUfqVX0Agy4qtY=;
        b=N02LErE9dq3/R+ouQXbCmArYXakhpEsijaOrlNridYJmj530ETOeWePoqlx9jusdKT
         iPfDHYES4HEyQQxPJu19zeJddM1thZLxnlq1uMSzUslbpFkGddTouvlTW54+4K6dADtr
         VAzgIeSwiO4kIkWN6we4elrNZOzpqpXh4Jg08=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BPezifRRh17LMgbOCetI5RBHb7FvOfUfqVX0Agy4qtY=;
        b=Vr1jDNuN6TMyW+y68fe7+5jwQw64zNNXgLpMbH67GhBBeblgCKfYBBtHpgtRrTNbee
         a2CGYOKpWrrplYTDpkfT8qSH/iZKTlq7QpvU7TYC1HIfk7xRrcn9AFOUZWzcvOzrD5JH
         wvym+jS879bfuMoVHzSqcaJacZ8AO2IXjRxA03aKUmisAa7vZ0tQlca/NgU9oGLIzi2K
         CyK2loTYA2vBzfxsAShJKCFpCNojAbFXITo8YRT9szPq0I2/dUzisH+GuU0zy0o5etNI
         I0Ye+GAktLrYMCcueT//zGLqTLswuXGfwJGQRZA/SUOcWalmQU6h6QGRELjZ0cZ5znHx
         nHlA==
X-Gm-Message-State: AO0yUKXPre0UG2DO2Z2LXKWjbapOUSZ05J1D87Rz14PxYREWTrLHHOst
        StZUszCxe3VzsjnoaB2Qzo1hS6nMt88zD4oOEP62BQ==
X-Google-Smtp-Source: AK7set+oNQywJdjoNKiBRoVLc3BLNQgwROOiiULh2qZGXSFUG24dnj7Lf6sHKTrCEF1O2JAiqeFNZ7IgIlv8x4NVK58=
X-Received: by 2002:a05:6102:23f2:b0:3ed:89c7:4bd2 with SMTP id
 p18-20020a05610223f200b003ed89c74bd2mr1663085vsc.26.1675407525498; Thu, 02
 Feb 2023 22:58:45 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-9-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-9-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 14:58:34 +0800
Message-ID: <CAGXv+5GEHXqtYffimHzH2srMZKa2dnMAmN5wgTW+91bfFFf6gg@mail.gmail.com>
Subject: Re: [PATCH v5 08/19] clk: mediatek: Add MT8188 imgsys clock support
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
> Add MT8188 imgsys clock controllers which provide clock gate
> control for image IP blocks.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
