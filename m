Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E292E9C38
	for <lists+netdev@lfdr.de>; Mon,  4 Jan 2021 18:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbhADRky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jan 2021 12:40:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726124AbhADRky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jan 2021 12:40:54 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C644C061793
        for <netdev@vger.kernel.org>; Mon,  4 Jan 2021 09:40:13 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id p22so28179715edu.11
        for <netdev@vger.kernel.org>; Mon, 04 Jan 2021 09:40:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7JVh0nWlPud1dpbmyrFAS7Kc6nqmJCan0rFBsdPb938=;
        b=MvUI1fL65NrjA8bAQBtM5ZwPrTffhovpaMdOJYfwZsdbM/F4E4DnZIc7BmekDeOvQS
         7MX0AWGzyxAWETblpoLIRV+z9CWAEwGHpuzF3i6SrU+DQZOjY+iceV5qD4EzZVzAyf5I
         fLsE4URAcgOX24e2pV7oWqexcpg4yYu5l1rIn63dcMi6kDlz8jdHH8z1LZyjcj3Uf4cm
         1LZBdr1A10cqsGk3/VeXAKMzb2DxT1RtyYAKSU+zz22Ozz7tb24yJvtImaH67AK2c2/r
         yGVmaOxvZmoJ/EDyKZyI+FYIwbhSBH1wyW8XEd3O4a4WYRAH9DKlXTMvSaIiaQfOBsF4
         VANQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7JVh0nWlPud1dpbmyrFAS7Kc6nqmJCan0rFBsdPb938=;
        b=VpK/fgqY12Tn3434AMEIRNYIAklytbOzLMVg9bKrhLkSAdVjDU+85p5aURr43I3NpB
         p5DOGOZZ8UKxO1NG2skv8OvXa8LCEpXc6NOOTkYJievqKz9K7np13hlPUcHFYADblSog
         iffY7ArW7BpnktRUI8j5cLo1uK5sJJiVgt8OqHSuceeYM7NKsjtWlVIuYR4+hgE1GxpP
         HsiGciHnTAfBVUQjBDz6UU2Fqu2MeF1YC7dCzaMcrlK31fKCiygy3h9AyTb82t2y0pVJ
         KIe9WM/3x9324nPecpY9u7EHDbXidl08bNcUcitAZ4qUig0t7CO04D07+NR03iw2VMXM
         VroA==
X-Gm-Message-State: AOAM530/pGXVD8/HoCTSDDBsiApfco2VePIxdhCadYTP2MUn4xuQ0TC3
        k+1q/vR6P0BcDlg7a5fdJ1Ln7pE8c9UBWLlQRmc=
X-Google-Smtp-Source: ABdhPJw9EsqMcgncXYgVr2MgMdf11M25TSj682nzZWoYVzgvrpYPT9P6Kugp0QmmTEZagVFs1wHdvpPWnVGcrjgzWgM=
X-Received: by 2002:a50:ec18:: with SMTP id g24mr70868595edr.6.1609782011172;
 Mon, 04 Jan 2021 09:40:11 -0800 (PST)
MIME-Version: 1.0
References: <20201230191244.610449-1-jonathan.lemon@gmail.com>
In-Reply-To: <20201230191244.610449-1-jonathan.lemon@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 4 Jan 2021 12:39:35 -0500
Message-ID: <CAF=yD-Jb-tkxYPHrnAk3x641RY6tnrGOJB0UkrBWrXmvuRiM9w@mail.gmail.com>
Subject: Re: [RFC PATCH v3 00/12] Generic zcopy_* functions
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 2:12 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> From: Jonathan Lemon <bsd@fb.com>
>
> This is set of cleanup patches for zerocopy which are intended
> to allow a introduction of a different zerocopy implementation.
>
> The top level API will use the skb_zcopy_*() functions, while
> the current TCP specific zerocopy ends up using msg_zerocopy_*()
> calls.
>
> There should be no functional changes from these patches.
>
> v2->v3:
>  Rename zc_flags to 'flags'.  Use SKBFL_xxx naming, similar
>  to the SKBTX_xx naming.  Leave zerocopy_success naming alone.
>  Reorder patches.
>
> v1->v2:
>  Break changes to skb_zcopy_put into 3 patches, in order to
>  make it easier to follow the changes.  Add Willem's suggestion
>  about renaming sock_zerocopy_

Overall, this latest version looks fine to me.

The big question is how this fits in with the broader rx direct
placement feature. But it makes sense to me to checkpoint as is at
this point.

One small comment: skb_zcopy_* is a logical prefix for functions that
act on sk_buffs, Such as skb_zcopy_set, which associates a uarg with
an skb. Less for functions that operate directly on the uarg, and do
not even take an skb as argument: skb_zcopy_get and skb_zcopy_put.
Perhaps net_zcopy_get/net_zcopy_put?
