Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48A053A14FE
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 14:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235407AbhFIM7G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 08:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232250AbhFIM7F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Jun 2021 08:59:05 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB1BC061574;
        Wed,  9 Jun 2021 05:57:10 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id p17so37084402lfc.6;
        Wed, 09 Jun 2021 05:57:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EUFkdCp0yijnaiM+M5ioxTqAM8NHB8uJhq8JDujxpQI=;
        b=Kjv1/ovreUd4Zlh2PQOXrt571kGplowG8aG8+p29v0QXUuY9h+c0LVY2iMjtFlMmmB
         daEwKddBXuxfqexytPiquQyRJTVCGx67Qt0zsd0EB7gMfeXO7CoxP5xpsbRlyvzVNlHj
         ar01H4k8U9mkRwYjQ8Atyq3YfTaEeFf2upz8W/hluHvotti/Iwv21MV6vDvFbmiUR8aC
         em7y1BC1JQhDqRDwWhf+mpQ9zIlnrTd5nm0UEJyWTPrrILYTAyitsbSocF3BfZ6w8fcw
         1/LMRHyy2rdtcda7p7UkSPpPuroQRZfsw937kmpJVgrIETq8fZkF8ywH7YwFGaa0+cCF
         KFiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EUFkdCp0yijnaiM+M5ioxTqAM8NHB8uJhq8JDujxpQI=;
        b=nWSByRQEh8nWyula+l+rtMFigLY1Rol8eaWPKawzXwTsIMR0McKDvTtf+wzL3pwl7f
         r5GbBeXRvDDP77TgrPBHU1tiVtpRSHtHQSWaleHCY5OnaTTDGR4diyOBRKIakywPHrOw
         Q2AId0fiKsP1N5K3OW0P185OfU/rEyHPZAqUOmI6vZXPhEV42XDDsMVeYars9cLbUm3U
         zeVhTHzBxxa0Nvt4Q2N/iLvBIT12LT7yjTClp+shMUOAXqMtnsp47bJ6+hT7BNMIHTI0
         gqsdV41VgGRReSa3h5a1msHwRtgPFm800kbu5EZDmsfjujK7OwDBFCzd+LYS9QpR6MdC
         ExQw==
X-Gm-Message-State: AOAM531eSo4Kzt0A0FTqEeJnyeuqd2Dwo2eUBtYeHEpNCNYo4GmgO2jl
        SF4It5TrcmSYxTXiViqHCpkWIImyYkPZSIfHt68=
X-Google-Smtp-Source: ABdhPJwsvgU4LcnW068X6sN9ugadBVbOydtU1NEXPACF98lGchSYdma10I+aq3kHdmBEF4A3fmNQGjwc5xi/t9TjdWs=
X-Received: by 2002:a05:6512:3324:: with SMTP id l4mr15260023lfe.273.1623243428863;
 Wed, 09 Jun 2021 05:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210609103251.534270-1-dong.menglong@zte.com.cn> <672e78df-5bb0-78eb-3022-f942978138f5@redhat.com>
In-Reply-To: <672e78df-5bb0-78eb-3022-f942978138f5@redhat.com>
From:   Menglong Dong <menglong8.dong@gmail.com>
Date:   Wed, 9 Jun 2021 20:56:57 +0800
Message-ID: <CADxym3ZCV94BzHviTxK1G5Kt1Z+1LbbNr6=B=9GjBqGfzrk_Kw@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/2] net: tipc: fix FB_MTU eat two pages and
 do some code cleanup
To:     Jon Maloy <jmaloy@redhat.com>
Cc:     ying.xue@windriver.com, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        tipc-discussion@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>,
        Menglong Dong <dong.menglong@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 6:47 PM Jon Maloy <jmaloy@redhat.com> wrote:
>
>
>
> On 6/9/21 6:32 AM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <dong.menglong@zte.com.cn>
> >
> > In the first patch, FB_MTU is redefined to make sure data size will not
> > exceed PAGE_SIZE. Besides, I removed the alignment for buf_size in
> > tipc_buf_acquire, because skb_alloc_fclone will do the alignment job.
> >
> > In the second patch, I removed align() in msg.c and replace it with
> > ALIGN().
> >
> >
> >
> >
> > Menglong Dong (2):
> >    net: tipc: fix FB_MTU eat two pages
> >    net: tipc: replace align() with ALIGN in msg.c
> >
> >   net/tipc/bcast.c |  2 +-
> >   net/tipc/msg.c   | 31 ++++++++++++++-----------------
> >   net/tipc/msg.h   |  3 ++-
> >   3 files changed, 17 insertions(+), 19 deletions(-)
> >
> NACK.
> You must have missed my last mail before you sent out this.  We have to
> define a separate macro for bcast.c, since those buffers sometimes will
> need encryption.
> Sorry for the confusion.

No, no, I didn't miss your mail. I think it can make us clear about what and how
to do by sending the V2 patches.

So we can define two versions 'FB_MTU' for bcast.c and msg.c, such as CRYPTO_MTU
and NON_CRYPTO_MTU. And within tipc_buf_acquire(), we decide which version
BUF_HEADROOM to use by the data size? Such as:

int buf_size;
if (IS_ENABLED(CONFIG_TIPC_CRYPTO) && size == NON_CRYPTO_MTU) {
    buf_size = size + BUF_HEADROOM_non-crypto + BUF_TAILROOM_non-crypto;
} else {
    buf_size = size + BUF_HEADROOM_crypto + BUF_TAILROOM_crypto;
}

Is this feeling?
(It's a little weird to check whether the data should be crypto by data size).

Thanks!
Menglong Dong
