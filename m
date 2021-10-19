Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99B92433341
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 12:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbhJSKNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 06:13:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhJSKNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 06:13:52 -0400
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54E77C06161C;
        Tue, 19 Oct 2021 03:11:40 -0700 (PDT)
Received: by mail-oi1-x231.google.com with SMTP id v77so4135823oie.1;
        Tue, 19 Oct 2021 03:11:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2ctl1coiiBgIR1zUuBcj1SRCWr0mc617dDGiuKbUwbY=;
        b=c873+lYsgqVl0Yfr6t+uWwUHLzQB6VnoRVOeUx2Ee/HORwwyNrC2oqUYkY3POlnmuL
         n+tc8p2TX0E2tcBh1VU6j4TChwpyIth3Td7GdJVDMXKXjs7FhTqoNNZoZJhlqyZAnalq
         jWKjAxIlZkC/9kxvhngfvq0iQBttHIriATnyQ1gDhabE2To/TIB09ixSL7Eo/vZ4muUN
         xGvX8g37HvIrbcSKV3+zLiHg6agms0W+wiyRHvKfNc+toLVklWhtsug4KjJeS3LDGh6f
         EVtVtXLFJVHgd5lydDxrOqgS673Gqrq9IhiyFLEXkZRM9NVqEh5hBAXb0gpaSJvr8qFK
         HuQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2ctl1coiiBgIR1zUuBcj1SRCWr0mc617dDGiuKbUwbY=;
        b=oyIeUsh2bXDH7dCdQre0+gwOcWo2rgy+vBlSdIwyo87Fq3DVYPCLy8ntS8yYzxNDM7
         udOho5YSluKkNsasRj+9fU6fbLn+aMPI9vdgPsti9Byn6mi3UTk6XRKu/IAuqvZ76+QH
         VDBUxRhEbeE9xYqCb9YnGeL4GZqTndDrDSsk4K912z4EHvhtn62rgTDjaGTaS1c13xDX
         XFTL3+uqJyvkuaEfBxc47SnIecCaVeciZzZZ/3J3AVr9Wa14sUAOYOzxYtQYIKRn3bjl
         2iL4XEFDpnTu+MCzEgjmCHzf55LXhVYoFbeSUDQGeGyB4yWcVm69XNmjZXd0473O6AxL
         K8WA==
X-Gm-Message-State: AOAM531rXuvDZIswuKQCgjXFbzn7aoFUsZUI/Etb1OKQcfGpo/DBbnPW
        cALmx9LZdUAXoBOH6ga6UsdMxjiJKxcjRtXWWA==
X-Google-Smtp-Source: ABdhPJybA/174GdIrs0q4NSa5FqT5pPxCeY63ObMStK/SaVjnPZJBE4By7fv6IinsJ8E9sGDlb0DFnENP/H8rQqhgbY=
X-Received: by 2002:aca:5cd4:: with SMTP id q203mr3509045oib.179.1634638299649;
 Tue, 19 Oct 2021 03:11:39 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000005639cd05ce3a6d4d@google.com> <f821df00-b3e9-f5a8-3dcb-a235dd473355@iogearbox.net>
 <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
In-Reply-To: <f3cc125b2865cce2ea4354b3c93f45c86193545a.camel@redhat.com>
From:   Jussi Maki <joamaki@gmail.com>
Date:   Tue, 19 Oct 2021 12:11:28 +0200
Message-ID: <CAHn8xcnoPvt4KNZ3cD17PD9qbTa=58h38E8O0zePvYiKHFEc+A@mail.gmail.com>
Subject: Re: [syzbot] BUG: corrupted list in netif_napi_add
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+62e474dd92a35e3060d8@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>, ast@kernel.org,
        bpf <bpf@vger.kernel.org>, davem@davemloft.net, hawk@kernel.org,
        john.fastabend@gmail.com, kafai@fb.com, kpsingh@kernel.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        Network Development <netdev@vger.kernel.org>,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com, yhs@fb.com,
        toke@toke.dk
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 14, 2021 at 3:50 PM Paolo Abeni <pabeni@redhat.com> wrote:
>
> On Wed, 2021-10-13 at 15:35 +0200, Daniel Borkmann wrote:
> > On 10/13/21 1:40 PM, syzbot wrote:
> > > Hello,
> > >
> > > syzbot found the following issue on:
> >
> > [ +Paolo/Toke wrt veth/XDP, +Jussi wrt bond/XDP, please take a look, thanks! ]
>
> For the records: Toke and me are actively investigating this issue and
> the other recent related one. So far we could not find anything
> relevant.
>
> The onluy note is that the reproducer is not extremelly reliable - I
> could not reproduce locally, and multiple syzbot runs on the same code
> give different results. Anyhow, so far the issue was only observerable
> on a specific 'next' commit which is currently "not reachable" from any
> branch. I'm wondering if the issue was caused by some incosistent
> status of such tree.
>

Hey,

I took a look at the bond/XDP related bits and couldn't find anything
obvious there. And for what it's worth, I was running the syzbot repro
under bpf-next tree (223f903e9c8) in the bpf vmtest.sh environment for
30 minutes without hitting this. An inconsistent tree might be a
plausible cause.
