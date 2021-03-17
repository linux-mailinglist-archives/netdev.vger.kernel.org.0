Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32AC333F92C
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 20:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233218AbhCQTaE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 15:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbhCQT3d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 15:29:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35324C06174A
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 12:29:32 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id w3so154506ejc.4
        for <netdev@vger.kernel.org>; Wed, 17 Mar 2021 12:29:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MnKaNf1OhfTI3PxhKZODRIR4nBG71AcDs+AIvy6KSYw=;
        b=Z8blTH0mVe971MEWcAwJkpdGdIkIa8p7VB1QnsEFSQDz4scBy7aS9GK+Ihp783iR+D
         QWz308N6MPOW560s1IZ3ZtYWpv64rKL+lsKHQnOJ2Y/DPVIc1fzQNoiFyxJSK0D8O/qz
         NVORBZFoFWjMaYCW7rZb9Vo56lqQswtdLdgRix6qFfsMtlZvzxQMYQi1FK09rgxFz4SL
         eWWPrOaZkQt3N26b2skJlK4VwBnAIEwIEeXLndyPLMMhmPuap2hRlAIuZUYq4zWP+CR7
         5nmSE6m7AmMnZ1HgGtpY/u2MRjO0wojUP5U3OjCGxYhi5GCr9r7j+oR9TrhUTZzS9g0k
         eWnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=MnKaNf1OhfTI3PxhKZODRIR4nBG71AcDs+AIvy6KSYw=;
        b=fxFIWsSIip2V8MN+faPmsqAADKkzQvb7RqRHpyN6VIQBrmxkWT3+o/8Tg8ECwvyIbT
         TD+Ws304C2qNm3vb1+vUmGxGQQQVXqLa0F72PrtErKKvyug89iHICAQM4xaFa7EdRKk2
         FGKuXIa85Rnz7CTdY/chsyJd3KfzsJKKMoNa+xPo7KyTrXN7Qi7EDYEgDOEV5OI3jIcp
         a5SezozXquF6O0q8mZTCpX73rEUyZUa6ZQ+G5XZD6sgjDVy4HeylbwgRm6Ewsr0Feq2g
         d3gvL7DDlBsUcYtSpar8TBXsWhxfVrYGEGe5qnAXwpeLKROcSMgyZStVZLRRjexYUeBK
         EajA==
X-Gm-Message-State: AOAM5316/cEWThVzsrDD2RRFMPkeJttxAznUeDFWjNKnjQWoMvboo7AH
        MUGTWfcAaEEPbHtG6/Pc3OI=
X-Google-Smtp-Source: ABdhPJy/wTpZOkkXT12qkxCGjhKnuhQNW90PNUN6DyLxr12/Ek7xzyOt6o6/slFKqk7mmATxYBiqhA==
X-Received: by 2002:a17:906:a049:: with SMTP id bg9mr37191818ejb.186.1616009370845;
        Wed, 17 Mar 2021 12:29:30 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id g26sm12258918ejz.70.2021.03.17.12.29.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 12:29:30 -0700 (PDT)
Date:   Wed, 17 Mar 2021 21:29:29 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] net: dsa: mv88e6xxx: Offload bridge
 learning flag
Message-ID: <20210317192929.qviweve6acjzrjcq@skbuf>
References: <20210315211400.2805330-1-tobias@waldekranz.com>
 <20210315211400.2805330-5-tobias@waldekranz.com>
 <20210317141224.ssll7nt64lqym3wg@skbuf>
 <87k0q5obz9.fsf@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87k0q5obz9.fsf@waldekranz.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 17, 2021 at 07:45:46PM +0100, Tobias Waldekranz wrote:
> On Wed, Mar 17, 2021 at 16:12, Vladimir Oltean <olteanv@gmail.com> wrote:
> > On Mon, Mar 15, 2021 at 10:13:59PM +0100, Tobias Waldekranz wrote:
> >> +	if (flags.mask & BR_LEARNING) {
> >> +		u16 pav = (flags.val & BR_LEARNING) ? (1 << port) : 0;
> >> +
> >> +		err = mv88e6xxx_port_set_assoc_vector(chip, port, pav);
> >> +		if (err)
> >> +			goto out;
> >> +	}
> >> +
> >
> > If flags.val & BR_LEARNING is off, could you please call
> > mv88e6xxx_port_fast_age too? This ensures that existing ATU entries that
> > were automatically learned are purged.
> 
> This opened up another can of worms.
> 
> It turns out that the hardware is incapable of fast aging a LAG.

You sound pretty definitive about it, do you know why?

> I can see two workarounds. Both are awful in their own special ways:
> 
> 1. Iterate over all entries of all FIDs in the ATU, removing all
>    matching dynamic entries. This will accomplish the same thing, but it
>    is a very expensive operation, and having that in the control path of
>    STP does not feel quite right.

When does it ever feel right? :)

I think of it like a faster 'bridge fdb' command (since 'bridge fdb'
traverses the ATU super inefficiently, it dumps the whole table for each
port).

On my system with 24 mv88e6xxx ports, 'time bridge fdb' takes around 34
seconds. So that means a 'slow age' will take around 1.4 seconds for a
single LAG.

On the other hand, on my system with 7 sja1105 ports, I have no choice
but to do slow ageing - the hardware simply doesn't have the concept of
'fast ageing'. There, 'time bridge fdb' returns 1.781s, so I expect a
slow age would take around 0.25 seconds. Of course I'm not happy about
it, but I think I'll bite the bullet.

> 2. Flushing all dynamic entries in the entire ATU. Fast, but obviously
>    results in a period of lots of flooded packets.

This one seems like an overreaction to me. Would that even solve the
problem? Couly you destroy and re-create the trunk?

> Any opinion on which approach you think would hurt less? Or, even
> better, if there is a third way that I have missed.
> 
> For this series I am leaning towards making mv88e6xxx_port_fast_age a
> no-op for LAG ports. We could then come back to this problem when we add
> other LAG-related FDB operations like static FDB entries. Acceptable?

Yeah, I guess that's fair.
