Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4256968FC47
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 01:59:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbjBIA7i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 19:59:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229814AbjBIA7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 19:59:37 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DE7F22780
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 16:59:35 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id x26-20020a056830115a00b0068bbc0ee3eeso128734otq.0
        for <netdev@vger.kernel.org>; Wed, 08 Feb 2023 16:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mtpRDoplcuCictdCyoDGjkhBUdzEOAwK0eQ9y/v4TiQ=;
        b=V+FDzkZK0UwpJUgXwMl/DiABSH3frlMoycQNIRHLN+58dWDLF1YfjLWoW3vt7oH3pA
         8WXoLET2X/F4mTNrabgEkhAwm0NjdS+FGGudN2Tku7kGFcMmosGYByBLtNGTHgdERjdC
         UoLDOcFhI6L7z85tURO9sMaZeUAFDkHN7BqLrI4DHFMRdUfisRcSbXGtCoZnGRN9+nFp
         rxpUVnze7t9OsJs/2dJV8Ht/+foftneGpKocTUWww8zq2C9aUb2ZCkQgJhhPX6gDC81a
         xCIircRzumjUNqzouRqHF0BeBD2P8kGii7BIGePiNGQaw52nueCf7b2SLhzxH2PjZSz8
         71Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mtpRDoplcuCictdCyoDGjkhBUdzEOAwK0eQ9y/v4TiQ=;
        b=I44HSyxPpMM0LznitkcwxqYkTSHmEliqe7unY1Kftuun/NbOk3h4G5U6t+1qz3l39x
         AfE04Xd5X1UWAxwRqcIZuljKjNDlHeez9/gHLm43mkzc1ff6sFTDUeoc3zfMXgKSxsfn
         BCCNl009rl2OchuhT9KM1ShNGq3934CX9MODyCKvUZMisDw8Nj5070VYOvwZMKU36ls2
         b/r4Y5klCk7ZwuAG25L4jn+Y64HEmFMJ/gFxyQpI1ZPqUQUyeGh4TOp9duCom7Tv5lTt
         wgKSKzXKBD1iyi5xBj1E//fEIqL0/SjgmmONCMsoDonU8ebiUV1vs6t4nXbSy5AVxBP1
         /aCg==
X-Gm-Message-State: AO0yUKXUCVJLePBSmNs6r3k530yAqmnPLGzZ2GXUPyZQzqN2ma1t45UW
        +F2HirI+x5AlmqiHGKgfzb1VGA==
X-Google-Smtp-Source: AK7set/qDHVfF1GJxl7DerqtF680JctDHE+JBJqrviZf22umWNz6wqgE16v03FR0wFG+JsbArHe/2Q==
X-Received: by 2002:a05:6830:2004:b0:68b:a341:b93b with SMTP id e4-20020a056830200400b0068ba341b93bmr4941251otp.36.1675904374702;
        Wed, 08 Feb 2023 16:59:34 -0800 (PST)
Received: from localhost (23-118-233-243.lightspeed.snantx.sbcglobal.net. [23.118.233.243])
        by smtp.gmail.com with ESMTPSA id d2-20020a056830044200b0066ca61230casm8870530otc.8.2023.02.08.16.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Feb 2023 16:59:34 -0800 (PST)
From:   Steev Klimaszewski <steev@kali.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Subject: Re: [PATCH v4 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth chip wcn6855
Date:   Wed,  8 Feb 2023 18:59:32 -0600
Message-Id: <20230209005932.4351-1-steev@kali.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <CABBYNZLaOcYU-2HsSuJy4E6-OyfffmZdfK5mxWY=Wto4G84ySA@mail.gmail.com>
References: <CABBYNZLaOcYU-2HsSuJy4E6-OyfffmZdfK5mxWY=Wto4G84ySA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Hi Steev,
>
>On Mon, Feb 6, 2023 at 9:28 PM Steev Klimaszewski <steev@kali.org> wrote:
>>
>> Added regulators,GPIOs and changes required to power on/off wcn6855.
>> Added support for firmware download for wcn6855.
>>
>> Signed-off-by: Steev Klimaszewski <steev@kali.org>
>> ---
>>
>> Changes since v3:
>>  * drop unused regulators
>>
>> Changes since v2:
>>  * drop unnecessary commit info
>>
>> Changes since v1:
>>  * None
>> ---
>>  drivers/bluetooth/btqca.c   | 24 ++++++++++++++--
>>  drivers/bluetooth/btqca.h   | 10 +++++++
>>  drivers/bluetooth/hci_qca.c | 56 ++++++++++++++++++++++++++++---------
>>  3 files changed, 75 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
>> index c9064d34d830..456b961b9554 100644
>> --- a/drivers/bluetooth/btqca.c
>> +++ b/drivers/bluetooth/btqca.c
>> @@ -472,6 +472,19 @@ static int qca_download_firmware(struct hci_dev *hdev,
>>                                            config->fwname, ret);
>>                                 return ret;
>>                         }
>> +               } else if (soc_type == QCA_WCN6855 && config->type == ELF_TYPE_PATCH) {
>> +                       bt_dev_dbg(hdev, "QCA Failed to request file: %s (%d)",
>> +                                  config->fwname, ret);
>
>I suspect the above message is not really needed since you didn't even
>request the firmware at this point.
>

You are correct, I was copying from the 6750's work, where they have a .mbn file
available, and as far as I could tell looking through the Windows firmware
folders, we do not; so we shouldn't ever hit that.  I've removed it.

>> +                       config->type = TLV_TYPE_PATCH;
>> +                       snprintf(config->fwname, sizeof(config->fwname),
>> +                                "qca/hpbtfw%02x.tlv", rom_ver);
>> +                       bt_dev_info(hdev, "QCA Downloading %s", config->fwname);
>> +                       ret = request_firmware(&fw, config->fwname, &hdev->dev);
>> +                       if (ret) {
>> +                               bt_dev_err(hdev, "QCA Failed to request file: %s (%d)",
>> +                                          config->fwname, ret);
>> +                               return ret;
>> +                       }
>>                 } else {
>>                         bt_dev_err(hdev, "QCA Failed to request file: %s (%d)",
>>                                    config->fwname, ret);
>> @@ -596,7 +609,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>>          */
>>         rom_ver = ((soc_ver & 0x00000f00) >> 0x04) | (soc_ver & 0x0000000f);
>>
>> -       if (soc_type == QCA_WCN6750)
>> +       if (soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855)
>>                 qca_send_patch_config_cmd(hdev);
>>
>>         /* Download rampatch file */
>> @@ -614,6 +627,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>>                 config.type = ELF_TYPE_PATCH;
>>                 snprintf(config.fwname, sizeof(config.fwname),
>>                          "qca/msbtfw%02x.mbn", rom_ver);
>> +       } else if (soc_type == QCA_WCN6855) {
>> +               snprintf(config.fwname, sizeof(config.fwname),
>> +                        "qca/hpbtfw%02x.tlv", rom_ver);
>>         } else {
>>                 snprintf(config.fwname, sizeof(config.fwname),
>>                          "qca/rampatch_%08x.bin", soc_ver);
>> @@ -648,6 +664,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>>         else if (soc_type == QCA_WCN6750)
>>                 snprintf(config.fwname, sizeof(config.fwname),
>>                          "qca/msnv%02x.bin", rom_ver);
>> +       else if (soc_type == QCA_WCN6855)
>> +               snprintf(config.fwname, sizeof(config.fwname),
>> +                        "qca/hpnv%02x.bin", rom_ver);
>>         else
>>                 snprintf(config.fwname, sizeof(config.fwname),
>>                          "qca/nvm_%08x.bin", soc_ver);
>> @@ -672,6 +691,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>>         case QCA_WCN3991:
>>         case QCA_WCN3998:
>>         case QCA_WCN6750:
>> +       case QCA_WCN6855:
>>                 hci_set_msft_opcode(hdev, 0xFD70);
>>                 break;
>>         default:
>> @@ -685,7 +705,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t baudrate,
>>                 return err;
>>         }
>>
>> -       if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750) {
>> +       if (soc_type == QCA_WCN3991 || soc_type == QCA_WCN6750 || soc_type == QCA_WCN6855) {
>>                 /* get fw build info */
>>                 err = qca_read_fw_build_info(hdev);
>>                 if (err < 0)
>> diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
>> index 61e9a50e66ae..b884095bcd9d 100644
>> --- a/drivers/bluetooth/btqca.h
>> +++ b/drivers/bluetooth/btqca.h
>> @@ -147,6 +147,7 @@ enum qca_btsoc_type {
>>         QCA_WCN3991,
>>         QCA_QCA6390,
>>         QCA_WCN6750,
>> +       QCA_WCN6855,
>>  };
>>
>>  #if IS_ENABLED(CONFIG_BT_QCA)
>> @@ -168,6 +169,10 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
>>  {
>>         return soc_type == QCA_WCN6750;
>>  }
>> +static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
>> +{
>> +       return soc_type == QCA_WCN6855;
>> +}
>>
>>  #else
>>
>> @@ -206,6 +211,11 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_type soc_type)
>>         return false;
>>  }
>>
>> +static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
>> +{
>> +       return false;
>> +}
>> +
>>  static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
>>  {
>>         return -EOPNOTSUPP;
>> diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
>> index 3df8c3606e93..a35612ba23b2 100644
>> --- a/drivers/bluetooth/hci_qca.c
>> +++ b/drivers/bluetooth/hci_qca.c
>> @@ -606,7 +606,8 @@ static int qca_open(struct hci_uart *hu)
>>                 qcadev = serdev_device_get_drvdata(hu->serdev);
>>
>>                 if (qca_is_wcn399x(qcadev->btsoc_type) ||
>> -                   qca_is_wcn6750(qcadev->btsoc_type))
>> +                   qca_is_wcn6750(qcadev->btsoc_type) ||
>> +                   qca_is_wcn6855(qcadev->btsoc_type))
>>                         hu->init_speed = qcadev->init_speed;
>
>This is really ugly I must say, why don't we just check if
>qcadev->init_speed has been set then we set it as hu->init_speed?
>
I think I've addressed this in v5, and hopefully I've done it right.

>>                 if (qcadev->oper_speed)
>> @@ -1317,7 +1318,8 @@ static int qca_set_baudrate(struct hci_dev *hdev, uint8_t baudrate)
>>
>>         /* Give the controller time to process the request */
>>         if (qca_is_wcn399x(qca_soc_type(hu)) ||
>> -           qca_is_wcn6750(qca_soc_type(hu)))
>> +           qca_is_wcn6750(qca_soc_type(hu)) ||
>> +           qca_is_wcn6855(qca_soc_type(hu)))
>>                 usleep_range(1000, 10000);
>>         else
>>                 msleep(300);
>> @@ -1394,7 +1396,8 @@ static unsigned int qca_get_speed(struct hci_uart *hu,
>>  static int qca_check_speeds(struct hci_uart *hu)
>>  {
>>         if (qca_is_wcn399x(qca_soc_type(hu)) ||
>> -           qca_is_wcn6750(qca_soc_type(hu))) {
>> +           qca_is_wcn6750(qca_soc_type(hu)) ||
>> +           qca_is_wcn6855(qca_soc_type(hu))) {
>>                 if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
>>                     !qca_get_speed(hu, QCA_OPER_SPEED))
>>                         return -EINVAL;
>> @@ -1428,7 +1431,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
>>                  * changing the baudrate of chip and host.
>>                  */
>>                 if (qca_is_wcn399x(soc_type) ||
>> -                   qca_is_wcn6750(soc_type))
>> +                   qca_is_wcn6750(soc_type) ||
>> +                   qca_is_wcn6855(soc_type))
>>                         hci_uart_set_flow_control(hu, true);
>>
>>                 if (soc_type == QCA_WCN3990) {
>> @@ -1446,7 +1450,8 @@ static int qca_set_speed(struct hci_uart *hu, enum qca_speed_type speed_type)
>>
>>  error:
>>                 if (qca_is_wcn399x(soc_type) ||
>> -                   qca_is_wcn6750(soc_type))
>> +                   qca_is_wcn6750(soc_type) ||
>> +                   qca_is_wcn6855(soc_type))
>>                         hci_uart_set_flow_control(hu, false);
>>
>>                 if (soc_type == QCA_WCN3990) {
>> @@ -1682,7 +1687,8 @@ static int qca_power_on(struct hci_dev *hdev)
>>                 return 0;
>>
>>         if (qca_is_wcn399x(soc_type) ||
>> -           qca_is_wcn6750(soc_type)) {
>> +           qca_is_wcn6750(soc_type) ||
>> +           qca_is_wcn6855(soc_type)) {
>>                 ret = qca_regulator_init(hu);
>>         } else {
>>                 qcadev = serdev_device_get_drvdata(hu->serdev);
>> @@ -1723,7 +1729,8 @@ static int qca_setup(struct hci_uart *hu)
>>
>>         bt_dev_info(hdev, "setting up %s",
>>                 qca_is_wcn399x(soc_type) ? "wcn399x" :
>> -               (soc_type == QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390");
>> +               (soc_type == QCA_WCN6750) ? "wcn6750" :
>> +               (soc_type == QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390");
>>
>>         qca->memdump_state = QCA_MEMDUMP_IDLE;
>>
>> @@ -1735,7 +1742,8 @@ static int qca_setup(struct hci_uart *hu)
>>         clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
>>
>>         if (qca_is_wcn399x(soc_type) ||
>> -           qca_is_wcn6750(soc_type)) {
>> +           qca_is_wcn6750(soc_type) ||
>> +           qca_is_wcn6855(soc_type)) {
>>                 set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
>>                 hci_set_aosp_capable(hdev);
>>
>> @@ -1757,7 +1765,8 @@ static int qca_setup(struct hci_uart *hu)
>>         }
>>
>>         if (!(qca_is_wcn399x(soc_type) ||
>> -            qca_is_wcn6750(soc_type))) {
>> +            qca_is_wcn6750(soc_type) ||
>> +            qca_is_wcn6855(soc_type))) {
>>                 /* Get QCA version information */
>>                 ret = qca_read_soc_version(hdev, &ver, soc_type);
>>                 if (ret)
>> @@ -1883,6 +1892,20 @@ static const struct qca_device_data qca_soc_data_wcn6750 = {
>>         .capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
>>  };
>>
>> +static const struct qca_device_data qca_soc_data_wcn6855 = {
>> +       .soc_type = QCA_WCN6855,
>> +       .vregs = (struct qca_vreg []) {
>> +               { "vddio", 5000 },
>> +               { "vddbtcxmx", 126000 },
>> +               { "vddrfacmn", 12500 },
>> +               { "vddrfa0p8", 102000 },
>> +               { "vddrfa1p7", 302000 },
>> +               { "vddrfa1p2", 257000 },
>> +       },
>> +       .num_vregs = 6,
>> +       .capabilities = QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STATES,
>
>Since it appears there is already a struct like this for each soc type
>we could perhaps just extend with the data needed instead of checking
>the soc_type over and over again.

I'm definitely new to all of this, and if you mean something like a
quirks/feature set instead, that sounds like a good idea, however, it's quite a
bit over my head.

Additionally, I noticed your similar comments in
https://lore.kernel.org/all/CABBYNZLaOcYU-2HsSuJy4E6-OyfffmZdfK5mxWY=Wto4G84ySA@mail.gmail.com/
which is Tim's patch for the QCA2066.  I actually think both the WCN6855 and the
QCA2066 might be the same chip?  I'm not at Qualcomm, just someone who wanted to
get bluetooth working on my Thinkpad X13s and so I started poking at it until
something worked.  If someone from Qualcomm could confirm or say, one way or the
other, that would be great.  The QCA2066 and my patch do seem to use the same
firmware at least.

>> +};
>> +
>>  static void qca_power_shutdown(struct hci_uart *hu)
>>  {
>>         struct qca_serdev *qcadev;
>> @@ -2047,7 +2070,8 @@ static int qca_serdev_probe(struct serdev_device *serdev)
>>
>>         if (data &&
>>             (qca_is_wcn399x(data->soc_type) ||
>> -           qca_is_wcn6750(data->soc_type))) {
>> +           qca_is_wcn6750(data->soc_type) ||
>> +           qca_is_wcn6855(data->soc_type))) {
>>                 qcadev->btsoc_type = data->soc_type;
>>                 qcadev->bt_power = devm_kzalloc(&serdev->dev,
>>                                                 sizeof(struct qca_power),
>> @@ -2067,14 +2091,18 @@ static int qca_serdev_probe(struct serdev_device *serdev)
>>
>>                 qcadev->bt_en = devm_gpiod_get_optional(&serdev->dev, "enable",
>>                                                GPIOD_OUT_LOW);
>> -               if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type == QCA_WCN6750) {
>> +               if (IS_ERR_OR_NULL(qcadev->bt_en)
>> +                   && (data->soc_type == QCA_WCN6750 ||
>> +                       data->soc_type == QCA_WCN6855)) {
>>                         dev_err(&serdev->dev, "failed to acquire BT_EN gpio\n");
>>                         power_ctrl_enabled = false;
>>                 }
>>
>>                 qcadev->sw_ctrl = devm_gpiod_get_optional(&serdev->dev, "swctrl",
>>                                                GPIOD_IN);
>> -               if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type == QCA_WCN6750)
>> +               if (IS_ERR_OR_NULL(qcadev->sw_ctrl)
>> +                   && (data->soc_type == QCA_WCN6750 ||
>> +                       data->soc_type == QCA_WCN6855))
>>                         dev_warn(&serdev->dev, "failed to acquire SW_CTRL gpio\n");
>>
>>                 qcadev->susclk = devm_clk_get_optional(&serdev->dev, NULL);
>> @@ -2150,7 +2178,8 @@ static void qca_serdev_remove(struct serdev_device *serdev)
>>         struct qca_power *power = qcadev->bt_power;
>>
>>         if ((qca_is_wcn399x(qcadev->btsoc_type) ||
>> -            qca_is_wcn6750(qcadev->btsoc_type)) &&
>> +            qca_is_wcn6750(qcadev->btsoc_type) ||
>> +            qca_is_wcn6855(qcadev->btsoc_type)) &&
>>              power->vregs_on)
>>                 qca_power_shutdown(&qcadev->serdev_hu);
>>         else if (qcadev->susclk)
>> @@ -2335,6 +2364,7 @@ static const struct of_device_id qca_bluetooth_of_match[] = {
>>         { .compatible = "qcom,wcn3991-bt", .data = &qca_soc_data_wcn3991},
>>         { .compatible = "qcom,wcn3998-bt", .data = &qca_soc_data_wcn3998},
>>         { .compatible = "qcom,wcn6750-bt", .data = &qca_soc_data_wcn6750},
>> +       { .compatible = "qcom,wcn6855-bt", .data = &qca_soc_data_wcn6855},
>>         { /* sentinel */ }
>>  };
>>  MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
>> --
>> 2.39.0
>>
>
>
>-- 
>Luiz Augusto von Dentz

Thank you!
-- steev
