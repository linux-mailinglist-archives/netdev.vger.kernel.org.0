Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1B6E695E08
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:05:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232252AbjBNJFi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjBNJFS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:05:18 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B658241E1;
        Tue, 14 Feb 2023 01:04:38 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id h24so16816382qtr.0;
        Tue, 14 Feb 2023 01:04:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vi73fGmWmjTNDASDZdnfJSIYN1ahtOW91dirgxR/MuM=;
        b=WrLk7G8ph4exG2WAnUJJd502XIFYTAHK7kRqeS6TTzAVT9cfD4U0gfdU8FLsbcuaA3
         Iiihd2FqvDAuV0LdFQ4mEo2kZsgHudz4E/JhhI+QILjYhwJolPIGnqdfwRXXvERLpgNi
         1ZfaXs/fwsxm4KReDYRnzLbgcIh7GsOkB2eX7UHseZaubN6dm4xn0IC0tL9fisRk35Se
         TpDrW+6vhutfA7JSSxs9CVS+rcynwS34RlyFp4/XdxPzLhHTC7wjoYaWt6BbXaaIXaLv
         jAAow5jaylKC8E6GaVNsFv+70R1n/HK7UJSb7LSQLYU14vTpm0VY4WPmBh/7YsG3D+nK
         aG9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vi73fGmWmjTNDASDZdnfJSIYN1ahtOW91dirgxR/MuM=;
        b=xXUBqs/0h8rhJmmS3MPIk/fur7DdAZLeYVItGkNmVLj9+vsImaJ4wz8cRllXPIBIt2
         KVHhdlbYU6Z0aQvJbE0Aox6c5WeUAl0KJ3eG09R3VwAJuEDX4+lq6/QV5FStGU2V3YKo
         HnZQD5wgwhSr4HMIDuQGL3mGh64lxb2cc1+j96Tsj/rAiQ7CM9tVhaeOmEtrQHNle2yd
         63AtnHwgLBdvazdL6SuFD/+6mLjk3mEQm1xKcQDECC/5ZWEZB5eV02EcjLXfzlgFw4ZC
         r05uKtdtG9eG4JFMYA9FrLS1QUc5NJhJYfVPkE+HQ6N8W4Wud2DFDNzHyMukigNh3Gck
         pcng==
X-Gm-Message-State: AO0yUKW/gpzyhGjsuJpwX2SpnpZv01B28df5SBLcyRqbcpSwYAKZEUNW
        ZC1daUlWCw1mjrIGRy2cNFgV1F63HbFL8d51Rw8=
X-Google-Smtp-Source: AK7set/BhpTV/KRldVCK+qjZOJbG2cPSpTKVxLlvt7BPL8FEbisiGeB0cyIcDqr2AdNCos9yQyawt9wXz9U+Dy7tdeY=
X-Received: by 2002:a05:622a:289:b0:3b8:6b33:d92b with SMTP id
 z9-20020a05622a028900b003b86b33d92bmr169724qtw.325.1676365475057; Tue, 14 Feb
 2023 01:04:35 -0800 (PST)
MIME-Version: 1.0
References: <20230214080034.3828-1-marcan@marcan.st> <20230214080034.3828-2-marcan@marcan.st>
In-Reply-To: <20230214080034.3828-2-marcan@marcan.st>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 14 Feb 2023 20:04:22 +1100
Message-ID: <CAGRGNgWrRvJezq7svHF7iVohxTdkutEkvLHC=QYUVpic5k=DFA@mail.gmail.com>
Subject: Re: [PATCH 1/2] brcmfmac: acpi: Add support for fetching Apple ACPI properties
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
        Linus Walleij <linus.walleij@linaro.org>,
        asahi@lists.linux.dev, linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hector,

On Tue, Feb 14, 2023 at 7:04 PM Hector Martin <marcan@marcan.st> wrote:
>
> On DT platforms, the module-instance and antenna-sku-info properties
> are passed in the DT. On ACPI platforms, module-instance is passed via
> the analogous Apple device property mechanism, while the antenna SKU
> info is instead obtained via an ACPI method that grabs it from
> non-volatile storage.
>
> Add support for this, to allow proper firmware selection on Apple
> platforms.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Makes sense to me.

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>

> ---
>  .../broadcom/brcm80211/brcmfmac/Makefile      |  2 +
>  .../broadcom/brcm80211/brcmfmac/acpi.c        | 51 +++++++++++++++++++
>  .../broadcom/brcm80211/brcmfmac/common.c      |  1 +
>  .../broadcom/brcm80211/brcmfmac/common.h      |  9 ++++
>  4 files changed, 63 insertions(+)
>  create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmfmac/acpi.c

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
