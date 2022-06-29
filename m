Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD6855606AA
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 18:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbiF2QuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 12:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbiF2QuC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 12:50:02 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD00919B
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:50:01 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id b5so7744304vkp.4
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 09:50:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1xjaurxtrr+ElYOOvMAKu4UXyGgzuY971CUxJkJcb9M=;
        b=W+6qb8mmAJjS7XSVfIzriHNyoifK3hu5L0Lu2ZZ+fygaMDkfvcVL5nLy8Ju3QuoSkX
         ISkm020By6aUvZcIfql48a4CEnP1f1YMirudA8RJnH8iTkY0YKCtecYs8cg8Pf0eWSgP
         orkAOkkVqhpqRGC/+eG48FwLBdR6Wbulu3WEVpUOICxZw6MS1U5ySxFIWtho9ZTlxNWa
         TuzfYncXT8WLuz11HghZiASMupDw6F++NFvutMoIEqwYZblPXyR9xuRv3TiEN/LobE31
         Tf+WA72LPGRncFri6d642ZV/lTBCH5D3OkWB1zym9T6mNxM4qpUYczzkYbWcrfEOxIgV
         vXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1xjaurxtrr+ElYOOvMAKu4UXyGgzuY971CUxJkJcb9M=;
        b=IoJuVcHb3oysUt5v8MkLJihpaznYPWLW71+uVTEPwZFU4+g9pJCXKz2+L+ZvZDmaan
         NGBLAZYcyuSiYXoP4r4/5t5kcNlqzpKe0rb66NhF7cQiwzJyo6HpwnovqqJqU8O1yPxz
         pon6aGCEANmj7l9sHC+NQOv4Ipv0uzYbe13OMWioeo2jmc+Tfctyf7vzA/qZMF5VSEL5
         mtTyQpmzzPuOJCmtaVmsXeIjt7h4JRVbzqi7yBRrPbKY6wUPMQ63fzPR38qIv+zNFJPl
         uEYCma5wRdv7jqinJXa4H3njDydg1wOwR65cBrTYAQhlxIGhDgWo6Alwo80dz07mWQ5I
         3MTg==
X-Gm-Message-State: AJIora9rnX6UJX9BFFIVVbYVggy12pVGjgXsCc5DEJAAfPqil4KG5lkk
        K3vgMuiNvU7slba5Mup1GP0+YMfnYL4vaYdy2wc=
X-Google-Smtp-Source: AGRyM1slKgsizARc3rR9HsRkxcP+DxL7w59oVFXkilDMTIq3KWEiIw8tABZ1gkXALqWD0MDm6a8KyY6KABGHrnK2c8U=
X-Received: by 2002:ac5:cd94:0:b0:370:a1da:b959 with SMTP id
 i20-20020ac5cd94000000b00370a1dab959mr2015238vka.38.1656521400850; Wed, 29
 Jun 2022 09:50:00 -0700 (PDT)
MIME-Version: 1.0
References: <20220629035434.1891-1-luizluca@gmail.com> <6f4e00d6-6b7d-e4c7-8108-67c009f7a6d8@arinc9.com>
In-Reply-To: <6f4e00d6-6b7d-e4c7-8108-67c009f7a6d8@arinc9.com>
From:   Luiz Angelo Daros de Luca <luizluca@gmail.com>
Date:   Wed, 29 Jun 2022 13:49:49 -0300
Message-ID: <CAJq09z6j2FFHRs243OX37ycT7w1vHVpf1LeDWR1Ybh5vaJZyMw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
To:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Cc:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?Q?Alvin_=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>, krzk+dt@kernel.org
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

Em qua., 29 de jun. de 2022 =C3=A0s 09:30, Ar=C4=B1n=C3=A7 =C3=9CNAL
<arinc.unal@arinc9.com> escreveu:
>
> On 29.06.2022 06:54, Luiz Angelo Daros de Luca wrote:
> > The last patch cleans all the deprecated code while keeping the kernel
> > messages. However, if there is no "mdio" node but there is a node with
> > the old compatible stings "realtek,smi-mdio", it will show an error. It
> > should still work but it will use polling instead of interruptions.
> >
> > My idea, if accepted, is to submit patches 1 and 2 now. After a
> > reasonable period, submit patch 3.
> >
> > I don't have an SMI-connected device and I'm asking for testers. It
> > would be nice to test the first 2 patches with:
>
> I'd love to test this on an Asus RT-AC88U which has got the
> smi-connected RTL8365MB switch but modifying the OpenWrt SDK to build
> for latest kernels is a really painful process. I know it's not related
> to this patch series but, does anyone know a more efficient way of
> building the kernel with rootfs with sufficent userspace tools? Like, am
> I supposed to use Buildroot, Yocto?

Hello Arin=C3=A7,

You can backport those patches to mostly any device already using
rtl8365mb. The code it changes is mostly the same since the files
migrated to the realtek directory. However, you do need to backport
fe7324b932 (which is also easily applicable). I believe only the last
patch will conflict as some new functions were added to the
dsa_switch_ops that is being removed.

Regards,

Luiz
