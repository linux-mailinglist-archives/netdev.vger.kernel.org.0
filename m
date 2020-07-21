Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5977228521
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 18:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgGUQOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 12:14:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729708AbgGUQOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 12:14:39 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDE81C061794;
        Tue, 21 Jul 2020 09:14:38 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f5so24691985ljj.10;
        Tue, 21 Jul 2020 09:14:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qnrzo3m/moPC7spmlG7c2sD0aqedvWh7YbC4vhEm7sA=;
        b=npnlZ761xb5dO2PofCWrkeVpoyos4evXBBlncACEK3Wo5mVKKy1x1V0ZThwPThvtgF
         9j7hQ0qrg1DoxN6zNZCDvfZYrJyLhuSJz4kSZ5zIqY7iycBHtNKWqHsTB6jTtkIEF1bS
         5qrLn/C+x5h9JAGQVYs8Rq3bj1npXCRUwqQDIWHXyjMLaMgQru4isJ5HCp0bxgnWRf3L
         MrsityQZhvQjiphulixgSJ5051yQjVH6GkCa2521oPIcWpYybgL1zU4Wl8X3zGJUZQPT
         WrzsK4UE9BtlimWHK7LtyNzx9ujtw35qR+MOHZQnQXNG6ghOz/d9zLv3sqqKgH2MQ4Mg
         bM2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qnrzo3m/moPC7spmlG7c2sD0aqedvWh7YbC4vhEm7sA=;
        b=nZRFUOljCY9ona2I5y+6U0XLxpwNmvXe7V3yELcPfXWm9TCa8opU8KBps1EQZle4KM
         iik/++mUqlcM8jpWKiAcVPPqyCZeLwTZiZPjkmvJPEM5mMZTQMa6ow37FkCiLxEL0Z2Q
         Oz7dR5L/IBX8yZXJ7k/zWAiDzHrTjoxuNYsapik4DzP+g2CXMHldkDAJxFl/M6aqprf6
         TmN7usNYsIon4DPjKbeCi+h4IGaS3JAwVUrTEBtVQf7S66hftBTD4wP2651DRhbY3sZG
         koQmt5G1URK3S2c3X731iC7s4fN92Gtt3N9zdkiOQR1+8GSEADg8rnp112S+8Rvifabp
         Hvig==
X-Gm-Message-State: AOAM530wFS+ITjFBAb43Pfl7PJzTBGEEh5ybZkJKxtBfd34Wqyu5e1uh
        nVYyS3nKMwohj4eHlxtmJ8GF7IBlKbYNicneMPs=
X-Google-Smtp-Source: ABdhPJxyt6MEO8MDzWAApsfZLBM3yeet5/hMDgA3rvElUOHwuyt92SwGTQZlsPDjfjg3KTUusSrUQR4s/hI68wRqCI0=
X-Received: by 2002:a2e:9a0f:: with SMTP id o15mr13518627lji.450.1595348077362;
 Tue, 21 Jul 2020 09:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200721100716.720477-1-jakub@cloudflare.com> <1140c2d9-f0a4-97da-5f3f-23190e6bc6b9@infradead.org>
In-Reply-To: <1140c2d9-f0a4-97da-5f3f-23190e6bc6b9@infradead.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 21 Jul 2020 09:14:25 -0700
Message-ID: <CAADnVQ+F3devpvOg7i6td99Hq3bXOVe0t6_tUKnFzw-=v6Ky9A@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf, netns: Fix build without CONFIG_INET
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 7:01 AM Randy Dunlap <rdunlap@infradead.org> wrote:
>
> On 7/21/20 3:07 AM, Jakub Sitnicki wrote:
> > When CONFIG_NET is set but CONFIG_INET isn't, build fails with:
> >
> >   ld: kernel/bpf/net_namespace.o: in function `netns_bpf_attach_type_unneed':
> >   kernel/bpf/net_namespace.c:32: undefined reference to `bpf_sk_lookup_enabled'
> >   ld: kernel/bpf/net_namespace.o: in function `netns_bpf_attach_type_need':
> >   kernel/bpf/net_namespace.c:43: undefined reference to `bpf_sk_lookup_enabled'
> >
> > This is because without CONFIG_INET bpf_sk_lookup_enabled symbol is not
> > available. Wrap references to bpf_sk_lookup_enabled with preprocessor
> > conditionals.
> >
> > Fixes: 1559b4aa1db4 ("inet: Run SK_LOOKUP BPF program on socket lookup")
> > Reported-by: Randy Dunlap <rdunlap@infradead.org>
> > Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>
> Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested

Applied. Thanks
