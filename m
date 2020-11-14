Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92982B2D19
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 13:21:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgKNMU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 07:20:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgKNMU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 07:20:56 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01758C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 04:20:55 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id a15so13898875edy.1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 04:20:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6qcy9DmA1Wku1Q4ZwLpAFafm8Jb23CC0YKeFzJd3Opg=;
        b=tagAyhN1xmhjv9KLTVSDOW+HLtFdgC2agJU/9Dx9BicFme7DdRBSBW0amQhsnU0396
         uDVvTzcbZCcOBdWjl2pZbw+Q3OAJdNXIRKo1yDG3gU/UH1koM6PpsN0wNhFDH7EsWBOd
         2pdbxY80XgEwLvdrjwmyhNgjvYBgQ8bzdaEYIENO8Phf75sTruBzf/j/+Gejqs3n3F0Y
         AIb7SWCo3n/ZLvd0TITvFdOyr3uZf5PfGSTonbw7lYiU1Ni3RyKyx219XDe2mvdnpCTz
         /rd82yNN6XlKP+wNezyq5iCXj66wmoGO/lZnmIA+lhSFjLTd9isgkWD3edn8oMOOGpCp
         gXWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6qcy9DmA1Wku1Q4ZwLpAFafm8Jb23CC0YKeFzJd3Opg=;
        b=UVRK+5s9qRjpa31sxDpYhmDGZtV7b5EXCI9qebDEpnvqcYrGYvZem/RFZgyeUMZAUR
         ILt2jNAsioIfFUBtHjZfpfX1fXAUm6PcikHd1RMToEQKJk4T60VYVXliS1m5NJ6HeuAU
         gcC79sm3hHGqPjKlxp4rnXW5tvDQEUcAvZkpXPR0oe0rnzOkvk0MRJFwBKlZEPp3nG8D
         7aORblI/SeJaUEYeYayH9DDpgZyPeSk5gr+5ifuCH6g9ospoJzlxK9FR/l6UT1X2jpxw
         pqxUWXdPclnoc/XJgepnFSlGfc4q7CPv8kW+xmn0G8rMfeHtbTt9ZY4qlPZ3I0lYSjs5
         QR8Q==
X-Gm-Message-State: AOAM5325oYJjIBx7yl+c0k5Iga0gMCsbzv8C1vdQ0Ozo6Jw7kevijZ5o
        2C/wSFo36Q+9mKA3D+j9lRQ=
X-Google-Smtp-Source: ABdhPJz1LtdFIfMlbQIgf0aDGeXKL5/pltUf3SZmfBNT2Cb8YXBtrpst0dYIgeah567O6UP4Mo0sYw==
X-Received: by 2002:aa7:d888:: with SMTP id u8mr7391132edq.210.1605356453022;
        Sat, 14 Nov 2020 04:20:53 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id c5sm6694414edw.67.2020.11.14.04.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 04:20:52 -0800 (PST)
Date:   Sat, 14 Nov 2020 14:20:51 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, davem@davemloft.net, kuba@kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next 1/2] net: dsa: tag_dsa: Unify regular and
 ethertype DSA taggers
Message-ID: <20201114122051.4nwjjkjhrbb344vy@skbuf>
References: <20201114020851.GW1480543@lunn.ch>
 <C72Y9Y96O02K.2J4BFT8MY7S6U@wkz-x280>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C72Y9Y96O02K.2J4BFT8MY7S6U@wkz-x280>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 14, 2020 at 12:29:32PM +0100, Tobias Waldekranz wrote:
> > Humm, yes, they have not been forwarded by hardware. But is the
> > software bridge going to do the right thing and not flood them? Up
>
> The bridge is free to flood them if it wants to (e.g. IGMP/MLD
> snooping is off) or not (e.g. IGMP/MLD snooping enabled). The point
> is, that is not for a lowly switchdev driver to decide. Our job is to
> relay to the bridge if this skb has been forwarded or not, the end.
>
> > until now, i think we did mark them. So this is a clear change in
> > behaviour. I wonder if we want to break this out into a separate
> > patch? If something breaks, we can then bisect was it the combining
> > which broke it, or the change of this mark.
>
> Since mv88e6xxx can not configure anything that generates
> DSA_CODE_MGMT_TRAP or DSA_CODE_POLICY_TRAP yet, we do not have to
> worry about any change in behavior there.
>
> That leaves us with DSA_CODE_IGMP_MLD_TRAP. Here is the problem:
>
> Currenly, tag_dsa.c will set skb->offload_fwd_mark for IGMP/MLD
> packets, whereas tag_edsa.c will exempt them. So we can not unify the
> two without changing the behavior of one.
>
> I posit that tag_edsa does the right thing, the packet has not been
> forwarded, so we should go with that.
>
> This is precisely the reason why we want to unify these! :)

Shouldn't the correct approach be to monitor the
SWITCHDEV_ATTR_ID_BRIDGE_MC_DISABLED attribute in order to figure out
whether IGMP/MLD snooping is enabled or not?
