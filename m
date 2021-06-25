Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FCCD3B48EA
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbhFYSqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhFYSqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 14:46:48 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EBFC061574
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:44:27 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id s15so14658877edt.13
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BXsss1G9KDRHd5vDIGHmD+1GwtkPgSlwLuaVF/dvD0w=;
        b=mZGy/Jw+nrJfy2G1w0cWQpus4ZueoOBwSg5zvTvpkgULB77HuwM5QGmf5pFjmZSGUn
         1ilS95HroOjlNK2ICCQTy7vow3Z3ovtOJVZ0WaiZs65igoCHG6DLYNGDceCqVhGQ92Rf
         vs11p07yka0EZsymHRjA8XEiTjwR1l9aTEOAjbHvPl6HX3zXDlEeHN2nCmvKdU+WczNh
         6JzPI4UegNOHOsM70sCI8JZGOk3nOXkMp0yzu1D8K8KuwYFPP+5KenfL6njDOGfbQ/ZF
         CtzI/nGd1etWOoTifgj16GBJzvZxFFBcKXBJqWLX3g0gDurt9jfGqM4m0Vt+dUjkGnXL
         Olng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BXsss1G9KDRHd5vDIGHmD+1GwtkPgSlwLuaVF/dvD0w=;
        b=ikjRssR+hNrEO7LA+QmpZlD8HBIO/00JwKWokut/aUCjoCIu3+foq2YLJFAaQ4VSBV
         xRaQlqRRvOonQ+sXvIUWvSIw2odB9THyLhgIdcdZE0ZVVoxnyG6xIFrQKuWYojv9dJi9
         fQ7vPFzAtLM9OCNQj59OR4m8XagZ532GvT4JpLU2u87qUGbt4WWu4b5F2fyr7s/2h5K3
         tK1RCUHB/M0qpBdlz3xKg9EDxxeptwUfmUhnZ30HgYaZkG7UP2G5RbCLRyU4uYOjejwy
         XIiixuGLmTkVNouJKsnJPhSspBRAzVE0G3jzYwDS0o0wDp4p+ftcLO+u6YbO/CD7tq5/
         +psQ==
X-Gm-Message-State: AOAM532AphIBbs99lASytc88JL/FGVffkPl5tAeGzEM2BoQxuqmFTq8R
        HDeQNqvpj9F2ysKFBWoedFYltFJUPsJHnQ==
X-Google-Smtp-Source: ABdhPJz2pV5rC3JHUvuEOBDydrCSA4/xiP9it80nZSGf97ocTHxwSAmic5LK3K+UnKz1kSH+7mixmw==
X-Received: by 2002:a50:fb14:: with SMTP id d20mr16703813edq.187.1624646666323;
        Fri, 25 Jun 2021 11:44:26 -0700 (PDT)
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com. [209.85.221.42])
        by smtp.gmail.com with ESMTPSA id e3sm3236955ejy.78.2021.06.25.11.44.25
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Jun 2021 11:44:25 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id j2so11602734wrs.12
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 11:44:25 -0700 (PDT)
X-Received: by 2002:adf:e502:: with SMTP id j2mr12305713wrm.275.1624646664642;
 Fri, 25 Jun 2021 11:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <03ee62602dd7b7101f78e0802249a6e2e4c10b7f.camel@infradead.org>
 <20210624123005.1301761-1-dwmw2@infradead.org> <20210624123005.1301761-4-dwmw2@infradead.org>
In-Reply-To: <20210624123005.1301761-4-dwmw2@infradead.org>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 25 Jun 2021 14:43:47 -0400
X-Gmail-Original-Message-ID: <CA+FuTSc-8uO2wUNZH_HhcJ-+SrncyCvJ2NaASCzixpoZQ6cfpQ@mail.gmail.com>
Message-ID: <CA+FuTSc-8uO2wUNZH_HhcJ-+SrncyCvJ2NaASCzixpoZQ6cfpQ@mail.gmail.com>
Subject: Re: [PATCH v3 4/5] net: tun: fix tun_xdp_one() for IFF_TUN mode
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     netdev@vger.kernel.org, Jason Wang <jasowang@redhat.com>,
        =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 8:30 AM David Woodhouse <dwmw2@infradead.org> wrote:
>
> From: David Woodhouse <dwmw@amazon.co.uk>
>
> In tun_get_user(), skb->protocol is either taken from the tun_pi header
> or inferred from the first byte of the packet in IFF_TUN mode, while
> eth_type_trans() is called only in the IFF_TAP mode where the payload
> is expected to be an Ethernet frame.
>
> The equivalent code path in tun_xdp_one() was unconditionally using
> eth_type_trans(), which is the wrong thing to do in IFF_TUN mode and
> corrupts packets.
>
> Pull the logic out to a separate tun_skb_set_protocol() function, and
> call it from both tun_get_user() and tun_xdp_one().

I think this should be two patches. The support for parsing pi is an
independent fix.

> XX: It is not entirely clear to me why it's OK to call eth_type_trans()
> in some cases without first checking that enough of the Ethernet header
> is linearly present by calling pskb_may_pull(). Such a check was never
> present in the tun_xdp_one() code path, and commit 96aa1b22bd6bb ("tun:
> correct header offsets in napi frags mode") deliberately added it *only*
> for the IFF_NAPI_FRAGS mode.

IFF_NAPI_FRAGS exercises napi_gro_frags, which uses the frag0
optimization where all data is in frags. The other receive paths do
not.

For the other cases, linear is guaranteed to include the link layer
header. __tun_build_skb, for instance, just allocates one big
skb->data. It is admittedly not trivial to prove this point
exhaustively for all paths.

commit 96aa1b22bd6bb restricted the new test to the frags case, to
limit the potential blast radius of a bug fix to only the code path
affected by the bug.

> I would like to see specific explanations of *why* it's ever valid and
> necessary (is it so much faster?) to skip the pskb_may_pull()

It was just not needed and that did not complicate anything until this
patch. It's fine to unconditionally check if that simplifies this
change.
