Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24E50E7BF
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 20:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244207AbiDYSGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 14:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237543AbiDYSGH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 14:06:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9994E47041;
        Mon, 25 Apr 2022 11:03:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5D76AB819F6;
        Mon, 25 Apr 2022 18:03:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D918C385AC;
        Mon, 25 Apr 2022 18:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650909781;
        bh=fhApvrUwqfudytb9kB8j3zbObVW/QPY0KQK6DC7Xzio=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rtencyc8zLIjJ36X9M2RrUvDnozE91nLa07X57bkB60jrP/WMCLsJHCauGqP1g7vy
         h1dGnRCQjlMchbr7ZJzFBv71m79Jj47ts+jIsKBHNMJRjicHVvxyLuM6+a5TIlS5wT
         I7wD2LIXa8OgpXDkWFbs0N9DksuQ+J+DCP5RApycFi2xpzxi689myOrhxLWvBk4vOf
         zm2+OqDaZaLWkfVptku2uVVVmEN3YL5/qzhP1+YZsr7awGJnZDxm1B5K+64SPz/PuS
         /iEK/E1yxga99jjsZuGQTMyIe8XdcYnOPWw5mGzXkdGjbxHaMGSgqErqsJ4+xDxq7M
         Bvh9e0e06LJCQ==
Date:   Mon, 25 Apr 2022 11:02:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Eric Dumazet <eric.dumazet@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/2] Make [IP6]GRE[TAP] devices always
 NETIF_F_LLTX
Message-ID: <20220425110259.389ed44b@kernel.org>
In-Reply-To: <cover.1650580763.git.peilin.ye@bytedance.com>
References: <cover.1650580763.git.peilin.ye@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Apr 2022 15:43:42 -0700 Peilin Ye wrote:
> This patchset depends on these fixes [1].  Since o_seqno is now atomic_t,
> we can always turn on NETIF_F_LLTX for [IP6]GRE[TAP] devices, since we no
> longer need the TX lock (&txq->_xmit_lock).

LGTM, thanks, but please repost on Thu / Fri. The fixes make their way
into net-next on Thu so until then we can't apply.

> We could probably do the same thing to [IP6]ERSPAN devices as well, but
> I'm not familiar with them yet.  For example, ERSPAN devices are
> initialized as |= GRE_FEATURES in erspan_tunnel_init(), but I don't see
> IP6ERSPAN devices being initialized as |= GRE6_FEATURES.  Please suggest
> if I'm missing something, thanks!

Probably good to CC William when you repost.
