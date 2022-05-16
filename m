Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 941D6528519
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 15:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243750AbiEPNOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 09:14:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237369AbiEPNOa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 09:14:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 26A401EC5A
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1652706867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t3lctaNrBtVMkpYbjYsFBRjqmR6Zj0/iB9OndQ2l2RQ=;
        b=Sbr+6ZiN6wBFtCzOwIj+5Lml9q5aCO9GkpCtHIMdt1ZrHu/oWCc20LG8KVTbnQXzLVvXhY
        3toYbr4lT3Iea/+IiQptfr6sw14/TwcfJgLRBHRh0KMhW1pri8WRmHJP9iRLvX2XzYPO+N
        9m5Xv7BeQ3AOggMQK+4puGfUXr2oPig=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-315-gfKf9LYeMeGSA5MmBNClzw-1; Mon, 16 May 2022 09:14:25 -0400
X-MC-Unique: gfKf9LYeMeGSA5MmBNClzw-1
Received: by mail-wm1-f70.google.com with SMTP id l38-20020a05600c1d2600b00395cf292797so3583790wms.3
        for <netdev@vger.kernel.org>; Mon, 16 May 2022 06:14:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=t3lctaNrBtVMkpYbjYsFBRjqmR6Zj0/iB9OndQ2l2RQ=;
        b=wXULUcyc1f+NgqFWGBAXjIcih0/l/DATcw8MqsCIQb//XEWysrdxv7fKAkIxH0Z3+R
         W+b26tYnX4N2crdrvSURVxfywEgl6FiBnpiiu0OIPwQH5Y2jSrtEpQawDgjfeBWxEhco
         9xG3Jj88l97b8MTYGmg7BaKgksVrPfej418kEA7R5T/ZQUaKOA9CdFtEh7IJkoTKxGqu
         vcdnwFmZg75JytMCsofX4HeVJnV8iQtwPjaVpiwcRUxsrDeB+qHFwOFnzBsTTSFeTFPl
         v2el9kMkg424fSWMKnHJ7HUlTp9iHCSzIlsy9aDVnLcfgir8H/gyRA76yOwqEqsVWuVq
         dsMg==
X-Gm-Message-State: AOAM531NDfF6uQfbnjyPjwDdJulUSz162vWJ9B/mPITcPkkKWmFGeiP/
        piVORI1lYONf0j29Ry5OfLcMUXH3lriLAI92wEwSgaCR8xjiQA4xDzkaKvK3L0aSrzVU5FlEKWh
        RGbYTG6xZWtSkwa7b
X-Received: by 2002:adf:eacb:0:b0:20d:230:906 with SMTP id o11-20020adfeacb000000b0020d02300906mr7563070wrn.245.1652706864361;
        Mon, 16 May 2022 06:14:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxFI6gXt4bC663XUr9rT/BI3UPCcyDYX/mLi0lrUd3uM4RTBILVBdH8a5Eavbo/0XSfGWAJBg==
X-Received: by 2002:adf:eacb:0:b0:20d:230:906 with SMTP id o11-20020adfeacb000000b0020d02300906mr7563049wrn.245.1652706864169;
        Mon, 16 May 2022 06:14:24 -0700 (PDT)
Received: from gerbillo.redhat.com (146-241-112-184.dyn.eolo.it. [146.241.112.184])
        by smtp.gmail.com with ESMTPSA id x13-20020a7bc20d000000b0039429bfebebsm15025003wmi.3.2022.05.16.06.14.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 May 2022 06:14:23 -0700 (PDT)
Message-ID: <f0fb2ffbde15b2939ed76545b549bdcd33b92ae8.camel@redhat.com>
Subject: Re: [PATCH net-next v3 03/10] udp/ipv6: prioritise the ip6 path
 over ip4 checks
From:   Paolo Abeni <pabeni@redhat.com>
To:     Pavel Begunkov <asml.silence@gmail.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org
Date:   Mon, 16 May 2022 15:14:22 +0200
In-Reply-To: <50cca375d8730b5bf74b975d0fede64b1a3744c4.1652368648.git.asml.silence@gmail.com>
References: <cover.1652368648.git.asml.silence@gmail.com>
         <50cca375d8730b5bf74b975d0fede64b1a3744c4.1652368648.git.asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2022-05-13 at 16:26 +0100, Pavel Begunkov wrote:
> For AF_INET6 sockets we care the most about ipv6 but not ip4 mappings as
> it's requires some extra hops anyway. Take AF_INET6 case from the address
> parsing switch and add an explicit path for it. It removes some extra
> ifs from the path and removes the switch overhead.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  net/ipv6/udp.c | 37 +++++++++++++++++--------------------
>  1 file changed, 17 insertions(+), 20 deletions(-)
> 
> diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
> index 85bff1252f5c..e0b1bea998ce 100644
> --- a/net/ipv6/udp.c
> +++ b/net/ipv6/udp.c
> @@ -1360,30 +1360,27 @@ int udpv6_sendmsg(struct sock *sk, struct msghdr *msg, size_t len)
>  
>  	/* destination address check */
>  	if (sin6) {
> -		if (addr_len < offsetof(struct sockaddr, sa_data))
> -			return -EINVAL;
> +		if (addr_len < SIN6_LEN_RFC2133 || sin6->sin6_family != AF_INET6) {
> +			if (addr_len < offsetof(struct sockaddr, sa_data))
> +				return -EINVAL;

I think you can't access 'sin6->sin6_family' before validating the
socket address len, that is before doing:

if (addr_len < offsetof(struct sockaddr, sa_data))

Paolo

