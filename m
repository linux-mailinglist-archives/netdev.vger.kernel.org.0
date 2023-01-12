Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAA46686FF
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 23:32:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbjALWcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 17:32:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240503AbjALWbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 17:31:36 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD7E637266
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:30:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1673562602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AmmMTMTkl1SpATAvKbKhhENq0+Dt4nDr+jehSO4eUlc=;
        b=DXZnzuNfihmqAr9GUGiqoymcbTIuNU19yeQN6ZdQZix/TBB3Xz3RcktDQgkzz2bSGNRC7S
        2fmY3251VhAvn0QChh4rTQHuqH1hGrTpyB5RnJPymduUum9LW95vUS4qhaI7kucmQcxO1y
        2ensxCDUhw/sxJJx8FEC1y5mBk0rJ+o=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-367-7d5g5STfM7izumR4gK8oog-1; Thu, 12 Jan 2023 17:30:00 -0500
X-MC-Unique: 7d5g5STfM7izumR4gK8oog-1
Received: by mail-ej1-f71.google.com with SMTP id ga21-20020a1709070c1500b007c171be7cd7so13846242ejc.20
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 14:30:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AmmMTMTkl1SpATAvKbKhhENq0+Dt4nDr+jehSO4eUlc=;
        b=5i+BNitg9PgiNvrp2fERMkbhw1EtlicbTZeEwlMVQApSfMH0T3JQoiT8SWig2taicc
         MfE3fUO1MqSCsz7esNSl6sNmK3jg779Ehqq63NUQumtUk9N4ikchPefBNEwqX27n9SEm
         A7Eh5J/y/0N1UkoSlswUP8jzs1yHLwTjfLEWp18KhVcRIwpvx6h4sz2DS15kHuJJT+HL
         v+Y4/obl9sfFdQlfzf+/kr13s+iigzOJLkT8E+61zlO83ibhJ5F39wcC+rnB59RDsGIb
         EyjwCFCs7L0buNh4Oqcmjx4vLaBLoD5rk9SNnGz2oVW5OcD+UoKk9M43MRyO9VwsfqS1
         TJJg==
X-Gm-Message-State: AFqh2kpmYrL/9TP1BX+W9XCv//Asr1tbCCaYqCuVzuote/OnVt9Sxi6j
        KoNjRo3GTMbQyJwm5aJlumEfp8dakv2YgEwAN29JVVTpfubLqEKHHyGWyNeBADonVfeyNHO4pCX
        wRcM4hLMLxZWb2dru
X-Received: by 2002:a17:906:9f20:b0:84d:43a0:7090 with SMTP id fy32-20020a1709069f2000b0084d43a07090mr15422511ejc.77.1673562599654;
        Thu, 12 Jan 2023 14:29:59 -0800 (PST)
X-Google-Smtp-Source: AMrXdXsqPdHBhI5sdFZhQI7ZFU9LyJiPErvoKHj1tV1uSh9/yzeA+17qJ9uEVoWX2vLXSimcX2vkQQ==
X-Received: by 2002:a17:906:9f20:b0:84d:43a0:7090 with SMTP id fy32-20020a1709069f2000b0084d43a07090mr15422479ejc.77.1673562599344;
        Thu, 12 Jan 2023 14:29:59 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id c10-20020a17090618aa00b0084d14646fd9sm7751190ejf.165.2023.01.12.14.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Jan 2023 14:29:58 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 45232900731; Thu, 12 Jan 2023 23:29:58 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Tariq Toukan <ttoukan.linux@gmail.com>, bpf@vger.kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com,
        jolsa@kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        netdev@vger.kernel.org
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v7 15/17] net/mlx5e: Introduce
 wrapper for xdp_buff
In-Reply-To: <CAKH8qBvBsAj0s36=xHKz3XN5Nq1bDcEP1AOsnf9+Sgtm5wWUyQ@mail.gmail.com>
References: <20230112003230.3779451-1-sdf@google.com>
 <20230112003230.3779451-16-sdf@google.com>
 <a0bac9bd-6772-64d4-8fd5-756ff4d8c2ad@gmail.com>
 <CAKH8qBsUOdRax0m5XM8guudSX_VYpJuMz_mzdMJegDsq4_ezwA@mail.gmail.com>
 <87k01rfojm.fsf@toke.dk> <87h6wvfmfa.fsf@toke.dk>
 <CAKH8qBvBsAj0s36=xHKz3XN5Nq1bDcEP1AOsnf9+Sgtm5wWUyQ@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 12 Jan 2023 23:29:58 +0100
Message-ID: <87edrzfkt5.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stanislav Fomichev <sdf@google.com> writes:

> On Thu, Jan 12, 2023 at 1:55 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@re=
dhat.com> wrote:
>>
>> Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:
>>
>> > Stanislav Fomichev <sdf@google.com> writes:
>> >
>> >> On Thu, Jan 12, 2023 at 12:07 AM Tariq Toukan <ttoukan.linux@gmail.co=
m> wrote:
>> >>>
>> >>>
>> >>>
>> >>> On 12/01/2023 2:32, Stanislav Fomichev wrote:
>> >>> > From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>> >
>> >>> > Preparation for implementing HW metadata kfuncs. No functional cha=
nge.
>> >>> >
>> >>> > Cc: Tariq Toukan <tariqt@nvidia.com>
>> >>> > Cc: Saeed Mahameed <saeedm@nvidia.com>
>> >>> > Cc: John Fastabend <john.fastabend@gmail.com>
>> >>> > Cc: David Ahern <dsahern@gmail.com>
>> >>> > Cc: Martin KaFai Lau <martin.lau@linux.dev>
>> >>> > Cc: Jakub Kicinski <kuba@kernel.org>
>> >>> > Cc: Willem de Bruijn <willemb@google.com>
>> >>> > Cc: Jesper Dangaard Brouer <brouer@redhat.com>
>> >>> > Cc: Anatoly Burakov <anatoly.burakov@intel.com>
>> >>> > Cc: Alexander Lobakin <alexandr.lobakin@intel.com>
>> >>> > Cc: Magnus Karlsson <magnus.karlsson@gmail.com>
>> >>> > Cc: Maryam Tahhan <mtahhan@redhat.com>
>> >>> > Cc: xdp-hints@xdp-project.net
>> >>> > Cc: netdev@vger.kernel.org
>> >>> > Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> >>> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>> >>> > ---
>> >>> >   drivers/net/ethernet/mellanox/mlx5/core/en.h  |  1 +
>> >>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.c  |  3 +-
>> >>> >   .../net/ethernet/mellanox/mlx5/core/en/xdp.h  |  6 +-
>> >>> >   .../ethernet/mellanox/mlx5/core/en/xsk/rx.c   | 25 ++++----
>> >>> >   .../net/ethernet/mellanox/mlx5/core/en_rx.c   | 58 +++++++++----=
------
>> >>> >   5 files changed, 50 insertions(+), 43 deletions(-)
>> >>> >
>> >>> > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/driver=
s/net/ethernet/mellanox/mlx5/core/en.h
>> >>> > index 2d77fb8a8a01..af663978d1b4 100644
>> >>> > --- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> >>> > +++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
>> >>> > @@ -469,6 +469,7 @@ struct mlx5e_txqsq {
>> >>> >   union mlx5e_alloc_unit {
>> >>> >       struct page *page;
>> >>> >       struct xdp_buff *xsk;
>> >>> > +     struct mlx5e_xdp_buff *mxbuf;
>> >>>
>> >>> In XSK files below you mix usage of both alloc_units[page_idx].mxbuf=
 and
>> >>> alloc_units[page_idx].xsk, while both fields share the memory of a u=
nion.
>> >>>
>> >>> As struct mlx5e_xdp_buff wraps struct xdp_buff, I think that you just
>> >>> need to change the existing xsk field type from struct xdp_buff *xsk
>> >>> into struct mlx5e_xdp_buff *xsk and align the usage.
>> >>
>> >> Hmmm, good point. I'm actually not sure how it works currently.
>> >> mlx5e_alloc_unit.mxbuf doesn't seem to be initialized anywhere? Toke,
>> >> am I missing something?
>> >
>> > It's initialised piecemeal in different places; but yeah, we're mixing
>> > things a bit...
>> >
>> >> I'm thinking about something like this:
>
> Seems more invasive? I don't care much tbf, but what's wrong with
> keeping 'xdp_buff xsk' member and use it consistently?

Yeah, it's more invasive, but it's also more consistent with the non-xsk
path where every usage of struct xdp_buff is replaced with the wrapping
struct?

Both will work, I suppose (in fact I think the resulting code will be
more or less identical), so it's more a matter of which one is easier to
read and where we put the type-safety-breaking casts.

I can live with either one (just note you'll have to move the
'mxbuf->rq' initialisation next to the one for mxbuf->cqe for yours, but
that's probably fine too). Let's see which way Tariq prefers...

-Toke

