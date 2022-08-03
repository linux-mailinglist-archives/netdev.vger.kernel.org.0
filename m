Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 800FC58940F
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 23:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiHCVcv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 17:32:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiHCVcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 17:32:50 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FAC1836D;
        Wed,  3 Aug 2022 14:32:49 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id gk3so21490076ejb.8;
        Wed, 03 Aug 2022 14:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SKMHQ9xTcP02SQJOeCEjFBlLpV7mwodyQLsJJfEU3e8=;
        b=DMTmrblDBJ75WmuolOCl7bRbz5o0Gz7VpjZgn2T1Yv6i2Le02NduMAsaCSenu7UqSO
         ByX5SFFNfaxpV4WmcjmXV/gPr7u7R3d6AVBubgZ/mI9esuI39RYypYu0abAKHXTUJ/mi
         mAurgSHPoNuWohfwqVkAgxJCVyMPQCNDEoTGPXXQF2MIm9Ls0tU2ZrdJMU10aEbI4ebK
         Q+9CWyhEy0DncU4DAeH88RHUK+f51oz+A9XOhf4Ms0W9Uq6a5IvEIC5g+NPRGhxdoE9g
         tlVcu+H0Ls38AURpRszCxnWhf9jEgQEcZNbRplIctXLwGlaS4RxYNH7yjPJotJZ5HxMB
         ExjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SKMHQ9xTcP02SQJOeCEjFBlLpV7mwodyQLsJJfEU3e8=;
        b=Ip/or50iUDBOxYHHPEVpGVXCkdJ+/lf0lok4wYxxdGw86y/xbRQS53tewm3/iE1GSw
         dk2U6P4cr8IzQkoewQPiu+X7dbylpaN5+FxBt24M/LfNoLUdnMD5Xjk9AZ8zKC1Qfgi4
         FGS2MniWDizrG6IPEMWyoIEyue+HnawDIJMDKTfvmYxMvRTGCpY7Cti0SOmYSOMmbeXn
         AU+BUlpL4bHI2g+P0JcD3v1D3QR5oW5uPG0e4riEZqUkJbeRLgtlA4LHWF7Q3QGDUmN1
         Mazp6hNi5PIQfi0HyfDUyv6SqONJr01ocRQZ8r84mWDVbi+ZnTKabd8V8TuTak3MucTc
         X86Q==
X-Gm-Message-State: AJIora8J9zSdxUUiBBew7b699t/yrNvRvwTuxXR6bru7oOFSwFWyLZex
        CxMphQ5Z30xpAHEeIwLbCJUiSSUIp6SbsUYRHFM=
X-Google-Smtp-Source: AGRyM1vJZX2bI3+QFu1yQnjtrogTdDNSSpY9IjUjG0WSFpMG9nYUIsOFuvWDbOApL/1rd1ZVKS0esVqTfh7k+bPejZk=
X-Received: by 2002:a17:907:2e0d:b0:72b:8cd4:ca52 with SMTP id
 ig13-20020a1709072e0d00b0072b8cd4ca52mr20781860ejc.541.1659562368119; Wed, 03
 Aug 2022 14:32:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220803132319.1.I5acde3b5af78dbd2ea078d5eb4158d23b496ac87@changeid>
 <20220803132319.2.I27d3502a0851c75c0c31fb7fea9b09644d54d81d@changeid>
In-Reply-To: <20220803132319.2.I27d3502a0851c75c0c31fb7fea9b09644d54d81d@changeid>
From:   Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Date:   Wed, 3 Aug 2022 14:32:36 -0700
Message-ID: <CABBYNZKdmy_vfJk_jL=Z0u31FcPAks84qNii7P28pOC2DGD_3A@mail.gmail.com>
Subject: Re: [PATCH 2/2] Bluetooth: hci_sync: Cancel AdvMonitor interleave
 scan when suspend
To:     Manish Mandlik <mmandlik@google.com>,
        "Gix, Brian" <brian.gix@intel.com>
Cc:     Marcel Holtmann <marcel@holtmann.org>,
        ChromeOS Bluetooth Upstreaming 
        <chromeos-bluetooth-upstreaming@chromium.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        Miao-chen Chou <mcchou@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>
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

Hi Manish,

On Wed, Aug 3, 2022 at 1:24 PM Manish Mandlik <mmandlik@google.com> wrote:
>
> Cancel interleaved scanning for advertisement monitor when suspend.
>
> Fixes: 182ee45da083 ("Bluetooth: hci_sync: Rework hci_suspend_notifier")
>
> Signed-off-by: Manish Mandlik <mmandlik@google.com>
> Reviewed-by: Miao-chen Chou <mcchou@google.com>
> ---
>
>  net/bluetooth/hci_sync.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/net/bluetooth/hci_sync.c b/net/bluetooth/hci_sync.c
> index cb0c219ebe1c..33d2221b2bc4 100644
> --- a/net/bluetooth/hci_sync.c
> +++ b/net/bluetooth/hci_sync.c
> @@ -1721,6 +1721,9 @@ static bool is_interleave_scanning(struct hci_dev *hdev)
>
>  static void cancel_interleave_scan(struct hci_dev *hdev)
>  {
> +       if (!is_interleave_scanning(hdev))
> +               return;
> +
>         bt_dev_dbg(hdev, "cancelling interleave scan");
>
>         cancel_delayed_work_sync(&hdev->interleave_scan);
> @@ -5288,6 +5291,9 @@ int hci_suspend_sync(struct hci_dev *hdev)
>         /* Pause other advertisements */
>         hci_pause_advertising_sync(hdev);
>
> +       /* Cancel interleaved scan */
> +       cancel_interleave_scan(hdev);
> +
>         /* Suspend monitor filters */
>         hci_suspend_monitor_sync(hdev);
>
> --
> 2.37.1.455.g008518b4e5-goog

This will likely conflict with the following changes:

https://patchwork.kernel.org/project/bluetooth/patch/20220801171505.1271059-6-brian.gix@intel.com/

Also I think this code shall be part of hci_scan_disable_sync so
scanning_paused apply to all scanning including interleave_scanning
and we most likely need a mgmt-tester that exercise this since
apparently that is not being tested, @Gix, Brian can you take a look
at adding a tests for it?

-- 
Luiz Augusto von Dentz
