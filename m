Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD793145CB
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 02:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbhBIBqF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 20:46:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbhBIBqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 20:46:03 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B753C061786;
        Mon,  8 Feb 2021 17:45:23 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id t25so11471248pga.2;
        Mon, 08 Feb 2021 17:45:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ylaceuEa/Vzdn6V3R3jlGmaJ+hDPnSL+OVK3bN0IhUs=;
        b=Zey/9qn5ESKWUjjG7RQUp7VtO10lHZ/SLCoic2QydlCHqqXEcPwoAJlMGcKawv++Vk
         u4uO4oMF5Zj2NW76T2absBE+uGcGkOfwQig8sjsrGDDtnJJZStxIJzZzcmv7vR43yuo+
         RXzEu0dnRnk1PzNl3W/RxKMx46JimtXqMJxf0gDrKXmf07v1jML6ui6LVHyyHhUNNyLO
         72anuLSdcyq9AXATAMid5OFfDghTnpFrMWv6UjqdIRVO3OOvCyc69upxOV+o5B8lXg6s
         l40fp5UYvFcp1xdxwhtyLgBHsXfmf5jbEHsJpNrW5W39M2npHoIc17lEwWqj8bPBIdRU
         8APg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ylaceuEa/Vzdn6V3R3jlGmaJ+hDPnSL+OVK3bN0IhUs=;
        b=RJbpgdSWo4U0AbaOuCLZf/rNWJV/5GVDKGZndtNDie0ppTvtigdnm1vXLs+WME/U6B
         N+hhzemj1pxNZtX8o9qP0Qjjjorpsui0hGBxCfejg2nQwRBmsKHLeBazFqS5//kKoHiK
         kBkiRfUQrNfK4o4iVwuNHBdCY3/KkhehjUjFY4r9ugtxx9dPnqcxFftKExTpBND074Jp
         IJKz4bJhHf4jmVSQyfa4ySgOV0A+dk4ZCyFWmT8EUZdHLFvNkBxm12I75cUjpyfj4QvG
         mCwUjz2AG2lpUuu6hX6+NwnDkAVBD2YLd3lFctrdjcCryik5DhtDiOCarJzg5YANwDGJ
         tXSQ==
X-Gm-Message-State: AOAM530Dx+hCat1eF+97a+sz4LL8ASWhetHabds0zoNih2rkSbWVlr63
        64DfUPplDc0Cxo9nXS2Q1z6kFaQIWjYyOayvCbQ=
X-Google-Smtp-Source: ABdhPJxzqxeb6Ejx+uYYx7LhRgDp4LNTxk9KUbqAXnPNl0hfM9CMHg/rayCNkUD0QcS2ChuPM5jNDgM3PpdITNwCpNo=
X-Received: by 2002:a62:ed01:0:b029:1c8:c6c:16f0 with SMTP id
 u1-20020a62ed010000b02901c80c6c16f0mr20578967pfh.80.1612835122743; Mon, 08
 Feb 2021 17:45:22 -0800 (PST)
MIME-Version: 1.0
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-2-xiyou.wangcong@gmail.com> <6020f4793d9b5_cc86820866@john-XPS-13-9370.notmuch>
In-Reply-To: <6020f4793d9b5_cc86820866@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 8 Feb 2021 17:45:11 -0800
Message-ID: <CAM_iQpWu8PMbSTfsifBy9j9BLrMn69H2fFkjdRVpGGtbmUURFw@mail.gmail.com>
Subject: Re: [Patch bpf-next 01/19] bpf: rename BPF_STREAM_PARSER to BPF_SOCK_MAP
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 12:21 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > Before we add non-TCP support, it is necessary to rename
> > BPF_STREAM_PARSER as it will be no longer specific to TCP,
> > and it does not have to be a parser either.
> >
> > This patch renames BPF_STREAM_PARSER to BPF_SOCK_MAP, so
> > that sock_map.c hopefully would be protocol-independent.
> >
> > Also, improve its Kconfig description to avoid confusion.
> >
> > Cc: John Fastabend <john.fastabend@gmail.com>
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Cc: Lorenz Bauer <lmb@cloudflare.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> The BPF_STREAM_PARSER config was originally added because we need
> the STREAM_PARSER define and wanted a way to get the 'depends on'
> lines in Kconfig correct.
>
> Rather than rename this, lets reduce its scope to just the set
> of actions that need the STREAM_PARSER, this should be just the
> stream parser programs. We probably should have done this sooner,
> but doing it now will be fine.

This makes sense, but we still need a Kconfig for the rest sockmap
code, right? At least for the dependency on NET_SOCK_MSG?

>
> I can probably draft a quick patch tomorrow if above is not clear.
> It can go into bpf-next outside this series as well to reduce
> the 19 patches a bit.

I can handle it in my next update too, like all other feedbacks.

Thanks.
