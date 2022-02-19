Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B9A94BC560
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:41:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238676AbiBSElP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:41:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232527AbiBSElO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:41:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B189E1B4D;
        Fri, 18 Feb 2022 20:40:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BAB5B60A6A;
        Sat, 19 Feb 2022 04:40:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F339CC004E1;
        Sat, 19 Feb 2022 04:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645245656;
        bh=ubKYQvVvfod/mMLEp2FCmn7Zz1AOcwHdT56+fc+Dm8I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ffXmrsTGWE/BCxEpFdIM4VKEdzqemdf0kQU1cq7wD7unhBh6KQZmRvtq9gME60Q8P
         BMnWqKD0zL/YgacnX1cBwlTcsjHHTetud0ybDyfa5AgKLcmPvlfdGBnRfDZ5tP14hC
         Q49r/8mMjZ5FxUENTdHEThSKDSREGGIAHgyUyZ16yOMhcalOWMDPWsRwpVQ8aA64Vk
         sIs7vCGwXNbjfVwf3Ms7dnFzWG35TAacYIfkK1VJELV+XuAiU+qG7Ix8or6qSDuicx
         zNZQMeHZHEGP5h9EBaK9bigPB/bTuDvyc446ThbLVRdF/QrJpNbLSJf4SIZDw0NJ6v
         NHhslBp9lMxjg==
Date:   Fri, 18 Feb 2022 20:40:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     dsahern@kernel.org, edumazet@google.com, davem@davemloft.net,
        rostedt@goodmis.org, mingo@redhat.com, yoshfuji@linux-ipv6.org,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, imagedong@tencent.com,
        talalahmad@google.com, keescook@chromium.org,
        ilias.apalodimas@linaro.org, alobakin@pm.me, memxor@gmail.com,
        atenart@kernel.org, bigeasy@linutronix.de, pabeni@redhat.com,
        linyunsheng@huawei.com, arnd@arndb.de, yajun.deng@linux.dev,
        roopa@nvidia.com, willemb@google.com, vvs@virtuozzo.com,
        cong.wang@bytedance.com, luiz.von.dentz@intel.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org, flyingpeng@tencent.com
Subject: Re: [PATCH net-next v2 1/9] net: tcp: introduce tcp_drop_reason()
Message-ID: <20220218204054.7acc715b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218083133.18031-2-imagedong@tencent.com>
References: <20220218083133.18031-1-imagedong@tencent.com>
        <20220218083133.18031-2-imagedong@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 16:31:25 +0800 menglong8.dong@gmail.com wrote:
> +static inline void tcp_drop(struct sock *sk, struct sk_buff *skb)

The patches are marked as changes requested in patchwork.

I presume Dave also thinks this static inline is best avoided.

Is this function really not getting inlined? Otherwise please 
repost with the inline keyword removed.

> +{
> +	tcp_drop_reason(sk, skb, SKB_DROP_REASON_NOT_SPECIFIED);
>  }
