Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 852616ED008
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 16:11:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbjDXOLB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 10:11:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231303AbjDXOLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 10:11:00 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E52DE;
        Mon, 24 Apr 2023 07:10:57 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id 6a1803df08f44-5ef55901f49so19037966d6.2;
        Mon, 24 Apr 2023 07:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682345456; x=1684937456;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gd9Pl0It3TDltQeAVm2rUEyHHwpqgvGnQc5Nc20j11o=;
        b=OqZYsS4SU4LHUhElPmxqFbN9r+Jg2q93L6UFEtrdRCLhzqiZQI+z0NHxn+lzeq8UEJ
         03V2u6KywmZYYZ4TpdHFD8rTrnPj0Esw7R4c4BkoQqNT4XPjp2A5N6ntBR9wVSwLtbrP
         LOdymBYrRWbxz6IDkGXJjrWcAlkuUYoHeiKSEJNKzTzJKx2Frj/i9OmRpPwNbsqhb+nI
         2ARMKnCjjahLpNen8SWwwgCTFTDsR32YaELIXgHpmTmcGPve2mGeZFcE+LkCGRpuoK8Y
         GxRfUQ7GFvaUQJhBvo5F1LfT/3SDsyXKkF+imnkt00Audiqdt8l8kY2eRm1vzKYg3b8s
         H+Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682345456; x=1684937456;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Gd9Pl0It3TDltQeAVm2rUEyHHwpqgvGnQc5Nc20j11o=;
        b=aUT2Gd0DY+79HL1d+cPLB+Tc4xey/Zbkvplkzf0+3k3Msoa9aqmasA1whB5i10NTsk
         9cXhkNfMjnppg/IEIW3h/E89y0EO3K+SGpqygcQg4ml+gAjN00snR2FoRdQ0dihrnDpu
         HpxV8aP43EIeFrboTSL0bPIbnQGIzVbqx8IwsOrIidYYMMAz3Flok09knAmzV+pKiuD3
         +xAitVaXEvVVxc6HdfTBe/CQidq11GWpvE2zFsMikWMBgK3+Kq7Ro0kVJsnP2lURh4cg
         0/skOlxrRCVq1gTAgZKUUYG2NUetY2RDDUXoZMFUwxd2mlxN074psngBERMZ0gfMlqtJ
         d2oA==
X-Gm-Message-State: AC+VfDwShhIBd36ny8XGdgqS2pnVPNisYShcC/SmAcELb/jO0TiAKpII
        UY7N+s8jd/UDWd2cGwVGcBI=
X-Google-Smtp-Source: ACHHUZ6fbXcD4TpjrtcJ/LY+6XZH/BKqQVQjdnCjhh/UAAtkD1IldLCbOqOnGtxKzN+y2LjUMG9OWA==
X-Received: by 2002:a05:6214:19cf:b0:616:2ff9:4826 with SMTP id j15-20020a05621419cf00b006162ff94826mr4768223qvc.18.1682345455733;
        Mon, 24 Apr 2023 07:10:55 -0700 (PDT)
Received: from localhost (172.174.245.35.bc.googleusercontent.com. [35.245.174.172])
        by smtp.gmail.com with ESMTPSA id y15-20020a0c8ecf000000b005e7648f9b78sm3301042qvb.109.2023.04.24.07.10.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 07:10:55 -0700 (PDT)
Date:   Mon, 24 Apr 2023 10:10:54 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     yang.yang29@zte.com.cn, davem@davemloft.net,
        willemdebruijn.kernel@gmail.com
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang.yunkai@zte.com.cn, yang.yang29@zte.com.cn,
        xu.xin16@zte.com.cn
Message-ID: <64468deedd90a_191c8029493@willemb.c.googlers.com.notmuch>
In-Reply-To: <202304241355464262541@zte.com.cn>
References: <202304241355464262541@zte.com.cn>
Subject: RE: [PATCH linux-next v3] selftests: net: udpgso_bench_rx: Fix
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

This error is not relevant to the bug that is being fixed
 
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

Same here

> Environment B, the receiver:
> bash# tcpdump -i eth0 host "$IP_B" &
> IP $IP_A.41025 > $IP_B.8000: UDP, length 7360
> IP $IP_A.41025 > $IP_B.8000: UDP, length 14720
> IP $IP_B > $IP_A: ICMP $IP_B udp port 8000 unreachable, length 556

And here
 
> In one test, the verification data is printed as follows:
> abcd...xyz           | 1...
> ..                  |
> abcd...xyz           |
> abcd...opabcd...xyz  | ...1472... Not xyzabcd, messages are merged
> ..                  |
> 
> The issue is that the test on receive for expected payload pattern 
> {AB..Z}+ fail for GRO packets if segment payload does not end on a Z.

This is really the only pertinent explanation needed for the fix.

> The issue still exists when using the GRO with -G, but not using the -S
> to obtain gsosize. Therefore, a print has been added to remind users.

So the issue is that -G/cfg_gro_segment enables UDP_GRO, but
-S/cfg_expected_gso_size enables recvmsg cmsg UDP_GRO. We need
gso_size to know whether discontinuities will appear, so cannot
verify payload for -G without -S. There really is no reason to
ever run the test in that configuration, should perhaps fail.

Btw title should start with PATCH net as this is a fix, instead of
PATCH linux-next. And it is verify not verifty. Also needs a Fixes tag:

Fixes: 0a9ac2e954091 ("selftests: add GRO support to udp bench rx program")

> Changes in v3:
> - Simplify description and adjust judgment order.
> 
> Changes in v2:
> - Fix confusing descriptions.
> 
> Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> Reviewed-by: Xu Xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
> Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
> ---
>  tools/testing/selftests/net/udpgso_bench_rx.c | 34 +++++++++++++++++++++++----
>  1 file changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
> index f35a924d4a30..3ad18cbc570d 100644
> --- a/tools/testing/selftests/net/udpgso_bench_rx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_rx.c
> @@ -189,26 +189,45 @@ static char sanitized_char(char val)
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
> +				error(0, 0, "Use -S to obtain gsosize to guide "
> +					"splitting and verification.");
> +

This is not the place to add a gso_size test. Drop.

>  			error(1, 0, "data[%d]: len %d, %c(%hhu) != %c(%hhu)\n",
>  			      i, len,
>  			      sanitized_char(data[i]), data[i],
>  			      sanitized_char(cur), cur);
> +		}
> +	}
> +}
> +
> +static void do_verify_udp_gro(const char *data, int len, int segment_size)
> +{
> +	int start = 0;
> +
> +	while (len - start > 0) {
> +		if (len - start > segment_size)
> +			do_verify_udp(data, start, segment_size);
> +		else
> +			do_verify_udp(data, start, len - start);

Instead of adding start argument, just pass data + start as first argument.

> +
> +		start += segment_size;
>  	}
>  }
> 
> @@ -268,7 +287,12 @@ static void do_flush_udp(int fd)
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

This only test a fraction of the payload. The test should always test
the entire payload. It should just be aware of discontinuity at gso_size.
>  		}
>  		if (cfg_expected_gso_size && cfg_expected_gso_size != gso_size)
>  			error(1, 0, "recv: bad gso size, got %d, expected %d "
> -- 
> 2.15.2


