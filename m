Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6653901CA
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 15:12:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhEYNNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 09:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233061AbhEYNN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 09:13:26 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FA38C061574;
        Tue, 25 May 2021 06:11:40 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id w1so31623870ybt.1;
        Tue, 25 May 2021 06:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/PFVsPOHgJ97hXva08hCaidxRFtp/e8m6uT8+4/8nNg=;
        b=aXaYgSQIxTxzG86HRp5BgVVNaw3FvnwJE2m6gsrCgp4a+WBt5KZqi99KCQWocFkFU6
         jqGbcBua/YXSRFDDT0GzPEuQExPBOLOKSu3qfOEi0gyUZmsIwBn71PrVyP6fZdRGk51Z
         B47T0eL8XM9P2F0i6IlQwzoy7L1KxlnT75rmGVu48B83udu4Sqq0G6pJm/H/IdSOZDXK
         qOHUR/OBnYsncq04s35YDlh6Da+Rpf6Xt4nvk+pyreWTOz35qXKmKtpzoxl9KmJhsiTX
         0NKjTnRUaAJGSZI87T6jg7Hpz/Mdki3KGvY/udODyfxaZCeHy1eprqBYvm6/sWXwDRXw
         15Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/PFVsPOHgJ97hXva08hCaidxRFtp/e8m6uT8+4/8nNg=;
        b=X11geWEhYnZ0PtpjOuOd3I+wCErXaw2BmkV/YrDmMS64ACmctJy7dRrk0kgL07+VEs
         ZXQ/dZmLbn1glDECKemGj/PPfNYXp76VpTyz9kjhHSjFPsTkdWqOqQ/Me2jecKrLIDMH
         9tqiTacySxAgGH+pgfHGn7jXrH82hhxw/7pCSXw+02oDZfChepMp77VjUMau99eBqJgq
         Gb5PPohK/z/w9/2SZsEMmGeFC9QFDEUosJoQPHHzrMdjZ2DXzcdv0BnP1Gg1lY8ASZtD
         rV679jSNnVu5yYoYT6fjQ1sJTmzT14+cWEApZ3L+wUnPKkHiB2ciBu0EHId+SQMn0NQE
         y+dQ==
X-Gm-Message-State: AOAM530rB6aczhpx/OWfnupRUvmiqHRxBvXEGDbItvHIp+SwRf5L+XQ+
        0L61p7iDP8jSHB9V6sZJPsJyWbhuNPg9JgLh4m4=
X-Google-Smtp-Source: ABdhPJw7HXw8uszzkufyper3JITEPX4kBnV5R8/N5Dq9faUqPeNiyqcrmQ/UUVOQiDb7LTwmxJtncyCnhGCW7Ju90Ys=
X-Received: by 2002:a25:4d56:: with SMTP id a83mr38354334ybb.437.1621948299686;
 Tue, 25 May 2021 06:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <20210525122615.3972574-1-pgwipeout@gmail.com> <20210525122615.3972574-2-pgwipeout@gmail.com>
 <YKz1R2+ivmRsjAoL@lunn.ch>
In-Reply-To: <YKz1R2+ivmRsjAoL@lunn.ch>
From:   Peter Geis <pgwipeout@gmail.com>
Date:   Tue, 25 May 2021 09:11:28 -0400
Message-ID: <CAMdYzYqHYu_aMw+EjeFP70HnbzJfC6md1fMT-yx0cs3MEF12ug@mail.gmail.com>
Subject: Re: [PATCH 1/2] net: phy: fix yt8511 clang uninitialized variable warning
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        clang-built-linux@googlegroups.com,
        kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 9:02 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, May 25, 2021 at 08:26:14AM -0400, Peter Geis wrote:
> > clang doesn't preinitialize variables. If phy_select_page failed and
> > returned an error, phy_restore_page would be called with `ret` being
> > uninitialized.
> > Even though phy_restore_page won't use `ret` in this scenario,
> > initialize `ret` to silence the warning.
> >
> > Fixes: b1b41c047f73 ("net: phy: add driver for Motorcomm yt8511 phy")
> > Reported-by: kernel test robot <lkp@intel.com>
> > Signed-off-by: Peter Geis <pgwipeout@gmail.com>
> > ---
> >  drivers/net/phy/motorcomm.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/phy/motorcomm.c b/drivers/net/phy/motorcomm.c
> > index 796b68f4b499..5795f446c528 100644
> > --- a/drivers/net/phy/motorcomm.c
> > +++ b/drivers/net/phy/motorcomm.c
> > @@ -51,7 +51,7 @@ static int yt8511_write_page(struct phy_device *phydev, int page)
> >  static int yt8511_config_init(struct phy_device *phydev)
> >  {
> >       unsigned int ge, fe;
> > -     int ret, oldpage;
> > +     int oldpage, ret = 0;
>
> Please keep to reverse Christmas tree.

Ah, I missed that.
Do you want a v2 or will it be fixed on application?

>
> With that fixed:
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
>
>     Andrew

Thanks!
Peter
