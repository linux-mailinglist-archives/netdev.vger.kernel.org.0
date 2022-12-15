Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCCD64E220
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 21:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbiLOUIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 15:08:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiLOUIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 15:08:47 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 807911F2D7;
        Thu, 15 Dec 2022 12:08:46 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id w23so96455ply.12;
        Thu, 15 Dec 2022 12:08:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVtEfAAkfXkktaXEDmW98q7dKYMVq3c7HgdRun7NHcI=;
        b=qYnyJfkwGdBgLHrEyGda+TFGttzKbqzE2ZIH+TgsxQPuucaiv1Y6UbU99o8qshRYNo
         tpYoFkG6bUIES7g5ubypGfc4AsJexXOIn+wE8h2VuU9uNp51u00wTnWYT2aCzCd3Cuii
         8S2CfnBsaBuNXOGpSvEoPcpIs6vizNYUfqsahs3EneQBCcauHLDUMZnsnDwJDoGjdz1L
         fOh29ShkWgUp3M/qYyu82OB1/qZsDolD+6PB6TZDithKVl9Oy0bWrugUk1NkfV98a4WQ
         Nz0P3K/QTZzWxJ4sh2sN+yBIkEmi3nRWjUIN3c630EgPe2gLj2E9ShRQNLAKoT8/gZMH
         mYDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVtEfAAkfXkktaXEDmW98q7dKYMVq3c7HgdRun7NHcI=;
        b=rdHsyPpOJez4DMYl4RyPvQWZOKwZx+h/pqwuN9zypKo5tMSOLgxBMP+IFpLXsFi00m
         s/KosOXBExoZ50TnGo0QRC+IJverlQEqf28N29YycFDbNbQPqec3WZpqTRPRtzVy973E
         KAfwHTRds1ILpChvOVBBaX1SBtQvCvCIZsgWIOKYH4wXVdDO5ZgZFDZthJKXrDWHgpGE
         TXilUvU8YxkqqxP3Vdt/796IAb+BfS5syzXDCLN6/s0ONrpbXUVAtAR+sTTBmEh8o1S8
         aUlnJxQwvZ9/3WHuKwbcvHvLgKkW+UVFwamqBbhxmzTu9oYB4wUg+qwo5uAPS4POgB+D
         jJbA==
X-Gm-Message-State: AFqh2koLCwXZOuiSNx9AjO3bQrTwq+zWCmdBo13b0MBYKb4gFpPj/kfg
        lZg103nfCFYSmLpzJggwmiYr5mJTTJ4rhNvj+5A=
X-Google-Smtp-Source: AMrXdXt+N8GVGay+OUSvh76f4W8y9ZhJwxSkqK3MSgsAI4LNNGCiaEYEpIwgwNiwOm2JSI2mraZZ4K9ig+UpRSz+3OI=
X-Received: by 2002:a17:90a:5996:b0:219:aea7:1db8 with SMTP id
 l22-20020a17090a599600b00219aea71db8mr294223pji.211.1671134925990; Thu, 15
 Dec 2022 12:08:45 -0800 (PST)
MIME-Version: 1.0
References: <20221214232059.760233-1-decot+git@google.com> <7211782676442c6679d8a016813fd62d44cbebad.camel@gmail.com>
 <CAG88wWZNaKqDXWrXanfSpM_h6LP7s3F5PppyWqwWRyA7g=+p_g@mail.gmail.com>
In-Reply-To: <CAG88wWZNaKqDXWrXanfSpM_h6LP7s3F5PppyWqwWRyA7g=+p_g@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Thu, 15 Dec 2022 12:08:34 -0800
Message-ID: <CAKgT0Uea8JztZfKsR_FUAjt5iXEyRhjySwysZSoeeobWv3Cizw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/1] net: neigh: persist proxy config across
 link flaps
To:     David Decotigny <decot@google.com>
Cc:     David Decotigny <decot+git@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Nikolay Aleksandrov <razor@blackwall.org>,
        David Ahern <dsahern@kernel.org>,
        "Denis V. Lunev" <den@openvz.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Chen Zhongjin <chenzhongjin@huawei.com>,
        Yuwei Wang <wangyuweihx@gmail.com>,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
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

On Thu, Dec 15, 2022 at 9:29 AM David Decotigny <decot@google.com> wrote:
>
>
> (comments inline below)
>
>
> On Thu, Dec 15, 2022 at 8:24 AM Alexander H Duyck <alexander.duyck@gmail.=
com> wrote:
>>
>> On Wed, 2022-12-14 at 15:20 -0800, David Decotigny wrote:
>> > From: David Decotigny <ddecotig@google.com>
>> >
>> > Without this patch, the 'ip neigh add proxy' config is lost when the
>> > cable or peer disappear, ie. when the link goes down while staying
>> > admin up. When the link comes back, the config is never recovered.
>> >
>> > This patch makes sure that such an nd proxy config survives a switch
>> > or cable issue.
>> >
>> > Signed-off-by: David Decotigny <ddecotig@google.com>
>> >
>> >
>> > ---
>> > v1: initial revision
>> > v2: same as v1, except rebased on top of latest net-next, and includes=
 "net-next" in the description
>> >
>> >  net/core/neighbour.c | 5 ++++-
>> >  1 file changed, 4 insertions(+), 1 deletion(-)
>> >
>> > diff --git a/net/core/neighbour.c b/net/core/neighbour.c
>> > index f00a79fc301b..f4b65bbbdc32 100644
>> > --- a/net/core/neighbour.c
>> > +++ b/net/core/neighbour.c
>> > @@ -426,7 +426,10 @@ static int __neigh_ifdown(struct neigh_table *tbl=
, struct net_device *dev,
>> >  {
>> >       write_lock_bh(&tbl->lock);
>> >       neigh_flush_dev(tbl, dev, skip_perm);
>> > -     pneigh_ifdown_and_unlock(tbl, dev);
>> > +     if (skip_perm)
>> > +             write_unlock_bh(&tbl->lock);
>> > +     else
>> > +             pneigh_ifdown_and_unlock(tbl, dev);
>> >       pneigh_queue_purge(&tbl->proxy_queue, dev ? dev_net(dev) : NULL,
>> >                          tbl->family);
>> >       if (skb_queue_empty_lockless(&tbl->proxy_queue))
>>
>> This seems like an agressive approach since it applies to all entries
>> in the table, not just the permenant ones like occurs in
>> neigh_flush_dev.
>>
>> I don't have much experience in this area of the code but it seems like
>> you would specifically be wanting to keep only the permanant entries.
>> Would it make sense ot look at rearranging pneigh_ifdown_and_unlock so
>> that the code functioned more like neigh_flush_dev where it only
>> skipped the permanant entries when skip_perm was set?
>>
>
> The reason I am proposing this patch like it is is because these "proxy" =
entries appear to be a configuration attribute (similar to ip routes, comin=
g from the sysadmin config), and not cached data (like ip neigh "normal" en=
tries essentially coming from the outside). So I view them as fundamentally=
 different kinds of objects [1], which they actually are in the code. And t=
hey are also updated from a vastly different context (sysadmin vs traffic).=
 IMHO, it would seem natural that these proxy attributes (considered config=
 attributes) would survive link flaps, whereas normal ip neigh cached entri=
es without NUD_PERMANENT should not. And neither should survive admin down,=
 the same way ip route does not survive admin down. This is what this patch=
 proposes.
>
> Honoring NUD_PERMANENT (I assume that's what you are alluding to) would a=
lso work, and (with current iproute2 implementation [2]) would lead to the =
same result. But please consider the above. If really honoring NUD_PERMANEN=
T is the required approach here, I am happy to revisit this patch. Please l=
et me know.

Yeah, I was referring to basically just limiting your changes to honor
NUD_PERMANANT. Looking at pneigh_ifdown_and_unlock and comparing it to
neigh_flush_dev it seems like it would make sense to just add the
skip_perm argument there and then add the same logic at the start of
the loop to eliminate the items you aren't going to flush/free. That
way we aren't keeping around any more entries than those specifically
that are supposed to be permanent.
