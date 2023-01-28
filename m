Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 807CE67F9C1
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 18:09:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234068AbjA1RJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 12:09:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234014AbjA1RI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 12:08:58 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1DE124CA6;
        Sat, 28 Jan 2023 09:08:56 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id z1so2211190pfg.12;
        Sat, 28 Jan 2023 09:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bi2c0AiB4/LoswvJkjpv5gSlOvZirZv7Jl7L6GFn7Vg=;
        b=PwVIGVIB+CvI+Z0JJaJ5ZeywBMhuIrPTpLWZmAVS6rn5TFgVBBqsJvD8hCakBOQOuu
         MYtLH1w8NRHEOTVJM7kOd5fHWsMxOtPavGa4hUk79sOpRgGWjhEP2ixgton6x8S/zErF
         KprYIuirhzPaKgxGmRzLa9Gc2GXn2c2aSFkkQJqNfbX8i20306S789eZAHBLF/m1gDYq
         BlXjsSD2HyL9dwH5mdqqSTeHzMrL8PAQujeco2624/AvTDNa+EEncYIKuGimVQSgn63y
         OczuZS2QLGyh8S3a/ctV5uURgfT9C73QFGt+qPWxaQpBT1u3I73nVkqx3qRADRgsfhTi
         rpiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bi2c0AiB4/LoswvJkjpv5gSlOvZirZv7Jl7L6GFn7Vg=;
        b=11fyl/dlx440vRM+a3SwQyk4rJlRwDf6gIhyo+HuXzK4nUJ12SgyJ3/er6FswXxN8l
         AhRSbLdvJuEIPIntgGuKh7+054G0+sRSxLf8m05cRITwlo9SYnz2EucI0EwIt+UY3Chi
         2WoGTpDbhS5/fB1D85h2I1mLgtbquROiDBiREjzF46FH/U5d+pIYnWCmCp4G69rsQ3I4
         xixsN/4LqmPHSJzDKlWAfSgY8Mr04Rtkep0I6BZTsCkYL5/jzesanTvUCjh054mngl2x
         PwJ0iSRO1XxHKPkylYHr4GdjdAXx8yCm6GJ4KdhV+b2GS1TC28M4KgYLyojFUVVDnPEv
         YlIQ==
X-Gm-Message-State: AFqh2kpcgfarA6Q2qnxJajl6mMUhuR423oQiuFn/j/90afBMn2WLhYJ7
        C7gc8rmn/Xe+yWPF0vXaVh7JaUrkldRFWPME6N+gZu84
X-Google-Smtp-Source: AMrXdXspGTX67unMJYWstzl+rZ6PJ0WnkXGoeLIG43ZfDiHo9vj7qGT2h4kf5EIyjYoS6ogLjp7QsC6nfx51hba/Cuo=
X-Received: by 2002:a65:4d09:0:b0:4a0:8210:f47a with SMTP id
 i9-20020a654d09000000b004a08210f47amr4119853pgt.14.1674925736168; Sat, 28 Jan
 2023 09:08:56 -0800 (PST)
MIME-Version: 1.0
References: <04e27096-9ace-07eb-aa51-1663714a586d@nbd.name>
 <167475990764.1934330.11960904198087757911.stgit@localhost.localdomain>
 <cde24ed8-1852-ce93-69f3-ff378731f52c@huawei.com> <20230127212646.4cfeb475@kernel.org>
 <CANn89iL1x=Wis4xDRF=SJ-8_7FebY9y7hvG71gsvUPGXf6xwHA@mail.gmail.com>
In-Reply-To: <CANn89iL1x=Wis4xDRF=SJ-8_7FebY9y7hvG71gsvUPGXf6xwHA@mail.gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 28 Jan 2023 09:08:44 -0800
Message-ID: <CAKgT0UfWMNwzLmmAoR2oHW9DHmGRQSCLuscjH+4tXW+rdETMJg@mail.gmail.com>
Subject: Re: [net PATCH] skb: Do mix page pool and page referenced frags in GRO
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Yunsheng Lin <linyunsheng@huawei.com>, nbd@nbd.name,
        davem@davemloft.net, hawk@kernel.org, ilias.apalodimas@linaro.org,
        linux-kernel@vger.kernel.org, lorenzo@kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 27, 2023 at 11:16 PM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sat, Jan 28, 2023 at 6:26 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Sat, 28 Jan 2023 10:37:47 +0800 Yunsheng Lin wrote:
> > > If we are not allowing gro for the above case, setting NAPI_GRO_CB(p)->flush
> > > to 1 in gro_list_prepare() seems to be making more sense so that the above
> > > case has the same handling as skb_has_frag_list() handling?
> > > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/core/gro.c#L503
> > >
> > > As it seems to avoid some unnecessary operation according to comment
> > > in tcp4_gro_receive():
> > > https://elixir.bootlin.com/linux/v6.2-rc4/source/net/ipv4/tcp_offload.c#L322
> >
> > The frag_list case can be determined with just the input skb.
> > For pp_recycle we need to compare input skb's pp_recycle with
> > the pp_recycle of the skb already held by GRO.
> >
> > I'll hold off with applying a bit longer tho, in case Eric
> > wants to chime in with an ack or opinion.
>
> Doing the test only if the final step (once all headers have been
> verified) seems less costly
> for the vast majority of the cases the driver cooks skbs with a
> consistent pp_recycle bit ?
>
> So Alex patch seems less expensive to me than adding the check very early.

That was the general idea. Basically there is no need to look into
this until we are looking at merging the skb and it is very unlikely
that we will see a mix of page pool and non-page pool skbs. I
considered this check to be something equivalent to discovering there
is no space in the skb to store the frags so that is one of the
reasons why I had picked the spot that I did.
