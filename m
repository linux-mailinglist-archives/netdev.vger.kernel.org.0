Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7D51D8E65
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 05:54:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728210AbgESDyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 23:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726724AbgESDyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 23:54:02 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AAB2C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 20:54:02 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id b6so13117730qkh.11
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 20:54:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jdAdQiSqC6E9/DnvU8XM55rRUljUrjeKNvvg0xSeMYc=;
        b=G6ZfX6QEOsYFB2xzVWxjjBuDKRHs8M4Ek9R7rFNofPSsFNFN0YPHGMoSf2Q1/lJTBc
         5oOJ+hHV2bYYVJakQL2pp4R+YcLVZrZ+6L158jWmuBDE/lWiqOXP3ygkdRBxZcGDSTZF
         cRxv/818/GOW3+mbxnVKgvUFp6ny0jMJO2hmWHWNVCsTRQCk48hJVeVkbA2H7ULg200W
         WEbN3TnSLPTMQ70hZX/vVMIqmGumQdvxJiLrR9HB5t+4FHFqrVSgkoqrjNjs2pbpiVWU
         W4gLzLa9NiIks8eJaNhBm4MV6rQDgvFVxz3j9Wl7hWZrPJ1ioaLMPoGby5yZjX7KBEXP
         072Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jdAdQiSqC6E9/DnvU8XM55rRUljUrjeKNvvg0xSeMYc=;
        b=ikn7rpomyLNyBPi0QcvOvX/cwDJvENRTLF3PJQJxopeuJ/wwk9RZNB7qYZ84LkzXVt
         RLhbAe/NTL5DrzQg31fgaLp3uu7uWmA4IUA+NSokVnhKBrDEFqzwiI+Umixe0VF937lx
         vCCFZ8Cusr8jMcI3v4Ll/TP92OdY2PJwK/uHJss6madcCB1DN+d3fNw3tEi58nZ8+kfE
         ftGUweeMTcudHkbEjCgeOQhKQMlSnIgQLi0iQSTz7/Py9r9Cb7mP/Ehi7QGqFfl0b6Yy
         dIVSRnqKBnj9hbR4LELJvXUvYL4FEd4pOsvFuupKFwYbu1z3LgPa5Y9lZAVG4ktmf4gf
         CJqA==
X-Gm-Message-State: AOAM533bPzbwUP/e9Gr+BWX/m50QLckPUiUYA7TCX6UxWyzOsLERYvwv
        b1W95vDOu/eZDxcgc4LO1qw=
X-Google-Smtp-Source: ABdhPJyG1sMPXZsMjGTXRdwVCvSgQE2blEow1W6vr0zQmctdoTkSB10ioZs5ugppdhG21D4xfyCSCw==
X-Received: by 2002:a05:620a:792:: with SMTP id 18mr17211163qka.181.1589860441680;
        Mon, 18 May 2020 20:54:01 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:c5f3:7fed:e95c:6b74? ([2601:282:803:7700:c5f3:7fed:e95c:6b74])
        by smtp.googlemail.com with ESMTPSA id l133sm9771800qke.105.2020.05.18.20.54.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 20:54:01 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] nexthop: support for fdb ecmp nexthops
To:     Roopa Prabhu <roopa@cumulusnetworks.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nikolay@cumulusnetworks.com,
        jiri@mellanox.com, idosch@mellanox.com, petrm@mellanox.com
References: <1589854474-26854-1-git-send-email-roopa@cumulusnetworks.com>
 <1589854474-26854-3-git-send-email-roopa@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4a103e6c-9b23-cbfc-b759-d2ff0c70668d@gmail.com>
Date:   Mon, 18 May 2020 21:53:59 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <1589854474-26854-3-git-send-email-roopa@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/18/20 8:14 PM, Roopa Prabhu wrote:

> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index b607ea6..37e4dba 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1771,6 +1771,7 @@ static struct neigh_table *neigh_find_table(int family)
>  }
>  
>  const struct nla_policy nda_policy[NDA_MAX+1] = {
> +	[NDA_UNSPEC]		= { .strict_start_type = NDA_NH_ID },
>  	[NDA_DST]		= { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
>  	[NDA_LLADDR]		= { .type = NLA_BINARY, .len = MAX_ADDR_LEN },
>  	[NDA_CACHEINFO]		= { .len = sizeof(struct nda_cacheinfo) },
> @@ -1781,6 +1782,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
>  	[NDA_IFINDEX]		= { .type = NLA_U32 },
>  	[NDA_MASTER]		= { .type = NLA_U32 },
>  	[NDA_PROTOCOL]		= { .type = NLA_U8 },
> +	[NDA_NH_ID]		= { .type = NLA_U32 },

I think you also need a checks where nda_policy is used to detect if
NDA_NH_ID is set. Since the neighbor code ignores the attribute it
should send back an error if set.

Otherwise looks ok to me.

Reviewed-by: David Ahern <dsahern@gmail.com>
