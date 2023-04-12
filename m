Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACFFF6DFD19
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229846AbjDLR4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbjDLR42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:56:28 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E97259E2
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:56:26 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-63b145b3b03so1135791b3a.1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:56:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681322186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qC0J8ipO5xQolwxkiv40AtEnP8cuuUuoL3jFk2sT+xU=;
        b=av8In+IitDjEfmXBb9r8y8s0KgzNn33ghSZo9Q/jk4j+WAQ5n6xIBxI+GILpW98Qjw
         oKqYBzlcPSNfQuz1T69VJyUyRwvNF/j1lnG0AMnQtClFfd7W6vLOWA8ExKcFUGkAMoiL
         c+KXy6wLSah2RlGIMcie47xhVxhomLX2VJIb3ltpPCiVYD5+ca2hswJ9XChNykGs4tdB
         VwdC+KKIT3eSVFNuUeV4lTAhDPDqIXvieEuOSL97MDHwy0um3O9kg91OHYu2xjAT975e
         VAVOVzTiaIMUEkK7ELglagPtiCc/pLzAjvdlMLzVHhW6Pajbj2DDxksiWeVuMvgLYttB
         KqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681322186;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qC0J8ipO5xQolwxkiv40AtEnP8cuuUuoL3jFk2sT+xU=;
        b=OJAFUwD/oO+V1QT6KWp5NGBTwHkYk/y8vNaVdOug20VAZHoQky44kguY60H+GQ8dcQ
         MoBh6Ycmq/isaIE8S08me/texUaoHWfDNhYudJZhXx6li6gcMEtkSbbZrXdVe5flGpyL
         eMLS8wWnHP5vySQXGekXWSOvej86GbWooLX040rtIF6HI51zO3lGI3InZIdYRmoJKr4L
         E6cHkyo9UvSEUA50s+Qc+ctyqBY+Azq8aaHuiPDTPIXX3a/VhZARu0+YhBUWjBvY4Zly
         5LBqvVqFpOYSDOBNhYqqJr9hJBsdFnqRz5h9aO/p/9DzLgSYhLjmD3gSh6zoKV9I2Rx7
         kU8Q==
X-Gm-Message-State: AAQBX9csUxI6l3Yi+bQpozmP6h22CEDVP41TiLzr1aFnLH8q8cQwHsfY
        6rVm0hoavNplkbxIl8gt0xj4DtXfeyROQ13dz/FQ0w==
X-Google-Smtp-Source: AKy350bTungGNSfBzyJElO3L4Pqje2XW5a7VPmPwAVWRYoIgihrJFvryebkoCdI1ykq4RWf0nveqt5LC2WxIaa+L08g=
X-Received: by 2002:a05:6a00:2d22:b0:632:e692:55b2 with SMTP id
 fa34-20020a056a002d2200b00632e69255b2mr1762332pfb.2.1681322185562; Wed, 12
 Apr 2023 10:56:25 -0700 (PDT)
MIME-Version: 1.0
References: <168130333143.150247.11159481574477358816.stgit@firesoul>
 <168130336725.150247.12193228778654006957.stgit@firesoul> <ZDbiofWhQhFEfIsr@google.com>
 <34152b76-88c8-0848-9f30-bd9755b1ee25@redhat.com>
In-Reply-To: <34152b76-88c8-0848-9f30-bd9755b1ee25@redhat.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 12 Apr 2023 10:56:14 -0700
Message-ID: <CAKH8qBub-b0R42k-J=3gyvKeWVDBy7DoxQCn7GAynEDB8z9rbw@mail.gmail.com>
Subject: Re: [PATCH bpf V8 2/7] selftests/bpf: Add counters to xdp_hw_metadata
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>
Cc:     brouer@redhat.com, bpf@vger.kernel.org,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        alexandr.lobakin@intel.com, larysa.zaremba@intel.com,
        xdp-hints@xdp-project.net, anthony.l.nguyen@intel.com,
        yoong.siang.song@intel.com, boon.leong.ong@intel.com,
        intel-wired-lan@lists.osuosl.org, pabeni@redhat.com,
        jesse.brandeburg@intel.com, kuba@kernel.org, edumazet@google.com,
        john.fastabend@gmail.com, hawk@kernel.org, davem@davemloft.net,
        tariqt@nvidia.com, saeedm@nvidia.com, leon@kernel.org,
        linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 12, 2023 at 10:52=E2=80=AFAM Jesper Dangaard Brouer
<jbrouer@redhat.com> wrote:
>
>
> On 12/04/2023 18.56, Stanislav Fomichev wrote:
> > On 04/12, Jesper Dangaard Brouer wrote:
> >> Add counters for skipped, failed and redirected packets.
> >> The xdp_hw_metadata program only redirects UDP port 9091.
> >> This helps users to quickly identify then packets are
> >> skipped and identify failures of bpf_xdp_adjust_meta.
> >>
> >> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> >> ---
> >>   .../testing/selftests/bpf/progs/xdp_hw_metadata.c  |   15 ++++++++++=
+++--
> >>   tools/testing/selftests/bpf/xdp_hw_metadata.c      |    4 +++-
> >>   2 files changed, 16 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c b/too=
ls/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >> index b0104763405a..a07ef7534013 100644
> >> --- a/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >> +++ b/tools/testing/selftests/bpf/progs/xdp_hw_metadata.c
> >> @@ -25,6 +25,10 @@ struct {
> >>      __type(value, __u32);
> >>   } xsk SEC(".maps");
> >>
> >> +volatile __u64 pkts_skip =3D 0;
> >> +volatile __u64 pkts_fail =3D 0;
> >> +volatile __u64 pkts_redir =3D 0;
> >> +
> >>   extern int bpf_xdp_metadata_rx_timestamp(const struct xdp_md *ctx,
> >>                                       __u64 *timestamp) __ksym;
> >>   extern int bpf_xdp_metadata_rx_hash(const struct xdp_md *ctx,
> >> @@ -59,16 +63,21 @@ int rx(struct xdp_md *ctx)
> >>                      udp =3D NULL;
> >>      }
> >>
> >> -    if (!udp)
> >> +    if (!udp) {
> >> +            pkts_skip++;
> >>              return XDP_PASS;
> >> +    }
> >>
> >>      /* Forwarding UDP:9091 to AF_XDP */
> >> -    if (udp->dest !=3D bpf_htons(9091))
> >> +    if (udp->dest !=3D bpf_htons(9091)) {
> >> +            pkts_skip++;
> >>              return XDP_PASS;
> >> +    }
> >>
> >>      ret =3D bpf_xdp_adjust_meta(ctx, -(int)sizeof(struct xdp_meta));
> >>      if (ret !=3D 0) {
> >
> > [..]
> >
> >>              bpf_printk("bpf_xdp_adjust_meta returned %d", ret);
> >
> > Maybe let's remove these completely? Merge patch 1 and 2, remove printk=
,
> > add counters. We can add more counters in the future if the existing
> > ones are not enough.. WDYT?
> >
>
> Sure, lets just remove all of the bpf_printk, and add these counter inste=
ad.
> Rolling V9.
>
> >> +            pkts_fail++;
>
> This fail counter should be enough for driver devel to realize that they
> also need to implement/setup XDP metadata pointers correctly (for
> bpf_xdp_adjust_meta to work).

Agreed. As long as we have a clear signal "something's not working"
(instead of failing silently), that should be enough to get to the
bottom of it..

> >>              return XDP_PASS;
> >>      }
>
