Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF1F578F51
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 02:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiGSAeB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 20:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbiGSAd7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 20:33:59 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9B820BE3;
        Mon, 18 Jul 2022 17:33:58 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id tk8so12968667ejc.7;
        Mon, 18 Jul 2022 17:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IvxZ+pT9eeB1oLC9gFmEKd/KuQtpynmxv5JFp2p4LmA=;
        b=gIwUl/XuJhRTTGvtNQ0aWFNNZ72RlbJkwCpGM7wO/sSbDoqxUvqlBJWjDWb4nUVxkr
         wA4kzWGIsYd+oyTYPVOyC2ZEirNy56kC6YvoOg+Fu9JlIyx/BhzBlvQ+GB0MbVTk2jEb
         eyBlXAwQJroWvaq2gnY/J8A7Jy+02RK/TtexgA7MBUZK9FnxBH7HPm/OPbZR2kp6FIOG
         BYDIh26pR+njlg0wqOtuaPaePG5L+WBmSIyBqxyMD5dCULrXaEhs9vg/GnJqlYLpsG/y
         w38dp1uD5s55WeggWwrAh2xQxeFiYqJgAS/5mGamYHgRw4gT0je1cudllgWrZEayUSK0
         E39A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IvxZ+pT9eeB1oLC9gFmEKd/KuQtpynmxv5JFp2p4LmA=;
        b=3pozF0Sp0Y31M6XUXg5S/pg5PQ13T7OSXUI/u2d+ngzgnenZaMrKdO629nBNmeWgaV
         Z3v5bRHB17DWBN5oYUBjDNFHhCNu0vZiPPOwfymIjFbjWChr7WSzs+R6V34YH+U19Uzt
         6rJanp842pyNVovP9mzCtmEt1nNpJxy47uzLplu14L6nH4JjqcSd25fu5Bxcu1dj5lFy
         A4oWGSWmK/oPkvYllMLtce9K6fy9UMOhCW38s7vGzS+/svDbiubNe9GF6KTHKmoLTnnJ
         5H3dmqQOwXwYadKi/VLKJ8rOG+AxNsi5OoQFVSylk9202nm9Lhq7QfAGK06YuwwUy0AW
         X7UQ==
X-Gm-Message-State: AJIora+rHTGTED0YfyLnHtBoK9I+cU5fbEc/G345v467NOlVM8Y0IQRV
        CGEj0Esz4xHEXBrRkwPytQSkZjfs3QgMF4WVmNc=
X-Google-Smtp-Source: AGRyM1sRm67nRsWZfFSFhouVBqucc4bOtFjiV6na1gILOaBHlxhxwORoLOL7DxP/wH7oPhk7TCfa/L42Gn4aM8oO2I8=
X-Received: by 2002:a17:906:149:b0:712:502:bc62 with SMTP id
 9-20020a170906014900b007120502bc62mr28280283ejh.720.1658190836834; Mon, 18
 Jul 2022 17:33:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220718072144.2699487-1-airlied@gmail.com> <97e5afd3-77a3-2227-0fbf-da2f9a41520f@leemhuis.info>
 <20220718150414.1767bbd8@kernel.org>
In-Reply-To: <20220718150414.1767bbd8@kernel.org>
From:   Dave Airlie <airlied@gmail.com>
Date:   Tue, 19 Jul 2022 10:33:45 +1000
Message-ID: <CAPM=9tw6iP3Ti1idrBLTLVX57uYgf79rG2-0ad-fS48z+pXzeA@mail.gmail.com>
Subject: Re: [PATCH] docs: driver-api: firmware: add driver firmware guidelines.
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Thorsten Leemhuis <linux@leemhuis.info>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel@ffwll.ch>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        alsa-devel@alsa-project.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        linux-block@vger.kernel.org, Dave Airlie <airlied@redhat.com>
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

On Tue, 19 Jul 2022 at 08:04, Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Mon, 18 Jul 2022 11:33:11 +0200 Thorsten Leemhuis wrote:
> > > If the hardware isn't
> > > +  enabled by default or under development,
> >
> > Wondering if it might be better to drop the "or under development", as
> > the "enabled by default" is the main part afaics. Maybe something like
> > "If support for the hardware is normally inactive (e.g. has to be
> > enabled manually by a kernel parameter)" would be better anyway.
>
> It's a tricky one, I'd say something like you can break the FW ABI
> "until HW becomes available for public consumption" or such.
> I'm guessing what we're after is letting people break the compatibility
> in early stages of the product development cycles. Pre-silicon and
> bring up, but not after there are products on the market?

I'll stick with enabled by default I think, "public consumption"
invites efforts to describe corners of the cloud or other places where
hw has shipped but is not technically "public",

Dave.
