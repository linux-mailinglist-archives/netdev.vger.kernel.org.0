Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B1D46436B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 00:33:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241053AbhK3Xgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 18:36:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240948AbhK3Xgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 18:36:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E636C061574;
        Tue, 30 Nov 2021 15:33:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C626EB81DA8;
        Tue, 30 Nov 2021 23:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73429C53FC7;
        Tue, 30 Nov 2021 23:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638315192;
        bh=o66XONlC1x/mhPbq0QtOTpAuom5KiJgE2R06gIbJ6u0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=InkOuhknGOxd8N5xl77GeDgAOnq+d/9pm5MdtGHWcXiD9sTnJVSC+xc4sEo3FJqoU
         SyZx5MODcD6z7+PZw9QHimAh4jmTn7gyxrfNXZIcj37ch24ZM1h8jGTNC3FC5lnAXH
         0F8nxyx+5p+7qYuwiB9PYTBuKi/MLq6gwYZ8zpDw0JVz1PN/gd6hDoDpydRQWDj55g
         0o0KQQMPIRKqE5l8ybVeJ05iZ6or3HPiOHmsG3okEVrXRO6t8VEQ7/UWk2bNlRJKUw
         c/YziQvI9SK7U1XmIa5haiobFs7H2BRYswgwTokBF+dDzKe9lkNtm3Jde2TIHgzsVg
         zHwMa+ExPfWGg==
Received: by mail-yb1-f172.google.com with SMTP id y68so57669987ybe.1;
        Tue, 30 Nov 2021 15:33:11 -0800 (PST)
X-Gm-Message-State: AOAM532gpiuM+CJouURZrwPageq/vXVEPPfzAFkWWr6YfYj4ALKW4Ezj
        n+Ne9SBlpNlJEQpmFjO2PNcQ8k8oCflJo3C+CgU=
X-Google-Smtp-Source: ABdhPJyjfnEFhglo0DbcwGwTognFvP2jCytpZFHG6zbtK0Q4Pbjy4fnci8JRQMgx7o6CZV/l6pxSis0dP8fUB6XZ4rc=
X-Received: by 2002:a25:3bc3:: with SMTP id i186mr2912182yba.282.1638315190634;
 Tue, 30 Nov 2021 15:33:10 -0800 (PST)
MIME-Version: 1.0
References: <20211126204108.11530-1-xiyou.wangcong@gmail.com>
 <CAPhsuW4zR5Yuwuywd71fdfP1YXX5cw6uNmhqULHy8BhfcbEAAQ@mail.gmail.com> <YaU9Mdv+7kEa4JOJ@unknown>
In-Reply-To: <YaU9Mdv+7kEa4JOJ@unknown>
From:   Song Liu <song@kernel.org>
Date:   Tue, 30 Nov 2021 15:32:59 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
Message-ID: <CAPhsuW4M5Zf9ryWihNSc6DPnXAq0PDJReD2-exxNZp4PDvsSXQ@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: fix missing section "sk_skb/skb_verdict"
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 29, 2021 at 12:51 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Fri, Nov 26, 2021 at 04:20:34PM -0800, Song Liu wrote:
> > On Fri, Nov 26, 2021 at 12:45 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> > >
> > > From: Cong Wang <cong.wang@bytedance.com>
> > >
> > > When BPF_SK_SKB_VERDICT was introduced, I forgot to add
> > > a section mapping for it in libbpf.
> > >
> > > Fixes: a7ba4558e69a ("sock_map: Introduce BPF_SK_SKB_VERDICT")
> > > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > > Cc: John Fastabend <john.fastabend@gmail.com>
> > > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> >
> > The patch looks good to me. But seems the selftests are OK without this. So,
> > do we really need this?
> >
>
> Not sure if I understand this question.
>
> At least BPF_SK_SKB_STREAM_PARSER and BPF_SK_SKB_STREAM_VERDICT are already
> there, so either we should remove all of them or add BPF_SK_SKB_VERDICT for
> completeness.
>
> Or are you suggesting we should change it back in selftests too? Note, it was
> changed by Andrii in commit 15669e1dcd75fe6d51e495f8479222b5884665b6:
>
> -SEC("sk_skb/skb_verdict")
> +SEC("sk_skb")

Yes, I noticed that Andrii made the change, and it seems to work
as-is. Therefore,
I had the question "do we really need it".

If we do need to differentiate skb_verdict from just sk_skb, could you
please add a
case selftest for skb_verdict?

Also, maybe we can name it as "sk_skb/verdict" to avoid duplication?

Thanks,
Song
