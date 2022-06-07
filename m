Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 364F75403CC
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240700AbiFGQaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235612AbiFGQ37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:29:59 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E88D85EDC
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 09:29:58 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id c144so11099324qkg.11
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 09:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arista.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lg3TwZPKgeUmV5BCRe+Wr51K8BfRlJvm7N5E+evC63U=;
        b=QuHD+P/6jd8L5qI3oOyOw6ABZCnLiRnhTkn3eXsxplCX+nc8PzKKtYR3mlh/x5Ldug
         7rxIYMmlwIiLjjE9Ec2HZCJKkCrnsvMvomMJiiSDmSYP7CAkrZAswT+kR6LtSaJLiXhF
         2TUb7OP2P3VYXpkDDIGX+qvbCgAoOqt2MeTEDQXma9hC+qF0h6SY7yD5gQGRnGFdhcfv
         Ieb1iLYLtOd90CeaIhnbNORKUt0ph3DVneKw3kpjwWtGUJwfDPUrgmBqkUGdfxbP5V5m
         kZSNizXiaO6myYqWQf+MH6nflDUmAKVZJxDsU2leg3+AIOR6yaMcPNxjkWpFd6rlSEPk
         RNxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lg3TwZPKgeUmV5BCRe+Wr51K8BfRlJvm7N5E+evC63U=;
        b=HAfpbyPXcXSMr8FfEDc9wm1rNfVW/waiHVJ1dduxIJ0ZsbC5hSB+f9AYgcHIvIoFKW
         zzGceNn/TWULElfdjvjy1xZuBQ9cpJBZP8iGY6/CrDZ+YsOw4/GqsathPSD8WesDRRjJ
         AqRj0j2B62uMGFDRCSEYrP7I64Fy74HVD1XOvUsC9PP6BB5zX3Ut/bskzAk8iXY6JZo2
         +7rRRh4paXzgfGvLSWn/XdP8ThwcnHVEjrIzwdy2WJj5SOILnXpMn2wu+S2OQoWaKUh6
         WSWXObDL4o2xGmyrNTES2i8OPHPacJBmfc7DD5eQp/rvowWlnUdtQIgupPdg7Gq3Zwpa
         rBYA==
X-Gm-Message-State: AOAM530g0mM6xA3yBqEoOSy3w1HgdLIGH1TiMJHh4JAS1vg97ahZ0BR4
        7BqqT3DuqEeSuGe2hX1Sz2TXWXjpb7uGBqeaVfkC/A==
X-Google-Smtp-Source: ABdhPJyyEeGBAJt5XO3VtSGt2hNpC7lz3pAdNX5trk7mr6Ms/c35vn87nZh9xPzxH5Q77IpkoxhsT29fhRxsqwwFkKY=
X-Received: by 2002:a37:cc4:0:b0:6a6:a193:1263 with SMTP id
 187-20020a370cc4000000b006a6a1931263mr14395974qkm.210.1654619396844; Tue, 07
 Jun 2022 09:29:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
 <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com> <20220606201910.2da95056@hermes.local>
In-Reply-To: <20220606201910.2da95056@hermes.local>
From:   Francesco Ruggeri <fruggeri@arista.com>
Date:   Tue, 7 Jun 2022 09:29:45 -0700
Message-ID: <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
Subject: Re: neighbour netlink notifications delivered in wrong order
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Andy Roulin <aroulin@nvidia.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 6, 2022 at 8:19 PM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 6 Jun 2022 19:07:04 -0700
> Andy Roulin <aroulin@nvidia.com> wrote:
>
> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > index 54625287ee5b..a91dfcbfc01c 100644
> > --- a/net/core/neighbour.c
> > +++ b/net/core/neighbour.c
> > @@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb,
> > struct neighbour *neigh,
> >       if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
> >               goto nla_put_failure;
> >
> > -     read_lock_bh(&neigh->lock);
> >       ndm->ndm_state   = neigh->nud_state;
>
> Accessing neighbor state outside of lock is not safe.
>
> But you should be able to use RCU here??

I think the patch removes the lock from neigh_fill_info but it then uses it
to protect all calls to neigh_fill_info, so the access should still be safe.
In case of __neigh_notify the lock also extends to protect rtnl_notify,
guaranteeing that the state cannot be changed while the notification
is in progress (I assume all state changes are protected by the same lock).
Andy, is that the idea?
