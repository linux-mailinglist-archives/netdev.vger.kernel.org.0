Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01E7C5658E0
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 16:45:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbiGDOpS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 10:45:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232665AbiGDOpR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 10:45:17 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73393DEC5;
        Mon,  4 Jul 2022 07:45:16 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id C2E805C00F1;
        Mon,  4 Jul 2022 10:45:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 04 Jul 2022 10:45:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1656945913; x=1657032313; bh=kiuUXP9ruD
        zX/H0U1Opg7S+HL8Nwn2O6feuWWww2TO4=; b=QA2OLOKyOBFRusDhl9mmNwZb6o
        qxge9lI5rigPx1QsWatQc74ZxstjhysejvajmJ8sY2WMbaLF28oPDW7OMFsp/Fk8
        3N7KRPuS5t+vd9jLC7eVWcAtzbmEw5aaJaLrBo3RyyhGk5fnjMfg/mISCFaIYsXp
        PkDGPxyuflPNi6my528G3t85JLVaTAQQayMBDDiuhS/lHoRKbUrUHR9g5mOiFhUM
        7XKRbQjf6AZ9/S+Tkna+Te9cBjq1OEExVIhTmD8ETuht4AEVSf5yxQHXv5mOt5ag
        oB8ta2ZGyi3N+OTVSc4XKagymb1tlxK8nGvX+URcHmXgHTaRU6ISXanidtIA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; t=1656945913; x=1657032313; bh=kiuUXP9ruDzX/H0U1Opg7S+HL8Nw
        n2O6feuWWww2TO4=; b=g6iH//tTnVpTiTSyMRF2uyIH77k4q4GKZIH4fEZACcU7
        tOyb7cDDjZV55G+FDofI0jPvMcQyxpIk4PcBfOKHFiT50sdHBWKSomJ2rW2wctJT
        LzW/cPAzLIkpahRl3IAK+2PTV5Vru2oI6tCgpTxEEw46N/zBNfJHmMXVh5oNjRb7
        xOTz3BOWvdK2l7AaC+LEF4BJLaJiykT1Akah6p3SN4plSrOqVxWabn3N5uDzVxpa
        USaKYR7fZX+D+tecTHx/UppfUWLkDob21fC1OY/ndZr8TH6UvqLD6fPEKcYcXAwy
        D1CM9tu6C6Y7uvsNl7EyX/ow9+OApDalr/EB4MoC7g==
X-ME-Sender: <xms:-PzCYpjBsflADCw884SlFZZRQnYVV9joT34RTngmATYpcjgSm7D5Qw>
    <xme:-PzCYuAZtJQmR1FZXrHrj57NPxNIat4IksH9nuZb8db9XnnQcRfDl1Ld9kOBHp8-I
    PVkPVKXR3HRNw>
X-ME-Received: <xmr:-PzCYpGczjHSjJGmFHelMXgRwyYkcIELrqcPMLRSQKHnRo2fnxwioDe5V9R4UixouWJjPlhuY5pOziTA7TPT0kp9R-8h6LTN>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudehledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgeehue
    ehgfdtledutdelkeefgeejteegieekheefudeiffdvudeffeelvedttddvnecuffhomhgr
    ihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:-PzCYuRbMi7PjRArRzDhouviAp6SXA1GgmPPm3UxLCy6SRH-w5WXXg>
    <xmx:-PzCYmy8c5SMzj3iWg3a8prT-BJT8-mbGA3JtKfiUt1_OVjdEP4cdg>
    <xmx:-PzCYk7eBg0h_V-GL1DY7W7a3BSWgKbUZ0wO2Glz1TMaQV8081Fz4A>
    <xmx:-fzCYrIG5e__rPiBqJQxYRnH4xqN_zYR4OVKWWay3_uLkQOo0RFrpA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 4 Jul 2022 10:45:12 -0400 (EDT)
Date:   Mon, 4 Jul 2022 16:45:10 +0200
From:   Greg KH <greg@kroah.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     stable@vger.kernel.org, edumazet@google.com,
        netdev@vger.kernel.org, Ilya Maximets <i.maximets@ovn.org>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: Re: [PATCH stable 5.15] tcp: add a missing nf_reset_ct() in 3WHS
 handling
Message-ID: <YsL89hdkaK9AOtDy@kroah.com>
References: <20220701014101.684813-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701014101.684813-1-kuba@kernel.org>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 30, 2022 at 06:41:01PM -0700, Jakub Kicinski wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> commit 6f0012e35160cd08a53e46e3b3bbf724b92dfe68 upstream.
> 
> When the third packet of 3WHS connection establishment
> contains payload, it is added into socket receive queue
> without the XFRM check and the drop of connection tracking
> context.
> 
> This means that if the data is left unread in the socket
> receive queue, conntrack module can not be unloaded.
> 
> As most applications usually reads the incoming data
> immediately after accept(), bug has been hiding for
> quite a long time.
> 
> Commit 68822bdf76f1 ("net: generalize skb freeing
> deferral to per-cpu lists") exposed this bug because
> even if the application reads this data, the skb
> with nfct state could stay in a per-cpu cache for
> an arbitrary time, if said cpu no longer process RX softirqs.
> 
> Many thanks to Ilya Maximets for reporting this issue,
> and for testing various patches:
> https://lore.kernel.org/netdev/20220619003919.394622-1-i.maximets@ovn.org/
> 
> Note that I also added a missing xfrm4_policy_check() call,
> although this is probably not a big issue, as the SYN
> packet should have been dropped earlier.
> 
> Fixes: b59c270104f0 ("[NETFILTER]: Keep conntrack reference until IPsec policy checks are done")
> Reported-by: Ilya Maximets <i.maximets@ovn.org>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Florian Westphal <fw@strlen.de>
> Cc: Pablo Neira Ayuso <pablo@netfilter.org>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Tested-by: Ilya Maximets <i.maximets@ovn.org>
> Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
> Link: https://lore.kernel.org/r/20220623050436.1290307-1-edumazet@google.com
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/ipv4/tcp_ipv4.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)

Now queued up, thanks.

greg k-h
