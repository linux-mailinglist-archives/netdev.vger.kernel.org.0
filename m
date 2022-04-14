Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D2425017DC
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 18:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244774AbiDNPvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 11:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352656AbiDNPRk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 11:17:40 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A627F61A35;
        Thu, 14 Apr 2022 08:02:35 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id u15so10544016ejf.11;
        Thu, 14 Apr 2022 08:02:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=NaW3uwRS/6FaXBKfVrvwdBzKWMrtN62MAAhE0D3p16s=;
        b=Ftmn2tslRoFo5kjZZYcZh376SNswuFaAST8TXXySj1EQZyxHD/y2bW4tGghR0A6pfi
         TP6wVNRcGA0ZENqH6SN3h1Jrxlc19ZJa3qeVQs8hu1iLq0WPWehSREUluuICNIDkvPTd
         CQuwy7NS5c3v571sugYalQ3qxjjt/HUKyt0ddL+suHPyPl/N0XIwxBrxJJ5YqBvoJyTI
         WTFH5x5Nc6Q/DbGAY+BLdbSD8oG4QWfU2UigHgSPVDALH+dsEGEmeuNZ9HpFAz0LgU8C
         i1pEdHZb3Jjb5g1b3vJds6l+/dWEow0QWj37myQqXHCgZKBT34dyrqMPz1oUOsq1656l
         d5Dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=NaW3uwRS/6FaXBKfVrvwdBzKWMrtN62MAAhE0D3p16s=;
        b=RlZYhJDYkKvgPOsNLVRKzKDGzjvriXKINLF9g6/eRfpOO1di35xIO38TR1Di8H7cCk
         Jaa9HxWTssVtRW7aq7lGc+XogTYHekvYv6YCrI8lDtTLnWyIJzotEJydIZf/s5GqUBYH
         f3s0q07SZIerYQWLtCQtnnMP17m+jc8zYJEyR6BO6YMPQdVn7qGpUwXF/CYWoDTH77hv
         lfjf0a1o+GTa92rsE7E6y07+RraKCwKgVQqWtzr5QNRd6V98AUTyrXanW1j8rMjCKEcl
         c3hgLIz09eMLx4e5FB9WFJzUj1zHkuBsxxv/0dPJx3rmt54gVXY6piDAxtHBmdiAr4GX
         eI7g==
X-Gm-Message-State: AOAM533W95JoXOVLTc9txkL8WDYlE2oQuGkYtvTw8e8/Tv+rbOOCaD/c
        xS7rxKcXrYJRt1xU/sgd75YSKJ2oNOsriOnN3S4=
X-Google-Smtp-Source: ABdhPJxsfCiDGHoztilISww5idTIll6LpIs4Gm/tQhfvSoxH+J/SSbqV2+n5Tfdxyh4VfsvxmoLehq2tfeBEWE0xEU8=
X-Received: by 2002:a17:907:8a14:b0:6e8:9691:62f7 with SMTP id
 sc20-20020a1709078a1400b006e8969162f7mr2720540ejc.497.1649948554022; Thu, 14
 Apr 2022 08:02:34 -0700 (PDT)
MIME-Version: 1.0
References: <20220409120901.267526-1-dzm91@hust.edu.cn> <YlQbqnYP/jcYinvz@hovoldconsulting.com>
In-Reply-To: <YlQbqnYP/jcYinvz@hovoldconsulting.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Thu, 14 Apr 2022 18:01:57 +0300
Message-ID: <CAHp75VeTqmdLhavZ+VbBYSFMDHr0FG4iKFGdbzE-wo5MCNikAA@mail.gmail.com>
Subject: Re: [PATCH] driver: usb: nullify dangling pointer in cdc_ncm_free
To:     Johan Hovold <johan@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Oliver Neukum <oliver@neukum.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>,
        syzbot+eabbf2aaa999cc507108@syzkaller.appspotmail.com,
        USB <linux-usb@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
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

On Mon, Apr 11, 2022 at 9:33 PM Johan Hovold <johan@kernel.org> wrote:
> On Sat, Apr 09, 2022 at 08:09:00PM +0800, Dongliang Mu wrote:
> > From: Dongliang Mu <mudongliangabcd@gmail.com>
> >
> > cdc_ncm_bind calls cdc_ncm_bind_common and sets dev->data[0]
> > with ctx. However, in the unbind function - cdc_ncm_unbind,
> > it calls cdc_ncm_free and frees ctx, leaving dev->data[0] as
> > a dangling pointer. The following ioctl operation will trigger
> > the UAF in the function cdc_ncm_set_dgram_size.
> >
> > Fix this by setting dev->data[0] as zero.
>
> This sounds like a poor band-aid. Please explain how this prevent the
> ioctl() from racing with unbind().

Good question. Isn't it the commit 2c9d6c2b871d ("usbnet: run unbind()
before unregister_netdev()") which changed the ordering of the
interface shutdown and basically makes this race happen? I don't see
how we can guarantee that IOCTL won't be called until we quiescence
the network device =E2=80=94 my understanding that on device surprise remov=
al
we have to first shutdown what it created and then unbind the device.
If I understand the original issue correctly then the problem is in
usbnet->unbind and it should actually be split to two hooks, otherwise
it seems every possible IOCTL callback must have some kind of
reference counting and keep an eye on the surprise removal.

Johan, can you correct me if my understanding is wrong?

--=20
With Best Regards,
Andy Shevchenko
