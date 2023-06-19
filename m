Return-Path: <netdev+bounces-11920-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A9E267351F3
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 12:25:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7ECA21C209E9
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 10:25:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9618EC8FA;
	Mon, 19 Jun 2023 10:25:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89B5AC123
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 10:25:54 +0000 (UTC)
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6873C2;
	Mon, 19 Jun 2023 03:25:52 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f9002a1a9bso30677785e9.1;
        Mon, 19 Jun 2023 03:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687170351; x=1689762351;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gng9SazytkDXh+NW6WTbuYnGKFStOTanhoWvA/17AEw=;
        b=e519CGsiML3H5sSONGn/kXv4+3LZa6Ioi/kR/j67eaQgwe0rlRwlYP715Z91n1/XWt
         8s0WP3KmoxkY1c1ZlmiND/DBj7T92JLqFu9R3KOiPnbKeeFDisCtb/lBSPp1Xg6rAyRL
         uCLzLtigVLuIyZnNG9Q7O82B51xHPfU26RxKZxdNyfhzXJeK9Z/1n5Vi5k4LIi3Da0wb
         U2r1c03BZZreqXkuK9nuli74snMMVRnNkA7X6lyzEMUeT9sauDW8TuvTI3J7PIKDQ8Q5
         7FU+8eJmGAEhBZhcD+XSSmfAD3eDG5UY3Njaw51d18dd9lasT/cVouREzJp3trBzj3NG
         cSUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687170351; x=1689762351;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gng9SazytkDXh+NW6WTbuYnGKFStOTanhoWvA/17AEw=;
        b=M1sQys/qh2Gi1cy5AB5Rtrp3tydzoBcvI+KA91n4H2vLmMYQ5QplOzE37BlQ/hXgJh
         CrrLlbFBg0grMNCqgMq0ZLBNuP2QR1TeJ3HOumi+Ski1NzqLFWAeGWtWaNY1H2LCxLo3
         NL2omBu75Q0+Ev2IsDACmV0bWY+jmTuwdaLOSX+y8r424cIRpkzxf/+rUaabLiY8nj4o
         WukW3HXrd7gORgeQzP+BTWE0q44yA10L4h+ZaqOlI45QmEY7qoNtCQq6Kh6y8MPDVQa5
         giSYX4mAsjcsjub1yq/EPrFR8jThVgicWSWHx2LYZOC61CMiKCtru2a8OmIvnv18aDnn
         rqog==
X-Gm-Message-State: AC+VfDxsY4doLVPQRU7x/N9hVa6owLaFnGh7nZK05vWfRct5ZBTFyNVw
	JGJiZGHgAgDFXERfrPnA/pi8LGpu1EY=
X-Google-Smtp-Source: ACHHUZ7SjiF9Qfy0j51/PZ0TeYY94+3UENyGlUyFI5R5fHILJZoZMEJMcndiZQJRH/DlbLvjRB5Abw==
X-Received: by 2002:a1c:6a13:0:b0:3f9:57b:b34a with SMTP id f19-20020a1c6a13000000b003f9057bb34amr5866282wmc.6.1687170351077;
        Mon, 19 Jun 2023 03:25:51 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d17-20020adffbd1000000b0030fb4b55c13sm24991899wrs.96.2023.06.19.03.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 03:25:50 -0700 (PDT)
Subject: Re: [PATCH 3/3] sfc: selftest: fix struct packing
To: Arnd Bergmann <arnd@kernel.org>, Martin Habets
 <habetsm.xilinx@gmail.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>
Cc: Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org,
 linux-net-drivers@amd.com, linux-kernel@vger.kernel.org
References: <20230619091215.2731541-1-arnd@kernel.org>
 <20230619091215.2731541-3-arnd@kernel.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <7c448f02-4031-0a90-97e2-0cc663b0cff9@gmail.com>
Date: Mon, 19 Jun 2023 11:25:49 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20230619091215.2731541-3-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 19/06/2023 10:12, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> Three of the sfc drivers define a packed loopback_payload structure with an
> ethernet header followed by an IP header. However, the kernel definition
> of iphdr specifies that this is 4-byte aligned, causing a W=1 warning:
> 
> net/ethernet/sfc/siena/selftest.c:46:15: error: field ip within 'struct efx_loopback_payload' is less aligned than 'struct iphdr' and is usually due to 'struct efx_loopback_payload' being packed, which can lead to unaligned accesses [-Werror,-Wunaligned-access]
>         struct iphdr ip;
> 
> As the iphdr packing is not easily changed without breaking other code,
> change the three structures to use a local definition instead.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Duplicating the definition isn't the prettiest thing in the world; it'd
 do for a quick fix if needed but I assume W=1 warnings aren't blocking
 anyone, so maybe defer this one for now and I'll follow up soon with a
 rewrite that fixes this more cleanly?  My idea is to drop the __packed
 from the containing struct, make efx_begin_loopback() copy the layers
 separately, and efx_loopback_rx_packet() similarly do something less
 direct than casting the packet data to the struct.

But I don't insist on it; if you want this fix in immediately then I'm
 okay with that too.

> ---
>  drivers/net/ethernet/sfc/falcon/selftest.c | 21 ++++++++++++++++++++-
>  drivers/net/ethernet/sfc/selftest.c        | 21 ++++++++++++++++++++-
>  drivers/net/ethernet/sfc/siena/selftest.c  | 21 ++++++++++++++++++++-
>  3 files changed, 60 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/ethernet/sfc/falcon/selftest.c b/drivers/net/ethernet/sfc/falcon/selftest.c
> index 6a454ac6f8763..fb7fcd27a33a5 100644
> --- a/drivers/net/ethernet/sfc/falcon/selftest.c
> +++ b/drivers/net/ethernet/sfc/falcon/selftest.c
> @@ -40,7 +40,26 @@
>   */
>  struct ef4_loopback_payload {
>  	struct ethhdr header;
> -	struct iphdr ip;
> +	struct {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +		__u8	ihl:4,
> +			version:4;
> +#elif defined (__BIG_ENDIAN_BITFIELD)
> +		__u8	version:4,
> +			ihl:4;
> +#else
> +#error	"Please fix <asm/byteorder.h>"
> +#endif
> +		__u8	tos;
> +		__be16	tot_len;
> +		__be16	id;
> +		__be16	frag_off;
> +		__u8	ttl;
> +		__u8	protocol;
> +		__sum16	check;
> +		__be32	saddr;
> +		__be32	daddr;
> +	} __packed ip; /* unaligned struct iphdr */
>  	struct udphdr udp;
>  	__be16 iteration;
>  	char msg[64];
> diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
> index 3c5227afd4977..440a57953779c 100644
> --- a/drivers/net/ethernet/sfc/selftest.c
> +++ b/drivers/net/ethernet/sfc/selftest.c
> @@ -43,7 +43,26 @@
>   */
>  struct efx_loopback_payload {
>  	struct ethhdr header;
> -	struct iphdr ip;
> +	struct {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +		__u8	ihl:4,
> +			version:4;
> +#elif defined (__BIG_ENDIAN_BITFIELD)
> +		__u8	version:4,
> +			ihl:4;
> +#else
> +#error	"Please fix <asm/byteorder.h>"
> +#endif
> +		__u8	tos;
> +		__be16	tot_len;
> +		__be16	id;
> +		__be16	frag_off;
> +		__u8	ttl;
> +		__u8	protocol;
> +		__sum16	check;
> +		__be32	saddr;
> +		__be32	daddr;
> +	} __packed ip; /* unaligned struct iphdr */
>  	struct udphdr udp;
>  	__be16 iteration;
>  	char msg[64];
> diff --git a/drivers/net/ethernet/sfc/siena/selftest.c b/drivers/net/ethernet/sfc/siena/selftest.c
> index 07715a3d6beab..b8a8b0495f661 100644
> --- a/drivers/net/ethernet/sfc/siena/selftest.c
> +++ b/drivers/net/ethernet/sfc/siena/selftest.c
> @@ -43,7 +43,26 @@
>   */
>  struct efx_loopback_payload {
>  	struct ethhdr header;
> -	struct iphdr ip;
> +	struct {
> +#if defined(__LITTLE_ENDIAN_BITFIELD)
> +		__u8	ihl:4,
> +			version:4;
> +#elif defined (__BIG_ENDIAN_BITFIELD)
> +		__u8	version:4,
> +			ihl:4;
> +#else
> +#error	"Please fix <asm/byteorder.h>"
> +#endif
> +		__u8	tos;
> +		__be16	tot_len;
> +		__be16	id;
> +		__be16	frag_off;
> +		__u8	ttl;
> +		__u8	protocol;
> +		__sum16	check;
> +		__be32	saddr;
> +		__be32	daddr;
> +	} __packed ip; /* unaligned struct iphdr */
>  	struct udphdr udp;
>  	__be16 iteration;
>  	char msg[64];
> 


