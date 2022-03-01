Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D4D4C8A9B
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 12:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiCALYZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 06:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbiCALYZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 06:24:25 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A81690FDB
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 03:23:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646133823;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MEeutD72K6aSlBnghiDwpVSu8UxQf5mSoqEoa/rTviI=;
        b=V+LdXgBO/A0OwLns8UYzgAiHlPp/Dj2pkSABIIW02416P5SzQ8IPf318T6hWo/K5zhcIwc
        97zmlumo9ObYgtH62cp9Dv/cKCnHg9431HNplNfLZLOHye82MXHAnQtbXQ35JR3HVKsXc2
        jt+H0Sv+Yn5f0HdbrLETcIIm6dlGvwE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-618-VzxLndayPJ2UtgzyIxkM_A-1; Tue, 01 Mar 2022 06:23:42 -0500
X-MC-Unique: VzxLndayPJ2UtgzyIxkM_A-1
Received: by mail-ed1-f71.google.com with SMTP id l24-20020a056402231800b00410f19a3103so7633931eda.5
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 03:23:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=MEeutD72K6aSlBnghiDwpVSu8UxQf5mSoqEoa/rTviI=;
        b=js+P1rXCxRd5aMtCWYq+ATAGTRXF0aUtKgAuZ08+xYZrDjmL4oaE+F+qQmuwXIY+CC
         j013obOKm4NzFML8CUlJTjiLSe0Ju7ipcw4bzGKDyOUerri4+XP7qGZ4l4YDFwEPDANx
         ScHCYp6ysr5l60lq6odH3ivNV6ri5+5F4tfbAfvIZTjsAP97h+UKoMCFEytnS7C65Wk3
         peapaOIdCwDn3ezMvo2n9BNaWuY00J7flJ4B24JaFTD/EPmkBJmh8rtzmH0IOIzYJVCz
         3ObmhmLGAqVIMXIrYrz7LPvdE+9ZnsZDwoeQSJlvgxmKCtrXJgn3hnViMivdRqLuZXc3
         AB6w==
X-Gm-Message-State: AOAM530LzOuubtHkkRixdICVIKOwNQYwGnzfWZWnKUMzB3NhdmmZvlcd
        1XvA9zTRACfyS7aQAIUH4OoTo5w3plTNQPyPHy9sUXAi/kuDl2w6mherGNiv1z6Os/C9oLwPdG8
        FpmtINtVPMjBYgEzl
X-Received: by 2002:a05:6402:d5a:b0:413:2db4:b4ad with SMTP id ec26-20020a0564020d5a00b004132db4b4admr24132557edb.287.1646133819088;
        Tue, 01 Mar 2022 03:23:39 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxLfgpAA/Vzd9d/1MkB5pATh3YIKDylI7Pc+SuvZ8quAMDbIc6fsCS0ALStznwzVAGM2hi2iQ==
X-Received: by 2002:a05:6402:d5a:b0:413:2db4:b4ad with SMTP id ec26-20020a0564020d5a00b004132db4b4admr24132417edb.287.1646133816980;
        Tue, 01 Mar 2022 03:23:36 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q9-20020a17090609a900b006cd30a3c4f0sm5293851eje.147.2022.03.01.03.23.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Mar 2022 03:23:36 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0667413173F; Tue,  1 Mar 2022 12:23:35 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Joe Damato <jdamato@fastly.com>
Cc:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Subject: Re: [net-next v7 4/4] mlx5: add support for page_pool_get_stats
In-Reply-To: <CALALjgxJDF=WJBbExTn0ua5LoqHqGHe0a8MG0GifbbRptfruLQ@mail.gmail.com>
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-5-git-send-email-jdamato@fastly.com>
 <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
 <CALALjgxS0q+Vbg8rgrqTZ+CSV=9tXOTdxE7S4VGGnvsbicLE3A@mail.gmail.com>
 <87h78jxsrl.fsf@toke.dk>
 <CALALjgxJDF=WJBbExTn0ua5LoqHqGHe0a8MG0GifbbRptfruLQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 01 Mar 2022 12:23:34 +0100
Message-ID: <87a6e9dih5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Damato <jdamato@fastly.com> writes:

> On Mon, Feb 28, 2022 at 1:17 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Joe Damato <jdamato@fastly.com> writes:
>>
>> > On Sun, Feb 27, 2022 at 11:28 PM Jesper Dangaard Brouer
>> > <jbrouer@redhat.com> wrote:
>> >>
>> >>
>> >>
>> >> On 25/02/2022 18.41, Joe Damato wrote:
>> >> > +#ifdef CONFIG_PAGE_POOL_STATS
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fast=
) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow=
) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow=
_high_order) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_empt=
y) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_refi=
ll) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_waiv=
e) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_=
cached) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_=
cache_full) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_=
ring) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_=
ring_full) },
>> >> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_=
released_ref) },
>> >> > +#endif
>> >>
>> >> The naming: "page_pool_rec_xxx".
>> >> What does the "rec" stand for?
>> >
>> > rec stands for recycle.
>> >
>> > ethtool strings have a limited size (ETH_GSTRING_LEN - 32 bytes) and
>> > the full word "recycle" didn't fit for some of the stats once the
>> > queue number is prepended elsewhere in the driver code.
>> >
>> >> Users of ethtool -S stats... will they know "rec" is "recycle" ?
>> >
>> > I am open to other names or adding documentation to the driver docs to
>> > explain the meaning.
>>
>> You could shorten the 'page_pool_' prefix to 'ppool_' or even 'pp_' and
>> gain some characters that way?
>
> I had considered this, but I thought that 'pp' was possibly as terse as '=
rec'.
>
> If you all think these are more clear, I can send a v8 of this series
> that changes the strings from the above to this instead:
>
> rx_pp_alloc_fast
> rx_pp_alloc_slow
> rx_pp_alloc_...
>
> and
>
> rx_pp_recyle_cached
> rx_pp_recycle_cache_full
> rx_pp_recycle_...
>
> With this name scheme, it looks like all the stat names seem to fit. I
> have no idea if this is more or less clear to the user though :)

My thinking was that at least 'pp_' is obviously opaque, so it will be
clear to readers that if they don't know what it is they have to look it
up. Whereas 'rec_' looks like it could be 'record' or something like
that, and it'll make people guess (wrongly).

> I'll leave it up to the mlx5 maintainers; I am happy to do whatever
> they prefer to get this series in.

Right, but this is also going to create precedence for other drivers
that add the page pool-based stats, so spending a bit of time agreeing
on the colour of the bikeshed may be worthwhile here... :)

-Toke

