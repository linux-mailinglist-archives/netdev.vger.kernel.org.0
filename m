Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACD7230361
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 08:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727062AbgG1G7j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 02:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbgG1G7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 02:59:39 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F65C061794;
        Mon, 27 Jul 2020 23:59:39 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id y206so118034pfb.10;
        Mon, 27 Jul 2020 23:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j8ZnOfNbyvBr0XEMDZWI56PsvQaHIfE1fSeq4rdZwUg=;
        b=XvYlkBGbkIpwwP9YCIrSkPZMFfE79qRMVDhq+0C0e2o6IOPNjAlVA47TPCWELitlUl
         pkfXruU9G/B7GxeriFXOvvVzRS+d/TqJ8BRkmjzCkSmVC5Ht6s+mj7NMWxNcWOrzbPcm
         8Yk0KnRZ/bahHCUHMeMezl3DWkEug+5V4cQqsm+1O0cq4euBSippCEb58r8HSj0c6mJk
         xIgthEPkH5l5xUXx+Dn/Gfh6c3rQRxA5N6vp6mMMqZ5Wa05gm3xV0nU31UZrGcqjZ0ur
         +tW2cRzABPU2I5WHtD4Dr+pHAerLpX7/yAY3lEwTAgIRN0BzYTxO7eG4TnZAvcJxZXNk
         LRMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j8ZnOfNbyvBr0XEMDZWI56PsvQaHIfE1fSeq4rdZwUg=;
        b=XP9RKCZdXa7AdLeCFn8spcB+4kDiX49yMmyzqz1LAyeUxY7FdFHUyenwhABjwbFQXO
         LWWfRIVtimxGhSTPDzf/DJv9Cq+80vENkTtd3gB6AnwTpWasogKT92LJArkg0q2TYWBR
         LPQOmouppEmDUSAYxPKj7B5wDqJocF0IVEiAvUJRWlqpkzCpiWqec2wj3R0Yyr6VcPUE
         YcoCGoGZf7h8tHem79p1sNRJvBCu+BGIDFigBt1SYt/2jGsjN6jt5oWW0IUzbrDK2fDv
         tx30hWmffUL7kWd0fy0g64PhO3EgC6KOF5hQZvzzxy5cMkmj0AzKdEfKFmMmT21G7Xvf
         SWEw==
X-Gm-Message-State: AOAM531LuN6UkGdjggeq0qxU2jU+uFFtoZJSkL1uzr5ffIB24SPdzVQy
        a8LaBl9qmJqbMr3s0CeW+wIDgJYGByp0CARMev2Zv87n
X-Google-Smtp-Source: ABdhPJymEJo2G6QXkg8vVV0vatyIM1rgCLgxZiJFdAbZjOaNr0gQxmS+i729Tg6Z8GH4byZI+0iSzIr6Am8EipXCpKE=
X-Received: by 2002:a05:6a00:789:: with SMTP id g9mr1765866pfu.65.1595919579011;
 Mon, 27 Jul 2020 23:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200726110524.151957-1-xie.he.0141@gmail.com>
 <CAJht_EOAGFkVXsrJefWNMDn_D5HhH+ODkqE03BULyzb_Ma8A5A@mail.gmail.com> <CAM_iQpV8GDu2U_+4LwSy=uHc6_0FvCx_7ZPCOQ15=hccpaOCig@mail.gmail.com>
In-Reply-To: <CAM_iQpV8GDu2U_+4LwSy=uHc6_0FvCx_7ZPCOQ15=hccpaOCig@mail.gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Mon, 27 Jul 2020 23:59:28 -0700
Message-ID: <CAJht_EOFREE7oc_jiA5=OS22D2y0y-6ydh+bvqBx-zJ0HihL3Q@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wan/lapbether: Use needed_headroom instead of hard_header_len
To:     Brian Norris <briannorris@chromium.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Brian Norris,

I'm wishing to change a driver from using "hard_header_len" to using
"needed_headroom" to declare its needed headroom. I submitted a patch
and it is decided it needs to be reviewed. I see you submitted a similar
patch in the past. So I think you might be able to help review my patch.
Can you help review my patch? Thanks!

The patch is at:
http://patchwork.ozlabs.org/project/netdev/patch/20200726110524.151957-1-xie.he.0141@gmail.com/

As you have noted in the commit message of your patch, hard_header_len
has special meaning in AF_PACKET so we need to use needed_headroom
instead when we just need to reserve some header space. I believe the
value of hard_header_len should be the same as the length of the header
created by dev_hard_header.
