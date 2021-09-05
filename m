Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3AC64010C7
	for <lists+netdev@lfdr.de>; Sun,  5 Sep 2021 18:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236513AbhIEQOh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Sep 2021 12:14:37 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48683 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229566AbhIEQOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Sep 2021 12:14:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 300DB5C00F0;
        Sun,  5 Sep 2021 12:13:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 05 Sep 2021 12:13:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=imVX4K
        Du2acMPLc0coRno6vwc+wHYAHsXVPuB2UKWcM=; b=o5OqkkJ53vHL2FHICdG6Na
        vlFy3sBKyV64ZdU98AE5R/rJ5t8ViK/ONGwhctLSHESBpTaJzks9Y3S7siw1TTGm
        vbhR9i4+VjccvH4bL5pZdzD0cME3oVoheRXulbjXlikOiHUjezdh4zy5xYSsRGrT
        2TuemqBP2nDyNRl3Q3tzsHWE2Ya3+jK5SZ7AoFTvq574j4Sa9cUkAvLhPy3Tpqat
        4R748dDb/7MczZThDFm/yf/9f+Y1pdArsX3r7FQrqvQJc1Kl38dWfuGMgTA7oql+
        /XWgRezOz/iScB1Jp1QlYxIj4y4t5ivq5QhORnZ9Eu+gdF3XyyqpW046ikDGhbAg
        ==
X-ME-Sender: <xms:rOw0Yb8vUVjJ7vIbxwCZ_hOw8Q0UJXHh1hqexA3f05bXMyQO0mpz9Q>
    <xme:rOw0YXsKgXnAFxsLQGPVwsTp6fDozAPkZqhViRWZlhGChhM-H6o5eGQD3dzldwuYe
    SSurDBZL-kD1Jg>
X-ME-Received: <xmr:rOw0YZBQIPbzpVCRl8ZKZ2oLtO7qC3vchMoCj3mdf53uQT23TzXzbLhi9-Cbw-e2u3mwlboBngEBOuGRpzEkO3aO98gFng>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefuddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpedtffekkeefudffveegueejffejhfetgfeuuefgvedtieehudeuueekhfduheel
    teenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:rOw0YXcZxz1_ZOYAf3OrNlxWQfQ_T5bhPhmtc1tVx9IPyTbE9g1OLg>
    <xmx:rOw0YQOGnhaWe7Fuhj59EkfGcsfkCcXrKgCJSnJo53_z6lGqiJRLlA>
    <xmx:rOw0YZldkLMfKjKM90P3kgkUaV3tMb4ew-IXVYibIHjDfHWLc8aaBw>
    <xmx:rew0YdraJlVw31ZSbeVtEdlKyBUbxZTEDZoZLiKIOG47LrYzt_eFWQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Sep 2021 12:13:32 -0400 (EDT)
Date:   Sun, 5 Sep 2021 19:13:28 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        chouhan.shreyansh630@gmail.com,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH net] ip_gre: validate csum_start only on pull
Message-ID: <YTTsqIjRJMg7js6G@shredder>
References: <20210905152109.1805619-1-willemdebruijn.kernel@gmail.com>
 <CAKgT0UfX__k29P+SuhSrsantA9=KVi8=9+pspmcDXh+dWuHyfQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgT0UfX__k29P+SuhSrsantA9=KVi8=9+pspmcDXh+dWuHyfQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Sep 05, 2021 at 08:47:16AM -0700, Alexander Duyck wrote:
> Looks good to me.
> 
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Thanks Willem and Alex! Applied the patch to my tree. Will let you know
tomorrow morning after regression is complete (though I'm sure it's
fine).
