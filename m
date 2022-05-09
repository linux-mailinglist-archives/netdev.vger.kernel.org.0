Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC3D52065F
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 23:05:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiEIVJL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 17:09:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiEIVJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 17:09:11 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5ED1268207
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 14:05:15 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id ks9so22756799ejb.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 14:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1ssAFc9Y9YGdSYhkeno052Yd/vGQeSx6hAqfVOM35SM=;
        b=F2iBgguktpPTmm6kME1cK1YpiXKbc+q+g9nawkvgx+Z+dGYqp9bgK4DRQSzBdPhrI3
         EKd4w1tXJSZ7CZU1eL5Jj9jKU8Z+dRRsKzggkL+cQrSgyu/S7xAJGNCASawPhF9MJeUD
         FkJjJ4ZVsbRXHTh4jt50ZpOXwZbFvg8iBtnrtwZdSSNP2atV383msSYCTbAnJqpgTfaf
         BqPtb+Dk7Y7E33vvSIwGuKg0IryIio3LB7uY28UgK7kwvmFh0db2Aq3hQRL+yaqCWjdF
         bXk3R0Xt0UBfDglnhpJTPCyxzHXCKvHu4JA8nr0nvzIGPP1l1L4IBFGL3wsUckKyOngW
         2o2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1ssAFc9Y9YGdSYhkeno052Yd/vGQeSx6hAqfVOM35SM=;
        b=CDuEnL3qN3WULRDGSVQIzbQ2FjdjYdMp9QoUahvOhQiloCeGrfZCT/aGRgRiGHNCGr
         KKEcc0qhzypZEEiTclzWaOJlAGEVhzxeZUqw/EiQW8uFo/zDJl+4TaCuu4dZrt9GeXJs
         hqGeRij3SfwRt0/dZVGGanP2TbEjviSkUPkV8mSx64v36XiUwsqF8TLp0x61FfYXnCR8
         KQnVsbUEEKBPEqBIElzVfx5pTp+89ZDqThcwQSTwLm9rULslFUaj0etW05Qf+YtlTzRs
         P0FJAX3+DmOaSTuwksVT/1vkAZtGj8UUndXn+tLLQylxNIlOYtgWdGrSimEnw1UHmvNx
         EDBw==
X-Gm-Message-State: AOAM533XMABGs4GuqQf5fjf67y+DN2cctAiIJH6at3j32uleFmx0JykC
        3qeJQnvMsMAcAKkNlP/4t7ghT0zMuGuQCP65EjZUvbW+
X-Google-Smtp-Source: ABdhPJwAAWh9qhsQ7hXDfbCtcUlH1JgCRyrNYuZBLg+ThnMuThuQs+jhUa3ZOhT68PiG459Z5XoRTvJxknwE2dubZ9o=
X-Received: by 2002:a17:907:3f16:b0:6f4:c54:2700 with SMTP id
 hq22-20020a1709073f1600b006f40c542700mr16455514ejc.615.1652130314339; Mon, 09
 May 2022 14:05:14 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
 <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
 <CANn89iL+r=dgW4ndjBBR=E0KQ0rBVshWMQOVmco0cZDbNXymrw@mail.gmail.com>
 <433e8f1e98c583d04798102f234aea6b566bef36.camel@gmail.com> <CANn89i+74TjkiuTwScqF0ML=R8cpvWZ6z0M-cSuh2g7fuhwnZQ@mail.gmail.com>
In-Reply-To: <CANn89i+74TjkiuTwScqF0ML=R8cpvWZ6z0M-cSuh2g7fuhwnZQ@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 9 May 2022 14:05:03 -0700
Message-ID: <CAKgT0UdZNs1FBuDsAkQK2R6L57dHs=F_WP-eaWW+8GSGf9JgRg@mail.gmail.com>
Subject: Re: [PATCH 0/2] Replacements for patches 2 and 7 in Big TCP series
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Coco Li <lixiaoyan@google.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 1:31 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Mon, May 9, 2022 at 1:22 PM Alexander H Duyck
> <alexander.duyck@gmail.com> wrote:
> >
> > On Mon, 2022-05-09 at 11:54 -0700, Eric Dumazet wrote:
> > > On Mon, May 9, 2022 at 11:17 AM Alexander Duyck
> > > <alexander.duyck@gmail.com> wrote:
> > > >
> > > > This patch set is meant to replace patches 2 and 7 in the Big TCP series.
> > > > From what I can tell it looks like they can just be dropped from the series
> > > > and these two patches could be added to the end of the set.
> > > >
> > > > With these patches I have verified that both the loopback and mlx5 drivers
> > > > are able to send and receive IPv6 jumbogram frames when configured with a
> > > > g[sr]o_max_size value larger than 64K.
> > > >
> > > > Note I had to make one minor change to iproute2 to allow submitting a value
> > > > larger than 64K in that I removed a check that was limiting gso_max_size to
> > > > no more than 65536. In the future an alternative might be to fetch the
> > > > IFLA_TSO_MAX_SIZE attribute if it exists and use that, and if not then use
> > > > 65536 as the limit.
> > >
> > > OK, thanks.
> > >
> > > My remarks are :
> > >
> > > 1) Adding these enablers at the end of the series will not be
> > > bisection friendly.
> >
> > They don't have to be added at the end, but essentially they could be
> > drop in replacements for the two patches called out. I just called it
> > out that way as that is what I ended up doing in order to test the
> > patches, and to make it easier to just send them as a pair instead of
> > sending the entire set. I moved them to the end of the list and was
> > swapping between the 2 sets in my testing. I was able to reorder them
> > without any issues. So if you wanted you could place these two patches
> > as patches 2 and 7 in your series.
> >
> > > 2) Lots more changes, and more backport conflicts for us.
> > >
> > > I do not care really, it seems you absolutely hate the new attributes,
> > > I can live with that,
> > > but honestly this makes the BIG TCP patch series quite invasive.
> >
> > As it stands the BIG TCP patch series breaks things since it is
> > outright overrriding the gso_max_size value in the case of IPv6/TCP
> > frames. As I mentioned before this is going to force people to have to
> > update scripts if they are reducing gso_max_size as they would also now
> > need to update gso_ipv6_max_size.
>
> If they never set  gso_ipv6_max_size, they do not have to change it.
> If they set it, well, they get what they wanted.
> Also, the driver value caps  gso_ipv6_max_size, so our patches broke nothing.

I agree that the driver value caps it now that the patches from Jakub
are in. My concern is more with the fact that if they are reducing it
to address some other issue on their NIC then they are now going to
have to update 2 controls instead of just one.

> Some people could actually decide to limit IPV4 TSO packets to 40KB,
> and yet limit
> IPv6 packets to 128KB.
> Their choice.
> Apparently you think this is not a valid choice.

That would be a perfectly valid choice, but limiting it at the NIC
doesn't make sense to me since the NIC is an L2 device and what you
are talking about doing is making modifications up at the L3 layer. It
might make more sense to associate something like that with either a
sysctl at the protocol layer, or maybe even as some sort of attribute
to associate with a routing destination.

I would say the best comparison is device MTU and PMTU or MSS. The
device MTU is a hardware specific value. Nothing larger than that gets
through that specific interface. The PMTU or MSS is what defines your
value from one end to another and is usually stored away in the
routing and/or socket layers. Quite often the PMTU or MSS is smaller
than the device MTU and is tuned in order to get optimal throughput to
the network destination.

> >
> > It makes much more sense to me to allow people to push up the value
> > from 64K to whatever value it is you want to allow for the IPv6/TCP GSO
> > and then just cap the protocols if they cannot support it.
> >
> > As far as the backport/kcompat work it should be pretty straight
> > forward. You just replace the references in the driver to GSO_MAX_SIZE
> > with GSO_LEGACY_MAX_SIZE and then do a check in a header file somewhere
> > via #ifndef and if it doesn't exist you define it.
>
> Well, this is the kind of stuff that Intel loves to do in their
> out-of-tree driver,
> which is kind of horrible.
>
> Look, I will spend fews days rebasing and testing a new series
> including your patches,
> no need to answer this email.
>
> We will live with future merge conflicts, and errors because you
> wanted to change
> GSO_MAX_SIZE, instead of a clean change.

I appreciate all the effort you and the team at Google put into this,
and I am looking forward to seeing it accepted.

Thanks,

- Alex
