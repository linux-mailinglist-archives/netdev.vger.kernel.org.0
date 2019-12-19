Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEDF12685D
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:47:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726869AbfLSRr0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:47:26 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:52761 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726818AbfLSRr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:47:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576777644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/t4Upj7hPAzDTNoMx4qXwpAn5Gp98d4wONcCwSlNJDo=;
        b=YmOSA1yGYlSjrfH7YSV0bMOwKXzDqWDYNYKNFxsgsVoZMA/mGMIiWVBwGhtXcbOO+W2Vz/
        0fbBn/gsGAxTRcDkaYURr0i9rvQaG3ZK18+7S1CzxPyJrzxKkCuozLyBIvRXEDTp5vRtY+
        gaFIp4ichoMjRWqHJDMaidsW2gfIMiQ=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-145-4FNFYGkpPfKJoY23564GxA-1; Thu, 19 Dec 2019 12:47:23 -0500
X-MC-Unique: 4FNFYGkpPfKJoY23564GxA-1
Received: by mail-wr1-f72.google.com with SMTP id c6so2627327wrm.18
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:47:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/t4Upj7hPAzDTNoMx4qXwpAn5Gp98d4wONcCwSlNJDo=;
        b=PHacLdAmg2BfRb1lBeTiaFqkS6kV/uEqvmIpOAu7p/6bgK9n9R3G0OTq5vxJEr0+e2
         mTZbiCUBEB+qJ+jUZrxtS1+IpgC7XgJrXiY5yONOCPf2D9Fbvxn3zZKW16MHzWRYeQtc
         aDByFAAxxDFK0LpoosxzB716PGlXOkiLwFt704lL1R1haGY8pGyqHJ1jeStnEnLWzt5o
         AgtidXF/O0MNfJO0NbIdtneElo7Gkj7qiN53a11ZRIfKao1XWCkHwPd7G13XEsA5HR4/
         o26FrMim0Iny7RZh47cXFSSytdkF7yILWlqm/EzgvwG+ofdP4QTuJStIAvvKtV6wWOAR
         livg==
X-Gm-Message-State: APjAAAVL4YLuHi8NcioW9Pk3oBWnjeQy0s+YKfiOF3yprCa8S6mpK01L
        Z9+ay88oVPHNPETZOt5tiaVvtcV+SObTOvYZLL6l/tmawODptAP80EQyFvFhq6uhsM01yfb78ON
        WVgc+C6Z30HC4NbD7
X-Received: by 2002:a05:600c:203:: with SMTP id 3mr12055623wmi.31.1576777642680;
        Thu, 19 Dec 2019 09:47:22 -0800 (PST)
X-Google-Smtp-Source: APXvYqxWU0y+iXI8HzFmk97OEIWrw923Z6sFr4RDsPMls+wIFXzSJs8bG1wTrwKZwhpQH0qxRjF1sg==
X-Received: by 2002:a05:600c:203:: with SMTP id 3mr12055599wmi.31.1576777642474;
        Thu, 19 Dec 2019 09:47:22 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id u8sm6671660wmm.15.2019.12.19.09.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 09:47:21 -0800 (PST)
Date:   Thu, 19 Dec 2019 18:47:20 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Julian Anastasov <ja@ssi.bg>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Pablo Neira <pablo@netfilter.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kodanev <alexey.kodanev@oracle.com>
Subject: Re: [PATCH net-next 5/8] tunnel: do not confirm neighbor when do
 pmtu update
Message-ID: <20191219174720.GA14566@linux.home>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
 <20191218115313.19352-6-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218115313.19352-6-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 07:53:10PM +0800, Hangbin Liu wrote:
> When do IPv6 tunnel PMTU update and calls __ip6_rt_update_pmtu() in the end,
> we should not call dst_confirm_neigh() as there is no two-way communication.
> 
> Although ipv4 tunnel is not affected as __ip_rt_update_pmtu() does not call
> dst_confirm_neigh(), we still not do neigh confirm to keep consistency with
> IPv6 code.
> 
This is a bit confusing. IPv4 tunnels (e.g. gretap) are affected, as show
by your reproducer. Quoting patch 0:
"""
  The reason is when we ping6 remote via gretap, we will call like

  gre_tap_xmit()
   - ip_tunnel_xmit()
     - tnl_update_pmtu()
       - skb_dst_update_pmtu()
         - ip6_rt_update_pmtu()
           - __ip6_rt_update_pmtu()
             - dst_confirm_neigh()
               - ip6_confirm_neigh()
                 - __ipv6_confirm_neigh()
                   - n->confirmed = now
"""

IPv4 is not affected if it's on the overlay, but that's not what is
this patch cares about. Unless I've misunderstood this paragraph, I
think that you can just delete it.

> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  net/ipv4/ip_tunnel.c  | 2 +-
>  net/ipv6/ip6_tunnel.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
> index 38c02bb62e2c..0fe2a5d3e258 100644
> --- a/net/ipv4/ip_tunnel.c
> +++ b/net/ipv4/ip_tunnel.c
> @@ -505,7 +505,7 @@ static int tnl_update_pmtu(struct net_device *dev, struct sk_buff *skb,
>  		mtu = skb_valid_dst(skb) ? dst_mtu(skb_dst(skb)) : dev->mtu;
>  
>  	if (skb_valid_dst(skb))
> -		skb_dst_update_pmtu(skb, mtu);
> +		skb_dst_update_pmtu_no_confirm(skb, mtu);
>  

Fixes: 0dec879f636f ("net: use dst_confirm_neigh for UDP, RAW, ICMP, L2TP")

