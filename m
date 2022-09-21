Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDC4F5BF242
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:39:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231179AbiIUAjF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230388AbiIUAjE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:39:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF0EBBAF;
        Tue, 20 Sep 2022 17:39:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 55FCBB81178;
        Wed, 21 Sep 2022 00:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FAD1C433D7;
        Wed, 21 Sep 2022 00:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663720741;
        bh=ES4lHOfi36UTOt/Tzs3dS9IkBYhPXBuVpySG7uoJLyM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JcR1t0aPrNk/5OXhoyZew1qhTELtVUfQzsDPvSjmVMHqlivyvY409ghnkIROD0NdD
         QHmp8WR9QgNIq3XyPTvi42L6sTEW/2JGfKKa7uAAKace0hkuUHXpk/BDrirq/76FXA
         BFK4PPtBIt0VmdGviF/g8k/EGPZx9+At7ttrgVZWTFQzlBylAM0LSOJUh/+4790G0V
         UNCNt0TRgg98NeIPDzj7BkJ8UyxcbaX4yWgIiZ+Bc0NINa2BHdz3Zo0W7n1VZxLZZN
         QEeb2h5r9JbQvF0ycchFnpK+WjlsTgaacXYKB4ialZ7HL/xlPzrZ6sQfXP4zKdgYDH
         oo+U+ODBhhJJg==
Date:   Tue, 20 Sep 2022 17:38:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Peilin Ye <yepeilin.cs@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Peilin Ye <peilin.ye@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Kuniyuki Iwashima <kuniyu@amazon.com>,
        Alexei Starovoitov <ast@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/2] udp: Refactor udp_read_skb()
Message-ID: <20220920173859.6137f9e9@kernel.org>
In-Reply-To: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
References: <03db9765fe1ef0f61bfc87fc68b5a95b4126aa4e.1663143016.git.peilin.ye@bytedance.com>
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

On Wed, 14 Sep 2022 01:15:30 -0700 Peilin Ye wrote:
> Delete the unnecessary while loop in udp_read_skb() for readability.
> Additionally, since recv_actor() cannot return a value greater than
> skb->len (see sk_psock_verdict_recv()), remove the redundant check.

These don't apply cleanly, please rebase?
