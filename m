Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C9C57D3CA
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 21:03:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230465AbiGUTDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 15:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiGUTDK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 15:03:10 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8BE8CCB5;
        Thu, 21 Jul 2022 12:03:09 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bv24so3577202wrb.3;
        Thu, 21 Jul 2022 12:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8FiCNiUvZcviZm3kfKD2/KbS8gbm4AhNmzu6H6fLTj0=;
        b=R5dtDB/M9phN+65l2Qma/3SXMktcqknerv8FVUSOP8QshPKuwgJrElipxSqBcx4ZGs
         LcHZ/2HmAIwl+wK8BAyvr8g+vGjkDAceEnI9upE+sQgARd4rfHHZej1/abeAgqRrAX/K
         ZeSpXG6rTXDR/OoFmYUkV9jP/ecq30ncDPuTbFhHf4wGgItihzU9dYxhonPcuslchRrG
         /ETVVDXopUDX4/xC1ge6B82An8Ct41wkMiSZQWGw7+SblBIMV5zg4ZiyuyRctHgzeWx6
         hGdIVphBgLttuYoTi2cNgz0kY9mali2rIi66R6e11kmDhITrBbj+H0XniqQHsmDV6xjq
         rNiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8FiCNiUvZcviZm3kfKD2/KbS8gbm4AhNmzu6H6fLTj0=;
        b=HT+1JHSO6jKtyEWdleuOA2VJClNPA+WBwrLlwMbCp4+pNY5gIiUsKqG0ksAMnLp+IW
         sxcUj/LuP10oXk1rYSM+rOVtTnNo2eymZApcqdh5jYm+yzo+PB1zdY2EXRSTsiFy2Yli
         mAhmleXI1soefGa6w1DqOmrAQdxt6I06pd5kOu1Kv2DyeL1dFZafwZg/ZM59UWwbREQb
         /s7u1/OY3gl2cqpFHg3EK14pRbZ7plE0YWTvxkvg022TicdYc+w/WvtVwXXP5WLVfIv9
         FyAiKR0KYYIqmgdqw/1EeRuLbOpyGz5zmmUDHG+c5zFZL1UCf6XEZH3CPhsFYPPSOoNv
         ZfjQ==
X-Gm-Message-State: AJIora/Iq30dLC0dN2zuEGxdwvOvqi4+fS0wim608Aav26T+RXoYCafl
        dzkGtkb37M9YhgqAc//AexbfyxuM8hDJPL94Br8=
X-Google-Smtp-Source: AGRyM1tUiIITVaS8LBVb76fxTOPvGTT7YEwuZqNYA0svYuOh2XgEeXpJPSfdipqrfA45HyTlhMBptFuYjnGt6u5tTTY=
X-Received: by 2002:a05:6000:1cf:b0:21d:656c:dd9f with SMTP id
 t15-20020a05600001cf00b0021d656cdd9fmr35969897wrx.15.1658430188047; Thu, 21
 Jul 2022 12:03:08 -0700 (PDT)
MIME-Version: 1.0
References: <20220719235002.1944800-1-sean.anderson@seco.com>
 <20220719235002.1944800-9-sean.anderson@seco.com> <Ytep4isHcwFM7Ctc@shell.armlinux.org.uk>
 <3844f2a6-90fb-354e-ce88-0e9ff0a10475@seco.com> <YtmVIXYKpCJ2GEwK@shell.armlinux.org.uk>
 <YtmckydVRP9Z/Mem@lunn.ch>
In-Reply-To: <YtmckydVRP9Z/Mem@lunn.ch>
From:   Dave Taht <dave.taht@gmail.com>
Date:   Thu, 21 Jul 2022 12:02:55 -0700
Message-ID: <CAA93jw7w1MY-4MWAQhSQG2BLrCjYApUPeFRB8fpuRtU-ZWYFEg@mail.gmail.com>
Subject: Re: [PATCH v2 08/11] net: phylink: Adjust advertisement based on rate adaptation
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>, netdev@vger.kernel.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
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

On Thu, Jul 21, 2022 at 11:42 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
> > I guess it would depend on the structure of the PHY - whether the PHY
> > is structured similar to a two port switch internally, having a MAC
> > facing the host and another MAC facing the media side. (I believe this
> > is exactly how the MACSEC versions of the 88x3310 are structured.)
> >
> > If you don't have that kind of structure, then I would guess that doing
> > duplex adaption could be problematical.
>
> If you don't have that sort of structure, i think rate adaptation
> would have problems in general. Pause is not very fine grained. You
> need to somehow buffer packets because what comes from the MAC is
> likely to be bursty. And when that buffer overflows, you want to be
> selective about what you throw away. You want ARP, OSPF and other
> signalling packets to have priority, and user data gets
> tossed. Otherwise your network collapses.

Most of our protocols (like arp) are tolerant of some loss and taking
extraordinary measures to preserve "signalling" packets shouldn't be
necessary.

That said, how much buffering can exist here? How much latency between
emission, receipt, and response to a pause will there be?

>
>         Andrew



--=20
FQ World Domination pending: https://blog.cerowrt.org/post/state_of_fq_code=
l/
Dave T=C3=A4ht CEO, TekLibre, LLC
