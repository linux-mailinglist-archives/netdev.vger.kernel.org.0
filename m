Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2636F20EAB5
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 03:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgF3BJB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 21:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726813AbgF3BJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 21:09:00 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C020C061755;
        Mon, 29 Jun 2020 18:09:00 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id c139so17109084qkg.12;
        Mon, 29 Jun 2020 18:09:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mLqvYSAOGnkTKKYIcxSTIKl3JTY1Fv2qmcuy1k1Azeg=;
        b=B3JoUf1YgHc4MHMOhpP9lktcjR0y4ZljdmXeC+bguk6LUbZC2spe71wUCrYBbFBP+Q
         0EcZo3g4a2uqW3bd4B8BL2RwQPAqXMEehsR+89t5l13QUJqFcVbZ9FpgZhb7wG1FIUmy
         UT3h9N9D2vMAOUGA7ZvzYBLZzEYhxivOURnROt3Tcri8SQgLC5tRtcBdRYKda7OdnRZv
         /EQcsaVu4DpjpQM+wQHYTFy39iEFjj1VV+s6JTCO4H3iTheE9EiaTpaonlXTIn/bav6Q
         2VKqOaqFGekB/QRcPFs9kpbe1YB6Of/uLtyOw/9LmFfFQC82SakFMS/jk4ZILlCPbMyN
         LIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mLqvYSAOGnkTKKYIcxSTIKl3JTY1Fv2qmcuy1k1Azeg=;
        b=jgLd8MLgF8o/Dk2hpePu6Me1hMUa8VNgR7EhhU/4HeQiQjbP1ZBNwkpUdlnDarDu+f
         Eros70IbR47PYCsa5+gQfwCr+wK8L83aeYq6+7GsmfoEjaifgf/vwGlYAK0xsAupdg7M
         sRlizMMctE3H7Mu1OyiMxvWHj5fGWb2uy+PDN1XqmYBb3CZiGP7aUmRaziRMfAYWkBzo
         Y2vu3JEeAgQKCOEADA33tpvsK/kCarQFj0bhgRlGTBWg3RWWcyK8ID3qan6A14PIw4eP
         eXhuGWRNTRbx9EPhrqxf05rwlDxuLpk+Kg18b7akjUUCe9pDTQkDLGKDBh/0zCIU294U
         6s1w==
X-Gm-Message-State: AOAM532YaNbZCQue0yRtVmJmBNubWYXh2BWg1dMRcXZqyfTi82oAU2Vs
        mPrCGrO9LQNWdVPHvPBdB9E0TMxyjSoUd+9tTTM=
X-Google-Smtp-Source: ABdhPJyaBMzIHXVQK436zhFkesRV7XvOtQCfVVM3ZaGPXOd1W9IVVO5IA3wCh16oo7KLqbgehjK+/iMafJA07WhAzW4=
X-Received: by 2002:a37:270e:: with SMTP id n14mr16602479qkn.92.1593479339561;
 Mon, 29 Jun 2020 18:08:59 -0700 (PDT)
MIME-Version: 1.0
References: <20200630003441.42616-1-alexei.starovoitov@gmail.com>
 <20200630003441.42616-2-alexei.starovoitov@gmail.com> <CAEf4BzaLJ619mcN9pBQkupkJOcFfXWiuM8oy0Qjezy65Rpd_vA@mail.gmail.com>
In-Reply-To: <CAEf4BzaLJ619mcN9pBQkupkJOcFfXWiuM8oy0Qjezy65Rpd_vA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 29 Jun 2020 18:08:48 -0700
Message-ID: <CAEf4BzZ4oEbONjbW5D5rngeiuT-BzREMKBz9H_=gzfdvBbvMOQ@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 1/5] bpf: Remove redundant synchronize_rcu.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 29, 2020 at 5:58 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Jun 29, 2020 at 5:35 PM Alexei Starovoitov
> <alexei.starovoitov@gmail.com> wrote:
> >
> > From: Alexei Starovoitov <ast@kernel.org>
> >
> > bpf_free_used_maps() or close(map_fd) will trigger map_free callback.
> > bpf_free_used_maps() is called after bpf prog is no longer executing:
> > bpf_prog_put->call_rcu->bpf_prog_free->bpf_free_used_maps.
> > Hence there is no need to call synchronize_rcu() to protect map elements.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> > ---
>
> Seems correct. And nice that maps don't have to care about this anymore.
>

Actually, what about the map-in-map case?

What if you had an array-of-maps with an inner map element. It is the
last reference to that map. Now you have two BPF prog executions in
parallel. One looked up that inner map and is updating it at the
moment. Another execution at the same time deletes that map. That
deletion will call bpf_map_put(), which without synchronize_rcu() will
free memory. All the while the former BPF program execution is still
working with that map.

Or am I missing something that would prevent that?

> Acked-by: Andrii Nakryiko <andriin@fb.com>
>
> >  kernel/bpf/arraymap.c         | 9 ---------
> >  kernel/bpf/hashtab.c          | 8 +++-----
> >  kernel/bpf/lpm_trie.c         | 5 -----
> >  kernel/bpf/queue_stack_maps.c | 7 -------
> >  kernel/bpf/reuseport_array.c  | 2 --
> >  kernel/bpf/ringbuf.c          | 7 -------
> >  kernel/bpf/stackmap.c         | 3 ---
> >  7 files changed, 3 insertions(+), 38 deletions(-)
> >
