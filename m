Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAA70DF24F
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 18:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729835AbfJUQBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 12:01:14 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:41968 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbfJUQBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 12:01:13 -0400
Received: by mail-lj1-f193.google.com with SMTP id f5so13933389ljg.8;
        Mon, 21 Oct 2019 09:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KOjK1gTuOPcck6tqkEBr4a2duGXba7fS1Z/e1SXXo8E=;
        b=lN9wcp3WNq/iYaA6LNI57oK/7VJpAvUeyHYV1WnP8JbTxSgHMKqTgsBWC0X6VlvR96
         Pz2e+NOVWvAIYs7Q/RN0MVBf9S+eaH5TNoMfs2mOKpHF0nsDH3WNzbPKSna2K4Faq0BR
         jvpZOp0Y3Uc+fWECPFQdM6I5JoQ3Mnv1xEht3siyO03PwGr+KN1eTw96LgXmLVXqLHO3
         Xh93kG0zTnTm1M/lM+yLnTMlGIAjTveprOnapECRPFnpR4fARdt0fMoydO9uun0MZ9C/
         pBIBgCbGfwZpfPU4JLf2F9VwyBLFNNTZrkeYusEBkA5kAGtv4rl/SReZ2gcZjQ70hBVA
         8AWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KOjK1gTuOPcck6tqkEBr4a2duGXba7fS1Z/e1SXXo8E=;
        b=DuaXehLt982/RN+jXZEtbCi3soCLoB2O+Z4jzYd2abqAYToftrKnfAdf8KwK5d/Pgk
         xU3uPz633pDsWTtwPMAPUEPmEeF2JVW2I1LICN52Jgl9jCQydRDUVxR1dP4NTZ/KuNIt
         YZoRzi8Dz3RJilUkNjnn+gJJyqPrSYAfVb0oG2JoYFqsLGl8nCGq309LS6tmeSKkTMCD
         lBtMWixZsJivfSKqHgocHNQl1M63vJ09mkbMU2cmNa+XFRcfwpEhiiCStVB/teqL0J0q
         gmwtyCAuiMgePCRdLeqD0XlVvkdFYe+HxnWiotqgdL1MiUWXw5ne67iD28KcAdX1mmfE
         BwHQ==
X-Gm-Message-State: APjAAAW4B2/GxMlhx+V6pt4YGuG8noYWzqM1iZeorPJCp43+hdkd3t0w
        ah77bRN9niMXtv/XF0kH557j2mcsT3+AsOIJXw/0wt2r4TQ=
X-Google-Smtp-Source: APXvYqx3lGTq1CCkhaEj0OolRNPjk+oQHrPGkaaVkeZbtWplbSoJHNDwvkdHobLzBIrI98eZfcLxM2h20GIS/AvTlxs=
X-Received: by 2002:a2e:9695:: with SMTP id q21mr7519373lji.105.1571673669713;
 Mon, 21 Oct 2019 09:01:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-8-ap420073@gmail.com>
 <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
 <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com>
 <72bc9727d0943c56403eac03b6de69c00b0f53f6.camel@sipsolutions.net>
 <CAMArcTVeFGqA2W26=rBD5KkjRpFB6gjSgXj8dp+WWrrwJ7pr-A@mail.gmail.com> <bb48fca5a5ffb0a877b2bff8de07ec8090b63427.camel@sipsolutions.net>
In-Reply-To: <bb48fca5a5ffb0a877b2bff8de07ec8090b63427.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 22 Oct 2019 01:00:57 +0900
Message-ID: <CAMArcTWvuqtUv-RKvmw17x4A2JXTkJMOPchRvJ0aRVKKCKemyw@mail.gmail.com>
Subject: Re: [PATCH net v4 07/12] macvlan: use dynamic lockdep key instead of subclass
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>, saeedm@mellanox.com,
        manishc@marvell.com, rahulv@marvell.com, kys@microsoft.com,
        haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 7 Oct 2019 at 20:41, Johannes Berg <johannes@sipsolutions.net> wrote:
>

Hi Johannes,

> On Sat, 2019-10-05 at 18:13 +0900, Taehee Yoo wrote:
> >
> > If we place lockdep keys into "struct net_device", this macro would be a
> > little bit modified and reused. And driver code shape will not be huge
> > changed. I think this way is better than this v4 way.
> > So I will try it.
>
> What I was thinking was that if we can do this for every VLAN netdev,
> why shouldn't we do it for *every* netdev unconditionally? Some code
> could perhaps even be simplified if this was just a general part of
> netdev allocation.
>
> > > But it seems to me the whole nesting also has to be applied here?
> > >
> > > __dev_xmit_skb:
> > >  * qdisc_run_begin()
> > >  * sch_direct_xmit()
> > >    * HARD_TX_LOCK(dev, txq, smp_processor_id());
> > >    * dev_hard_start_xmit() // say this is VLAN
> > >      * dev_queue_xmit() // on real_dev
> > >        * __dev_xmit_skb // recursion on another netdev
> > >
> > > Now if you have VLAN-in-VLAN the whole thing will recurse right?
> > >
> >
> > I have checked on this routine.
> > Only xmit_lock(HARD_TX_LOCK) could be nested. other
> > qdisc locks(runinng, busylock) will not be nested.
>

"I have checked on this routine.
Only xmit_lock(HARD_TX_LOCK) could be nested. other
qdisc locks(runinng, busylock) will not be nested."

I'm so sorry, I think it's not true.
running lock could be nested.
But lockdep warning doesn't occur because of below code.

seqcount_acquire(&qdisc->running.dep_map, 0, 1, _RET_IP_);

The third argument means trylock.
If trylock is set, lockdep doesn't make lockdep chain.
So, running could be nested but lockdep warning doesn't occur even
these have the same lockdep key.
You can check on /proc/lockdep and /proc/lockdep_chain

> OK, I still didn't check it too closely I guess, or got confused which
> lock I should look at.
>
> > This patch already
> > handles the _xmit_lock key. so I think there is no problem.
>
> Right
>
> > But I would like to place four lockdep keys(busylock, address,
> > running, _xmit_lock) into "struct net_device" because of code complexity.
> >
> > Let me know if I misunderstood anything.
>
> Nothing to misunderstand - I was just asking/wondering why the qdisc
> locks were not treated the same way.
>
> johannes
>

Thank you
Taehee
