Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 349C26EBA18
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 17:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjDVP5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 11:57:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbjDVP5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 11:57:20 -0400
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BA11FEB
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:57:18 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-329627dabfbso31283075ab.0
        for <netdev@vger.kernel.org>; Sat, 22 Apr 2023 08:57:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682179038; x=1684771038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SQXPUcdiszkXF5bOn7MqwFZjI2t9JyziyZXMeUYYLVQ=;
        b=YaP1wjUK8t6i0PoEmovOQ8N4Cg3yJwbKuqyEmJCI6bUFgKHxdSvUj5Dk67fhIPKuM1
         z1sEp4gx4Zcv7jr+WFANKBV1rDhiaKZTjKB2RROq6K1puPsqXtAaDuu3Q0GkMqFN2e4j
         lDOVZZs/xSoMGxaH6pvgIv36r+kjpe9Y15TsgK+XNWLWGTQRqo7CIfxEmTP2+jZ6PiN3
         dnbXK8NLUX4I6nHLsGe9Npgb3ZxPemLIIplCbOrQzqSln9gwNeRIoJu+WU6zHg1x84Vm
         e+DTXkFtKSeweILka3l4Y9AGHEvbk+nbPAbNLHMYV+iDbTGvZGsNDnZCwbVza1njmjvc
         2r+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682179038; x=1684771038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SQXPUcdiszkXF5bOn7MqwFZjI2t9JyziyZXMeUYYLVQ=;
        b=a5kJndK0qxe0qsGn17WG3D670dJUAvGWzzrpvHVjL/mvsyPF0b6rofzFm5pnnr6XJx
         vjG/bz8DZK/AEGtXKZm0fkpeLPqO3jYOf0sB4Ta9ZaaE0LTz+j47qBHqbWLPU6d3tMGH
         9C1/+LILGZm2uG9gi1/v0AlIR62ih4pZDastluPq8NrcZBAtuQD0CXAxCEgnFyeGJPDZ
         Zqa57O9TjZhjAE+UXIa8iNfCtAnas5dE5KaHnsp5cXrKd1oSUEAyW0SM3jVO6HaQ8atc
         blfqNH1CHetE2sWjGl9QVeBeFHK7WmVysuJ8WATOyg3D1vdMk7+k1wIH8apB/jzk72ox
         iutA==
X-Gm-Message-State: AAQBX9cijlKxmTyrr8JT/v0GvmXRfBeDXlvL+Mf5k/WF4HOEH6Ds7/+Q
        BngypG/9JzTHsj4X6gg+/oq20NFpjO0=
X-Google-Smtp-Source: AKy350buGZlre45MA4JQJDZZk52sjVpYsFnL9FazR/5nT90SPJWfgSjtbWOCuMKG/oLYKiGuvBIvyA==
X-Received: by 2002:a6b:f30c:0:b0:760:effd:c899 with SMTP id m12-20020a6bf30c000000b00760effdc899mr1724068ioh.5.1682179038068;
        Sat, 22 Apr 2023 08:57:18 -0700 (PDT)
Received: from ?IPV6:2601:284:8200:b700:41d2:b7bd:5855:d604? ([2601:284:8200:b700:41d2:b7bd:5855:d604])
        by smtp.googlemail.com with ESMTPSA id h13-20020a05660224cd00b0074c7db1470dsm1855032ioe.20.2023.04.22.08.57.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Apr 2023 08:57:17 -0700 (PDT)
Message-ID: <226bfa8b-afe1-179a-5763-376e80ebe038@gmail.com>
Date:   Sat, 22 Apr 2023 09:57:15 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.10.0
Subject: Re: [PATCH v3 net] netlink: Use copy_to_user() for optval in
 netlink_getsockopt().
To:     Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Patrick McHardy <kaber@trash.net>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Christophe Ricard <christophe-h.ricard@st.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org,
        Brad Spencer <bspencer@blackberry.com>
References: <20230421185255.94606-1-kuniyu@amazon.com>
Content-Language: en-US
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20230421185255.94606-1-kuniyu@amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/23 12:52 PM, Kuniyuki Iwashima wrote:
> diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
> index f365dfdd672d..9b6eb28e6e94 100644
> --- a/net/netlink/af_netlink.c
> +++ b/net/netlink/af_netlink.c
> @@ -1742,7 +1742,8 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
>  {
>  	struct sock *sk = sock->sk;
>  	struct netlink_sock *nlk = nlk_sk(sk);
> -	int len, val, err;
> +	unsigned int flag;
> +	int len, val;

len is not initialized here ...

>  
>  	if (level != SOL_NETLINK)
>  		return -ENOPROTOOPT;
> @@ -1754,39 +1755,17 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
>  
>  	switch (optname) {
>  	case NETLINK_PKTINFO:
> -		if (len < sizeof(int))
> -			return -EINVAL;
> -		len = sizeof(int);

you remove all of these ...

> -		val = nlk->flags & NETLINK_F_RECV_PKTINFO ? 1 : 0;
> -		if (put_user(len, optlen) ||
> -		    put_user(val, optval))
> -			return -EFAULT;
> -		err = 0;
> +		flag = NETLINK_F_RECV_PKTINFO;
>  		break;
>  	case NETLINK_BROADCAST_ERROR:
> -		if (len < sizeof(int))
> -			return -EINVAL;
> -		len = sizeof(int);
> -		val = nlk->flags & NETLINK_F_BROADCAST_SEND_ERROR ? 1 : 0;
> -		if (put_user(len, optlen) ||
> -		    put_user(val, optval))
> -			return -EFAULT;
> -		err = 0;
> +		flag = NETLINK_F_BROADCAST_SEND_ERROR;
>  		break;
>  	case NETLINK_NO_ENOBUFS:
> -		if (len < sizeof(int))
> -			return -EINVAL;
> -		len = sizeof(int);
> -		val = nlk->flags & NETLINK_F_RECV_NO_ENOBUFS ? 1 : 0;
> -		if (put_user(len, optlen) ||
> -		    put_user(val, optval))
> -			return -EFAULT;
> -		err = 0;
> +		flag = NETLINK_F_RECV_NO_ENOBUFS;
>  		break;
>  	case NETLINK_LIST_MEMBERSHIPS: {
> -		int pos, idx, shift;
> +		int pos, idx, shift, err = 0;
>  
> -		err = 0;
>  		netlink_lock_table();
>  		for (pos = 0; pos * 8 < nlk->ngroups; pos += sizeof(u32)) {
>  			if (len - pos < sizeof(u32))
> @@ -1803,40 +1782,32 @@ static int netlink_getsockopt(struct socket *sock, int level, int optname,
>  		if (put_user(ALIGN(nlk->ngroups / 8, sizeof(u32)), optlen))
>  			err = -EFAULT;
>  		netlink_unlock_table();
> -		break;
> +		return err;
>  	}
>  	case NETLINK_CAP_ACK:
> -		if (len < sizeof(int))
> -			return -EINVAL;
> -		len = sizeof(int);
> -		val = nlk->flags & NETLINK_F_CAP_ACK ? 1 : 0;
> -		if (put_user(len, optlen) ||
> -		    put_user(val, optval))
> -			return -EFAULT;
> -		err = 0;
> +		flag = NETLINK_F_CAP_ACK;
>  		break;
>  	case NETLINK_EXT_ACK:
> -		if (len < sizeof(int))
> -			return -EINVAL;
> -		len = sizeof(int);
> -		val = nlk->flags & NETLINK_F_EXT_ACK ? 1 : 0;
> -		if (put_user(len, optlen) || put_user(val, optval))
> -			return -EFAULT;
> -		err = 0;
> +		flag = NETLINK_F_EXT_ACK;
>  		break;
>  	case NETLINK_GET_STRICT_CHK:
> -		if (len < sizeof(int))
> -			return -EINVAL;
> -		len = sizeof(int);
> -		val = nlk->flags & NETLINK_F_STRICT_CHK ? 1 : 0;
> -		if (put_user(len, optlen) || put_user(val, optval))
> -			return -EFAULT;
> -		err = 0;
> +		flag = NETLINK_F_STRICT_CHK;
>  		break;
>  	default:
> -		err = -ENOPROTOOPT;
> +		return -ENOPROTOOPT;
>  	}
> -	return err;
> +
> +	if (len < sizeof(int))

and then check len here.

> +		return -EINVAL;

seems like this chunk (len < sizeof(int)) is not needed.

> +
> +	len = sizeof(int);
> +	val = nlk->flags & flag ? 1 : 0;
> +
> +	if (put_user(len, optlen) ||
> +	    copy_to_user(optval, &val, len))
> +		return -EFAULT;
> +
> +	return 0;
>  }
>  
>  static void netlink_cmsg_recv_pktinfo(struct msghdr *msg, struct sk_buff *skb)

