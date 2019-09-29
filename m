Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C9B6C1449
	for <lists+netdev@lfdr.de>; Sun, 29 Sep 2019 13:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfI2LGG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Sep 2019 07:06:06 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:34447 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725924AbfI2LGG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Sep 2019 07:06:06 -0400
Received: by mail-lf1-f68.google.com with SMTP id r22so4953760lfm.1;
        Sun, 29 Sep 2019 04:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dnZ4iM2yDtkFkt93R4MF3nfXRV6/1Xh4Uo5dTWKcW0Q=;
        b=FOZWqstvikEmzvqvgPHaVWFTyV7hIXvn8Ho2y4DhnwIws9DXuHaFM/xpc+fuwXw4fT
         UdLR+/s208yXs7MvZ7bL0HENfSIKd/8spYlflg+/Revwy2eOd6mMyRwtRjbVTE4GK/hL
         GdOVKaUlXtp2V2GNI/HO+zHKp3N1eH8Eb+APIowVjVb3K/RffbkM9JH9kvmIkzJPtZJB
         8pvNZDZHHyMh1rtibtSDQm7nWsImosIroYezG5G/ua6eDSUSb864bD2kfWCd+VA1Hu/V
         4DXIEa59HVkLwB8zwsoZpq7Uca7lFw3S//AwPuQtCostn0olr1jOmEalmh69VItPM3PU
         7pFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dnZ4iM2yDtkFkt93R4MF3nfXRV6/1Xh4Uo5dTWKcW0Q=;
        b=jSgp4YOA0aGYFEU7dLdbkzDb2+6R+L/ys3sQ19G622dM+1+kApvkhzEdJ9glfkXdyA
         54NLSE6jPT1wEiEHDrQlHzyxiQ7Bl0vLDq8iMDXGsfSz8VvNTzfF0ia6f1iN0+QKgK2Q
         5AePRxDG8iP0r/QvKKO20iITyMZXcrvtcxWB182WttUQ4LhU0sFsN5PJIaY23kiSG8/M
         T/Ww/nc/bTU4YUCuB83NIXpTEv+35SDKb9bffvabN7j8nfJ8IQcNQlljakgV467fKHMM
         lPxFnqPYVZmDaCOSmH/2T2X3KVkryDJ/lXEUO+0YfMf5EUVBFoDBvZmP+tMYDGZb8ef8
         reIQ==
X-Gm-Message-State: APjAAAWDb6bVGTsK2zF6Z3KoiIAjOqP2xVkcjrL91xdOhAbR1c3Hw6Zf
        W6ARig+j3X8/CjVopyFD2V6ZQCU2nkxyS8KHMhc=
X-Google-Smtp-Source: APXvYqwHOC3tsEH5DwyvgqZBibu7BcKPCqf9mB6T6eQMhcmsQmZYsnUEt2PmyRWF8JGvAJwNl4x1Z0i6dS8X5G90NwQ=
X-Received: by 2002:ac2:44b9:: with SMTP id c25mr8577589lfm.112.1569755163519;
 Sun, 29 Sep 2019 04:06:03 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <20190928164843.31800-2-ap420073@gmail.com>
 <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
In-Reply-To: <d1b5d944fef2a2d5875a0f12f3cdc490586da475.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 29 Sep 2019 20:05:52 +0900
Message-ID: <CAMArcTUgcPv+kg5rhw0i2iwX-CiD00v3ZCvw0b_Q0jb_-eo=UQ@mail.gmail.com>
Subject: Re: [PATCH net v4 01/12] net: core: limit nested device depth
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

On Sun, 29 Sep 2019 at 04:36, Johannes Berg <johannes@sipsolutions.net> wrote:
>
> Hi,
>
> >  int netdev_walk_all_upper_dev_rcu(struct net_device *dev,
> >                                 int (*fn)(struct net_device *dev,
> >                                           void *data),
> >                                 void *data)
> >  {
> [...]
> >       }
> >
> >       return 0;
> > +
> >  }
>
> that seems like an oversight, probably from editing the patch in
> different versions?
>

I will fix this in a v5 patch.

> > +static int __netdev_update_upper_level(struct net_device *dev, void *data)
> > +{
> > +     dev->upper_level = __netdev_upper_depth(dev) + 1;
> > +     return 0;
> > +}
> > +
> > +static int __netdev_update_lower_level(struct net_device *dev, void *data)
> > +{
> > +     dev->lower_level = __netdev_lower_depth(dev) + 1;
> > +     return 0;
> > +}
>
> Is there any point in the return value here? You don't really use it,
> afaict? I guess I might see the point if it was used for tail-call
> optimisation or such?
>

These functions are used as a callback function of
netdev_walk_all_{upper/lower}_dev(). So these return types are needed.

>
> Also, I dunno, I guess netdevs aren't as much under pressure as SKBs :-)
> but do we actually gain much from storing the nesting level at all? You
> have to maintain it all the time anyway when adding/removing and that's
> the only place where you also check it, so perhaps it wouldn't be that
> bad to just count at that time?
>
> But then again the counting would probably be recursive again ...
>
> >       return 0;
> > +
> >  }
> >  EXPORT_SYMBOL_GPL(netdev_walk_all_lower_dev_rcu);
>
> same nit as above
>

I will fix this in a v5 patch too.

> > +     __netdev_update_upper_level(dev, NULL);
> > +     netdev_walk_all_lower_dev(dev, __netdev_update_upper_level, NULL);
> > +
> > +     __netdev_update_lower_level(upper_dev, NULL);
> > +     netdev_walk_all_upper_dev(upper_dev, __netdev_update_lower_level, NULL);
>
> Actually, if I'm reading this correctly you already walk all the levels
> anyway? Then couldn't you calculate the depth at this time and return
> it, instead of storing it? Though, if it actually overflowed then you'd
> have to walk *again* to undo that?
>
> Hmm, actually, if you don't store the value you don't even need to walk
> here I guess, or at least you would only have to do it to verify you
> *can* attach, but wouldn't have to in detach?
>
> So it looks to me like on attach (i.e. this code, quoted from
> __netdev_upper_dev_link) you're already walking the entire graph to
> update the level values, and could probably instead calculate the
> nesting depth to validate it?
> And then on netdev_upper_dev_unlink() you wouldn't even have to walk the
> graph at all, since you only need that to update the values that you
> stored.
>
> But maybe I'm misinterpreting this completely?
>

Without storing level storing, a walking graph routine is needed only
once. The routine would work as a nesting depth validator.
So that the detach routine doesn't need to walk the graph.
Whereas, in this patch, both attach and detach routine need to
walk graph. So, storing nesting variable way is slower than without
storing nesting variable way because of the detach routine's updating
upper and lower level routine.

But I'm sure that storing nesting variables is useful because other
modules already using nesting level values.
Please look at vlan_get_encap_level() and usecases.
If we don't provide nesting level variables, they should calculate
every time when they need it and this way is easier way to get a
nesting level. There are use-cases of lower_level variable
in the 11th patch.

Thank you

> Thanks,
> johannes
>
>
