Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83C82F428F
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 04:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAMDgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 22:36:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725917AbhAMDgq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 22:36:46 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13388C061575
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 19:36:00 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id 22so463408qkf.9
        for <netdev@vger.kernel.org>; Tue, 12 Jan 2021 19:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mfz4umtCD9kGNYUYmm5FDO8p0FURTK29N0mRSudPVJI=;
        b=FtC+Tzj3g52ZaNDhzd5EHbkVOi36+SKcQ1DwTr5Ax3jr/hEoiiuus9/TV1p4pnmHYa
         wdmx1qAQMvfuUNAHIxLNTyxuFwI07LkCp2Jck5v9futhCbKtVH1Lp+Ti3Win9WerqIzR
         ozW2KgZw7YKbVrQb6PYRi+57BEE3lbX53C0sBEjQgpoY9ZoFn6KufS3dI/7kueDodeut
         sppyR73dqSYW7OT/BRHm9lfdVY5RF9G+Eg/g4/r7Sq3fVkSFoekrYKTrjFhu9fhnX1EK
         r9PeGSc33uodQ1pRAscd4xBRP3FOwbe1H7OeRyWd0gx+b8pM+FZlQ3+ekM2imXy4M0Pw
         vF2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mfz4umtCD9kGNYUYmm5FDO8p0FURTK29N0mRSudPVJI=;
        b=Nk4EvUx3ZlqyxNteh/BwMxi8WPpCNx1HfVqH4sSNsaE09rLBveICQHNCLXQ3k6V9kO
         ZCTuUinqBzDtxzJWYjSNDCTRz6wvLWwfp0Fo1ulRKWNDNF5lgoRYA68wRx2wtTxcgg8+
         f0VYjBRBq9KpPn1LUYdZgngHfcQ2xlU6eBz13mGHNgOjHhc99uiBZszXbKp5hrVZ/tvk
         o+/6MzqV3zSv76KV3bUp4SOq6SKQjM+W+kiwjwDWIXx1SOlGwaSucWeuOkyINATMsIP0
         29v/So5r0lN+PbHwgZxuhGisd/AYQSku3Y8ranI3BAXA3fvXA+TRWCFI5q/OOv1YlcDg
         YCsw==
X-Gm-Message-State: AOAM5328MfLlWdpV9TZd7lsMXwFRzxMLWAv4ip9NPBDC2JLwXHuWZGlZ
        fRggaTGnrEbz0tOnmYl90NR9JiVG1PGly+t/r1U=
X-Google-Smtp-Source: ABdhPJwazPNfBVoi/wl6MY0174GumC9zOS5Z0jTP26o9lUsNFGzdtbMEieRI7lcY7edI771XUvX8k8qec8nbNLE6VFc=
X-Received: by 2002:a37:a297:: with SMTP id l145mr3048029qke.344.1610508959107;
 Tue, 12 Jan 2021 19:35:59 -0800 (PST)
MIME-Version: 1.0
References: <20210106175327.5606-1-rohitm@chelsio.com> <20210106111710.34ab4eab@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
In-Reply-To: <3d94bd63-dee0-3699-8e42-193e652592fa@chelsio.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 12 Jan 2021 19:35:48 -0800
Message-ID: <CAKgT0UcbYhpngJ5qtXvDGK+nqCgUqa9m3CHBT0=ZeFxCvRJSxQ@mail.gmail.com>
Subject: Re: [net] net: feature check mandating HW_CSUM is wrong
To:     rohit maheshwari <rohitm@chelsio.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, secdev@chelsio.com,
        Alexei Starovoitov <ast@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>, andriin@fb.com,
        tariqt@nvidia.com, Eric Dumazet <edumazet@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, ap420073@gmail.com,
        Jiri Pirko <jiri@mellanox.com>, borisp@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 12, 2021 at 6:43 PM rohit maheshwari <rohitm@chelsio.com> wrote:
>
>
> On 07/01/21 12:47 AM, Jakub Kicinski wrote:
> > On Wed,  6 Jan 2021 23:23:27 +0530 Rohit Maheshwari wrote:
> >> Mandating NETIF_F_HW_CSUM to enable TLS offload feature is wrong.
> >> And it broke tls offload feature for the drivers, which are still
> >> using NETIF_F_IP_CSUM or NETIF_F_IPV6_CSUM. We should use
> >> NETIF_F_CSUM_MASK instead.
> >>
> >> Fixes: ae0b04b238e2 ("net: Disable NETIF_F_HW_TLS_TX when HW_CSUM is disabled")
> >> Signed-off-by: Rohit Maheshwari <rohitm@chelsio.com>
> > Please use Tariq's suggestion.
> HW_TLS_TX feature is for both IPv4/v6. And If one device is limited to
> support only IPv4 checksum offload, TLS offload should be allowed for
> that too. So I think putting a check of CSUM_MASK is enough.

The issue is that there is no good software fallback if the packet
arrives at the NIC and it cannot handle the IPv6 TLS offload.

The problem with the earlier patch you had is that it was just
dropping frames if you couldn't handle the offload and "hoping" the
other end would catch it. That isn't a good practice for any offload.
If you have it enabled you have to have a software fallback and in
this case it sounds like you don't have that.

In order to do that you would have to alter the fast path to have to
check if the device is capable per packet which is really an
undesirable setup as it would add considerable overhead and is open to
race conditions.
