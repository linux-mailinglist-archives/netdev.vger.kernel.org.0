Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA2D5975DF
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 20:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232561AbiHQSlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 14:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237435AbiHQSle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 14:41:34 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 875249FAB8;
        Wed, 17 Aug 2022 11:41:33 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E96C55C0055;
        Wed, 17 Aug 2022 14:41:32 -0400 (EDT)
Received: from imap42 ([10.202.2.92])
  by compute2.internal (MEProxy); Wed, 17 Aug 2022 14:41:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1660761692; x=
        1660848092; bh=KBkAVrFUWUiLnYz1HgB/kktwNXCcCNFrJP92tOCbhDk=; b=i
        kSCWfDhzh9hREGc9NnjtCI/XLmrpunPU3M5N8WxiUoMsnKo0cUDYKCcUIFKOTgtF
        +6TFAc1M/ixDcswGt0aKJ9BSLoT1dKD4+ow6CxfhKhJ7nlC4o3I3PY/QYRMhy3+j
        Lt03MeQ52D9lQpUfNbSjAeHh9+UbPXZxySSP2kFJM7ynMzbKUiE9qnrPcDB2vvTX
        +BbhwhbMRuBoFiWU0npqrL0DCJVpGyTJ4956cIX8AxJ7IEkMResR4POpQ4Y1Zgt0
        0gTLlz3Cf8ezcyPX7FUQ6ixRwFgGgkXeGwcEbQbxlBDuosZe0NX8CeRV4RIST2Z1
        lFmBvg+71tN/LxHUMLuEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1660761692; x=
        1660848092; bh=KBkAVrFUWUiLnYz1HgB/kktwNXCcCNFrJP92tOCbhDk=; b=U
        Dy6EGmSK7gzMimqN2Np815myw8KzJqgcF72m++jcMXieKMudfuKtm4o4pIthssx1
        jJzVD6Yc2FOrUaOe3zW/5cHKGqJLSLAMd4UksqbU6tjF2/11FDlL2GmqL6NQICYf
        HQf7kdvQg5h01FPOw57CsTicUHiA8E+egEGCtA5cPqo9BatnyuL+zsOGziXAn2EZ
        b/9N6bW7bXJM+l1vM5vMh7EFOtWs5vTu5GY5lz1P8DXI+2qNAcrf6OO9WmIE0bJy
        RpcdZa6wUlwvTUl4HPNHLI3Ys6WGTnySymfYcKBaVG4I2dIomm4iQDFBO5DLRIEK
        7eSzQdx0Xr0P+90lPHfdQ==
X-ME-Sender: <xms:XDb9YnFIagB7A2cBaaQ9vILES5qUY8hgnO2VQhhYng81is1f3NxtKQ>
    <xme:XDb9YkV6eLgxdJ0xqtrcFHxCIAGsWTc-K38ygMoLkemAoHyfBQQvIpjATGxsIH_zJ
    SpE9gyB3yfAaj03rA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehiedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enfghrlhcuvffnffculddvfedmnecujfgurhepofgfggfkjghffffhvfevufgtgfesthhq
    redtreerjeenucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihusegugihuuhhurd
    ighiiiqeenucggtffrrghtthgvrhhnpeffheffhfdvfefgjeehfedviedvfeehgeefgeeu
    jedvheeuteelkeevvdduvdeludenucffohhmrghinheplhhotghkrdhrvggrugenucevlh
    hushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegugihusegugihu
    uhhurdighiii
X-ME-Proxy: <xmx:XDb9YpJlIk5i-V5nCszbe21XnXqF-pO9TMHo9Nw8cXdqfBlWoNl2nw>
    <xmx:XDb9YlHXYa8YJJP43LNqim97aNApWqDSToNK0K1TjcFnMEeeSfZUNQ>
    <xmx:XDb9YtU3C4346XXEp4OB1tOcRRXLxP952bpCHiZ0SSkOisQqX4-72Q>
    <xmx:XDb9YprWXRms0hWDnATlbCgWhPHNu29K7_MI2QvQkq_MkujLAU0zdQ>
Feedback-ID: i6a694271:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 90270BC0075; Wed, 17 Aug 2022 14:41:32 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.7.0-alpha0-841-g7899e99a45-fm-20220811.002-g7899e99a
Mime-Version: 1.0
Message-Id: <668406b9-714f-4ade-889d-051cf42ceefc@www.fastmail.com>
In-Reply-To: <20220817183453.GA24008@breakpoint.cc>
References: <cover.1660592020.git.dxu@dxuuu.xyz>
 <f850bb7e20950736d9175c61d7e0691098e06182.1660592020.git.dxu@dxuuu.xyz>
 <871qth87r1.fsf@toke.dk> <20220815224011.GA9821@breakpoint.cc>
 <5c7ac2ab-942f-4ee7-8a9c-39948a40681c@www.fastmail.com>
 <20220817183453.GA24008@breakpoint.cc>
Date:   Wed, 17 Aug 2022 12:41:12 -0600
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "Florian Westphal" <fw@strlen.de>
Cc:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
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

On Wed, Aug 17, 2022, at 12:34 PM, Florian Westphal wrote:
> Daniel Xu <dxu@dxuuu.xyz> wrote:
>> On Mon, Aug 15, 2022, at 4:40 PM, Florian Westphal wrote:
>> > Toke H=C3=B8iland-J=C3=B8rgensen <toke@kernel.org> wrote:
>> >> > Support direct writes to nf_conn:mark from TC and XDP prog types=
. This
>> >> > is useful when applications want to store per-connection metadat=
a. This
>> >> > is also particularly useful for applications that run both bpf a=
nd
>> >> > iptables/nftables because the latter can trivially access this m=
etadata.
>> >> >
>> >> > One example use case would be if a bpf prog is responsible for a=
dvanced
>> >> > packet classification and iptables/nftables is later used for ro=
uting
>> >> > due to pre-existing/legacy code.
>> >> >
>> >> > Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
>> >>=20
>> >> Didn't we agree the last time around that all field access should =
be
>> >> using helper kfuncs instead of allowing direct writes to struct nf=
_conn?
>> >
>> > I don't see why ct->mark needs special handling.
>> >
>> > It might be possible we need to change accesses on nf/tc side to use
>> > READ/WRITE_ONCE though.
>>=20
>> I reviewed some of the LKMM literature and I would concur that
>> READ/WRITE_ONCE() is necessary. Especially after this patchset.
>>=20
>> However, it's unclear to me if this is a latent issue. IOW: is reading
>> ct->mark protected by a lock? I only briefly looked but it doesn't
>> seem like it.
>
> No, its not protected by a lock.  READ/WRITE_ONCE is unrelated to your
> patchset, this is a pre-existing "bug".

Thanks for confirming. Since it's pre-existing I will send out a followup
patchset then.

Thanks,
Daniel
