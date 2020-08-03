Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E60923A1B6
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 11:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726034AbgHCJ0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 05:26:40 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:44026 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725945AbgHCJ0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 05:26:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596446798;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HXfBoRWIWg4C4wOIc3itQd4oHDH+MFDocd2EVsu5wkU=;
        b=W2ZW1/DMwtSZxZYQB/fLD+nNs3VFqVJh9JzGGbwXmKZodXi3DWKTtrjmGcKBJyR+IL6UXv
        zgmandlgGz0IXgOU1LhpaGK8s1/xoiRXKWNte8iZl76YfeiMWbHGK+3EqVIk9eXaw+lLU0
        pBAQDsJ48VE+eOMtBTNihWQX4/tkTwg=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-412-65-ztnK5MpiFBl44d1gvRA-1; Mon, 03 Aug 2020 05:26:37 -0400
X-MC-Unique: 65-ztnK5MpiFBl44d1gvRA-1
Received: by mail-wr1-f72.google.com with SMTP id r29so7094648wrr.10
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 02:26:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HXfBoRWIWg4C4wOIc3itQd4oHDH+MFDocd2EVsu5wkU=;
        b=QL1iNUaNtbcfOJMVPauIWRYIJ8vfuD+D6K3XEK0CF8gYxLLzlGgY1YwGCi72ISYeK9
         Nr02A1ZaVG0Cec5JAM56PJaCVPrMuIB7L37rJg48vNtAnM8j5qQEarLPtHfn3VfhRseT
         YmzNQ8F4aIh8to32ysQeriIrcNamo+bmLAjWROUj/fy9n0F628s3F6U+rDq2xtK6eP4f
         TJUlLexbqLk9Scm0sGmmE978hjbj0sLoAi/4DwKpmno2zV1vGAFKVWU8gEbts1cGyPOp
         DS99w3tuhR/5ICshhbF7KO3EF9zEHJIXoAe6rG4HoihDXsP9wjuWRpwcHPuQoTTOdDgv
         L0bw==
X-Gm-Message-State: AOAM531ObYOL8dN7BWeMv16k3SKO0cOLO4N36GynAnBuBnd5qdKsnJAI
        9bem43dZlt40wwzcTN6JoVvXOb/uIiqJNcOULetp3RfCabAca/7b/pFDokwuASjUT/V5q9LFmD8
        zzSRJczNvHB4DD5hl
X-Received: by 2002:a5d:424f:: with SMTP id s15mr15332429wrr.342.1596446795786;
        Mon, 03 Aug 2020 02:26:35 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzojwIR9bCr5F9BhTvyfOVnXLIJUE0qkqhiWtPDUJ0Rxhw7cm3NbW0vO3xylwJjBUr9qArN8w==
X-Received: by 2002:a5d:424f:: with SMTP id s15mr15332417wrr.342.1596446795623;
        Mon, 03 Aug 2020 02:26:35 -0700 (PDT)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id t11sm22954041wrs.66.2020.08.03.02.26.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 02:26:34 -0700 (PDT)
Date:   Mon, 3 Aug 2020 11:26:33 +0200
From:   Guillaume Nault <gnault@redhat.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Petr Machata <pmachata@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        David Ahern <dsahern@kernel.org>,
        Eelco Chaudron <echaudro@redhat.com>
Subject: Re: [PATCH net-next 1/2] net: add IP_DSCP_MASK
Message-ID: <20200803092633.GA3827@linux.home>
References: <20200803080217.391850-1-liuhangbin@gmail.com>
 <20200803080217.391850-2-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803080217.391850-2-liuhangbin@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 03, 2020 at 04:02:16PM +0800, Hangbin Liu wrote:
> In RFC1349 it defined TOS field like
> 
>        0     1     2     3     4     5     6     7
>     +-----+-----+-----+-----+-----+-----+-----+-----+
>     |   PRECEDENCE    |          TOS          | MBZ |
>     +-----+-----+-----+-----+-----+-----+-----+-----+
> 
> But this has been obsoleted by RFC2474, and updated by RFC3168 later.
> Now the DS Field should be like
> 
>        0     1     2     3     4     5     6     7
>     +-----+-----+-----+-----+-----+-----+-----+-----+
>     |          DS FIELD, DSCP           | ECN FIELD |
>     +-----+-----+-----+-----+-----+-----+-----+-----+
> 
>       DSCP: differentiated services codepoint
>       ECN:  Explicit Congestion Notification
> 
> So the old IPTOS_TOS_MASK 0x1E should be updated. But since
> changed the value will break UAPI, let's add a new value
> IP_DSCP_MASK 0xFC as a replacement.
> 
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> ---
>  include/uapi/linux/in_route.h | 1 +
>  include/uapi/linux/ip.h       | 2 ++
>  2 files changed, 3 insertions(+)
> 
> diff --git a/include/uapi/linux/in_route.h b/include/uapi/linux/in_route.h
> index 0cc2c23b47f8..26ba4efb054d 100644
> --- a/include/uapi/linux/in_route.h
> +++ b/include/uapi/linux/in_route.h
> @@ -29,5 +29,6 @@
>  #define RTCF_NAT	(RTCF_DNAT|RTCF_SNAT)
>  
>  #define RT_TOS(tos)	((tos)&IPTOS_TOS_MASK)
> +#define RT_DSCP(tos)	((tos)&IP_DSCP_MASK)
>  
>  #endif /* _LINUX_IN_ROUTE_H */
> diff --git a/include/uapi/linux/ip.h b/include/uapi/linux/ip.h
> index e42d13b55cf3..62e4169277eb 100644
> --- a/include/uapi/linux/ip.h
> +++ b/include/uapi/linux/ip.h
> @@ -22,6 +22,8 @@
>  
>  #define IPTOS_TOS_MASK		0x1E
>  #define IPTOS_TOS(tos)		((tos)&IPTOS_TOS_MASK)
> +#define IP_DSCP_MASK		0xFC
> +#define IP_DSCP(tos)		((tos)&IP_DSCP_MASK)

What's the use of IP_DSCP()? It's the same as RT_DSCP().

I guess it's supposed to be the equivalent of IPTOS_TOS(), but that
macro is only used once in the tree, where it could be replaced with
RT_TOS().

I can't see a reason to copy this pattern.

