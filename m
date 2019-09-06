Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8BAABDEF
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 18:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388313AbfIFQop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 12:44:45 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:44196 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725871AbfIFQop (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 12:44:45 -0400
Received: by mail-yb1-f195.google.com with SMTP id y21so2381610ybi.11
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:44:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4KfgqDWgseLxqotkMdCp/x5aRTk3rWI3G/nlTstqzFk=;
        b=cWnZMfZauZmEnEq7pxRfRj44cK/v0thuVmlL+HfBymX2urw1faR+1+926W6wPIxQNe
         zRf8epN8CWUW+6v7g8ivtYKtD8fxKvrZT8OSH4VzqT2gT+7zcM3TGPiToS53b/UxXpID
         En1lNB6aZMXST1+BBM4xFiQiSNi+q0ih3KT08n77LuSsgWO/hkqFh2DP6yFbilQCK2+u
         KQAtd5PUd00DJtH8WendR3xghlO9OLZo0uHJNyril2x1kG+QGuYD/iymMfKF4eZuSWlx
         ouOiEe+BD4IYRese4Br5WSMID4cQsIIQqJEnaO7ZfW/CUtNLLcJKLj4b/m+DpsD5nvr2
         xgIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4KfgqDWgseLxqotkMdCp/x5aRTk3rWI3G/nlTstqzFk=;
        b=CeW0+R81CDmYW7RtXNWL4m4Wl0rf+XcSWqL5fRtChOG2GD5pnBtwOnNw9CiL9S6G7r
         MGRR7FAQAPiNdnyK/bE37Tx55QLnpJQk6SxDKSfHbWbH6hGt684PAzW9TniAxy06CFGJ
         sOxuriviUnBFc0QButvU1Q+UfMolw05qyfYYvJ+2T8VXdLzQrEWMUsS0GSJ6kiSMin2b
         9TmTYdPK3r/pJGa6RyEyCQXUOStVFgUU8tPvlEZ+BzSRdp9DziS/hsUttELY1Kmh6crj
         Ge4abkhe99VNvCjGtIVB5RXPQlWESaeAXP/rXkjuxZUtN8X4aBT8GAKcGkdqqPW9by2z
         9QDA==
X-Gm-Message-State: APjAAAVloTjhU2AjnE60GSeVdS5m+7zUtNdzWBHPyQRC4azvvvLwbq2F
        vb7Opv8OjX8cRzUg3voyNaVRrOn0
X-Google-Smtp-Source: APXvYqxgokWVwayd1ZrWYKv5lXLYUFEOEtDmMIn1AgxOCvkwWk7/lwwkFkAg42mkKRdH19W8jrHc3w==
X-Received: by 2002:a25:514:: with SMTP id 20mr6960770ybf.319.1567788283329;
        Fri, 06 Sep 2019 09:44:43 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id i132sm1262108ywc.38.2019.09.06.09.44.41
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Sep 2019 09:44:41 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id u32so2378094ybi.12
        for <netdev@vger.kernel.org>; Fri, 06 Sep 2019 09:44:41 -0700 (PDT)
X-Received: by 2002:a25:7396:: with SMTP id o144mr7223804ybc.390.1567788280737;
 Fri, 06 Sep 2019 09:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190905183633.8144-1-shmulik.ladkani@gmail.com>
 <CAF=yD-J9Ax9f7BsGBFAaG=QU6CPVw6sSzBkZJOHRW-m6o49oyw@mail.gmail.com>
 <20190906094744.345d9442@pixies> <CAF=yD-JB6TMQuyaxzLX8=9CZZF+Zk5EmniSkx_F81bVc87XqJw@mail.gmail.com>
 <20190906183707.3eaacd79@pixies> <CAKgT0Ufd40gmaW7eLu3sRHd=4CeY9WNmgRBUzNt5_+0tEKEMvA@mail.gmail.com>
In-Reply-To: <CAKgT0Ufd40gmaW7eLu3sRHd=4CeY9WNmgRBUzNt5_+0tEKEMvA@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 6 Sep 2019 12:44:04 -0400
X-Gmail-Original-Message-ID: <CA+FuTSea6gTEFFsBfwSECQ8CSi3TFqi2mEPvMuaWNdHwQxwcLg@mail.gmail.com>
Message-ID: <CA+FuTSea6gTEFFsBfwSECQ8CSi3TFqi2mEPvMuaWNdHwQxwcLg@mail.gmail.com>
Subject: Re: [PATCH net] net: gso: Fix skb_segment splat when splitting
 gso_size mangled skb having linear-headed frag_list
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Shmulik Ladkani <shmulik@metanetworks.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, eyal@metanetworks.com,
        netdev <netdev@vger.kernel.org>,
        Shmulik Ladkani <shmulik.ladkani@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 6, 2019 at 11:44 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Fri, Sep 6, 2019 at 8:37 AM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
> >
> > On Fri, 6 Sep 2019 10:49:55 -0400
> > Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
> >
> > > But I wonder whether it is a given that head_skb has headlen.
> >
> > This is what I observed for GRO packets that do have headlen frag_list
> > members: the 'head_skb' itself had a headlen too, and its head was
> > built using the original gso_size (similar to the frag_list members).

That makes sense.

I was thinking of, say, a driver that combines napi_gro_frags with a
copy break optimization. But given that gso_size is the same for all
segments expect perhaps the last, all those segments will have taken
the same path.

And if we're wrong we'll find out soon enough and can return to this
topic yet again. skb_segment really puts the fun in function.

> >
> > Maybe Eric can comment better.
> >
> > > Btw, it seems slightly odd to me tot test head_frag before testing
> > > headlen in the v2 patch.
> >
> > Requested by Alexander. I'm fine either way.
>
> Yeah, my thought on that was "do we care about the length if the data
> is stored in a head_frag?". I suppose you could flip the logic and
> make it "do we care about it being a head_frag if there is no data
> there?". The reason I had suggested the head_frag test first was
> because it was a single test bit whereas the length requires reading
> two fields and doing a comparison.
>
> For either ordering it is fine by me. So if we need to feel free to
> swap those two tests for a v3.

Got it. I don't feel strongly either. No need for a v3 for that.

> Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>

Reviewed-by: Willem de Bruijn <willemb@google.com>
