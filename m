Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38619D3D0
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 18:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732444AbfHZQSS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 12:18:18 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34162 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732392AbfHZQSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 12:18:18 -0400
Received: by mail-lj1-f193.google.com with SMTP id x18so15687247ljh.1;
        Mon, 26 Aug 2019 09:18:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GVFZrkNa5UUR53TTYqVUdnzWjJdqvq17wdRF5GnYB84=;
        b=mvq4fVzEBqWRmwNNFOr33PBZtypqUiu3gdvcjCcbyzY695RbFT5DM47S6KqYyEf1V0
         AFq0vnVa0AQpiOd4OWXw8yB6aY3xTOBONG0jtA22j7g9XB7Ce/+lUhykA0F3Cv9YIPgY
         MIOlF8mmf6LU9lGT5jHpA9/31coDq7fTlkGAmrrXi+IMRjggsPLMU1hZqI3E7VGCe0J5
         MwWmW6ImwiuA2infGnbUA+k+ZfAXhz6F9P1R8Xy3zHfngensynO+wiUuTUh15YuQeaf+
         LKPZSWfHBFc7wzkUhLUUtnGa6msXqwW5hYg8/BBJwS+Cvnx3imD8jdAxRwkxuVnfF4Vo
         RYFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GVFZrkNa5UUR53TTYqVUdnzWjJdqvq17wdRF5GnYB84=;
        b=W4x4CdW41GVFE6iuN/kbsYa2HtBJ9AUMbMQ69OcYG0Sa7ED+/Lu9EEecYSGkd7d6sp
         Lznqkxu1DD/bggKyxIVScOhn76EbroJZnnmYVZvFcBMpQ9gPhS14gWNZzTcrJiNXMQ0n
         BXiHsxgt3P/bWqDrZJiw8XOUFBHt/llm1BOyfAHpfN39aZIkU1DQbUS2J7zuZuSznr45
         7YZMECRr8dhQOmKcRW50sE6EUS9XDcAi8gtPHuvBEfaGfBClW00j5tDOtoBCp6o8dtLr
         2W9pWE67lAE8wNFK5s7aruIDtriVDWgEB6yqTu/Olp9br7VgPlfkuii+0ylHaLHSe1Rf
         O3kQ==
X-Gm-Message-State: APjAAAVRpAJYqCFW/4cI5qpgcl8Ip57Jmqr0iJxNE6tGKRExvosioSRP
        SyrUXcU1F/5D0xVGPpFttxRLFuCQscxDuBtxm+A=
X-Google-Smtp-Source: APXvYqxDCcZCSjcR1pZKr6yhlb8QTTv9BjqZSvBJmHsdhYyoygYw4Lh5KD1hzoeroEX8Ya2n2WITI1gV8isikfgPlK0=
X-Received: by 2002:a2e:80d0:: with SMTP id r16mr10856783ljg.17.1566836296144;
 Mon, 26 Aug 2019 09:18:16 -0700 (PDT)
MIME-Version: 1.0
References: <20190824020028.6242-1-jakub.kicinski@netronome.com>
 <CAPhsuW7_dSEPJOdKApQFU-aVmEXgOwmqLS7S1FC4JtnzjR6OiQ@mail.gmail.com> <CAJpBn1z736w5_uv7apwyy82vzcnc9c5Gua_9ZyUy-pSEwnQewA@mail.gmail.com>
In-Reply-To: <CAJpBn1z736w5_uv7apwyy82vzcnc9c5Gua_9ZyUy-pSEwnQewA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 26 Aug 2019 09:18:04 -0700
Message-ID: <CAADnVQ++TEUK=Cb3sCyunFyYFcpXu=NK71P4-1rEWEGCGewU7A@mail.gmail.com>
Subject: Re: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index register
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Song Liu <liu.song.a23@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 26, 2019 at 8:57 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Sun, Aug 25, 2019 at 10:37 PM Song Liu <liu.song.a23@gmail.com> wrote:
> > On Fri, Aug 23, 2019 at 7:04 PM Jakub Kicinski wrote:
> > > From: Jiong Wang <jiong.wang@netronome.com>
> > >
> > > NFP is using Local Memory to model stack. LM_addr could be used as base of
> > > a 16 32-bit word region of Local Memory. Then, if the stack offset is
> > > beyond the current region, the local index needs to be updated. The update
> > > needs at least three cycles to take effect, therefore the sequence normally
> > > looks like:
> > >
> > >   local_csr_wr[ActLMAddr3, gprB_5]
> > >   nop
> > >   nop
> > >   nop
> > >
> > > If the local index switch happens on a narrow loads, then the instruction
> > > preparing value to zero high 32-bit of the destination register could be
> > > counted as one cycle, the sequence then could be something like:
> > >
> > >   local_csr_wr[ActLMAddr3, gprB_5]
> > >   nop
> > >   nop
> > >   immed[gprB_5, 0]
> > >
> > > However, we have zero extension optimization that zeroing high 32-bit could
> > > be eliminated, therefore above IMMED insn won't be available for which case
> > > the first sequence needs to be generated.
> > >
> > > Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
> > > Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> > > Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> > I haven't looked into the code yet. But ^^^ should be
> >
> > Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> >
> > right?
>
> I prefer Review on code I review, ack on code I ack, and sign-off on
> code I co-author.

I believe if you're sending somebody else patch you have to add your SOB
in addition to their 'Author:' and their SOB fields.
