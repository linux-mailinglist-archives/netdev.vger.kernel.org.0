Return-Path: <netdev+bounces-11259-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 121397324DC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 03:50:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 34F0A28158F
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 01:50:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 38F9B62C;
	Fri, 16 Jun 2023 01:50:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F22C9627;
	Fri, 16 Jun 2023 01:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA38DC433C8;
	Fri, 16 Jun 2023 01:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686880248;
	bh=nU+X+KVIDURgxGYvWyF+fi9rrL67M81WPlMLce7pVlM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=t27sAfqe4eAwmg9rAPO2acEOoG2G8Z+k4Se7kXknI55d+EzouXOfWBoRMjy1j2Aat
	 cAZzASQCAf7AzZuEKzz1kV52J051iaTI+hNuNcliOzrFGiZ/dWf4iBXmyzil47vVtd
	 4nUzseNGNYk92Y/lD42OzhQhzw/MTslmIjPvbL1Rni2cBsBIUqZNZsxaKzzwFug5lT
	 uBsKyxLe5s3+VnODSrzFARsXHIHCOYKKIp/fTiH02KJRfky7pP8lrqPcMP4zvwwb70
	 g9DWv2tadpgbcKCG4Jz/aJU6L0WkNfggnamtbw6rPO3GbF8FoEYFLDUog6qf31UdZq
	 CgeL+/nolTt0w==
Date: Thu, 15 Jun 2023 18:50:46 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Stanislav Fomichev <sdf@google.com>
Cc: Alexei Starovoitov <alexei.starovoitov@gmail.com>, Toke =?UTF-8?B?SMO4?=
 =?UTF-8?B?aWxhbmQtSsO4cmdlbnNlbg==?= <toke@kernel.org>, bpf
 <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, Martin KaFai
 Lau <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
 <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh
 <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Jiri Olsa
 <jolsa@kernel.org>, Willem de Bruijn <willemb@google.com>, David Ahern
 <dsahern@kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>,
 =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, "Fijalkowski, Maciej"
 <maciej.fijalkowski@intel.com>, Network Development
 <netdev@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
Message-ID: <20230615185046.3c9133ea@kernel.org>
In-Reply-To: <CAKH8qBuLG=k0dF+3X0fM-1vmJ318B-UCzYOpcCYseWW14_w2NA@mail.gmail.com>
References: <20230612172307.3923165-1-sdf@google.com>
	<87cz20xunt.fsf@toke.dk>
	<ZIiaHXr9M0LGQ0Ht@google.com>
	<877cs7xovi.fsf@toke.dk>
	<CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
	<87v8frw546.fsf@toke.dk>
	<CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
	<CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com>
	<CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
	<CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
	<877cs6l0ea.fsf@toke.dk>
	<CAADnVQJM6ttxLjj2FGCO1DKOwHdj9eqcz75dFpsfwJ_4b3iqDw@mail.gmail.com>
	<87pm5wgaws.fsf@toke.dk>
	<CAADnVQKvn-6xio0DyO8EDJktHKtWykfEQc3VosO7oji+Fk1oMA@mail.gmail.com>
	<CAKH8qBuLG=k0dF+3X0fM-1vmJ318B-UCzYOpcCYseWW14_w2NA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 15 Jun 2023 09:31:19 -0700 Stanislav Fomichev wrote:
> Timestamp might be a bit of an outlier here where it's just setting
> some bit in some existing descriptor.
> For some features, the drivers might have to reserve extra descriptors
> and I'm not sure how safe it would be to let the programs arbitrarily
> mess with the descriptor queues like that.

I was gonna say, most NICs will have some form of descriptor chaining,
with strict ordering, to perform reasonably with small packets.

> I'll probably keep this kfunc approach for v2 rfc for now (will try to
> get rid of the complicated attachment at least), but let's keep
> discussing.

SGTM, FWIW.

