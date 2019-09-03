Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60F2FA719E
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 19:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729921AbfICRZY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 13:25:24 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:37754 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbfICRZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 13:25:24 -0400
Received: by mail-yw1-f67.google.com with SMTP id u141so6081588ywe.4
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 10:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e36E2j0U86/ncYIwgoAp63b76wxN4ppVlGDgKcPnY6c=;
        b=dsdkVf4dC/PZnstDzqOgYZeyRjIBS6I+z2N6RJN2H90B2+PfdhYT+hKsk1O/jb/pMC
         9gat57kZq3vIoYfhiNdLHrcYLp6ESw3RFVZnPY5btvQ4hGDEKcWTFQrvwfEnP2SEuJik
         bp58BnBaVzHW6r0NyrEDXZplmmhnifkgoXxJQ9SJ1Q5N4kXNiV17LYaKfq/AylwhQrs2
         9JZyvCK4ZKzdHLIxlGARTIzQNBJ/ZcO5gEaF60C2ZTYsLBHOuQ/kfasBXOuBxlljJcyS
         cgIoCeodNUWgWq6bs3X/ucsR4lJJMQ+krA3GfpCU9uHTVXh3rYVJcbF4lDOvziC4dHPz
         sjJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e36E2j0U86/ncYIwgoAp63b76wxN4ppVlGDgKcPnY6c=;
        b=Husd4N/lJzWBHHSzvS/N2POf7zTPBc69ecxj+sleA1uLJtpRKrmIeulZKP7J4NnnQZ
         HPHJOLF42h/9oH5dzvu+OyTa0aGOesp3ZnmEKRCblGzSoaPRkVZH3+egN3oPrO/UIKXv
         w4T5LRqvLg8E7q0/MjHYjGe70F6+0EXSpcE0lNSlZMx7Z7xBD3xuncbpf05lIXD9wOtj
         dyVsQ3H0XLVXWlutC6WptsYyyoTqXJEMXZ6PClKNsywpxaIqK0O8JscsCK/kSP+XZJ7Z
         bam2zNs647pCZ9MxhhdNkqVxhJIqhEXqkfoFve/2KsRLRygsFkz9wpI3c7i/p7qaAXcS
         tr2g==
X-Gm-Message-State: APjAAAU17KzIA7oD6mVMDkEsOcqfNyiHV/a/M6lqEwowEftnVZaC3T19
        aOM+4OrsGB5IDf0D7ByVTuS6LJne
X-Google-Smtp-Source: APXvYqxUcfDLcDujaGYjBIHjYpOAszs50egxJvsLPN0fIzconAvk+8Ug9la95AxUf1O3PW58czMQ0g==
X-Received: by 2002:a81:7743:: with SMTP id s64mr2074163ywc.183.1567531522524;
        Tue, 03 Sep 2019 10:25:22 -0700 (PDT)
Received: from mail-yb1-f177.google.com (mail-yb1-f177.google.com. [209.85.219.177])
        by smtp.gmail.com with ESMTPSA id b66sm3711149ywd.110.2019.09.03.10.25.20
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Sep 2019 10:25:21 -0700 (PDT)
Received: by mail-yb1-f177.google.com with SMTP id c9so6142362ybf.2
        for <netdev@vger.kernel.org>; Tue, 03 Sep 2019 10:25:20 -0700 (PDT)
X-Received: by 2002:a25:7396:: with SMTP id o144mr25610482ybc.390.1567531519961;
 Tue, 03 Sep 2019 10:25:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190826170724.25ff616f@pixies> <94cd6f4d-09d4-11c0-64f4-bdc544bb3dcb@gmail.com>
 <20190827144218.5b098eac@pixies> <88a3da53-fecc-0d8c-56dc-a4c3b0e11dfd@iogearbox.net>
 <20190829152241.73734206@pixies> <CA+FuTSfVsgNDi7c=GUU8nMg2hWxF2SjCNLXetHeVPdnxAW5K-w@mail.gmail.com>
 <20190903185121.56906d31@pixies> <CA+FuTScE=pyopY=3f5E4JGx1zyGqT+XS+8ss13UN4if4TZ2NbA@mail.gmail.com>
 <20190903200312.7e0ec75e@pixies>
In-Reply-To: <20190903200312.7e0ec75e@pixies>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 3 Sep 2019 13:24:43 -0400
X-Gmail-Original-Message-ID: <CA+FuTScFchWJL5f9DcsK28YKFSBOG4rUc8-7k4TnboN199zXJA@mail.gmail.com>
Message-ID: <CA+FuTScFchWJL5f9DcsK28YKFSBOG4rUc8-7k4TnboN199zXJA@mail.gmail.com>
Subject: Re: BUG_ON in skb_segment, after bpf_skb_change_proto was applied
To:     Shmulik Ladkani <shmulik@metanetworks.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        eyal@metanetworks.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 3, 2019 at 1:03 PM Shmulik Ladkani <shmulik@metanetworks.com> wrote:
>
> On Tue, 3 Sep 2019 12:23:54 -0400
> Willem de Bruijn <willemdebruijn.kernel@gmail.com> wrote:
>
> > This is a lot more code change. Especially for stable fixes that need
> > to be backported, a smaller patch is preferable.
>
> Indeed. Thanks for the feedback.
>
> > My suggestion only tested the first frag_skb length. If a list can be
> > created where the first frag_skb is head_frag but a later one is not,
> > it will fail short. I kind of doubt that.
> >
> > By default skb_gro_receive builds GSO skbs that can be segmented
> > along the original gso_size boundaries. We have so far only observed
> > this issue when messing with gso_size.
>
> The rationale was based on inputs specified in 43170c4e0ba7, where a GRO
> skb has a fraglist with different amounts of payloads.
>
> > We can easily refine the test to fall back on to copying only if
> > skb_headlen(list_skb) != mss.
>
> I'm concerned this is too generic; innocent skbs may fall victim to our
> skb copy fallback. Probably those mentioned in 43170c4e0ba7.
>
> > Alternatively, only on SKB_GSO_DODGY is fine, too.
> >
> > I suggest we stick with the two-liner.
>
> OK.
> So lets refine your original codition, testing only the first
> frag_skb, but also ensuring SKB_GSO_DODGY *and* 'skb_headlen(list_skb) != mss'
> (we know existing code DOES work OK for unchanged gso_size, even if frags
> have linear, non head_frag, data).
>
> This hits the known, reproducable case of the mentioned BUG_ON, and is
> tightly scoped to that case.
>
> If that's agreed, I'll submit a proper patch.

Yep, that sounds good to me.
