Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B51B594EA8
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 04:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiHPC05 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Aug 2022 22:26:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239614AbiHPC0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Aug 2022 22:26:39 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EE4B77E8E;
        Mon, 15 Aug 2022 15:41:29 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7EC775C0059;
        Mon, 15 Aug 2022 18:41:26 -0400 (EDT)
Received: from imap42 ([10.202.2.92])
  by compute2.internal (MEProxy); Mon, 15 Aug 2022 18:41:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1660603286; x=
        1660689686; bh=Fx+3U6i5N7hG3oTIANTunyRAkIo4mSSiHjyXtVm84Ww=; b=r
        O2ByjhOaliy15VKrYUAOb59tMk4tfsG0KMeBH36pG6nfgU79EjRKNu7wRoqlA+/N
        X04gBu90q4oUvkCG4eidfga//uCn8speHWZIAsVArvovtCwK2kXAE5C16ZMS8HTf
        Sb39nr31dTzCPuEDGCQZroD07Kg93tuKfYYf27lJeWa9oJasnfB4OsK5HFEwl4K+
        zsgFnAWQqhpS9XNJNP4m633z89Wp7E5w9ozxGsmiET/uvjkoTVlMN0xifWV33ynf
        t4MExHocuLv46PStulWP1A17B2qlY+HlGV1ydRgGUsVypPlEpxalIjsmr4dnzGf0
        6TPenU6XSrqXLEcOEgntA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1660603286; x=
        1660689686; bh=Fx+3U6i5N7hG3oTIANTunyRAkIo4mSSiHjyXtVm84Ww=; b=U
        KkFif4XKD3lSqv0ZUyQ+rWQ/rSp1PMZmfYXZuw4Jp73eerNuaDoassLYoSJkwsO8
        fF/DBo+qakO1yxVDK9cP4bNfOJF0mLT9ZqvbVOqSX1/pnSJo1fMGXuWCCR9vLYjo
        ZSDPzywO1mPabsHdAfuqD7Fr8CLpx8xf+nao7qZQ/zvvbF5vfx0jtB6t2d/OE+fp
        1KvRFP1I6UUurxZm2pACjTauXX112cyrf0crqc5W9sI1jgXPIpaGq6icIdoJBs5t
        tpLO/AO/vU4eZH9BN3slRJ+vNzZsz/OyANrfDWv5lzfCO0x/l6QaPx1DJCee28oa
        rk85WYKRYskLulihCCu7A==
X-ME-Sender: <xms:lcv6YjLIt81ZfhAUN5B5urN-A9jRDObRZ0WtgCnW8d1Gq-XSADJ7IA>
    <xme:lcv6YnJFK-fYHyLtRRVZ_dafBemOPicpvstbWVB0BdqY6c5pTh5BQTYzFeqTqR0B0
    8Tqr7hy5IbTUUXVzA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehfedgudegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdlvdefmdenucfjughrpefofgggkfgjfhffhffvvefutgfgsehtqher
    tderreejnecuhfhrohhmpedfffgrnhhivghlucgiuhdfuceougiguhesugiguhhuuhdrgi
    ihiieqnecuggftrfgrthhtvghrnhepfeetudetgeeikeejgefgffdvhefgveehiedtuedu
    jedugedtledvtdduiedtkeffnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihu
    uhhurdighiii
X-ME-Proxy: <xmx:lcv6YrtVSSZIt25u71WwPhqPIqQ1rEI3GL5De2icpYlrpRJn7mlJcw>
    <xmx:lcv6YsbuhqfTJZpsClcn3Js731PRqkVbTDvKX48zPmmFg4HUphAFOA>
    <xmx:lcv6YqZSxZ1_vdn6BPZUFy9O74yZ-U3zQrTL25k77kBeERwK7fau7g>
    <xmx:lsv6YgMjtXuf-VVzUAsdPNkHIdEIMTamEUhKMcMaxCNGWsX0-MhsWw>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id B1424BC0075; Mon, 15 Aug 2022 18:41:25 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-841-g7899e99a45-fm-20220811.002-g7899e99a
Mime-Version: 1.0
Message-Id: <7556b140-7d73-4411-86c5-f827cfb9f2ae@www.fastmail.com>
In-Reply-To: <871qth87r1.fsf@toke.dk>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
 <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
 <871qth87r1.fsf@toke.dk>
Date:   Mon, 15 Aug 2022 16:41:11 -0600
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
Cc:     pablo@netfilter.org, fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Toke,

On Mon, Aug 15, 2022, at 4:25 PM, Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Daniel Xu <dxu@dxuuu.xyz> writes:
>
>> Support direct writes to nf_conn:mark from TC and XDP prog types. This
>> is useful when applications want to store per-connection metadata. Th=
is
>> is also particularly useful for applications that run both bpf and
>> iptables/nftables because the latter can trivially access this metada=
ta.
>>
>> One example use case would be if a bpf prog is responsible for advanc=
ed
>> packet classification and iptables/nftables is later used for routing
>> due to pre-existing/legacy code.
>>
>> Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>
> Didn't we agree the last time around that all field access should be
> using helper kfuncs instead of allowing direct writes to struct nf_con=
n?

Sorry, I was not aware of those discussions. Do you have a link handy?

I received the suggestion to enable direct writes here:
https://lore.kernel.org/bpf/CAP01T74aWUW-iyPCV_VfASO6YqfAZmnkYQMN2B4L8ng=
MMgnAcw@mail.gmail.com/ .

Thanks,
Daniel
