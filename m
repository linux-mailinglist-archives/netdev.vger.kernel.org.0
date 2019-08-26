Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79DF29D385
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 17:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732088AbfHZP5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 11:57:41 -0400
Received: from mail-ua1-f68.google.com ([209.85.222.68]:44833 "EHLO
        mail-ua1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfHZP5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 11:57:41 -0400
Received: by mail-ua1-f68.google.com with SMTP id m23so5880262uaq.11
        for <netdev@vger.kernel.org>; Mon, 26 Aug 2019 08:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GFnOT6vgu+r/lhkNN/tQF3NbbQWiENZLqVFsUKVA5rU=;
        b=BMInD5xOvrN2i1SL0H0iqKlICinwarz2/UC6/LzJNY+/qGEXF89sf1f+lUQOpeR8NJ
         jGrnv2++PVMJVjokc31NuRgeM0ObSc6MxtkUlTyYOrQBQ6mOpuj3xtE53u8cFLJoB1Kp
         Z6NnmdQdc4OTbghXq1k8XmPqTS/kpYhuXdQjuenDJtwpPIiY5kcorpFRuryTKSKwaTJw
         O4Opi8YPvYB3rKZfFaE0YxFCVSIEncAk1kEn85a7Uq4HYMCARrcOWX2/dhzZDJhtkePR
         wRUdL8i8g19avjYI7BJA9ifJTjDPQjuEzUovBDZVMwGB5mTgxIn+jZrZLRm+mBCQkKUP
         JUcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GFnOT6vgu+r/lhkNN/tQF3NbbQWiENZLqVFsUKVA5rU=;
        b=JVCCmDsIQVXHHHk9dPXnlOP1qGvURp68tvj2+p00WucivxF6ATQ85kRp2xKcNZTWlq
         C5UiB5zJNciWCmsIEQJwPNvqGvSRo+o/Ot+v1l4SxJYQm++F4cxwr8164N1EvgZqmYCD
         dgqtihdqUbgG/NTZdMZ+3a2fpY0vxNb+LbvFWGlVD44JnFFXM+mltZnBSlyzHiz9EhKC
         CldbYNpU6rFVXI/EZNFJcBJLru37Hf2OmJeF9OpVicQeRAkxZnTMykvWaeedBEfhKfKT
         WpsL2caoLOEKLvr2QKTYcNv+oViFMZ38/gwOTOf5C3KpEOdo33CT9YjxPQCFtCssN6YE
         gGDw==
X-Gm-Message-State: APjAAAW3aGSGFPPnwasRm0amuoVoP2PzACY84SKD1RlCQOjgF6Qj+tWv
        MoL0EQ0K3nnM2ksIArT1Y50RZ7vQTQvA4OIdR4wYZw==
X-Google-Smtp-Source: APXvYqxb9EOME/yS8FxXdJ9AuKzls2c+zYtIBAXjNTg2VvJzAn/Vo1vD5JBG2oa2MXhSHox+v35wp+ejnd+eCrSR7Pk=
X-Received: by 2002:ab0:e19:: with SMTP id g25mr8360418uak.71.1566835060171;
 Mon, 26 Aug 2019 08:57:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190824020028.6242-1-jakub.kicinski@netronome.com> <CAPhsuW7_dSEPJOdKApQFU-aVmEXgOwmqLS7S1FC4JtnzjR6OiQ@mail.gmail.com>
In-Reply-To: <CAPhsuW7_dSEPJOdKApQFU-aVmEXgOwmqLS7S1FC4JtnzjR6OiQ@mail.gmail.com>
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
Date:   Mon, 26 Aug 2019 08:57:17 -0700
Message-ID: <CAJpBn1z736w5_uv7apwyy82vzcnc9c5Gua_9ZyUy-pSEwnQewA@mail.gmail.com>
Subject: Re: [PATCH bpf] nfp: bpf: fix latency bug when updating stack index register
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        OSS Drivers <oss-drivers@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Aug 25, 2019 at 10:37 PM Song Liu <liu.song.a23@gmail.com> wrote:
> On Fri, Aug 23, 2019 at 7:04 PM Jakub Kicinski wrote:
> > From: Jiong Wang <jiong.wang@netronome.com>
> >
> > NFP is using Local Memory to model stack. LM_addr could be used as base of
> > a 16 32-bit word region of Local Memory. Then, if the stack offset is
> > beyond the current region, the local index needs to be updated. The update
> > needs at least three cycles to take effect, therefore the sequence normally
> > looks like:
> >
> >   local_csr_wr[ActLMAddr3, gprB_5]
> >   nop
> >   nop
> >   nop
> >
> > If the local index switch happens on a narrow loads, then the instruction
> > preparing value to zero high 32-bit of the destination register could be
> > counted as one cycle, the sequence then could be something like:
> >
> >   local_csr_wr[ActLMAddr3, gprB_5]
> >   nop
> >   nop
> >   immed[gprB_5, 0]
> >
> > However, we have zero extension optimization that zeroing high 32-bit could
> > be eliminated, therefore above IMMED insn won't be available for which case
> > the first sequence needs to be generated.
> >
> > Fixes: 0b4de1ff19bf ("nfp: bpf: eliminate zero extension code-gen")
> > Signed-off-by: Jiong Wang <jiong.wang@netronome.com>
> > Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> I haven't looked into the code yet. But ^^^ should be
>
> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>
> right?

I prefer Review on code I review, ack on code I ack, and sign-off on
code I co-author.
