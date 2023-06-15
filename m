Return-Path: <netdev+bounces-11111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B19E731904
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 14:36:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3FF9B1C20E49
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE30E6106;
	Thu, 15 Jun 2023 12:36:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40D271FDA;
	Thu, 15 Jun 2023 12:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C17C433C0;
	Thu, 15 Jun 2023 12:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686832582;
	bh=GkT9ZzUS0jxyoPU9+PHr+3Ug0LWT0zu1rrz4M6oSY8A=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Q+kGfUAeKphnJdA63xi3HZo4FErUcmtmycIDnm0g8JvmsvBoRk24vZC1yUFdQnc1Y
	 ThlmJUs13K720bqY1SU57awY10l/TPjgDSx5rPLa5qmdMvgU1QfcI3HXOn3fsxWwmw
	 9xDIsylg36S5YNam25bdgzWzjd+rGOJawASLYpz/wDsSk+EJk3MiF+TRL4/g4jDsc/
	 NxdppriMG99TMKNvr4GPim+2uVXXjUXHTFsXkgs4Zya/3MSNbTpuaxzif+1TpZ5InH
	 AkTx8OMxLvtOXTYhCwsEBD8j/GooVVXZmlkKRSmZqE8Wrg4GGSnyHauqPT0OKDUOPf
	 zzzPPmAFQVFcA==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
	id 92CDEBBEC2F; Thu, 15 Jun 2023 14:36:19 +0200 (CEST)
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Stanislav Fomichev <sdf@google.com>, bpf <bpf@vger.kernel.org>, Alexei
 Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Song Liu <song@kernel.org>, Yonghong Song
 <yhs@fb.com>, John Fastabend <john.fastabend@gmail.com>, KP Singh
 <kpsingh@kernel.org>, Hao Luo <haoluo@google.com>, Jiri Olsa
 <jolsa@kernel.org>, Willem de Bruijn <willemb@google.com>, David Ahern
 <dsahern@kernel.org>, "Karlsson, Magnus" <magnus.karlsson@intel.com>,
 =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>, "Fijalkowski, Maciej"
 <maciej.fijalkowski@intel.com>, Network Development
 <netdev@vger.kernel.org>
Subject: Re: [RFC bpf-next 0/7] bpf: netdev TX metadata
In-Reply-To: <CAADnVQJM6ttxLjj2FGCO1DKOwHdj9eqcz75dFpsfwJ_4b3iqDw@mail.gmail.com>
References: <20230612172307.3923165-1-sdf@google.com>
 <87cz20xunt.fsf@toke.dk> <ZIiaHXr9M0LGQ0Ht@google.com>
 <877cs7xovi.fsf@toke.dk>
 <CAKH8qBt5tQ69Zs9kYGc7j-_3Yx9D6+pmS4KCN5G0s9UkX545Mg@mail.gmail.com>
 <87v8frw546.fsf@toke.dk>
 <CAKH8qBtsvsWvO3Avsqb2PbvZgh5GDMxe2fok-jS4DrJM=x2Row@mail.gmail.com>
 <CAADnVQKFmXAQDYVZxjvH8qbxk+3M2COGbfmtd=w8Nxvf9=DaeA@mail.gmail.com>
 <CAKH8qBvAMKtfrZ1jdwVS2pF161UdeXPSpY4HSzKYGTYNTupmTg@mail.gmail.com>
 <CAADnVQ+CCOw9_LbCAaFz0593eydKNb7RxnGr6_FatUOKmvPmBg@mail.gmail.com>
 <877cs6l0ea.fsf@toke.dk>
 <CAADnVQJM6ttxLjj2FGCO1DKOwHdj9eqcz75dFpsfwJ_4b3iqDw@mail.gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date: Thu, 15 Jun 2023 14:36:19 +0200
Message-ID: <87pm5wgaws.fsf@toke.dk>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:

> On Wed, Jun 14, 2023 at 5:00=E2=80=AFAM Toke H=C3=B8iland-J=C3=B8rgensen =
<toke@kernel.org> wrote:
>>
>> >>
>> >> It's probably going to work if each driver has a separate set of tx
>> >> fentry points, something like:
>> >>   {veth,mlx5,etc}_devtx_submit()
>> >>   {veth,mlx5,etc}_devtx_complete()
>>
>> I really don't get the opposition to exposing proper APIs; as a
>> dataplane developer I want to attach a program to an interface. The
>> kernel's role is to provide a consistent interface for this, not to
>> require users to become driver developers just to get at the required
>> details.
>
> Consistent interface can appear only when there is a consistency
> across nic manufacturers.
> I'm suggesting to experiment in the most unstable way and
> if/when the consistency is discovered then generalize.

That would be fine for new experimental HW features, but we're talking
about timestamps here: a feature that is already supported by multiple
drivers and for which the stack has a working abstraction. There's no
reason why we can't have that for the XDP path as well.

-Toke

