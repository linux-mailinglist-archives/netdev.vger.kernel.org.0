Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B013060ED9E
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 03:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233553AbiJ0BwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 21:52:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiJ0BwR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 21:52:17 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59B5412D836
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 18:52:15 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id p184so204579iof.11
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 18:52:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQrE6UcaHXRgs6HzQAQdpTO5b2h+VLZMgJ0fLJwWtDo=;
        b=HYt6+SJx2bj1hJ9D5WLbiQW8acQ8FmGfRj3AeXjFRuso0kFGBreMjchr4Ew7YrcEdu
         MOd7e5e+7liobCMpsO1R/CN0nVSknqHET/+B8S47Kt8qAIXWwsc0LZrFDo8IGYJUB8UT
         NTJbcmltjIQDG9WpRVQ3XnWwhTRris9bTKXJuCCxXxH3ix88TeXuDg2/+0ssUc0Ur9mp
         dkrG2EBciqdorDbbMuMOOKaIex7aehgEwVHhmuc+j9lqyk7Iya5x6QKUiUQR/pISkil/
         GRmqBtu410MaylWYQgdcalNiJzpMalRUezwdTkxLZQ5Ees0gxYbCFOeERO7swWe4bC6/
         Pokw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQrE6UcaHXRgs6HzQAQdpTO5b2h+VLZMgJ0fLJwWtDo=;
        b=N8FNXSS0S4dQc8IbcxRD/CYO6tMKKQpJJ2iknWO3G0J8huyqfWtyhgDpkJDHbXfJuR
         Dt8fU1JRHSY6UGtqM+dtL8rSaG7Ou6g4y1TdPw2Y3/Mrj0ZiaVpElcrXtz1h22E+Z766
         rfqC4ACt4ujnWZ7W1K1kE62Yu6q7EpVEW8bubQGLqRTa7pnUHqNo5AKZVQupCg5v9fUz
         GOSblXZyYEOV5wspyD3CUsh2Cplzj2jHC+awSQ4zLg6/gllyWVNg3SDmYTaJH9UXQo2r
         sCbzm84kOC6b2Y6aSaAhuMLqD+A7Mm4oV4ozK552mxS6CrGQtQDeZdBClyzNGBWj13FR
         Kefg==
X-Gm-Message-State: ACrzQf14s4wqmWCANomBbblFtRNIA2GwvibOVjfJMiTFyjzk0wBiVoFW
        s6bawPPbxffckB7FQ2CefTLf+ntBYKuqs4A6iu1cZPzZT/7b3GLOPBA=
X-Google-Smtp-Source: AMsMyM6JOtHc+nhJ83eM+EE7TPxQojZha/SsCR7bgrb5Cs81URhSPFU+FgG6OzchHFS2b0Cj5+nQWOWhFGkJRDAzfAA=
X-Received: by 2002:a05:6638:16d1:b0:363:d762:d278 with SMTP id
 g17-20020a05663816d100b00363d762d278mr29778438jat.211.1666835534601; Wed, 26
 Oct 2022 18:52:14 -0700 (PDT)
MIME-Version: 1.0
References: <20221026083203.2214468-1-zenczykowski@gmail.com>
 <CAHo-Ooy5JB-0R5ZNMmEXaPfGjWKBw8VdXVp0d-XW2CNeO6u34A@mail.gmail.com> <20221026182426.2173105d@kernel.org>
In-Reply-To: <20221026182426.2173105d@kernel.org>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Thu, 27 Oct 2022 10:52:03 +0900
Message-ID: <CANP3RGdWDSmvBDsSEWXf+9u_8KQRBzr8NcQCjHB_DPMa83B6PQ@mail.gmail.com>
Subject: Re: [PATCH] xfrm: fix inbound ipv4/udp/esp packets to UDPv6 dualstack sockets
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Linux Network Development Mailing List <netdev@vger.kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-9.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 27, 2022 at 10:24 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 26 Oct 2022 17:42:37 +0900 Maciej =C5=BBenczykowski wrote:
> > I'll admit that so far I've only tested that the code builds.
>
> For _a_ definition of builds ;)
>
> ERROR: modpost: "xfrm4_udp_encap_rcv" [net/ipv6/ipv6.ko] undefined!

Oh, it does build - it even boots.

egrep 'XFRM|ESP' .config | egrep -v 'is not set'

CONFIG_NAMESPACES=3Dy
CONFIG_X86_ESPFIX64=3Dy
CONFIG_XFRM=3Dy
CONFIG_XFRM_ALGO=3Dy
CONFIG_XFRM_ESP=3Dy
CONFIG_INET6_ESP=3Dy

Looking at the Kconfigs/Makefiles, perhaps you have ipv6 as a module?
Why would you do that ;-)
I don't think my development systems even support booting with ipv6
modularized...
