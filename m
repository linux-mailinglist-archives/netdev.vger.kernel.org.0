Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBFF69621E
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 12:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232870AbjBNLOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 06:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232933AbjBNLOA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 06:14:00 -0500
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 456E723307;
        Tue, 14 Feb 2023 03:13:41 -0800 (PST)
Received: by mail-qk1-x732.google.com with SMTP id bl15so5952759qkb.4;
        Tue, 14 Feb 2023 03:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QY69IubUKobiGQjBkAM6NMgZ/rDfUXquM5D7B9d60Ic=;
        b=BH1AlyGB9oGV81i5obUw3pp4B5Gp64ngiIJoP7KFoFB7Mi9KMIbvvq9t0cYEgRDkee
         tnxX2gm/GvaPXGWRwg4AgZxNNpKLCb6PsqrHYYY+i69OuITVxseptcDsAje7z9auLlKS
         M5RUBsdCWynkbBmMXq20geBPO/r0bF+SxE1al8bS+iklRbcjq60Xz0Ag6Glbr5C9r7mW
         AWBYrCFFfzifnFoTFPT+7kNOGMH+JGQhVl2b8wdrGBwhRINlb8G8DOcFz7oVbsgC6bBP
         4IqrEuezGve8PEjIcbwSSj3KUuGRgnnRTXPp4UirjhgU5c97UU0dqrcMZb+WY4psTfca
         xZuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QY69IubUKobiGQjBkAM6NMgZ/rDfUXquM5D7B9d60Ic=;
        b=Im0p/+ZMrvrPWU37dlUeluDpUcH9NXS8rY9p2U/F3cxbO+N9Mqw8VZxch9s93O+ue6
         rnk6pPGKUCnmPasODxJ5plTiwSNiWKNmULgxhd4uBW6V22maISKFjEBMimYJvHvR/KNQ
         u87CGL4emT+TDRDiq+EWVZGRNlgoPlrm4OkvAMUuBpS74Q9YjooX6QikTL05mmEPTmu1
         XX8rWTURi1YtKMaMbP3VKfXYlB7/0GRAo+kZ5+gp2auEWgboLgdQL6S9buJ4H7BJcwXN
         OkWm9g7t+uCngIzEjJSAK4drCWLpY8gLFW8RQ6LXiJAL3ih/HFIdKVceCit/8gUwHRYb
         mPhw==
X-Gm-Message-State: AO0yUKU+lhINdFRpQs9HP/Qyx0qG4NWZj/kIrkeBr2NJQECkOZOH7jDW
        gY4iJRT04LU/PbKVpCUVVnip2DenNvos1+R8fQg=
X-Google-Smtp-Source: AK7set89IDV1ztNWxEdvPIDujkpAxkMc80QByegNdRwadNdoy8YD3ZimFJhoeB9aJuDdRChh7VcrRKi3To6OXjeBhoU=
X-Received: by 2002:a37:2e83:0:b0:719:8bf8:ba16 with SMTP id
 u125-20020a372e83000000b007198bf8ba16mr96830qkh.72.1676373216884; Tue, 14 Feb
 2023 03:13:36 -0800 (PST)
MIME-Version: 1.0
References: <20230214092838.17869-1-marcan@marcan.st>
In-Reply-To: <20230214092838.17869-1-marcan@marcan.st>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 14 Feb 2023 22:13:23 +1100
Message-ID: <CAGRGNgUUX8_Jcxsbm-+08kF83yH3HgqDRJcBDRsrJPS_8=zodA@mail.gmail.com>
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
        Linus Walleij <linus.walleij@linaro.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
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

Hi,

On Tue, Feb 14, 2023 at 8:32 PM Hector Martin <marcan@marcan.st> wrote:
>
> BCM4378B3 is a new silicon revision of BCM4378 present on the Apple M2
> 13" MacBook Pro "kyushu". Its PCI revision number is 5.
>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Assuming the numbers are correct, this looks like other patches that
add new cards, so this is:

Reviewed-by: Julian Calaby <julian.calaby@gmail.com>


>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index 7ee532ab8e85..43d666e9038f 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -66,6 +66,7 @@ BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
>  BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
>  BRCMF_FW_CLM_DEF(4377B3, "brcmfmac4377b3-pcie");
>  BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
> +BRCMF_FW_CLM_DEF(4378B3, "brcmfmac4378b3-pcie");
>  BRCMF_FW_CLM_DEF(4387C2, "brcmfmac4387c2-pcie");
>
>  /* firmware config files */
> @@ -101,7 +102,8 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>         BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
>         BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
>         BRCMF_FW_ENTRY(BRCM_CC_4377_CHIP_ID, 0xFFFFFFFF, 4377B3), /* revision ID 4 */
> -       BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
> +       BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0x0000000F, 4378B1), /* revision ID 3 */
> +       BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFE0, 4378B3), /* revision ID 5 */
>         BRCMF_FW_ENTRY(BRCM_CC_4387_CHIP_ID, 0xFFFFFFFF, 4387C2), /* revision ID 7 */
>  };
>
> --
> 2.35.1
>


--
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
