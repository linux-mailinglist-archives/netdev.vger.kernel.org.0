Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789403B4748
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 18:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229712AbhFYQSj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 12:18:39 -0400
Received: from novek.ru ([213.148.174.62]:32858 "EHLO novek.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229630AbhFYQSj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Jun 2021 12:18:39 -0400
Received: from [192.168.0.18] (unknown [37.228.234.253])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id B2A585006F4;
        Fri, 25 Jun 2021 19:14:17 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru B2A585006F4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1624637659; bh=ikCs0PrHd9kLLeRriM9Bup/d3XiotZIPgA6nnaLdFnk=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=Qp3esMYMYCBHJUB0XMDkMoLWZF/rHBgJX5LO1tfGehTwLUOG6OecEPlq+eNJa6+py
         pIkdMJE+UcO5FGxUD8ZnNCf03asq3MjSYi092YdSjKbW9xsRo3uJcAoe3mjAOXjr9B
         gu99i+e19kPckPcc1NOUFL9BTadL92jt9k3aPE5Y=
Subject: Re: [PATCH net] net: lwtunnel: handle MTU calculation in forwading
To:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210625155700.4276-1-vfedorenko@novek.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
Message-ID: <f8dda3aa-6945-09d4-c36e-793b773b7b8e@novek.ru>
Date:   Fri, 25 Jun 2021 17:16:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210625155700.4276-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,NICE_REPLY_A
        autolearn=ham autolearn_force=no version=3.4.1
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on gate.novek.ru
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.06.2021 16:57, Vadim Fedorenko wrote:
> Commit 14972cbd34ff ("net: lwtunnel: Handle fragmentation") moved
> fragmentation logic away from lwtunnel by carry encap headroom and
> use it in output MTU calculation. But the forwarding part was not
> covered and created difference in MTU for output and forwarding and
> further to silent drops on ipv4 forwarding path. Fix it by taking
> into account lwtunnel encap headroom.
> 
> The same commit also introduced difference in how to treat RTAX_MTU
> in IPv4 and IPv6 where latter explicitly removes lwtunnel encap
> headroom from route MTU. Make IPv4 version do the same.
> 
> Fixes: 14972cbd34ff ("net: lwtunnel: Handle fragmentation")
> Suggested-by: David Ahern <dsahern@gmail.com>
> Signed-off-by: Vadim Fedorenko <vfedorenko@novek.ru>
> ---
>   include/net/ip.h        | 10 ++++++----
>   include/net/ip6_route.h | 16 ++++++++++++----
>   net/ipv4/route.c        |  3 ++-
>   3 files changed, 20 insertions(+), 9 deletions(-)
> 

Please, ingore it, I was too fast, sorry. Will post v2 soon

