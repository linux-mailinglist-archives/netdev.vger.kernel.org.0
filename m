Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A55731EDB3
	for <lists+netdev@lfdr.de>; Thu, 18 Feb 2021 18:54:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234768AbhBRRwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Feb 2021 12:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234461AbhBRRhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Feb 2021 12:37:46 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC91C0613D6;
        Thu, 18 Feb 2021 09:37:05 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id 75so1551465pgf.13;
        Thu, 18 Feb 2021 09:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Xmf6pTNe7mQQ+6NHgcE8bVS8WWzHYXysNcfphF1I+24=;
        b=Y/8D/DbfQgqs+GHwMjEuxhzZCU1naE54M6ECflXmCALxpIV0AXdNrz2eQRDpXtFki5
         URJgtKjb+/zCNsyyRv0sKQ0oom1VGKhXLAcENdEsQUj2CslkwXOWuuTg77O8rgBXUsSI
         E4Xchs1spLREWPvvEip4Oi5pDq7yhTMQNsRiN3apzSRM1/4DTDz/tIktS4oZbFyc0P6P
         S2eThA6pR6nCXcCgq2GMoJNSAlJb5h+v7ae7/diE2HF8Zbp2e1E/S3iNJihZ+3tvY30c
         WRSxxvxRC5rdr4NUsysZfIRYrmF+YZfEb+g5w9TUPRZERGZjnj6SCn9FcUl+PG6LWKsv
         AHjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Xmf6pTNe7mQQ+6NHgcE8bVS8WWzHYXysNcfphF1I+24=;
        b=OSMp6MJeHwIzmpHgJECGsySokMsDqPAHE8bnaG6c3GeN9qcT61Gc0sfeGU0oelEHZO
         xiqb8F6TlsIk/ZF5TLoY6XE67qsC+9iCm+SiEHgcEFDvLwjKS/8Hr2FCcdkeXHiRkzhr
         Tg2fpQ4tP/fY4DrsCrGUaMhX/oR+6+8gmY57EA6KFts+GutgNFGkCJYwgnjW0kngQhwC
         KhM+jqqeWKJJKiES9U8YcZQ2Jnz8sPyEdlmlRUE1RchaeWM24xlD4xrZwQHw/nnM+m7a
         IAb/GwPRyuisu+01pNHRYaF6Jllt2MpurDFFVQhInDRKwMzNTMycRNgvYVeUwcmWvPu+
         mA6w==
X-Gm-Message-State: AOAM530mq2/kNzZO7XIimp/LbA6Q2HpFRdiBel98mV0xiuhuWrIbn84F
        wmYMx8IJoqKB77VhsZdBY/5xhkrXJszfFoZ2tIHQiCGr
X-Google-Smtp-Source: ABdhPJy4lZs5G/uRY3utOJ/evT/TjcNbVyBZZnGu2g4ZS/e5JLu4FJZrG5lr3f0fi0KTZHNrPiA6ykLIfp5gBvcV464=
X-Received: by 2002:a05:6a00:7c7:b029:1de:80cd:46b8 with SMTP id
 n7-20020a056a0007c7b02901de80cd46b8mr5427816pfu.63.1613669825077; Thu, 18 Feb
 2021 09:37:05 -0800 (PST)
MIME-Version: 1.0
References: <20210216201813.60394-1-xie.he.0141@gmail.com> <YC4sB9OCl5mm3JAw@unreal>
 <CAJht_EN2ZO8r-dpou5M4kkg3o3J5mHvM7NdjS8nigRCGyih7mg@mail.gmail.com> <YC5DVTHHd6OOs459@unreal>
In-Reply-To: <YC5DVTHHd6OOs459@unreal>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 18 Feb 2021 09:36:54 -0800
Message-ID: <CAJht_EOhu+Wsv91yDS5dEt+YgSmGsBnkz=igeTLibenAgR=Tew@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4] net: hdlc_x25: Queue outgoing LAPB frames
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 18, 2021 at 2:37 AM Leon Romanovsky <leon@kernel.org> wrote:
>
> It is not me who didn't explain, it is you who didn't want to write clear
> comment that describes the headroom size without need of "3 - 1".

Why do I need to write unnecessary comments when "3 - 1" and the
current comment already explains everything?

> So in current situation, you added two things: comment and assignment.
> Both of them aren't serve their goals.

Why?

> Your comment doesn't explain
> enough and needs extra help

Why? My comment already explains everything.

> and your assignment is useless without
> comment.

My assignment is already very clear with my current comment. My
comment explains very clearly what this assignment means.
