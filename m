Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506BE694D21
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 17:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbjBMQo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 11:44:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231220AbjBMQo6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 11:44:58 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B938616308
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:44:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676306644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=p2uiqF8o9JdkRigcIZc+ZpBFYKuDDGtLRLHIO1Ia0Y4=;
        b=f9wQrazWuxSCosQEWnXVTEl2G4Nf6xmJQX0Hl5W1rOe4w9z8QAWJOq8h7s76sQqiOKxZbK
        HIPfA9HScNkKgcTz+djJgXnSkrPy1R+08oaIN50n6v2MyJf7b+LFKaJ6Bg8Jg6LZgN0i7/
        NjjWRB0SFfllOHzGhx9ro834o6Z7CD0=
Received: from mail-vk1-f199.google.com (mail-vk1-f199.google.com
 [209.85.221.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-246-9tP154XTMrqR6BTcfL76rQ-1; Mon, 13 Feb 2023 11:44:03 -0500
X-MC-Unique: 9tP154XTMrqR6BTcfL76rQ-1
Received: by mail-vk1-f199.google.com with SMTP id x197-20020a1f7cce000000b00401684aa41aso1697960vkc.17
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 08:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p2uiqF8o9JdkRigcIZc+ZpBFYKuDDGtLRLHIO1Ia0Y4=;
        b=ZlhXYSK5tZ9m3X07Kp7buqSh+p1S9UfNNhZadPFcS9b0t38h20T1UydJXhvi5sbG2w
         laKgCpMIeLaYIfDReArCzJ1oXTyeX57/c7qQYyrI7Ul9c2VH56JD1aTX2+Y6JKrS6Noh
         WoZFENeLDejPVREEQW+UhYqnXaPXQr0leVoEwOBK8wKNRVVRmeCzYzd63wWI0W6nVkZz
         Ngt061FaOlt94X0SJxiI1ukksYKmka/BWTfFgwPnuC19cDck3Q3ppaqqjcM5kwCmfAF6
         aVIoMy0E9FL8UsgaQ2u8Pl7qCDSbGj99+Qk+nItbKoUlaV84wGv67athq6z10BVbXc78
         6Ltg==
X-Gm-Message-State: AO0yUKX/NOgdebZPyytf2aHj5Tug01g1EyvG7nCZAbuIwvF6UMzWcy48
        l6Bv8XHOKGWB1xK44bMgD7wBlAfdEQRglOMrsErB7LEZYfumVrUbTiRi3iLAYG1ubIEPPWj+ruK
        oMHVm7FENHiEFJNdOlZoYlO20KkzOfuqO
X-Received: by 2002:ab0:7702:0:b0:68a:c03f:8bcf with SMTP id z2-20020ab07702000000b0068ac03f8bcfmr39145uaq.15.1676306642681;
        Mon, 13 Feb 2023 08:44:02 -0800 (PST)
X-Google-Smtp-Source: AK7set/2c7YX+hhz2VLCQjUBSZHXtNzsjxLvz6cXa3Ns67kjAfZIDy8YGKX0capXm6mvrk9bs5TUZ2nXBNYO6+cBCdk=
X-Received: by 2002:ab0:7702:0:b0:68a:c03f:8bcf with SMTP id
 z2-20020ab07702000000b0068ac03f8bcfmr39135uaq.15.1676306642375; Mon, 13 Feb
 2023 08:44:02 -0800 (PST)
MIME-Version: 1.0
References: <20230212063813.27622-1-marcan@marcan.st> <20230212063813.27622-2-marcan@marcan.st>
In-Reply-To: <20230212063813.27622-2-marcan@marcan.st>
From:   Eric Curtin <ecurtin@redhat.com>
Date:   Mon, 13 Feb 2023 16:43:46 +0000
Message-ID: <CAOgh=Fz_ma1t6H_p2XQRpq81=4q7MjZuht_f2gA6V=-LmRhufg@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] wifi: brcmfmac: Rename Cypress 89459 to BCM4355
To:     Hector Martin <marcan@marcan.st>
Cc:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Prutskov <alep@cypress.com>,
        Ian Lin <ian.lin@infineon.com>,
        Joseph chuang <jiac@cypress.com>,
        Sven Peter <sven@svenpeter.dev>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Aditya Garg <gargaditya08@live.com>,
        Jonas Gorski <jonas.gorski@gmail.com>, asahi@lists.linux.dev,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 12 Feb 2023 at 06:46, Hector Martin <marcan@marcan.st> wrote:
>
> The commit that introduced support for this chip incorrectly claimed it
> is a Cypress-specific part, while in actuality it is just a variant of
> BCM4355 silicon (as evidenced by the chip ID).
>
> The relationship between Cypress products and Broadcom products isn't
> entirely clear but given what little information is available and prior
> art in the driver, it seems the convention should be that originally
> Broadcom parts should retain the Broadcom name.
>
> Thus, rename the relevant constants and firmware file. Also rename the
> specific 89459 PCIe ID to BCM43596, which seems to be the original
> subvariant name for this PCI ID (as defined in the out-of-tree bcmdhd
> driver).
>
> Since Cypress added this part and will presumably be providing its
> supported firmware, we keep the CYW designation for this device.
>
> We also drop the RAW device ID in this commit. We don't do this for the
> other chips since apparently some devices with them exist in the wild,
> but there is already a 4355 entry with the Broadcom subvendor and WCC
> firmware vendor, so adding a generic fallback to Cypress seems
> redundant (no reason why a device would have the raw device ID *and* an
> explicitly programmed subvendor).
>
> Fixes: dce45ded7619 ("brcmfmac: Support 89459 pcie")
> Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Hector Martin <marcan@marcan.st>

Reviewed-by: Eric Curtin <ecurtin@redhat.com>

Is mise le meas/Regards,

Eric Curtin

> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c    | 5 ++---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    | 7 +++----
>  .../net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h  | 5 ++---
>  3 files changed, 7 insertions(+), 10 deletions(-)
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> index 121893bbaa1d..3e42c2bd0d9a 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/chip.c
> @@ -726,6 +726,7 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
>         case BRCM_CC_43664_CHIP_ID:
>         case BRCM_CC_43666_CHIP_ID:
>                 return 0x200000;
> +       case BRCM_CC_4355_CHIP_ID:
>         case BRCM_CC_4359_CHIP_ID:
>                 return (ci->pub.chiprev < 9) ? 0x180000 : 0x160000;
>         case BRCM_CC_4364_CHIP_ID:
> @@ -735,8 +736,6 @@ static u32 brcmf_chip_tcm_rambase(struct brcmf_chip_priv *ci)
>                 return 0x170000;
>         case BRCM_CC_4378_CHIP_ID:
>                 return 0x352000;
> -       case CY_CC_89459_CHIP_ID:
> -               return ((ci->pub.chiprev < 9) ? 0x180000 : 0x160000);
>         default:
>                 brcmf_err("unknown chip: %s\n", ci->pub.name);
>                 break;
> @@ -1426,8 +1425,8 @@ bool brcmf_chip_sr_capable(struct brcmf_chip *pub)
>                 addr = CORE_CC_REG(base, sr_control1);
>                 reg = chip->ops->read32(chip->ctx, addr);
>                 return reg != 0;
> +       case BRCM_CC_4355_CHIP_ID:
>         case CY_CC_4373_CHIP_ID:
> -       case CY_CC_89459_CHIP_ID:
>                 /* explicitly check SR engine enable bit */
>                 addr = CORE_CC_REG(base, sr_control0);
>                 reg = chip->ops->read32(chip->ctx, addr);
> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> index ae57a9a3ab05..96608174a123 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
> @@ -51,6 +51,7 @@ enum brcmf_pcie_state {
>  BRCMF_FW_DEF(43602, "brcmfmac43602-pcie");
>  BRCMF_FW_DEF(4350, "brcmfmac4350-pcie");
>  BRCMF_FW_DEF(4350C, "brcmfmac4350c2-pcie");
> +BRCMF_FW_CLM_DEF(4355, "brcmfmac4355-pcie");
>  BRCMF_FW_CLM_DEF(4356, "brcmfmac4356-pcie");
>  BRCMF_FW_CLM_DEF(43570, "brcmfmac43570-pcie");
>  BRCMF_FW_DEF(4358, "brcmfmac4358-pcie");
> @@ -62,7 +63,6 @@ BRCMF_FW_DEF(4366B, "brcmfmac4366b-pcie");
>  BRCMF_FW_DEF(4366C, "brcmfmac4366c-pcie");
>  BRCMF_FW_DEF(4371, "brcmfmac4371-pcie");
>  BRCMF_FW_CLM_DEF(4378B1, "brcmfmac4378b1-pcie");
> -BRCMF_FW_DEF(4355, "brcmfmac89459-pcie");
>
>  /* firmware config files */
>  MODULE_FIRMWARE(BRCMF_FW_DEFAULT_PATH "brcmfmac*-pcie.txt");
> @@ -78,6 +78,7 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>         BRCMF_FW_ENTRY(BRCM_CC_4350_CHIP_ID, 0x000000FF, 4350C),
>         BRCMF_FW_ENTRY(BRCM_CC_4350_CHIP_ID, 0xFFFFFF00, 4350),
>         BRCMF_FW_ENTRY(BRCM_CC_43525_CHIP_ID, 0xFFFFFFF0, 4365C),
> +       BRCMF_FW_ENTRY(BRCM_CC_4355_CHIP_ID, 0xFFFFFFFF, 4355),
>         BRCMF_FW_ENTRY(BRCM_CC_4356_CHIP_ID, 0xFFFFFFFF, 4356),
>         BRCMF_FW_ENTRY(BRCM_CC_43567_CHIP_ID, 0xFFFFFFFF, 43570),
>         BRCMF_FW_ENTRY(BRCM_CC_43569_CHIP_ID, 0xFFFFFFFF, 43570),
> @@ -93,7 +94,6 @@ static const struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
>         BRCMF_FW_ENTRY(BRCM_CC_43666_CHIP_ID, 0xFFFFFFF0, 4366C),
>         BRCMF_FW_ENTRY(BRCM_CC_4371_CHIP_ID, 0xFFFFFFFF, 4371),
>         BRCMF_FW_ENTRY(BRCM_CC_4378_CHIP_ID, 0xFFFFFFFF, 4378B1), /* revision ID 3 */
> -       BRCMF_FW_ENTRY(CY_CC_89459_CHIP_ID, 0xFFFFFFFF, 4355),
>  };
>
>  #define BRCMF_PCIE_FW_UP_TIMEOUT               5000 /* msec */
> @@ -2609,9 +2609,8 @@ static const struct pci_device_id brcmf_pcie_devid_table[] = {
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_2G_DEVICE_ID, BCA),
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4366_5G_DEVICE_ID, BCA),
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4371_DEVICE_ID, WCC),
> +       BRCMF_PCIE_DEVICE(BRCM_PCIE_43596_DEVICE_ID, CYW),
>         BRCMF_PCIE_DEVICE(BRCM_PCIE_4378_DEVICE_ID, WCC),
> -       BRCMF_PCIE_DEVICE(CY_PCIE_89459_DEVICE_ID, CYW),
> -       BRCMF_PCIE_DEVICE(CY_PCIE_89459_RAW_DEVICE_ID, CYW),
>         { /* end: all zeroes */ }
>  };
>
> diff --git a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> index f4939cf62767..28b6cf8ff286 100644
> --- a/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> +++ b/drivers/net/wireless/broadcom/brcm80211/include/brcm_hw_ids.h
> @@ -37,6 +37,7 @@
>  #define BRCM_CC_4350_CHIP_ID           0x4350
>  #define BRCM_CC_43525_CHIP_ID          43525
>  #define BRCM_CC_4354_CHIP_ID           0x4354
> +#define BRCM_CC_4355_CHIP_ID           0x4355
>  #define BRCM_CC_4356_CHIP_ID           0x4356
>  #define BRCM_CC_43566_CHIP_ID          43566
>  #define BRCM_CC_43567_CHIP_ID          43567
> @@ -56,7 +57,6 @@
>  #define CY_CC_43012_CHIP_ID            43012
>  #define CY_CC_43439_CHIP_ID            43439
>  #define CY_CC_43752_CHIP_ID            43752
> -#define CY_CC_89459_CHIP_ID            0x4355
>
>  /* USB Device IDs */
>  #define BRCM_USB_43143_DEVICE_ID       0xbd1e
> @@ -90,9 +90,8 @@
>  #define BRCM_PCIE_4366_2G_DEVICE_ID    0x43c4
>  #define BRCM_PCIE_4366_5G_DEVICE_ID    0x43c5
>  #define BRCM_PCIE_4371_DEVICE_ID       0x440d
> +#define BRCM_PCIE_43596_DEVICE_ID      0x4415
>  #define BRCM_PCIE_4378_DEVICE_ID       0x4425
> -#define CY_PCIE_89459_DEVICE_ID         0x4415
> -#define CY_PCIE_89459_RAW_DEVICE_ID     0x4355
>
>  /* brcmsmac IDs */
>  #define BCM4313_D11N2G_ID      0x4727  /* 4313 802.11n 2.4G device */
> --
> 2.35.1
>
>

