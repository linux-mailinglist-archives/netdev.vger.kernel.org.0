Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1884D1716A1
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 13:02:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbgB0MCk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 07:02:40 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:46496 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728986AbgB0MCk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 07:02:40 -0500
Received: by mail-oi1-f194.google.com with SMTP id a22so2967467oid.13
        for <netdev@vger.kernel.org>; Thu, 27 Feb 2020 04:02:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BrW5LZwrgusNW5R7fWdBcyZoH5Id25Lj621CnfewVCc=;
        b=R7ucxzv9WX65DnqA/knWAtXzG4aPD3M+Asthh3S1KCrJkFmamDtuptP8MO97MSHPba
         e34rpQIqPzJrIS5t+m2Tbc5VplqIasAxwwwWAF/g02+wjLvXAycRrcQgceZ/5e3sPx6V
         FEQqshY/WSxH/1/V4meq2t1Hh1fEGRnWWai7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BrW5LZwrgusNW5R7fWdBcyZoH5Id25Lj621CnfewVCc=;
        b=sTUzG2EQ64pb1jX4jSOlDlDSW4GSgmfRoLwol+EWv0lIz09lODE/lZnlB/Ui9fT4Kr
         NYTVp+LlrAMCOL70h+Rr1zHpN2udnrvROW3Jq8/fVdJEnjLNj3DHQW4BeyKwm2JLDmwB
         7MxiAbSWWDEvNjW37BBFLkMlT+noA+8pezmCcvd7P2RXf5PK9SdBDhgPlDh8Ic8syIns
         dzknEY4YVMMrdck5x6ijwgXFAAd6KKHy18QwpZ0A/TKyJkkjaOfByY9OepsjpzTyZVx8
         4atm9VSR1u/ChGB7aTrVC0j/V6hSO5HkpCzqzQbBNdQLvgxkhNWCL4Q7A3d6S7rooaJr
         pHWg==
X-Gm-Message-State: APjAAAXaetcL22xvqusBnJuv8HayRkLeNukPasT3dEjGqHQAhYPkj16m
        yRjKK0ageEu+ZkElyJdST6/ivNv+bgWicPJptXQ4uA==
X-Google-Smtp-Source: APXvYqxGGnZ2YlIzPYcumkmeZ2az1g8ikQk+YksINp58lf1d1j35iK2m2bjoEozqq7jJAU097AlwLPvODXTA3KcrXgY=
X-Received: by 2002:aca:d4c1:: with SMTP id l184mr3007527oig.172.1582804959343;
 Thu, 27 Feb 2020 04:02:39 -0800 (PST)
MIME-Version: 1.0
References: <20200225135636.5768-1-lmb@cloudflare.com> <20200225135636.5768-7-lmb@cloudflare.com>
 <877e08cksq.fsf@cloudflare.com>
In-Reply-To: <877e08cksq.fsf@cloudflare.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Thu, 27 Feb 2020 12:02:28 +0000
Message-ID: <CACAyw9832Q+uLfYgzs5oAmYZDF+3U5pPGYKViMKovqb_hKY0gw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 6/7] selftests: bpf: add tests for UDP sockets in sockmap
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Feb 2020 at 11:49, Jakub Sitnicki <jakub@cloudflare.com> wrote:
> > +#define TEST(fn) TEST_SOTYPE(fn, 0)
> > +#define TEST_STREAM(fn) TEST_SOTYPE(fn, SOCK_STREAM)
> > +#define TEST_DGRAM(fn) TEST_SOTYPE(fn, SOCK_DGRAM)
> > +
>
> An alternative would be to use __VA_ARGS__ and designated intializers,
> as I did recently in e0360423d020 ("selftests/bpf: Run SYN cookies with
> reuseport BPF test only for TCP"). TEST_DGRAM is unused at the moment,
> so that's something to consider.

Good idea, I'll pick it up!

> test_redir() doesn't get called with SOCK_DGRAM, because redirection
> with sockmap and UDP is not supported yet, so perhaps no need to touch
> this function.

I did this to avoid needing another macro, it should be possible to skip this
with your VA_ARGS idea.

> Looks like we can enable reuseport tests with not too much effort.
> I managed to get them working with the changes below.

Thanks, I'll add this to the next revision!

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
