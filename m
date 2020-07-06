Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37EEB216062
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 22:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbgGFUhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 16:37:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgGFUhG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 16:37:06 -0400
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com [IPv6:2607:f8b0:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523C6C061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 13:37:06 -0700 (PDT)
Received: by mail-oi1-x243.google.com with SMTP id w17so32387290oie.6
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 13:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qxuInpeT0zPJ81Anrcmt2sLX1ftg1++39V+NueezsYo=;
        b=bV2U5lx1GZOWJexjjtF82NlU68mdRX31jnCdkCvS68+1fl8Wne3/qEWGuGngdDvQwK
         k5xNocV+mNu7AdErJYmosE7jbf2ohtef+B8brHO3694aaKrS2Etfdvbvfo6mv7RraVzG
         uj+Jqo1/KiNfx+1/18f/8rD0kXtk+xJTpNhEirXz1ZtkJ1dU+LZGta9rDg0uYWQcX8Bk
         LBJKQ0cQf7sfLG4SScuOSVaMpeniTR43Qzc2y1dLT//tKvFxBCvZZ/y4hPJs/3BBfJSj
         /BP5t2+3h+hZrZ8egCJbutVdz5NVmG7RY1cfuFj+n+JZbAZEF5Fi3FzutV3ATEZwPDhi
         xldA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qxuInpeT0zPJ81Anrcmt2sLX1ftg1++39V+NueezsYo=;
        b=PgsfQBZroDSsid6HRB/z51HZa0USyPhWnQ5aGqmd3P1C6G4BawqGp5QoOvOMKGEhN9
         Ov3Y9cMe6CzyPzBx+ne2qPjQVNR5aUh1jKaWSZo1BPFtueWfVV5ApLypm2IBA4dPl1U0
         T1Ya78t4Qq2fTl4Smupey96DgiQvf/3RaeRQNs+ZtQNMOvnn2mmPsDxw5VGApoNpH+D7
         mDjG7UgNg6UexuJS3EBg1m+5eYl7EAokwZxb27Mn+u/owmwaenw6KEYINGgsri7olIQc
         UynSW8erY1Kmr955isRLCFUnJdS4cX2InU/zG7n8/Z6w2BuA+HYDENQtWoko1Me9iKgn
         zj0A==
X-Gm-Message-State: AOAM531SekV0iBbqmiW8yFyd1FmJJYVJImAExDskuw7l+mzVHiY9Vh8E
        hTbb+EVRtY8DRc/QtyW7wXQXbqbmMwwGGkmvfy31Eg==
X-Google-Smtp-Source: ABdhPJyDEw+SzjKlL22HJ8/oMKjyLCyK1GAHS6gZHbrCOpQbYUR9KROo5WTX0ArpxfhKhFtk5moFoa/Bmkpua0AeyI0=
X-Received: by 2002:aca:494d:: with SMTP id w74mr856423oia.97.1594067825776;
 Mon, 06 Jul 2020 13:37:05 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+BqPeVqbgojN+nhYTE0nDcGF2-TfaeqyfPLOF-+DLn5Q@mail.gmail.com>
 <20200620212616.93894-1-zenczykowski@gmail.com> <CALAqxLVeg=EE06Eh5yMBoXtb2KTHLKKnBLXwGu-yGV4aGgoVMA@mail.gmail.com>
 <CAADnVQJOpsQhT0oY5GZikf00MT1=pR3vpCZkn+Z4hp2_duUFSQ@mail.gmail.com>
 <CALAqxLVfxSj961C5muL5iAYjB5p_JTx7T6E7zQ7nsfQGC-exFA@mail.gmail.com> <39345ec1-79a1-c329-4d2e-98904cdb11e1@iogearbox.net>
In-Reply-To: <39345ec1-79a1-c329-4d2e-98904cdb11e1@iogearbox.net>
From:   John Stultz <john.stultz@linaro.org>
Date:   Mon, 6 Jul 2020 13:36:41 -0700
Message-ID: <CALAqxLXNCcXp-dNudZJRYhpbR5BgES6yrYdfRj7pJg3TpeHroA@mail.gmail.com>
Subject: Re: [PATCH bpf v2] restore behaviour of CAP_SYS_ADMIN allowing the
 loading of networking bpf programs
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 6, 2020 at 1:15 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
> On 7/6/20 10:11 PM, John Stultz wrote:
> >    Just wanted to follow up on this as I've not seen the regression fix
> > land in 5.8-rc4 yet? Is it still pending, or did it fall through a
> > gap?
>
> No, it's in DaveM's -net tree currently, will go to Linus' tree on his next pull req:
>
>    https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=b338cb921e6739ff59ce32f43342779fe5ffa732

Great! Much appreciated! Sorry to nag!
-john
