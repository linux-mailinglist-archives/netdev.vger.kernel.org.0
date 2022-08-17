Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 567095975BA
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbiHQS3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:29:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHQS3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:29:21 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 009D6923E8;
        Wed, 17 Aug 2022 11:29:19 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A77E15C01B4;
        Wed, 17 Aug 2022 14:29:17 -0400 (EDT)
Received: from imap42 ([10.202.2.92])
  by compute2.internal (MEProxy); Wed, 17 Aug 2022 14:29:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1660760957; x=
        1660847357; bh=6TH2AFqIEcaUghdEzI5ZBqijygz5Q7u/rKXyapeK99M=; b=a
        YV896cCdzjcUBfMu7MUS/qvr1yVCvHMBuOVfCmZxWiB4MTpvBjpg1Bh/mD95DC3h
        kEzGSIbQLMDBFfS2QlGVvA4diPNzICej7fVa5Bvr1tHcItYtnDgRyOHpMgF6sDve
        SoPYUlihc2cBTp8nQ7/e/VWaCmtWdGcRz5KPwiaek3RP8TJXyVS15EgSGg9RWjmP
        1IOgbnv02XScPj/I1Snav5/LTHTnWRGti3hGX2EXSmFlOktFDYJSJyVuba3Iuw0h
        tje0vpyjq/PgdkV4cYmU5KJVyTIppuPXLmVG779l8FUOSWWHSTckJJ7FRFHQdIag
        YDhduOlpwuxCRdr0Cw6cA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1660760957; x=
        1660847357; bh=6TH2AFqIEcaUghdEzI5ZBqijygz5Q7u/rKXyapeK99M=; b=Q
        mdfvAEk/fQyCxlHxN4wxEpn89SykmJnip3HwCdXzo3KkL3SCt+kIPjZW8gLMw1by
        el9FogGfFl9iUmfHjJZooK5K2sAwgbOgtFv7yHDTvNps8XKfPsCqCYLi2SecDJzo
        5GgJpVHtgZ2VaJWchxzCrDZt1WXzJ4L54retbD8fxetYzScDvwf9bHJBICaAsSZx
        OiWYDtLpuTl7J4VxHtf7C7yxhQVnvm4HccntxbE+VOtZHz0mqwHZBW2mQbuEhiut
        AWUsNW82qVjxiC/fh+AUQfX2ohWThnqPllJcozO4ioQQV8L9PJFN/y3HrYxvLliL
        gSC63Y/te//MyfECJl+LA==
X-ME-Sender: <xms:fTP9YiAAfZnfgUcXGYWv6MiG_YtW9Z_o4rawl6C0QPk3CrKC3g5mYA>
    <xme:fTP9Ysjpy81fu_WRJ7-l5hWEGsf59RNnd1s5VsaCbZJTUkle9HZY-cMdMUZ3w8kpW
    FzwTSSJIhirHwvGxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddvfedmnecujfgurhepofgfggfkjghffffhvfevufgtgfesthhq
    redtreerjeenucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihusegugihuuhhurd
    ighiiiqeenucggtffrrghtthgvrhhnpeevheduteefvddthfdvgfehjeejtdfhieeigffg
    gfduvdfftdevleejleelfeeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:fTP9YlmSnL9XUPlDsOC4TpprHhYvT0SrIjXtMV0gnelubsQZ6D3ccQ>
    <xmx:fTP9YgyyFZ5Lcl0Dr78ROHBQbYjzZH5cF-8QAiXYxBM4ZTI1VxP8ZQ>
    <xmx:fTP9YnRbh5RpWNPbAq_ZUdOBxgyzqduFMGd-mOFZF-qpyUlJpC7WBA>
    <xmx:fTP9YiHD6MfPweqnA_jTiwCm35qO9qUMNsrCJTvTvmtRabnlES_iwg>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 07998BC0078; Wed, 17 Aug 2022 14:29:17 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-841-g7899e99a45-fm-20220811.002-g7899e99a
Mime-Version: 1.0
Message-Id: <5c7ac2ab-942f-4ee7-8a9c-39948a40681c@www.fastmail.com>
In-Reply-To: <20220815224011.GA9821@breakpoint.cc>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
 <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
 <871qth87r1.fsf@toke.dk> <20220815224011.GA9821@breakpoint.cc>
Date:   Wed, 17 Aug 2022 12:28:55 -0600
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Florian Westphal" <fw@strlen.de>,
        =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Cc:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "Alexei Starovoitov" <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andrii@kernel.org>,
        "Kumar Kartikeya Dwivedi" <memxor@gmail.com>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next 2/3] bpf: Add support for writing to nf_conn:mark
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Mon, Aug 15, 2022, at 4:40 PM, Florian Westphal wrote:
> Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> > Support direct writes to nf_conn:mark from TC and XDP prog types. T=
his
>> > is useful when applications want to store per-connection metadata. =
This
>> > is also particularly useful for applications that run both bpf and
>> > iptables/nftables because the latter can trivially access this meta=
data.
>> >
>> > One example use case would be if a bpf prog is responsible for adva=
nced
>> > packet classification and iptables/nftables is later used for routi=
ng
>> > due to pre-existing/legacy code.
>> >
>> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>>=20
>> Didn't we agree the last time around that all field access should be
>> using helper kfuncs instead of allowing direct writes to struct nf_co=
nn?
>
> I don't see why ct->mark needs special handling.
>
> It might be possible we need to change accesses on nf/tc side to use
> READ/WRITE_ONCE though.

I reviewed some of the LKMM literature and I would concur that
READ/WRITE_ONCE() is necessary. Especially after this patchset.

However, it's unclear to me if this is a latent issue. IOW: is reading
ct->mark protected by a lock? I only briefly looked but it doesn't
seem like it.

I'll do some more digging.

In the meantime, I'll send out a v2 on this patchset and I'll plan on
sending out a followup patchset for adding READ/WRITE_ONCE()
to ct->mark accesses.

Thanks,
Daniel
