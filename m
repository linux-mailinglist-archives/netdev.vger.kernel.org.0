Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95B062AAECE
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 02:45:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgKIBpT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Nov 2020 20:45:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727979AbgKIBpT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Nov 2020 20:45:19 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 886ADC0613CF;
        Sun,  8 Nov 2020 17:45:19 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id w6so979405pfu.1;
        Sun, 08 Nov 2020 17:45:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=do64FoTxiW6aSEst954wsCuxnCqK2NqrUlgo5iPVJ0U=;
        b=V8GHN66N/wOQtHaPM8a7mgZQOx2zU+r6RW2kAjMXBFRh3itFM6zN4mn28wKBmdkXCO
         4YjkFifLhDMlIMmvLCjYsZBkdvrBkDny40zFrCFWVZMqsl9SEjOjxLwyTQxIVUS5pvx9
         kcNK5ixcW+MSxvijkDuFrrvhQjDkV8w+N8eple71+yG+tfoB68ANkpBD8QbKUKSYV1c+
         U+eiaQNCGwAl2uzvXxipWUI8OSES+Ap28ZVwLBLoz++rDvbXWUVFiExtWXZFclVKPFtT
         DEVKb3CsgtlvGvnUeNYEOaMMVvt8gSIS14kh1WkJ4DqnGfyeR6Hi6HScJyxfkpZfky/m
         QJug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=do64FoTxiW6aSEst954wsCuxnCqK2NqrUlgo5iPVJ0U=;
        b=In+EeSc9lm9S9DAXgIV+WkCp7mMjEDk5pP76rp9G440TVrVBuViEXK1Rj4owiphpKz
         gn4bLfWF/AcGbIiegi6Kg659XpCYTdy4T14v2xONrEZMG34TIE7h0nTmq+w8DBCFxbGY
         QHoljbQUj2fbqoWwJesJ7rJa31gNyfrfgV8PNFv+osa8DT8nGhikqT1I71zKzuVEyfUH
         E6B1DYgsBEwFs9eTfMxNNFweM2mVB/WLiIHHgw2K2vEe3IOiCbZoCme+llchgF4rgBuU
         6BpZzRVYbEIDc3ySDMQhMVpxLxCSQP34QDe08yteuI6U8pH35vjE66gQnRUey1iRVqhe
         GTqw==
X-Gm-Message-State: AOAM532L+ioTy/nAjZslZ3QTjy2gVe43NqNCFOr03JcsZbn5FCVVEkC4
        LB8ZGGwbgfKq45I+FB0WYoA=
X-Google-Smtp-Source: ABdhPJwYB3Whpu117Q8/CtmgwUK8dDudCPfXHYlVhvmYWsZeoMlQEzYEfsMOoSsoAv9yKbwNiLMBcA==
X-Received: by 2002:a17:90a:b797:: with SMTP id m23mr783000pjr.153.1604886319127;
        Sun, 08 Nov 2020 17:45:19 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:7b57])
        by smtp.gmail.com with ESMTPSA id t19sm8160644pgv.37.2020.11.08.17.45.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 17:45:17 -0800 (PST)
Date:   Sun, 8 Nov 2020 17:45:15 -0800
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
Message-ID: <20201109014515.rxz3uppztndbt33k@ast-mbp>
References: <20201104031145.nmtggnzomfee4fma@ast-mbp.dhcp.thefacebook.com>
 <bb04a01a-8a96-7a6a-c77e-28ee63983d9a@solarflare.com>
 <CAADnVQKu7usDXbwwcjKChcs0NU3oP0deBsGGEavR_RuPkht74g@mail.gmail.com>
 <07f149f6-f8ac-96b9-350d-b289ef16d82f@solarflare.com>
 <CAEf4BzaSfutBt3McEPjmu_FyxyzJa_xVGfhP_7v0oGuqG_HBEw@mail.gmail.com>
 <20201106094425.5cc49609@redhat.com>
 <CAEf4Bzb2fuZ+Mxq21HEUKcOEba=rYZHc+1FTQD98=MPxwj8R3g@mail.gmail.com>
 <CAADnVQ+S7fusZ6RgXBKJL7aCtt3jpNmCnCkcXd0fLayu+Rw_6Q@mail.gmail.com>
 <20201106152537.53737086@hermes.local>
 <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45d88ca7-b22a-a117-5743-b965ccd0db35@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 04:38:13PM -0700, David Ahern wrote:
> On 11/6/20 4:25 PM, Stephen Hemminger wrote:
> >>
> >> I think bumping the minimal version of libbpf with every iproute2 release
> >> is necessary as well.
> >> Today iproute2-next should require 0.2.0. The cycle after it should be 0.3.0
> >> and so on.
> >> This way at least some correlation between iproute2 and libbpf will be
> >> established.
> >> Otherwise it's a mess of versions and functionality from user point of view.
> 
> If existing bpf features in iproute2 work fine with version 0.1.0, what
> is the justification for an arbitrary requirement for iproute2 to force
> users to bump libbpf versions just to use iproute2 from v5.11?

I don't understand why on one side you're pointing out existing quirkiness with
bpf usability while at the same time arguing to make it _less_ user friendly
when myself, Daniel, Andrii explained in detail what libbpf does and how it
affects user experience?

The analogy of libbpf in iproute2 and libbfd in gdb is that both libraries
perform large percentage of functionality comparing to the rest of the tool.
When library is dynamic linked it makes user experience unpredictable. My guess
is that libbfd is ~50% of what gdb is doing. What will the users say if gdb
suddenly behaves differently (supports less or more elf files) because
libbfd.so got upgraded in the background? In case of tc+libbpf the break down
of funcionality is heavliy skewed towards libbpf. The amount of logic iproute2
code will do to perform "tc filter ... bpf..." command is 10% iproute2 / 90%
libbpf. Issuing few netlink calls to attach bpf prog to a qdisc is trivial
comparing to what libbpf is doing with an elf file. There is a linker inside
libbpf. It will separate different functions inside elf file. It will relocate
code and adjust instructions before sending it to the kernel. libbpf is not
a wrapper. It's a mini compiler: CO-RE logic, function relocation, dynamic
kernel feature probing, etc. When the users use a command line tool (like
iproute2 or bpftool) they are interfacing with the tool. It's not unix-like to
demand that users should check the version of a shared library and adjust their
expectations. The UI is the command line. Its version is as a promise of
features. iproute2 of certain version in one distro should behave the same as
iproute2 in another distro. By not doing git submodule that promise is broken.
Hence my preference is to use fixed libbpf sha for every iproute2 release. The
other alternative is to lag iproute2/libbpf one release behind. Hence
repeating what I said earlier: Today iproute2-next should require 0.2.0. The
iprtoute2 in the next cycle _must_ bump be the minimum libbpf version to 0.3.0.
Not bumping minimum version brings us to square one and unpredicatable user
experience. The users are jumping through enough hoops when they develop bpf
programs. We have to make it simpler and easier. Using libbpf in iproute2
can improve the user experience, but only if it's predictable.
