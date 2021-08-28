Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 503303FA376
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 06:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229992AbhH1EHX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 00:07:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229450AbhH1EHV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 00:07:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1DDD60F44;
        Sat, 28 Aug 2021 04:06:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630123591;
        bh=dIBeOi1GGKjlDfEsJVaGO8duIxg15L1z3VVcvy4vXzE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SmW4tzyXz+NvXu1cKRLsrojCzh5PwOcGfKfayoE2RN80DPEOehNEQ8jG4NgBJgK+w
         ZO7+DiLMd/KKcbniBeJkHNR5qXZhvE/KZ2owroHZfpa3wvWBOen6YGgMbUJ1Pg5Dyp
         BxxbTNK0Zl8CPmw7rL9ME50i0AvM/RlxdnrNQx6+Alx+xjH93FkVsNshG4KEFFJCZT
         twmxXgk9P5FVx87iPyLmqm+PbpcSwUaGhPmDWYDz1Y9b9b3g9KWnNME4BAnxfuK9iR
         1wpoyZx3yuy7ishYDCN4eYb2MQg/xRXQThgw+b3/OE/hGWyTNndNQK5jGY0bVO9u+S
         rUM413WD/8bhA==
Date:   Fri, 27 Aug 2021 21:06:29 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>, Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, rocco.yue@gmail.com,
        chao.song@mediatek.com, zhuoliang.zhang@mediatek.com
Subject: Re: [PATCH net-next v6] ipv6: add IFLA_INET6_RA_MTU to expose mtu
 value
Message-ID: <20210827210629.6858ceb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <88523c38-f0b4-8a63-6ca6-68a3122bef79@gmail.com>
References: <20210827150412.9267-1-rocco.yue@mediatek.com>
        <88523c38-f0b4-8a63-6ca6-68a3122bef79@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 27 Aug 2021 09:41:53 -0700 David Ahern wrote:
> On 8/27/21 8:04 AM, Rocco Yue wrote:
> > The kernel provides a "/proc/sys/net/ipv6/conf/<iface>/mtu"
> > file, which can temporarily record the mtu value of the last
> > received RA message when the RA mtu value is lower than the
> > interface mtu, but this proc has following limitations:
> > 
> > (1) when the interface mtu (/sys/class/net/<iface>/mtu) is
> > updeated, mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) will
> > be updated to the value of interface mtu;
> > (2) mtu6 (/proc/sys/net/ipv6/conf/<iface>/mtu) only affect
> > ipv6 connection, and not affect ipv4.
> > 
> > Therefore, when the mtu option is carried in the RA message,
> > there will be a problem that the user sometimes cannot obtain
> > RA mtu value correctly by reading mtu6.
> > 
> > After this patch set, if a RA message carries the mtu option,
> > you can send a netlink msg which nlmsg_type is RTM_GETLINK,
> > and then by parsing the attribute of IFLA_INET6_RA_MTU to
> > get the mtu value carried in the RA message received on the
> > inet6 device. In addition, you can also get a link notification
> > when ra_mtu is updated so it doesn't have to poll.
> > 
> > In this way, if the MTU values that the device receives from
> > the network in the PCO IPv4 and the RA IPv6 procedures are
> > different, the user can obtain the correct ipv6 ra_mtu value
> > and compare the value of ra_mtu and ipv4 mtu, then the device
> > can use the lower MTU value for both IPv4 and IPv6.
> > 
> > Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thank you!
