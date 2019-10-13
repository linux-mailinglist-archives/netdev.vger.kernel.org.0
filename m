Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5D4D57E7
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 21:58:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729444AbfJMT6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 15:58:07 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:36308 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727492AbfJMT6H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 15:58:07 -0400
Received: by mail-pl1-f193.google.com with SMTP id j11so7040675plk.3
        for <netdev@vger.kernel.org>; Sun, 13 Oct 2019 12:58:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hW9sTxB7nn7/nzhoCeHQe5Z+i8VaQti+mCOFqSSTFDo=;
        b=kP53LKJFNuWiKkOOveZIqQTRSuQFEQZheXEgJVZnWyegA7agA4on2GrOkbpY8kvl9d
         ePdRmPd6QkVRS3Y5pBAQ5vI156+8ZFZtJQ5Luv3Ar0IJciyEfDnYIeiIQVWK3WyvMH+8
         ddvEg/e9nhVJfZW0jZMwHII7hOM2PnztMAS/53E26RY2OlBo7AuzGxGCYcU74lsvsV/k
         dg2NX2+oEpSea9AC/JDz3wtbUTie+t+s+lkD8lnfDGcO+sWPfLuVX4avQNjVDIAKg816
         0+B9EIL/lyqt0Xjm0czkQNNBqKxKwfq2ip4Upn9ZIeLOPr/W9vbpDX+hWr/4/9bG876B
         ikjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hW9sTxB7nn7/nzhoCeHQe5Z+i8VaQti+mCOFqSSTFDo=;
        b=ZF0Y72X5a2e6lOYkb9LmenYwZyiBFYWJwHnxTA29ZlNXCTDSWxkzh+nNcIq6wFXxk+
         Ca9OjD97ww+4QgjAFxX2G4+y0eRzzWArrG2lOoGQhltUdu6w5H6AhXz0dnhz/BlWH8Vj
         dwJIcsgan+MHAuvNFsEaoxCLf/7LVtm8iwz5VY1TO6nbX0P5ANQ8GejrgLJvYnOrPpkd
         P+Ftq8TopGxxqy+06ICBHIHnXow4fQL58FMcPiWHTMWyredQTYnu9ImDbmCiE77dI05h
         8EMVEUCDZcbh6x3IujKO9RqGVsrOVoc9yBtxv5oaVmoEMakyzC6RPyFZ8EJYam9dSjay
         UvZg==
X-Gm-Message-State: APjAAAVwiPrl2TR/Hi2hkoMdfu5B/JS783LVTw2iQulmOsHBfwv9XmuS
        oUCExuOGE5Hwqw9IB2IinoO7SqbD
X-Google-Smtp-Source: APXvYqxB7SN+SdKnHrYBMutoL4etzxwELiOD1cT2hwzQppZq+3W3KPRlqZZsxCIK5HknWcWClp9rvA==
X-Received: by 2002:a17:902:9347:: with SMTP id g7mr26604844plp.291.1570996686336;
        Sun, 13 Oct 2019 12:58:06 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-70.hsd1.ca.comcast.net. [73.241.150.70])
        by smtp.gmail.com with ESMTPSA id f13sm9574785pgr.6.2019.10.13.12.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Oct 2019 12:58:05 -0700 (PDT)
Subject: Re: [PATCH] net: core: skbuff: skb_checksum_setup() drop err
To:     Vito Caputo <vcaputo@pengaru.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20191013003053.tmdc3hs73ik3asxq@shells.gnugeneration.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <52dfe9f3-cc54-408d-6781-3bc0a86ebae8@gmail.com>
Date:   Sun, 13 Oct 2019 12:58:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191013003053.tmdc3hs73ik3asxq@shells.gnugeneration.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/12/19 5:30 PM, Vito Caputo wrote:
> Return directly from all switch cases, no point in storing in err.
> 
> Signed-off-by: Vito Caputo <vcaputo@pengaru.com>
> ---
>  net/core/skbuff.c | 15 +++------------
>  1 file changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index f5f904f46893..c59b68a413b5 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -4888,23 +4888,14 @@ static int skb_checksum_setup_ipv6(struct sk_buff *skb, bool recalculate)
>   */
>  int skb_checksum_setup(struct sk_buff *skb, bool recalculate)
>  {
> -	int err;
> -
>  	switch (skb->protocol) {
>  	case htons(ETH_P_IP):
> -		err = skb_checksum_setup_ipv4(skb, recalculate);
> -		break;
> -
> +		return skb_checksum_setup_ipv4(skb, recalculate);
>  	case htons(ETH_P_IPV6):
> -		err = skb_checksum_setup_ipv6(skb, recalculate);
> -		break;
> -
> +		return skb_checksum_setup_ipv6(skb, recalculate);
>  	default:
> -		err = -EPROTO;
> -		break;
> +		return -EPROTO;
>  	}
> -
> -	return err;
>  }
>  EXPORT_SYMBOL(skb_checksum_setup);


We prefer having a single return point in a function, if possible.

The err variable would make easier for debugging support,
if say a developer needs to trace this function.






