Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A61F6C22AA
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 21:30:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjCTUaK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 16:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229565AbjCTUaG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 16:30:06 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32B9013D6C;
        Mon, 20 Mar 2023 13:29:34 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id y4so51814604edo.2;
        Mon, 20 Mar 2023 13:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112; t=1679344172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QYZOthRe2Sn6mPr50C2vVU4y8YGt44Tewf3C3OiSzSY=;
        b=NLD70tJFs/akTvr/UxBT36qutDMtlFNlZuypATv3sO7Gkzv3f0ji+SVDRMrfZvnOLb
         gov27oSU8BFANiq2LthBeLQ9DQ5jJ72TDgOiBnzS7YqeKgLQSlC6aAPzJBI3Txpj3kK7
         eziIpjYDb+NT2B1W/JAvDIlfH3kfifwy+XJvVV1b2K3gYboZLgO+NyI6QD5OCA+/Kb61
         1f+euHKxrD7acNnY4KMqrs8J04n8NBOGyq2g079dXS2yaRkiuBYn+rDiSXVXBzFr3sTe
         qpSsmPAfgPGW41NjkQiYvzWO4MJBmm4+4GX21x+gbXovLZdib+nBqDtoL0G5pMcqX6AY
         718g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344172;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QYZOthRe2Sn6mPr50C2vVU4y8YGt44Tewf3C3OiSzSY=;
        b=5J3dNreDyYD1Hb0UxzB4caioqEeoLAhGok3tfdTB7CHH6H7PfqcafmTlvNzAI5oaxX
         iOcpgYoWG+CeFjuC8lHdfNWAep5ZRornG4dzCqIRK3iw9GwAtfDT+EiKOVKf0xV18Vmd
         UE1CX1rRGikjKEe7jAG6uIQrYalYNjEjm4Va4WlAThx0kN6Ov69FsyMzZLNx60OB2hYM
         QkZlCbJ+CURYDA0MjCvI0XYnRmpxo/6ZbXwtXDDoOn7BOAcKZwOOlwh24DOaioO+Lsfm
         l1oZq0+kgiq5t4YPl33DfX++oWIM3mQryvaTZva5EH8diMb6CYDLWi+yaZuCq5XPCWg+
         KU3g==
X-Gm-Message-State: AO0yUKWrQ8BbPLbSoSZryftnEUVGEKemEmIR3xnFV1LgX/DIpX4hDlPz
        0KhgL+eJkpoV+63aiIRRgXcPVpUuTNltNFplEko=
X-Google-Smtp-Source: AK7set8ioH4qkvyNKpdoBAB36Tt7dmLpqWianC+mMdllyZpApql/SQ2xTXx1nAQXoEO8wEpjaf3gYhqdggDksqI+wvw=
X-Received: by 2002:a50:c389:0:b0:4fa:3c0b:74c with SMTP id
 h9-20020a50c389000000b004fa3c0b074cmr465915edf.4.1679344171725; Mon, 20 Mar
 2023 13:29:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230310202922.2459680-1-martin.blumenstingl@googlemail.com>
 <20230310202922.2459680-10-martin.blumenstingl@googlemail.com> <6413750b.4a0a0220.cfd67.2a0b@mx.google.com>
In-Reply-To: <6413750b.4a0a0220.cfd67.2a0b@mx.google.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 20 Mar 2023 21:29:20 +0100
Message-ID: <CAFBinCBdEuCKZqXEtcV8mVnOGRbk+DeTiZ1WNpU-HVR+eCiJjQ@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 9/9] wifi: rtw88: Add support for the SDIO based
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

Hi Chris,

On Thu, Mar 16, 2023 at 8:59=E2=80=AFPM Chris Morgan <macroalpha82@gmail.co=
m> wrote:
[...]
> > +MODULE_AUTHOR("Martin Blumenstingl <martin.blumenstingl@googlemail.com=
>");
> > +MODULE_DESCRIPTION("Realtek 802.11ac wireless 8821cs driver");
> > +MODULE_LICENSE("Dual BSD/GPL");
> > --
> > 2.39.2
> >
>
> Overall it works well for me, but when I resume from suspend I get the
> following filling up my dmesg:
>
> rtw_8821cs mmc3:0001:1: sdio read8 failed (0x86): -110
>
> So suspend/resume seems to be an issue, but otherwise it works well
> for me.
Thanks for reporting this issue! I have a fix in my local tree and I'm
testing it currently. If you want to try it for yourself (before I
send an updated series) you can just replace one function in sdio.c:
static int __maybe_unused rtw_sdio_suspend(struct device *dev)
{
    struct sdio_func *func =3D dev_to_sdio_func(dev);
    struct ieee80211_hw *hw =3D dev_get_drvdata(dev);
    struct rtw_dev *rtwdev =3D hw->priv;
    int ret;

    ret =3D sdio_set_host_pm_flags(func, MMC_PM_KEEP_POWER);
    if (ret)
        rtw_err(rtwdev, "Failed to host PM flag MMC_PM_KEEP_POWER");

    return ret;
}


Best regards,
Martin
