Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8EBE65DB35
	for <lists+netdev@lfdr.de>; Wed,  4 Jan 2023 18:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239301AbjADRXl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 12:23:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231133AbjADRXk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 12:23:40 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 279D6B80;
        Wed,  4 Jan 2023 09:23:37 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z11so33696886ede.1;
        Wed, 04 Jan 2023 09:23:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L2XzINSDFSEvVIKVI2wVpJiYMuWabWAuVVe8v1OkWsI=;
        b=i1QDjhVcONX9bh/l0A9oznGBt1NkCpxbTD+HfoL4G/IRZr9iTieCbZUPXTeOqXnNz/
         5tQUW2A3KcmQD4XpqEo12oc+6ley5UIwHRLU9QQBGvN7ErwenWPuynwh+bcR4KuB+9j/
         obEeYNpKvX7HgoLb7dmUOKnQSmyXb947pW89RoCqdwVHd/LvhjjyOFv+w863CWaLHlsw
         E3qY8y1MLsg0/BeoPsa7fZyMopi4agQff1HwJoxOyPtkNNudsoAmSe61HH/EUs2QHFzT
         5Gsyj5+jdOjWUhaCNoGkTsMFDt9OhnBZuBhnJ5Re7z4Dj3jx+cFBxMmkUcEfXT4Kz5OD
         OuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L2XzINSDFSEvVIKVI2wVpJiYMuWabWAuVVe8v1OkWsI=;
        b=Y5hNN3yTeQ0OMRyTE+QtbUo0wN2psxzkpCliylbUAIWYhB1pKgO0QfmF62SZ109Sj4
         pwQCLqpmPuvsBfVn2FnJAEIhRrWOZAuprAcp/xtOPeX6D1nARugUn9ERi1DBS3u1jbAc
         HxVHLvYHOeQvGggTVs4Fdad9Qa1do96TFLsmlv4bMPLxKfGK1anqx0ZChL65SyEJeEl8
         Ei+lnZDWZEmNs3QwbZ1LPahzDDpBXCbFUmfGdPIP3vrfgkWWIx1XARS4JUmVU9Qspula
         gyufe8DMULR4/ix2ZvHM0tM6RIVuBbX7VRsOVlC3cN8y+845kyjHRPP51WYskrk5cq+9
         jytQ==
X-Gm-Message-State: AFqh2kpI+RBrRrEBn2H09xLp8qRtt7zM8Alr6tCnaqWPi5rYYM+uzYg8
        vE0WpIGfxW340qDJRyMH1m/ElvybD4orXtWTAPTY2TpA6yA=
X-Google-Smtp-Source: AMrXdXsHBND9yqg/aQT2MvD78H2b1FN2qJvOmmnDkb0pa4kqAWIj5/4aU93Gc6S0kb5DvBaZ3q+fYsMF+KhuUT1LnCs=
X-Received: by 2002:a05:6402:120a:b0:462:2e27:3bf2 with SMTP id
 c10-20020a056402120a00b004622e273bf2mr4869720edw.13.1672853015563; Wed, 04
 Jan 2023 09:23:35 -0800 (PST)
MIME-Version: 1.0
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-20-martin.blumenstingl@googlemail.com>
 <63b4b3e1.050a0220.791fb.767c@mx.google.com> <CAFBinCDpMjHPZ4CA-YdyAu=k1F_7DxxYEMSjnBEX2aMWfSCCeA@mail.gmail.com>
 <63b5b1c0.050a0220.a0efc.de06@mx.google.com>
In-Reply-To: <63b5b1c0.050a0220.a0efc.de06@mx.google.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Wed, 4 Jan 2023 18:23:24 +0100
Message-ID: <CAFBinCCvf8E6jwjtoSgATnBxULgytFsUnphzUuaVPygsO3Prwg@mail.gmail.com>
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

On Wed, Jan 4, 2023 at 6:05 PM Chris Morgan <macroalpha82@gmail.com> wrote:
[...]
> > > [    0.989545] mmc2: new high speed SDIO card at address 0001
> > > [    0.989993] rtw_8821cs mmc2:0001:1: Firmware version 24.8.0, H2C version 12
> > > [    1.005684] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x14): -110
> > > [    1.005737] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1080): -110
> > > [    1.005789] rtw_8821cs mmc2:0001:1: sdio write32 failed (0x11080): -110
> > > [    1.005840] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x3): -110
> > > [    1.005920] rtw_8821cs mmc2:0001:1: sdio read8 failed (0x1103): -110
> > > [    1.005998] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x80): -110
> > > [    1.006078] rtw_8821cs mmc2:0001:1: sdio read32 failed (0x1700): -110
> > The error starts with a write to register 0x14 (REG_SDIO_HIMR), which
> > happens right after configuring RX aggregation.
> > Can you please try two modifications inside
> > drivers/net/wireless/realtek/rtw88/sdio.c:
> > 1. inside the rtw_sdio_start() function: change
> > "rtw_sdio_rx_aggregation(rtwdev, false);" to
> > "rtw_sdio_rx_aggregation(rtwdev, true);"
>
> No change, still receive identical issue.
>
> > 2. if 1) does not work: remove the call to rtw_sdio_rx_aggregation()
> > from rtw_sdio_start()
> >
>
> Same here, still receive identical issue.
Thanks for testing and for reporting back!

Looking back at it again: I think I mis-interpreted your error output.
I think it's actually failing in __rtw_mac_init_system_cfg()

Can you please try the latest code from [0] (ignoring any changes I
recommended previously)?
There's two bug fixes in there (compared to this series) which may
solve the issue that you are seeing:
- fix typos to use "if (!*err_ret ..." (to read the error code)
instead of "if (!err_ret ..." (which just checks if a non-null pointer
was passed) in rtw_sdio_read_indirect{8,32}
- change buf[0] to buf[i] in rtw_sdio_read_indirect_bytes

These fixes will be part of v2 of this series anyways.


Best regards,
Martin


[0] https://github.com/xdarklight/linux/tree/d115a8631d208996510822f0805df5dfc8dfb548
