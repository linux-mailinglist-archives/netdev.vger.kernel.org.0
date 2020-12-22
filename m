Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D83CE2E0BF5
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 15:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727657AbgLVOos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 09:44:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727448AbgLVOor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 09:44:47 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD59C0613D3
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:44:07 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id j16so13174187edr.0
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 06:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ccKih3qpozSFUW9gZuk9/wRr2X01uG5gam26BuXGogo=;
        b=q7sJzvB1wUOxXjIJHwo5OItGwECVzJQShaw5Aaug+JYTydzSbiaRFxLBW7b1up5k0d
         oFlNqTHHuxDgz/qhaH0bTC9/L0PXGqCMhY/pxbN/BLFl0mGdjJLNjfaryscntzh6Hray
         lsyB9x6FkEiSN702MkTQESijBv8Ta2ppiX3zIiKyg0c/m70NBTPeAaxskQviP45waaAS
         Ax2sXL4Ko/vPpEaXRAekrvAfWv8v4zbcy8+k8i/sBxpx9vHejg2136y7z5wrdRSZxSdT
         AfZsJZqGFcwbnHVY1oMtlOdLtM/vs9hMvz0MawHcG7hM86/SGwAxV0mOYhoX2OUtmx00
         3hcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ccKih3qpozSFUW9gZuk9/wRr2X01uG5gam26BuXGogo=;
        b=Mh/F6QBggGGINjQdeSqppM2I5ZFR74d7PKcLR+Mb9TwbnAJVapC9KxtLq4xFEZQde1
         ElFe5E/Kbj28i5MLCKT8drDWdkN/CotDQKhkmCCzx8+0UQ8/FYIZHLVLZpZuJL0kasnX
         hDIVtUZD1PjDTNJf0nqCx0ZZXIfyJ0oLlmuZTME93jEKlZyetDcMWPtZkFfwPkG67sXT
         BqIMchTYiL0p4j8xZ8JE3NfptGulSZW22ZFFN+Xs6Jb/tJp3FDzoK3L/BHYqjIveynoT
         AYjI11tNPApr23boTKLZbjdXyQak1CETQQuNq7bnTL4gxMJblGlBJdvTPR8mp5+QXfsj
         ahhg==
X-Gm-Message-State: AOAM533r1eVpC8jhykH0gnq8knW+FgziFBKymM8c4/xmHFJiGcUUItJb
        leAiuGhN/8ANL5VFjzwXmGxlEAKDat1u06g43I0=
X-Google-Smtp-Source: ABdhPJxreDQKnN2O5C5mJ5S+lPIjDlj2rDw9skS+xENC/OOOHgsKk9Qf692F6CE/ifYfNCvc75+V+HP4AL+zfdyeWfY=
X-Received: by 2002:a50:9f4a:: with SMTP id b68mr20441975edf.296.1608648246141;
 Tue, 22 Dec 2020 06:44:06 -0800 (PST)
MIME-Version: 1.0
References: <20201222000926.1054993-1-jonathan.lemon@gmail.com> <20201222000926.1054993-4-jonathan.lemon@gmail.com>
In-Reply-To: <20201222000926.1054993-4-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 22 Dec 2020 09:43:30 -0500
Message-ID: <CAF=yD-JSeLBABCj2i6QnMTN72HCeUcZwH564aKrc=xX=7C0y8w@mail.gmail.com>
Subject: Re: [PATCH 03/12 v2 RFC] skbuff: simplify sock_zerocopy_put
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 21, 2020 at 7:09 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> All 'struct ubuf_info' users should have a callback defined.
> Remove the dead code path to consume_skb(), which makes
> unwarranted assumptions about how the structure was allocated.
>
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Please link to the commit I shared that made the consume_skb path
obsolete. Before that this would have been unsafe.

should have a callback defined -> have a callback defined as of commit
0a4a060bb204 ("sock: fix
zerocopy_success regression with msg_zerocopy").

With that explanation why this is correct

Acked-by: Willem de Bruijn <willemb@google.com>
