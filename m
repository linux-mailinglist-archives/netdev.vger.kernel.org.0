Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCD323E3ED
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 00:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgHFWVe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 18:21:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgHFWVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 18:21:32 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54080C061574;
        Thu,  6 Aug 2020 15:21:32 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id p1so111079pls.4;
        Thu, 06 Aug 2020 15:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t1TN4T3jQ2jrlk3a/d7SaKfk2DJyftZUv6bXnlt6NPQ=;
        b=GyumodkGmYKsGSwVnzxjXGz3Hc6dDp/7EX3r4spkycDyPVNN0ciFP2qEtF0XPhrBf4
         +cCI0OWrH6x101NHuYUTOaXPwuCecyhxfEvjJRna72hDnNI+bib+8AzwceW3eJdE75Gn
         SeIJKEi14my/hEJw+qU/KCE5RSHazXH9KHIfKLNltLm7ADcruE5/tGFOBJjd/g0Mnrl5
         TD9+5yjblEpGaVz4M1LHrXLmcdWRpP5c2NV1JaW3i6df06bY03MlPUl3EghFXAFM5iLk
         Ox9KU5vu5QYQH83zkF+ICm8Q2r+16LLLSd84hY8z6dVmhZCgoIg7vDd5Gd8rg9nvzxvN
         9EXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t1TN4T3jQ2jrlk3a/d7SaKfk2DJyftZUv6bXnlt6NPQ=;
        b=e1lzyzb0IUfIRzudWXCJ1cnSbrZG3OU8EoVQ0p+kJDkZ1tnLXS6o966fc2KdC6EHeL
         3SrIF0a5mXVw76vBuseFHDBVjkkqkjlSiZ4ovEVfQAjHNwieeA9kQTFnWW2rC5ZbPf9O
         XCVz7HUemkpVnapitCxqsMEN6h+Q28m+bBbKFOppxvOEkVHfUzGS1ldj+fNmo5m0qPl1
         ED2axOJ1D3LUxfVoNB0CC1/auI0H9efPJaH6IlviqbYNd5RQTwLOmmWz2ftkLDDCIrhJ
         Wdyw2sb/kvUexW2wviff3HtcudiqYhWO/eNEvVHcZJMxGZcVkKXQc7LPLka0fe1Ye8m0
         FC6w==
X-Gm-Message-State: AOAM533QHJUjqnXMz8lHoCE9mfaVnnvTe76eDAuB5RQDhG7tKwWbhiP6
        q6J7leABOdw2O3ozloO5s2k=
X-Google-Smtp-Source: ABdhPJwdY4ryrXf97t2P6yPCseaEpoaitTdHlZtd60UHAYlnINemi0RFvJHHjsz9ZaSHJyy7n+NjVw==
X-Received: by 2002:a17:902:45:: with SMTP id 63mr9766294pla.179.1596752491350;
        Thu, 06 Aug 2020 15:21:31 -0700 (PDT)
Received: from [10.1.10.11] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id w82sm9912017pff.7.2020.08.06.15.21.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 15:21:30 -0700 (PDT)
Subject: Re: [PATCH 25/26] net: pass a sockptr_t into ->setsockopt
To:     Christoph Hellwig <hch@lst.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-sctp@vger.kernel.org, linux-hams@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, bridge@lists.linux-foundation.org,
        linux-can@vger.kernel.org, dccp@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net,
        linux-wpan@vger.kernel.org, linux-s390@vger.kernel.org,
        mptcp@lists.01.org, lvs-devel@vger.kernel.org,
        rds-devel@oss.oracle.com, linux-afs@lists.infradead.org,
        tipc-discussion@lists.sourceforge.net, linux-x25@vger.kernel.org,
        Stefan Schmidt <stefan@datenfreihafen.org>
References: <20200723060908.50081-1-hch@lst.de>
 <20200723060908.50081-26-hch@lst.de>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <6357942b-0b6e-1901-7dce-e308c9fac347@gmail.com>
Date:   Thu, 6 Aug 2020 15:21:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200723060908.50081-26-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/22/20 11:09 PM, Christoph Hellwig wrote:
> Rework the remaining setsockopt code to pass a sockptr_t instead of a
> plain user pointer.  This removes the last remaining set_fs(KERNEL_DS)
> outside of architecture specific code.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Acked-by: Stefan Schmidt <stefan@datenfreihafen.org> [ieee802154]
> ---


...

> diff --git a/net/ipv6/raw.c b/net/ipv6/raw.c
> index 594e01ad670aa6..874f01cd7aec42 100644
> --- a/net/ipv6/raw.c
> +++ b/net/ipv6/raw.c
> @@ -972,13 +972,13 @@ static int rawv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  }
>  

...

>  static int do_rawv6_setsockopt(struct sock *sk, int level, int optname,
> -			    char __user *optval, unsigned int optlen)
> +			       sockptr_t optval, unsigned int optlen)
>  {
>  	struct raw6_sock *rp = raw6_sk(sk);
>  	int val;
>  
> -	if (get_user(val, (int __user *)optval))
> +	if (copy_from_sockptr(&val, optval, sizeof(val)))
>  		return -EFAULT;
>  

converting get_user(...)   to  copy_from_sockptr(...) really assumed the optlen
has been validated to be >= sizeof(int) earlier.

Which is not always the case, for example here.

User application can fool us passing optlen=0, and a user pointer of exactly TASK_SIZE-1


