Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C29D59903D
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 00:11:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345980AbiHRWKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 18:10:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346119AbiHRWKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 18:10:41 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C612D25FF;
        Thu, 18 Aug 2022 15:10:39 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 5C0313200900;
        Thu, 18 Aug 2022 18:10:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 Aug 2022 18:10:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm3; t=1660860634; x=
        1660947034; bh=bqimtuRDECWOfamqyR5FSsot1AL5746ILjJxrzbyYOY=; b=Q
        tZNFrMEXwo0B/LI90hb4Vym5HO+fB2OVHlsZMXzn0/O8oJtRrNKyNi1ZZbg1WyVm
        araWUv9Qy7Yuw8OW+YqLca5pwRHzLmItXKyzwwzdFlJumA/bTfrjbaCgijKvWLIK
        5ifR+qZa27xAHiQFhKPH5KmEdR/0HUYQcT6nZkTDs3rTI3Y3vBmSBrzFhO+l7lLB
        QXqe0kE0l3mE8q0JgfqtIeU3ewC1tKcyurtI3Xc/Nvhhtkhqfayg5ge4DjUB48Wi
        qeEi1HlMXy7fzARInCGAyQwNRaNtcQCH4XS0D1KftDk9hQYMcUxZ+fJT+ntYAieA
        VULTmDq+MoU4THN2faB8Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1660860634; x=
        1660947034; bh=bqimtuRDECWOfamqyR5FSsot1AL5746ILjJxrzbyYOY=; b=1
        2+QZkWF9inCmGBBPYFj60fys2jhoL/3SnCrhktpZphBqWhTcqUj59eUGgOKxQgEJ
        HerW6z/V36bbAnZa5z3tLpafPSDPXPt1u4kzZQxxglUBHMaoiDSGfPHu7pH0b9MV
        VW/U2u5k3xrKeImFqhIxNMsMIg+6uwCTtMfUDzPv4IP2I3xFNySUCSOkgS/nYEqI
        ZBXX5OYBD53szxY781XN/i97bXvvy/vuO660DcARFLbpg7k0S89t82Kit+g5JM1m
        ePP+qx5OAR7zFScALBVoHDJIz48BeFzqBbBTAxdIA1rJeWOe4T/Rxvrm3KceNMfk
        Zvr8Kl79bfjJqEUH7TH0A==
X-ME-Sender: <xms:2rj-YqlSCFiFZGwtTi1iUFeeXfZJOIUeSTtdm42Zvln3Uz08FSrXxg>
    <xme:2rj-Yh0kkf_3W6Fdz4BdUpe9uPmhpfFnejHWvH47F3mTu2Za0DoM3qDmdDgK8dX32
    vUiP513TGoUYm1ZaA>
X-ME-Received: <xmr:2rj-YorGWp8ATbOrmOjxKA-Iy2MUS9uFkHsM0PKxoJ7w2Igxhe6hOxuhUbtYiM7kSnq5rRy7ccYzeOHzgqdTMBz815ulREZ8lNIC>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeitddgtdeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    gfrhhlucfvnfffucdljedtmdenucfjughrpeffhffvvefukfhfgggtugfgjgesthekredt
    tddtudenucfhrhhomhepffgrnhhivghlucgiuhcuoegugihusegugihuuhhurdighiiiqe
    enucggtffrrghtthgvrhhnpeegvdejveeuvdeigfejjeeufefhffetfeekuddtuddvuedt
    ueffvdejleehgeetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpegugihusegugihuuhhurdighiii
X-ME-Proxy: <xmx:2rj-YunwIWChXgRMS44dcdI6nJCXA2VmImGp9L8GBJBZIiCgARf7gg>
    <xmx:2rj-Yo2t9M2iHf492Xd8c4qtZ0pEWYskuKHCCenOEqRtJTe3emEXtg>
    <xmx:2rj-Ylsv_UmfO_P-N9XhMU-rbWUcG_bebhw7S3jIljAgUF5D8NqHAw>
    <xmx:2rj-YuwdKVOYeqcFjtpM5iF1aavXvOlD40cpMhzTCN1RXm1pqkiDSg>
Feedback-ID: i6a694271:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 18:10:33 -0400 (EDT)
Date:   Thu, 18 Aug 2022 16:10:32 -0600
From:   Daniel Xu <dxu@dxuuu.xyz>
To:     Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, memxor@gmail.com, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 3/4] bpf: Add support for writing to
 nf_conn:mark
Message-ID: <20220818221032.7b4lcpa7i4gchdvl@kashmir.localdomain>
References: <cover.1660761470.git.dxu@dxuuu.xyz>
 <edbca42217a73161903a50ba07ec63c5fa5fde00.1660761470.git.dxu@dxuuu.xyz>
 <87pmgxuy6v.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87pmgxuy6v.fsf@toke.dk>
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

Hi Toke,

On Thu, Aug 18, 2022 at 09:52:08PM +0200, Toke Høiland-Jørgensen wrote:
> Daniel Xu <dxu@dxuuu.xyz> writes:
> 
> > Support direct writes to nf_conn:mark from TC and XDP prog types. This
> > is useful when applications want to store per-connection metadata. This
> > is also particularly useful for applications that run both bpf and
> > iptables/nftables because the latter can trivially access this
> > metadata.
> 
> Looking closer at the nf_conn definition, the mark field (and possibly
> secmark) seems to be the only field that is likely to be feasible to
> support direct writes to, as everything else either requires special
> handling (like status and timeout), or they are composite field that
> will require helpers anyway to use correctly.
> 
> Which means we're in the process of creating an API where users have to
> call helpers to fill in all fields *except* this one field that happens
> to be directly writable. That seems like a really confusing and
> inconsistent API, so IMO it strengthens the case for just making a
> helper for this field as well, even though it adds a bit of overhead
> (and then solving the overhead issue in a more generic way such as by
> supporting clever inlining).
> 
> -Toke

I don't particularly have a strong opinion here. But to play devil's
advocate:

* It may be confusing now, but over time I expect to see more direct
  write support via BTF, especially b/c there is support for unstable
  helpers now. So perhaps in the future it will seem more sensible.

* The unstable helpers do not have external documentation. Nor should
  they in my opinion as their unstableness + stale docs may lead to
  undesirable outcomes. So users of the unstable API already have to
  splunk through kernel code and/or selftests to figure out how to wield
  the APIs. All this to say there may not be an argument for
  discoverability.

* Direct writes are slightly more ergnomic than using a helper.

Thanks,
Daniel
