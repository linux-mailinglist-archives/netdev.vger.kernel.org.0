Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C92F33D446E
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 04:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233755AbhGXCAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 22:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhGXCAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 22:00:30 -0400
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A02CC061575;
        Fri, 23 Jul 2021 19:41:02 -0700 (PDT)
Received: by mail-yb1-xb30.google.com with SMTP id d73so5192790ybc.10;
        Fri, 23 Jul 2021 19:41:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mPr+m1CfRxv5rg4j/EeNrM3iSIMWTPMsVYUKuqMR+HU=;
        b=cI0d2mf5qMDinOEep4KgSEnVcpPtmKLks3vqCz6dSpzSNImpQzgf0mOZP2N8iojaAA
         cff8WPzXx1o/PJbEVqMAOxy84n73N1SHnTTUfn7OdP2uj0W5VOX67s3R7jRsRXjsTGla
         UxPlGhjzBrOjWAb0YhKSl4x9X1//wi7uEIkJ2PBFXL+krui0tUHA2OVxx81QZgVorbQq
         xROoFzdB1ABK8pq42Y37gccrVPpTTpExyUfTeCVPXc+sBI/O/BYk+n499n5DGrt6wDab
         DYZ39ZWocIDzJkXr45YVeoGfbx5jcujdn8vgz3lzz84mF3JcFZqWaroBF0EAFeIkdFL1
         B14Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mPr+m1CfRxv5rg4j/EeNrM3iSIMWTPMsVYUKuqMR+HU=;
        b=TTkTMLSx+HDLlxBdlVdgah7u6W7KOjpyKiAnkstBtQFZkYJKhn6rTTFEkHE6B8MJgW
         Nqk//JBhoWUzbvRY21v66vkS8nPG7uGzJXAjlysBm6lTVLuli4Q1zB2CxltHbRD6W2TG
         SA6t8fv5mj5X/euiqbotWKxCDpMGArA211xeigElMaGA0lXYLVxlCaRy6DQBYsb0zwiB
         x1WHR0cIx+fktfugCPr9Da0EBZ0unueL1HlBAICQoPxuXb0z/0sSOAvHgZ/36Oh13JQm
         CMGg/HElMZMZochfBhb+6xfth3qojKrywr84ABSKk4fKFYDwtfx9ZnaxmtA0yk1HBiW9
         GycQ==
X-Gm-Message-State: AOAM531l8gaxKD6hDxZJ644Y1OljWyP8fY9Xq0xeFonjWYyc/J/xzdnF
        N0zwpPdQcO330BL8QN1RBIKemhXCH3Rru/Zp2pg=
X-Google-Smtp-Source: ABdhPJwhkYy3XFilacLt7eDyAbpDZk8wZ65hLvXfH4PdauqYM29u/yweNreYiaWb+w849JUYbFuTrce/dhZlO/0kO/A=
X-Received: by 2002:a25:ceca:: with SMTP id x193mr10127764ybe.496.1627094461246;
 Fri, 23 Jul 2021 19:41:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210724010117.GA633665@minyard.net>
In-Reply-To: <20210724010117.GA633665@minyard.net>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Sat, 24 Jul 2021 05:40:50 +0300
Message-ID: <CAHsH6Gu12oTqeE_TV6suU8Qoa9tET-XCUDc_x+TkFrZuWMrhJQ@mail.gmail.com>
Subject: Re: IPSec questions and comments
To:     Corey Minyard <minyard@acm.org>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ho Corey,

On Sat, Jul 24, 2021 at 4:02 AM Corey Minyard <minyard@acm.org> wrote:
> 1) In struct xfrm_dst, what is the difference between the route and path
> fields?  From what I can tell, in the first element of a bundle they
> will both point the route the packet will take after it has been
> transformed.  In the other elements of a bundle, route is the same as in
> the first element and path will be NULL.  Is this really the intent?
> Can path just be eliminated?

For non-transport modes - such as tunnel - 'route' and 'path' won't be the
same in the first element (xdst0): 'route' will be the original dst and
'path' will be the route the transformed packet will take. the dst is
overridden in the xfrm_dst_lookup() call within xfrm_bundle_create(), after
xdst->route had been set.

AFAICT, the intent for the 'path' member is described in commit
0f6c480f23f4 ("xfrm: Move dst->path into struct xfrm_dst") - essentially
'path' contains the reference to the underlay route from the topmost bundle
member avoiding a walk through the child chain when needed.

Hope this helps.
Eyal.
