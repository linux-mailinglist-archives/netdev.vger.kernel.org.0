Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D42E42D0D3
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 05:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhJNDP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 23:15:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhJNDP4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 23:15:56 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7B1C061570;
        Wed, 13 Oct 2021 20:13:42 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id o204so6580534oih.13;
        Wed, 13 Oct 2021 20:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KCSZhhWp0i+Niz+/La5nLeCvEv7X4TLoYOZh5lxRCEw=;
        b=S8O40buBJOLzxwiKKVKojkxow0VR/06e9TlkOZAcJ8DlkkBYXQAA8gwBSntWB/RWfU
         /H6evhGL/PLSICM5z/9ltxMDrGWsH8ioh4cBOAIujc1uDj8wzzxu7gvCUaodihv2vqHO
         qxDCvG+H/C7mpv1z3cx+J6fOSt0q7/YVU4r9X4E1VJXV+PojX/ti9dgY1zqrM/JAHnn7
         /QcbJLhx9JJTC3sDuhrSrlLm8n5G2msNTCrT5Tvpg2KMPOb0I8Q2HClNL6LWEF0bSGst
         GTA09LwVkCSgFMhOiPzOjYYEBy8KIKmyJeAJJ7D4rrrhE6+TUnj4C02Hj2HvcsNTpy9v
         /udA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KCSZhhWp0i+Niz+/La5nLeCvEv7X4TLoYOZh5lxRCEw=;
        b=ksrevD6I3PZaJ5V3LRFVwSVOjhjWeXpOt4xVQ1dPKpz73IispqjrJ4JoNxVn9E9AtO
         f4H5cVjQdnSsfIle5PP3BYCctyqBrcLJLVQVOHwxJKRfmNaksX8M4K/Ppa7MLIt0gSgz
         FDhi0rUcvc7Dca1OyPOhHWoAVNne4MyH8+vkWWJnjPM5f81tFLPIeFgwlsEAfVS+pR+z
         qIcOiyJ7RO+pg1ui11KLVBP9KWvr2xHRnbffkeIamY9P4rkTgujt7UcY87EroY6iZoc9
         8q/1loU5BCRUPWTfrQUaj53uq6Y0UgUar+TSaPWQlWikDT7XM7PliKMLvdC9dyCyPk7R
         WCHA==
X-Gm-Message-State: AOAM530Vwq8shVp6EAfmEhrk1ayazskNcfeEHAS3RSXwKTRkKvrGaEUq
        Pn79pRVcR8sJqLWVNgOUJfLe5MFBeYxHZw==
X-Google-Smtp-Source: ABdhPJxZF32y42kJJT1/o20X5MJzOu2upxB2aQ7G0yHzVtIQzzDT+P5X0mEsir7eRRziDhRBcvjuJA==
X-Received: by 2002:aca:3855:: with SMTP id f82mr7153440oia.112.1634181222008;
        Wed, 13 Oct 2021 20:13:42 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id h91sm310350otb.38.2021.10.13.20.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 20:13:41 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] net, neigh: Use NLA_POLICY_MASK helper for
 NDA_FLAGS_EXT attribute
To:     Daniel Borkmann <daniel@iogearbox.net>, davem@davemloft.net,
        kuba@kernel.org
Cc:     roopa@nvidia.com, dsahern@kernel.org, m@lambda.lt,
        john.fastabend@gmail.com, netdev@vger.kernel.org,
        bpf@vger.kernel.org
References: <20211013132140.11143-1-daniel@iogearbox.net>
 <20211013132140.11143-3-daniel@iogearbox.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8be43259-1fc1-2c62-3cd1-100bde6ff702@gmail.com>
Date:   Wed, 13 Oct 2021 21:13:40 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211013132140.11143-3-daniel@iogearbox.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 7:21 AM, Daniel Borkmann wrote:
> Instead of open-coding a check for invalid bits in NTF_EXT_MASK, we can just
> use the NLA_POLICY_MASK() helper instead, and simplify NDA_FLAGS_EXT sanity
> check this way.
> 
> Suggested-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
> ---
>  net/core/neighbour.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 
> diff --git a/net/core/neighbour.c b/net/core/neighbour.c
> index 4fc601f9cd06..922b9ed0fe76 100644
> --- a/net/core/neighbour.c
> +++ b/net/core/neighbour.c
> @@ -1834,7 +1834,7 @@ const struct nla_policy nda_policy[NDA_MAX+1] = {
>  	[NDA_MASTER]		= { .type = NLA_U32 },
>  	[NDA_PROTOCOL]		= { .type = NLA_U8 },
>  	[NDA_NH_ID]		= { .type = NLA_U32 },
> -	[NDA_FLAGS_EXT]		= { .type = NLA_U32 },
> +	[NDA_FLAGS_EXT]		= NLA_POLICY_MASK(NLA_U32, NTF_EXT_MASK),
>  	[NDA_FDB_EXT_ATTRS]	= { .type = NLA_NESTED },
>  };
>  
> @@ -1936,10 +1936,6 @@ static int neigh_add(struct sk_buff *skb, struct nlmsghdr *nlh,
>  	if (tb[NDA_FLAGS_EXT]) {
>  		u32 ext = nla_get_u32(tb[NDA_FLAGS_EXT]);
>  
> -		if (ext & ~NTF_EXT_MASK) {
> -			NL_SET_ERR_MSG(extack, "Invalid extended flags");
> -			goto out;
> -		}
>  		BUILD_BUG_ON(sizeof(neigh->flags) * BITS_PER_BYTE <
>  			     (sizeof(ndm->ndm_flags) * BITS_PER_BYTE +
>  			      hweight32(NTF_EXT_MASK)));
> 

I get that NLA_POLICY_MASK wants to standardize the logic, but the
generic extack message "reserved bit set" is less useful than the one here.
