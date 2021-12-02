Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4155E466872
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 17:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359623AbhLBQmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 11:42:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242448AbhLBQmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 11:42:01 -0500
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com [IPv6:2607:f8b0:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5247C06174A
        for <netdev@vger.kernel.org>; Thu,  2 Dec 2021 08:38:38 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so355725otv.9
        for <netdev@vger.kernel.org>; Thu, 02 Dec 2021 08:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cAXmB0n34WBsoO6hi+dfMBcdo9th0bJiy/P23hVvSXs=;
        b=lwXHF5nU2gJncImtcm/C0WISWm4c3QQI8dddQmCLa5FfmIMqBEmR+lQgsDXj8xL2+N
         WURTSaAXnaRdBnl9i3Zlny/SMBkBOPJFdXBt9xzAzS6YIIJduScZzwdxDAG9E20fUVsx
         xPM8yuy6oA7NWSkUtKVXC4CQwrpidD+8DbQkB3YZVPVQMxYUF42R+x8Ku6Du1aWjrt8M
         j2lMBreJ/hhbJMQJefkeISxsF2yYs+h7wyVal7WwbedX1YVjRwkWu0E1lWw5s+n3boEA
         WB/7AxnWALW2sumsGW4ONHhZ9KJNTwOnh9DAUue7dUcLW+hqk18yOyAOkVEgZIPLiucY
         ylzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cAXmB0n34WBsoO6hi+dfMBcdo9th0bJiy/P23hVvSXs=;
        b=Lqedv0dQJuUZNoLZcWnULkJWSbNlUitDnd20myLCUKhmCQ6Tuhv9qFl9o6CqbF2owS
         c47IYzFQze1IJp42L7GvnD/+pgplHFLz3A9Hed/1afrcAuhK165CyqH64A+7o/RBdmsS
         3M7dDAtAYL6lrbCCynAyv3o+Sm4OlXj6oW8F/X8uazeYnsOv6P3xIYBTK85cHmH4Im31
         iW36Gg/NmdHm9o4T2mG+zUcboSqQG0bS62Fo748kMnmbj9biZMS5M8oAPUxCHMqh4h3r
         X/1KoTLLzWz1Bg+StPKx2ACsL/ckl3+jWoIzshbEOvEQhDK1PBFljy48VjS4gTjj9UP2
         T6Ng==
X-Gm-Message-State: AOAM530CkBisI6CB11JCjEARom4iDPT7uZZoiX3E2YF8VNFvfEqeJ/Ld
        yHzklGb2VZAjDLBYrOo1rY0=
X-Google-Smtp-Source: ABdhPJxOa3hzPK7WE7tMaCX26Ejp/M58D0AevrRDW8Ftg53X4i18ASqXPFbSfXpJ5NVWpHlOBxsXUg==
X-Received: by 2002:a05:6830:80a:: with SMTP id r10mr12513610ots.74.1638463118010;
        Thu, 02 Dec 2021 08:38:38 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id r25sm109688ote.73.2021.12.02.08.38.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Dec 2021 08:38:37 -0800 (PST)
Message-ID: <d284a03b-baf8-339f-05bb-c42c3a2fb3f8@gmail.com>
Date:   Thu, 2 Dec 2021 09:38:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [patch RFC net-next v2 2/3] icmp: ICMPV6: Examine invoking packet
 for Segment Route Headers.
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        James Prestwood <prestwoj@gmail.com>,
        Justin Iurman <justin.iurman@uliege.be>,
        Praveen Chaudhary <praveen5582@gmail.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>,
        Eric Dumazet <edumazet@google.com>,
        netdev <netdev@vger.kernel.org>
References: <20211201202519.3637005-1-andrew@lunn.ch>
 <20211201202519.3637005-3-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20211201202519.3637005-3-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/1/21 1:25 PM, Andrew Lunn wrote:
> diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
> index a7c31ab67c5d..dd1fe8a822e3 100644
> --- a/net/ipv6/icmp.c
> +++ b/net/ipv6/icmp.c
> @@ -818,9 +819,40 @@ static void icmpv6_echo_reply(struct sk_buff *skb)
>  	local_bh_enable();
>  }
>  
> +/* Determine if the invoking packet contains a segment routing header.
> + * If it does, extract the true destination address, which is in the
> + * first segment address
> + */
> +static void icmpv6_notify_srh(struct sk_buff *skb, struct inet6_skb_parm *opt)
> +{
> +	__u16 network_header = skb->network_header;
> +	struct ipv6_sr_hdr *srh;
> +
> +	/* Update network header to point to the invoking packet
> +	 * inside the ICMP packet, so we can use the seg6_get_srh()
> +	 * helper.
> +	 */
> +	skb_reset_network_header(skb);
> +
> +	srh = seg6_get_srh(skb, 0);
> +	if (!srh)
> +		goto out;
> +
> +	if (srh->type != IPV6_SRCRT_TYPE_4)
> +		goto out;
> +
> +	opt->flags |= IP6SKB_SEG6;
> +	opt->srhoff = (unsigned char *)srh - skb->data;
> +
> +out:
> +	/* Restore the network header back to the ICMP packet */
> +	skb->network_header = network_header;
> +}
> +

since this is SR specific, why not put it in seg6.c?
