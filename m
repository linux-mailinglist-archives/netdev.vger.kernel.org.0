Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C2768CB58
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 01:43:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBGAnG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 19:43:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbjBGAnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 19:43:05 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4192824CBB;
        Mon,  6 Feb 2023 16:43:03 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id d8so13887545ljq.9;
        Mon, 06 Feb 2023 16:43:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=aZutm5hPrBdZUb67UXyFX833bOiP7wUg+HuM8BYZCPc=;
        b=gsIAlDkYYd+bR20KKCVDS6qXI7hHNUh2ZyKeYcuquWVc9tNPcxLgDNNd4WeKnZIwof
         6mFhvPj1cAhRwTzHGXrDXFSxTHl36z7UF1DvT3tQYGjVdRHLOIqCrKcM4DCe23S4BVk7
         yKmP2vLQosQ9npUlFnifSdPnLhMkr96cMZoW2Xx3Pcxr0Gg4tgww53FRR7KX6H6OlIAK
         NcSlR3pZzkb9D7jmw2aVPXVO/knYoqO5DiS1kNn/r+7tVR+T46gpr7reWDW9JpTuvtT9
         j6BuZRgoFGJNpfM+8ABL3mmdE8qiY9gu/fv8NBs9g7IGlE5syGZUU2b9+U/YBso2f0PI
         fMOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aZutm5hPrBdZUb67UXyFX833bOiP7wUg+HuM8BYZCPc=;
        b=WVAKxizZZ7Lf0ZTy3KZ11N9RIKFdqvyFUFpJy6YWfzMRp0dlURUyVqQyMW5YU744HO
         DrGL1G0h0YI4udyfim5ldLcTPofTHvZPj8QUtDURzJuBuIfBLmFugWPM0NWM3qG2QVHV
         /bn25nlUM+3eHs1JyQQhnkcRCs1qP5sf4Xe8hMBiR/q6KKxeRRXAh/F36zhHr2+IFGD8
         f6bWnf/UHMqAcyS5lyT9at7ZUy4nxsDjrYwntLDQPoJ7A1/Ao2XuQj/af5x891lrHHsX
         wPiUawltgLpL4LhRxf71NczB50iRwHXuVnWGC1pgj292B7T66Gyir9mKwDf9A+Y030zw
         beVQ==
X-Gm-Message-State: AO0yUKXE/nXwnOpb4dQH8oAI+H0A+/SQGd3RDa9vFcqGkok+YSEAt7uV
        PFp63xwtJI3Jvy9wW08BmxcAVvlzwil9DMRYSNo=
X-Google-Smtp-Source: AK7set87PYXzpGAQX0poJ1aVH7vFdN80t4jSB+Vmc3Blj+rHFthMrYCfPH4yXHNHnUki46CYU5g0YqsflkIUGG2IxGA=
X-Received: by 2002:a2e:9c4b:0:b0:293:ed1:ee6f with SMTP id
 t11-20020a2e9c4b000000b002930ed1ee6fmr192493ljj.119.1675730581330; Mon, 06
 Feb 2023 16:43:01 -0800 (PST)
MIME-Version: 1.0
References: <20230206233912.9410-1-bage@debian.org> <20230206233912.9410-3-bage@debian.org>
In-Reply-To: <20230206233912.9410-3-bage@debian.org>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Mon, 6 Feb 2023 16:42:49 -0800
Message-ID: <CABBYNZJo_y9zoF_YbjWYgkNrXUne-cp7vkBB7omFE-W4fTihLg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] Bluetooth: btrtl: add support for the RTL8723CS
To:     Bastian Germann <bage@debian.org>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

Hi Bastian,

On Mon, Feb 6, 2023 at 3:39 PM Bastian Germann <bage@debian.org> wrote:
>
> From: Vasily Khoruzhick <anarsoul@gmail.com>
>
> The Realtek RTL8723CS is SDIO WiFi chip. It also contains a Bluetooth
> module which is connected via UART to the host.
>
> It shares lmp subversion with 8703B, so Realtek's userspace
> initialization tool (rtk_hciattach) differentiates varieties of RTL8723CS
> (CG, VF, XX) with RTL8703B using vendor's command to read chip type.
>
> Also this chip declares support for some features it doesn't support
> so add a quirk to indicate that these features are broken.
>
> Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
> Signed-off-by: Bastian Germann <bage@debian.org>
> ---
>  drivers/bluetooth/btrtl.c  | 120 +++++++++++++++++++++++++++++++++++--
>  drivers/bluetooth/btrtl.h  |   5 ++
>  drivers/bluetooth/hci_h5.c |   4 ++
>  3 files changed, 125 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/bluetooth/btrtl.c b/drivers/bluetooth/btrtl.c
> index 69c3fe649ca7..97716cab7617 100644
> --- a/drivers/bluetooth/btrtl.c
> +++ b/drivers/bluetooth/btrtl.c
> @@ -17,7 +17,11 @@
>
>  #define VERSION "0.1"
>
> +#define RTL_CHIP_8723CS_CG     3
> +#define RTL_CHIP_8723CS_VF     4
> +#define RTL_CHIP_8723CS_XX     5
>  #define RTL_EPATCH_SIGNATURE   "Realtech"
> +#define RTL_ROM_LMP_8703B      0x8703
>  #define RTL_ROM_LMP_8723A      0x1200
>  #define RTL_ROM_LMP_8723B      0x8723
>  #define RTL_ROM_LMP_8821A      0x8821
> @@ -30,6 +34,7 @@
>  #define IC_MATCH_FL_HCIREV     (1 << 1)
>  #define IC_MATCH_FL_HCIVER     (1 << 2)
>  #define IC_MATCH_FL_HCIBUS     (1 << 3)
> +#define IC_MATCH_FL_CHIP_TYPE  (1 << 4)
>  #define IC_INFO(lmps, hcir, hciv, bus) \
>         .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_HCIREV | \
>                        IC_MATCH_FL_HCIVER | IC_MATCH_FL_HCIBUS, \
> @@ -59,6 +64,7 @@ struct id_table {
>         __u16 hci_rev;
>         __u8 hci_ver;
>         __u8 hci_bus;
> +       __u8 chip_type;
>         bool config_needed;
>         bool has_rom_version;
>         bool has_msft_ext;
> @@ -99,6 +105,39 @@ static const struct id_table ic_id_table[] = {
>           .fw_name  = "rtl_bt/rtl8723b_fw.bin",
>           .cfg_name = "rtl_bt/rtl8723b_config" },
>
> +       /* 8723CS-CG */
> +       { .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
> +                        IC_MATCH_FL_HCIBUS,
> +         .lmp_subver = RTL_ROM_LMP_8703B,
> +         .chip_type = RTL_CHIP_8723CS_CG,
> +         .hci_bus = HCI_UART,
> +         .config_needed = true,
> +         .has_rom_version = true,
> +         .fw_name  = "rtl_bt/rtl8723cs_cg_fw.bin",
> +         .cfg_name = "rtl_bt/rtl8723cs_cg_config" },
> +
> +       /* 8723CS-VF */
> +       { .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
> +                        IC_MATCH_FL_HCIBUS,
> +         .lmp_subver = RTL_ROM_LMP_8703B,
> +         .chip_type = RTL_CHIP_8723CS_VF,
> +         .hci_bus = HCI_UART,
> +         .config_needed = true,
> +         .has_rom_version = true,
> +         .fw_name  = "rtl_bt/rtl8723cs_vf_fw.bin",
> +         .cfg_name = "rtl_bt/rtl8723cs_vf_config" },
> +
> +       /* 8723CS-XX */
> +       { .match_flags = IC_MATCH_FL_LMPSUBV | IC_MATCH_FL_CHIP_TYPE |
> +                        IC_MATCH_FL_HCIBUS,
> +         .lmp_subver = RTL_ROM_LMP_8703B,
> +         .chip_type = RTL_CHIP_8723CS_XX,
> +         .hci_bus = HCI_UART,
> +         .config_needed = true,
> +         .has_rom_version = true,
> +         .fw_name  = "rtl_bt/rtl8723cs_xx_fw.bin",
> +         .cfg_name = "rtl_bt/rtl8723cs_xx_config" },
> +
>         /* 8723D */
>         { IC_INFO(RTL_ROM_LMP_8723B, 0xd, 0x8, HCI_USB),
>           .config_needed = true,
> @@ -208,7 +247,8 @@ static const struct id_table ic_id_table[] = {
>         };
>
>  static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
> -                                            u8 hci_ver, u8 hci_bus)
> +                                            u8 hci_ver, u8 hci_bus,
> +                                            u8 chip_type)
>  {
>         int i;
>
> @@ -225,6 +265,9 @@ static const struct id_table *btrtl_match_ic(u16 lmp_subver, u16 hci_rev,
>                 if ((ic_id_table[i].match_flags & IC_MATCH_FL_HCIBUS) &&
>                     (ic_id_table[i].hci_bus != hci_bus))
>                         continue;
> +               if ((ic_id_table[i].match_flags & IC_MATCH_FL_CHIP_TYPE) &&
> +                   (ic_id_table[i].chip_type != chip_type))
> +                       continue;
>
>                 break;
>         }
> @@ -307,6 +350,7 @@ static int rtlbt_parse_firmware(struct hci_dev *hdev,
>                 { RTL_ROM_LMP_8723B, 1 },
>                 { RTL_ROM_LMP_8821A, 2 },
>                 { RTL_ROM_LMP_8761A, 3 },
> +               { RTL_ROM_LMP_8703B, 7 },
>                 { RTL_ROM_LMP_8822B, 8 },
>                 { RTL_ROM_LMP_8723B, 9 },       /* 8723D */
>                 { RTL_ROM_LMP_8821A, 10 },      /* 8821C */
> @@ -587,6 +631,48 @@ static int btrtl_setup_rtl8723b(struct hci_dev *hdev,
>         return ret;
>  }
>
> +static bool rtl_has_chip_type(u16 lmp_subver)
> +{
> +       switch (lmp_subver) {
> +       case RTL_ROM_LMP_8703B:
> +               return true;
> +       default:
> +               break;
> +       }
> +
> +       return  false;
> +}
> +
> +static int rtl_read_chip_type(struct hci_dev *hdev, u8 *type)
> +{
> +       struct rtl_chip_type_evt *chip_type;
> +       struct sk_buff *skb;
> +       const unsigned char cmd_buf[] = {0x00, 0x94, 0xa0, 0x00, 0xb0};
> +
> +       /* Read RTL chip type command */
> +       skb = __hci_cmd_sync(hdev, 0xfc61, 5, cmd_buf, HCI_INIT_TIMEOUT);
> +       if (IS_ERR(skb)) {
> +               rtl_dev_err(hdev, "Read chip type failed (%ld)",
> +                           PTR_ERR(skb));
> +               return PTR_ERR(skb);
> +       }
> +
> +       if (skb->len != sizeof(*chip_type)) {
> +               rtl_dev_err(hdev, "RTL chip type event length mismatch");
> +               kfree_skb(skb);
> +               return -EIO;
> +       }
> +
> +       chip_type = (struct rtl_chip_type_evt *)skb->data;

You can probably use skb_pull_data instead of trying to cast skb->data directly.

> +       rtl_dev_info(hdev, "chip_type status=%x type=%x",
> +                    chip_type->status, chip_type->type);
> +
> +       *type = chip_type->type & 0x0f;
> +
> +       kfree_skb(skb);
> +       return 0;
> +}
> +
>  void btrtl_free(struct btrtl_device_info *btrtl_dev)
>  {
>         kvfree(btrtl_dev->fw_data);
> @@ -603,7 +689,7 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
>         struct hci_rp_read_local_version *resp;
>         char cfg_name[40];
>         u16 hci_rev, lmp_subver;
> -       u8 hci_ver;
> +       u8 hci_ver, chip_type = 0;
>         int ret;
>         u16 opcode;
>         u8 cmd[2];
> @@ -629,8 +715,14 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
>         hci_rev = le16_to_cpu(resp->hci_rev);
>         lmp_subver = le16_to_cpu(resp->lmp_subver);
>
> +       if (rtl_has_chip_type(lmp_subver)) {
> +               ret = rtl_read_chip_type(hdev, &chip_type);
> +               if (ret)
> +                       goto err_free;
> +       }
> +
>         btrtl_dev->ic_info = btrtl_match_ic(lmp_subver, hci_rev, hci_ver,
> -                                           hdev->bus);
> +                                           hdev->bus, chip_type);
>
>         if (!btrtl_dev->ic_info)
>                 btrtl_dev->drop_fw = true;
> @@ -673,7 +765,7 @@ struct btrtl_device_info *btrtl_initialize(struct hci_dev *hdev,
>                 lmp_subver = le16_to_cpu(resp->lmp_subver);
>
>                 btrtl_dev->ic_info = btrtl_match_ic(lmp_subver, hci_rev, hci_ver,
> -                                                   hdev->bus);
> +                                                   hdev->bus, chip_type);
>         }
>  out_free:
>         kfree_skb(skb);
> @@ -755,6 +847,7 @@ int btrtl_download_firmware(struct hci_dev *hdev,
>         case RTL_ROM_LMP_8761A:
>         case RTL_ROM_LMP_8822B:
>         case RTL_ROM_LMP_8852A:
> +       case RTL_ROM_LMP_8703B:
>                 return btrtl_setup_rtl8723b(hdev, btrtl_dev);
>         default:
>                 rtl_dev_info(hdev, "assuming no firmware upload needed");
> @@ -795,6 +888,19 @@ void btrtl_set_quirks(struct hci_dev *hdev, struct btrtl_device_info *btrtl_dev)
>                 rtl_dev_dbg(hdev, "WBS supported not enabled.");
>                 break;
>         }
> +
> +       switch (btrtl_dev->ic_info->lmp_subver) {
> +       case RTL_ROM_LMP_8703B:
> +               /* 8723CS reports two pages for local ext features,
> +                * but it doesn't support any features from page 2 -
> +                * it either responds with garbage or with error status
> +                */
> +               set_bit(HCI_QUIRK_BROKEN_LOCAL_EXT_FEATURES_PAGE_2,
> +                       &hdev->quirks);
> +               break;
> +       default:
> +               break;
> +       }
>  }
>  EXPORT_SYMBOL_GPL(btrtl_set_quirks);
>
> @@ -953,6 +1059,12 @@ MODULE_FIRMWARE("rtl_bt/rtl8723b_fw.bin");
>  MODULE_FIRMWARE("rtl_bt/rtl8723b_config.bin");
>  MODULE_FIRMWARE("rtl_bt/rtl8723bs_fw.bin");
>  MODULE_FIRMWARE("rtl_bt/rtl8723bs_config.bin");
> +MODULE_FIRMWARE("rtl_bt/rtl8723cs_cg_fw.bin");
> +MODULE_FIRMWARE("rtl_bt/rtl8723cs_cg_config.bin");
> +MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_fw.bin");
> +MODULE_FIRMWARE("rtl_bt/rtl8723cs_vf_config.bin");
> +MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_fw.bin");
> +MODULE_FIRMWARE("rtl_bt/rtl8723cs_xx_config.bin");
>  MODULE_FIRMWARE("rtl_bt/rtl8723ds_fw.bin");
>  MODULE_FIRMWARE("rtl_bt/rtl8723ds_config.bin");
>  MODULE_FIRMWARE("rtl_bt/rtl8761a_fw.bin");
> diff --git a/drivers/bluetooth/btrtl.h b/drivers/bluetooth/btrtl.h
> index ebf0101c959b..349d72ee571b 100644
> --- a/drivers/bluetooth/btrtl.h
> +++ b/drivers/bluetooth/btrtl.h
> @@ -14,6 +14,11 @@
>
>  struct btrtl_device_info;
>
> +struct rtl_chip_type_evt {
> +       __u8 status;
> +       __u8 type;
> +} __packed;
> +
>  struct rtl_download_cmd {
>         __u8 index;
>         __u8 data[RTL_FRAG_LEN];
> diff --git a/drivers/bluetooth/hci_h5.c b/drivers/bluetooth/hci_h5.c
> index 6455bc4fb5bb..e90670955df2 100644
> --- a/drivers/bluetooth/hci_h5.c
> +++ b/drivers/bluetooth/hci_h5.c
> @@ -936,6 +936,8 @@ static int h5_btrtl_setup(struct h5 *h5)
>         err = btrtl_download_firmware(h5->hu->hdev, btrtl_dev);
>         /* Give the device some time before the hci-core sends it a reset */
>         usleep_range(10000, 20000);
> +       if (err)
> +               goto out_free;
>
>         btrtl_set_quirks(h5->hu->hdev, btrtl_dev);
>
> @@ -1100,6 +1102,8 @@ static const struct of_device_id rtl_bluetooth_of_match[] = {
>           .data = (const void *)&h5_data_rtl8822cs },
>         { .compatible = "realtek,rtl8723bs-bt",
>           .data = (const void *)&h5_data_rtl8723bs },
> +       { .compatible = "realtek,rtl8723cs-bt",
> +         .data = (const void *)&h5_data_rtl8723bs },
>         { .compatible = "realtek,rtl8723ds-bt",
>           .data = (const void *)&h5_data_rtl8723bs },
>  #endif
> --
> 2.39.1
>


-- 
Luiz Augusto von Dentz
