Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F361C44E254
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 08:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233565AbhKLHZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 02:25:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbhKLHZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 02:25:53 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58851C061766;
        Thu, 11 Nov 2021 23:23:03 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id o8so33927663edc.3;
        Thu, 11 Nov 2021 23:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GML/j0biHkMPIhr228qPRBmmjkAdp6WUxiI0Aqk8uDw=;
        b=LP70yhUbcWoPkhFEpzd5rLCtJCOYN5XyCgWXBV9HBT+mFUoDXRSJXOWBQFfmm+dupJ
         iF/HxQmpvRF+BL6sRCQnXwGif6iZc/27sfGrZ+uFLncyrEjIkre93D1XCzN4wqBoJpm1
         9JNONC0Fu+Xfg6c7mMgPyda3QLuA3NM7MN9U/4suJ7bUU/OdIYltWwXjOQ7eWRHvpoHh
         nczXT/L+wqItELNaTfmLo5sZwqsrVrz+i1SBQMCZ1WIsNRwkH/gUiVKx6ZMbdnOYuoQV
         NQwJAp11DfT4diJQfRyYKXnW9TogqeRFkTCvKnfS/OjTTwouH6r3t7Ok2nYTyBWeUAIP
         UxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GML/j0biHkMPIhr228qPRBmmjkAdp6WUxiI0Aqk8uDw=;
        b=douibayaPaNfCfRarSsp/z4jBGwo7jzlVehVXLRcvNV2W1hdywwdgwLf82bLiUYNVM
         Up7L0aZX+T11vnhhA1170bNTyOr3p6gMoINSD6UbV0gGaHsvlA6AGndCUb6EQnaPfRgG
         Jsb5S+bGKHihOjBWnne9UVsc/2lXrXJJnipTe60HxVPUSjFVSJA6wgC+4uYK27kly3DJ
         yaNhop4eYl3ItPGDuWYmVKu1CrT3mGIZ4T3VvfkKsufyxF306BosRAZX1nsKkwn9/JfS
         DQGsFoZuhEteRbdzSfwmx1B+he/xyqvOuWW3GnVlrxTLWVwIsZSmuN/zJbrR69oGL294
         ES/g==
X-Gm-Message-State: AOAM530MNDBEMIzAx0KtfmpUu4Q+z+PEH0f20DLe9N/TxFQGsf7Axp52
        DjBVFNTEUPgNn2Xd7gndbvh4sc+ChRwd01p6GTwvU1kPFIeHmg==
X-Google-Smtp-Source: ABdhPJynhb9mYpfzM9A94RqJvz8FDvRRgaUS4Ulmw+R+ZRq0QB8qtFTRAhmcTryxsu+LnLyUDuxsZ12bwU6bYhq7b7M=
X-Received: by 2002:a50:cd16:: with SMTP id z22mr2347658edi.128.1636701781806;
 Thu, 11 Nov 2021 23:23:01 -0800 (PST)
MIME-Version: 1.0
References: <20211111145847.1487241-1-mudongliangabcd@gmail.com> <CAB_54W6K+FTTRxLbUHp8csBbtJf=E+JU-zd3q7mQZpa-LHTX8A@mail.gmail.com>
In-Reply-To: <CAB_54W6K+FTTRxLbUHp8csBbtJf=E+JU-zd3q7mQZpa-LHTX8A@mail.gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Fri, 12 Nov 2021 15:22:35 +0800
Message-ID: <CAD-N9QXdDoT_ckDeV7KM8o2CyuuMswhYs5ibZitD54yDmme3Xw@mail.gmail.com>
Subject: Re: [PATCH v2] net: ieee802154: fix shift-out-of-bound in nl802154_new_interface
To:     Alexander Aring <alex.aring@gmail.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 12, 2021 at 11:12 AM Alexander Aring <alex.aring@gmail.com> wrote:
>
> Hi,
>
> On Thu, 11 Nov 2021 at 09:59, Dongliang Mu <mudongliangabcd@gmail.com> wrote:
> >
> > In nl802154_new_interface, if type retrieved from info->attr is
> > NL802154_IFTYPE_UNSPEC(-1), i.e., less than NL802154_IFTYPE_MAX,
> > it will trigger a shift-out-of-bound bug in BIT(type) [1].
> >
> > Fix this by adding a condition to check if the variable type is
> > larger than NL802154_IFTYPE_UNSPEC(-1).
> >
>
> Thanks.
>
> I just sent another patch to fix this issue. The real problem here is
> that the enum type doesn't fit into the u32 netlink range as I
> mentioned some months ago. [0] Sorry for the delayed fix.

It's fine. This fix hits the core of the underlying bug.

>
> - Alex
>
> [0] https://lore.kernel.org/linux-wpan/CAB_54W62WZCcPintGnu-kqzCmgAH7EsJxP9oaeD2NVZ03e_2Wg@mail.gmail.com/T/#t
