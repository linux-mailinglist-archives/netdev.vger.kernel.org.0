Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB5CCF4B9
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 10:13:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbfJHINg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 04:13:36 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:32813 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730309AbfJHINg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 04:13:36 -0400
Received: by mail-lf1-f65.google.com with SMTP id y127so11273645lfc.0;
        Tue, 08 Oct 2019 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LRw2nUwXDpX/s9reIbhkN0rYHhrGthC9PtGcXI5QI30=;
        b=tFcsSOCGp9hyWVQnJOvF/8gyV5y4Eo7v0lg4cj3BZugrr6w3/4lEZJYSFPxoIcBJlq
         PwudanwBLOH/9XnmkUOi+f3olI0PbcO27yupyh2vuhbazLgPInKR9bWMzttfhmDP5+WF
         8fKPkDiFnKewoc9SVs4YZy4r2lu966cqAiculSRdjAARpO9BYDg8nAgSAO+flx/DCTMd
         bgtm0Z3x1I3fiFn9vZ58YwdXWMBjmC/Io48qdNOd9Cot9zBbRIp/5r/36gOZCpwtA3qT
         nzSTDe6ADQMIpdAwCEsQETpOIq+wr4ynOwrn+Z4hdW/jdKucNANS1NDUKp/20EIENded
         4haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LRw2nUwXDpX/s9reIbhkN0rYHhrGthC9PtGcXI5QI30=;
        b=WponLL7ywPPBUije8NNFrBR8Y9xZ08IPkKVK6Tsiz6d4d3rUT2NpiBOFiyxVamjl9U
         L6C95m4JCOOgkM4KoVnVFAplsjVVzIIRNQaQseJKOTnVZKiBkXCwcMmrXR5sR7vOd29P
         QjMnT3/o4uWSdyBke1DZqs/io+vQ1+/ErDoCtiXKu+nhteWgbCKQJDGXc2wjPXIt1tqc
         BGIFjt01ZW7q52VuZ0ct7oeMJHOOJrkxYT6tsOTOhQ2nM7IVigqrOZo53ieTQ6aR32Cj
         36tcZIcZVLy3/1Evj8E5f8lQxEXST4HJNEMf+OwDTkLiRMR9qv9wuXV9sIKlAse4Fz2f
         Th+Q==
X-Gm-Message-State: APjAAAUdJTJGIZuw9092E1QKWfLfwRb3HP8weG6CCd2TMnWoNkXT1qvI
        VnKH6x/Z5zIAJEIXqTh3mg71drPFP6NxNxI3rRY=
X-Google-Smtp-Source: APXvYqxp1WiyRxY0zT+XmroavDCpA4LOvQuD2KDPgzp8Ksx/cmijBwIdtGVAwM9dphQLhiKa1OpuNV13dP56aLBL4D4=
X-Received: by 2002:a19:2207:: with SMTP id i7mr19618360lfi.185.1570522414136;
 Tue, 08 Oct 2019 01:13:34 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-8-ap420073@gmail.com>
 <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
 <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com>
 <72bc9727d0943c56403eac03b6de69c00b0f53f6.camel@sipsolutions.net>
 <CAMArcTVeFGqA2W26=rBD5KkjRpFB6gjSgXj8dp+WWrrwJ7pr-A@mail.gmail.com> <bb48fca5a5ffb0a877b2bff8de07ec8090b63427.camel@sipsolutions.net>
In-Reply-To: <bb48fca5a5ffb0a877b2bff8de07ec8090b63427.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Tue, 8 Oct 2019 17:13:22 +0900
Message-ID: <CAMArcTVvpUsz013K6UXpbKiKfpMKaTsGmJhnv3YfiGOLnh4Zig@mail.gmail.com>
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

Your opinion makes sense.
I think there is no critical reason that every netdev shouldn't have
own lockdep keys. By comparison, the benefits are obvious.

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

I'm always thankful for your detailed and careful reviews.

> johannes
>

Thank you,
Taehee Yoo
