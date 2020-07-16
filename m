Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0013221B6E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 06:36:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725933AbgGPEgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 00:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgGPEf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 00:35:59 -0400
Received: from mail-vk1-xa43.google.com (mail-vk1-xa43.google.com [IPv6:2607:f8b0:4864:20::a43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4531C061755;
        Wed, 15 Jul 2020 21:35:59 -0700 (PDT)
Received: by mail-vk1-xa43.google.com with SMTP id h190so1003279vkh.6;
        Wed, 15 Jul 2020 21:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Md0I7qZUYOfItQaUHXL1L1O2AfGxevzdjkYatV5C7vg=;
        b=DdAtg4lH9GsswCGXo+CgsHouaJ+G2eQj2PNUfdZtyKsoLsveH+Bbuo9XsFV3cJbc7U
         DYSTA19WVwP3ufiG0oQwyUmSJ+zBcxaRAnThPGRPLo8SE+R1fAIGLdoDUTa+UPEVo0l7
         F86F+wyBfldj6LcJ68x+7pisJ61vn5aqsl9QJQGCMlctYlw69JuKXrBI1GJHp8hUnHXe
         ur/2FkT+CWEpMKbrBI9fQvZy2H7zJzLbbq04tkEI3A/eTnfGWW+sUN9+F7a6CCvwgrXS
         el2RlkK2dWd5R2dyj4cTPicvkX88Sm5L8qaqVzbn0KOdhBrRogi9UFuOPErgJmYr/u8a
         gosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Md0I7qZUYOfItQaUHXL1L1O2AfGxevzdjkYatV5C7vg=;
        b=OO94qFxho1sM8npYIRapPYvy3EM1nXFQxUDfPCJfycdDZg6GuLsQcgOPm/MfsPIqyt
         xb9dbxhf1snmB9uWwMTG510u5b9jXUL6a1eWTRT9Q6uLA67kdhPNHgwelMfiAwcIaZLG
         vJx7jR0iPjhoM7b+wWYIzDh5lIbFOSE/Yq6QWPK+1OmpJgwHAHyafjeXhQEZjpZLFglD
         AVVv7CuR8qf1vAEwEG4EQWWq/KL/WZYBdJ+GaaVIYhAcWxn49vKtIBsHMhGzqnHu1R0d
         vszZ9Tx+zYxK4MzdT5YOp0bng7noLB9/cyhQsWSOuTnyuQ8ogYs3cHGHwb4y4gDhbXBr
         YbzA==
X-Gm-Message-State: AOAM531hrJ60KxNl9a0UKJzT1eNOQrklAfzBadV0/TCSMwwZ8nELgidc
        Qm6972cNpvVWfH0xBA+nJxdTtojBl6Teqozc+xw=
X-Google-Smtp-Source: ABdhPJyFs2cS92i9MiT7gqX1V1cUi1wRjFNO4OQ4Npy0TolsLKqhQAKSEn7ByGbBynG2Gk0l80P+PLhknyYnz93yAys=
X-Received: by 2002:a1f:418f:: with SMTP id o137mr1743334vka.25.1594874158827;
 Wed, 15 Jul 2020 21:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <1594390602-7635-1-git-send-email-magnus.karlsson@intel.com>
 <1594390602-7635-12-git-send-email-magnus.karlsson@intel.com> <fc6e254c-5153-aa72-77d1-693e24b49848@mellanox.com>
In-Reply-To: <fc6e254c-5153-aa72-77d1-693e24b49848@mellanox.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Thu, 16 Jul 2020 06:35:48 +0200
Message-ID: <CAJ8uoz30f_jbtH4bM-YAxyPq2+zqC1CC3c+eQFg-ECwgkOfzSw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 11/14] xsk: add shared umem support between devices
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, jeffrey.t.kirsher@intel.com,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>,
        cristian.dumitrescu@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 12:18 PM Maxim Mikityanskiy
<maximmi@mellanox.com> wrote:
>
> On 2020-07-10 17:16, Magnus Karlsson wrote:
> > Add support to share a umem between different devices. This mode
> > can be invoked with the XDP_SHARED_UMEM bind flag. Previously,
> > sharing was only supported within the same device. Note that when
> > sharing a umem between devices, just as in the case of sharing a
> > umem between queue ids, you need to create a fill ring and a
> > completion ring and tie them to the socket (with two setsockopts,
> > one for each ring) before you do the bind with the
> > XDP_SHARED_UMEM flag. This so that the single-producer
> > single-consumer semantics of the rings can be upheld.
>
> I'm not sure if you saw my comment under v1 asking about performance.
> Could you share what performance numbers (packet rate) you see when
> doing forwarding with xsk_fwd? I'm interested in:
>
> 1. Forwarding between two queues of the same netdev.
>
> 2. Forwarding between two netdevs.
>
> 3. xdpsock -l as the baseline.

Sorry for the delay Max, but it is all due to vacation. I will provide
you with the numbers once the weather turns sour and/or the family
gets tired of me ;-). From what I can remember, it did not scale
perfectly linearly, instead it hit some other bottleneck, though I did
not examine what at that time.

/Magnus

> Thanks,
> Max
>
> >
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> > ---
> >   net/xdp/xsk.c | 11 ++++-------
> >   1 file changed, 4 insertions(+), 7 deletions(-)
> >
> > diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
> > index 05fadd9..4bf47d3 100644
> > --- a/net/xdp/xsk.c
> > +++ b/net/xdp/xsk.c
> > @@ -695,14 +695,11 @@ static int xsk_bind(struct socket *sock, struct sockaddr *addr, int addr_len)
> >                       sockfd_put(sock);
> >                       goto out_unlock;
> >               }
> > -             if (umem_xs->dev != dev) {
> > -                     err = -EINVAL;
> > -                     sockfd_put(sock);
> > -                     goto out_unlock;
> > -             }
> >
> > -             if (umem_xs->queue_id != qid) {
> > -                     /* Share the umem with another socket on another qid */
> > +             if (umem_xs->queue_id != qid || umem_xs->dev != dev) {
> > +                     /* Share the umem with another socket on another qid
> > +                      * and/or device.
> > +                      */
> >                       xs->pool = xp_create_and_assign_umem(xs,
> >                                                            umem_xs->umem);
> >                       if (!xs->pool) {
> >
>
