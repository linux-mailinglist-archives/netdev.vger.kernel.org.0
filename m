Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D19304932B0
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 03:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350847AbiASCFJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 21:05:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350404AbiASCFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 21:05:08 -0500
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9DDCC061574
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:05:07 -0800 (PST)
Received: by mail-yb1-xb36.google.com with SMTP id m6so2634909ybc.9
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 18:05:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VQdsEe+ak/PgSRoUo06sVFbkn2BbfGP2zqV4F0AW4R4=;
        b=nM9l/qqJakDUMNQezg6hDu6oA1IF5Zt4m5I3ZOkI/8+uL8fP8qNYb2vU7wi3TldMiV
         hPUxm2SFunk5EHBOnTVuhAymoySA1NIPnP+oETwZFmfsM8MyjRAx4geivRFXuHDlZxjU
         ZyGMbfHKj92VWkoQpY+aRL+ZKQLFAbTDd20T4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VQdsEe+ak/PgSRoUo06sVFbkn2BbfGP2zqV4F0AW4R4=;
        b=KPfHAsNOXUsiuE2A+ECAJI7od/A5kPFlLSvuvbcdgAaHTgafQb80WSxB6rnvogET4F
         AaUouh2XqA++XfZ0nGrUFsu7cqblAqkXWmCuXoOpqFvgzTgzVcVw/bhIzVe3yeggiRQd
         DtIBpvqdXXhEyJdG6kRB/ow7d6RBaRBnQsA6W3rSWtfLijzMmdII+BQKpzW6pNa0eAtD
         AU8QSBStXWoucc6xERWqMQbDk8CgJCuBi+aqS+fszRzLDtGgf8qyRrQJqbNUI9L80mBg
         eJ2hjLTbdSsdsYQ/NOiTRk9zhBvyhKJVty2IZgDf2jGIvmSEi3IA98NBnakBJRclaaD7
         gzhg==
X-Gm-Message-State: AOAM533jQaiQerVMopU7ISClllwd51fcQ4wiGSjRrD3//6U0SwS2KOtt
        WVlUKCuRwmGoji0Jd2sl5PLfbuAY9/dHuKYfG32MAQ==
X-Google-Smtp-Source: ABdhPJxIj2C0Cha69QfweKbPdBB2VEwyAVVXFjFXzYHW+FjgKpYwl71lIpRV3vp3gt9cxAOoyCI2byIlgVOS/Kk97SU=
X-Received: by 2002:a5b:a01:: with SMTP id k1mr17361381ybq.433.1642557906924;
 Tue, 18 Jan 2022 18:05:06 -0800 (PST)
MIME-Version: 1.0
References: <CABWYdi1a7MKxM8XX9_1zRkp_h8AHGWT_GQTwAbJdz0iKEfrsEA@mail.gmail.com>
 <3776.1642550885@famine> <CABWYdi3rg+=GCNqPZ2ss=WRQtZ-onQFOqqTwkLxC-HGesZTiLA@mail.gmail.com>
In-Reply-To: <CABWYdi3rg+=GCNqPZ2ss=WRQtZ-onQFOqqTwkLxC-HGesZTiLA@mail.gmail.com>
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Tue, 18 Jan 2022 18:04:56 -0800
Message-ID: <CABWYdi3SEvO0yLS7vxiXBufoTBy5ZZzQoBeoSU2wQeSa-snnwA@mail.gmail.com>
Subject: Re: Empty return from bond_eth_hash in 5.15
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jussi Maki <joamaki@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        kernel-team <kernel-team@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Moshe Tal <moshet@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 4:15 PM Ivan Babrou <ivan@cloudflare.com> wrote:
> > commit 429e3d123d9a50cc9882402e40e0ac912d88cfcf (HEAD -> master, origin/master, origin/HEAD)
> > Author: Moshe Tal <moshet@nvidia.com>
> > Date:   Sun Jan 16 19:39:29 2022 +0200
> >
> >     bonding: Fix extraction of ports from the packet headers
> >
> >     Wrong hash sends single stream to multiple output interfaces.
> >
> >         which was just committed to net a few days ago; are you in a
> > position that you'd be able to test this change?
>
> Absolutely, I'll give it a try and report back.

Looks good:

$ sudo bpftrace -e 'kprobe:__bond_xmit_hash { @skbs[pid] = arg1 }
kretprobe:__bond_xmit_hash { $skb_ptr = @skbs[pid]; if ($skb_ptr) {
$skb = (struct sk_buff *) $skb_ptr; $ipheader = ((struct iphdr *)
($skb->head + $skb->network_header)); printf("%s %x\n",
ntop($ipheader->daddr), retval); } }' | fgrep --line-buffered
x.y.z.205
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b
x.y.z.205 215fec1b

Hope it lands into the 5.15 stable queue as well.
