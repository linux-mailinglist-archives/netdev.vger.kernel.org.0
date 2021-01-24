Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D86E301B3D
	for <lists+netdev@lfdr.de>; Sun, 24 Jan 2021 11:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbhAXK31 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Jan 2021 05:29:27 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:58047 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726546AbhAXK3Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Jan 2021 05:29:24 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 8E278D3C;
        Sun, 24 Jan 2021 05:28:17 -0500 (EST)
Received: from imap6 ([10.202.2.56])
  by compute2.internal (MEProxy); Sun, 24 Jan 2021 05:28:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kode54.net; h=
        mime-version:message-id:in-reply-to:references:date:from:to:cc
        :subject:content-type; s=fm2; bh=9bTaOq/ywin9K4U2DKZqsyrGf/ZSeUy
        3tGjtLPYRmSA=; b=FpAaiiiyhZdbkNreOl76L6OmYD40OvOkrOXUXqwWa6mJaSu
        1G+nTecenF/cNy9DlY10QeTGZtJt9+bM7b3QjYhrCrbK/e3kkj6lePPdyGGN05Gx
        R/T27MUdw2FPChUhYnDMUqJYTz9PvgCZQbre1s7aF+lyVBFdftk2TIxPXES1IPnM
        Vuz0vyJY21jq7G4fjFwVcBfYevMvdnyFkI0jyWKmdgt18Al911fPP1BkEivXx6t9
        WKx6ps8e2+CCOkevyXF95BSNeXVZxXSbqIzHo3ipfSv4+aYtTycHYzc/cjmivK4H
        T0mXqVUrWErsOpnJFuqj7z/BOwoJXKUhJVYtk1A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=9bTaOq
        /ywin9K4U2DKZqsyrGf/ZSeUy3tGjtLPYRmSA=; b=rLD7+pFeWTkCJSTwhBlyWR
        Tr9AnVtSKu38Si0eLsoO94VCMCxAJpBD7rooVx6qURWO20XTKZ1dWqubw49P1+bu
        FkOj/2KqACbVrc1JzuPG8vihtgLY7l+MEqRQxO4pr1Qy+dyCd6xh+OEOKnk67bcC
        scenD9EmimbAGeMUSOn0eSw/Db8J4f5YMVj9gjRc3UCk8PR1eVuheZFFe4eMo0a6
        zhOD+fUo0MzYZlTWytbbZBaOd3zo1M6EsMdqM8Rk5QT+XUPP0F4LSWa+mK4D3LeR
        8iHUqVpE7wh0MDwWNHvaLsZT850K1nCl4bnwDYCKZyOE55LJyMrumc/Nz/kBZ+Iw
        ==
X-ME-Sender: <xms:wEsNYBLG5b0IDrrO9JgOYMq-CYgnshFNBomEcGBCOR9ELTpEm4zPCg>
    <xme:wEsNYNKdV8ef0jmLmpNv2betINdzDyHlElP-i2RiZAB5gOdtyThQIW6yCTrH1UovE
    1mJqrB_lry2B64JBj0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvddugddujecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefofgggkfgjfhffhffvufgtsehttdertderredtnecuhfhrohhmpedfvehhrhhi
    shhtohhphhgvrhcuhghilhhlihgrmhcuufhnohifhhhilhhlfdcuoegthhhrihhssehkoh
    guvgehgedrnhgvtheqnecuggftrfgrthhtvghrnhepteelueegledvteehveefiefhveev
    gefhteefiedtveekhfehledvjeffudelgfegnecuffhomhgrihhnpehkvghrnhgvlhdroh
    hrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegt
    hhhrihhssehkohguvgehgedrnhgvth
X-ME-Proxy: <xmx:wEsNYJs2ESlyhDdn7AsvnrvpTIR0DQJ4wyEg_y5nJ3d7OtUeutIbSQ>
    <xmx:wEsNYCbuKvmVqMuq9igL29QonamWkdrkAQ6MvxgbpXm1t_WCWFxxMw>
    <xmx:wEsNYIZOiWSU0yu3ouvYoV8Yh8kmUmTbORWhneGyAOECbs1oCKhlUA>
    <xmx:wUsNYPXSk4o64KhCyXYeSjcMfpeBgxNCEtgeb6b5yZD3-L8mpnubgw>
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id A864D240408; Sun, 24 Jan 2021 05:28:16 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.5.0-alpha0-78-g36b56e88ef-fm-20210120.001-g36b56e88
Mime-Version: 1.0
Message-Id: <4f19b649-a837-48af-90d1-c4692580053d@www.fastmail.com>
In-Reply-To: <161048280875.1131.14039972740532054006.git-patchwork-notify@kernel.org>
References: <20210110070341.1380086-1-andrii@kernel.org>
 <161048280875.1131.14039972740532054006.git-patchwork-notify@kernel.org>
Date:   Sun, 24 Jan 2021 02:27:53 -0800
From:   "Christopher William Snowhill" <chris@kode54.net>
To:     patchwork-bot+netdevbpf@kernel.org,
        "Andrii Nakryiko" <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com
Subject: Re: [PATCH bpf 1/2] bpf: allow empty module BTFs
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When is this being applied to an actual kernel? 5.11 is still quite broken without these two patches. Unless you're not using a vfat EFI partition, I guess.

On Tue, Jan 12, 2021, at 12:20 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This series was applied to bpf/bpf.git (refs/heads/master):
> 
> On Sat, 9 Jan 2021 23:03:40 -0800 you wrote:
> > Some modules don't declare any new types and end up with an empty BTF,
> > containing only valid BTF header and no types or strings sections. This
> > currently causes BTF validation error. There is nothing wrong with such BTF,
> > so fix the issue by allowing module BTFs with no types or strings.
> > 
> > Reported-by: Christopher William Snowhill <chris@kode54.net>
> > Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
> > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > 
> > [...]
> 
> Here is the summary with links:
>   - [bpf,1/2] bpf: allow empty module BTFs
>     https://git.kernel.org/bpf/bpf/c/bcc5e6162d66
>   - [bpf,2/2] libbpf: allow loading empty BTFs
>     https://git.kernel.org/bpf/bpf/c/b8d52264df85
> 
> You are awesome, thank you!
> --
> Deet-doot-dot, I am a bot.
> https://korg.docs.kernel.org/patchwork/pwbot.html
> 
> 
>
