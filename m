Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DACD614E7A
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiKAPht (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiKAPhs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5A8019C0B;
        Tue,  1 Nov 2022 08:37:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66C8961645;
        Tue,  1 Nov 2022 15:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2A0C433D7;
        Tue,  1 Nov 2022 15:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667317065;
        bh=Cui/4MgtQLHs/m1tpB4yK9M7ZhzRBb+NXaKygznnO20=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qgIPVcK8jni91Yfk7NEpm7FMBzi8jCLykbsBDaETFl2UCThpMrKAQBzXN/67dlRO8
         WK8qWBXqmiPbT68X/uaKi3aegiqyAWqDAEozeoNjVkXem/Qj0X5IfUlzN3qI2vSd9L
         OjJqRCjhJGQTEFZo/z085XzAswfpQEtPbNlG5gdV4Zv/rWvTRhTPNzUpPjlAJiIhYj
         pY6uB67q7ixV1ND55DG58P2KNikArDUKleJ3g/3v99v3tO+PrQsi9AfXFgHID1nM4e
         IMDexVYKzXZPuFYU6Nzy2D3G0Bc1taz6U5Fb8O5wi7//59dY+IYGNP5vzA0DxSahlr
         b9T4pi0EGvAdQ==
Date:   Tue, 1 Nov 2022 08:37:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jani Nikula <jani.nikula@intel.com>,
        Cai Huoqing <cai.huoqing@linux.dev>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Zhengchao Shao <shaozhengchao@huawei.com>,
        SeongJae Park <sj@kernel.org>,
        Bin Chen <bin.chen@corigine.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] net: hinic: Add control command support
 for VF PMD driver in DPDK
Message-ID: <20221101083744.7b0e9e5a@kernel.org>
In-Reply-To: <87a65a97fw.fsf@intel.com>
References: <20221101060358.7837-1-cai.huoqing@linux.dev>
        <20221101060358.7837-2-cai.huoqing@linux.dev>
        <87iljz7y0n.fsf@intel.com>
        <20221101121734.GA6389@chq-T47>
        <87a65a97fw.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 01 Nov 2022 14:37:39 +0200 Jani Nikula wrote:
> On Tue, 01 Nov 2022, Cai Huoqing <cai.huoqing@linux.dev> wrote:
> > On 01 11=E6=9C=88 22 12:46:32, Jani Nikula wrote: =20
> >> Out of curiosity, what exactly compelled you to Cc me on this particul=
ar
> >> patch? I mean there aren't a whole lot of places in the kernel that
> >> would be more off-topic for me. :) =20
> > run ./scripts/get_maintainer.pl this patch in net-next
> > then get your email
> > Jani Nikula <jani.nikula@intel.com> (commit_signer:1/8=3D12%)
> > Maybe you have some commits in net subsystem ? =20
>=20
> A grand total of 3 commits in drivers/net/wireless/ath/ two years ago,
> adding 3 const keywords, nowhere near of what you're changing.
>=20
> get_maintainer.pl is utterly broken to suggest I should be Cc'd.

Apparently is because you acked commit 8581fd402a0c ("treewide: Add
missing includes masked by cgroup -> bpf dependency").
This random driver is obviously was not the part you were acking but
heuristics :/

Cai Huoqing FWIW we recommend adding --git-min-percent 25 when running
get_maintainers, otherwise there's all sorts of noise that gets in.
