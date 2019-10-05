Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA1D5CC8F5
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 11:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727307AbfJEJNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 05:13:44 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:44755 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEJNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 05:13:44 -0400
Received: by mail-lj1-f193.google.com with SMTP id m13so8792376ljj.11;
        Sat, 05 Oct 2019 02:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6BMm3bC3bkusqxJWYAC/zLRsOGev2sxGw4nQG+kQcc=;
        b=gvmHNy8D4Y14VKLA2WNPxfPGjW3qIykENQ7BWGE6EHDMK6OmmzdygA2CjHtOTvJZeF
         dhxGhRqJu9eVM1MOolMtYDle+7h3uMRpjKyeA6RQT4v1tIj00wVeI2ovWvYOUU4s2JK0
         bG5adlXhTC3ME3tUn3BmQyxcsSdsgOwUh5pRvlQVaWamBwI+3Mbndk4VUBzAOBB+Ec5E
         tHl2QLygGimnMkkgsJOIJy8azP9wL1injFT6QVvLcWZz0g1/VKoBCND4umumlI5S4M/U
         0Mdld6SUVr8+0NAxbz8T2xfzsRP34AdMyMJnmcKPgS+0wwEpDvV6/F8V9LTSZwxhQNib
         hK8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6BMm3bC3bkusqxJWYAC/zLRsOGev2sxGw4nQG+kQcc=;
        b=KkKUnKLdoJegZZIAfz9MjkFeeglcVtk1WkhNppw+8LvAwO3E1qoMMVPQEuGhyx4xpW
         xGTo3EEv/e440jSjdK5WATgRHqptEuvLLcGVxd3brluf9m4WSepfcZ3sT1XG2BCILeI7
         b3Ng4sENULj4eGKThYjymESaORifoYj81IjIHLkLx25S6URwSvN4PSuet52sOVoaJ7WG
         jYsjpcShRG3uhpMukOoE91CWPbVsjx/fUZhxhDc0N22fEM4yDJQ/TP6If4k8F/lnPJd6
         8fVRT0XWiStS1WUae9aPqrakig9UyWCx8L1MKhxyGyfeSpiDPvnnSJGmqkNxc6JR29FF
         hGsA==
X-Gm-Message-State: APjAAAWfn5y8grZkb7Fa5UMDundtcQUPCrJw9H1PTYe+TF5eymDLUOOw
        ZIQzdNuPYCPIgQw0odwIP3ugpubJYmd1s4IIE7c=
X-Google-Smtp-Source: APXvYqxqB0Kne5zhevFmaSMC9cHpnYFjnvsL+Vn7FHfkKaIfgiZGdMfsDj9OgJNtkRMw33epJrlAItY+P44+IimpY5E=
X-Received: by 2002:a2e:744:: with SMTP id i4mr12193905ljd.64.1570266821465;
 Sat, 05 Oct 2019 02:13:41 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-8-ap420073@gmail.com>
 <33adc57c243dccc1dcb478113166fa01add3d49a.camel@sipsolutions.net>
 <CAMArcTWrMq0qK72VJv=6ATugMSt_b=FiE4d+xOmi2K3FE8aEyA@mail.gmail.com> <72bc9727d0943c56403eac03b6de69c00b0f53f6.camel@sipsolutions.net>
In-Reply-To: <72bc9727d0943c56403eac03b6de69c00b0f53f6.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 5 Oct 2019 18:13:30 +0900
Message-ID: <CAMArcTVeFGqA2W26=rBD5KkjRpFB6gjSgXj8dp+WWrrwJ7pr-A@mail.gmail.com>
Subject: Re: [PATCH net v4 07/12] macvlan: use dynamic lockdep key instead of subclass
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
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

On Tue, 1 Oct 2019 at 16:25, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>

Hi,

> > > I didn't see any discussion on this, but perhaps I missed it? The cost
> > > would be a bigger netdev struct (when lockdep is enabled), but we
> > > already have that for all the VLANs etc. it's just in the private data,
> > > so it's not a _huge_ difference really I'd think, and this is quite a
> > > bit of code for each device type now.
> >
> > Actually I agree with your opinion.
> > The benefits of this way are to be able to make common helper functions.
> > That would reduce duplicate codes and we can maintain this more easily.
> > But I'm not sure about the overhead of this way. So I would like to ask
> > maintainers and more reviewers about this.
>
> :-)
>
> > Using "struct nested_netdev_lockdep" looks really good.
> > I will make common codes such as "struct nested_netdev_lockdep"
> > and "netdev_devinit_nested_lockdep" and others in a v5 patch.
>
> That makes *sense*, but it seems to me that for example in virt_wifi we
> just missed this part completely, so addressing it in the generic code
> would still reduce overall code and complexity?
>

Yes, you're right,
Virt_wifi has the same problem. I will fix this in a v5 patch!

> Actually, looking at net-next, we already have
> netdev_lockdep_set_classes() as a macro there that handles all this. I
> guess having it as a macro makes some sense so it "evaporates" when
> lockdep isn't enabled.
>
>
> I'd probably try that but maybe somebody else can chime in and say what
> they think about applying that to *every* netdev instead though.
>

If we place lockdep keys into "struct net_device", this macro would be a
little bit modified and reused. And driver code shape will not be huge
changed. I think this way is better than this v4 way.
So I will try it.

>
> > > What's not really clear to me is why the qdisc locks can actually stay
> > > the same at all levels? Can they just never nest? But then why are they
> > > different per device type?
> >
> > I didn't test about qdisc so I didn't modify code related to qdisc code.
> > If someone reviews this, I would really appreciate.
>
> I didn't really think hard about it when I wrote this ...
>
> But it seems to me the whole nesting also has to be applied here?
>
> __dev_xmit_skb:
>  * qdisc_run_begin()
>  * sch_direct_xmit()
>    * HARD_TX_LOCK(dev, txq, smp_processor_id());
>    * dev_hard_start_xmit() // say this is VLAN
>      * dev_queue_xmit() // on real_dev
>        * __dev_xmit_skb // recursion on another netdev
>
> Now if you have VLAN-in-VLAN the whole thing will recurse right?
>

I have checked on this routine.
Only xmit_lock(HARD_TX_LOCK) could be nested. other
qdisc locks(runinng, busylock) will not be nested. This patch already
handles the _xmit_lock key. so I think there is no problem.
But I would like to place four lockdep keys(busylock, address,
running, _xmit_lock) into "struct net_device" because of code complexity.

Let me know if I misunderstood anything.

> johannes
>

Thank you,
Taehee
