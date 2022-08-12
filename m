Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE87F591618
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 21:47:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234923AbiHLTrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 15:47:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiHLTrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 15:47:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690E5B2DA6
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 12:47:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id AA5D5CE2669
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 19:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A278FC433C1;
        Fri, 12 Aug 2022 19:47:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660333653;
        bh=xWAktnGlAHmk5idujSQYkP2jTOFr/j9l9/l12hAqOpM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kcTLF6wBEp30R0UZWzKelJV2GEBUOpSgZzWNDX9fTrQpHt+Exdp7DibCZtuFqDsUJ
         wtdanMqPyRuDGSf8wZSROriVSL6NGxGHVwsWRBXiw/oBt0Y+4Gu6gKs4NhcYGUOrH0
         iTt6LTH9ImBEnoEJBS8rOuy8idlPqhcOe0CB78GyYwjtNPzcjN1WrHfo7sgygZSISp
         RvAP15axpC/7fgZh7uovGXADpSWwds+YMccwoZdQG4DokFfjVUCe5bQqn73jf9XuN/
         LsW8WXkHBvv/Ow7yHm7SJpqGZ0v4A8y571BSsLvCGwKeYPzaUjAlrs43DavvfBob/1
         dpcw3DMxaIlGw==
Date:   Fri, 12 Aug 2022 12:47:32 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc:     virtualization@lists.linux-foundation.org,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH vhost 0/2] virtio_net: fix for stuck when change ring
 size with dev down
Message-ID: <20220812124732.75023d98@kernel.org>
In-Reply-To: <1660267838.1945586-1-xuanzhuo@linux.alibaba.com>
References: <20220811080258.79398-1-xuanzhuo@linux.alibaba.com>
        <20220811041041-mutt-send-email-mst@kernel.org>
        <20220811103730.0f085866@kernel.org>
        <1660267838.1945586-1-xuanzhuo@linux.alibaba.com>
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

On Fri, 12 Aug 2022 09:30:38 +0800 Xuan Zhuo wrote:
> Yes, the commits fixed by this patch are currently in Michael's vhost branch.
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=linux-next
> 
> So I mean that by "vhost" here, not into the net/net-next branch. Or should I use
> a more accurate term next time?

The tagging seems good, perhaps add a note to the commit message next
time. Maybe a lore link to the series you are fixing up?
The virtio_net.c patches usually go via netdev AFAIU and we're lacking
the vhost context.
