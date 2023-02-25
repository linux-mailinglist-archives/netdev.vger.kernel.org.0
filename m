Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 080256A2B10
	for <lists+netdev@lfdr.de>; Sat, 25 Feb 2023 18:22:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbjBYRV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Feb 2023 12:21:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjBYRV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Feb 2023 12:21:56 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 060E213D64
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 09:21:54 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-53916ab0c6bso64875217b3.7
        for <netdev@vger.kernel.org>; Sat, 25 Feb 2023 09:21:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tv3UYABuAc7O90pBQK/S/U1msSEewKnxoIVQ3wzAmKA=;
        b=CGVB/AlBQ93fj6NkAbhT6TYqmvU+QFV1F+y2ehXpzEIz1u5G/x5Tdu7ZOFg8Sv7i/q
         A8/pcxAUyHKmwRsJGPFeBDPLNN9Uwt6Ng0mkyq4ELlM4vt4Ewndqwt5Gd412H/7rYB2J
         O4/8VzAp4t81+z7CmeVEm8Fc/5hxaFbTeNN2Jw0Hk94Djl0Ha5g4WZjZT/V737AIFaSc
         WAjF8EjOud4mIZA8dmXz6+G6k8c+josM1rQiWH85XS0oVpX3iQQr6xRymCcRedsHk/JY
         yCT3e6j0xbCTnl6a8phr+1213qQPgn91KkRGEQgV8A0RENkE+rs+q2k3CYLHd4tCMNCs
         EHhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tv3UYABuAc7O90pBQK/S/U1msSEewKnxoIVQ3wzAmKA=;
        b=aqncKxtgltu5ZFpw3uBvHYYDfNhjj9CR7ywWEvRypmhaJsIlDs9JgfeQ+H2g5A7Z2p
         G3L7wgNmtdZR8z874I7mhLnwl6kqeHal3/s65s1UbeHijKKRRi8nWQCj99ZLuzA9tqwI
         Y0nxbY7wO5JQB/GlBSoBDNDzWsiPT4jP+wEKVL7m1UAXoxUFCfDK9DGK7VbJXspDQMtN
         nOAYk0CxXoQnq2YNhkNKF28rxN0GEK2BZBGC0m+ustxcoHwW1cofh3rLTD57yLOXffMe
         DImnN4zKzN5aJ9lBqkdDJlCWfqkodTSxZbL8qxHerXuiu71y9jUEfizbCsFWtZMhONYz
         rQbg==
X-Gm-Message-State: AO0yUKU7O+kyYhZqLU0hA1U5efuTjlAgkMrfYq5rJWHa0FvCOOLBoQDN
        JglB6FN9E/qXgW7813GgQ57OHAe583Vu7mgRRbSESg==
X-Google-Smtp-Source: AK7set/PDX/J0Z6hizeg296HLSuMoOepNSanMyjPKlQ+2CnEXfTEiHiRiU9KDu/vxPK2gNpYwmRRr9QE4RqGnoqtuz8=
X-Received: by 2002:a81:4325:0:b0:52e:bb3e:15aa with SMTP id
 q37-20020a814325000000b0052ebb3e15aamr4336673ywa.7.1677345713194; Sat, 25 Feb
 2023 09:21:53 -0800 (PST)
MIME-Version: 1.0
References: <20230224015234.1626025-1-kuba@kernel.org> <20230223192742.36fd977a@hermes.local>
 <20230224091146.39eae414@kernel.org> <CAM0EoM=Ugqtg_jg_kgWjA+eojcV7k+nZuyov8Qn2C7L7aPwSRQ@mail.gmail.com>
 <20230224102935.591dbb43@kernel.org> <20230224143327.4221f8a5@hermes.local> <20230224165618.5e4cbbf4@kernel.org>
In-Reply-To: <20230224165618.5e4cbbf4@kernel.org>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Sat, 25 Feb 2023 12:21:41 -0500
Message-ID: <CAM0EoMmYMt5rR56LRnfQaH-x74A9CNdhOh+jwohREFa0NzbKUw@mail.gmail.com>
Subject: Re: [PATCH iproute2] genl: print caps for all families
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Hemminger <stephen@networkplumber.org>, dsahern@gmail.com,
        Johannes Berg <johannes@sipsolutions.net>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 24, 2023 at 7:56 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 24 Feb 2023 14:33:27 -0800 Stephen Hemminger wrote:
> > > I'm biased but at this point the time is probably better spent trying
> > > to filling the gaps in ynl than add JSON to a CLI tool nobody knows
> > > about... too harsh? :
> >
> > So I can drop it (insert sarcasm here)
>
> It may be useful to experts as a for-human-consumption CLI.
>
> JSON to me implies use in scripts or higher level code, I can't
> think of a reason why scripts would poke into genl internals.
> E.g. if a script wants something from devlink it will call devlink,
> and the devlink tool internally may interrogate genl internals.
>

genl was/is mostly useful for debugging. Ive used it on/off to check
on things but on its own not much use.

> IOW we're tapping into a layer in the middle of the tech stack,
> while user wants JSON out of the end of the stack.
>

Only reason to make it json capable is for consistency with the rest
of iproute2 (given the effort to convert all prints to json). Main
value for json is providing a more formal, parseable output. Probably
not for genl, but generally for iproute2 utilities, example tc,
running tc -j | jq somethinghere | grep ..  is more predictable in
outcome than using text output piped to grep (which is what people
used to do before  -j); we extensively use it in tdc for example.

> [We can replace ynl with a iproute2 internal lib or libml to avoid bias]
> Now, what I'm saying is - for devlink - we don't have a easy to use
> library which a programmer can interact with to query the family info.
> Parsing thru the policy dumps is _hard_. So building a C library for
> this seems more fruitful than adding JSON to the CLI tool.
>
> IDK if I'm making sense.  I could well be wrong.

Not familiar with ynl, but if it is a library then I would suggest it
be part of iproute2 to avoid code replication etc. The LinuxWay(tm) is
CutnpasteThenEditAway - a lot of code in iproute2 is very templateable
so would benefit that way. Such code is also susceptible to human
error (see Pedros patches to fix broken usage of "index" parsing in tc
actions).

Re Devlink (or any other users): one of the original goals of generic
netlink was to seek the source of truth from the kernel via
introspection to discover properties of the different users, their
families, commands, etc and then formulate what will be acceptable to
send from user space. Some of that code unfortunately never went in
(mostly because it was an idea that I had but no users existed at the
time); Johannes I believe introduced policy discovery at some point
which may make it feasible now. The idea then is the CLI would query
the kernel for the properties, build enough details and then process
user requirements with the known constraints. Maybe that idea is still
too ambitious.

For sure having a centralized CLI that is widely adopted helps - a lot
of the code is very templa. It's a lot easier to evolve current tools
than to replace them even when the evolution is superficial. Folks
familiar with "ip" or "tc" (and already have the certification to
prove it) would be happier to stick with those interfaces than
creating a new one. If you are a developer and want to write your own
application then having well formed libraries (probably polyglot) is
very valuable; however, that doesnt contradict the need for
operational tooling such as provided by iproute2.

I worry I may have rambled without addressing the essence what you are asking;->

cheers,
jamal
