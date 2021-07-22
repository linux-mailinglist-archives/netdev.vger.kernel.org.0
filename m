Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2567D3D1C07
	for <lists+netdev@lfdr.de>; Thu, 22 Jul 2021 04:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhGVCGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Jul 2021 22:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbhGVCGx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Jul 2021 22:06:53 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB6E9C061575
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 19:47:28 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id c197so5066195oib.11
        for <netdev@vger.kernel.org>; Wed, 21 Jul 2021 19:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aXw9qTxwP+SnkbLHW21pIcAPQktMpjTpdE5RdL4BevQ=;
        b=YQqk0qDRZsBK1JOxUJhnXo3iSaM59evSXPdFB5Py2DsxfSy4tm7gWWRf2dQfsNpXJR
         3pnovjpYWoBGMQCP/WSZKKdiQ1vYmBdWvFrl9WqychpF6WE1ohmtCNfkL+CejBybZ2z4
         j2Sl5DYPrUpFRMdwsa+dpKPRapdqv1AuHLL8MBgo3C5/wfE6IvTR2Zveuy1p3jkP2bKR
         ANUI9Mj0TIYPWxvC+2E3Ogs+EQ1bzHdLDNFMQhtaPt+b2Ck5eLT+VU8okoS8w3px1R2w
         WW8yWmYlDvybGt4N42P00zDJz45D8Nyl1SJF6UTTiAd9vbGLnxy+bayde6iZNSq5Z65j
         LDVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aXw9qTxwP+SnkbLHW21pIcAPQktMpjTpdE5RdL4BevQ=;
        b=HIgJrPqtXhXJiQOacXgPFph/X5P4P9Ue/faoPCC9VRgK85WHCNykNakylGM/zWW1YT
         1zXp43ayRLM3lZhhnYrQU4Tg1h1ZGVgxWVv38UlYibBRPO+304uf2DSfu+dQuiNMCmxG
         M/tQRH/FNjop1+FKZ55bQeOIi9tP39Oj4Q00ehnoJrwLc+vURhIzn9ibRJ8TQ9PEptbU
         KmDrCGZNp+iN/KOVTA13L5Bo/TFi2jaZ5sUmSLt7C5kTYOxQmWCS2zE+Pq5541E5RX9h
         N2ql+AvEBZCiifrFf0ZYmPmZq3yIqvCElgP4dB6d1w+ts/BPZHUqfiKN3egdCI2fpl7O
         9CSQ==
X-Gm-Message-State: AOAM531PCiqyd50mMQ/Aij5OZqcJSbqQPV2C4m2cbkhgNN0a51AG38Je
        6uGU0PlNvmV1vymIBPOVnss=
X-Google-Smtp-Source: ABdhPJzqjMuuP+bJn/f/6q9faMib6y+/4d5QnsExORrvch0cJsiBfwdxiERO6QnTb+8eaT9+QDxQrA==
X-Received: by 2002:aca:b903:: with SMTP id j3mr3095848oif.179.1626922048298;
        Wed, 21 Jul 2021 19:47:28 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id k7sm4628353otn.60.2021.07.21.19.47.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jul 2021 19:47:27 -0700 (PDT)
Subject: Re: [PATCH net-next v5 2/6] ipv6: ioam: Data plane support for
 Pre-allocated Trace
To:     Justin Iurman <justin.iurman@uliege.be>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, tom@herbertland.com
References: <20210720194301.23243-1-justin.iurman@uliege.be>
 <20210720194301.23243-3-justin.iurman@uliege.be>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3801e3ce-089a-2252-ebdf-558b43824459@gmail.com>
Date:   Wed, 21 Jul 2021 20:47:26 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210720194301.23243-3-justin.iurman@uliege.be>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/20/21 1:42 PM, Justin Iurman wrote:
> diff --git a/include/uapi/linux/in6.h b/include/uapi/linux/in6.h
> index 5ad396a57eb3..c4c53a9ab959 100644
> --- a/include/uapi/linux/in6.h
> +++ b/include/uapi/linux/in6.h
> @@ -145,6 +145,7 @@ struct in6_flowlabel_req {
>  #define IPV6_TLV_PADN		1
>  #define IPV6_TLV_ROUTERALERT	5
>  #define IPV6_TLV_CALIPSO	7	/* RFC 5570 */
> +#define IPV6_TLV_IOAM		49	/* TEMPORARY IANA allocation for IOAM */

why temporary and what is the risk the value changes between now and the
final version?

