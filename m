Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E05C6487ED
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 18:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229680AbiLIRqf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 12:46:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229604AbiLIRqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 12:46:34 -0500
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A68813F2D
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 09:46:33 -0800 (PST)
Received: by mail-pj1-x1031.google.com with SMTP id u15-20020a17090a3fcf00b002191825cf02so5703541pjm.2
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 09:46:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HQ9dSEXwYBxA4pKSv/9YF2c2JcAm8IxKG1zQ6cKX/dc=;
        b=dYXP6fDzQN2V/qlc3SQr8N0jvIQ2duJ/fjb7ifX4vUlGuJLJ2+SspX1BrypjxiLwX9
         3CJ8ivbUM/t5qTU7Jm8mepJlGzlcVOMEzoJI2fgIapmCEuqj74it1aGl4jKTaMj4zQKU
         hXWqk1uuV+7fgfEeC4+7GWzoEF4MCI1sAJ/81KLLaFv5di9kdCBAYoZDdXkKwMyq7HB9
         oawG4p9VDqLGaGRka74ejvh9F+J3E+rNL7Hdp8ZqBwXD6+uJEbFSLoRW8U9ZM6WYIwCF
         4Y2JcN0wsDF5tCIHVO3mlnck3Kp4VlAvyQnQKn/VTDrU41nwROvzrhD0xnov5LTOUDzo
         RcxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HQ9dSEXwYBxA4pKSv/9YF2c2JcAm8IxKG1zQ6cKX/dc=;
        b=TD5jYcomEyMBeqqT+XJSZoKfvxg1NZDKk/5UEE2ld5IKbSfD8zaOXMZOmm4GZmSw3j
         X3TamNA1kZ2J9pzWriO6hcwTq0yLpsE64Z6I6rokrnyEVy2hUbKI//2dUwxxe36l09kr
         DPmi0JbVAJCxe+CMNRCHmWPBWMRl+X2xNkr765mMisI/xSRuFrTsS9N+rQJ9fM54cefj
         aAzNzr1q+oxC7Cy3cc/KYWpIdZdiSzq59HM0ANxkfpv3RbFMQbGgxwrTytSgY0lT+TKs
         7b0im5fOaTPcWxYbulFCEri6g2tJJrK9ZSZtJmIUiAji9V4Y1NTBFU5OJILqmrjeat6Y
         Uj0Q==
X-Gm-Message-State: ANoB5pmR9sXxX/efX6x95ip8XcX95W7+aPbCHQRYaTX49DhsGkfg+hOz
        Ijc5RVN3StG0QISja9FKCwacNOoveUx6ba/r1344vw==
X-Google-Smtp-Source: AA0mqf6J7OlXOVrlXIrOK83k51H3KpK5FYzmh8bzgATvgK+PzcS10dPMUBOH9FWm1W7UuPK/JhLJi793PsvGKg1gLfo=
X-Received: by 2002:a17:90a:6382:b0:219:fbc:a088 with SMTP id
 f2-20020a17090a638200b002190fbca088mr65443415pjj.162.1670607992729; Fri, 09
 Dec 2022 09:46:32 -0800 (PST)
MIME-Version: 1.0
References: <20221206024554.3826186-1-sdf@google.com> <20221206024554.3826186-12-sdf@google.com>
 <875yellcx6.fsf@toke.dk> <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
 <87359pl9zy.fsf@toke.dk> <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
 <87tu25ju77.fsf@toke.dk> <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
 <87o7sdjt20.fsf@toke.dk> <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
 <87cz8sk59e.fsf@toke.dk> <20221209084524.01c09d9c@kernel.org>
In-Reply-To: <20221209084524.01c09d9c@kernel.org>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Fri, 9 Dec 2022 09:46:20 -0800
Message-ID: <CAKH8qBsx4pPuvYenpM18NgdnGCG8QjqnsNY40Uc44EXTUVabMA@mail.gmail.com>
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP metadata
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Anatoly Burakov <anatoly.burakov@intel.com>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        Maryam Tahhan <mtahhan@redhat.com>, xdp-hints@xdp-project.net,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 9, 2022 at 8:45 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Fri, 09 Dec 2022 15:42:37 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote=
:
> > If we expect the program to do out of band probing, we could just get
> > rid of the _supported() functions entirely?
> >
> > I mean, to me, the whole point of having the separate _supported()
> > function for each item was to have a lower-overhead way of checking if
> > the metadata item was supported. But if the overhead is not actually
> > lower (because both incur a function call), why have them at all? Then
> > we could just change the implementation from this:
> >
> > bool mlx5e_xdp_rx_hash_supported(const struct xdp_md *ctx)
> > {
> >       const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
> >
> >       return _ctx->xdp.rxq->dev->features & NETIF_F_RXHASH;
> > }
> >
> > u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx)
> > {
> >       const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
> >
> >       return be32_to_cpu(_ctx->cqe->rss_hash_result);
> > }
> >
> > to this:
> >
> > u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx)
> > {
> >       const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
> >
> >       if (!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH))
> >                 return 0;
> >
> >       return be32_to_cpu(_ctx->cqe->rss_hash_result);
> > }
>
> Are there no corner cases? E.g. in case of an L2 frame you'd then
> expect a hash of 0? Rather than no hash?
>
> If I understand we went for the _supported() thing to make inlining
> the check easier than inlining the actual read of the field.
> But we're told inlining is a bit of a wait.. so isn't the motivation
> for the _supported() pretty much gone? And we should we go back to
> returning an error from the actual read?

Seems fair, we can always bring those _supported() calls back in the
future when the inlining is available and having those separate calls
shows clear benefit.
Then let's go back to a more conventional form below?

int mlx5e_xdp_rx_hash(const struct xdp_md *ctx, u32 *timestamp)
{
      const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;

       if (!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH))
                 return -EOPNOTSUPP;

       *timestamp =3D be32_to_cpu(_ctx->cqe->rss_hash_result);
       return 0;
 }

> Is partial inlining hard? (inline just the check and generate a full
> call for the read, ending up with the same code as with _supported())

I'm assuming you're suggesting to do this partial inlining manually
(as in, writing the code to output this bytecode)?
This probably also falls into the "manual bpf asm generation tech debt" buc=
ket?
LMK if I missed your point.
