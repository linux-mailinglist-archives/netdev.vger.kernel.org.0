Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82905658BF3
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 11:50:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbiL2Ku6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 05:50:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233345AbiL2Ku1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 05:50:27 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D1C213DE9;
        Thu, 29 Dec 2022 02:50:08 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id u9so44279604ejo.0;
        Thu, 29 Dec 2022 02:50:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xFMsXCfWSHnd7DW7AtBbmF0mbUVmP/dA5yo0gz+yknc=;
        b=ZALxZ8yvP8e0FGeniJtEPHJyRQrP28k4KcZz2NVsNmw1Hc7gK2Tuxn+wv59OkqYdih
         gtmz1nMNthCW9OGAnkSywu6s7QSPbs7NQltZGd6qcD1LPuCJ/igMF3kR/t0wjylr8zop
         jXaOBYOx4h2/tIqdmUbnOkfDOP8ISY7PDtNtcxSiHgzEJIxxFiEwweOV/RnfCZq3Uc4s
         9bjKLgAoU8lEGgrBuMcFog7w0FGHFFCMSi/xWvXzE+qlTniGCNutVrCnyfuJKnaLYXqt
         r+LQIEElorWCtkreTu40z97grjfePXugyo3G5osJ2CTekVSoGgkH7dJOAvoAifiLnjKM
         JkHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xFMsXCfWSHnd7DW7AtBbmF0mbUVmP/dA5yo0gz+yknc=;
        b=r5l/FKk3X9nY8MrVSkJYCvCVAfNh4wzMieWh6OyTVSZT7td/pHx4JLac3amztKUp9P
         isqdlYwdePEcJj8aoalQ1Fr5ag4F6eoKMEN4mRKX8BGO4ORLdZvmc5+PaG9zVxptJJm6
         RBhhHxi2fJWG53ZI7rRb2ojZlgjczvCfq90YT0O22AdfuAcu1ddLWCqfcR9n8nUO+qu2
         utPhh9pq31VxCzdfAbKh41qMXjWzqkUQV2lSTuQndpGzpg4rXWC7eDl7J2bsf+PcckLd
         RaVEvI9q+eVae9cPc6QbeH48rOkM6nIzycYKVMTEi6G0eiyjbeFubuh3mfhVRCXwMnxS
         m1pA==
X-Gm-Message-State: AFqh2ko7QwkVXdyBe7PCHP9tHQnsjSuwsp7efa2mSMoxQJMkkmlkZxFZ
        06UNGJ4WrIBuN+t+ttSN/4Gecrp9bOkK6nAvd6Y=
X-Google-Smtp-Source: AMrXdXvw5WKMnFWDjCEYC95jCJQ5AsoOniEwsFJo04jNqkFv7owm3aekbXzzjg0HRBL68POW19mB4nqvXhwUJHBXbsQ=
X-Received: by 2002:a17:906:e4f:b0:7c0:ae1c:3eb7 with SMTP id
 q15-20020a1709060e4f00b007c0ae1c3eb7mr1773070eji.510.1672311006635; Thu, 29
 Dec 2022 02:50:06 -0800 (PST)
MIME-Version: 1.0
References: <20221227233020.284266-1-martin.blumenstingl@googlemail.com>
 <20221227233020.284266-14-martin.blumenstingl@googlemail.com> <b30273c693fd4868873d9bf4a1b5c0ca@realtek.com>
In-Reply-To: <b30273c693fd4868873d9bf4a1b5c0ca@realtek.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Thu, 29 Dec 2022 11:49:55 +0100
Message-ID: <CAFBinCAzmgwRAzAbXM17nmPw0bo9Mzx6gQQQrR3tPDb+n2jDHA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 13/19] rtw88: mac: Add support for SDIO specifics
 in the power on sequence
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Chris Morgan <macroalpha82@gmail.com>,
        Nitin Gupta <nitin.gupta981@gmail.com>,
        Neo Jou <neojou@gmail.com>,
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

Hi Ping-Ke,

On Thu, Dec 29, 2022 at 2:15 AM Ping-Ke Shih <pkshih@realtek.com> wrote:
[...]
> > +             if (rtw_sdio_is_sdio30_supported(rtwdev))
> > +                     rtw_write8_set(rtwdev, REG_HCI_OPT_CTRL + 2, BIT(2));
>
> BIT_USB_LPM_ACT_EN BIT(10)   // reg_addr +2, so bit >> 8
The ones above are clear to me, thank you.
But for this one I have a question: don't we need BIT(18) for this one
and then bit >> 16?
reg_addr + 0: bits 0..7
reg_addr + 1: bits 8..15
reg_addr + 2: bits 16..23


Best regards,
Martin
