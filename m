Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 615F6467BCF
	for <lists+netdev@lfdr.de>; Fri,  3 Dec 2021 17:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382197AbhLCQya (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 11:54:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382205AbhLCQy1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 11:54:27 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5B8C061354
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 08:51:03 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id o4so6890477oia.10
        for <netdev@vger.kernel.org>; Fri, 03 Dec 2021 08:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=n3sbDhWlX4PbV2iEXibvxckJSCikW1LMTHL88Saf4mY=;
        b=i01MYwLxTklYwkJPwVVp6rzbEvpk9w8OgMf1paoBgdWbblz4Mu2qRz/vFX+x3B5Laq
         hIT67y83YcjE5pxe6y0aYv8p5+IzZrAfNgiIX8lPMvbr6REn99sbOO2tHtyYtnJo1ajM
         PNAuZyHcGj7xWo5w5s8K2xpXtewMUxFzhtzISMxenGJbp1/aSYOpzhoIFK1v9pC323Cy
         d7LmEKQXxWOfz94tb5j7UtGoL6su7Jb6LmgdYyNHuW9g9QqDmmz7I3orKOTecY+oQUVn
         TqxFqTMjYU+/N/i+BpIsQn76WUJU/Hz1dYS1IgT4x8eJp7d/Y7Lp0TUG3O79wkLHohdc
         PeTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=n3sbDhWlX4PbV2iEXibvxckJSCikW1LMTHL88Saf4mY=;
        b=KvFHom1wM/hJuOtJyJCTeYwNF7FfvuoTfeP1AEm/TLWiwBY1G29+F2hujPQ73pbUKN
         II7YbupeCRyE0OpvvBbyMKnIV60IrrIqjEc/zHIR3clz8G4hFZkQLTpgHkdb5TsqaS/W
         rIlkcj6bNyf9EHD1FA1hd5GfUVMGtRSv3gjbKpCls3otoDGk4cHJlCTtOJZPhoKfa5VA
         fT3axghzriT2eEQpm9wyO2gXeQ/9bdNxrBQL1qycd2paB+rLUsfBowwhkW0ckRJkzWdM
         FdgeGiPusZ0qtNKapk4RLiMYloESzAmoeEb0XEB9tnyHVcpVN+acciRkaJeiBwLe7R7F
         qzzA==
X-Gm-Message-State: AOAM533UGR3YPlCJ1k/bMtP24KwSpWT+9bIYx41xm3XtBb+RKe+vEDmU
        E48SI+1CX84vDsyKFvs1CRsEbsIEpsw=
X-Google-Smtp-Source: ABdhPJy9t3fi/gYh1s821gcIMpgjFtTBAGRSV4AGWQjepjm6BtP8iicgTPGS+xXLFBEP58pmY9OxWg==
X-Received: by 2002:a05:6808:300b:: with SMTP id ay11mr10841046oib.120.1638550263138;
        Fri, 03 Dec 2021 08:51:03 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id w5sm658054otk.70.2021.12.03.08.51.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Dec 2021 08:51:02 -0800 (PST)
Message-ID: <b77ecea5-0a46-a867-8df5-21fa8ffe6354@gmail.com>
Date:   Fri, 3 Dec 2021 09:51:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [[PATCH net-next v3] 3/3] udp6: Use Segment Routing Header for
 dest address if present
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20211203162926.3680281-1-andrew@lunn.ch>
 <20211203162926.3680281-4-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211203162926.3680281-4-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/3/21 9:29 AM, Andrew Lunn wrote:
> diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
> index 73aaabf0e966..4fd7d3793c1b 100644
> --- a/net/ipv6/seg6.c
> +++ b/net/ipv6/seg6.c
> @@ -134,6 +134,27 @@ void seg6_icmp_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
>  	skb->network_header = network_header;
>  }
>  
> +/* If the packet which invoked an ICMP error contains an SRH return
> + * the true destination address from within the SRH, otherwise use the
> + * destination address in the IP header.
> + */
> +const struct in6_addr *seg6_get_daddr(struct sk_buff *skb,
> +				      struct inet6_skb_parm *opt)
> +{
> +	/* ipv6_hdr() does not work here, since this IP header is
> +	 * nested inside an ICMP error report packet
> +	 */
> +	const struct ipv6hdr *hdr = (const struct ipv6hdr *)skb->data;
> +	struct ipv6_sr_hdr *srh;
> +
> +	if (opt->flags & IP6SKB_SEG6) {
> +		srh = (struct ipv6_sr_hdr *)(skb->data + opt->srhoff);
> +		return  &srh->segments[0];
> +	}
> +
> +	return &hdr->daddr;
> +}
> +

also, that could be an inline in net/seg6.h given how short it is.
