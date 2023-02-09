Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55BA169013F
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 08:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjBIH15 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 02:27:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBIH14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 02:27:56 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1018E25960
        for <netdev@vger.kernel.org>; Wed,  8 Feb 2023 23:27:52 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 9FFAA5C00DC;
        Thu,  9 Feb 2023 02:27:49 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 09 Feb 2023 02:27:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1675927669; x=1676014069; bh=KkqBFMNIS8rWz0PpcdTb6h68jLgi
        ydKowtuoLMREmw0=; b=l6oTwWq5jBKDsIzXMYroUoXimdyxR3MJhoxt98svq5mt
        EU/wJK4vLWr3GoscBMdMwU3sByEdpU0m3k0DLrrYuil65tJoCvFKcGHrLL0XtD8d
        FCABlSxnHvObyh3bHDVAeFcl0/awz+8CjLAhUHc8iXXiugWz0O5oCnUKX+049WNh
        bgf81Bk+TNMfddKMQWaEwy0dZrcSKv+ID5sCsbV40ewmFdEjDG1cOhujFCLFAuCm
        FZ0lP+XcVrMJVDH9BTnEEY7Dod6w3IyVTvgMbbxn+kP9HJWQ0knWZVT9DHW2qEZS
        yWtBubc5d+JLvsGYQrnz0uKGw3HnbXEInFom+rb7RA==
X-ME-Sender: <xms:daDkY_gBHzTF-Lk7Psu-kW1f1aArbhcQN8xUBI2sdX8vVfiHQKozMQ>
    <xme:daDkY8DCjjX14MybKTVJVsDGJepvgWs6ncW8SV-jbHU_t1CtitkV0FOaVX8rbyAWb
    QqmJD__EfbVxAo>
X-ME-Received: <xmr:daDkY_HDIRGsVqWzpnYesddsVE7EDimDJvAnhcsgIxXvLd5NnDkbXKnRH16FxWy9-3GI7e4a5Z8vx9q3ox-Y5t9T9LM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudehvddgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvddufeevkeehueegfedtvdevfefgudeifeduieefgfelkeehgeelgeejjeeg
    gefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:daDkY8Rfeob1fVAgDQSa3jtW6W7c4vvB5x9Akk-fDVnE8CnoRCxT2Q>
    <xmx:daDkY8yiGLEr7fOlX_VXhIrPNMABwQM1U_skbgW0Out7fKSpTUe-kw>
    <xmx:daDkYy41twZ0_qkGNmHz-pQGMJA2IneYpEBAsCB-l2HuU8QV3TGoiQ>
    <xmx:daDkYznVsAlWX5CqV5hTLypJpllVBEczuolpP17BsbIWZ6_67SwR_A>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 9 Feb 2023 02:27:48 -0500 (EST)
Date:   Thu, 9 Feb 2023 09:27:44 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, Soheil Hassas Yeganeh <soheil@google.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        syzbot <syzkaller@googlegroups.com>
Subject: Re: [PATCH net-next] net: enable usercopy for skb_small_head_cache
Message-ID: <Y+SgcC4pRz42H83G@shredder>
References: <20230208142508.3278406-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230208142508.3278406-1-edumazet@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 02:25:08PM +0000, 'Eric Dumazet' via syzkaller wrote:
> syzbot and other bots reported that we have to enable
> user copy to/from skb->head. [1]
> 
> We can prevent access to skb_shared_info, which is a nice
> improvement over standard kmem_cache.
> 
> Layout of these kmem_cache objects is:
> 
> < SKB_SMALL_HEAD_HEADROOM >< struct skb_shared_info >

[...]

> 
> Fixes: bf9f1baa279f ("net: add dedicated kmem_cache for typical/small skb->head")
> Reported-by: syzbot <syzkaller@googlegroups.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Tested-by: Ido Schimmel <idosch@nvidia.com>

Hit this one as well, patch solved the problem.

Thanks!
