Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D99C228C21E
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 22:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727298AbgJLUPa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 16:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgJLUPa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 16:15:30 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4D01C0613D0;
        Mon, 12 Oct 2020 13:15:29 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h20so18087591lji.9;
        Mon, 12 Oct 2020 13:15:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AaqfZGksXkb468Gud1+tLV9XuIYPHVuRqNQnRNQ+1J0=;
        b=Bx12m4iA6fQ/goPMrhWvLBufJeqOp+LFvD7RkANGGP8w10/846PuAuCAWsXVMmNDLC
         YoBon8nLG1QDcFXadP/O4plfrTPrnw3UrIzhcUDL0tCvOcH3EmrId1xJLRObfYkc2KUI
         JuEdqCQEt0/fohmh7KfX+HBoyJvmvy6Ajs56PgnUMq1i9ntuYwiTBEZalMJ/75pzVTX/
         dViOdDYVU88Grbn07Bo6Asr3pZXZapPj2aHPfJZP/M/8qB8u4sg0RETZduQo5q2jlXW5
         3Pg3FcHsWMdcgmqukQFliEKo616oU9QvZ/CGzvkofO13xSCkV13mNq69rqBwQm2yynPW
         3a1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AaqfZGksXkb468Gud1+tLV9XuIYPHVuRqNQnRNQ+1J0=;
        b=mmYtU9vGwI+oStZRdjDYeBbTXKB56fIeVjXasCe6EwxFr+qUJXKbvqXHs59ByxoAMh
         UA4iqhiO9WZ/hzNFMSnqVrzUVEqzKtoeJs0pBYLddxAOpDC5oRPs00DzcO5o9djaQq2c
         vWl4Dv88UJfRoMzWgIYAJGo6TnwB83VjXt4EochN3z/1fzWO+Ns5yoei0UUEZJPMV2gi
         CahoTym7cz/IZ+C2MsIF3apFGWLBsYPhLSBNnHNelOZn/S79N+Y/nSirl9cmBvwXnTuW
         xUUUQc3btKhMcEkgBm7ohxh3+WMVmi8DGjO0dhbUpgPHfVeIya2Qcgjg5mP9D5ZIGNKu
         TIjQ==
X-Gm-Message-State: AOAM531vB7DFGZMx1SVuiOck13CZDgoNuTD4egv+jSouNFEQ8QDYydDE
        51MEmAvql8kzAf51jnK8l3QEtcN4uxbN0CyzN1jaHLJgJPi/eg==
X-Google-Smtp-Source: ABdhPJy6QhBZ3ble63R6ZSgUdWmc12/XXvM/YIS/V1g9gawx4lGIyjXcmisHO83owOnuqXj/3hq1vO1Spj83bD64+C8=
X-Received: by 2002:a2e:b8cc:: with SMTP id s12mr4952914ljp.2.1602533727747;
 Mon, 12 Oct 2020 13:15:27 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+ycd8T4nBcnAwr5FHX75_JhWmqdHzXEXwx5udBv8uwiQ@mail.gmail.com>
 <20201012110046.3b2c3c27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201012110046.3b2c3c27@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 12 Oct 2020 13:15:16 -0700
Message-ID: <CAADnVQKn=CxcOpjSWLsD+VC5rviC6sMfrhw5jrPCU60Bcx5Ssw@mail.gmail.com>
Subject: Re: merge window is open. bpf-next is still open.
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 12, 2020 at 11:00 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Sun, 11 Oct 2020 17:59:16 -0700 Alexei Starovoitov wrote:
> > Hi BPF developers,
> >
> > The merge window has just opened.
> > Which would typically mean that bpf-next is closing,
> > but things are going to be a little bit different this time.
> > We're stopping to accept new features into bpf-next/master.
> > The few pending patches might get applied and imminent pull-req into
> > net-next will be sent.
> > After that bpf-next/master will be frozen for the duration of the merge window,
> > but bpf-next/next branch will be open for the new features.
> >
> > So please continue the BPF development and keep sending your patches.
> > They will be reviewed as usual.
> > After the merge window everything that is accumulated in bpf-next/next
> > will be applied to bpf-next/master.
> > Due to merge/rebase sha-s in bpf-next/next will likely be unstable.
> >
> > Please focus on fixing bugs that may get exposed during the merge window.
> > The bpf tree is always open for bug fixes.
>
> FWIW for CIs switching between bpf-next/next and bpf-next/master could
> be somewhat fragile.

CIs can adjust. That's not a big deal, but having two branches definitely
adds a point of confusion to people.
Song proposed earlier to use bpf-next/dev and push patches into /master and
into /dev branches always, so folks/CI can always use bpf-next/dev.
Unfortunately sha-s will be different, so it's not workable.

> Since bpf-next/master is frozen during the merge
> window, why not apply the patches there?

You mean keep pushing into bpf-next/master ?
The only reason is linux-next.
But coming to think about it again, let's fix linux-next process instead.

Stephen,
could you switch linux-next to take from bpf.git during the merge window
and then go back to bpf-next.git after the merge window?
That will help everyone. CIs wouldn't need to flip flop.
People will keep basing their features on bpf-next/master all the time, etc.
The only inconvenience is for linux-next. I think that's a reasonable trade-off.
In other words bpf-next/master will always be open for new features.
After the merge window bpf-next/master will get rebased to rc1.
