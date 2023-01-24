Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6284C67A189
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 19:43:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233906AbjAXSm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 13:42:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233900AbjAXSmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 13:42:52 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE7D145BCD;
        Tue, 24 Jan 2023 10:42:16 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id v19so1318148qtq.13;
        Tue, 24 Jan 2023 10:42:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iVcjuX1DrPzpms/qqm55UTZi+ADxFT6DDuGfNYewlYI=;
        b=2ei6fTcIr9X2ixQHZ+EPC5V6182JQumzNihDMIy/75cdok5VCufdVppWkbV2cOKbum
         tQUQQcf6dsT3oTGntcYphPDjpvez7fvKdHXcbHhtOHQ0/SWzPUd9ukVR7LTJZEuYix0x
         P2xjoNcrVulWScTqD+uZ2IyHi5SG0pteiI7q4WDE63zV/otmUwGtYbwE6kvjjylqLPlj
         ayPG91xOnYTsF8kEBOLWxRHAzAMoUrFFF8Kwg7PjWj30qfHhZlED8SyjFzjbHvBMR2HN
         7w35XDzm7cBN5HKqAM4aCMHe4Tc4wtQD6Byj0eM2T2KWcpkFpgHAOBb2yTeCn88fOMyY
         qTng==
X-Gm-Message-State: AFqh2krBnSQrUR4ncDKxd6xTipHHyJZK9GetrXShZ9TcY698CdCH97b3
        pe8bKeWDB4HwgUeNSEtUNm9OjtGstnsAIA==
X-Google-Smtp-Source: AMrXdXtMjycl63rqLtCwxpqXzLnyoJpcGZdndPK/mZ5/XadjpLZLQHbavo2VN7ZRW0m7s00iLnvggg==
X-Received: by 2002:ac8:524c:0:b0:3b6:378c:5cd7 with SMTP id y12-20020ac8524c000000b003b6378c5cd7mr41300962qtn.61.1674585675773;
        Tue, 24 Jan 2023 10:41:15 -0800 (PST)
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com. [209.85.128.176])
        by smtp.gmail.com with ESMTPSA id l4-20020a37f504000000b00705be892191sm1877987qkk.56.2023.01.24.10.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 10:41:15 -0800 (PST)
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-4ff07dae50dso186269157b3.2;
        Tue, 24 Jan 2023 10:41:14 -0800 (PST)
X-Received: by 2002:a05:690c:c89:b0:4dd:7a8e:1cf3 with SMTP id
 cm9-20020a05690c0c8900b004dd7a8e1cf3mr3096734ywb.384.1674585674575; Tue, 24
 Jan 2023 10:41:14 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674499048.git.geert+renesas@glider.be> <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
In-Reply-To: <e825b50a843ffe40e33f34e4d858c07c1b2ff259.1674499048.git.geert+renesas@glider.be>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Tue, 24 Jan 2023 19:41:03 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com>
Message-ID: <CAMuHMdXtiC-Oo01Y-vCbokjF=L+YXMN=TucgqCS4Vtcg5gt==g@mail.gmail.com>
Subject: Re: [PATCH 12/12] can: rcar_canfd: Add transceiver support
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Fabrizio Castro <fabrizio.castro.jz@renesas.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Ulrich Hecht <uli+renesas@fpond.eu>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 7:56 PM Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> Add support for CAN transceivers described as PHYs.
>
> While simple CAN transceivers can do without, this is needed for CAN
> transceivers like NXP TJR1443 that need a configuration step (like
> pulling standby or enable lines), and/or impose a bitrate limit.
>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> This depends on "[PATCH 1/7] phy: Add devm_of_phy_optional_get() helper".
> https://lore.kernel.org/all/f53a1bcca637ceeafb04ce3540a605532d3bc34a.1674036164.git.geert+renesas@glider.be

v2: "[PATCH v2 3/9] phy: Add devm_of_phy_optional_get() helper"
    https://lore.kernel.org/all/4cd0069bcff424ffc5c3a102397c02370b91985b.1674584626.git.geert+renesas@glider.be

I'll keep you updated when/if this ends up on an immutable branch.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
