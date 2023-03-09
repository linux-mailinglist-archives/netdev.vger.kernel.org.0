Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B84E6B2EA7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 21:25:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230445AbjCIUZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 15:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbjCIUZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 15:25:12 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2701AF8651
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 12:25:10 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id ay14so11863361edb.11
        for <netdev@vger.kernel.org>; Thu, 09 Mar 2023 12:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kali.org; s=google; t=1678393508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G+BklEzWVltOR1hJvkNkXfkrfxPiDjF0+O+EA7XHv/4=;
        b=TpjTcTG89eVAWMsGE1cmuq97VbZqB66knbilw8sax5Cv+BzMBUv7Y0z3XYJnKUd2gA
         73u8YU3OJxPBN9UgE3Edk/K1fBICUyIFRwv7xHy2JqtLRVV9gusQKnMCREzxVQHUisYb
         RskiwQG/+LF3/fI4AaS4agkY6XcBoEQwr+Xn4iETmLTex/JWpeyvnJeIBfItukuillRz
         pk+hyW7BHiz3tVQ1uxfXDiDj/8Rp4Ao+ThtHiV6OAhYyO041NZeENtqyHJBz9Ndi/0Wg
         bO8Ks0u9ZBMr+DayjzQf/p3MdEBwM3kVWqWybjHi3rlz6zKqhegW98CDBfPJmHp/MCAg
         Cazw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678393508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G+BklEzWVltOR1hJvkNkXfkrfxPiDjF0+O+EA7XHv/4=;
        b=HashNut85Llbbw43YXg0sUXjLzRluNIqepoGMeGVHLUZeqvXRzl/aFebNAjNpBMIDJ
         ifZ9mGf7wvgw87mN1V6tw94y9FFxuIDHhcKvVPEyZIXwwes2kP9iZmSXRy2PBwtMNyzu
         8/qABL8Hht6BqrJhwQvJ4F19L1UvH234KB8f+63V+a/vBKISuON+ixXrcWxGsCqcBxxh
         5i64DC3aeuz1f24A7VK1KpX7aWwZNqHydPnNxqcIgZstK6tIY47mWio8cE5jrhibKHAE
         EBhE+zhCuc9JyDnucrPQDKseuBZk8Sy641WT5LtkUzo8M7P9xoJLrYKmSnYwOM11PiPS
         Ua1g==
X-Gm-Message-State: AO0yUKXVL7b9I3tO2xRpBJCBwCDoG1nIuFanArrY7mFNL5qTSXLzCY3G
        2W7AL9U1iIkra9Pum3eJO83Icjtx16PC7+E5J0UvYQ==
X-Google-Smtp-Source: AK7set9EN3dy7vGdMfeh3rglPNG/kYWEw6r8ijSWoyhGmr7zPcrla0Uj/AALoQlb/9C1PliGkSkkSJWouA4rgr00T24=
X-Received: by 2002:a17:906:4997:b0:8ee:babc:d3f8 with SMTP id
 p23-20020a170906499700b008eebabcd3f8mr11823640eju.3.1678393508590; Thu, 09
 Mar 2023 12:25:08 -0800 (PST)
MIME-Version: 1.0
References: <20230209020916.6475-1-steev@kali.org> <20230209020916.6475-3-steev@kali.org>
 <ZAoS1T9m1lI21Cvn@hovoldconsulting.com>
In-Reply-To: <ZAoS1T9m1lI21Cvn@hovoldconsulting.com>
From:   Steev Klimaszewski <steev@kali.org>
Date:   Thu, 9 Mar 2023 14:24:57 -0600
Message-ID: <CAKXuJqhEKB7cuVhEzObbFyYHyKj87M8iWVaoz7gkhS2OQ9tTBA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] Bluetooth: hci_qca: Add support for QTI Bluetooth
 chip wcn6855
To:     Johan Hovold <johan@kernel.org>
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
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Tim Jiang <quic_tjiang@quicinc.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 9, 2023 at 11:08=E2=80=AFAM Johan Hovold <johan@kernel.org> wro=
te:
>
> On Wed, Feb 08, 2023 at 08:09:14PM -0600, Steev Klimaszewski wrote:
> > Added regulators,GPIOs and changes required to power on/off wcn6855.
> > Added support for firmware download for wcn6855.
> >
> > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> > ---
> > Changes since v4:
> >  * Remove unused firmware check because we don't have mbn firmware.
> >  * Set qcadev->init_speed if it hasn't been set.
> >
> > Changes since v3:
> >  * drop unused regulators
> >
> > Changes since v2:
> >  * drop unnecessary commit info
> >
> > Changes since v1:
> >  * None
> >
> >  drivers/bluetooth/btqca.c   |  9 ++++++-
> >  drivers/bluetooth/btqca.h   | 10 ++++++++
> >  drivers/bluetooth/hci_qca.c | 50 ++++++++++++++++++++++++++++---------
> >  3 files changed, 56 insertions(+), 13 deletions(-)
> >
> > diff --git a/drivers/bluetooth/btqca.c b/drivers/bluetooth/btqca.c
> > index c9064d34d830..2f9d8bd27c38 100644
> > --- a/drivers/bluetooth/btqca.c
> > +++ b/drivers/bluetooth/btqca.c
> > @@ -614,6 +614,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t ba=
udrate,
> >               config.type =3D ELF_TYPE_PATCH;
> >               snprintf(config.fwname, sizeof(config.fwname),
> >                        "qca/msbtfw%02x.mbn", rom_ver);
> > +     } else if (soc_type =3D=3D QCA_WCN6855) {
> > +             snprintf(config.fwname, sizeof(config.fwname),
> > +                      "qca/hpbtfw%02x.tlv", rom_ver);
> >       } else {
> >               snprintf(config.fwname, sizeof(config.fwname),
> >                        "qca/rampatch_%08x.bin", soc_ver);
> > @@ -648,6 +651,9 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t ba=
udrate,
> >       else if (soc_type =3D=3D QCA_WCN6750)
> >               snprintf(config.fwname, sizeof(config.fwname),
> >                        "qca/msnv%02x.bin", rom_ver);
> > +     else if (soc_type =3D=3D QCA_WCN6855)
> > +             snprintf(config.fwname, sizeof(config.fwname),
> > +                      "qca/hpnv%02x.bin", rom_ver);
> >       else
> >               snprintf(config.fwname, sizeof(config.fwname),
> >                        "qca/nvm_%08x.bin", soc_ver);
> > @@ -672,6 +678,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t ba=
udrate,
> >       case QCA_WCN3991:
> >       case QCA_WCN3998:
> >       case QCA_WCN6750:
> > +     case QCA_WCN6855:
>
> Did you actually verify the microsoft extensions need this, or you are
> assuming it works as 6750?
>
It was 100% an assumption that since the 6750 does it, the 6855 does
too.  I should know better than to assume since I used to work at a
device manufacturer but high hopes things have changed a bit in the
past 12 years ;)

> >               hci_set_msft_opcode(hdev, 0xFD70);
> >               break;
> >       default:
> > @@ -685,7 +692,7 @@ int qca_uart_setup(struct hci_dev *hdev, uint8_t ba=
udrate,
> >               return err;
> >       }
> >
> > -     if (soc_type =3D=3D QCA_WCN3991 || soc_type =3D=3D QCA_WCN6750) {
> > +     if (soc_type =3D=3D QCA_WCN3991 || soc_type =3D=3D QCA_WCN6750 ||=
 soc_type =3D=3D QCA_WCN6855) {
>
> Line is now over 80 columns which is still the preferred limit.
>
> Perhaps this should now be a switch statement instead?
>
switch statement might work, I'll give it a shot here.

> >               /* get fw build info */
> >               err =3D qca_read_fw_build_info(hdev);
> >               if (err < 0)
> > diff --git a/drivers/bluetooth/btqca.h b/drivers/bluetooth/btqca.h
> > index 61e9a50e66ae..b884095bcd9d 100644
> > --- a/drivers/bluetooth/btqca.h
> > +++ b/drivers/bluetooth/btqca.h
> > @@ -147,6 +147,7 @@ enum qca_btsoc_type {
> >       QCA_WCN3991,
> >       QCA_QCA6390,
> >       QCA_WCN6750,
> > +     QCA_WCN6855,
> >  };
> >
> >  #if IS_ENABLED(CONFIG_BT_QCA)
> > @@ -168,6 +169,10 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_t=
ype soc_type)
> >  {
> >       return soc_type =3D=3D QCA_WCN6750;
> >  }
> > +static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
> > +{
> > +     return soc_type =3D=3D QCA_WCN6855;
> > +}
> >
> >  #else
> >
> > @@ -206,6 +211,11 @@ static inline bool qca_is_wcn6750(enum qca_btsoc_t=
ype soc_type)
> >       return false;
> >  }
> >
> > +static inline bool qca_is_wcn6855(enum qca_btsoc_type soc_type)
> > +{
> > +     return false;
> > +}
> > +
> >  static inline int qca_send_pre_shutdown_cmd(struct hci_dev *hdev)
> >  {
> >       return -EOPNOTSUPP;
> > diff --git a/drivers/bluetooth/hci_qca.c b/drivers/bluetooth/hci_qca.c
> > index 3df8c3606e93..efc1c0306b4e 100644
> > --- a/drivers/bluetooth/hci_qca.c
> > +++ b/drivers/bluetooth/hci_qca.c
> > @@ -605,8 +605,7 @@ static int qca_open(struct hci_uart *hu)
> >       if (hu->serdev) {
> >               qcadev =3D serdev_device_get_drvdata(hu->serdev);
> >
> > -             if (qca_is_wcn399x(qcadev->btsoc_type) ||
> > -                 qca_is_wcn6750(qcadev->btsoc_type))
> > +             if (!(qcadev->init_speed))
> >                       hu->init_speed =3D qcadev->init_speed;
>
> This change makes no sense.
>
> In fact, it seems the driver never sets init_speed anywhere.
>
> Either way, it should not be needed for wcn6855.
>

So, that was a request from an earlier review, but if it's not needed
for 6855, I'll just drop it, and then I don't need to do any of those
changes :D

> >
> >               if (qcadev->oper_speed)
> > @@ -1317,7 +1316,8 @@ static int qca_set_baudrate(struct hci_dev *hdev,=
 uint8_t baudrate)
> >
> >       /* Give the controller time to process the request */
> >       if (qca_is_wcn399x(qca_soc_type(hu)) ||
> > -         qca_is_wcn6750(qca_soc_type(hu)))
> > +         qca_is_wcn6750(qca_soc_type(hu)) ||
> > +         qca_is_wcn6855(qca_soc_type(hu)))
> >               usleep_range(1000, 10000);
> >       else
> >               msleep(300);
> > @@ -1394,7 +1394,8 @@ static unsigned int qca_get_speed(struct hci_uart=
 *hu,
> >  static int qca_check_speeds(struct hci_uart *hu)
> >  {
> >       if (qca_is_wcn399x(qca_soc_type(hu)) ||
> > -         qca_is_wcn6750(qca_soc_type(hu))) {
> > +         qca_is_wcn6750(qca_soc_type(hu)) ||
> > +         qca_is_wcn6855(qca_soc_type(hu))) {
> >               if (!qca_get_speed(hu, QCA_INIT_SPEED) &&
> >                   !qca_get_speed(hu, QCA_OPER_SPEED))
> >                       return -EINVAL;
> > @@ -1682,7 +1683,8 @@ static int qca_power_on(struct hci_dev *hdev)
> >               return 0;
> >
> >       if (qca_is_wcn399x(soc_type) ||
> > -         qca_is_wcn6750(soc_type)) {
> > +         qca_is_wcn6750(soc_type) ||
> > +         qca_is_wcn6855(soc_type)) {
> >               ret =3D qca_regulator_init(hu);
> >       } else {
> >               qcadev =3D serdev_device_get_drvdata(hu->serdev);
> > @@ -1723,7 +1725,8 @@ static int qca_setup(struct hci_uart *hu)
> >
> >       bt_dev_info(hdev, "setting up %s",
> >               qca_is_wcn399x(soc_type) ? "wcn399x" :
> > -             (soc_type =3D=3D QCA_WCN6750) ? "wcn6750" : "ROME/QCA6390=
");
> > +             (soc_type =3D=3D QCA_WCN6750) ? "wcn6750" :
> > +             (soc_type =3D=3D QCA_WCN6855) ? "wcn6855" : "ROME/QCA6390=
");
>
> This is hideous, but not your fault...
>
It is, and, I'm not entirely sure we need it? I mean, it's nice to
show that it's now starting to set up, but it isn't particularly
helpful for end users or making sure things are working?

> >
> >       qca->memdump_state =3D QCA_MEMDUMP_IDLE;
> >
> > @@ -1735,7 +1738,8 @@ static int qca_setup(struct hci_uart *hu)
> >       clear_bit(QCA_SSR_TRIGGERED, &qca->flags);
> >
> >       if (qca_is_wcn399x(soc_type) ||
> > -         qca_is_wcn6750(soc_type)) {
> > +         qca_is_wcn6750(soc_type) ||
> > +         qca_is_wcn6855(soc_type)) {
> >               set_bit(HCI_QUIRK_USE_BDADDR_PROPERTY, &hdev->quirks);
> >               hci_set_aosp_capable(hdev);
> >
> > @@ -1757,7 +1761,8 @@ static int qca_setup(struct hci_uart *hu)
> >       }
> >
> >       if (!(qca_is_wcn399x(soc_type) ||
> > -          qca_is_wcn6750(soc_type))) {
> > +          qca_is_wcn6750(soc_type) ||
> > +          qca_is_wcn6855(soc_type))) {
>
> Perhaps you can add a leading space while changing this so that the
> open-parenthesis alignment makes sense.
>
> >               /* Get QCA version information */
> >               ret =3D qca_read_soc_version(hdev, &ver, soc_type);
> >               if (ret)
> > @@ -1883,6 +1888,20 @@ static const struct qca_device_data qca_soc_data=
_wcn6750 =3D {
> >       .capabilities =3D QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STAT=
ES,
> >  };
> >
> > +static const struct qca_device_data qca_soc_data_wcn6855 =3D {
> > +     .soc_type =3D QCA_WCN6855,
> > +     .vregs =3D (struct qca_vreg []) {
> > +             { "vddio", 5000 },
> > +             { "vddbtcxmx", 126000 },
> > +             { "vddrfacmn", 12500 },
> > +             { "vddrfa0p8", 102000 },
> > +             { "vddrfa1p7", 302000 },
> > +             { "vddrfa1p2", 257000 },
>
> Hmm. More random regulator load values. I really think we should get rid
> of this but that's a separate discussion.
>
Bjorn specifically requested that he wanted me to leave them in.  I'm
not married to them, and don't care one way or the other, I just
wanted working bluetooth since audio wasn't quite ready yet :)

> > +     },
> > +     .num_vregs =3D 6,
> > +     .capabilities =3D QCA_CAP_WIDEBAND_SPEECH | QCA_CAP_VALID_LE_STAT=
ES,
> > +};
> > +
> >  static void qca_power_shutdown(struct hci_uart *hu)
> >  {
> >       struct qca_serdev *qcadev;
>
> As I mentioned elsewhere, you need to update also this function so that
> wcn6855 can be powered down.

Sorry, I do have that locally, I just haven't pushed a v6 as I was
looking at Tim's v2 of the qca2066 and was wondering if I should or
shouldn't continue working on my version of the driver?

>
> > @@ -2047,7 +2066,8 @@ static int qca_serdev_probe(struct serdev_device =
*serdev)
> >
> >       if (data &&
> >           (qca_is_wcn399x(data->soc_type) ||
> > -         qca_is_wcn6750(data->soc_type))) {
> > +         qca_is_wcn6750(data->soc_type) ||
> > +         qca_is_wcn6855(data->soc_type))) {
>
> Perhaps you fix the alignment here too.
>
> >               qcadev->btsoc_type =3D data->soc_type;
> >               qcadev->bt_power =3D devm_kzalloc(&serdev->dev,
> >                                               sizeof(struct qca_power),
> > @@ -2067,14 +2087,18 @@ static int qca_serdev_probe(struct serdev_devic=
e *serdev)
> >
> >               qcadev->bt_en =3D devm_gpiod_get_optional(&serdev->dev, "=
enable",
> >                                              GPIOD_OUT_LOW);
> > -             if (IS_ERR_OR_NULL(qcadev->bt_en) && data->soc_type =3D=
=3D QCA_WCN6750) {
> > +             if (IS_ERR_OR_NULL(qcadev->bt_en)
> > +                 && (data->soc_type =3D=3D QCA_WCN6750 ||
>
> && operator should go on the previous line before the line break.
>
> > +                     data->soc_type =3D=3D QCA_WCN6855)) {
> >                       dev_err(&serdev->dev, "failed to acquire BT_EN gp=
io\n");
> >                       power_ctrl_enabled =3D false;
> >               }
> >
> >               qcadev->sw_ctrl =3D devm_gpiod_get_optional(&serdev->dev,=
 "swctrl",
> >                                              GPIOD_IN);
> > -             if (IS_ERR_OR_NULL(qcadev->sw_ctrl) && data->soc_type =3D=
=3D QCA_WCN6750)
> > +             if (IS_ERR_OR_NULL(qcadev->sw_ctrl)
> > +                 && (data->soc_type =3D=3D QCA_WCN6750 ||
>
> Same here.
>
> > +                     data->soc_type =3D=3D QCA_WCN6855))
> >                       dev_warn(&serdev->dev, "failed to acquire SW_CTRL=
 gpio\n");
> >
> >               qcadev->susclk =3D devm_clk_get_optional(&serdev->dev, NU=
LL);
> > @@ -2150,7 +2174,8 @@ static void qca_serdev_remove(struct serdev_devic=
e *serdev)
> >       struct qca_power *power =3D qcadev->bt_power;
> >
> >       if ((qca_is_wcn399x(qcadev->btsoc_type) ||
> > -          qca_is_wcn6750(qcadev->btsoc_type)) &&
> > +          qca_is_wcn6750(qcadev->btsoc_type) ||
> > +          qca_is_wcn6855(qcadev->btsoc_type)) &&
> >            power->vregs_on)
> >               qca_power_shutdown(&qcadev->serdev_hu);
> >       else if (qcadev->susclk)
> > @@ -2335,6 +2360,7 @@ static const struct of_device_id qca_bluetooth_of=
_match[] =3D {
> >       { .compatible =3D "qcom,wcn3991-bt", .data =3D &qca_soc_data_wcn3=
991},
> >       { .compatible =3D "qcom,wcn3998-bt", .data =3D &qca_soc_data_wcn3=
998},
> >       { .compatible =3D "qcom,wcn6750-bt", .data =3D &qca_soc_data_wcn6=
750},
> > +     { .compatible =3D "qcom,wcn6855-bt", .data =3D &qca_soc_data_wcn6=
855},
> >       { /* sentinel */ }
> >  };
> >  MODULE_DEVICE_TABLE(of, qca_bluetooth_of_match);
>
> With power-off handling fixed, this seems to work as quite well on my
> X13s with 6.3-rc1. Nice job!
>
> Btw, apart from the frame reassembly error, I'm also seeing:
>
>         Bluetooth: Received HCI_IBS_WAKE_ACK in tx state 0
>
> during probe.
>
I'm still not sure where the frame reassembly error comes from, and I
don't know how to get more info to figure it out either, if anyone
happens to have any guidance for that, I would love some.
Additionally, it doesn't always happen.  It seems to happen on the
first load of the module, however, running modprobe -r && modprobe in
a loop (with the powerdown properly modified so the log isn't full of
splats),  it doesn't seem to occur every time. Likewise for the
WAKE_ACK.

> Johan
