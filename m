Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5996A2272
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 20:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjBXTlp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 14:41:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBXTlo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 14:41:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744146F02D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 11:41:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C13AB6191D
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 19:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA343C433EF;
        Fri, 24 Feb 2023 19:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677267686;
        bh=3VXWaBlf+nsaLvyR3SYbryjYm/GCVhKIuk84UVUkCBk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gpX61g1DlYIb8OOEaUmranXL1gfTK7I3VDg5aWuV4qp0UoaRR3m2sD3UBoME+0VZI
         P6sPYGqNItfDh/nOEb5xYVexzxXnEPDQML6bncv3KsHTPlPtGAg9M7aA28a/Rig/QN
         rEJ5dzGLeltKnsbNheUJN7CSeZj3zPhTFgOpe4QQejpU0r9tK8KaVDgpxvR8fNQxs2
         tbk70z4PC7DcIc3KjQuF/ZajUItd/JhaRkEUhVBzjpYekKC9v7KNrNVkzIqGjVlLo2
         qiWm4zAraR7yxH5+tCYKhll2i15u1dIRR8m4hAchKaNc1AGhltdjTfCRPlUFgIY1ob
         mZcFhdKl7xwMA==
Date:   Fri, 24 Feb 2023 11:41:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Yunsheng Lin <linyunsheng@huawei.com>
Subject: Re: [PATCH v2 net] net: fix __dev_kfree_skb_any() vs drop monitor
Message-ID: <20230224114124.66f65713@kernel.org>
In-Reply-To: <20230223083845.1555914-1-edumazet@google.com>
References: <20230223083845.1555914-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 08:38:45 +0000 Eric Dumazet wrote:
> dev_kfree_skb() is aliased to consume_skb().
> 
> When a driver is dropping a packet by calling dev_kfree_skb_any()
> we should propagate the drop reason instead of pretending
> the packet was consumed.
> 
> Note: Now we have enum skb_drop_reason we could remove
> enum skb_free_reason (for linux-6.4)
> 
> v2: added an unlikely(), suggested by Yunsheng Lin.

Applied, thanks!
