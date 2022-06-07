Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39C7E54068F
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 19:37:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346526AbiFGRgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 13:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348331AbiFGRgN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 13:36:13 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F8262CD4
        for <netdev@vger.kernel.org>; Tue,  7 Jun 2022 10:32:26 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q18so15361159pln.12
        for <netdev@vger.kernel.org>; Tue, 07 Jun 2022 10:32:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ghbpLxDoM1wp/oxnkxfrUJWkLWC0cjXnG6AxQX5B6f8=;
        b=pwpeX/rKb1CbJ2nXkLR9ooSnIXTB/zZmajwEFmBCo/l4Ib/mpA2Hlyx1A1eQ2vNX8f
         wIfC3wtm1AgWZ+uGaS14HdUWGU9x5BF75e8VGwBJkn+5quKBau0IfA75b1NngRYZHcqB
         +NDDmFIiOXd4I4zpyd+Nkas21WA5ytTE8LH3tMAMnF3tf1qXgKEjBl7jcciC7fFrpLIz
         3rSmbZFJSfkzedsRIXF+KdHFr8tlh10aYdAKgdXi5dGCjvYJ1L8ytD1/II2dXiucX2Yq
         rzdaGeygncRfiGdYHwNpd4kHq/HPCg1FMznpTksYJJ7tk101C7a7uA3QuipFbzI2PcV4
         w0Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ghbpLxDoM1wp/oxnkxfrUJWkLWC0cjXnG6AxQX5B6f8=;
        b=sog2Of+aW6ogeia5xJkSZE3NK8g8QMhcO330wX1gHWrfkQywhHbn4SJbK2Sk+PPtxR
         DK1Y3SRBlXOAKkLLsjSTpwQjBxqmjzIHcntpCsS5FpqUQzUnAtSoEUz6V6M3j0ETiE0m
         zq1m9LGV8RLocqMMZc8u/aR4MgXKKo4B1eV5SeyRdR1klgAtphS+8V7qgipZ6pW7DO0w
         Uke5nndIgfpuy7miu6rRVFKVNoU3AJ+Gvs6MBFwfmlJagEbYPeNXc24gepOJeddNM1eK
         Vgiyq3uwu8i7ZbTC4UkhPFWaLO8oCfeXxl5bn1xvwrk+vf8NY+hUjjMfez86GKj7ozPl
         mbzA==
X-Gm-Message-State: AOAM532IAmwigUpAuL7JKwM7qMVlxPHRpK9NCddMXiBVkIpH7Odpxlp/
        glOcTjb9TOA3yYBYrpOdcNRdHA==
X-Google-Smtp-Source: ABdhPJxPJpc1txWrnrDc1uETEo/bSrqzFayXuMptbndFwmZ8YV4y6w56wlzv2SLrUITDNnavI93wxw==
X-Received: by 2002:a17:902:d64e:b0:163:5074:c130 with SMTP id y14-20020a170902d64e00b001635074c130mr30822740plh.125.1654623141592;
        Tue, 07 Jun 2022 10:32:21 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id y23-20020a056a00181700b00518c68872b9sm6124241pfa.216.2022.06.07.10.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jun 2022 10:32:21 -0700 (PDT)
Date:   Tue, 7 Jun 2022 10:32:18 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Francesco Ruggeri <fruggeri@arista.com>
Cc:     Andy Roulin <aroulin@nvidia.com>, netdev@vger.kernel.org
Subject: Re: neighbour netlink notifications delivered in wrong order
Message-ID: <20220607103218.532ff62c@hermes.local>
In-Reply-To: <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
References: <20220606230107.D70B55EC0B30@us226.sjc.aristanetworks.com>
        <ed6768c1-80b8-aee2-e545-b51661d49336@nvidia.com>
        <20220606201910.2da95056@hermes.local>
        <CA+HUmGidY4BwEJ0_ArRRUKY7BkERsKomYnOwjPEayNUaS8wv=w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Jun 2022 09:29:45 -0700
Francesco Ruggeri <fruggeri@arista.com> wrote:

> On Mon, Jun 6, 2022 at 8:19 PM Stephen Hemminger
> <stephen@networkplumber.org> wrote:
> >
> > On Mon, 6 Jun 2022 19:07:04 -0700
> > Andy Roulin <aroulin@nvidia.com> wrote:
> >  
> > > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> > > index 54625287ee5b..a91dfcbfc01c 100644
> > > --- a/net/core/neighbour.c
> > > +++ b/net/core/neighbour.c
> > > @@ -2531,23 +2531,19 @@ static int neigh_fill_info(struct sk_buff *skb,
> > > struct neighbour *neigh,
> > >       if (nla_put(skb, NDA_DST, neigh->tbl->key_len, neigh->primary_key))
> > >               goto nla_put_failure;
> > >
> > > -     read_lock_bh(&neigh->lock);
> > >       ndm->ndm_state   = neigh->nud_state;  
> >
> > Accessing neighbor state outside of lock is not safe.
> >
> > But you should be able to use RCU here??  
> 
> I think the patch removes the lock from neigh_fill_info but it then uses it
> to protect all calls to neigh_fill_info, so the access should still be safe.
> In case of __neigh_notify the lock also extends to protect rtnl_notify,
> guaranteeing that the state cannot be changed while the notification
> is in progress (I assume all state changes are protected by the same lock).
> Andy, is that the idea?

Neigh info is already protected by RCU, is per neighbour reader/writer lock
still needed at all?
