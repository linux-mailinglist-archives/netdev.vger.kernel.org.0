Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB685FACFB
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 08:41:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiJKGl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Oct 2022 02:41:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229698AbiJKGl0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Oct 2022 02:41:26 -0400
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 406DD371B4;
        Mon, 10 Oct 2022 23:41:26 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id B9656320046F;
        Tue, 11 Oct 2022 02:41:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Tue, 11 Oct 2022 02:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1665470482; x=1665556882; bh=Te6x0oEH5PW3g1OGnqB5gG0tb3T4
        mkg/JlI/9qYhhsM=; b=RJV5L9FHPxtuSOVO3wATpSX3NnlmZAWGIFpEUKtorLE2
        RiXnlKkBefZiMrQyuNuGGd324ambOfLYWxxaHoZ71rumJGiJ54l89Wjg5/NpBuNl
        u5fD476K0xVLzybGe2vi1iNslKl+LA/pvuYClrq8/JnqxJgtYfdYDaGf+QlqlM77
        GWmbIxEajaxLBR9yc0cKrly/dlMqp4gGnusO7gU/aTAWy2wHRyW352XNHTStbTpq
        ztaI6DEEl8xoKW+xiW9c15uMS/wnQRmKXRDwGL/aovK4rWoVbwKkcVkQ/4eNX3nv
        +3nLKXDBg0jsNQj75MrMJSBKBv3cLTSPhAeP6NopTA==
X-ME-Sender: <xms:EBBFYwxQjdpcis1oRb47ud7dayfZqCPX6m93IFoSPzVxj2mM9ttt5g>
    <xme:EBBFY0T5G3_O9JDIz-Wepqf70i8MMlT3AMigTZa0AMTn_d1fXqpW6S4usWVcgu4ce
    p0B2bca37bRsfY>
X-ME-Received: <xmr:EBBFYyWS7Ppc3HlbKJpOfwr-SNkaibVo_lPqv2KDSaLSYl5YN4pGUYvw9F04jTA0WeEtQjhZ_qIy31T6Lrz9UXG3etU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeejhedguddtlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkugho
    ucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvudefveekheeugeeftddvveefgfduieefudeifefgleekheegleegjeej
    geeghfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    hiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:EBBFY-jjBnevYXktaCxs5NylxKdGeqg2opyXr2YxjAJ8_YtB_wxbGQ>
    <xmx:EBBFYyA-1WRXyJ2KAPrUJR-hg4sbmf27HNs3LHnwCr6GFIUSKrhybQ>
    <xmx:EBBFY_LPAgsQ6OmwAH69Mk3k_KDtau11NydA9D89rqoD_iLwKpQUqw>
    <xmx:EhBFY-6LmPL4M3P9WZd2XdRGylYVyg9U1EEI8RmXB8u1HiYtCZLXEw>
Feedback-ID: i494840e7:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 11 Oct 2022 02:41:20 -0400 (EDT)
Date:   Tue, 11 Oct 2022 09:41:15 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, steffen.klassert@secunet.com,
        herbert@gondor.apana.org.au, dsahern@kernel.org,
        contact@proelbtn.com, pablo@netfilter.org,
        nicolas.dichtel@6wind.com, razor@blackwall.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH ipsec-next,v4 3/3] xfrm: lwtunnel: add lwtunnel support
 for xfrm interfaces in collect_md mode
Message-ID: <Y0UQC0oycrGs4Zad@shredder>
References: <20220826114700.2272645-1-eyal.birger@gmail.com>
 <20220826114700.2272645-4-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220826114700.2272645-4-eyal.birger@gmail.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 02:47:00PM +0300, Eyal Birger wrote:
> diff --git a/net/core/lwtunnel.c b/net/core/lwtunnel.c
> index 9ccd64e8a666..6fac2f0ef074 100644
> --- a/net/core/lwtunnel.c
> +++ b/net/core/lwtunnel.c
> @@ -50,6 +50,7 @@ static const char *lwtunnel_encap_str(enum lwtunnel_encap_types encap_type)
>  		return "IOAM6";
>  	case LWTUNNEL_ENCAP_IP6:
>  	case LWTUNNEL_ENCAP_IP:
> +	case LWTUNNEL_ENCAP_XFRM:
>  	case LWTUNNEL_ENCAP_NONE:
>  	case __LWTUNNEL_ENCAP_MAX:
>  		/* should not have got here */

Eyal,

The warning at the bottom can be triggered [1] from user space when the
kernel is compiled with CONFIG_MODULES=y and CONFIG_XFRM=n:

 # ip route add 198.51.100.0/24 dev dummy1 encap xfrm if_id 1
 Error: lwt encapsulation type not supported.

Original report is from a private syzkaller instance which I have
reduced to the command above.

Thanks

[1]
 WARNING: CPU: 3 PID: 2746262 at net/core/lwtunnel.c:57 lwtunnel_valid_encap_type+0x4f/0x120
[...]
 Call Trace:
  <TASK>
  rtm_to_fib_config+0x211/0x350
  inet_rtm_newroute+0x3a/0xa0 
  rtnetlink_rcv_msg+0x154/0x3c0
  netlink_rcv_skb+0x49/0xf0
  netlink_unicast+0x22f/0x350 
  netlink_sendmsg+0x208/0x440 
  ____sys_sendmsg+0x21f/0x250
  ___sys_sendmsg+0x83/0xd0
  __sys_sendmsg+0x54/0xa0
  do_syscall_64+0x35/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd
