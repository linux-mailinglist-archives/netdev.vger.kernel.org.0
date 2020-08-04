Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9176623BFA5
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 21:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgHDTU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 15:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHDTU2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 15:20:28 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0377C06174A;
        Tue,  4 Aug 2020 12:20:28 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id r4so13153802pls.2;
        Tue, 04 Aug 2020 12:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dSFdfyvPC6qN3rDv8TbLIdSVXhfqaFQjHz20FwFT6s4=;
        b=r+ll7PmoizKu9XtmZtkGbq0jNGXN8IMG93WMrz/7IgmKIkrdXI06yIwr33K3Jcfn79
         jh+nwyPHw0AgsBAbvWkVTtlI0F1bMzE+QjGZXtB40gjgnuT40zzUHqPUC2GMHCs4iCfD
         fkTkVfQg2loFF9ElRGanOwxucIZAG0CR8Nf7rfVI7zuBi4Mph5QV51eXSAF46gINmFL8
         bLO06cSdW/HDOOujKoumRS5T7xHAE9kzV/rXqmnmlhYYjDKCKIAUuG7cQX5C6P/nTCJS
         IjW7rhe8W17Wh++0hBPOToL2tFO7pynMD1NgRi4crXwE/LyHFADYbeNbv2VoJBmlLaR2
         MjLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dSFdfyvPC6qN3rDv8TbLIdSVXhfqaFQjHz20FwFT6s4=;
        b=dHL139Fyp2y/AF2zieaVw4bOXQc1AKWiUTgeXanWItTsLvBnhApWjzhDwcqs9nw0Vo
         9bE99nh+QlOTzRv43oNy+xjgOJMIo4qtGf2TaAzi7BxkOlBhFvBtwUHm0t6YAe5dKxtd
         r/1SpwGIUr/SBdJCYaC7JfZP9YBJw8jWABr4SSNeVJSghll9AyuVYpaQLtNPR96ntYhO
         RYuFvPaqvlDyqYSeduydytfuygfDLgruo2Nmv7DuHIXjJfLJL3PtgH8j2h/Anky1ehs8
         uqIZHMid55lIehKanRhrt3Z0Gyid7CSDoAIFUOKJEA6mcDXDkKoWCgGfpBQG7qWUNF9Q
         MKbQ==
X-Gm-Message-State: AOAM533O9JFSXoW9gXCQW34KcZ7bHZaRUhTm+/FPoXXXLdi4HVAZy0uE
        /mcbadFngJL3t8Hvxe0e7pfbHBf2UXzU9AdjHQE=
X-Google-Smtp-Source: ABdhPJzhOoYnzQNlSb3CDxdjRi1S4lk3uOnUvLdZUZa3f8bxI07qa5iX1j49wdYivrj6t4D5oCc7OVzDtLOFPLa4oyc=
X-Received: by 2002:a17:90b:11c4:: with SMTP id gv4mr5861511pjb.198.1596568828216;
 Tue, 04 Aug 2020 12:20:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200802195046.402539-1-xie.he.0141@gmail.com> <d02996f90f64d55d5c5e349560bfde46@dev.tdt.de>
In-Reply-To: <d02996f90f64d55d5c5e349560bfde46@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Tue, 4 Aug 2020 12:20:17 -0700
Message-ID: <CAJht_ENuzbyYesYtP0703xgRwRBTY9SySe3oXLEtkyL_H_yTSQ@mail.gmail.com>
Subject: Re: [net v3] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Brian Norris <briannorris@chromium.org>,
        netdev-owner@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 5:43 AM Martin Schiller <ms@dev.tdt.de> wrote:
>
> I'm not an expert in the field, but after reading the commit message and
> the previous comments, I'd say that makes sense.

Thanks!

> Shouldn't this kernel panic be intercepted by a skb_cow() before the
> skb_push() in lapbeth_data_transmit()?

When a skb is passing down a protocol stack for transmission, there
might be several different skb_push calls to prepend different
headers. It would be the best (in terms of performance) if we can
allocate the needed header space in advance, so that we don't need to
reallocate the skb every time a new header needs to be prepended.
Adding skb_cow before these skb_push calls would indeed help
preventing kernel panics, but that might not be the essential issue
here, and it might also prevent us from discovering the real issue. (I
guess this is also the reason skb_cow is not included in skb_push
itself.)
