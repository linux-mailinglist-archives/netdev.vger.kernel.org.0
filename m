Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 725816234E5
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 21:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbiKIUti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 15:49:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231666AbiKIUtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 15:49:35 -0500
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0D62CCA1;
        Wed,  9 Nov 2022 12:49:34 -0800 (PST)
Received: by mail-lf1-x135.google.com with SMTP id r12so27861670lfp.1;
        Wed, 09 Nov 2022 12:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HMexBlxBxOfaLRccW2JVyrflm9G7r7sk5hRAu9Qd8Xw=;
        b=lNabaBwBDx8wdVGBNgTi9QC7ZUqI1PcJvBPYkx5jrHBUeWhiNinibODdCdAobmUQsp
         xX/EDJFbuhFE0m9R3ZyxxJXaocdRM7BwV3OHrhEH4ZSJqWDNDOEU8kAbOzh/Qw7grLtQ
         2VDPcwgFBJlvk/MF2Lnt+TlB52oW2yPF+Vp1shEB5BicSyRVPfzlC4gUEX28a9jJuS+Y
         d+T7DDTc2OqSBIJGkr5q0G8dv1mquMEhGbGaEc2Nh8qp8YP5Uy4OV4SOR5jlHVbQa9K6
         DAoNKZkghLTa/oh6kaqdgzRmhd5vhM3Rdc49nb3dyQ/j38+8IIdKnkLLrf6EU0jumPbf
         kxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HMexBlxBxOfaLRccW2JVyrflm9G7r7sk5hRAu9Qd8Xw=;
        b=hmXfG7zO5G3AE1a/88yUfPlcFgRq+ZLpYReqFMqK+apTHNqV6qd9lwK1A0SzgJ99Rr
         18138jciOMSDPi3MhAtX1xd7hC9pt20/eK8GtspM4Bt5NRGgUBnO2N5dZjC3gM/uodOi
         2EZP+NF4DYMaSvC0ExRtbtXekGeDdg8EbpOV7VhrCsJ7kHOWVuSRAAUuPNsT2T6gnoRB
         aM9XvrdZKgLrZTYMSEi2sUo11ZyGKCUp60ovgR35e8BPUcMfQ02guqa/dXp5uIW45zfU
         6YJa/WwxnxVaJsuToDQKebllhlNN0w3U5U7s81ydlL4g39dEug+II/EXT2an/7z9bljj
         tT4g==
X-Gm-Message-State: ACrzQf2u3sovvnXh9m0ioSg6EKeNVaqBlIfXpKCfSzhGpov7SB0dqUG4
        aiJjWakEh7dHhng7lgqdml3HVS9WU1EDlSlG04A=
X-Google-Smtp-Source: AMsMyM47rnxNdnhq2uJF1dI0lUZOzuLnsLb7XNFBM3pLXMpIHNfi4zaMlJ30IDlwjmXIXU+3bvfZZXI248olgA0My5A=
X-Received: by 2002:a19:6554:0:b0:4a2:be5c:688f with SMTP id
 c20-20020a196554000000b004a2be5c688fmr775793lfj.121.1668026972441; Wed, 09
 Nov 2022 12:49:32 -0800 (PST)
MIME-Version: 1.0
References: <20221029202454.25651-1-swyterzone@gmail.com> <20221029202454.25651-3-swyterzone@gmail.com>
In-Reply-To: <20221029202454.25651-3-swyterzone@gmail.com>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 9 Nov 2022 12:49:20 -0800
Message-ID: <CABBYNZKnw+b+KE2=M=gGV+rR_KBJLvrxRrtEc8x12W6PY=LKMw@mail.gmail.com>
Subject: Re: [PATCH 3/3] Bluetooth: btusb: Add a parameter to let users
 disable the fake CSR force-suspend hack
To:     Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, luiz.von.dentz@intel.com,
        quic_zijuhu@quicinc.com, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Ismael,

On Sat, Oct 29, 2022 at 1:25 PM Ismael Ferreras Morezuelas
<swyterzone@gmail.com> wrote:
>
> A few users have reported that their cloned Chinese dongle doesn't
> work well with the hack Hans de Goede added, that tries this
> off-on mechanism as a way to unfreeze them.
>
> It's still more than worthwhile to have it, as in the vast majority
> of cases it either completely brings dongles to life or just resets
> them harmlessly as it already happens during normal USB operation.
>
> This is nothing new and the controllers are expected to behave
> correctly. But yeah, go figure. :)
>
> For that unhappy minority we can easily handle this edge case by letting
> users disable it via our =C2=ABbtusb.disable_fake_csr_forcesuspend_hack=
=3D1=C2=BB kernel option.

Don't really like the idea of adding module parameter for device
specific problem.

> I believe this is the most generic way of doing it, given the constraints
> and by still having a good out-of-the-box experience.
>
> No clone left behind.
>
> Cc: stable@vger.kernel.org
> Cc: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
> ---
>  drivers/bluetooth/btusb.c | 31 +++++++++++++++++++------------
>  1 file changed, 19 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/bluetooth/btusb.c b/drivers/bluetooth/btusb.c
> index 8f34bf195bae..d31d4f925463 100644
> --- a/drivers/bluetooth/btusb.c
> +++ b/drivers/bluetooth/btusb.c
> @@ -34,6 +34,7 @@ static bool force_scofix;
>  static bool enable_autosuspend =3D IS_ENABLED(CONFIG_BT_HCIBTUSB_AUTOSUS=
PEND);
>  static bool enable_poll_sync =3D IS_ENABLED(CONFIG_BT_HCIBTUSB_POLL_SYNC=
);
>  static bool reset =3D true;
> +static bool disable_fake_csr_forcesuspend_hack;
>
>  static struct usb_driver btusb_driver;
>
> @@ -2171,7 +2172,7 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>                 is_fake =3D true;
>
>         if (is_fake) {
> -               bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; add=
ing workarounds and force-suspending once...");
> +               bt_dev_warn(hdev, "CSR: Unbranded CSR clone detected; add=
ing workarounds...");
>
>                 /* Generally these clones have big discrepancies between
>                  * advertised features and what's actually supported.
> @@ -2215,21 +2216,24 @@ static int btusb_setup_csr(struct hci_dev *hdev)
>                  * apply this initialization quirk to every controller th=
at gets here,
>                  * it should be harmless. The alternative is to not work =
at all.
>                  */
> -               pm_runtime_allow(&data->udev->dev);
> +               if (!disable_fake_csr_forcesuspend_hack) {
> +                       bt_dev_warn(hdev, "CSR: Unbranded CSR clone detec=
ted; force-suspending once...");
> +                       pm_runtime_allow(&data->udev->dev);
>
> -               ret =3D pm_runtime_suspend(&data->udev->dev);
> -               if (ret >=3D 0)
> -                       msleep(200);
> -               else
> -                       bt_dev_warn(hdev, "CSR: Couldn't suspend the devi=
ce for our Barrot 8041a02 receive-issue workaround");
> +                       ret =3D pm_runtime_suspend(&data->udev->dev);
> +                       if (ret >=3D 0)
> +                               msleep(200);
> +                       else
> +                               bt_dev_warn(hdev, "CSR: Couldn't suspend =
the device for our Barrot 8041a02 receive-issue workaround");

Is this specific to Barrot 8041a02? Why don't we add a quirk then?

> -               pm_runtime_forbid(&data->udev->dev);
> +                       pm_runtime_forbid(&data->udev->dev);
>
> -               device_set_wakeup_capable(&data->udev->dev, false);
> +                       device_set_wakeup_capable(&data->udev->dev, false=
);
>
> -               /* Re-enable autosuspend if this was requested */
> -               if (enable_autosuspend)
> -                       usb_enable_autosuspend(data->udev);
> +                       /* Re-enable autosuspend if this was requested */
> +                       if (enable_autosuspend)
> +                               usb_enable_autosuspend(data->udev);
> +               }
>         }
>
>         kfree_skb(skb);
> @@ -4312,6 +4316,9 @@ MODULE_PARM_DESC(enable_autosuspend, "Enable USB au=
tosuspend by default");
>  module_param(reset, bool, 0644);
>  MODULE_PARM_DESC(reset, "Send HCI reset command on initialization");
>
> +module_param(disable_fake_csr_forcesuspend_hack, bool, 0644);
> +MODULE_PARM_DESC(disable_fake_csr_forcesuspend_hack, "Don't indiscrimina=
tely force-suspend Chinese-cloned CSR dongles trying to unfreeze them");
> +
>  MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
>  MODULE_DESCRIPTION("Generic Bluetooth USB driver ver " VERSION);
>  MODULE_VERSION(VERSION);
> --
> 2.38.1
>


--=20
Luiz Augusto von Dentz
