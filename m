Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281C230352A
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:37:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbhAZFgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:36:39 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:37069 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731263AbhAZCSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 21:18:44 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 0938F5C0176;
        Mon, 25 Jan 2021 21:17:31 -0500 (EST)
Received: from imap6 ([10.202.2.56])
  by compute2.internal (MEProxy); Mon, 25 Jan 2021 21:17:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kode54.net; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm2; bh=735hv4Tvj+thMpNngNIzqfBhcBDwojM
        fJpUzLTedE6o=; b=pVFpn8v3qAbmr2OoqdKgfWkqjIU6M3vY92pWTxF7InYco3u
        oa+WorMQNBVhm8ot/xGm5wZ9Sx8RB0/R6YMZk5SgThkH4nX9hH5QdLTddIA6bmQU
        4BE5pySIXkyzzaMQdsC6NrK6N8F6ca4LyJv/KrYKA/HfRiUfDR2/xoySBJdeJvWO
        RQA7FG8rmjwEecDMgMKgOH9Fr7EK1irY/Cw8nxLJxmYbD4H8DxBJYatikzBfH+jv
        Rb2yEx91JB0RH9/0KjhvNVs7PgPN36E9oAr9XCBw9g5x6/bOznuwUJea3TRxUJ9u
        KZtwoNwrm3lm50A2rKi8P04Yw9zxnW//BFmt63g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=735hv4
        Tvj+thMpNngNIzqfBhcBDwojMfJpUzLTedE6o=; b=q59W6fQhajGm5T1F9BTP8o
        L5swcW1MW4L0ts5Y0eNKAkVIe/jbpFMSgsx9FZRuKlY6S45JBuvtSc45vUjA/ciD
        yMod/gEurcc6QW8JllyS9aUJ7piW/90I1b7yHifkf8if4iqbSt9Mvokl/A03odFQ
        jXmFQF6dOHrTHNeHvVGvCOZDSNbQtIpSHh4Xj35hrciceHwk7muP5We/+DOVFB4D
        G2JXqjQ/ZOwStEIEX5WDgDsmVPIKIjkystnT9t4fCqlXobvJXK3XnrHEP27oZ1Qx
        ZxewuOp8ao++EMo6F1cJanf4ZcrRRgKjbvdUz9sASfdVu/qxTX5JoSxg/9D0oPZA
        ==
X-ME-Sender: <xms:unsPYI18mbGmEeU71voby2Ivw1_gMUtEatHJBtbp8gmEZJgUzTJ-Fw>
    <xme:unsPYDHSMuSWnBEz9kKj5ZMIV9MjAknkXmPebHjONTJbl0V1Eqz37XXM4HJiUPm08
    yA7wMBmevEJqxUt2Lg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeggdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfvehhrhhi
    shhtohhphhgvrhcuhghilhhlihgrmhcuufhnohifhhhilhhlfdcuoegthhhrihhssehkoh
    guvgehgedrnhgvtheqnecuggftrfgrthhtvghrnhepteelueegledvteehveefiefhveev
    gefhteefiedtveekhfehledvjeffudelgfegnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegt
    hhhrihhssehkohguvgehgedrnhgvth
X-ME-Proxy: <xmx:unsPYA7dBw0ZgwLur30miIuBh9S9UHMSRz631tfRDEDE5uSu0qTtzw>
    <xmx:unsPYB0fv86tr3hIl-R8OwQ2ganBcVYjh2jd6DlXRNIsjwU35VvZtg>
    <xmx:unsPYLERVM4cqeat6ZGTQ6xPFOn4ROEcHz-KMR6_8alCSn5JgpNGFw>
    <xmx:u3sPYMP1y_ttj9Rz0oXdScMp6qjRt1wFssuqhwGAJqVyelN8puwlIg>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A729924063D; Mon, 25 Jan 2021 21:17:30 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-78-g36b56e88ef-fm-20210120.001-g36b56e88
Mime-Version: 1.0
Message-Id: <64ab3a61-1488-4334-8831-60e7052864d7@www.fastmail.com>
In-Reply-To: <CAEf4BzY4LWhyHfd3OpvrM5DB7qieOemcxzp0GBtqWJTw56PMCg@mail.gmail.com>
References: <20210110070341.1380086-1-andrii@kernel.org>
 <161048280875.1131.14039972740532054006.git-patchwork-notify@kernel.org>
 <4f19b649-a837-48af-90d1-c4692580053d@www.fastmail.com>
 <CAEf4BzY4LWhyHfd3OpvrM5DB7qieOemcxzp0GBtqWJTw56PMCg@mail.gmail.com>
Date:   Mon, 25 Jan 2021 18:17:10 -0800
From:   "Christopher William Snowhill" <chris@kode54.net>
To:     "Andrii Nakryiko" <andrii.nakryiko@gmail.com>
Cc:     patchwork-bot+netdevbpf <patchwork-bot+netdevbpf@kernel.org>,
        "Andrii Nakryiko" <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "Alexei Starovoitov" <ast@fb.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Kernel Team" <kernel-team@fb.com>
Subject: Re: [PATCH bpf 1/2] bpf: allow empty module BTFs
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aha, that was just released. Nice. I'll report this to the issue tracker where I had lodged the bpf patches for QoL use when testing rc4 and older.

On Mon, Jan 25, 2021, at 5:26 PM, Andrii Nakryiko wrote:
> On Sun, Jan 24, 2021 at 2:28 AM Christopher William Snowhill
> <chris@kode54.net> wrote:
> >
> > When is this being applied to an actual kernel? 5.11 is still quite broken without these two patches. Unless you're not using a vfat EFI partition, I guess.
> >
> 
> It's in v5.11-rc5.
> 
> > On Tue, Jan 12, 2021, at 12:20 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> > > Hello:
> > >
> > > This series was applied to bpf/bpf.git (refs/heads/master):
> > >
> > > On Sat, 9 Jan 2021 23:03:40 -0800 you wrote:
> > > > Some modules don't declare any new types and end up with an empty BTF,
> > > > containing only valid BTF header and no types or strings sections. This
> > > > currently causes BTF validation error. There is nothing wrong with such BTF,
> > > > so fix the issue by allowing module BTFs with no types or strings.
> > > >
> > > > Reported-by: Christopher William Snowhill <chris@kode54.net>
> > > > Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
> > > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > > >
> > > > [...]
> > >
> > > Here is the summary with links:
> > >   - [bpf,1/2] bpf: allow empty module BTFs
> > >     https://git.kernel.org/bpf/bpf/c/bcc5e6162d66
> > >   - [bpf,2/2] libbpf: allow loading empty BTFs
> > >     https://git.kernel.org/bpf/bpf/c/b8d52264df85
> > >
> > > You are awesome, thank you!
> > > --
> > > Deet-doot-dot, I am a bot.
> > > https://korg.docs.kernel.org/patchwork/pwbot.html
> > >
> > >
> > >
>
