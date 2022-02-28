Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F2694C6589
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 10:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233153AbiB1JRv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 04:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232997AbiB1JRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 04:17:51 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3BA6E506DC
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646039832;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xyoZS8R09K5R53F9xuxSDE0hn+q9/eWcNwXXBMh6nG0=;
        b=jF80iH1KoRwFxBEOl4V18ZUrTuK0eQBrRKMU5TDKzRnAd7RCFZGeqUeZR1p1++Fu5HCivK
        /Mj2RQloLos9Eu4EMswmMqg4WQwTttpASYlXYevgWquXpzJatyI2XpGpSm+vYz5NWO4bm2
        RZrjGh1KHi0wafA9dDg7T2dGYs6DT/c=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-372-7p3UWPCCMK62MY_Ku9Ww0g-1; Mon, 28 Feb 2022 04:17:09 -0500
X-MC-Unique: 7p3UWPCCMK62MY_Ku9Ww0g-1
Received: by mail-ed1-f70.google.com with SMTP id r11-20020a508d8b000000b00410a4fa4768so5437729edh.9
        for <netdev@vger.kernel.org>; Mon, 28 Feb 2022 01:17:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=xyoZS8R09K5R53F9xuxSDE0hn+q9/eWcNwXXBMh6nG0=;
        b=5s5A9BngM96fwXcCz9OR36pknSG/0Ibi+dUuNpg7q//lGWLaewZtfiqMMzbjAtp4xv
         CsoajJyfvKnxH68KbwrUCdLJQFcjpBZ6jcWeLthOmfb02zCEUqnvZS+S++Nx6SkQhgxA
         VicfYKhFOc6xvHahyfE7QIgDpL+t0mgw/e+G9vHU0XFyVL841O+KwhjAbns6DtaQuADN
         Dv8D2rF6hh/kBgFUP4kbu7IlchZvBN8g3UcZrDtfl2wo2XqU5oEdFnf3x3sQapCCUEqf
         kEi20Bz9XNT2TfU3Plv0QSyGvRyP9Cff/IkSklmo7ZxinEnSUCk8Jyk2OTMbhUHrRKs7
         SP+A==
X-Gm-Message-State: AOAM5334ktKmmLNjFNeNdIf2xumlRhUGdUPAvaIrygc4TetujTuDbgsp
        HpJ2Z3l6DS2vWmdZPMlbrWgrxepw7dlgqLybnDrjOKsJ2c02DuDxKjr0WnvZh4Z+NZQn63XOgjr
        o+GqRdOIMD4SlVmRY
X-Received: by 2002:a05:6402:268c:b0:411:e086:b7d1 with SMTP id w12-20020a056402268c00b00411e086b7d1mr18436329edd.111.1646039828409;
        Mon, 28 Feb 2022 01:17:08 -0800 (PST)
X-Google-Smtp-Source: ABdhPJx4k3lfxU3y0W6EYLg0D8NbUBDrOaRHbsOw1Nw53hmqO1B8mo2t7jPTO9wRmYPK0193RmQBmg==
X-Received: by 2002:a05:6402:268c:b0:411:e086:b7d1 with SMTP id w12-20020a056402268c00b00411e086b7d1mr18436301edd.111.1646039828049;
        Mon, 28 Feb 2022 01:17:08 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id w14-20020a509d8e000000b00412cf368b4csm5812029ede.53.2022.02.28.01.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 01:17:06 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id C8C7713100F; Mon, 28 Feb 2022 10:08:46 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Joe Damato <jdamato@fastly.com>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, hawk@kernel.org,
        saeed@kernel.org, ttoukan.linux@gmail.com, brouer@redhat.com
Subject: Re: [net-next v7 4/4] mlx5: add support for page_pool_get_stats
In-Reply-To: <CALALjgxS0q+Vbg8rgrqTZ+CSV=9tXOTdxE7S4VGGnvsbicLE3A@mail.gmail.com>
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-5-git-send-email-jdamato@fastly.com>
 <453c24e6-f9b1-0b7d-3144-7b3db1d94944@redhat.com>
 <CALALjgxS0q+Vbg8rgrqTZ+CSV=9tXOTdxE7S4VGGnvsbicLE3A@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 28 Feb 2022 10:08:46 +0100
Message-ID: <87h78jxsrl.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
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

> On Sun, Feb 27, 2022 at 11:28 PM Jesper Dangaard Brouer
> <jbrouer@redhat.com> wrote:
>>
>>
>>
>> On 25/02/2022 18.41, Joe Damato wrote:
>> > +#ifdef CONFIG_PAGE_POOL_STATS
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_fast) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_slow_high_order) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_empty) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_refill) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_waive) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cached) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_cache_full) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_ring_full) },
>> > +     { MLX5E_DECLARE_RX_STAT(struct mlx5e_rq_stats, page_pool_rec_released_ref) },
>> > +#endif
>>
>> The naming: "page_pool_rec_xxx".
>> What does the "rec" stand for?
>
> rec stands for recycle.
>
> ethtool strings have a limited size (ETH_GSTRING_LEN - 32 bytes) and
> the full word "recycle" didn't fit for some of the stats once the
> queue number is prepended elsewhere in the driver code.
>
>> Users of ethtool -S stats... will they know "rec" is "recycle" ?
>
> I am open to other names or adding documentation to the driver docs to
> explain the meaning.

You could shorten the 'page_pool_' prefix to 'ppool_' or even 'pp_' and
gain some characters that way?

-Toke

