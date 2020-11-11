Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990752AE51B
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 01:48:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbgKKAr7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 19:47:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732485AbgKKAr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 19:47:56 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69819C0613D1;
        Tue, 10 Nov 2020 16:47:54 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id w4so207496pgg.13;
        Tue, 10 Nov 2020 16:47:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=JwoNgdxg8ZrZ61bDPQkii1B5bpOmPdODGxawpOT/OhY=;
        b=Se4AStJrGLvgU+qwRcI5kmgucbLew44q5SfB+BQg4LEoVrMx+K4KjygCX+LVOlbkVL
         7iH5SFAjN0N4yEtH1zqZicl98egEmqQAy8idPed2b7NqXg6DSlE4Lx1rpHvDVQYF/YTu
         Y5NDwqoeYu0+1LHzukpJ1VjkGPZHwWwyikE2uby5dx3OIjwjxkco+LpJTbWRimRbEh8r
         h6t5cStruS2utk8nVUhc1+zODE6uca5xxywPgy74VPKplOg5+FxDBZqHt5DI2LGDtoU4
         SNBgVim68hGnMhm5pESJWLUhQW8MaTyNzqUxirqdKlIdG134CBAjd+FVd6gECAXJaX5m
         E6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JwoNgdxg8ZrZ61bDPQkii1B5bpOmPdODGxawpOT/OhY=;
        b=rNGR9PMxyak6eDCYDYf7HzjDEU5ZDnoo+vNKXWspX1m5ueFq96IhClIdph2uRU3G3P
         2bCqbccYBriiqbRpWDfkyfdIMgFE05n8/M/ML8U+FZJd/81eliFTa1/y/Vr+M7JfNfOU
         yVrMKNst44NxDnpyIg7Ya4JOwyXD9QPiQbxDDu7BsBOnDyYno8HnetSIZ3XNvu49sebJ
         o2IcgqYzuSgW6OqT0UVNT1Hzp9s6uGy97uBojQFbYHoE1EwZBo056kistGD86JOFbaYd
         rw8YYfOCuBOjiWIMJKyAdz5II6CRqJ2DNV3c88E+xlfGXRJNPRw3pePVXleNjmS/W9/Y
         w4DQ==
X-Gm-Message-State: AOAM533gqV5JE8QlkaZA1jKm5PV11MvRkboqkRC0RpHrHbpBRPgNy5X4
        0UDPmHwbIc+G69sB48lyWY8=
X-Google-Smtp-Source: ABdhPJy2fxLB1dlnVWnaLAVFfdkoNbWkppSl+jZtKwfbF/Z31VOj1iTQ3aNiXlTjl8/b81TWA42NoQ==
X-Received: by 2002:a63:8149:: with SMTP id t70mr19811263pgd.80.1605055673806;
        Tue, 10 Nov 2020 16:47:53 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:8fc0])
        by smtp.gmail.com with ESMTPSA id y124sm315178pfy.28.2020.11.10.16.47.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 16:47:52 -0800 (PST)
Date:   Tue, 10 Nov 2020 16:47:49 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Jiri Benc <jbenc@redhat.com>,
        Edward Cree <ecree@solarflare.com>,
        Hangbin Liu <haliu@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCHv3 iproute2-next 0/5] iproute2: add libbpf support
Message-ID: <20201111004749.r37tqrhskrcxjhhx@ast-mbp>
References: <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
 <20201109014515.rxz3uppztndbt33k@ast-mbp>
 <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <14c9e6da-e764-2e2c-bbbb-bc95992ed258@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 09:09:44PM -0700, David Ahern wrote:
> On 11/8/20 6:45 PM, Alexei Starovoitov wrote:
> > 
> > I don't understand why on one side you're pointing out existing quirkiness with
> > bpf usability while at the same time arguing to make it _less_ user friendly
> 
> I believe you have confused my comments with others. My comments have
> focused on one aspect: The insistence by BPF maintainers that all code
> bases and users constantly chase latest and greatest versions of
> relevant S/W to use BPF

yes, because we care about user experience while you're still insisting
on make it horrible.
With random pick of libbpf.so we would have no choice, but to actively tell
users to avoid using tc, because sooner or later they will be pissed. I'd
rather warn them ahead of time.

> - though I believe a lot of the tool chasing
> stems from BTF. I am fairly certain I have been consistent in that theme
> within this thread.

Right. A lot of features added in the last couple years depend on BTF:
static vs global linking, bpf_spin_lock, function by function verification, etc

> > when myself, Daniel, Andrii explained in detail what libbpf does and how it
> > affects user experience?
> > 
> > The analogy of libbpf in iproute2 and libbfd in gdb is that both libraries
> 
> Your gdb / libbfd analogy misses the mark - by a lot. That analogy is
> relevant for bpftool, not iproute2.
> 
> iproute2 can leverage libbpf for 3 or 4 tc modules and a few xdp hooks.
> That is it, and it is a tiny percentage of the functionality in the package.

cat tools/lib/bpf/*.[hc]|wc -l
23950
cat iproute2/tc/*.[hc]|wc -l
29542

The point is that for these few tc commands the amount logic in libbpf/tc is 90/10.

Let's play it out how libbpf+tc is going to get developed moving forward if
libbpf is a random version. Say, there is a patch for libbpf that makes
iproute2 experience better. bpf maintainers would have no choice, but to reject
it, since we don't add features/apis to libbpf if there is no active user.
Adding a new libbpf api that iproute2 few years from now may or may not take
advantage makes little sense.
