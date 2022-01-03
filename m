Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D082D483635
	for <lists+netdev@lfdr.de>; Mon,  3 Jan 2022 18:35:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiACRe6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jan 2022 12:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235542AbiACRej (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jan 2022 12:34:39 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76D89C061761
        for <netdev@vger.kernel.org>; Mon,  3 Jan 2022 09:34:39 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id q5so41146696ioj.7
        for <netdev@vger.kernel.org>; Mon, 03 Jan 2022 09:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xG4GE0ZWTHD5oZzmyVSqHb7fSQhjqDFEHuQ5l+tpxgU=;
        b=LLftgB/flQJb3ibkzoPtGL6yl5mTNWSBfN1DXE4SZzuZIUJSH0eZ/2YXh+lzX6opKL
         0/tjoP6K4BspWa3kxnXPR4f8Ta0U8E1+mcp0y67P7Q+pV4rHNYy1RASqNEAkAEY7aliF
         1OHFqwckJd3izVI5OK6fqE8RuNfmRkmJyKqEdt/AdwsknV3sMAPZ4gcdOk6zRFWHvSb3
         lFWSrCos67XrqY5tkXy8z6q6WbQmo6AcE4Q8onnJPDlYn8uUgfIOR8gR4eWdBi7+aA82
         oceK8xXA0ubaVCm5y+pALAxoLfOMMr8M41e/scSu3UZJdjJOonSh+LvJDOyeNka1Ed9l
         ggpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xG4GE0ZWTHD5oZzmyVSqHb7fSQhjqDFEHuQ5l+tpxgU=;
        b=5a6/xtUzzULUAAnZXnh5tgjR9u9gIQe5treYEsBtrlf80B1gBTQ5mbuCl+aLqv/TnO
         oSD6Z3aoJVbA5CSfXy5g6I+gDCkSdyB0p1SnxVu3BD3x3kQFpvPdsvBnD47lz5192zRg
         RmP91NRfht38Z5knATt3btrv8lVBUohEoWCtg4c+7TgGExxIunjjudJJpqjLhCoJ1kKd
         APeKKLEKmDUnGMJb2oluHluX+KvYNY4+8IRpWkQoMEcgMZbXMonE1It6mVJWN/Qnze4+
         iwI6dNaXKGy4Kxm+zpZKKeHgR0EZanaw4hs9b2IHjvt7lTiWacIUulFXwOfGDODfdB7J
         906w==
X-Gm-Message-State: AOAM533b8cjbDSmLuq8I4to/ON5XyihBjDbqLR3JiFvpf0pSRVj2muns
        l6CYfXV1IaCwhG5FmfFukOs=
X-Google-Smtp-Source: ABdhPJxKQT60ga1pohZzTmO0cfaaLEHfAd6aw/6i9T2G88YrYgMtmb1JCuKx0HiYXoLpLpRRScgqKA==
X-Received: by 2002:a02:cf39:: with SMTP id s25mr19890147jar.17.1641231278922;
        Mon, 03 Jan 2022 09:34:38 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id n2sm23411020ioc.0.2022.01.03.09.34.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 09:34:38 -0800 (PST)
Message-ID: <c67d22c7-2f1b-b619-b14e-2f5076b92a15@gmail.com>
Date:   Mon, 3 Jan 2022 10:34:37 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.4.1
Subject: Re: [PATCH v5 net-next 2/3] icmp: ICMPV6: Examine invoking packet for
 Segment Route Headers.
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
References: <20220103171132.93456-1-andrew@lunn.ch>
 <20220103171132.93456-3-andrew@lunn.ch>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220103171132.93456-3-andrew@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/3/22 10:11 AM, Andrew Lunn wrote:
> RFC8754 says:
> 
> ICMP error packets generated within the SR domain are sent to source
> nodes within the SR domain.  The invoking packet in the ICMP error
> message may contain an SRH.  Since the destination address of a packet
> with an SRH changes as each segment is processed, it may not be the
> destination used by the socket or application that generated the
> invoking packet.
> 
> For the source of an invoking packet to process the ICMP error
> message, the ultimate destination address of the IPv6 header may be
> required.  The following logic is used to determine the destination
> address for use by protocol-error handlers.
> 
> *  Walk all extension headers of the invoking IPv6 packet to the
>    routing extension header preceding the upper-layer header.
> 
>    -  If routing header is type 4 Segment Routing Header (SRH)
> 
>       o  The SID at Segment List[0] may be used as the destination
>          address of the invoking packet.
> 
> Mangle the skb so the network header points to the invoking packet
> inside the ICMP packet. The seg6 helpers can then be used on the skb
> to find any segment routing headers. If found, mark this fact in the
> IPv6 control block of the skb, and store the offset into the packet of
> the SRH. Then restore the skb back to its old state.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> ---
>  include/linux/ipv6.h |  2 ++
>  include/net/seg6.h   |  1 +
>  net/ipv6/icmp.c      |  6 +++++-
>  net/ipv6/seg6.c      | 30 ++++++++++++++++++++++++++++++
>  4 files changed, 38 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


