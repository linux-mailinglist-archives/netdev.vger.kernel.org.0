Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92BEF6D550C
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 01:02:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233680AbjDCXCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 19:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbjDCXCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 19:02:35 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219ABE7C;
        Mon,  3 Apr 2023 16:02:34 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r11so123506887edd.5;
        Mon, 03 Apr 2023 16:02:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680562952; x=1683154952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=idbiGh/Ya6uIX+mzYB2rV5Qhy6GfPEhyNSP1LnCMOvw=;
        b=F8qCgBXulmMAgA4uX/HvTpCkkTA78It5Ay0WX+wC0m3fdny7VcYr5xK6qhGAvd49em
         UPUkMFayptoos9n0arvw66ok2KwzSDzK3etIoDz5NDwNBjrMGewFbjt2M7gNaiixQRiB
         ec8AUsNtIPvUCPvLiJfOqr4UXOaUFydOQrJxbjrM/8Cga871tsTqohCWjMyOjVJcELEl
         LmLoVKxVN+Vd5kVR+TPDum2eaImaMGZa67tvB+Fxlr0SjpTNCSvGcdp0wkO7TkWb0YvU
         5se00vVHNeAxT3+NJLtQoFGx7EWuNVY/vzuhfzhdaysj5bddsYxREPn4Fmy1LmN4C3/9
         eB6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680562952; x=1683154952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=idbiGh/Ya6uIX+mzYB2rV5Qhy6GfPEhyNSP1LnCMOvw=;
        b=4/WIqT4jMYLRWmGHbNWUChQ5UKMAMrOU9JRJb+WdcARd63KgWRFBalo/leToKE8FxY
         SH4b1MuA03n7OKG+vngq+yxHXKRQBrO0/hgFI2wP/suYHJQmCKpQItDeYTXqQAVvpbb2
         MIJjrYDr1M6RKwCbtog/X9BgFW+Xi5BiKOJS97oS+5rBNQNY0KUDGsKW9rBP3ocrbXpm
         tkqySvkxJtvquECT6dix5VEWNtjhVoWGm3oB4Vlq7O/Uha+Qc5TMIPmYMQtEnbB6a1zu
         P2kKBJPsSRH7UqBgKb/Zp34iCSLtICpAfv38Fe2zSPk6gLIo22FE7EIvyV53mW1r+aD1
         ciRQ==
X-Gm-Message-State: AAQBX9fq0OX6g3ngsABoXA63nDkxKKlsEcMcMmdHPd0YmqynrMvPbtka
        0tEEXAQTxQQhk4lpuEJuQRP9IjDJ978ASXWBrL4=
X-Google-Smtp-Source: AKy350YCrvXzZPu5fSnKVuKhW8RUVaKfBxcvGq3LzmM9l5vSftKYD875WlFhD/GHCCiGwm4WqTgscaBr5AtiNV9GQw8=
X-Received: by 2002:a17:906:f07:b0:924:32b2:e3d1 with SMTP id
 z7-20020a1709060f0700b0092432b2e3d1mr165085eji.3.1680562952478; Mon, 03 Apr
 2023 16:02:32 -0700 (PDT)
MIME-Version: 1.0
References: <168042409059.4051476.8176861613304493950.stgit@firesoul>
 <168042420344.4051476.9107061652824513113.stgit@firesoul> <CAADnVQ+JEP0sOyOOWbYKHackb4PmNYYcDGXnksucJt2mQGwi7g@mail.gmail.com>
 <CADRO9jPNbXW2TymTOS+nJGKLgbVtQRzmQTby=p62Ys1Ruf66Lg@mail.gmail.com>
In-Reply-To: <CADRO9jPNbXW2TymTOS+nJGKLgbVtQRzmQTby=p62Ys1Ruf66Lg@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 3 Apr 2023 16:02:21 -0700
Message-ID: <CAADnVQKYDzFkcVuh=EKzCQz=h=w95gP-j76Y9cYD7_jvW8MkuA@mail.gmail.com>
Subject: Re: [PATCH bpf V6 5/5] selftests/bpf: Adjust bpf_xdp_metadata_rx_hash
 for new arg
To:     Jesper Brouer <jbrouer@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        bpf <bpf@vger.kernel.org>, Stanislav Fomichev <sdf@google.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Larysa Zaremba <larysa.zaremba@intel.com>,
        xdp-hints@xdp-project.net,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "Song, Yoong Siang" <yoong.siang.song@intel.com>,
        "Ong, Boon Leong" <boon.leong.ong@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 3, 2023 at 8:08=E2=80=AFAM Jesper Brouer <jbrouer@redhat.com> w=
rote:
>
>
>
> s=C3=B8n. 2. apr. 2023 17.50 skrev Alexei Starovoitov <alexei.starovoitov=
@gmail.com>:
>>
>> On Sun, Apr 2, 2023 at 1:30=E2=80=AFAM Jesper Dangaard Brouer <brouer@re=
dhat.com> wrote:
>> >
>> > Update BPF selftests to use the new RSS type argument for kfunc
>> > bpf_xdp_metadata_rx_hash.
>> >
>> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
>> > Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>> > Acked-by: Stanislav Fomichev <sdf@google.com>
>> > ---
>> >  .../selftests/bpf/prog_tests/xdp_metadata.c        |    2 ++
>> >  .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   14 +++++++++--=
---
>> >  tools/testing/selftests/bpf/progs/xdp_metadata.c   |    6 +++---
>> >  tools/testing/selftests/bpf/progs/xdp_metadata2.c  |    7 ++++---
>> >  tools/testing/selftests/bpf/xdp_hw_metadata.c      |    2 +-
>> >  tools/testing/selftests/bpf/xdp_metadata.h         |    1 +
>> >  6 files changed, 20 insertions(+), 12 deletions(-)
>> >
>> > diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/t=
ools/testing/selftests/bpf/prog_tests/xdp_metadata.c
>> > index aa4beae99f4f..8c5e98da9ae9 100644
>> > --- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
>> > +++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
>> > @@ -273,6 +273,8 @@ static int verify_xsk_metadata(struct xsk *xsk)
>> >         if (!ASSERT_NEQ(meta->rx_hash, 0, "rx_hash"))
>> >                 return -1;
>> >
>> > +       ASSERT_EQ(meta->rx_hash_type, 0, "rx_hash_type");
>> > +
>> >         xsk_ring_cons__release(&xsk->rx, 1);
>> >         refill_rx(xsk, comp_addr);
>> >
>> > diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/too=
ls/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> > index 4c55b4d79d3d..7b3fc12e96d6 100644
>> > --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> > +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
>> > @@ -14,8 +14,8 @@ struct {
>> >
>> >  extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
>> >                                          __u64 *timestamp) __ksym;
>> > -extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
>> > -                                   __u32 *hash) __ksym;
>> > +extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx, __u32 *=
hash,
>> > +                                   enum xdp_rss_hash_type *rss_type) =
__ksym;
>> >
>> >  SEC("xdp")
>> >  int rx(struct xdp_md *ctx)
>> > @@ -74,10 +74,14 @@ int rx(struct xdp_md *ctx)
>> >         else
>> >                 meta->rx_timestamp =3D 0; /* Used by AF_XDP as not ava=
il signal */
>> >
>> > -       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash))
>> > -               bpf_printk("populated rx_hash with %u", meta->rx_hash)=
;
>> > -       else
>> > +       if (!bpf_xdp_metadata_rx_hash(ctx, &meta->rx_hash, &meta->rx_h=
ash_type)) {
>> > +               bpf_printk("populated rx_hash:0x%X type:0x%X",
>> > +                          meta->rx_hash, meta->rx_hash_type);
>> > +               if (!(meta->rx_hash_type & XDP_RSS_L4))
>> > +                       bpf_printk("rx_hash low quality L3 hash type")=
;
>> > +       } else {
>> >                 meta->rx_hash =3D 0; /* Used by AF_XDP as not avail si=
gnal */
>> > +       }
>>
>> Didn't we agree in the previous thread to remove these printks and
>> replace them with actual stats that user space can see?
>
>
> This patchset is for bpf-tree RC version of kernel.
> Thus, we keep changes to a minimum.
>
> I/we will do printk work on bpf-next.
> (Once I get home from vacation next week)

Sorry, but I insist on making them in this set.
We did bigger changes in bpf tree, so size is not an issue.
I don't want to remember to ping you every week or so to
remind you to fix this later after bpf gets merged into bpf-next.
Less work for me and less work for you to do it now.
