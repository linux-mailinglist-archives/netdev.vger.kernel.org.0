Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08CB46FE9D
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 11:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240013AbhLJKXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 05:23:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbhLJKXE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 05:23:04 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F4DC061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 02:19:29 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id y68so20266826ybe.1
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 02:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=k1kXipCH6bNKMJnW/zKudx/gO2zgGSzr72zH8fzfZIM=;
        b=rQkjJoSfVOzcoltVZapK0InyiIizBmX8KoG+sdTNHeE6nHG5pNfly+tMOg7NIJCZa/
         sTuh/zmOIzs0mdVwnRTd+OmQCBg1a+9eMNJ3LbOaQNVNkh0fNwZvNrOL6IrngjK2Pdq7
         I06/J8gvRBxGhKQ1cX4GJc0t5Ck+sF0LThspKg7cg5RHYDL8FnrNe67YMMMwHybabRid
         udep+7OjU9JV/8hw4IT485zJlIsRAZtx6CmQIGh+hLNZnK7yXayql9lpXL0JjffEaz6K
         zx6+GqgxpmbR3aPfZBiKHQrzdAnzqpwAXEfbT8RbEhbw1tJfFWzsbFJuGVO/vMyS1z5/
         V3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=k1kXipCH6bNKMJnW/zKudx/gO2zgGSzr72zH8fzfZIM=;
        b=cTbjUzDrILLYLTQ8fblHt/RbL1gEOadvzmFZlWde/+KlXsyZpWWUCwWrlLSGoOpzE6
         bcipLWg3P84jeEKkfOyfsms9ugqb3l8myPgCZ8TSUIW3/i0gWA/X9zZCJP8E2Ejt8okJ
         1kTfssBvhSXhHfmPMXRdSKd/IrAjumxLFnnasT6SpPBYVzMGnxx5trTaNlEdBZ7D7+vc
         CISPETo/VTvg5Q3vlaq7SxKufQg1IWH/13NMDqdJXdVIITCFWo55VabQr+IpI4dxMzKr
         us2xGSNro/k1o1X79u93SlPTS6JRF5zaB3T9mAG8iln+0CKQ5Ngw7BT01pFYZprfQYLT
         OfFw==
X-Gm-Message-State: AOAM533ONM1BodyG/+F3uRd2lj4PIsMnS/LiIXVcY8OhaU9/hb2Kz49E
        JjJ61ByF+kgQVjmXALylyWkKPRHDRceRApxzUgH15Q==
X-Google-Smtp-Source: ABdhPJxR1B2Z0efmUeCjHwa5GWgWzR9akRl9YRb5J+1IzT/A9xnvM7r5MGuDif1S+b+qgNlKYgH7Bn4Uscgmgz1Fq8w=
X-Received: by 2002:a25:6c6:: with SMTP id 189mr13790122ybg.753.1639131568775;
 Fri, 10 Dec 2021 02:19:28 -0800 (PST)
MIME-Version: 1.0
References: <20211207020102.3690724-1-kafai@fb.com> <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net> <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
 <CANn89iLXjnDZunHx04UUGQFLxWhq52HhdhcPiKiJW4mkLaLbOA@mail.gmail.com> <20211208204816.tvwckytomjuei2fz@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211208204816.tvwckytomjuei2fz@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 10 Dec 2021 02:19:17 -0800
Message-ID: <CANn89i+dxFqE+6x=7xhwADDHX78_CG-0no7UgMjxbM9E5MnAyA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 12:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Wed, Dec 08, 2021 at 10:27:51AM -0800, Eric Dumazet wrote:
> > On Wed, Dec 8, 2021 at 12:30 AM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > > For non bpf ingress, hmmm.... yeah, not sure if it is indeed an issue :/
> > > may be save the tx tstamp first and then temporarily restamp with __net_timestamp()
> >
> > Martin, have you looked at time namespaces (CLONE_NEWTIME) ?
> >
> > Perhaps we need to have more than one bit to describe time bases.
> My noob understanding is it only affects the time returning
> to the user in the syscall.  Could you explain how that
> may affect the time in skb->tstamp?

I would think it should affect timestamps (rx/tx network ones),
otherwise user applications would be broken ?
