Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92AB46D2EFF
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 10:06:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbjDAIGH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 04:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbjDAIGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 04:06:06 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB27C17F;
        Sat,  1 Apr 2023 01:06:05 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id s20so5059467ljp.7;
        Sat, 01 Apr 2023 01:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680336364;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=4ST7qAZyUrUnu6C0b1n65WZJxUtV/xJSKyTsGfRXsQQ=;
        b=OX9c9pq7jnMlmww6eCQy8E8DF55OrCoH3HuIZh184Ou5PTYdQU2dacd+IoxRlFm15b
         wWzPw7RNpZi8y4fS8lzLQdnCl64yP8FNPEh4logBq5RCgl1q/ggwwUKkFV5IdgpTJyFC
         XMgu0SPxPePqN32LI6Z4lqR907ZUQpVU4fFIG+CfZnmA2D5zMIF0EFLHWj84mXmI5mzO
         td6DLKS6PzgzPQZBgG7zBG71MpJmmSi5NZuN1ysgBXWDRWEcs5HoqiVZnf8S54Zl5qKl
         lLppefThuZyEOxtNbfYsbidT+//tNSdMAccBMCFCDb/9WIAs+Sm6XoRlLZBVSzKl83gT
         nbhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680336364;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ST7qAZyUrUnu6C0b1n65WZJxUtV/xJSKyTsGfRXsQQ=;
        b=IgiVeCCrn7FX3y8E1NAXDXZ1H09NtUilXlrxikeqZJS0ruC2pPDRDVcmTUCRt/63FJ
         Run59wX2IJfG3KXx3rEq+1zUaaVpGbl7higKZ2H7k/0Lnf9uNnGQi09I3MFUE1/vVuz5
         2bx1Kq+I1NS4Pn+pR0ctaHZ0w2GCZU8Afmr3SYsK7au4/JWYUBuRyUNuIuDaK23+V2E1
         6puQihpX7gjHfAT15pyh5a/eIV0JI+EH2WmNImN7XX0jdV6OPl2dvEdgUiii1XFnYfXB
         aWbuo4QQBmOhKtaakqA0gyatvO9D1Dt8M83/OG0zqB+/DjcyjYN6FQhwJvE3Tkd5gVD/
         8BQQ==
X-Gm-Message-State: AAQBX9el2E1R2SmFV/h5JlpBCAHcQTHo+QG5RSA7qOiN4MUJeVeXBUB+
        d2hjtxQVmAQ6GorkkYgDMjENEDEOE9YE+GI3tco=
X-Google-Smtp-Source: AKy350ZUaKV33EBurp3zv7o2fsJ4r1rVorZJ0CUdpHaYPqLPuvQOPZJ/bV7evNA8N5hP31voe9eVfor77FwKucCZFw8=
X-Received: by 2002:a05:651c:150f:b0:293:4ba5:f626 with SMTP id
 e15-20020a05651c150f00b002934ba5f626mr5975912ljf.2.1680336363546; Sat, 01 Apr
 2023 01:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1680180959.git.daniel@makrotopia.org> <fef2cb2fe3d2b70fa46e93107a0c862f53bb3bfa.1680180959.git.daniel@makrotopia.org>
 <6a7c5f81-a8a3-27b5-4af3-7175a3313f9a@arinc9.com> <ZCazDBJvFvjcQfKo@makrotopia.org>
 <7d0acaef-0cec-91b9-a5c6-d094b71e3dbd@arinc9.com>
In-Reply-To: <7d0acaef-0cec-91b9-a5c6-d094b71e3dbd@arinc9.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Sat, 1 Apr 2023 05:05:51 -0300
Message-ID: <CAJq09z6Y-vKhkDUs6-KC-+JZXs9faQZh1k3nq92fC6RbpQeGgA@mail.gmail.com>
Subject: Re: [PATCH net-next 14/15] net: dsa: mt7530: introduce driver for
 MT7988 built-in switch
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk,
        linux-kernel@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> The mmio driver could be useful in the future for the MT7530 on the MT7620
> >> SoCs or generally new hardware that would use MMIO to be controlled.
> >>
> >
> > Sure, it would be a bit confusing once we add support for MT7620A/N (if
> > that ever happens...), then CONFIG_NET_DSA_MT7988 would need to be
> > selected to support this ancient MIPS SoC...
> >
> > If you are planning to work on support for MT7620A/N feel free to suggest
> > a better way to name the Kconfig symbols.
>
> I don't plan to but Luiz may. Onto my suggestions.

I did start a branch to bring mt7620 ethernet+dsa upstream, but since
I burned my test device's serial port, my mt7620 and rtl8367s dev days
are over. After me, I wouldn't bet someone else will invest the
required amount of time that mt7620 needs just to support an outdated
SoC. Its internal MT7530 still only supports FastEthernet, so to have
GbE, you need to add a second switch connected to its single Gigabit
RGMII port. If you need GbE, you can just use an mt7621.

Regards,

Luiz
