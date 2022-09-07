Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABE95B0CB4
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 20:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbiIGStl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 14:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbiIGStk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 14:49:40 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8162110FF7;
        Wed,  7 Sep 2022 11:49:37 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id u18so11544934lfo.8;
        Wed, 07 Sep 2022 11:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=e1NUouMJlIfWMvB5ibq4JexkhbmTjQYF/xGpsCOOr/o=;
        b=oR31toyYyjza92H/8CT1gsP6E4qzxP8L6MxN6LddFykYpGXX4xgTYsWf/02AjAtYk/
         TzCodJ39Nh3UcAuI+J3uiS1we7PglvytuwksgSJjze9J6O/TFKofPy8pnjHJ1nzAHmFm
         XNtc04wKyaEr9ELEYtZf7xp8YQdYjtMs0JzmypI0xA3mXdT8LiYJWsQdRWpere86d2I4
         oow8QJW6dr0QvBSjIMvHbcjgV7BIMlmtO6l6D1+VkI09KGlr5Vdqy9UBhlJ5W8nSoRqU
         NB+OlfZuEk+HreYLyz0QwrsIeo2ZZ02B9Iy+ORDQjRcwwOIMrJxFOxoFjsxSnTq+EMcU
         gE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=e1NUouMJlIfWMvB5ibq4JexkhbmTjQYF/xGpsCOOr/o=;
        b=a4um3zD+T/rdJiDKYgkcFGWbVsRjLF+q1Lrm9LGYXFm53cbXBD/1q5ZN/NwyiP1oI0
         Y6blS+3JoSh15XhkD8fDx13WTJdMdq0kMfTAx+x40zzT8TZRL10y3gvoK82AfttkOTCn
         4aSugxAd2UTLma+qwy02l5I3jQoqOvbQghRL6UD1jj3BvnVJKdUqyzAGPSeBjAS/6sc/
         zbhHPWd3Z9PFG1yj3Yy6QI058XJ7W+l7bPfOUUUcTaPJAt+ZExtJSMKqj7YIfq2tkcwn
         9MSOaPe7kwgtYVDj2IATCNkqLEsm4DK/HbtoGLZ1soU+iOxzh/R+OTZVt0DH19Mk9M9R
         46PQ==
X-Gm-Message-State: ACgBeo29gfWKJqOMXDcWkL6VMNDrkJXs4Oura4n1kV8YauEiLuVk09ts
        04GN53WxXvc67icR+i+VlkRh0wGYdFG2ux0uhjk=
X-Google-Smtp-Source: AA6agR6/hLB2K7ccUe4nRjiLDMnjHHC5/CsLQq94MfUg5Gx9td3rC2XzZVcuuM5UwWGWEsK/7uTzPCABXn7AYQRt8lY=
X-Received: by 2002:a05:6512:3d24:b0:494:95d0:5c02 with SMTP id
 d36-20020a0565123d2400b0049495d05c02mr1682420lfv.198.1662576575720; Wed, 07
 Sep 2022 11:49:35 -0700 (PDT)
MIME-Version: 1.0
References: <20220907170935.11757-1-sven@svenpeter.dev> <20220907170935.11757-4-sven@svenpeter.dev>
In-Reply-To: <20220907170935.11757-4-sven@svenpeter.dev>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 7 Sep 2022 11:49:23 -0700
Message-ID: <CABBYNZLWc=2y0aVRc+_k_XzfJeEJkJ_ebaViqUybvaDY49p2_g@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] Bluetooth: hci_event: Add quirk to ignore byte in
 LE Extended Adv Report
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
        asahi@lists.linux.dev,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven,

On Wed, Sep 7, 2022 at 10:10 AM Sven Peter <sven@svenpeter.dev> wrote:
>
> Broadcom controllers present on Apple Silicon devices use the upper
> 8 bits of the event type in the LE Extended Advertising Report for
> the channel on which the frame has been received.
> Add a quirk to drop the upper byte to ensure that the advertising
> results are parsed correctly.
>
> The following excerpt from a btmon trace shows a report received on
> channel 37 by these controllers:
>
> > HCI Event: LE Meta Event (0x3e) plen 55
>       LE Extended Advertising Report (0x0d)
>         Num reports: 1
>         Entry 0
>           Event type: 0x2513
>             Props: 0x0013
>               Connectable
>               Scannable
>               Use legacy advertising PDUs
>             Data status: Complete
>             Reserved (0x2500)
>           Legacy PDU Type: Reserved (0x2513)
>           Address type: Public (0x00)
>           Address: XX:XX:XX:XX:XX:XX (Shenzhen Jingxun Software [...])
>           Primary PHY: LE 1M
>           Secondary PHY: No packets
>           SID: no ADI field (0xff)
>           TX power: 127 dBm
>           RSSI: -76 dBm (0xb4)
>           Periodic advertising interval: 0.00 msec (0x0000)
>           Direct address type: Public (0x00)
>           Direct address: 00:00:00:00:00:00 (OUI 00-00-00)
>           Data length: 0x1d
>           [...]
>         Flags: 0x18
>           Simultaneous LE and BR/EDR (Controller)
>           Simultaneous LE and BR/EDR (Host)
>         Company: Harman International Industries, Inc. (87)
>           Data: [...]
>         Service Data (UUID 0xfddf):
>         Name (complete): JBL Flip 5
>
> Signed-off-by: Sven Peter <sven@svenpeter.dev>
> ---
> changes from v1:
>   - adjusted the commit message a bit to make checkpatch happy
>
>  include/net/bluetooth/hci.h | 11 +++++++++++
>  net/bluetooth/hci_event.c   |  4 ++++
>  2 files changed, 15 insertions(+)
>
> diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
> index cf29511b25a8..62539c1a6bf2 100644
> --- a/include/net/bluetooth/hci.h
> +++ b/include/net/bluetooth/hci.h
> @@ -263,6 +263,17 @@ enum {
>          * during the hdev->setup vendor callback.
>          */
>         HCI_QUIRK_BROKEN_ENHANCED_SETUP_SYNC_CONN,
> +
> +       /*
> +        * When this quirk is set, the upper 8 bits of the evt_type field of
> +        * the LE Extended Advertising Report events are discarded.
> +        * Some Broadcom controllers found in Apple machines put the channel
> +        * the report was received on into these reserved bits.
> +        *
> +        * This quirk can be set before hci_register_dev is called or
> +        * during the hdev->setup vendor callback.
> +        */
> +       HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
>  };
>
>  /* HCI device flags */
> diff --git a/net/bluetooth/hci_event.c b/net/bluetooth/hci_event.c
> index 485c814cf44a..b50d05211f0d 100644
> --- a/net/bluetooth/hci_event.c
> +++ b/net/bluetooth/hci_event.c
> @@ -6471,6 +6471,10 @@ static void hci_le_ext_adv_report_evt(struct hci_dev *hdev, void *data,
>                         break;
>
>                 evt_type = __le16_to_cpu(info->type);
> +               if (test_bit(HCI_QUIRK_FIXUP_LE_EXT_ADV_REPORT_EVT_TYPE,
> +                            &hdev->quirks))
> +                       evt_type &= 0xff;
> +

Don't think we really need to quirk in order to mask the reserved
bits, according to the 5.3 spec only bits 0-6 are actually valid, that
said the usage of the upper byte is sort of non-standard so I don't
know what is broadcom/apple thinking that they could use like this,
instead this should probably be placed in a vendor command or even add
as part of the data itself with a vendor type.

>                 legacy_evt_type = ext_evt_type_to_legacy(hdev, evt_type);
>                 if (legacy_evt_type != LE_ADV_INVALID) {
>                         process_adv_report(hdev, legacy_evt_type, &info->bdaddr,
> --
> 2.25.1
>


-- 
Luiz Augusto von Dentz
