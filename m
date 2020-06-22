Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C322031F8
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgFVIVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 04:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbgFVIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 04:21:17 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49921C061794
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 01:21:17 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id f18so2247972wml.3
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 01:21:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iZo9Ovfo6C5AeVU/Qj6BDJUEHA/6vbU+Xe+teK0wySk=;
        b=lkVGFeo+LuWmT+IE3wDbp5wtzzpzE19Ise1MEm/ijnV9/PTbnT/n6IrAU0bu8qjx1w
         lt9PD99aaAAsMtcOs8ovM+jMGtFgRR5oT25Bvj2itiF4uPp3gmSzPzx0UxQj5W/cer9C
         37+RGwGbiSE53Kj9/pWpit1Eri0wCddOlVIo7qZ+VEZ57HlFE+VTz6aLyMnIhBvN+wSI
         +HwE/eqMQCa+plHKCb4j+3kM0IQ3t1EFcKuP9BayIgQXxKgwOU38nysnBginIHPfTcF1
         PztwV9MpNYRE1lo2fTgFZLBBvpFNLcsXzI8DDtxBs459AaDl66JhVsT+HiNoN9yiLJKW
         tveA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iZo9Ovfo6C5AeVU/Qj6BDJUEHA/6vbU+Xe+teK0wySk=;
        b=ZDTWLtKqKEuX0sIO811U8QlfuNnZf2IkvEWXTbtTMs95Q1gxO1GNSnZ/dJBMv+8NOQ
         CAFkajoYeO+2t6oEtJYQq90lVTGAz66nNpnjqtN1Ap0tk01zirujEhKHFublda90DZgn
         7AumWS2BKana+0dsDP/LNTHBL5BIm7CjFJwQuolklfPuemOnXarNTuuCD5lFIHpUV85j
         M8DGmBd5y97pdZWLWPbxex6SuFcL8lxXVl6iRbfvkqj2iN7afPCuHYrFGbI+vEtH0M8R
         D/C+cm4Bq3iW2tA5jdjuLeV/vYbz0w+4Tt41w4KrSmGULXDOR+II9R314cFMKbrO0RFT
         WvVw==
X-Gm-Message-State: AOAM530BPqeSxMswKDYMaYn6pjONzeSsm6Tx0/SkRQPexcSAYL7DyhuI
        JPiwpUPJ9zwT6FlFyK9TAqXco4NiqKqgKjZf99Y=
X-Google-Smtp-Source: ABdhPJwhBhEwwhOlTSMvwD3FeDkdycz/q42fytEi5teFkRHQARKdAYNFtTRx2VFGqHXEL0OXlkxZYgyLNmRjrPDlN5c=
X-Received: by 2002:a1c:cc03:: with SMTP id h3mr17050016wmb.87.1592814076103;
 Mon, 22 Jun 2020 01:21:16 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592328814.git.lucien.xin@gmail.com> <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
 <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
 <20200617091957.1ba687e1@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200617091957.1ba687e1@kicinski-fedora-PC1C0HJN>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Mon, 22 Jun 2020 16:30:07 +0800
Message-ID: <CADvbK_fP2ezY3e-+DGBqxhKaMQn3E-kNgAGDZc5qaGPKx_yjjQ@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 03/10] tunnel6: add tunnel6_input_afinfo for
 ipip and ipv6 tunnels
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 12:19 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 17 Jun 2020 01:36:28 +0800 Xin Long wrote:
> > This patch is to register a callback function tunnel6_rcv_cb with
> > is_ipip set in a xfrm_input_afinfo object for tunnel6 and tunnel46.
> >
> > It will be called by xfrm_rcv_cb() from xfrm_input() when family
> > is AF_INET6 and proto is IPPROTO_IPIP or IPPROTO_IPV6.
> >
> > Signed-off-by: Xin Long <lucien.xin@gmail.com>
>
> net/ipv6/tunnel6.c:163:14: warning: incorrect type in assignment (different address spaces)
> net/ipv6/tunnel6.c:163:14:    expected struct xfrm6_tunnel *head
> net/ipv6/tunnel6.c:163:14:    got struct xfrm6_tunnel [noderef] <asn:4> *
> net/ipv6/tunnel6.c:165:9: error: incompatible types in comparison expression (different address spaces):
> net/ipv6/tunnel6.c:165:9:    struct xfrm6_tunnel [noderef] <asn:4> *
> net/ipv6/tunnel6.c:165:9:    struct xfrm6_tunnel *
will change to:

 static int tunnel6_rcv_cb(struct sk_buff *skb, u8 proto, int err)
 {
-       struct xfrm6_tunnel *head, *handler;
+       struct xfrm6_tunnel __rcu *head;
+       struct xfrm6_tunnel *handler;
        int ret;
