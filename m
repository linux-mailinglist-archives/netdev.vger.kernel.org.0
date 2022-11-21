Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2BC4632E19
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 21:42:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiKUUlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 15:41:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229812AbiKUUli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 15:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7138326F1;
        Mon, 21 Nov 2022 12:41:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 626A36146B;
        Mon, 21 Nov 2022 20:41:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C0EDC433D6;
        Mon, 21 Nov 2022 20:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669063296;
        bh=DlOu/VHZFAZtVqvX+pi8ZYRpJOIH+dRsBr6N6flygRQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uqSD+37yAk3/8hUCc4Zg0Yp4eWXfMOBaY76iNcqe+O4VI3EBtGeFhARbTYegnHdta
         nwIWGQyDxshv2SADRfxYgEoh1oYy3dA85giCeMgoW9oXy/Ai/L7o3o1vmZnUUxw+sY
         jPwjhmHI6hs+R+ifC0ay3s0EI+QLGqc8rlCyKQVS+8F0DvLv1th3FCqpaX3FQn1sQy
         esujjXVi3QLL7eky60FWpELs0PHRQdMcHid0pS7ZQ32lCIkKCi2/KpC9I9ARhFDhp4
         xkVS16QmtCZKIhu3gKvZ6Q3YIDR92J84vGOXjv30CvF9PnBlKRKHS1uyO4VFZkdKf1
         ToOD7gUqkjlQg==
Date:   Mon, 21 Nov 2022 12:41:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Safonov <dima@arista.com>
Cc:     linux-kernel@vger.kernel.org, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bob Gilligan <gilligan@arista.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jason Baron <jbaron@akamai.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Salam Noureddine <noureddine@arista.com>,
        Steven Rostedt <rostedt@goodmis.org>, netdev@vger.kernel.org
Subject: Re: [PATCH v4 3/5] net/tcp: Disable TCP-MD5 static key on
 tcp_md5sig_info destruction
Message-ID: <20221121124135.4015cc66@kernel.org>
In-Reply-To: <31efe48a-4c68-f17c-64ee-88d45f56c438@arista.com>
References: <20221115211905.1685426-1-dima@arista.com>
        <20221115211905.1685426-4-dima@arista.com>
        <20221118191809.0174f4da@kernel.org>
        <31efe48a-4c68-f17c-64ee-88d45f56c438@arista.com>
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

On Mon, 21 Nov 2022 20:31:38 +0000 Dmitry Safonov wrote:
> > Maybe it wouldn't be 
> > the worst move to provide a sk_rcu_dereference() or rcu_dereference_sk()
> > or some such wrapper.
> > 
> > More importantly tho - was the merging part for this patches discussed?
> > They don't apply to net-next.  
> 
> They apply over linux-next as there's a change [1] in
> linux-tip/locking/core on which the patches set based.
> 
> Could the way forward be through linux-tip tree, or that might create
> net conflicts?

Dunno from memory, too much happens in these files :S

Could you cherry-pick [1] onto net-next and see if 

  git am --no-3way patches/*

goes thru cleanly? If so no objections for the patches to go via tip,
we're close enough to the merge window.

> I'll send v5 with the trivial change to rcu_dereference_protected()
> mentioned above.
