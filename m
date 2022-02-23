Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 808E84C0C6A
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237255AbiBWGIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232836AbiBWGIp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:08:45 -0500
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10F85BD30
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:08:18 -0800 (PST)
Received: by mail-oi1-x22c.google.com with SMTP id x193so17191944oix.0
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f0M6D8z96arBsC0LHTo8PBvDSw4jUwBinGn2jNKe3mo=;
        b=HPJNJyeX4unxMsT/mQMLGHGXe7sEtxKbIKj+cGlxHh/EYZwXjzrIo3XhxwDBbD9XWh
         285zIwTzvysNwFWOCtgNjttQRZu1rMbX5Kttf6RbCqLsafpc3IsQRz5CVJtKi9spb3bQ
         9gwsEng/ramOaTo4Ho6F3vAiEQ0ed/rLjDFAXRAVcXBnq9i9VVdsavUvOvyfkav0lLqA
         zpJAYKOQQIDu00m/xABm3k7GjfDInO0twP0MLOIRvfOkhlkqoZXxbQ60QcaTmuQH4TZa
         lMj/MINCuikkrBSodwMvVeqhY86ocHMutXjIVyG/fUWI+2U6sgx1xcGei2gV3JAwKajv
         D3MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f0M6D8z96arBsC0LHTo8PBvDSw4jUwBinGn2jNKe3mo=;
        b=wCwEZh2v5Yf8Fn1fa2SklHoIK5H1L8JTiLMauwGSjTTJzYBQk6iCH8fg7Reqk7fgi+
         AMeBXlLv9QWV3JeqBbpaoWJlhOVzhrqXXYL5TMXp5k4CF5odg50yL3nFZFY6t0X5DNN7
         ZlkMmDHakrUz/LMr9mgEGpmFtb2Cc1UIOMd14umBYhYZmfVTXmaOmyGVqhO8qXvStV71
         LF2iy+wg9YrIg6Pf9cTQ2HZ/2G2k0mbYGOl0h9fpfE5cgb8tCKS9TO/3Y8tFdj+U9j/3
         3sl2h3d3PuAvekIP4aH7OuLQw2C+1nRQS2/GxC5V9WauwfFq1s530L2lrV71r7XqEYuF
         yjmw==
X-Gm-Message-State: AOAM530AmdZrgRM7my4fS6OZjmLNfjeTtc9AHLEHfyma5ZsMo4eQNqdo
        JTz7FG6/LejfEVRuj/kFNIR8gl1dYw5n/pLuKXD1aRwYvKg=
X-Google-Smtp-Source: ABdhPJzWiiyJy/qTPAw+lQgx3rpZ2Plc+gx9JJrXoymx9NaiD8SMbX21ibmvlgUw1hCOE7uOAQi82acwbZkw/z+PrnU=
X-Received: by 2002:aca:5b8a:0:b0:2ce:6ee7:2d0c with SMTP id
 p132-20020aca5b8a000000b002ce6ee72d0cmr3746378oib.314.1645596497991; Tue, 22
 Feb 2022 22:08:17 -0800 (PST)
MIME-Version: 1.0
References: <ea03066bc7256ab86df8d3501f3440819305be57.1644988852.git.lucien.xin@gmail.com>
 <20220217075712.6bf6368c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220217075712.6bf6368c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Wed, 23 Feb 2022 14:08:06 +0800
Message-ID: <CADvbK_fgrvLNUPiTBOddrUcGFep-XkO4wbp01UXPybg0vXPVzA@mail.gmail.com>
Subject: Re: [PATCH net] ping: fix the dif and sdif check in ping_lookup
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     network dev <netdev@vger.kernel.org>, davem <davem@davemloft.net>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 17, 2022 at 11:57 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 16 Feb 2022 00:20:52 -0500 Xin Long wrote:
> >       if (skb->protocol == htons(ETH_P_IP)) {
> > +             dif = inet_iif(skb);
> > +             sdif = inet_sdif(skb);
> >               pr_debug("try to find: num = %d, daddr = %pI4, dif = %d\n",
> >                        (int)ident, &ip_hdr(skb)->daddr, dif);
> >  #if IS_ENABLED(CONFIG_IPV6)
> >       } else if (skb->protocol == htons(ETH_P_IPV6)) {
> > +             dif = inet6_iif(skb);
> > +             sdif = inet6_sdif(skb);
> >               pr_debug("try to find: num = %d, daddr = %pI6c, dif = %d\n",
> >                        (int)ident, &ipv6_hdr(skb)->daddr, dif);
> >  #endif
> > +     } else {
> > +             pr_err("ping: protocol(%x) is not supported\n", ntohs(skb->protocol));
> > +             return NULL;
> >       }
>
> Are you sure this is not reachable from some networking path allowing
> attacker (or local user) to DoS the kernel logs?
Hi, Jakub, sorry for late.

I actually didn't see how a skb with protocol != IP/IPV6 could reach here.
ping_err() is using "BUG()" for this kind of case.
I added this 'else' branch mostly to avoid the possible compiling
warning for "Use of uninitialized value dif/sdif".

Thanks.
