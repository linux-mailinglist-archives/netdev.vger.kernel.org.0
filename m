Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391226B5733
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 02:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjCKBAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 20:00:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbjCKBAq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 20:00:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6F1127135;
        Fri, 10 Mar 2023 17:00:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79AAAB8246F;
        Sat, 11 Mar 2023 01:00:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DDE8C433EF;
        Sat, 11 Mar 2023 01:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678496442;
        bh=23FUW9NwvA7PihXPj1s/kb+tMA+fP4vkf5bAWtJBV6o=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nl917fFocImUb30MM51jZn0HMuQ0Gsmr+dzoZ+GgH668/FGNAzV7zKqBBudu0Ux1V
         QOBrckpvstG9/30O0lM0JZj9+dmtT7Y8uai7QnwUp0o3yyaGhsdKEkxw6ilBf1mwT+
         296wQporPyHwipICRxl66tc3TjPEzKsbyaDeVKVzAGAOCSgDq4nkEEJWAF/e59KTp8
         hNIfsuQ4j4LKSaGdCYm5m4Y716QOeVTS+1paSpmOi22+oKn1+fDKDNvmusx1tYT8+3
         ZTHgkUd/N56L7AVjxbktascW+RTtnhnwXE2Cvsu9Ng7MsbOsJbdGF50pQpc1aKCO7v
         4NKs63Mankj/Q==
Date:   Fri, 10 Mar 2023 17:00:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlastimil Babka <vbabka@suse.cz>
Cc:     Christoph Lameter <cl@linux.com>,
        David Rientjes <rientjes@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>,
        Hyeonggon Yoo <42.hyeyoo@gmail.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        rcu@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mike Rapoport <rppt@kernel.org>,
        Neeraj Upadhyay <quic_neeraju@quicinc.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/7] remove SLOB and allow kfree() with
 kmem_cache_alloc()
Message-ID: <20230310170040.3ee6bf36@kernel.org>
In-Reply-To: <20230310103210.22372-1-vbabka@suse.cz>
References: <20230310103210.22372-1-vbabka@suse.cz>
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

On Fri, 10 Mar 2023 11:32:02 +0100 Vlastimil Babka wrote:
> Otherwise it's straightforward. Patch 2 is a cleanup in net area, that I
> can either handle in slab tree or submit in net after SLOB is removed.

Letter would be better, if you don't mind. skbuff.c is relatively hot,
there's a good chance we'll create a conflict.
