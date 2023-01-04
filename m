Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86B0765D75D
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 16:41:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239540AbjADPlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 10:41:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239500AbjADPlG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 10:41:06 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95447FFF;
        Wed,  4 Jan 2023 07:41:04 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id m21so49000622edc.3;
        Wed, 04 Jan 2023 07:41:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=eEskvgBf/rIaiXvPWmodi9mgQl9xhX7PHLLGIqbDhHY=;
        b=XWrhBK29nNMXRHIPEFUtEE1LdNiUpExU+GmJ7HzkrnJem0TWV+0K6Zn3iKIqwHo5bn
         jps0ri0ynZIp14qHPoSbhbsBm3/yTlZ1H8xmitnjqMOKdYquJdViyp/R/C9RAGwvIuuu
         YM+nMqq1ZOV+CQpFP4jQN5mtIr62eT4LrY+B2w+mUC7GJXbYrn4iz1/sy3SGORLNkizD
         kyJf2oo5lhEjWMekNOtrh8gxs2DCYegZLE/7XbQt4CpajvuWrWn0tVNod627hZRfW0/p
         Q0JDpT9piCbeDiIBsedzuxTrb5k3pfo5RL597j5nsw7nnh+wWaJkCJAHxOlkphEYYEnm
         OClw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eEskvgBf/rIaiXvPWmodi9mgQl9xhX7PHLLGIqbDhHY=;
        b=fy1xnoiCV5JtgWoQ4R1JD3diHMqOq/fp0wrMZi0pl4eroWxnSffmfqjXjuMWUd5AqZ
         2Mn09N+XMD7F7PZQOHJiRt/78nYY14EwoS2UUiK7K0nx0JqDB9G1LDpL9nmuoX51J6zd
         065+VF5WxUftmbZg5rMqApv2wkvt/yHgFYjtXzIrL0z/lOxo6Xrn/vUgjVKlhS8xLRav
         JcspI7HNIDyDuVCXvbQ8JC9vs2bkF3ikKsLohPGkoBFFjADb1n4wuYlhBRaQVDAg8CoA
         zyAgvTus996pqZQNAAE73X2jUG7iONiIna5DhxmiLQHi2O0OYsbiusbHsIoWqWHTSVep
         T4Qg==
X-Gm-Message-State: AFqh2krO/uGSGlZcqKjjh5eQ0YIftZHjSo5LeAgU+wIGfz7ijx99bb7u
        oLA904zZZz8sVH3kkTfxKna0UKR0Lm44heudx9o=
X-Google-Smtp-Source: AMrXdXvkYCzFVRif6nEi7mpIIaz+nt5cEg2zMnTtan+deHoFEsjrW1VcMfCJHWwSeP5ArsTmQu4LkxYI3ijB6/sysSA=
X-Received: by 2002:aa7:c0cd:0:b0:461:b033:90ac with SMTP id
 j13-20020aa7c0cd000000b00461b03390acmr5588804edp.257.1672846862917; Wed, 04
 Jan 2023 07:41:02 -0800 (PST)
MIME-Version: 1.0
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com> <63b4b3e1.050a0220.791fb.767c@mx.google.com>
In-Reply-To: <63b4b3e1.050a0220.791fb.767c@mx.google.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 4 Jan 2023 16:40:51 +0100
Message-ID: <CAFBinCDpMjHPZ4CA-YdyAu=k1F_7DxxYEMSjnBEX2aMWfSCCeA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 19/19] rtw88: Add support for the SDIO based
 RTL8821CS chipset
To:     Chris Morgan <macroalpha82@gmail.com>
Cc:     linux-wireless@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-mmc@vger.kernel.org, Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>, Pkshih <pkshih@realtek.com>,
        Jernej Skrabec <jernej.skrabec@gmail.com>
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

Hi Chris,

On Wed, Jan 4, 2023 at 12:01 AM Chris Morgan <macroalpha82@gmail.com> wrote:
>
> On Wed, Dec 28, 2022 at 12:30:20AM +0100, Martin Blumenstingl wrote:
> > Wire up RTL8821CS chipset support using the new rtw88 SDIO HCI code as
> > well as the existing RTL8821C chipset code.
> >
>
> Unfortunately, this doesn't work for me. I applied it on top of 6.2-rc2
> master and I get errors during probe (it appears the firmware never
> loads).
That's unfortunate.

> Relevant dmesg logs are as follows:
>
> [    0.989545] mmc2: new high speed SDIO card at address 0001
> [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
> [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
> [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
> [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
> [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
> [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
> [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
> [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
The error starts with a write to register 0x14 (REG_SDIO_HIMR), which
happens right after configuring RX aggregation.
Can you please try two modifications inside
drivers/net/wireless/realtek/rtw88/sdio.c:
1. inside the rtw_sdio_start() function: change
"rtw_sdio_rx_aggregation(rtwdev, false);" to
"rtw_sdio_rx_aggregation(rtwdev, true);"
2. if 1) does not work: remove the call to rtw_sdio_rx_aggregation()
from rtw_sdio_start()


Best regards,
Martin
