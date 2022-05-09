Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF4995205F0
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 22:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiEIUhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbiEIUhE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 16:37:04 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D355EAD02
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 13:31:27 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id w187so27077812ybe.2
        for <netdev@vger.kernel.org>; Mon, 09 May 2022 13:31:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yoSibLIeaq7WeOtPbayCDWgSYL2uTmYOTPFeBylokis=;
        b=es8SuHK1DnqI6FlwLKO+q9F5gG7c8sRegq1Slfr5oDKH8VcmeIl73zPBTwRZjCeKL5
         GiHv7byF/CcRxy3fmLVb9ZCpIthCzMwoyUsMw/eJpjdFnWGRxAX3OqR7ZBkmnrQOFHrl
         AqyXucGVeV2CRIGLTRatgEfSjd9ndumBKaztnnK0UJ9Fy6RkYJmTtWdexlXTaTNThLAp
         MbZjwViQqr/oEgXJ72UikUE1dSsmcdk/SzFoWW/6ceGWoSXOgKd8HLvRogKkkkNNTcKC
         ffj5PAcL+PloZalcjGVTeVmhdHZ0hOAQqiOGrNdHLOxGhrWkOg1WcDfBR3A/L7pMBhb5
         DzrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yoSibLIeaq7WeOtPbayCDWgSYL2uTmYOTPFeBylokis=;
        b=s/SJ89FR93rNcCD+tovDc4WPVpf0IfgNdfEOu4cdmXe0sV3PLcUUlv51LBtzjyzBUd
         w5sG17zuogwhchVM33rcnud/MEkCRV1mP2+IwYbFlM2y40DXEqwoSgDw783qFAmKtnsV
         n7oq2FCh3jhkX4o9BNMc7bCPfWT2J/kEyxfjXurjvYwV1WR/WlaN/jNhLK1jf3oP9YuZ
         BAiXKIWjH2JbCEWX10RYZ4g2Dcm2aN2HXuLHFmaEw4ABanN5RlN+8LZtRDrD5pEb2iQS
         tA+C3aY1YcnC8NHCz8ucMtzOObEP4dNi/ZWTcltXOjj3y3xPTNsr50BA4hIbHA1iivsb
         N8qQ==
X-Gm-Message-State: AOAM531pHtahEfTFImrKeeZaEroxhZqpLHHbMXetxKyFTenyhYybF6NG
        0FmwQSTKQ5w2+MxwiTQseUIujpt0KSgBz8s6ndso9TeilvrHUZFq
X-Google-Smtp-Source: ABdhPJxl/JuHz7HXdGuArDajd0FhD8ZOO0O+2JRMGNtid/8eK3Zm7wZ2v43Emz3ltbBrN6uvI2Y7oINZsvWbYm18lj8=
X-Received: by 2002:a25:8b88:0:b0:64b:8a2:aae4 with SMTP id
 j8-20020a258b88000000b0064b08a2aae4mr478200ybl.231.1652128286392; Mon, 09 May
 2022 13:31:26 -0700 (PDT)
MIME-Version: 1.0
References: <CANn89iJW9GCUWBRtutv1=KHYn0Gpj8ue6bGWMO9LLGXqvgWhmQ@mail.gmail.com>
 <165212006050.5729.9059171256935942562.stgit@localhost.localdomain>
 <CANn89iL+r=dgW4ndjBBR=E0KQ0rBVshWMQOVmco0cZDbNXymrw@mail.gmail.com> <433e8f1e98c583d04798102f234aea6b566bef36.camel@gmail.com>
In-Reply-To: <433e8f1e98c583d04798102f234aea6b566bef36.camel@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 9 May 2022 13:31:15 -0700
Message-ID: <CANn89i+74TjkiuTwScqF0ML=R8cpvWZ6z0M-cSuh2g7fuhwnZQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] Replacements for patches 2 and 7 in Big TCP series
To:     Alexander H Duyck <alexander.duyck@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Coco Li <lixiaoyan@google.com>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-15.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 9, 2022 at 1:22 PM Alexander H Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Mon, 2022-05-09 at 11:54 -0700, Eric Dumazet wrote:
> > On Mon, May 9, 2022 at 11:17 AM Alexander Duyck
> > <alexander.duyck@gmail.com> wrote:
> > >
> > > This patch set is meant to replace patches 2 and 7 in the Big TCP series.
> > > From what I can tell it looks like they can just be dropped from the series
> > > and these two patches could be added to the end of the set.
> > >
> > > With these patches I have verified that both the loopback and mlx5 drivers
> > > are able to send and receive IPv6 jumbogram frames when configured with a
> > > g[sr]o_max_size value larger than 64K.
> > >
> > > Note I had to make one minor change to iproute2 to allow submitting a value
> > > larger than 64K in that I removed a check that was limiting gso_max_size to
> > > no more than 65536. In the future an alternative might be to fetch the
> > > IFLA_TSO_MAX_SIZE attribute if it exists and use that, and if not then use
> > > 65536 as the limit.
> >
> > OK, thanks.
> >
> > My remarks are :
> >
> > 1) Adding these enablers at the end of the series will not be
> > bisection friendly.
>
> They don't have to be added at the end, but essentially they could be
> drop in replacements for the two patches called out. I just called it
> out that way as that is what I ended up doing in order to test the
> patches, and to make it easier to just send them as a pair instead of
> sending the entire set. I moved them to the end of the list and was
> swapping between the 2 sets in my testing. I was able to reorder them
> without any issues. So if you wanted you could place these two patches
> as patches 2 and 7 in your series.
>
> > 2) Lots more changes, and more backport conflicts for us.
> >
> > I do not care really, it seems you absolutely hate the new attributes,
> > I can live with that,
> > but honestly this makes the BIG TCP patch series quite invasive.
>
> As it stands the BIG TCP patch series breaks things since it is
> outright overrriding the gso_max_size value in the case of IPv6/TCP
> frames. As I mentioned before this is going to force people to have to
> update scripts if they are reducing gso_max_size as they would also now
> need to update gso_ipv6_max_size.

If they never set  gso_ipv6_max_size, they do not have to change it.
If they set it, well, they get what they wanted.
Also, the driver value caps  gso_ipv6_max_size, so our patches broke nothing.

Some people could actually decide to limit IPV4 TSO packets to 40KB,
and yet limit
IPv6 packets to 128KB.
Their choice.
Apparently you think this is not a valid choice.


>
> It makes much more sense to me to allow people to push up the value
> from 64K to whatever value it is you want to allow for the IPv6/TCP GSO
> and then just cap the protocols if they cannot support it.
>
> As far as the backport/kcompat work it should be pretty straight
> forward. You just replace the references in the driver to GSO_MAX_SIZE
> with GSO_LEGACY_MAX_SIZE and then do a check in a header file somewhere
> via #ifndef and if it doesn't exist you define it.

Well, this is the kind of stuff that Intel loves to do in their
out-of-tree driver,
which is kind of horrible.

Look, I will spend fews days rebasing and testing a new series
including your patches,
no need to answer this email.

We will live with future merge conflicts, and errors because you
wanted to change
GSO_MAX_SIZE, instead of a clean change.
