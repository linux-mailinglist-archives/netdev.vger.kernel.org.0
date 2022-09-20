Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA5725BD89A
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 02:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiITABr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 20:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiITABf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 20:01:35 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4538A520A7
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:01:20 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id y15so533292ilq.4
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 17:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=m+ol5EnBXoDIfzJmbh3nOBrvnCqAkgSzjJARNTQDg3w=;
        b=EzYUT6ir40LAbBuQQ8DziSYQCA21ZpGayYD0ZlxNL+f3p6YMpoMKHfdgXEEg1BpolV
         0TF80Z0ZP9ewzrep8Jxif5ir6ZFuT9MXfxHDsOIUoOHWyzf068AV/rxOwSvWvtyJjOuX
         1e1E1ULcT9c351kPB9wC13THNKOkqmtg5JQD4BbQ1TeGzC0lO+aEfS56Gz0ArczfRNXB
         0raqPIOxJ3mgzwwUxUuRLNv5xCFeqckEtlvtbsSJL1BgJ5d+DpfncDjSLPKwswle2kjK
         VqQptXdVDyU64vNZVJbiduVsTsiTwI9J3v2JLEwKWBD4Lby0yZIOnUmL/60eFvKFPavv
         jUtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=m+ol5EnBXoDIfzJmbh3nOBrvnCqAkgSzjJARNTQDg3w=;
        b=PEmTQmW9yL6o3A7Zw3dwKgnTPoqwTW68QlIGUk/v4VemlS0RCVvK/h7dtjs8uvs3qn
         i8BhZuUTyd5AUhFrKlMaBqmwpJjIv5+ZRYfdNwAloQwlSueEBeHEwF4Yokv9y96WoAAj
         JjdLBBDUEdLHcucIiNms4xL2I8OtIiD+NNjPNkoKJhuJN6t1Donp04UDltrzOdyGZzmz
         Gebc7qhGXdxgpitPX1zmhwYHk3zjsShCEY95JBp6fYxdFi+pyGdPp+EybwryKaANj3Hd
         yltyL7PjQl8DaemWiikuaC8czb+AEHMTAUUtDi3ER3YYSFc+7VXtWdqr5sWab3oyfnNE
         Y9Ow==
X-Gm-Message-State: ACrzQf0Obqk5diqKLMmqeXDTeC/mjRmdEuf3+Sz03qdOrq3dt7nhZ0/0
        NWIyJGYa+jelxPIibXz/qFNr4RzeLfE1VgLaKEXanw==
X-Google-Smtp-Source: AMsMyM5mWJYW6MUWJyjzC5XHnHEUkDAwKHcsvmIIpT/f/YgbxdQFYM/Hr16ATZZ5NLyjaeWuDQBHkXBWh+H5x3Fvkxk=
X-Received: by 2002:a05:6e02:1b09:b0:2f1:ba8b:8cd2 with SMTP id
 i9-20020a056e021b0900b002f1ba8b8cd2mr8726113ilv.75.1663632079318; Mon, 19 Sep
 2022 17:01:19 -0700 (PDT)
MIME-Version: 1.0
References: <20220916234552.3388360-1-prohr@google.com> <20220919101802.4f4d1a86@hermes.local>
In-Reply-To: <20220919101802.4f4d1a86@hermes.local>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Mon, 19 Sep 2022 17:01:07 -0700
Message-ID: <CANP3RGdMEJMDcB8X_YD-PM7X6pqypvSn7_q4x=B8rzLd+CAqXA@mail.gmail.com>
Subject: Re: [PATCH] tun: support not enabling carrier in TUNSETIFF
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Patrick Rohr <prohr@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>, Lorenzo Colitti <lorenzo@google.com>,
        Jason Wang <jasowang@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 19, 2022 at 10:18 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Fri, 16 Sep 2022 16:45:52 -0700
> Patrick Rohr <prohr@google.com> wrote:
> >  #define IFF_DETACH_QUEUE 0x0400
> > +/* Used in TUNSETIFF to bring up tun/tap without carrier */
> > +#define IFF_NO_CARRIER IFF_DETACH_QUEUE
>
> Overloading a flag in existing user API is likely to break
> some application somewhere...

We could of course burn a bit (0x0040 and 0x0080 are both currently
utterly unused)... but that just seemed wasteful...
Do you think that would be better?

I find it exceedingly unlikely that any application is specifying this
flag to TUNSETIFF currently.

This flag has barely any hits in the code base, indeed ignoring the
Documentation, tests, and #define's we have:

$ git grep IFF_DETACH_QUEUE
drivers/net/tap.c:928:  else if (flags & IFF_DETACH_QUEUE)
drivers/net/tun.c:2954: } else if (ifr->ifr_flags & IFF_DETACH_QUEUE) {
drivers/net/tun.c:3115:                 ifr.ifr_flags |= IFF_DETACH_QUEUE;

The first two implement ioctl(TUNSETQUEUE) -- that's the only spot
where IFF_DETACH_QUEUE is currently supposed to be used.

The third one is the most interesting, see drivers/net/tun.c:3111

 case TUNGETIFF:
         tun_get_iff(tun, &ifr);
         if (tfile->detached)
                 ifr.ifr_flags |= IFF_DETACH_QUEUE;
         if (!tfile->socket.sk->sk_filter)
                 ifr.ifr_flags |= IFF_NOFILTER;

This means TUNGETIFF can return this flag for a detached queue.  However:

(a) multiqueue tun/tap is pretty niche, and detached queues are even more niche.

(b) the TUNGETIFF returned ifr_flags field already cannot be safely
used as input to TUNSETIFF, because IFF_NOFILTER == IFF_NO_PI ==
0x1000

(this overlap of IFF_NO_PI and IFF_NOFILTER is why we thought it'd be
ok to overlap here as well)

(c) if this actually turns out to be a problem it shouldn't be that
hard to fix the 1 or 2 userspace programs to mask out the flag
and not pass in garbage... Do we really want / need to maintain
compatibility with extremely badly written userspace?
It's really hard to even imagine how such code would come into existence...

Arguably the TUNSETIFF api should have always returned an error for
invalid flags... should we make that change now?
