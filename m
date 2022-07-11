Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E60D056D82C
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230319AbiGKIfD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:35:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbiGKIef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:34:35 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6B0E7645
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:33:40 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 64so7550370ybt.12
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 01:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EMqz2RlRm0bA+8FrAifa7ABlwpjofLzKIEAi6/6vrLU=;
        b=QKeG1HHzJRHD0H/6LGGRINRsdCGiSnl5uUKdMUCuRhoYEQWRC6lTS+Lg7OFSPp0Xde
         FzHjt7jdbpTAbnN6Jk+F2iFxW0E4xi6OZ4xViAlRMe4f32/oV2TBD2YkUuR7r3fxPLTq
         X6k8bwRixqOnzTktO8gylxnb40UV8/WQmW3TtPx3YI5kXXnuVtKItv//X7gF9nK4l1yr
         UThHrRJoTlJXI+JvK+46nnLHNvY/ytS4iWI+Khd71Lus0RJNVZZsSf5BWb3LGKvhdvnB
         va3XO+T+ZMk+hoA4l40QpdtwNt6T3FjNHvZzByxIbl+TY0KheOYDL8R7ZZPzFpvbXv5L
         LoWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EMqz2RlRm0bA+8FrAifa7ABlwpjofLzKIEAi6/6vrLU=;
        b=qi2oZKqbzmGZ3ibQs7J5YU/k/yRu4weYVXQ+U0dWVIcJ7TScynI879crfL4EOo898U
         4RgfUw+ScBmMt/UOhV/ai6xPX8VL5bepP7OfdWVppDfUx9g1M4xdGMdK1kDlIeMaDWZe
         lhTOgx028hAeMNRZCg9PVHcj7F2Vkt8Qu3/28JLgrke3gibYxxi3Tv2gjIHnrhS0RkS4
         lVofn7FsS56yTBzicuX7+zTejNvwnfp/AX8MuUEMDjIsxWUDgCTi8smGdd6GFtStm91F
         DhatogdXSrqKOVhV1l97YTa2Ry4GhmWNMrg8TyC9JdPbqUTPODgqqykuJFi/zeG6X+KZ
         Ib1w==
X-Gm-Message-State: AJIora8GcKMEfBiFoJnQjJfQG26d+H6b94tK5bK1bMDDIUaLXrXpFFKb
        wgkfM0+4HCzXW6s9H8y1gyFSBUgrP6iREHmm/zs1kA==
X-Google-Smtp-Source: AGRyM1tBz8gehbsWzZ67YSk/1SanF3vkLhKYyrfaxSuuZmsIkaaSs9/LHvYZeiqbGDliuQnewe2hn0FUU2grp/OroJc=
X-Received: by 2002:a05:6902:150a:b0:66f:8a6:be47 with SMTP id
 q10-20020a056902150a00b0066f08a6be47mr8237660ybu.291.1657528419365; Mon, 11
 Jul 2022 01:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1656583541.git.hakan.jansson@infineon.com> <6d17c74d01e785ca7db21d611a5722943aeffdd3.1656583541.git.hakan.jansson@infineon.com>
In-Reply-To: <6d17c74d01e785ca7db21d611a5722943aeffdd3.1656583541.git.hakan.jansson@infineon.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 11 Jul 2022 10:33:28 +0200
Message-ID: <CACRpkdb4U0xZCSwfip4EoPzMcPjn9wUvsw1bjrjTQpb3AHTxZQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] Bluetooth: hci_bcm: Add DT compatible for CYW55572
To:     Hakan Jansson <hakan.jansson@infineon.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 2:46 PM Hakan Jansson
<hakan.jansson@infineon.com> wrote:

> CYW55572 is a Wi-Fi + Bluetooth combo device from Infineon.
>
> Signed-off-by: Hakan Jansson <hakan.jansson@infineon.com>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
