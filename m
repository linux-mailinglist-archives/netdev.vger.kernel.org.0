Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2ED26DDB8A
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 15:02:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbjDKNCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 09:02:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjDKNC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 09:02:26 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21F195273;
        Tue, 11 Apr 2023 06:01:58 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id ud9so19925170ejc.7;
        Tue, 11 Apr 2023 06:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681218079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gjfKHiTAelHKNBBiZ32rOlQe2iBqnhIwDJ/F7afqrdI=;
        b=RNXfuUX/MwoaEzkPLZbxur959pNK0xSVw/gPGRsMzx6f52TyDeq92xgmqeZGW/nvtM
         KNMoR2k9ilXJPSnVTFgSxEJgFUgkSCAd8EZzm44kQy3zfh6ohn+zXfrx1YljwsSMkmId
         oObACbJRFfm9kWqRd8B2d4G7u9qe2xCYuLQXkBZLXEPDbfyDaVaLQGqAkESsIouqUrYM
         8qbdI1YKDZOpImcKXHolp8tvRLZ1nXQatw6QwCb09tcc3ap+Qtd/WzWzoSNU0JyfMYKD
         Yj3kqpuPdCtVXBBYWkRCVAXGrls1X7xPI1zoyEoYitNQ12eI2W10WgMIapg5e10ps271
         iZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681218079;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjfKHiTAelHKNBBiZ32rOlQe2iBqnhIwDJ/F7afqrdI=;
        b=10YsDIhzHRkuVFaxDNaR8ncbX/KJAfVxTAt1JSU/fdIf/FRuiUZ3qVJsBZ/GgshIGK
         JqAHHhjHenQztPkLl1vNhRmXAOXIPkuTSV3N/VrGRr7QEz8Wt8F1A3viNpk3hYXYlZHU
         /Z7qm/mgPcnMg6DCasI/UEnHrG6gc+S5ybyopxcPEMYqmWKp1vqZ50aDerdXFKFUKWHu
         uNVRiElAx8TaGSHswWRc+gVSpCvzeTEz7FOdRutuaCWs4F1cfGmn5pRbQ3ZnsI6d1/IV
         uE38gsxmL0+zDzwwG8tqnAB9+kesJLW3HPcgqVzuwe8CNELdWfHWW/Uvsy9rN5SjFaE6
         6bLg==
X-Gm-Message-State: AAQBX9dioctkGZT+guGa0umb3sQXwL8sxAykBFU1dRe/zD7mVBjwMPFT
        OTaduf89d3bcbeEch6wyc2w=
X-Google-Smtp-Source: AKy350aW0nWZOzSh162Acl+sBUA3ly4jFNnSh2K8bVA/yYWF+mvJPnzOEjXTZ9+bw0enj2qBSQ+9Kw==
X-Received: by 2002:a17:906:17c9:b0:92f:7c42:8637 with SMTP id u9-20020a17090617c900b0092f7c428637mr12650457eje.30.1681218079336;
        Tue, 11 Apr 2023 06:01:19 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::26ef? ([2620:10d:c092:600::2:ddc3])
        by smtp.gmail.com with ESMTPSA id oz19-20020a1709077d9300b00947ae870e78sm6084005ejc.203.2023.04.11.06.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Apr 2023 06:01:19 -0700 (PDT)
Message-ID: <75efd3a5-dc32-eb06-ed50-8ca0688747e0@gmail.com>
Date:   Tue, 11 Apr 2023 13:54:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [RFC PATCH 2/4] net: add uring_cmd callback to UDP
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
        netdev@vger.kernel.org, kuba@kernel.org, axboe@kernel.dk
Cc:     leit@fb.com, edumazet@google.com, pabeni@redhat.com,
        davem@davemloft.net, dccp@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, dsahern@kernel.org,
        willemdebruijn.kernel@gmail.com, matthieu.baerts@tessares.net,
        marcelo.leitner@gmail.com
References: <20230406144330.1932798-1-leitao@debian.org>
 <20230406144330.1932798-3-leitao@debian.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230406144330.1932798-3-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/6/23 15:43, Breno Leitao wrote:
> This is the implementation of uring_cmd for the udp protocol. It
> basically encompasses SOCKET_URING_OP_SIOCOUTQ and
> SOCKET_URING_OP_SIOCINQ, which is similar to the SIOCOUTQ and SIOCINQ
> ioctls.
> 
> The return value is exactly the same as the regular ioctl (udp_ioctl()).
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> ---
>   include/net/udp.h        |  2 ++
>   include/uapi/linux/net.h |  5 +++++
>   net/ipv4/udp.c           | 16 ++++++++++++++++
>   3 files changed, 23 insertions(+)
> 
> diff --git a/include/net/udp.h b/include/net/udp.h
> index de4b528522bb..c0e829dacc2f 100644
> --- a/include/net/udp.h
> +++ b/include/net/udp.h
> @@ -283,6 +283,8 @@ void udp_flush_pending_frames(struct sock *sk);
>   int udp_cmsg_send(struct sock *sk, struct msghdr *msg, u16 *gso_size);
>   void udp4_hwcsum(struct sk_buff *skb, __be32 src, __be32 dst);
>   int udp_rcv(struct sk_buff *skb);
> +int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
> +		  unsigned int issue_flags);
>   int udp_ioctl(struct sock *sk, int cmd, unsigned long arg);
>   int udp_init_sock(struct sock *sk);
>   int udp_pre_connect(struct sock *sk, struct sockaddr *uaddr, int addr_len);
> diff --git a/include/uapi/linux/net.h b/include/uapi/linux/net.h
> index 4dabec6bd957..dd8e7ced7d24 100644
> --- a/include/uapi/linux/net.h
> +++ b/include/uapi/linux/net.h
> @@ -55,4 +55,9 @@ typedef enum {
>   
>   #define __SO_ACCEPTCON	(1 << 16)	/* performed a listen		*/
>   
> +enum {
> +	SOCKET_URING_OP_SIOCINQ		= 0,
> +	SOCKET_URING_OP_SIOCOUTQ,
> +};
> +
>   #endif /* _UAPI_LINUX_NET_H */
> diff --git a/net/ipv4/udp.c b/net/ipv4/udp.c
> index c605d171eb2d..d6d60600831b 100644
> --- a/net/ipv4/udp.c
> +++ b/net/ipv4/udp.c
> @@ -113,6 +113,7 @@
>   #include <net/sock_reuseport.h>
>   #include <net/addrconf.h>
>   #include <net/udp_tunnel.h>
> +#include <linux/io_uring.h>
>   #if IS_ENABLED(CONFIG_IPV6)
>   #include <net/ipv6_stubs.h>
>   #endif
> @@ -1711,6 +1712,20 @@ static int first_packet_length(struct sock *sk)
>   	return res;
>   }
>   
> +int udp_uring_cmd(struct sock *sk, struct io_uring_cmd *cmd,
> +		  unsigned int issue_flags)
> +{
> +	switch (cmd->sqe->cmd_op) {

Not particularly a problem of this series, but what bothers
me is the quite unfortunate placement of cmd_op in SQE.

struct io_uring_sqe {
	...
	union {
		__u64	d1;
		struct {
			__u32	cmd_op;
			__u32	__pad1;
		};
	};
	__u64	d2;
	__u32	d3;
	...
};

I'd much prefer it like this:

struct io_uring_sqe {
	...
	__u64 d1[2];
	__u32 cmd_op;
	...
};


We can't change it for NVMe, but at least new commands can have
a better layout. It's read in the generic cmd path, i.e.
io_uring_cmd_prep(), so will need some refactoring to make
the placement cmd specific.

-- 
Pavel Begunkov
