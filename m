Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEB76100FD
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 21:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236493AbiJ0TAE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 15:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiJ0S7y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 14:59:54 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A35EA1A82E;
        Thu, 27 Oct 2022 11:59:51 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id be13so4131274lfb.4;
        Thu, 27 Oct 2022 11:59:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sKKXfxrvWBs1+Hg89OKoS0D5bomkbPpDXug7ZUOTYqo=;
        b=C3rMcH37E0tC3a2/wwyFQyS/AaPfokgd48lGNu90AbsNzDMT+NQhQjrLkKiqanEm02
         LVhaBhX+2p5KIH+O95uYRlBM90vO46EKH01y1kX7GLOLRp4rRM9Aga/vTFSSnflfhj6z
         nfeTf6I8U1OwcchAOsZOlxPeQL6K9R5gGANMk6cx0HKtAchyXIE4dJ2WXyhPLqwqP0A6
         +1Ccc23QKGwL/rlvAT+d7NDlX5ZN9owv3H0lrKxVdF9TZaedeNFAyINo7RpCcVYAMVDO
         PrbuSrvK+8jlp7gOWupeCI51j0/2eYkNGkUU9d0KzieC9xPF7Ia1ikhR4rau11UlQh5/
         8A0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sKKXfxrvWBs1+Hg89OKoS0D5bomkbPpDXug7ZUOTYqo=;
        b=Mdiemgj9fDRWg30q7hpYJvtMkuBfPAzRl0Jg2bUcvlqiAScksEJ3OGj33suq91gvGd
         LLpIrr0HLV87M70vF/ToeXxqXRYvJ1vlS9goEVE30IWpuBX194VKBZf06f2V+Pl5m9hq
         8Vef9DaamnvPKm3pfSOtNart5rJQafcKIUgMy9qbosRLqB4IVBq6rNoYRoPxudP7btsO
         ABWNewIU8AfUDwf8jbstUWRzuGqA0APz7M6PAhjWqZPQ4ss1ErFWFwk2S+aVGwuz0nS/
         NL2k+gPvFytLVB2lia7+vKF+Cle6FeJxefUirhFhLwYHQScJQgbGIZj/hGb5HG00U1/C
         +1ww==
X-Gm-Message-State: ACrzQf0ClP/nDGYLIt9hf1tgeLKyK9AtUTzdtr9y5VKkVwJ6i/E+qkZF
        n52xBuLJpOZyWMrT/WifpGoL3TUym+6higG87cw=
X-Google-Smtp-Source: AMsMyM55BByl/DxbuZBmfmXxteUNIOLPRPgsHlOnNe8MUHvu3Tud4uluqbEsdWFvDVZytpdWa4vy0oC8fK7/fGiHJQ0=
X-Received: by 2002:a05:6512:483:b0:4a2:6905:dfae with SMTP id
 v3-20020a056512048300b004a26905dfaemr19431686lfq.57.1666897189900; Thu, 27
 Oct 2022 11:59:49 -0700 (PDT)
MIME-Version: 1.0
References: <20221027150822.26120-1-sven@svenpeter.dev> <20221027150822.26120-7-sven@svenpeter.dev>
In-Reply-To: <20221027150822.26120-7-sven@svenpeter.dev>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Thu, 27 Oct 2022 11:59:38 -0700
Message-ID: <CABBYNZKJnmfWfvxdgpxNFUGc7jTKP+BGv6CiZc2MsR970L35MA@mail.gmail.com>
Subject: Re: [PATCH v4 6/7] Bluetooth: Add quirk to disable MWS Transport Configuration
To:     Sven Peter <sven@svenpeter.dev>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Hector Martin <marcan@marcan.st>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        asahi@lists.linux.dev, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
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

Hi Sven,

On Thu, Oct 27, 2022 at 8:09 AM Sven Peter <sven@svenpeter.dev> wrote:
>
> Broadcom 4378/4387 controllers found in Apple Silicon Macs claim to
> support getting MWS Transport Layer Configuration,
>
> < HCI Command: Read Local Supported... (0x04|0x0002) plen 0
> > HCI Event: Command Complete (0x0e) plen 68
>       Read Local Supported Commands (0x04|0x0002) ncmd 1
>         Status: Success (0x00)
> [...]
>           Get MWS Transport Layer Configuration (Octet 30 - Bit 3)]
> [...]
>
> , but then don't actually allow the required command:
>
> > HCI Event: Command Complete (0x0e) plen 15
>       Get MWS Transport Layer Configuration (0x05|0x000c) ncmd 1
>         Status: Command Disallowed (0x0c)
>         Number of transports: 0
>         Baud rate list: 0 entries
>         00 00 00 00 00 00 00 00 00 00
>
> Signed-off-by: Sven Peter <sven@svenpeter.dev>
> ---
>  include/net/bluetooth/hci.h | 10 ++++++++++
>  net/bluetooth/hci_sync.c    |  2 ++
>  2 files changed, 12 insertions(+)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index 8cd89948f961..110d6df1299b 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -273,6 +273,16 @@ enum {
>          * during the hdev->setup vendor callback.
>          */
>         HCI_QUIRK_BROKEN_EXT_SCAN,
> +
> +       /*
> +        * When this quirk is set, the HCI_OP_GET_MWS_TRANSPORT_CONFIG command is
> +        * disabled. This is required for some Broadcom controllers which
> +        * erroneously claim to support MWS Transport Layer Configuration.
> +        *
> +        * This quirk can be set before hci_register_dev is called or
> +        * during the hdev->setup vendor callback.
> +        */
> +       HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG,
>  };
>
>  /* HCI device flags */
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 76c3107c9f91..91788d356748 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -4260,6 +4260,8 @@ static int hci_get_mws_transport_config_sync(struct hci_dev *hdev)
>  {
>         if (!(hdev->commands[30] & 0x08))
>                 return 0;
> +       if (test_bit(HCI_QUIRK_BROKEN_MWS_TRANSPORT_CONFIG, &hdev->quirks))
> +               return 0;

Let's add a macro that tests both the command and the quirk so we
don't have to test them separately.

>         return __hci_cmd_sync_status(hdev, HCI_OP_GET_MWS_TRANSPORT_CONFIG,
>                                      0, NULL, HCI_CMD_TIMEOUT);
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
