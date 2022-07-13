Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE9D8572BF2
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 05:33:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231672AbiGMDd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 23:33:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiGMDd0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 23:33:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F460D8607;
        Tue, 12 Jul 2022 20:33:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05ECBB81CD1;
        Wed, 13 Jul 2022 03:33:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B9EC3411E;
        Wed, 13 Jul 2022 03:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657683201;
        bh=aOVSuVL7JDIlIwE3oEDnonyPf5DF5MKPPsQEw9pumDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hwNXzEBpaPV02SVg35WWGJ47c04ATIixHzwcXXnsg7Dp5KgOuUFu1Q4hq8ECtB6ro
         wJXe6I6IwvwZVIE5wQqRLzKvYfPtzsi3Re06TqEfCTaSrrzekY+SoMjwZtnZjV3ICk
         NQhDz/h4VG3XKqiQWY3mYP8cJzGxSFPI2d8e1e1/cI65Bgj1Mdl04GqqRlE9asTGnp
         rF5JKEPhePpO8YYWhmkFEQr2yXRYgLF5OWRtFWLvxftlPkhlOgbCse1fe8Jnj3ZGb3
         r5Nv85J8hVxlDMtTVWsNH3fDNvLYwy3yxDa4LILGre/IoZfYN9IZbvMSJaXHSB384o
         Ow38RaI8xyWJg==
Date:   Tue, 12 Jul 2022 20:33:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hawkins Jiawei <yin31149@gmail.com>
Cc:     guwen@linux.alibaba.com, 18801353760@163.com, andrii@kernel.org,
        ast@kernel.org, borisp@nvidia.com, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, dsahern@kernel.org,
        edumazet@google.com, john.fastabend@gmail.com, kafai@fb.com,
        kgraul@linux.ibm.com, kpsingh@kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, paskripkin@gmail.com, skhan@linuxfoundation.org,
        songliubraving@fb.com,
        syzbot+5f26f85569bd179c18ce@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com,
        yoshfuji@linux-ipv6.org, chuck.lever@oracle.com
Subject: Re: [PATCH] smc: fix refcount bug in sk_psock_get (2)
Message-ID: <20220712203311.05541472@kernel.org>
In-Reply-To: <20220713031005.58220-1-yin31149@gmail.com>
References: <0408b739-3506-608a-4284-1086443a154d@linux.alibaba.com>
        <20220713031005.58220-1-yin31149@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Jul 2022 11:10:05 +0800 Hawkins Jiawei wrote:
> In Patchwork website, this patch fails the checks on
> netdev/cc_maintainers. If this patch fails for some other reasons,
> I will still fix this bug from SK_USER_DATA_PTRMASK,
> as a temporary solution.

That check just runs scripts/get_maintainer.pl so make sure you CC
folks pointed out by that script and you should be fine.
