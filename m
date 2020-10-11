Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79B2928A707
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 12:40:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgJKKhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 06:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729624AbgJKKhk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Oct 2020 06:37:40 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFE6C0613CE
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:37:40 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id d6so6858329plo.13
        for <netdev@vger.kernel.org>; Sun, 11 Oct 2020 03:37:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IwIdQxaAvtPvdQ7kv8/2HX6fvW7PYAkceLWLP3z3+j0=;
        b=fyGSM/hsJOE0+XtyetgrP/4oSTaoITF9ynd40QSEjMTurJmPGVfydGEeShfrjnIx46
         bt3uG5ZSkh68debo5dfPfrAp8wvNUD8IsS5GDoeO5XNxTqGfxrR/aqjxV49upHn5pqmo
         6mbu4nm2PJaOkxMfymbia6RnuRZNoU4liSZ+kRwILNQ3DFil3jGHMuRWVgWadtUlG0pm
         UPAXkrs1YKR5H8pdQhL93YcwDIQHoxtG+uvcFRdCidW5Rpd+ksWW0Pd0pZzipCpQWQ81
         VTw6Ps674GUciAn/Nmh+x6wVwiI7+rl4Wh0JXyEVpFqGEA/U4DWJ41sL6EdlEMnRWiA8
         iI9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IwIdQxaAvtPvdQ7kv8/2HX6fvW7PYAkceLWLP3z3+j0=;
        b=LWONn3Cu2E8tkOIle1Er8VAuE2Nixc432BlxydwcxkukzcXPRCrG1r1waT30vk8yQ6
         ST9aw8SFk5oMim7qGzL93dLOvLtn1nTSucs1ciflX3HhvNSdYSA5NdNZXwfo3x341viZ
         nl3cxVz4f4wI0/24S0/QY8bVlq9+ga/bLmacqxK+OPZnPeXLLwV7ZVRshD3BXIGn7+1+
         ZidIyXzXj3sfNxVeUpsS6CgXOqK3stu1LI6ObcPAeeN7QTy4o27vjslgjyynURKCOe6w
         NLbLsSHm8vL9Q+Z6NWVn1Wc1QwCJVFPFaIQ3KXxnh60p00GUITBMPANWqB6ssErGi113
         XXNA==
X-Gm-Message-State: AOAM531+Dnbd4IM4WsDd/jw4qCxtZix+oNWH8v7lyShGViKwg7Seqfvz
        4s1UJsYPzLOphyMgUbERrRSrAVnF6D4DyWWYvgky3w==
X-Google-Smtp-Source: ABdhPJx3URKf9AYK1M9Ikngl4G/r8DiVTS1GIRSdM5JdeFin+So8Y+XY9rUA1QnFioyMCB7L+/WDBgYt7vg2IYTVf0A=
X-Received: by 2002:a17:902:d716:b029:d3:8e2a:1b5d with SMTP id
 w22-20020a170902d716b02900d38e2a1b5dmr18272569ply.85.1602412659693; Sun, 11
 Oct 2020 03:37:39 -0700 (PDT)
MIME-Version: 1.0
References: <20201009170202.103512-1-a.nogikh@gmail.com> <C4BF5679-74E6-4F2E-839B-A95D88699DBF@sipsolutions.net>
In-Reply-To: <C4BF5679-74E6-4F2E-839B-A95D88699DBF@sipsolutions.net>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Sun, 11 Oct 2020 12:37:29 +0200
Message-ID: <CAAeHK+y=YaVwU=vgf4Fph_WMLnKgzKEhyypVmsYbF1LnRPfJsg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] [PATCH v2 0/3] [PATCH v2 0/3] net, mac80211,
 kernel: enable KCOV remote coverage collection for 802.11 frame handling
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Aleksandr Nogikh <a.nogikh@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Dumazet <edumazet@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Aleksandr Nogikh <nogikh@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 9, 2020 at 7:13 PM Johannes Berg <johannes@sipsolutions.net> wr=
ote:
>
>
>
> On 9 October 2020 19:01:59 CEST, Aleksandr Nogikh <a.nogikh@gmail.com> wr=
ote:
>
> >This patch series conflicts with another proposed patch
> >http://lkml.kernel.org/r/223901affc7bd759b2d6995c2dbfbdd0a29bc88a.160224=
8029.git.andreyknvl@google.com
> >One of these patches needs to be rebased once the other one is merged.
>
>
> Maybe that other patch shouldn't do things that way though, and add new A=
PI (which the existing one could call with some kind of "all contexts" argu=
ment) instead, so it's only necessary to specify the context (mask?) where =
its actually needed (the few places in usb or e whatever)?
>
> Surely that would also look less tedious in the mac80211 code, for exampl=
e.
>
> And if you ever fix the nesting issue you'd have fewer places to modify a=
gain.

Hi Johannes,

I initially hesitated to do that, as it would multiply the number of
kcov callbacks. But perhaps you're right and a clean API look
outweighs the rest. I will do this in v3.

Thanks!
