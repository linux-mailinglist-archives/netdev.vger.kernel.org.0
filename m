Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB540697897
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 10:04:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233378AbjBOJE1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 04:04:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229970AbjBOJEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 04:04:25 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1A54311F5
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:04:23 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-52eb7a5275aso242084737b3.2
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 01:04:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oY1nkRMg5xIYxJkEJudISp1SsePMPZsPbFvRS2TeTYY=;
        b=rbaWe+oRzVt/2SLnetpU2Uetj0VRu5i96tclNSePLjUiG/eeF6v2jHAVV+KonBcNDb
         v27l30iursquX/OPnVQ8FueErDRIpLPGc8LDk5Y61NP+6j9YsBMGDjsZyj0GPrH8XVBt
         IKckUdR/bYdLNTBpDUhxP3Hprta9kEe8Xs0qP7tYlxlDQfRle3Jx7ePaqkyWg6Ns4Hwr
         GOP9VKetqUZ1xbptXVWOX13bFKj5ySVw3ieN+CjuzghA/sjQ01x+On3gKCTryVkx2mTB
         tK8uX1jAzi/T5jUCnwW3W3GjVJ7NLJRDOffeYSjLzrW/EyAIUV6BASdvTs4Rn7y9I9uB
         /82Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oY1nkRMg5xIYxJkEJudISp1SsePMPZsPbFvRS2TeTYY=;
        b=Il8i6VII21d+XvqGst0SEuCkHam5nSdTb4Yus/eq44c8y4GF+/5m0XEnpNRVKMvnjs
         mKtmjf8eZlDVzGl1aPLD57c7ezxCmiUQe0wavOSoULIv+WJc99tzzhD06xrSVv6ZwAlV
         zTITW62SyLwD4wNPj0ojw7Q+sakdSx0hnEaPbCcHsc5PoFVnkhTqiVJ6uED23gdRM2/h
         lOJdtRGeUtuMxLvVRlYhwnMVK177slgbIO9Vr7mw8MM3C7tEa00VbCRVinr2Fu9R1kBv
         3zGvf1vcqQgRFmS7T21VRVlUp/daI5azVdVewTLTlsY5NfLSJDW1MFUw4a3lfJDeLHsd
         Xb0w==
X-Gm-Message-State: AO0yUKWIvdDs9kYLXo4vVT2x4C5ZUtq0mILRr9I8S5mhFni/pDn1+trV
        OCL3xI4snGWuANwU+k6AFcxRWhpkorRIsyd1hp5CQw==
X-Google-Smtp-Source: AK7set/fL3py9MtVnDFb7krzubxSrlxFlH3/cnycfcvpNmIE0uFAsbEzQ91Z9mMtjkDuqLB9Qeto8GMaBNULqAVkmrs=
X-Received: by 2002:a81:a008:0:b0:52a:9161:f533 with SMTP id
 x8-20020a81a008000000b0052a9161f533mr238975ywg.64.1676451863017; Wed, 15 Feb
 2023 01:04:23 -0800 (PST)
MIME-Version: 1.0
References: <20230214092838.17869-1-marcan@marcan.st>
In-Reply-To: <20230214092838.17869-1-marcan@marcan.st>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Wed, 15 Feb 2023 10:04:11 +0100
Message-ID: <CACRpkdaQ6L399pgPAiyOtXkAYhfaOdPWqvVjXacDt0+-Oa7N_Q@mail.gmail.com>
Subject: Re: [PATCH] brcmfmac: pcie: Add BCM4378B3 support
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 14, 2023 at 10:29 AM Hector Martin <marcan@marcan.st> wrote:

> BCM4378B3 is a new silicon revision of BCM4378 present on the Apple M2
> 13" MacBook Pro "kyushu". Its PCI revision number is 5.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
