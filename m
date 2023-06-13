Return-Path: <netdev+bounces-10490-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6AC272EB68
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 21:01:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23B521C208EA
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 19:01:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D76A22E41;
	Tue, 13 Jun 2023 19:00:53 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FDC922E27
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 19:00:53 +0000 (UTC)
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183ED196
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:52 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-543ae674f37so3207658a12.1
        for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 12:00:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686682851; x=1689274851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qmnlwwzcOwxvuG8cMk+8+qPGD+YwPIaDMpCzLMqGieI=;
        b=oJvKk7Y1GbtMKKX7TOC0OMEkD4FGlUyRgPt6gI6sjCQCczSoG+9wRVdn4ouwsHuzDC
         wyTeKdapUUnGqHP971OuLLs5cVj2FguUtNeIT31qIFRsoQvRtDMvVq00qvlemzwyLGQF
         cj8bgtwK2umzxp4nYRLeYBrQk3o8B2Q5cKT+6DJYeelL6zYziljHn7G0Zzoiz1+Ywx/4
         NhoifEk4HVnng5usQq+oq2gjqwMoCMmkwC6R7jm9kC2n57x4KnL72ERzHgAAq0QcjwDb
         eGS4O/EJcDy6xUqyF61M1MzRITUHg+Vrd+7D2slv9WDe4ur0K/y3W9+EooeVmQADM891
         DuCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686682851; x=1689274851;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qmnlwwzcOwxvuG8cMk+8+qPGD+YwPIaDMpCzLMqGieI=;
        b=HDt+JtgtTDTFEuiIS5UXYISh1xYTZZf304Hr4TzyerLWEVMzjqqQv+o+lyQmSD3f1j
         /anXG9PMJvQmwnxPkfjdodFqCAtvipQMYhat4RzEBlglXN0gl/VyJllvlnKKfLnfM8yo
         y+qBSOVhZ+5f4GYfWCUzX0F8SrWIO93Kp0EWnvuORf0Dh0yWcjzfC5mb0f5gvgvG/5JW
         hVhBplIO2ZfjX5QrE3wRIIsDk7DgLiutCPOOb2jeNskjeTAwp2HVmB/lV6RCXb2QsCSA
         gBlFfCpc0DJ6dmfN1iKpK8LSYQAyJfWNke2BhR3VR0eLttjjoUi+04jAhcFiS5tm2Q82
         wG4g==
X-Gm-Message-State: AC+VfDw1rzLu2rNS3csycZBRXW4i2TXzJ995/t2HUPC+HKE1tWIZn1PV
	19KOGENCxyD0JcvGRhn/Ll0LMTyyuKrw1YbNq/YQGg==
X-Google-Smtp-Source: ACHHUZ4Af54H7nlcyteKbjH6Zb1ag8zWwPHsPsl14JA3RCylILQceMCPwntjoHigLljgb1YxKyE9qYwGp3R3Bv7Z6ZE=
X-Received: by 2002:a17:90a:ab8e:b0:253:45e5:af5c with SMTP id
 n14-20020a17090aab8e00b0025345e5af5cmr11795274pjq.32.1686682851430; Tue, 13
 Jun 2023 12:00:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230612172307.3923165-1-sdf@google.com> <20230612172307.3923165-8-sdf@google.com>
 <CAF=yD-LgMsmXgQkg=gTnknnppM7CrUVRD8Wg-9XcdvB3PY8wAg@mail.gmail.com>
In-Reply-To: <CAF=yD-LgMsmXgQkg=gTnknnppM7CrUVRD8Wg-9XcdvB3PY8wAg@mail.gmail.com>
From: Stanislav Fomichev <sdf@google.com>
Date: Tue, 13 Jun 2023 12:00:38 -0700
Message-ID: <CAKH8qBt4W41i2RAu0rNv6jQjdpMtjX0H3JZUawCyKu5jFqTWxg@mail.gmail.com>
Subject: Re: [RFC bpf-next 7/7] selftests/bpf: extend xdp_hw_metadata with
 devtx kfuncs
To: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net, 
	andrii@kernel.org, martin.lau@linux.dev, song@kernel.org, yhs@fb.com, 
	john.fastabend@gmail.com, kpsingh@kernel.org, haoluo@google.com, 
	jolsa@kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, Jun 13, 2023 at 8:03=E2=80=AFAM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> On Mon, Jun 12, 2023 at 7:26=E2=80=AFPM Stanislav Fomichev <sdf@google.co=
m> wrote:
> >
> > When we get packets on port 9091, we swap src/dst and send it out.
> > At this point, we also request the timestamp and plumb it back
> > to the userspace. The userspace simply prints the timestamp.
> >
> > Haven't really tested, still working on mlx5 patches...
> >
> > Cc: netdev@vger.kernel.org
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
>
>
> > +++ b/tools/testing/selftests/bpf/xdp_hw_metadata.c
> > @@ -10,7 +10,8 @@
> >   *   - rx_hash
> >   *
> >   * TX:
> > - * - TBD
> > + * - UDP 9091 packets trigger TX reply
>
> This branch on port is missing?

That's the ping_pong part. Evey packet arriving on 9091 port gets
received by af_xdp and is sent back.

> > +static void ping_pong(struct xsk *xsk, void *rx_packet)
> > +{
> > +       struct ipv6hdr *ip6h =3D NULL;
> > +       struct iphdr *iph =3D NULL;
> > +       struct xdp_desc *tx_desc;
> > +       struct udphdr *udph;
> > +       struct ethhdr *eth;
> > +       void *data;
> > +       __u32 idx;
> > +       int ret;
> > +       int len;
> > +
> > +       ret =3D xsk_ring_prod__reserve(&xsk->tx, 1, &idx);
> > +       if (ret !=3D 1) {
> > +               printf("%p: failed to reserve tx slot\n", xsk);
> > +               return;
> > +       }
> > +
> > +       tx_desc =3D xsk_ring_prod__tx_desc(&xsk->tx, idx);
> > +       tx_desc->addr =3D idx % (UMEM_NUM / 2) * UMEM_FRAME_SIZE;
> > +       data =3D xsk_umem__get_data(xsk->umem_area, tx_desc->addr);
> > +
> > +       eth =3D data;
> > +
> > +       if (eth->h_proto =3D=3D htons(ETH_P_IP)) {
> > +               iph =3D (void *)(eth + 1);
> > +               udph =3D (void *)(iph + 1);
> > +       } else if (eth->h_proto =3D=3D htons(ETH_P_IPV6)) {
> > +               ip6h =3D (void *)(eth + 1);
> > +               udph =3D (void *)(ip6h + 1);
> > +       } else {
> > +               xsk_ring_prod__cancel(&xsk->tx, 1);
> > +               return;
> > +       }
> > +
> > +       len =3D ETH_HLEN;
> > +       if (ip6h)
> > +               len +=3D ntohs(ip6h->payload_len);
>
> sizeof(*ip6h) + ntohs(ip6h->payload_len) ?

Ooop, thanks, that's clearly not tested :-)

> > +       if (iph)
> > +               len +=3D ntohs(iph->tot_len);
> > +
> > +       memcpy(data, rx_packet, len);
> > +       swap(eth->h_dest, eth->h_source, ETH_ALEN);
> > +       if (iph)
> > +               swap(&iph->saddr, &iph->daddr, 4);
>
> need to recompute ipv4 checksum?

Discussed offline: swapping the aligned-u16 chunks preserves the checksum.

