Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F92A390BC3
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 23:46:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233492AbhEYVsG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 17:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbhEYVsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 17:48:06 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3419C061574;
        Tue, 25 May 2021 14:46:34 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id c196so23505096oib.9;
        Tue, 25 May 2021 14:46:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WrsMci1wux9x4oI1lZdnvMAiZAs7nx/+sDW4BJc2oWA=;
        b=Si4cDta1BaFLKWOnZTfednW3oPeIYwPrAYErfx/uBNx8GOYakG4Rdi62QgD2+KXZD6
         WTmG0nmBb3Ali1rDDWc4iuNpvDoUJR4K+P11tAEG3GYah+CmkTQ+ssA1L3Bk7EAvb/ba
         UnK9IGRnhRLL1xXh8R4+N7CxFLYD79BDD5zlNJZJtov6JoJXfxJoQDSCYSG2iyCDJty8
         kQF0v5CE4Aj+S5vYZs0X1KnHyfoLq6tWQpzRFcQpI83hJTq53MyddUxpDprQke1jhet1
         +yIOElA0LcutYsh7XSW5Oe8R4Jlm7Pf0ibc8wP6+OYNPkehesVaURecbs3nlBViVRBwt
         DeUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WrsMci1wux9x4oI1lZdnvMAiZAs7nx/+sDW4BJc2oWA=;
        b=UblDXCvPKo83cLxn+o7fOTKuh4oZWIHSA4dR1Ncq/GKpzyWj4o+3CTepM7OADiS4go
         MuBa0Lsr6KAnLwCcMp2tnwXkRRWqpMlUoL7XRFjICPKhVkprXXV7Tn24LuMccZ2HnHMO
         lwIOd1WGei9lxEy8RWAW/iu29GcvoL+j0oOsl6pE/2dSp4m8LtND5KKsG9aDeTvPnGq7
         NHyxIyiNxZCNF/tOpe6bfo/o8Qes7lZd1s9BpkDcx5VJs8zVcP12IzYz+jpiCemSbdO4
         y2lIADORs8XvsagfZFP67krcOC2hQKBvb99b61IoqZyRfZf3okRO3x9lwvEqABTh2Q1Q
         CoNA==
X-Gm-Message-State: AOAM531h3PRh84BOkKu2LgCiHNkgcfNZ3uoNn2H86qetOzltOb1vBpxU
        CA00NAQPhg5afq/PCRSsdCGf8usNbTZ/z9L20g==
X-Google-Smtp-Source: ABdhPJwzgwxYjBhqS5YwSnAJ/sHKdFDNptG9yHFTv/SWSJot2ik/Yal85ta+ttp0YNkw5zt5zoGuFDr207NC7mEm2o4=
X-Received: by 2002:aca:1015:: with SMTP id 21mr15505843oiq.92.1621979194196;
 Tue, 25 May 2021 14:46:34 -0700 (PDT)
MIME-Version: 1.0
References: <20210524185054.65642-1-george.mccollister@gmail.com> <20210524212938.jaepbj5qdl3esd4i@skbuf>
In-Reply-To: <20210524212938.jaepbj5qdl3esd4i@skbuf>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Tue, 25 May 2021 16:46:21 -0500
Message-ID: <CAFSKS=Mdvsqo0KUqTMdRgJMQ1SSa45wYJ_YM=rqnFEFJBoxZHw@mail.gmail.com>
Subject: Re: [PATCH net] net: hsr: fix mac_len checks
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Taehee Yoo <ap420073@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Wang Hai <wanghai38@huawei.com>,
        Phillip Potter <phil@philpotter.co.uk>,
        Andreas Oetken <andreas.oetken@siemens.com>,
        Marco Wenzel <marco.wenzel@a-eberle.de>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 4:29 PM Vladimir Oltean <olteanv@gmail.com> wrote:
[snip]
> > +     ret = hsr->proto_ops->fill_frame_info(proto, skb, frame);
>
> Nitpick: hsr uses "res", not "ret".
>

Oops. I'll try to pay more attention to what is used in the existing
code next time.

[snip]
>
> I admit that I went through both patches and I still don't understand
> what is the code path that the original commit 2e9f60932a2c ("net: hsr:
> check skb can contain struct hsr_ethhdr in fill_frame_info") is
> protecting against. I ran the C reproducer linked by syzbot too and I
> did not reproduce it (I did not compile with the linked clang though).

I think it's complaining if you access more than mac_len bytes from
the pointer returned by skb_mac_header() but I'm not familiar with
this bot.

Thanks for testing the patch.

-George
