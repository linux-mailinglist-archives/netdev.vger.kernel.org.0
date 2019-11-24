Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED1D10814D
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 01:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbfKXA5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 19:57:07 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45741 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXA5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 19:57:06 -0500
Received: by mail-pg1-f195.google.com with SMTP id k1so5255537pgg.12
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 16:57:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=hZ2QrHvkaktJjibTV6y1ix+OuKjZbPgqrdrVsaJAUEs=;
        b=AYt5LgOwb2iXHi1DGyGHMRa8FldnyRw/4h3pmNmXvpKciHd9wl7LiB0NEqOHQh232n
         bJg4B3k3qARqIIKBTwIvovKTSccjdQppxJRgS0ywHf0es170QW74rEJYwLiyrvAka6Rx
         SlwKUArXFPetzLPs8r3nIpv8iQpWYmDRPHfaNW2fD7oc1uFZrawX5YXNB457oN1D9IxP
         s321yXPW01gsMFOgXICGmck2phHttk5SCOVwgSugKpoEHZqLRopQCMyxlKm4CVtqWymk
         dyrGVuZ8TbPV63SvLkoOqeKH2ysr/a8vaxPU1Bfyy61P3bL5dXRO76mxzGjF+3sW743s
         ucIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=hZ2QrHvkaktJjibTV6y1ix+OuKjZbPgqrdrVsaJAUEs=;
        b=Sguguu97H87oqWyPZ2h4HIzdmYiN1r4hZrirFM5wpbjEBz5AmnSCJoYzH6TLCBo4am
         UVDtQj8PvHEPj9pMzd3GcCb4zzT5c1ydc/gkuG/eju8O98v7OaHHtZ1PZqHxrHlTmVXd
         LBz5ut4IoB/ybJWUUA6GeIK2GdCpO2RyVLBWlSYKZ55xqs+CZGA5A3auZzZnkTX6cnfV
         FaQG95fgUk5LhCcDfwDPdEIzIvaKKp5++O1r88dDr0/etlUBZmqiXX8vNzICMi6c+32Q
         cKrXxM1d8eCDPrOUH4swC+9cdwD5y59t4iN6UNpsJlJSn22Ukdowj5zPlRLO2FNbFJcu
         M1DA==
X-Gm-Message-State: APjAAAXAOF0tdJxcDYWO9ikiAd44Z6guEOEzugis6ZR/kwWcrrRcGwwB
        BaCUxjwXcOf1hCzoouq7ogGuvQ==
X-Google-Smtp-Source: APXvYqxo+E2TE+V7/dv+q2TKlYEZe2MrAHBBXsqM+BSjGvZ483AVaTaN9AQRTYj6mNpTcyfpqHSyoA==
X-Received: by 2002:a63:1360:: with SMTP id 32mr23480365pgt.3.1574557025678;
        Sat, 23 Nov 2019 16:57:05 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id s66sm2970516pfb.38.2019.11.23.16.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 16:57:05 -0800 (PST)
Date:   Sat, 23 Nov 2019 16:56:55 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH V2 net-next 1/6] netlink: Convert extack msg to a
 formattable buffer
Message-ID: <20191123165655.5a9b8877@cakuba.netronome.com>
In-Reply-To: <20191122224126.24847-2-saeedm@mellanox.com>
References: <20191122224126.24847-1-saeedm@mellanox.com>
        <20191122224126.24847-2-saeedm@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 22:41:47 +0000, Saeed Mahameed wrote:
> Before this patch the extack msg had to be a const char and didn't leave
> much room for developers to report formattable and flexible messages.
> 
> All current usages are oneliner messages, hence, a buffer of size 128B
> should be sufficient to replace the const char pointer.
> 
> This will allow future usages to provide formattable messages and more
> flexible error reporting, without any impact on current users.
> 
> Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

Let's CC DSA and Johannes on this one

> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
> index 205fa7b1f07a..de9004da0288 100644
> --- a/include/linux/netlink.h
> +++ b/include/linux/netlink.h
> @@ -62,6 +62,7 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
>  
>  /* this can be increased when necessary - don't expose to userland */
>  #define NETLINK_MAX_COOKIE_LEN	20
> +#define NL_EXTACK_MAX_MSG_SZ	128
>  
>  /**
>   * struct netlink_ext_ack - netlink extended ACK report struct
> @@ -72,40 +73,36 @@ netlink_kernel_create(struct net *net, int unit, struct netlink_kernel_cfg *cfg)
>   * @cookie_len: actual cookie data length
>   */
>  struct netlink_ext_ack {
> -	const char *_msg;
> +	char _msg[NL_EXTACK_MAX_MSG_SZ];
>  	const struct nlattr *bad_attr;
>  	u8 cookie[NETLINK_MAX_COOKIE_LEN];
>  	u8 cookie_len;
>  };
>  
> -/* Always use this macro, this allows later putting the
> - * message into a separate section or such for things
> - * like translation or listing all possible messages.
> - * Currently string formatting is not supported (due
> - * to the lack of an output buffer.)
> - */
> -#define NL_SET_ERR_MSG(extack, msg) do {		\
> -	static const char __msg[] = msg;		\
> +#define NL_MSG_FMT(extack, fmt, ...) \
> +	WARN_ON(snprintf(extack->_msg, NL_EXTACK_MAX_MSG_SZ, fmt, ## __VA_ARGS__) \
> +		>= NL_EXTACK_MAX_MSG_SZ)

I'd personally appreciate a word of analysis and reassurance in the
commit message that this snprintf + WARN_ON inlined in every location
where extack is used won't bloat the kernel :S

One could easily imagine a solution which would continue to carry the
static strings via a pointer without the unnecessary roundtrip thru
snprintf().

> +#define NL_SET_ERR_MSG(extack, fmt, ...) do {		\
>  	struct netlink_ext_ack *__extack = (extack);	\
>  							\
>  	if (__extack)					\
> -		__extack->_msg = __msg;			\
> +		NL_MSG_FMT(__extack, fmt, ## __VA_ARGS__); \
>  } while (0)
>  
> -#define NL_SET_ERR_MSG_MOD(extack, msg)			\
> -	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " msg)
> +#define NL_SET_ERR_MSG_MOD(extack, fmt, ...)			\
> +	NL_SET_ERR_MSG((extack), KBUILD_MODNAME ": " fmt, ## __VA_ARGS__)
>  
>  #define NL_SET_BAD_ATTR(extack, attr) do {		\
>  	if ((extack))					\
>  		(extack)->bad_attr = (attr);		\
>  } while (0)
>  
> -#define NL_SET_ERR_MSG_ATTR(extack, attr, msg) do {	\
> -	static const char __msg[] = msg;		\
> +#define NL_SET_ERR_MSG_ATTR(extack, attr, fmt, ...) do {	\
>  	struct netlink_ext_ack *__extack = (extack);	\
>  							\
>  	if (__extack) {					\
> -		__extack->_msg = __msg;			\
> +		NL_MSG_FMT(__extack, fmt, ## __VA_ARGS__); \
>  		__extack->bad_attr = (attr);		\
>  	}						\
>  } while (0)
> diff --git a/lib/nlattr.c b/lib/nlattr.c
> index cace9b307781..2ce1d6b68ce8 100644
> --- a/lib/nlattr.c
> +++ b/lib/nlattr.c
> @@ -208,7 +208,7 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
>  	case NLA_REJECT:
>  		if (extack && pt->validation_data) {
>  			NL_SET_BAD_ATTR(extack, nla);
> -			extack->_msg = pt->validation_data;
> +			NL_MSG_FMT(extack, pt->validation_data);
>  			return -EINVAL;
>  		}
>  		err = -EINVAL;

