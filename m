Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5397697283
	for <lists+netdev@lfdr.de>; Wed, 15 Feb 2023 01:10:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBOAKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 19:10:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232067AbjBOAKA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 19:10:00 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57CED301A6;
        Tue, 14 Feb 2023 16:09:59 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id a9so20259028ljr.13;
        Tue, 14 Feb 2023 16:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QEKkwruQ7jJehw3g+rIQrjpIlByT/m3bwWLpiiOouVk=;
        b=p28FIZZBq5sK9WuODXt+DSVdnUi4kp2nyF4/5sBrfjiGRSfrK3VLvwJlqb6kpi6goZ
         qW7G6N0SZEPju3mzicM9fGnpmwVofK8DM/N6lHc97wo47VIhc+3dFUtuzTny7VXklaiR
         sacuyMrQpWVGBK83x9Q237ImM/M5Z96CzVxla8UlDf3mnfccGgdM+lK/VUYOq3xqH24/
         VZMlVLDugj9q87loyT8/vHzqLvla76NyR99e5dL5f2178nEPHkuTwzlTWMSqaMAm75lI
         Wm3gCgdP07Q9Hv5gpwpUNREeDw1iJX8/pZet8+4YRvOYwDaOU+JIMErvHQ9WzLCyinUH
         Z0uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QEKkwruQ7jJehw3g+rIQrjpIlByT/m3bwWLpiiOouVk=;
        b=0trloeN7Y5b1wbGEUwDXmEUtrj+qKZI4IONsQiS1OfO5k+2dhcWySqDSNTkXv5Bgfj
         EBOREtD2YrR36qZ+FAoJwYDytGI294GBYdNUWXHK658ni3NVGzxCl82PHbPwyw7eZhP5
         byOhIVzUjoYOhlbqp0gLAnYVc+EubS8hL5qlGRjsN7PonB2UJyHTtv2lgIcFIzUot1+e
         npCr0v4j/nOHsBeQLyjvOOPlyiHM7yAY4f5SCt6e7O5Mba3iroZJannYdZMLrr59WOi6
         nJduTSnjl8zRXLL9dV1sNY53ECa2WeWap2D+IFad5IxK3qmun01Iq/pSPOP0XeWHeAs6
         32YQ==
X-Gm-Message-State: AO0yUKVxXeJAcBov53yjRMTT95O4yKJjf4o+WmJX+EVd5FsiJ7/C1KeN
        EcEILTitRAxe2MP2A37WszZM911oL6LvKaVKrUM=
X-Google-Smtp-Source: AK7set9zLYyavZdxDHLOuwVAryxvhgX3pw8MoesyCSUWxffTXcGoaNJtWpq1tPR2Bxb8kogvzpl0flY6SH32a2Z9IBE=
X-Received: by 2002:a2e:b5d9:0:b0:293:4fd1:6105 with SMTP id
 g25-20020a2eb5d9000000b002934fd16105mr5738ljn.9.1676419797461; Tue, 14 Feb
 2023 16:09:57 -0800 (PST)
MIME-Version: 1.0
References: <20230214145609.kernel.v1.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
In-Reply-To: <20230214145609.kernel.v1.1.Ibe4d3a42683381c1e78b8c3aa67b53fc74437ae9@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Tue, 14 Feb 2023 16:09:45 -0800
Message-ID: <CABBYNZKVVo4T_pbEdozhNvgiykC7NiLQKEnJi3q5gZpHunGrbA@mail.gmail.com>
Subject: Re: [kernel PATCH v1] Bluetooth: hci_sync: Resume adv with no RPA
 when active scan
To:     Zhengping Jiang <jiangzp@google.com>
Cc:     linux-bluetooth@vger.kernel.org, marcel@holtmann.org,
        chromeos-bluetooth-upstreaming@chromium.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
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

Hi Zhengping,

On Tue, Feb 14, 2023 at 2:56 PM Zhengping Jiang <jiangzp@google.com> wrote:
>
> The address resolution should be disabled during the active scan,
> so all the advertisements can reach the host. The advertising
> has to be paused before disabling the address resolution,
> because the advertising will prevent any changes to the resolving
> list and the address resolution status. Skipping this will cause
> the hci error and the discovery failure.

It is probably a good idea to quote the spec saying:

7.8.44 LE Set Address Resolution Enable command

This command shall not be used when:
=E2=80=A2 Advertising (other than periodic advertising) is enabled,

> If the host is using RPA, the controller needs to generate RPA for
> the advertising, so the advertising must remain paused during the
> active scan.
>
> If the host is not using RPA, the advertising can be resumed after
> disabling the address resolution.
>
> Fixes: 9afc675edeeb ("Bluetooth: hci_sync: allow advertise when scan with=
out RPA")
> Signed-off-by: Zhengping Jiang <jiangzp@google.com>
> ---
>
> Changes in v1:
> - Always pause advertising when active scan, but resume the advertising i=
f the host is not using RPA
>
>  net/bluetooth/hci_sync.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index 117eedb6f709..edbf9faf7fa1 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -2402,7 +2402,7 @@ static u8 hci_update_accept_list_sync(struct hci_de=
v *hdev)
>         u8 filter_policy;
>         int err;
>
> -       /* Pause advertising if resolving list can be used as controllers=
 are
> +       /* Pause advertising if resolving list can be used as controllers
>          * cannot accept resolving list modifications while advertising.
>          */
>         if (use_ll_privacy(hdev)) {
> @@ -5397,7 +5397,7 @@ static int hci_active_scan_sync(struct hci_dev *hde=
v, uint16_t interval)
>         /* Pause advertising since active scanning disables address resol=
ution
>          * which advertising depend on in order to generate its RPAs.
>          */
> -       if (use_ll_privacy(hdev) && hci_dev_test_flag(hdev, HCI_PRIVACY))=
 {
> +       if (use_ll_privacy(hdev)) {
>                 err =3D hci_pause_advertising_sync(hdev);
>                 if (err) {
>                         bt_dev_err(hdev, "pause advertising failed: %d", =
err);
> @@ -5416,6 +5416,10 @@ static int hci_active_scan_sync(struct hci_dev *hd=
ev, uint16_t interval)
>                 goto failed;
>         }
>
> +       // Resume paused advertising if the host is not using RPA
> +       if (use_ll_privacy(hdev) && !hci_dev_test_flag(hdev, HCI_PRIVACY)=
)
> +               hci_resume_advertising_sync(hdev);
> +
>         /* All active scans will be done with either a resolvable private
>          * address (when privacy feature has been enabled) or non-resolva=
ble
>          * private address.
> --
> 2.39.1.581.gbfd45094c4-goog

I think it is better that we add something like
hci_pause_addr_resolution so we can make it check all the conditions,
such as pausing advertising and resuming if needed. Btw, we do seem to
have proper checks for these conditions on the emulator:

https://git.kernel.org/pub/scm/bluetooth/bluez.git/tree/emulator/btdev.c#n4=
090

But perhaps there is no test which attempts to enable LL Privacy
without enabling Local Privacy, so it would be great if you could
update mgmt-tester adding a test that emulates such behavior.

--=20
Luiz Augusto von Dentz
