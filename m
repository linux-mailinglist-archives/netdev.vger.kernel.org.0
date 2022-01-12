Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E29E48C89A
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:39:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349985AbiALQjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:39:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343550AbiALQjr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:39:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438AFC06173F;
        Wed, 12 Jan 2022 08:39:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D636DB81F75;
        Wed, 12 Jan 2022 16:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F44C36AE5;
        Wed, 12 Jan 2022 16:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642005583;
        bh=wUo/+nqgdUiUY4rY7vEkB/M00vbVdbARQJ+Has9TCo8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=K2j5Sv1AF1pp41OnuUVwEd58KqRvo7gOXUbJ2wbbLVM7yLu12IzChZR1jy/qpzAKx
         EpioUmD+Gr5lrX3Pa4/IPcLPyj8yf9MkbdqX8aDqNeyC44Ta8bO24Oj6odOIVWNvl9
         zskBRMXQTsbwDRFZGDVYD8Ru3wr4N4UWcVRYlTnCWavqn9/bB3cbT1UjEUOWQ0ofYT
         rOll+KrPHooPfPeenw1kDd7w6E0SyB5/g+7H4smWzH8S0vazuxG9WKjRXU9btDAB7z
         csvNUcCUNlq7acfl+UUTFZM9Y+yJhM6kjW5WVq/Ux+4YQOo22ZtykR9sII5X9SqeQ3
         KHg/wsnfCWOIw==
Date:   Wed, 12 Jan 2022 08:39:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     cgel.zte@gmail.com, davem@davemloft.net, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH] net/ipv6: remove redundant err variable
Message-ID: <20220112083942.391fd0d7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <33308db2-a583-165c-cae0-b055c7976f33@gmail.com>
References: <20220112082655.667680-1-chi.minghao@zte.com.cn>
        <33308db2-a583-165c-cae0-b055c7976f33@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 12 Jan 2022 08:54:41 -0700 David Ahern wrote:
> On 1/12/22 1:26 AM, cgel.zte@gmail.com wrote:
> > diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
> > index fe786df4f849..897194eb3b89 100644
> > --- a/net/ipv6/ip6_tunnel.c
> > +++ b/net/ipv6/ip6_tunnel.c
> > @@ -698,13 +698,12 @@ mplsip6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
> >  	    u8 type, u8 code, int offset, __be32 info)
> >  {
> >  	__u32 rel_info = ntohl(info);
> > -	int err, rel_msg = 0;
> > +	int rel_msg = 0;  
> 
> this line needs to be moved down to maintain reverse xmas tree ordering.
> 
> You need to make the subject
> '[PATCH net-next] net/ipv6: remove redundant err variable'
> 
> and since net-next is closed you will need to resubmit when it is open.

Frankly I'm not sure these type of patches make sense.

Minghao how many instances of this pattern are there in the tree today?

What tools can we use to ensure the pattern does not get added back in
new patches?

> >  	u8 rel_type = type;
> >  	u8 rel_code = code;
> >  
> > -	err = ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
> > +	return ip6_tnl_err(skb, IPPROTO_MPLS, opt, &rel_type, &rel_code,
> >  			  &rel_msg, &rel_info, offset);

You should re-align continuation lines when you move the opening
bracket.

> > -	return err;
> >  }
