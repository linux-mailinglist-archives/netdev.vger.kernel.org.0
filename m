Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4E4141EDE
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727045AbgASPbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:31:36 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33779 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726860AbgASPbg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:31:36 -0500
Received: by mail-qt1-f193.google.com with SMTP id d5so25764829qto.0
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 07:31:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UcTI+TlXLyBcW5hP31A1SVUt3vTwZBGcuxRhGd8zG+0=;
        b=JgDVgp2BZf7AiqCs6wr0cE/24rwJYY+S7swfiymQ1/nx4cViDvSQJhzbQEddeQcLOv
         ZzW11TxVDQk4aQk4pRO54qSEHCsLqIhBy+PFYnbj8ndJ3H5U/f27Ks+nKHpJgMHsG73A
         BC2/GmVDda5FIcTEKjltKO7H+RKD/0O2ftn8N6UiUcdi8zHkM77E3mmkvgxHCTFwxgC+
         seqYH1IufMG4NF96qgfTT+m/oGjENy29axtgWaUC/ey3MGMietiq97ZavAd/rl6kekmd
         yB7ObWsz5nn8mcCE92zVC/Z9/JvVrcDg4EkCUgGoqOwprinLwmX4tZF0nHNsDFVG9Ssm
         9vaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UcTI+TlXLyBcW5hP31A1SVUt3vTwZBGcuxRhGd8zG+0=;
        b=IgS3l7jYEfZvPu95xEtPVuwDmNU7jp9YY08ACuufM5CYVJDUAAHjP8R8rtssx03RD5
         SwJw/ZhEDwpFuvNcOBPTRqiGY7RaFgKUJUGTnOpdMEy0fd4h5omsTJcyjWvuTKYyIdbN
         rTaYimg/NUQjr7DN40pM+3m8sFoLtAAlTjp4YZ4xp/xNkBkN/lOXcqcPasX8B8Oi0mIj
         TIcWnIrOt6dwvRTQIyVv54Vkrcowr3w1rBH48yJzGSfhnRxWlbuy8GK01vuLS/xzLs9C
         gtk3qUFbToL1CkvfWdZz3RL3PmlcUzFdI6D1goaK8A7FhbfZ0oP+RMDjbU3dEcKwj3pJ
         DPCQ==
X-Gm-Message-State: APjAAAUAd5v0K9zvZGNVOvX+3+1oExXysttkVlCeq8FBzv+sLc4TWkk3
        QY6VAuwJ2PrubocBBpTHgT7y+8KX
X-Google-Smtp-Source: APXvYqy/nxB/EGR6YOamWbA0DmEabbkwIv0AXPZ5xiiFS/sf+XLVTRyoyc5zNOY51ASIBlR8wp41Vw==
X-Received: by 2002:ac8:6f04:: with SMTP id g4mr16245803qtv.314.1579447895272;
        Sun, 19 Jan 2020 07:31:35 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:2dab:9c0b:8f93:c8be? ([2601:282:803:7700:2dab:9c0b:8f93:c8be])
        by smtp.googlemail.com with ESMTPSA id x27sm14432579qkx.81.2020.01.19.07.31.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jan 2020 07:31:34 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] ip: xfrm: add espintcp encapsulation
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <b7f74a02-ff87-1cd5-c3cb-7b620bd11fe2@gmail.com>
Date:   Sun, 19 Jan 2020 08:31:32 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <110d0a77532fcd895597f7087d1f408aadbfeb5d.1579429631.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/19/20 3:32 AM, Sabrina Dubroca wrote:
> diff --git a/include/uapi/linux/udp.h b/include/uapi/linux/udp.h
> new file mode 100644
> index 000000000000..2d1f561b89d2
> --- /dev/null
> +++ b/include/uapi/linux/udp.h
> @@ -0,0 +1,47 @@
> +/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
> +/*
> + * INET		An implementation of the TCP/IP protocol suite for the LINUX
> + *		operating system.  INET is implemented using the  BSD Socket
> + *		interface as the means of communication with the user level.
> + *
> + *		Definitions for the UDP protocol.
> + *
> + * Version:	@(#)udp.h	1.0.2	04/28/93
> + *
> + * Author:	Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
> + *
> + *		This program is free software; you can redistribute it and/or
> + *		modify it under the terms of the GNU General Public License
> + *		as published by the Free Software Foundation; either version
> + *		2 of the License, or (at your option) any later version.
> + */
> +#ifndef _UDP_H
> +#define _UDP_H
> +
> +#include <linux/types.h>
> +
> +struct udphdr {
> +	__be16	source;
> +	__be16	dest;
> +	__be16	len;
> +	__sum16	check;
> +};
> +
> +/* UDP socket options */
> +#define UDP_CORK	1	/* Never send partially complete segments */
> +#define UDP_ENCAP	100	/* Set the socket to accept encapsulated packets */
> +#define UDP_NO_CHECK6_TX 101	/* Disable sending checksum for UDP6X */
> +#define UDP_NO_CHECK6_RX 102	/* Disable accpeting checksum for UDP6 */
> +#define UDP_SEGMENT	103	/* Set GSO segmentation size */
> +#define UDP_GRO		104	/* This socket can receive UDP GRO packets */
> +
> +/* UDP encapsulation types */
> +#define UDP_ENCAP_ESPINUDP_NON_IKE	1 /* draft-ietf-ipsec-nat-t-ike-00/01 */
> +#define UDP_ENCAP_ESPINUDP	2 /* draft-ietf-ipsec-udp-encaps-06 */
> +#define UDP_ENCAP_L2TPINUDP	3 /* rfc2661 */
> +#define UDP_ENCAP_GTP0		4 /* GSM TS 09.60 */
> +#define UDP_ENCAP_GTP1U		5 /* 3GPP TS 29.060 */
> +#define UDP_ENCAP_RXRPC		6
> +#define TCP_ENCAP_ESPINTCP	7 /* Yikes, this is really xfrm encap types. */
> +
> +#endif /* _UDP_H */

Hi Sabrina:

I am confused about this header file. It is not from the kernel's uapi
directory, so the kernel does not care about the values and where did
you get the file?

