Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8BB86E7B8A
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:09:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbjDSOJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:09:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230153AbjDSOJb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:09:31 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F249C2D67;
        Wed, 19 Apr 2023 07:09:29 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id h14so21339988qvr.7;
        Wed, 19 Apr 2023 07:09:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681913369; x=1684505369;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pq/iy5VlVZ9QaLGnxXbLDd4vyHCaBmYeauBriKU8wYw=;
        b=J82sh9meFcVDeVOv1MfqAAsnN1HEU6DHKlU8iq8Z+kOkJQC45vPdA9Uh6m0VHH9MKy
         1TpRupieTGjmbboGVWBkxfLgw4PxozAYGkWTUEE4p06kdZKtU+ms2Pr8d736M9i8+y9T
         xyDTPsJLvUYIU/g2gNGTZUH0ZmMoJ/cbltp8GorshG6VokpR3Ac8elyG1ZYfq1Nen7rb
         CADY9a1XXOz0qNU08QXO7obT2ubmdFJgKdv6OcU3r7kzRL/QEzapbH3XNzwclePCxhUy
         ifhPcFSGp3J5cpKLblO/09eB+7AIMnGLfDLlKzOKEGR7BTq/ETChs97IOfrbWaDaHpU4
         sBfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681913369; x=1684505369;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pq/iy5VlVZ9QaLGnxXbLDd4vyHCaBmYeauBriKU8wYw=;
        b=R+dEQjQFgaecuv9Al1KSONeobAKhWdhK90pvFR1D5PXPzI26+BEjiC5pAIlolwopOj
         OKuFot3PnLN7a/2QzRa25mtrDMYH8S1lz1b52VEI8qZ38XeqA2aK4Fu+s5HOdJhA/tDs
         ZPRmzqv72DABWrVjWeJEO7iyq89J9b/DgJnte+i4vgJDflltmCxTjNr/rHi+NgjWC/wG
         AOgkpTlz7ru14UAy1Jno76IgvXi90HnBxfer0U0T97iJ88HPmo1d2g7UQKZopKhFlBJu
         6JSSe7LGRe8beQ9ut0ybHNSSKp6Zv7f7JGxx9ziQCJ1YDcnpuLcBdchSxTxNdN3BQMaU
         nfpQ==
X-Gm-Message-State: AAQBX9cR0IFjhe6vry2+l2objxQ/D/Gs3bJakYY9avxYjISeLCoC1sJN
        DGVZkBF0jgAHRi3xV1Yj5zA=
X-Google-Smtp-Source: AKy350YKOAOK1f3805S0hbdrd15toly9WWcPU1vRrpGVUv7vwhO+KubUlMTcENzp/o25JGt3ee0QzA==
X-Received: by 2002:ad4:5b8d:0:b0:579:5dbc:ab6e with SMTP id 13-20020ad45b8d000000b005795dbcab6emr28870100qvp.3.1681913368983;
        Wed, 19 Apr 2023 07:09:28 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id f13-20020ac8068d000000b003e3918f350dsm4824793qth.25.2023.04.19.07.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 07:09:28 -0700 (PDT)
Date:   Wed, 19 Apr 2023 10:09:28 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     yang.yang29@zte.com.cn, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com, edumazet@google.com
Cc:     kuba@kernel.org, pabeni@redhat.com, shuah@kernel.org,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, willemdebruijn.kernel@gmail.com,
        zhang.yunkai@zte.com.cn, yang.yang29@zte.com.cn,
        xu.xin16@zte.com.cn
Message-ID: <643ff6186235b_383475294ea@willemb.c.googlers.com.notmuch>
In-Reply-To: <202304191659543403931@zte.com.cn>
References: <202304191659543403931@zte.com.cn>
Subject: RE: [PATCH linux-next v2] selftests: net: udpgso_bench_rx: Fix
 verifty exceptions
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

yang.yang29@ wrote:
> From: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> 
> The verification function of this test case is likely to encounter the
> following error, which may confuse users. The problem is easily
> reproducible in the latest kernel.
> 
> Environment A, the sender:
> bash# udpgso_bench_tx -l 4 -4 -D "$IP_B"
> udpgso_bench_tx: write: Connection refused
> 
> Environment B, the receiver:
> bash# udpgso_bench_rx -4 -G -S 1472 -v
> udpgso_bench_rx: data[1472]: len 17664, a(97) != q(113)
> 
> If the packet is captured, you will see:
> Environment A, the sender:
> bash# tcpdump -i eth0 host "$IP_B" &
> IP $IP_A.41025 > $IP_B.8000: UDP, length 1472
> IP $IP_A.41025 > $IP_B.8000: UDP, length 1472
> IP $IP_B > $IP_A: ICMP $IP_B udp port 8000 unreachable, length 556
> 
> Environment B, the receiver:
> bash# tcpdump -i eth0 host "$IP_B" &
> IP $IP_A.41025 > $IP_B.8000: UDP, length 7360
> IP $IP_A.41025 > $IP_B.8000: UDP, length 14720
> IP $IP_B > $IP_A: ICMP $IP_B udp port 8000 unreachable, length 556
> 
> In one test, the verification data is printed as follows:
> abcd...xyz           | 1...
> ..                  |
> abcd...xyz           |
> abcd...opabcd...xyz  | ...1472... Not xyzabcd, messages are merged
> ..                  |
> 
> This is because the sending buffer is buf[64K], and its content is a
> loop of A-Z. But maybe only 1472 bytes per send, or more if UDP GSO is
> used. The message content does not necessarily end with XYZ, but GRO
> will merge these packets, and the -v parameter directly verifies the
> entire GRO receive buffer. So we do the validation after the data is split
> at the receiving end, just as the application actually uses this feature.

The explanation can be much more brief. The issue is that the test on
receive for expected payload pattern {AB..Z}+ fail for GRO packets if
segment payload does not end on a Z.
 
> If the sender does not use GSO, each individual segment starts at A,
> end at somewhere. Using GSO also has the same problem, and. The data
> between each segment during transmission is continuous, but GRO is merged
> in the order received, which is not necessarily the order of transmission.

The issue as I understand it is due to the above, not due to reordering.
Am I misunderstanding the problem?

> Execution in the same environment does not cause problems, because the
> lo device is not NAPI, and does not perform GRO processing. Perhaps it
> could be worth supporting to reduce system calls.
> bash# tcpdump -i lo host "$IP_self" &
> bash# echo udp_gro_receive > /sys/kernel/debug/tracing/set_ftrace_filter
> bash# echo function > /sys/kernel/debug/tracing/current_tracer
> bash# udpgso_bench_rx -4 -G -S 1472 -v &
> bash# udpgso_bench_tx -l 4 -4 -D "$IP_self"

This is not relevant.
 
> The issue still exists when using the GRO with -G, but not using the -S
> to obtain gsosize. Therefore, a print has been added to remind users.
> 
> After this issue is resolved, another issue will be encountered and will
> be resolved in the next patch.
> Environment A, the sender:
> bash# udpgso_bench_tx -l 4 -4 -D "$DST"
> udpgso_bench_tx: write: Connection refused
> 
> Environment B, the receiver:
> bash# udpgso_bench_rx -4 -G -S 1472
> udp rx:     15 MB/s      256 calls/s
> udp rx:     30 MB/s      512 calls/s
> udpgso_bench_rx: recv: bad gso size, got -1, expected 1472
> (-1 == no gso cmsg))

This is not relevant to *this patch*

> v2:
> - Fix confusing descriptions
> 
> Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> Reviewed-by: Xu Xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
> Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
> ---
>  tools/testing/selftests/net/udpgso_bench_rx.c | 40 +++++++++++++++++++++------
>  1 file changed, 31 insertions(+), 9 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
> index f35a924d4a30..6a2026494cdb 100644
> --- a/tools/testing/selftests/net/udpgso_bench_rx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_rx.c
> @@ -189,26 +189,44 @@ static char sanitized_char(char val)
>  	return (val >= 'a' && val <= 'z') ? val : '.';
>  }
> 
> -static void do_verify_udp(const char *data, int len)
> +static void do_verify_udp(const char *data, int start, int len)
>  {
> -	char cur = data[0];
> +	char cur = data[start];
>  	int i;
> 
>  	/* verify contents */
>  	if (cur < 'a' || cur > 'z')
>  		error(1, 0, "data initial byte out of range");
> 
> -	for (i = 1; i < len; i++) {
> +	for (i = start + 1; i < start + len; i++) {
>  		if (cur == 'z')
>  			cur = 'a';
>  		else
>  			cur++;
> 
> -		if (data[i] != cur)
> +		if (data[i] != cur) {
> +			if (cfg_gro_segment && !cfg_expected_gso_size)
> +				error(0, 0, "Use -S to obtain gsosize, to %s"
> +					, "help guide split and verification.");
> +
>  			error(1, 0, "data[%d]: len %d, %c(%hhu) != %c(%hhu)\n",
>  			      i, len,
>  			      sanitized_char(data[i]), data[i],
>  			      sanitized_char(cur), cur);
> +		}
> +	}
> +}
> +
> +static void do_verify_udp_gro(const char *data, int len, int gso_size)
> +{
> +	int start = 0;
> +
> +	while (len - start > 0) {
> +		if (len - start > gso_size)
> +			do_verify_udp(data, start, gso_size);
> +		else
> +			do_verify_udp(data, start, len - start);
> +		start += gso_size;
>  	}
>  }
> 
> @@ -264,16 +282,20 @@ static void do_flush_udp(int fd)
>  		if (cfg_expected_pkt_len && ret != cfg_expected_pkt_len)
>  			error(1, 0, "recv: bad packet len, got %d,"
>  			      " expected %d\n", ret, cfg_expected_pkt_len);
> +		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
> +			error(1, 0, "recv: bad gso size, got %d, expected %d %s",
> +				gso_size, cfg_expected_gso_size, "(-1 == no gso cmsg))\n");

why move this block? and don't pass part of the fmt as an extra %s.

>  		if (len && cfg_verify) {
>  			if (ret == 0)
>  				error(1, errno, "recv: 0 byte datagram\n");
> 
> -			do_verify_udp(rbuf, ret);
> +			if (!cfg_gro_segment)
> +				do_verify_udp(rbuf, 0, ret);
> +			else if (gso_size > 0)
> +				do_verify_udp_gro(rbuf, ret, gso_size);
> +			else
> +				do_verify_udp_gro(rbuf, ret, ret);
>  		}
> -		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
> -			error(1, 0, "recv: bad gso size, got %d, expected %d "
> -			      "(-1 == no gso cmsg))\n", gso_size,
> -			      cfg_expected_gso_size);
> 
>  		packets++;
>  		bytes += ret;
> -- 
> 2.15.2


