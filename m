Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE2FF5AA183
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 23:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbiIAVbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 17:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231447AbiIAVa4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 17:30:56 -0400
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7DB61D71
        for <netdev@vger.kernel.org>; Thu,  1 Sep 2022 14:30:55 -0700 (PDT)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-33da3a391d8so390787b3.2
        for <netdev@vger.kernel.org>; Thu, 01 Sep 2022 14:30:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=8SSW2+vu6ct/7tcWFtgXxH5jv2ox2W/ny4Sqhp6SHtM=;
        b=hf0oQ2b3KwBiLN4Z1ftLbR9tnTQTwlDe92T4S0i2uVx3zmIkdWAt3yEaKZP9yEwF/Q
         DeTwgAuIvak6nQ62I1huQxOxemiQfr/lq2Sg91FUswYAYt6xbYB88/pAXLyYktoiZiax
         4JrQVSENYjugEob45d1UZTw/F81L+o5X4iEGfdUXSSPFlEeVv4VHLeJSAYQ7WJk9KDDJ
         pNPcEF4tp2y5VAwr8htuqTkPI3d04wpH/7XttUA4FlCwCXqa1Z+4aGw1zUUGAE5JatNp
         8G2LSh3q6tZ8v5OpolCLtmagurSBIx5EFoGqpX9GFy49RADPY1G7J4nb1C5HMd3r+P0D
         KsEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=8SSW2+vu6ct/7tcWFtgXxH5jv2ox2W/ny4Sqhp6SHtM=;
        b=D84hUDQE0S/4tnds75wiFKj1nEXNtEee7RMEGiiBxAEgkXQCn5kTPkpuC8wNbIoYqd
         KwzhOM7S4r9rYMO5OT2xXDVZ+clBEBjQ+Y9s4dBjkWWEIcV40YUIMml5GUsLx8RBKxEh
         fRfdhjyNSGH9LX7K8c5mtcUdTaYer38giM03NEDlTNTjIOQu6hgD3NcSf2NJgMI0+H2E
         4UntHsNv2TCTrQa9xd2y7M1TP7vGJFbCvbfiShho9l08qlMAkHJkS3XyX+XDv0GH1fyZ
         w7xpIv91oz6UgPfUoZsZ3BxOdL5xDpiqxp4fiPk68Ub83Tq+HCwKTdl7J80ErwznFx73
         +GwA==
X-Gm-Message-State: ACgBeo34W2noIIBKxltl6JW1JAF0CP+3fjHfPJ5ff+2XubSXuiVPkdDA
        FzxcgSt8WnMgM+3gUVqDoABNoF91+UHDleQqG/RIyA==
X-Google-Smtp-Source: AA6agR62GifZZbFYzALr8HcX4hDs6FEosw7XUZJPr+Rh1W5H8eTWqDJ7XIGktvRpc46Nw0LQyTTzj+WyeiZyW/yGFdk=
X-Received: by 2002:a0d:f847:0:b0:341:3399:fd55 with SMTP id
 i68-20020a0df847000000b003413399fd55mr17304811ywf.55.1662067854684; Thu, 01
 Sep 2022 14:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <f154fcd1d7e9c856c46dbf00ef4998773574a5cc.camel@redhat.com> <20220901212520.11421-1-kuniyu@amazon.com>
In-Reply-To: <20220901212520.11421-1-kuniyu@amazon.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 1 Sep 2022 14:30:43 -0700
Message-ID: <CANn89iJ=D8o2kNRf6aL=Pa=V6m_fOr6bPBY67yjXFgwTCEAHag@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/5] tcp: Access &tcp_hashinfo via net.
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kuniyuki Iwashima <kuni1840@gmail.com>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 1, 2022 at 2:25 PM Kuniyuki Iwashima <kuniyu@amazon.com> wrote:
>
> From:   Paolo Abeni <pabeni@redhat.com>

> > /Me is thinking aloud...
> >
> > I'm wondering if the above has some measurable negative effect for
> > large deployments using only the main netns?
> >
> > Specifically, are net->ipv4.tcp_death_row and net->ipv4.tcp_death_row-
> > >hashinfo already into the working set data for established socket?
> > Would the above increase the WSS by 2 cache-lines?
>
> Currently, the death_row and hashinfo are touched around tw sockets or
> connect().  If connections on the deployment are short-lived or frequently
> initiated by itself, that would be host and included in WSS.
>
> If the workload is server and there's no active-close() socket or
> connections are long-lived, then it might not be included in WSS.
> But I think it's not likely than the former if the deployment is
> large enough.
>
> If this change had large impact, then we could revert fbb8295248e1
> which converted net->ipv4.tcp_death_row into pointer for 0dad4087a86a
> that tried to fire a TW timer after netns is freed, but 0dad4087a86a
> has already reverted.


Concern was fast path.

Each incoming packet does a socket lookup.

Fetching hashinfo (instead of &tcp_hashinfo) with a dereference of a
field in 'struct net' might inccurr a new cache line miss.

Previously, first cache line of tcp_info was enough to bring a lot of
fields in cpu cache.
