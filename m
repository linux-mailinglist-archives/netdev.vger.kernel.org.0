Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 607943CB070
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 03:31:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232079AbhGPBeK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Jul 2021 21:34:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbhGPBeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Jul 2021 21:34:09 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AC0C06175F;
        Thu, 15 Jul 2021 18:31:15 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id e20so11739427ljn.8;
        Thu, 15 Jul 2021 18:31:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8pGM98rvq6Cy+7SlMDex/asvWj6W9Zh7Piy15p8n3XU=;
        b=R1OqB3F1Vri0Wva4Sf/g27m/Y7AuynvF1a/L41vKx9bD3QCDCAzJ8rqlLKJduJ00U1
         f+hLeXlN4d4u/iLKlK2nAxtU9Ed4AoimGlEcohvyC6W+7m49UYgB9zEasmANAN8ggBV/
         mS+DG7fjwrtgqfwOuQLUEU3gBmQlN/y+TmYTJUKmPRXOBWPM/b/DEzqt1VYbfpYp32dJ
         3YETLN0fb8oUOVs0UBtCrfeXtIs3M6XEv1O4mXm8JbXGRtRKNeExgpLerlwxZlDJ0j+L
         srjGqvHv1vnoJOe1w0jeCJnfxSyu8WngYsYB3M5ubfdvncjc3rz7fDwzXe6YkJkVp3qB
         i7xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8pGM98rvq6Cy+7SlMDex/asvWj6W9Zh7Piy15p8n3XU=;
        b=bz4Gtm1SqV0P6THrQxbtfhB4QHSAWsPUVrEw5yvxT3aPnMSgvQZRMxaGvZ2AbskiFE
         54nXWgdl97JEUCzSXDY4GZQaUbdG0pkn5tEc1nUO79hiI7F+K4haW5U4MtUnN+5zaQ4B
         ricNJzeEUZddUB69KfUQhVNvU8bDzef5izMBIN69X/k7eIqHauq65LdHEZn4MMiJoqaS
         lZj2twBoL0S5OnCx/OoOU95lP/NJkv3Jz9SPh/ldKDlpSbcTGM7XJmqXFR271TtdQvqK
         QOj3WT3a9v/N98y9LQX6tSCnNwskpJlpD/OJz18vcKxjbDKTTbGK60jtEpvka9i1ZZr5
         9zSQ==
X-Gm-Message-State: AOAM531kKbK+DuX6FlBk9bwCW9JTS3wGNZaxv7swLtQwPEGT1rMdeAqY
        +3WiG63kErfHZdsE98pLTTOSoiqaOZQoJCOYTFI=
X-Google-Smtp-Source: ABdhPJzo6PVM3aTFF58Ba64L1t/2efsxQQJZLrg71R4EBoh9OGfHh1ohKhXwcczGdFjGDVXgOHWAF9hdbiUbwayzLtM=
X-Received: by 2002:a2e:a5c6:: with SMTP id n6mr6165487ljp.204.1626399073942;
 Thu, 15 Jul 2021 18:31:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210704190252.11866-1-xiyou.wangcong@gmail.com> <60ec75af43d1d_29dcc2085f@john-XPS-13-9370.notmuch>
In-Reply-To: <60ec75af43d1d_29dcc2085f@john-XPS-13-9370.notmuch>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 15 Jul 2021 18:31:02 -0700
Message-ID: <CAADnVQJNL6yfWe38Yu5yRrBhYTELjiE=rUH5N8CBRJj+iCt+CA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/11] sockmap: add sockmap support for unix
 datagram socket
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 10:03 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > This is the last patchset of the original large patchset. In the
> > previous patchset, a new BPF sockmap program BPF_SK_SKB_VERDICT
> > was introduced and UDP began to support it too. In this patchset,
> > we add BPF_SK_SKB_VERDICT support to Unix datagram socket, so that
> > we can finally splice Unix datagram socket and UDP socket. Please
> > check each patch description for more details.
> >
> > To see the big picture, the previous patchsets are available here:
> > https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=1e0ab70778bd86a90de438cc5e1535c115a7c396
> > https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git/commit/?id=89d69c5d0fbcabd8656459bc8b1a476d6f1efee4
> >
> > and this patchset is available here:
> > https://github.com/congwang/linux/tree/sockmap3
>
> LGTM Thanks. One nit around kfree of packets but its not specific
> to this series and I have a proposed fix coming shortly so no
> reason to hold this up.
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Applied. Thanks
