Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3623C5F9EE1
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 14:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbiJJMxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 08:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbiJJMxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 08:53:12 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7701052DF6
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 05:53:11 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id f14so7056078qvo.3
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 05:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TBAjW9r0Yqm9+8GYyvBiVexVdo43xQyNfiIdTzUgdZg=;
        b=PHNzImnR8QrGbjMwL1s0fRzN5o31WAGmg5gkJxBJVjt3ggEPiAqApR8zasReQ+SZu5
         022Fg+x9IqWZGzjdD+M+T/AptxNVORADONjxP/LPgZS5/hKylOKkNGvVrg1ZkI1EVfEP
         Mrq1Ahnz9grUqujlaelrmxiRjwzQDJaEkRcNDn1TIIC7TMXLe+ux5YoiRilACNY6yuQi
         UxqfyMMf/K/DsDIwjUqv+8IeSEjZiBcCq1W8ZBrZpZWrkMlfLma5fLJfen281rznX+pR
         xdOQMrRE6QyxExTzas40lCnH4gTZ8Z8ywhCdx/q+/PSSmcMnSxassNJyKUqnDO+Z/WH/
         WgIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TBAjW9r0Yqm9+8GYyvBiVexVdo43xQyNfiIdTzUgdZg=;
        b=WdnQnCZB6Zt4WnLHVA7TzSTOXbuc+nqxrbHtsN6s6LudDKsqZucIgHcXTgPDRZ0/tN
         p17cpB494mHsFQoKQ+O9Uaa2vMyH8oOAU/Z+4EzJnk/PZgaZiR9InQ1+kMB08wT2Ji6H
         BSdZkWiT9yfQuKRVvPDyJmzLwmp05cvwzd0k/s8auEaxApDGG+sPInwUJbqa4MgHoja0
         9Evtzu5PwBgw/4kmZWeMLM8oV075XBE6R+XxMPffzLQrb6rlsCHe6C9Apzjyazjnv+1d
         LS9Gkemdw3Q1UecgRSYPBWkVaTtxpPCbfsKCfoKmjDQptg6FsClSyLewqSwQ+jtXMMth
         R2Dw==
X-Gm-Message-State: ACrzQf3r/62RUf5JMLvrQuBmZta5oqMUvsgiJLhHd+WgLfHHvyWmcEd3
        WGkx1m9SH4kM5wubmaGo9PTY2iKii9XjZK6hYmelNx955UFIvw==
X-Google-Smtp-Source: AMsMyM7qGq3zSv5/KhkPd2D4R4e0iJ2D0KOntDQ7ogZdtlNg5HpIwC6gCYOq/7YVkH2Eb0TSBs2Cf9QJ7UUrdzDErwc=
X-Received: by 2002:a0c:cb8d:0:b0:4b1:7a87:8ad5 with SMTP id
 p13-20020a0ccb8d000000b004b17a878ad5mr14405550qvk.35.1665406390511; Mon, 10
 Oct 2022 05:53:10 -0700 (PDT)
MIME-Version: 1.0
References: <20221009191643.297623-1-eyal.birger@gmail.com>
 <1fc3c7b2-027b-374d-b77a-e5a01b70e73a@6wind.com> <CAHsH6GthqV7nUmeujhX_=3425HTsV0sc6O7YxWg22qbwbP=KJg@mail.gmail.com>
 <0e3f881d-b469-566f-7cdf-317fb88c305a@6wind.com>
In-Reply-To: <0e3f881d-b469-566f-7cdf-317fb88c305a@6wind.com>
From:   Eyal Birger <eyal.birger@gmail.com>
Date:   Mon, 10 Oct 2022 15:52:59 +0300
Message-ID: <CAHsH6GsBo59jm+fYLmPwf3FDa8+8Dc29BV1huj20YgjRdLeevQ@mail.gmail.com>
Subject: Re: [PATCH ipsec,v2] xfrm: fix "disable_policy" on ipv4 early demux
To:     nicolas.dichtel@6wind.com
Cc:     steffen.klassert@secunet.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        monil191989@gmail.com, stephen@networkplumber.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 10, 2022 at 3:19 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 10/10/2022 =C3=A0 12:29, Eyal Birger a =C3=A9crit :
> > Hi Nicolas,
> >
> > On Mon, Oct 10, 2022 at 11:28 AM Nicolas Dichtel
> > <nicolas.dichtel@6wind.com> wrote:
> >>
> >> Le 09/10/2022 =C3=A0 21:16, Eyal Birger a =C3=A9crit :
> >>> The commit in the "Fixes" tag tried to avoid a case where policy chec=
k
> >>> is ignored due to dst caching in next hops.
> >>>
> >>> However, when the traffic is locally consumed, the dst may be cached
> >>> in a local TCP or UDP socket as part of early demux. In this case the
> >>> "disable_policy" flag is not checked as ip_route_input_noref() was on=
ly
> >>> called before caching, and thus, packets after the initial packet in =
a
> >>> flow will be dropped if not matching policies.
> >>>
> >>> Fix by checking the "disable_policy" flag also when a valid dst is
> >>> already available.
> >>>
> >>> Link: https://bugzilla.kernel.org/show_bug.cgi?id=3D216557
> >>> Reported-by: Monil Patel <monil191989@gmail.com>
> >>> Fixes: e6175a2ed1f1 ("xfrm: fix "disable_policy" flag use when arrivi=
ng from different devices")
> >>> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
> >>>
> >>
> >> Is there the same problem with ipv6?
> >
> > The issue is specific to IPv4 as the original fix was only relevant
> > to IPv4.
> >
> > I also tested a similar scenario using IPv6 addresses and did not see
> > a problem.
> Thanks. Is it possible to write a selftest with this scenario?

I can add one targeting ipsec-next.

Do you perhaps know which is the current preferred flavor for such selftest=
s
for ipsec - C or bash?

Eyal.
