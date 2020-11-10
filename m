Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB0E2AD040
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 08:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbgKJHNI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 02:13:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727019AbgKJHNF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 02:13:05 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABCF3C0613CF;
        Mon,  9 Nov 2020 23:13:05 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id r10so9359239pgb.10;
        Mon, 09 Nov 2020 23:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZPFe2WuiWwyNg1Eyj3XJGsLb5Wa+6AC1ZklocEhohjk=;
        b=LW4ny0aDBseDwZ76K9DKeQOHEHyHurl/nH8zVm9oq4gw3hcIQnEjTIVQzx01YG6MAq
         OQY/3QH+NaZAieNoZmYuUPUzzMz45JXLzqk16njQnUQdVMz8+Oohl8/vftFwrd5DogF1
         RgD3k6j8EWApfYjwY6SQy0Ig2uJn4nq8n3a3pIuKVUjQYBnS5Tl0zSldv42Sc7vy3TdO
         0FERJ5P7UBQakCZ6KBvmrbcSsLJ0AtuDYORTC7NgZIWvUMu0VnVBwj6fX296zTCOZPC+
         9ubJsOCWlqPCWt9jpz8TzyWq2qOHNGRujamCmMWKpRdbXqclCh4ODJ3/zuNTqeECEbiY
         OF2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZPFe2WuiWwyNg1Eyj3XJGsLb5Wa+6AC1ZklocEhohjk=;
        b=uejDGxTIYSEmA+oBb/Kmiv1KiJhrhgO7Jnt2afMXC05wlWi/Qp/vxlCumaHwLagxyC
         ljp38JX3mluiPprikDnVIhfAp0GUrkjErSLMgaqhStt4YeD+RzQLBc8perNpPKn767Y8
         TUGaL+Af0jcfSWoci2cYHOKEhNB3nQXU51iFT7v9221yUu39cmBQjpF8RS3w19wAjute
         79ldx+YZIr72XGvMJzz0/0dBxNYJFTEaBcFrkVuCcfJZY4Mt4fbaDxLIIS00ALtsYebd
         B+jHE0nbDz1uAK6O951QTVxWQEfduVLXfzpAPtz+FnmX4nSfNFcDlEZj/bytSMSyUoz7
         lTGA==
X-Gm-Message-State: AOAM533oHHXzq1+hT4ARwuuCILytDN+FDTYPPiXWkoZqYLg3WWmjkgaw
        0e9FXsBj5IAwiNtuvoNejAds7XQPjvMadM+THsY=
X-Google-Smtp-Source: ABdhPJwdKvbB69qXEgdZwN3837DsoGBC4vJQh8ZB1EElebgRlZqRjGhXE6kbQreHcgynDvusc9yZdtBUmsuH6ozwGTw=
X-Received: by 2002:a62:2bd0:0:b029:18a:df0f:dd61 with SMTP id
 r199-20020a622bd00000b029018adf0fdd61mr16448462pfr.19.1604992385197; Mon, 09
 Nov 2020 23:13:05 -0800 (PST)
MIME-Version: 1.0
References: <1604498942-24274-1-git-send-email-magnus.karlsson@gmail.com>
 <1604498942-24274-3-git-send-email-magnus.karlsson@gmail.com> <5fa9aae46c442_8c0e208b5@john-XPS-13-9370.notmuch>
In-Reply-To: <5fa9aae46c442_8c0e208b5@john-XPS-13-9370.notmuch>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Tue, 10 Nov 2020 08:12:54 +0100
Message-ID: <CAJ8uoz1f=-2Dysg-iwo=Grn0eS5nJB0hNE8HuPeHYPgeE4Bfmg@mail.gmail.com>
Subject: Re: [Intel-wired-lan] [PATCH bpf-next 2/6] samples/bpf: increment Tx
 stats at sending
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 9, 2020 at 9:47 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Magnus Karlsson wrote:
> > From: Magnus Karlsson <magnus.karlsson@intel.com>
> >
> > Increment the statistics over how many Tx packets have been sent at
> > the time of sending instead of at the time of completion. This as a
> > completion event means that the buffer has been sent AND returned to
> > user space. The packet always gets sent shortly after sendto() is
> > called. The kernel might, for performance reasons, decide to not
> > return every single buffer to user space immediately after sending,
> > for example, only after a batch of packets have been
> > transmitted. Incrementing the number of packets sent at completion,
> > will in that case be confusing as if you send a single packet, the
> > counter might show zero for a while even though the packet has been
> > transmitted.
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
>
> LGTM. Just one question then if we wanted to know the old value, packet
> completion counter it looks like (tx_npkts - outstanding_tx) would give
> that value?

That is correct.

> Acked-by: John Fastabend <john.fastabend@gmail.com>
