Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39BB36486B6
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 17:45:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229793AbiLIQph (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 11:45:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiLIQpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 11:45:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6F4289AE5;
        Fri,  9 Dec 2022 08:45:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FE66622B2;
        Fri,  9 Dec 2022 16:45:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE0FC433D2;
        Fri,  9 Dec 2022 16:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670604326;
        bh=y9ju5uWeIvPH5xCPeQBcrFadw2lTaWjzkAGNG7iNTAQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fyE/CIxDGjWaUL0DLNshTMZ1OLUruLbVpHvrC61X21127DREq2ElfVR/r9oxf2evI
         VE+faV6CiOQrmW+Q5IDLeEttgAIy3f9iLs0Bk8hB8uhjEK0/wSQjCYPLFdRA/wo+X9
         jNx19EbIQj3FSi/15GyHrmQkaIyTJWXBQXAZld0+8NZPAQlGR9+AuzZL//huJJ/RuT
         Bh4ek2x38/DIFZRNfDekKCyHTB1eWRG6e6tpIZUnyKppl5ORiKnkeAuLGydtR4MuTT
         XNv/HG/4jv1y8EFUVbfSSgLIWdLaGV4k/valaLbAuyaBcL48VWWxbNwKpx/aAR9JEt
         2QMlH8EDn1o1A==
Date:   Fri, 9 Dec 2022 08:45:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Stanislav Fomichev <sdf@google.com>,
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
Subject: Re: [xdp-hints] Re: [PATCH bpf-next v3 11/12] mlx5: Support RX XDP
 metadata
Message-ID: <20221209084524.01c09d9c@kernel.org>
In-Reply-To: <87cz8sk59e.fsf@toke.dk>
References: <20221206024554.3826186-1-sdf@google.com>
        <20221206024554.3826186-12-sdf@google.com>
        <875yellcx6.fsf@toke.dk>
        <CAKH8qBv7nWdknuf3ap_ekpAhMgvtmoJhZ3-HRuL8Wv70SBWMSQ@mail.gmail.com>
        <87359pl9zy.fsf@toke.dk>
        <CAADnVQ+=71Y+ypQTOgFTJWY7w3YOUdY39is4vpo3aou11=eMmw@mail.gmail.com>
        <87tu25ju77.fsf@toke.dk>
        <CAADnVQ+MyE280Q-7iw2Y-P6qGs4xcDML-tUrXEv_EQTmeESVaQ@mail.gmail.com>
        <87o7sdjt20.fsf@toke.dk>
        <CAKH8qBswBu7QAWySWOYK4X41mwpdBj0z=6A9WBHjVYQFq9Pzjw@mail.gmail.com>
        <87cz8sk59e.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 09 Dec 2022 15:42:37 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> If we expect the program to do out of band probing, we could just get
> rid of the _supported() functions entirely?
>=20
> I mean, to me, the whole point of having the separate _supported()
> function for each item was to have a lower-overhead way of checking if
> the metadata item was supported. But if the overhead is not actually
> lower (because both incur a function call), why have them at all? Then
> we could just change the implementation from this:
>=20
> bool mlx5e_xdp_rx_hash_supported(const struct xdp_md *ctx)
> {
> 	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
>=20
> 	return _ctx->xdp.rxq->dev->features & NETIF_F_RXHASH;
> }
>=20
> u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx)
> {
> 	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
>=20
> 	return be32_to_cpu(_ctx->cqe->rss_hash_result);
> }
>=20
> to this:
>=20
> u32 mlx5e_xdp_rx_hash(const struct xdp_md *ctx)
> {
> 	const struct mlx5_xdp_buff *_ctx =3D (void *)ctx;
>=20
> 	if (!(_ctx->xdp.rxq->dev->features & NETIF_F_RXHASH))
>                 return 0;
>=20
> 	return be32_to_cpu(_ctx->cqe->rss_hash_result);
> }

Are there no corner cases? E.g. in case of an L2 frame you'd then
expect a hash of 0? Rather than no hash?=20

If I understand we went for the _supported() thing to make inlining=20
the check easier than inlining the actual read of the field.
But we're told inlining is a bit of a wait.. so isn't the motivation
for the _supported() pretty much gone? And we should we go back to
returning an error from the actual read?

Is partial inlining hard? (inline just the check and generate a full
call for the read, ending up with the same code as with _supported())
