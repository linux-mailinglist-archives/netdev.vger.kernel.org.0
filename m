Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF5A1E6476
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728590AbgE1OtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 10:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728456AbgE1OtS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 10:49:18 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDDFC05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:49:18 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id w3so3298705qkb.6
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 07:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=7bgiq+hLHRX0DJp5HGAPibY152zraWoS1bf1ZUi8yr0=;
        b=K6fYhbLNN80hW3Pf3S2Qo3jCZMiRm8Yyt2Z0WsGO9l1UOg9rbBt4EhiCgeduYh9v2J
         Cu+K0SqzPmLZEo0x+tipWKiL/HHRuemXF65qU7QlS++2O92h6Rtz1FBrTLKpQxSF65dv
         yiRzSumOTtlF5dDuF9zxCbR1UIzy1aAXD1FkiNwIYn2Wm0PiF4uKafoFpnA6QtXtWbyQ
         Lvs6IVTwvtYeO96emfrhmenqmqgc1PdidYI3hbgg1K3+lk99R+yYx2lFOhs45rHz9LTf
         jR/cMidGMOI0O4ABpSJmCcDzcW6V1cd69mNF9Unv6ByQxucGJBA1oELurTpg3ZrLS6xa
         qT5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=7bgiq+hLHRX0DJp5HGAPibY152zraWoS1bf1ZUi8yr0=;
        b=gNTIAP3xlJUnEtqaMvWXTcE75POQWdiXB2tI0VEZo/QpJx8NsbhuVVNeVV9KG1iBjE
         nV/awFfL8IV/3KUNhC0ylTFCfSmVJgpBIv53z5LqhKuhkyCedTLrufTSNFMkxUfekwym
         6xVzXvsnBn8tFcg76bd1E5VZvjBponDe/kEZAsvts+PdmTYwzH/E5sNNNExYn5q1fltt
         F/ZMA2QiCuDm1ntxEg8LfhDwBQFUrKJUz3MvDA1nBhAv9N00GWMouMXShUGxx8Dxycx8
         i/3VbVgtDQwJ73xFj1CTo0OLnDRaAJyh/YE3DhC6jA13Mm6pDpB2XFKWTZXT2H1QfnUR
         P/zA==
X-Gm-Message-State: AOAM532b+NvB2tgw2G5B44KqhoqB0HvBT0XDZB5/LuMAjskRezyCLwAF
        msQtrCLFHQgrkrZ6mnhkb1sz6CJ8BW8V0EfCW3gWpw==
X-Google-Smtp-Source: ABdhPJwMqRBjwPsgwb2FUKECIe64ZjaPiVPeaWousPYaYOHlGL5MTRIVN7nLAwXJjVoc8/Otc86MvbDhvL+AxdAQhlE=
X-Received: by 2002:a37:dd6:: with SMTP id 205mr2993984qkn.323.1590677357382;
 Thu, 28 May 2020 07:49:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200528142241.20466-1-brgl@bgdev.pl> <20200528142241.20466-2-brgl@bgdev.pl>
 <20200528144456.GG3606@sirena.org.uk>
In-Reply-To: <20200528144456.GG3606@sirena.org.uk>
From:   Bartosz Golaszewski <bgolaszewski@baylibre.com>
Date:   Thu, 28 May 2020 16:49:06 +0200
Message-ID: <CAMpxmJVB_L+otX2u80qwGjw4TXCJtwOXe=t11O4Daq3miMVk6Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] regmap: provide helpers for simple bit operations
To:     Mark Brown <broonie@kernel.org>
Cc:     Bartosz Golaszewski <brgl@bgdev.pl>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        arm-soc <linux-arm-kernel@lists.infradead.org>,
        linux-mediatek@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

czw., 28 maj 2020 o 16:45 Mark Brown <broonie@kernel.org> napisa=C5=82(a):
>
> On Thu, May 28, 2020 at 04:22:40PM +0200, Bartosz Golaszewski wrote:
>
> > +     return (val & bits) =3D=3D bits ? 1 : 0;
>
> The tenery here is redundant, it's converting a boolean value into a
> boolean value.  Otherwise this looks good.

Do you mind if I respin it right away? I don't want to spam the list.

Bartosz
