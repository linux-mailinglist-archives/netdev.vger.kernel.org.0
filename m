Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745BE4B3E03
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 23:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbiBMW3O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Feb 2022 17:29:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238579AbiBMW3O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Feb 2022 17:29:14 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290425468F
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 14:29:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id m22so6841121pfk.6
        for <netdev@vger.kernel.org>; Sun, 13 Feb 2022 14:29:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=pFzEmc747RJJgqoPpp4vMmgfZEPvhYveqoTXx5Z+Gb8=;
        b=gF++amW4bzDcF3r5Pjx1c4cf94nTtakIHCkrNtvDtcEWMBxCAgpKrhUtUJzbdHjNi5
         9E7z5dQClMD/cKL0qaSVgBuHiXnz8Zgw0X1fiwKhYZ59X7tHh4tasTWxJCmaNIumD/cX
         opGjEN6m6Ls5SZBh+Tn8iIX8lpQKvisJBxBUWgH4vIh6DAm2WVj1KFm/CM1zFXG3YIsk
         JNhrCcD8OZWTwqQm/NmPPSsKOb1dVQe4qHTQnqgyjl7cdsxQOXNEShh03ZUUTuDwoexr
         VTjWPBh9i23x89Lloa6cTq9DHRy+wqOg4OpdMPrQzMvAPyXyBqJGnhYLcb4csEoC73X7
         mE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=pFzEmc747RJJgqoPpp4vMmgfZEPvhYveqoTXx5Z+Gb8=;
        b=F8++J17aHeILXb5RCln3vvbQBQXedeh7qXjFKKWHDob5wr+52SxK9LZG/TxI6zZ8+2
         Q/Kr3Ioy8jkLBtZRVwvwZ4ntZq/NeMFJbIbt2ie4LbomfvPtsKuwvcoaOTZ80+tDgK/a
         oStY8sERQf1MayZxF1U+zgavCWBjncO2gihYl+PsckGLyqEtRjnvGnE8NXB78P57uR4d
         +/RRr/SwE7hGv5pJse7zEiIM2YGELqFTE+on2JoW2/9yY2thejOs47N0gHYdpu8CcyRq
         wPnrkl+5UfdPLOzHkUWdxwhunTl9d5WUK2fY9h4YjRa9QGPmNHqAnTRlNryw5ggT2o9F
         sPqQ==
X-Gm-Message-State: AOAM533oOvbi776C8cElCj/f0wo6ng3rVvKfFZvNcFP6OF13ia/MmDKi
        GbkBX85PXTbMSxo3iSDMMCkfqyJ4Uqj6XQBZ/nU=
X-Google-Smtp-Source: ABdhPJxaLOJWdes/xPKpFtx6bFjh8YdWaaTPZ9kbVK86cZ2bz1SG9wTdKYWAYljBQnSeyO/5uC0C3T2/Y6lhTJuluLg=
X-Received: by 2002:a05:6a00:170b:: with SMTP id h11mr11528829pfc.78.1644791347659;
 Sun, 13 Feb 2022 14:29:07 -0800 (PST)
MIME-Version: 1.0
References: <B3AA2DEA-D04C-49C8-9D22-BA6D64F7A6B2@arinc9.com> <87iltjuevn.fsf@bang-olufsen.dk>
In-Reply-To: <87iltjuevn.fsf@bang-olufsen.dk>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sun, 13 Feb 2022 19:28:56 -0300
Message-ID: <CAJq09z73Ok=np6Lz+WHcWr2KhN4tq1f9O8W4+VR0SZcwAUOb-Q@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net: dsa: realtek: realtek-mdio: reset before setup
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Frank Wunderlich <frank-w@public-files.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > If realtek-smi also resets before setup with this patch (I don=E2=80=99=
t understand code very well) can you mention it next to mdio in the summary=
 too?
>
> realtek-smi was already asserting reset. I just asked Luiz to send a
> patch to only try the reset if reset-gpio is actually specified, else it
> prints "asserting RESET" without actually doing it. So this is largely
> cosmetic. But it is odd to touch realtek-smi when the subject is
> realtek-mdio.
>
> Arguably this could be separated into a few patches; something to
> consider if you decide to send a v3 per Florian's comment:
>
> 1. realtek-smi: add if block around reset-gpio assertion
> 2. realtek-smi: demote dev_info to dev_dbg in reset-gpio assertion
> 3. realtek-mdio: add HW reset here too, based on realtek-smi (with
>    dev_dbg)

I won't be a problem.

>
> Kind regards,
> Alvin
