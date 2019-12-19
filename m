Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8FF126877
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 18:54:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfLSRyC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 12:54:02 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:51183 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726797AbfLSRyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 12:54:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576778040;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=a8OEL1SzrUF/dKr5VZBAF7fAHKAmo7B7XLTTtQdMEUI=;
        b=fQ/IiYIyODgb1YPw/kcL623AM/cuDvOa5N/RuejaW8SSzAaCm6PdL5Sbo25igRNP2+OI5/
        lsSS5lCWqeAuV04AYddQUVTDINcJg94CCUB8uoY73IViS6Xb7u5rh1g2phtfqgX7+XYwDh
        Y6Brx0UtlT6393/KO/7HmJ1rAaUPxxY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70-tapNUUeIO7KHrPClTvBybA-1; Thu, 19 Dec 2019 12:53:58 -0500
X-MC-Unique: tapNUUeIO7KHrPClTvBybA-1
Received: by mail-wr1-f71.google.com with SMTP id h30so2662218wrh.5
        for <netdev@vger.kernel.org>; Thu, 19 Dec 2019 09:53:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=a8OEL1SzrUF/dKr5VZBAF7fAHKAmo7B7XLTTtQdMEUI=;
        b=sdlI71DMonxfzwo5rY8Sxz/vuqvk0W8DytAdWoEmraF0j5TYjvj7TSyibEdD1gNy5X
         dlb3B378X9Tzv5l2zPSqxU7oiGMK4cdV4/EpDz+M8EkfLlKzZHdoMC4d0BNpE7gFiQph
         aZA+MIp1YIA5Q/S+WGIKOYPEnVo5Bj+A/OhtCT8ekDspkkm57o11OM0zCLeMnry2W7K3
         sy5r9m5UODPCG67/XLkVu/Licm5M3XHQdNzlcdiaEkGfYZgKPnXsm8n1VX2iAT6g923T
         YLB4frn2GjxRSv2nIoUQ5Y8eYqt/hGTGVZv+BXfc7APhwbH+yEOE7PPq+Q3rTe9ax+FV
         T+NA==
X-Gm-Message-State: APjAAAWSGcwcCcLtSSdrQHo4sR7ekoCl05I1/WqwD0kUL69HTC84ktSA
        eYCEAWfeXXqiwN6XL94BEGnSMf4AU3OWWUVDI0SkfzQmQCuf5zI5p7SFibbFPWQb0K+KAIH06cH
        tBE1aFRl2basui+p1
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr10108524wrm.24.1576778036499;
        Thu, 19 Dec 2019 09:53:56 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtpEpumqpQrE/XqXSa+eSoLAnW5A3nS3xYdWd5SZHrXUhVmXKDaIdkiDr19skwGUnyWjdS7A==
X-Received: by 2002:adf:dcc2:: with SMTP id x2mr10108512wrm.24.1576778036318;
        Thu, 19 Dec 2019 09:53:56 -0800 (PST)
Received: from linux.home (2a01cb0585290000c08fcfaf4969c46f.ipv6.abo.wanadoo.fr. [2a01:cb05:8529:0:c08f:cfaf:4969:c46f])
        by smtp.gmail.com with ESMTPSA id w13sm7274619wru.38.2019.12.19.09.53.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Dec 2019 09:53:55 -0800 (PST)
Date:   Thu, 19 Dec 2019 18:53:53 +0100
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
Subject: Re: [PATCH net-next 0/8] disable neigh update for tunnels during
 pmtu update
Message-ID: <20191219175353.GC14566@linux.home>
References: <20191203021137.26809-1-liuhangbin@gmail.com>
 <20191218115313.19352-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191218115313.19352-1-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 18, 2019 at 07:53:05PM +0800, Hangbin Liu wrote:
> When we setup a pair of gretap, ping each other and create neighbour cache.
> Then delete and recreate one side. We will never be able to ping6 to the new
> created gretap.
> 
> The reason is when we ping6 remote via gretap, we will call like
> 
> gre_tap_xmit()
>  - ip_tunnel_xmit()
>    - tnl_update_pmtu()
>      - skb_dst_update_pmtu()
>        - ip6_rt_update_pmtu()
>          - __ip6_rt_update_pmtu()
>            - dst_confirm_neigh()
>              - ip6_confirm_neigh()
>                - __ipv6_confirm_neigh()
>                  - n->confirmed = now
> 
> As the confirmed time updated, in neigh_timer_handler() the check for
> NUD_DELAY confirm time will pass and the neigh state will back to
> NUD_REACHABLE. So the old/wrong mac address will be used again.
> 
> If we do not update the confirmed time, the neigh state will go to
> neigh->nud_state = NUD_PROBE; then go to NUD_FAILED and re-create the
> neigh later, which is what IPv4 does.
> 
> We couldn't remove the ip6_confirm_neigh() directly as we still need it
> for TCP flows. To fix it, we have to pass a bool parameter to
> dst_ops.update_pmtu() and only disable neighbor update for tunnels.
> 

Apart from the missing Fixes tags, code looks good to me.

Reviewed-by: Guillaume Nault <gnault@redhat.com>

