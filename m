Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 630933597F2
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 10:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhDIIds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 04:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhDIIds (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 04:33:48 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07562C061760;
        Fri,  9 Apr 2021 01:33:36 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id g10so2385856plt.8;
        Fri, 09 Apr 2021 01:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lhOBDBWPuZntGK3npBwjF9tJqRpBOuEpoer/aWNxmFg=;
        b=Y09a2vq5mi2ZQYJlThD9RajGH/diYLOUtR9/xQX9U6SUCPqK/wxCnztrk1v1pVZc1D
         hrywet7txJlRvP6lniJr6q0VCRHENY9oeNCzfGAq0RVJ1PCUsEDBCGOHmeJ4gCDjI11h
         eXfZ5l7hBvmobuurXnmZjqRrz/ZF+JIgqYTlOWas12GjeWZ7hvM8eGGsHp4IMjkrHAFC
         IAOYYBt9lZU+jPIe/Jvpo7voYvaOhCFE+OJjf9l7iryfgU2YhRKsA+IF56ObAE39MDxG
         je+9ygXL7x7/8TxO4V/t292rOp9fcb+BIf/q+jpWftS6vD+R+hUWhh87hoBH2BXgdspD
         y87g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lhOBDBWPuZntGK3npBwjF9tJqRpBOuEpoer/aWNxmFg=;
        b=V0jZyZE+kQ7Bec6MVip/Su5NX/tZD9MCsR/R+zfLHj8lSSV1y55BYXkOSb8kN7Gnu8
         El8syMBtpfk28+aQw+fbT53jdiDBuK0XEvEVxhSliZQGvxqpEPKDnY5tnvryTQnFXgjc
         sbjPR2EogtmIf1/5tgd1R5js0MU9IvxfeLY14mXHDeFD7uUV+UumNI+OdW+xWpNumCII
         IW6x6VNRG583E685KB4wu8aWjNXkR8/CX9og7uFRmyuB6padnNFD47cpjHbGcghiMDdT
         KI0om5Wsp5ufSBP2Azy65Con/EEiqKqIOEiFN0Wsyn0xfd5XqLA1oFgExZm71eDgb86E
         368g==
X-Gm-Message-State: AOAM53096G4l6II+HtYZU87Nb2zw5dtzxHgsktF5lc8Yiy5GXx3AIWBZ
        VlCsRoFbc/LGWDrkG+klxgHqZb4keKqV10zODkI=
X-Google-Smtp-Source: ABdhPJwuS4ZAMtJki3YgrfFzzHATmAabvAjDG3npjiI+4IePakEZxXK4gGz2F4wPCcIpaZW74KcYH1nFgGDypD8zgNc=
X-Received: by 2002:a17:903:22c7:b029:e6:faf5:eb3a with SMTP id
 y7-20020a17090322c7b02900e6faf5eb3amr11970063plg.23.1617957215608; Fri, 09
 Apr 2021 01:33:35 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_ENNvG=VrD_Z4w+G=4_TCD0Rv--CQAkFUrHWTh4Cz_NT2Q@mail.gmail.com>
 <20210409073046.GI3697@techsingularity.net>
In-Reply-To: <20210409073046.GI3697@techsingularity.net>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 9 Apr 2021 01:33:24 -0700
Message-ID: <CAJht_EPXS3wVoNyaD6edqLPKvDTG2vg4qxiGuWBgWpFsNhB-4g@mail.gmail.com>
Subject: Re: Problem in pfmemalloc skb handling in net/core/dev.c
To:     Mel Gorman <mgorman@techsingularity.net>
Cc:     Mel Gorman <mgorman@suse.de>, jslaby@suse.cz,
        Neil Brown <neilb@suse.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Eric B Munson <emunson@mgebm.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 9, 2021 at 12:30 AM Mel Gorman <mgorman@techsingularity.net> wrote:
>
> Under what circumstances do you expect sk_memalloc_socks() to be false
> and skb_pfmemalloc() to be true that would cause a problem?

For example, if at the time the skb is allocated,
"sk_memalloc_socks()" was true, then the skb might be allocated as a
pfmemalloc skb. However, if after this skb is allocated and before
this skb reaches "__netif_receive_skb", "sk_memalloc_socks()" has
changed from "true" to "false", then "__netif_receive_skb" will see
"sk_memalloc_socks()" being false and "skb_pfmemalloc(skb)" being
true.

This is a problem because this would cause a pfmemalloc skb to be
delivered to "taps" and protocols that don't support pfmemalloc skbs.
