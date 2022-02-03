Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583D14A8A2F
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:36:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbiBCRe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:34:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiBCRe4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:34:56 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9E53C061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 09:34:55 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id w81so11039861ybg.12
        for <netdev@vger.kernel.org>; Thu, 03 Feb 2022 09:34:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KMNFQbwdGKWa7SrNR+/G4kXfIJ6Hav8hTTSgSvsdIzQ=;
        b=aKoVmyy7Hgwm3KyZtanu7xfi7reSj5VKANTMv1XDp4pSiCNhog1gyQ5jeAM5UjaG+J
         vkjhSm6z5n1SPDCzGFL6hGlnlX9l/trmff+DinWFJZujLA+Aacl8C8qVYAof7LfUyMo8
         cMVUtPs2fFgHM7nDyk8oYNJNh8JPeP8r1Wo0O6SvkEptCbB6FOsIcMaAaxkNx/7Yw5V3
         vtmNWEUck+zF/r1wRy+AU5WaALvckLkEW+d+tF0k/DlQ8L6vGmUu3W1UM0u1TsrQMsxa
         Fjzktgyape2Oo3Y0dKZLKkPw54Ho4uu6FFJpsoBvlY/FZLCmAtuqkeRVn0AF+XuIK01y
         mopg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KMNFQbwdGKWa7SrNR+/G4kXfIJ6Hav8hTTSgSvsdIzQ=;
        b=Gy9acNIgJI+X8HMNeNtIwokBjdYa3oAfaypzMs9Lh7aY/yh99bkQe+0M1568qyVB5N
         oWISWju119QgP8AHoARf2tT0+shdh1g/ToPih4eHv+roDrnVjon6YDgbqRWKwj57gidr
         dCj7CIf/OrOj3kOVdRgiUPLq8dxha7qjMLQ8HJ3WA297+Lamcaki6tIOC+TtJ/Nz8X5v
         1ueRAw8c3LPza0qsGh+rDR37maIJONStmPLE3KdMhKsgk8Lx1m2+inGUfmk7ZIRcH4hC
         fBULcflJjLwvFQASESYSCzgGhByx8tj5q0bg9J+ApIHqf7fyH4c7bI9yGPVEEzO0pM2c
         eEEA==
X-Gm-Message-State: AOAM530TW2owC8qhrXeUy/Ff1Ap4F4Ewh8pnxxVXIZnPfNeym3u13Pkx
        +QKYzLmBtMFmxphLp2E4lUGuB7MeKbPlZYhRBc1qPcvnmnEfBS1Sj5k=
X-Google-Smtp-Source: ABdhPJzG/bm/rGgZt1ndP/tfhuvaEBrW5HuMxnii5g0ZYwVEKlvQ5btDh9irnpxlLDGJAvwHuvms5qYplKfVhQC1SQ4=
X-Received: by 2002:a25:4f41:: with SMTP id d62mr48136259ybb.156.1643909694776;
 Thu, 03 Feb 2022 09:34:54 -0800 (PST)
MIME-Version: 1.0
References: <20220203015140.3022854-1-eric.dumazet@gmail.com>
 <20220203015140.3022854-10-eric.dumazet@gmail.com> <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
In-Reply-To: <ee1fedeb33cd989379b72faac0fd6a366966f032.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 3 Feb 2022 09:34:43 -0800
Message-ID: <CANn89iKxGvbXQqoRZZ5j22-5YkpiCLS13EGoQ1OYe3EHjEss6A@mail.gmail.com>
Subject: Re: [PATCH net-next 09/15] net: increase MAX_SKB_FRAGS
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>, Coco Li <lixiaoyan@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 9:26 AM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, 2022-02-02 at 17:51 -0800, Eric Dumazet wrote:
> > From: Eric Dumazet <edumazet@google.com>
> >
> > Currently, MAX_SKB_FRAGS value is 17.
> >
> > For standard tcp sendmsg() traffic, no big deal because tcp_sendmsg()
> > attempts order-3 allocations, stuffing 32768 bytes per frag.
> >
> > But with zero copy, we use order-0 pages.
> >
> > For BIG TCP to show its full potential, we increase MAX_SKB_FRAGS
> > to be able to fit 45 segments per skb.
> >
> > This is also needed for BIG TCP rx zerocopy, as zerocopy currently
> > does not support skbs with frag list.
> >
> > We have used this MAX_SKB_FRAGS value for years at Google before
> > we deployed 4K MTU, with no adverse effect.
> > Back then, goal was to be able to receive full size (64KB) GRO
> > packets without the frag_list overhead.
> >
> > Signed-off-by: Eric Dumazet <edumazet@google.com>
>
> So a big issue I see with this patch is the potential queueing issues
> it may introduce on Tx queues. I suspect it will cause a number of
> performance regressions and deadlocks as it will change the Tx queueing
> behavior for many NICs.
>
> As I recall many of the Intel drivers are using MAX_SKB_FRAGS as one of
> the ingredients for DESC_NEEDED in order to determine if the Tx queue
> needs to stop. With this change the value for igb for instance is
> jumping from 21 to 49, and the wake threshold is twice that, 98. As
> such the minimum Tx descriptor threshold for the driver would need to
> be updated beyond 80 otherwise it is likely to deadlock the first time
> it has to pause.

Are these limits hard coded in Intel drivers and firmware, or do you
think this can be changed ?

I could make  MAX_SKB_FRAGS a config option, and default to 17, until
all drivers have been fixed.

Alternative is that I remove this patch from the series and we apply
it to Google production kernels,
as we did before.
