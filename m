Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E9EA3A5E94
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 10:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhFNIvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 04:51:25 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:38586 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232670AbhFNIvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 04:51:21 -0400
Received: by mail-pj1-f53.google.com with SMTP id m13-20020a17090b068db02901656cc93a75so9616506pjz.3;
        Mon, 14 Jun 2021 01:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fJXJGzo/AzgCmmowETTvaQsC6wM1vEXUdgM3CM2feig=;
        b=DR8XsVbIMAQmQZl0SDZT64onM6mKvDo1FjbYxpmabg73JiYivmZ2QtqgKinbKLs/As
         kT5f0WNmUW8J3a99MtlJZXiz6iFc0L9YEXKNtlUrvz3l8Fg3RFrL/3umd4VJSRKYKUgq
         p+QiVcLukjjwIjYf42Gxeav1ASTrwtdOSbzTT6MiVUc9VZTlSSN9sYY47Viiutixk3l2
         kwF+RbgvsUXlfQAAQcTUrDW9kN8/Fr3sxCBqecShSRJ5OVlp9TGCFgCkhQx8pp8QA0GA
         cG4r13wNzQI7SmiM/DcN/vgxmVjbDFOediF8cI5pfF5vD/sk6CgzA/uppfPa+umyvVAY
         X8nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fJXJGzo/AzgCmmowETTvaQsC6wM1vEXUdgM3CM2feig=;
        b=dYuGUkUFH/+NHizS6wJ0oRE8oUEQyeA/+hXWyZqm2UGTPxHSSd0qBCoZxXAe0qpJXK
         eHr2ccKM96eE77dgYF+7swvHPXh+LfnkNBUkZ8x3lGZAXediSklLy+IatLHE7go3S41L
         FoaTszMQE/1FxNOTkk52/KFM+F2DIVatzfb/CIY9Q8lZvbVrTbCeliz1WlDQ0l/nU1HL
         P2M0sSjqdXEXb61EL0QD7XJmhpj5R1Uts7MJL/ojO5feaaEZUe+6GmUKZeplN0j5zhKZ
         RMsPzSujy0wxgy4sodKB+GXFtEzIk+SY7aOFerHiiqjvJhzdsNIPvsMOzy0dAs1TOP+K
         ixoA==
X-Gm-Message-State: AOAM530MeBjkmFJ//dJf3vuusdAjR0uK7ZbZA0yGUZoLKR2Dufzjh/si
        UdkOCuiZE0li8wJFVinuIRlhH8PAMDZ6bt9QeD8=
X-Google-Smtp-Source: ABdhPJz4p3NEuzhCq5k17/OP2UCkWvocwhedF3qakqYiwvONLxK+8fohY6wDcDSsL6mkE3e6zGDkVkNuYEqt5SEoBnU=
X-Received: by 2002:a17:902:dcce:b029:113:ad63:6f64 with SMTP id
 t14-20020a170902dcceb0290113ad636f64mr15676629pll.7.1623660498695; Mon, 14
 Jun 2021 01:48:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210609135537.1460244-1-joamaki@gmail.com> <20210609135537.1460244-4-joamaki@gmail.com>
 <20210609220713.GA14929@ranger.igk.intel.com> <CAHn8xcnMX03sX0n5VrTA2kJTSgcUj5s07mUHHc0wqB76QWpqeQ@mail.gmail.com>
In-Reply-To: <CAHn8xcnMX03sX0n5VrTA2kJTSgcUj5s07mUHHc0wqB76QWpqeQ@mail.gmail.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Mon, 14 Jun 2021 10:48:07 +0200
Message-ID: <CAJ8uoz0i2Y4bUXCGEgqWwP3QzLp2dqUfGZg+rWNt76qBwQezOw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: Add tests for XDP bonding
To:     Jussi Maki <joamaki@gmail.com>
Cc:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, j.vosburgh@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>, vfalico@gmail.com,
        Andrii Nakryiko <andrii@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 14, 2021 at 10:09 AM Jussi Maki <joamaki@gmail.com> wrote:
>
> On Thu, Jun 10, 2021 at 12:19 AM Maciej Fijalkowski
> <maciej.fijalkowski@intel.com> wrote:
> >
> > On Wed, Jun 09, 2021 at 01:55:37PM +0000, Jussi Maki wrote:
> > > Add a test suite to test XDP bonding implementation
> > > over a pair of veth devices.
> >
> > Cc: Magnus
> >
> > Jussi,
> > AF_XDP selftests have very similar functionality just like you are trying
> > to introduce over here, e.g. we setup veth pair and generate traffic.
> > After a quick look seems that we could have a generic layer that would
> > be used by both AF_XDP and bonding selftests.
> >
> > WDYT?
>
> Sounds like a good idea to me to have more shared code in the
> selftests and I don't see a reason not to use the AF_XDP datapath in
> the bonding selftests. I'll look into it this week and get back to
> you.

Note, that I am currently rewriting a large part of the AF_XDP
selftests making it more amenable to adding various tests. A test is
in my patch set is described as a set of packets to send, a set of
packets that should be received in a certain order with specified
contents, and configuration/setup information for the sender and
receiver. The current code is riddled with test specific if-statements
that make it hard to extend and use generically. So please hold off
for a week or so and review my patch set when I send it to the list.
Better use of your time. Hopefully we can make it fit your bill too
with not too much work.
