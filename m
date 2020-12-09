Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9102D4D7F
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:23:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388260AbgLIWWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388281AbgLIWVr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 17:21:47 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1976CC0613CF
        for <netdev@vger.kernel.org>; Wed,  9 Dec 2020 14:21:07 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id n26so4473413eju.6
        for <netdev@vger.kernel.org>; Wed, 09 Dec 2020 14:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sCwxrcZI11JHWFIR0ko4/rZ5sz6Z0Y9444d531pv6bk=;
        b=FlEpyYe82wKjV2BCp+6+YOEb5lr0q3lGLu4qdHf5Ff71O3PU54xy+1+GYLNhXfqQtL
         hb0ttJ8xNf9/tyLR5IWwhlu3Y1D9SEJLkJNCW4Dj189R5xedCt6dPyxMp1JxGr511Xhb
         QQRvvUeSACGcMcrH6BOvyDEICrO8vWsSSD7uDiKRgykmGaSY47G7OljeQAplninZoR2d
         9CQWLSb//rU6Rwe4aJ1tHt7aC3NYxnP1fQsNcA4RoKC/LGRWS4mSq9Iq9T6g9EaUDFu/
         CK5yalqzeO3NQ2fLG2wV+KGcULIE64s+Tq4Z7yP0GaVzUnK6HkzCifDzbfXRRD1YQCch
         5CtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sCwxrcZI11JHWFIR0ko4/rZ5sz6Z0Y9444d531pv6bk=;
        b=bw4Co2a1NJOHAwj+vnKpJyEs//h6tvzXh7DBfBPKq9gGrXBNIiX9cqXaoTcCd4/92b
         +C91LI0BEZo0AGe8qztCC/+mxxU0DuXM+sPlyfPpvsdcmcg7tvZ7WbtXt0S/Ij2pqpl6
         UHtE+EkWvG4c9qoRVjZKFJ6TUSB5qJInV0jjisWF1AjXYG9B48+hJlnYehNFzX8znVJX
         ToMeIP/YwMKJzHZACDYmf/VopAdvFGMgxxHpiCZD77W4/YjGM5HbgZgWI1/1xhbZ/bK6
         mrmBswbJv30vjmYtjNGtkiTma1dMbofeosmMNh4kzHeRfdMTAmwbh2NCGXT9MSYwePoz
         Y+kw==
X-Gm-Message-State: AOAM531IsXD0Ogwi04gD1b+qkuGbO0nkwXH6ZaVEBi7u6wQU2p6M/tZX
        Hof/n9OOlDL5VTOrwCvLCXh8Aa7BobE=
X-Google-Smtp-Source: ABdhPJxVAZCzYhFFNlblFc56MjQY+5ZcLCuaMFe6mdHaIl3ihAf+Y565i2cFRrRX+JqMDeCJ6cj2Kw==
X-Received: by 2002:a17:906:7243:: with SMTP id n3mr3782757ejk.246.1607552465776;
        Wed, 09 Dec 2020 14:21:05 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id gt11sm2630592ejb.67.2020.12.09.14.21.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 14:21:05 -0800 (PST)
Date:   Thu, 10 Dec 2020 00:21:03 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next 2/4] net: dsa: Link aggregation support
Message-ID: <20201209222103.zsisvbqaa7i2rl7k@skbuf>
References: <20201202091356.24075-1-tobias@waldekranz.com>
 <20201202091356.24075-3-tobias@waldekranz.com>
 <20201208112350.kuvlaxqto37igczk@skbuf>
 <87mtyo5n40.fsf@waldekranz.com>
 <20201208163751.4c73gkdmy4byv3rp@skbuf>
 <87k0tr5q98.fsf@waldekranz.com>
 <20201209105326.boulnhj5hoaooppz@skbuf>
 <87eejz5asi.fsf@waldekranz.com>
 <20201209160440.evuv26c7cnkqdb22@skbuf>
 <878sa663m2.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878sa663m2.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 09, 2020 at 11:01:25PM +0100, Tobias Waldekranz wrote:
> It is not the Fibonacci sequence or anything, it is an integer in the
> range 0..num_lags-1. I realize that some hardware probably allocate IDs
> from some shared (and thus possibly non-contiguous) pool. Maybe ocelot
> works like that. But it seems reasonable to think that at least some
> other drivers could make use of a linear range.

In the ocelot RFC patches that I've sent to the list yesterday, you
could see that the ports within the same bond must have the same logical
port ID (as opposed to regular mode, when each port has a logical ID
equal to its physical ID, i.e. swp0 -> 0, swp1 -> 1, etc). We can't use
the contiguous LAG ID assignment that you do in DSA, because maybe we
have swp1 and swp2 in a bond, and the LAG ID you give that bond is 0.
But if we assign logical port ID 0 to physical ports 1 and 2, then we
end up also bonding with swp0... So what is done in ocelot is that the
LAG ID is derived from the index of the first port that is part of the
bond, and the logical port IDs are all assigned to that value. It's
really simple when you think about it. It would have probably been the
same for Marvell too if it weren't for that cross-chip thing.

If I were to take a look at Florian's b53-bond branch, I do see that
Broadcom switches also expect a contiguous range of LAG IDs:
https://github.com/ffainelli/linux/tree/b53-bond

So ok, maybe ocelot is in the minority. Not an issue. If you add that
lookup table in the DSA layer, then you could get your linear "LAG ID"
by searching through it using the struct net_device *bond as key.
Drivers which don't need this linear array will just not use it.

> > I think that there is a low practical risk that the assumption will not
> > hold true basically forever. But I also see why you might like your
> > approach more. Maybe Vivien, Andrew, Florian could also chime in and we
> > can see if struct dsa_lag "bothers" anybody else except me (bothers in
> > the sense that it's an unnecessary complication to hold in DSA). We
> > could, of course, also take the middle ground, which would be to keep
> > the 16-entry array of bonding net_device pointers in DSA, and you could
> > still call your dsa_lag_dev_by_id() and pretend it's generic, and that
> > would just look up that table. Even with this middle ground, we are
> > getting rid of the port lists and of the reference counting, which is
> > still a welcome simplification in my book.
>
> Yeah I agree that we can trim it down to just the array. Going beyond
> that point, i.e. doing something like how sja1105 works, is more painful
> but possible if Andrew can live with it.

I did not get the reference to sja1105 here. That does not support
bonding offload, but does work properly with software bridging thanks to
your patches.
