Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0184F424B8C
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239554AbhJGBQg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230252AbhJGBQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 21:16:35 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEFCC061746;
        Wed,  6 Oct 2021 18:14:42 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l16-20020a9d6a90000000b0053b71f7dc83so5466454otq.7;
        Wed, 06 Oct 2021 18:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JCP3+/6KDb3OiE2F6/73DcdtnFzbR25XnFV46EjpVJg=;
        b=HYAadukXmKo/9+UeFo/Z4Dz9/HjxcEA/eTKaE4OjoaLxGIOvt3Tuzu55ThoyBaVeCO
         do7hy2LnOEyOEJShcDpV3i6k+j/FQ2yrzfJ4Yev+7BuUdl6jiZaQKdb7r2xpmIK8R2mq
         bi4TDfvApcaxEeS+CU2YOpaZ51X9maRF9ut1infVa5GLOI95i9x8RAUvjbvQYGyNZ6aq
         6SO+uMX/J6hqk5GZDBcbcYi+OzBAgRb0LKex5fTU11tCQi12rtZPoDblgej2sYu4nmm7
         8mbMc3Eyoqsb6wNAaQaJFszIbo5W4nLm76dYpAGURQqZibMdndsVXCWM9AuAsGaWpBbX
         rJAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JCP3+/6KDb3OiE2F6/73DcdtnFzbR25XnFV46EjpVJg=;
        b=qXNZYNeHyGYDFeFAr0X3hsM7oLBAwWdQMCLTSXdfpv60oqRzf9CYBdbYm3lrGEuT9q
         7vq7SeJvtZOQXnCko5zJl4N0twPFG8/Pklz81ReZ/aKGBnYzKSP9EScbU5eKh0kPC0nj
         r/pI3hkzL7cMZ0uXq4WwYH9wr85ubeOjU2sZlBB2e/uJ/iras7hBJHt+4h+c0geD8BLy
         WqXNk2ZHaIVD+7ai6e9KmCOox5prPMP0LoL/zL8dz74GiBRaap7ZSRnRBKdBeb/jAFwj
         W7iDVesjyHf4tkk1CU2gTn07hwff9atoNKEjrc9iP6J2C0aS5T1oRJ0a4CKgJJhYDv76
         GT8g==
X-Gm-Message-State: AOAM5315LDtJVHPSVNYBSUomLzqc9T6ild6AKOKe+SPViFvSlyxEz25G
        v7sk/qh0NPvgKOATXz46EqI8mtvkuMkI0w==
X-Google-Smtp-Source: ABdhPJxwDAOn6ouX6+DfbCt54B3l0fOxNuHYP3MjIPh+nw5gkur52sY9ijhWJpzrhzCU1VjkUG/IgQ==
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr1289599otj.191.1633569281949;
        Wed, 06 Oct 2021 18:14:41 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id p18sm4635010otk.7.2021.10.06.18.14.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 18:14:41 -0700 (PDT)
Subject: Re: [PATCH] tcp: md5: Fix overlap between vrf and non-vrf keys
To:     Leonard Crestez <cdleonard@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Yonghong Song <yhs@fb.com>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <209548b5-27d2-2059-f2e9-2148f5a0291b@gmail.com>
Date:   Wed, 6 Oct 2021 19:14:39 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <3d8387d499f053dba5cd9184c0f7b8445c4470c6.1633542093.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 11:48 AM, Leonard Crestez wrote:
> @@ -1103,11 +1116,11 @@ static struct tcp_md5sig_key *tcp_md5_do_lookup_exact(const struct sock *sk,
>  #endif
>  	hlist_for_each_entry_rcu(key, &md5sig->head, node,
>  				 lockdep_sock_is_held(sk)) {
>  		if (key->family != family)
>  			continue;
> -		if (key->l3index && key->l3index != l3index)
> +		if (key->l3index != l3index)

That seems like the bug fix there. The L3 reference needs to match for
new key and existing key. I think the same change is needed in
__tcp_md5_do_lookup.


>  			continue;
>  		if (!memcmp(&key->addr, addr, size) &&
>  		    key->prefixlen == prefixlen)
>  			return key;
>  	}
> 
> base-commit: 9cbfc51af026f5b721a1b36cf622ada591b3c5de
> 

