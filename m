Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 126836A1DBC
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 15:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbjBXOrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 09:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbjBXOru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 09:47:50 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A381D19BA;
        Fri, 24 Feb 2023 06:47:48 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-536bf92b55cso281764207b3.12;
        Fri, 24 Feb 2023 06:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8uUY0givXBFT5S7l+w54j/YXmi9by/XbIMZYftrzf2Q=;
        b=LLvWs8JX9DPLjP9GXeHGKYI6m3OLPWqDFxAE5Mr7DI3o9UqA5qKuhCWT6dCKs7RCBm
         /3+i988r17RH4J3MsFUBR5E9bXe5norCSlCV540ExT8ajXbus6eXIseyswopyjBVAfM1
         pvEznqqmPijzJbWqm+DlAQA7uW7Yss/j4wNcHyo3Oq7YebMUTSI+qLYg8TqK1K9+LOjL
         VRhS4mjzYz8l6/Mcmqk7/XKHhidzty7L6aR3fNuhsrjdGNypedE5bO3kMUd8dUJLCzw9
         zCQ1NeMO4Y5TKYNn/JjS+9xqWMWWqkLo2A5w/Aqr13ZWkNrF57QDU4n/1jux7P9YEalQ
         yiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8uUY0givXBFT5S7l+w54j/YXmi9by/XbIMZYftrzf2Q=;
        b=K6jSW3DJ1IvND3tPS0YjAwNZY/ye8USZhG2x1mz2DOVF+f8MqqpzH3/x2eAfKAyvyX
         JXr8N/yRq3FtCeHmP9SvY6M0xaFrhkDyf6/yA3a+YHSd8sHNKRGFVgSCyW4JviFAyjA3
         p6GB6XDLUeg9xBAwOu9clCOB0sxtOxlnfFNiqSOExIMYxpcNFW1pipRFhkCiC6WII/75
         mhFd2gDrumbehIodLBcUI2L1ijXwSxQaAeo6kwTAF8zdbuBUV2Q/MpkOwkwur00RjdDR
         8EXUUWNTUTC1i0F3z578+AFvz4cwF2PJEGzEmlSGRV6mljYXBnbdbd9oS/AOeFF4QFy1
         JLFg==
X-Gm-Message-State: AO0yUKXyldYiMG6Rj4f2r2ovjes60x3Yy8hhUaaoy0PrlFYLvXIuwVoW
        3vQaP1WqWNKvWozj4a+gVnYiEYjsQXM=
X-Google-Smtp-Source: AK7set/G9lKoX3cNTU4MKH/VN/w5BVWKXkwG3pEbF8XrYg8cCVVWQO24zeRWIYJB3yVJi0n7MdR0Og==
X-Received: by 2002:a25:e210:0:b0:a24:1001:1fb2 with SMTP id h16-20020a25e210000000b00a2410011fb2mr6144946ybe.30.1677250067848;
        Fri, 24 Feb 2023 06:47:47 -0800 (PST)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id b201-20020ae9ebd2000000b007423843d879sm5160106qkg.93.2023.02.24.06.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 06:47:47 -0800 (PST)
Date:   Fri, 24 Feb 2023 09:47:47 -0500
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     yang.yang29@zte.com.cn, davem@davemloft.net
Cc:     edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        jiang.xuexin@zte.com.cn
Message-ID: <63f8ce1313457_78f63208c6@willemb.c.googlers.com.notmuch>
In-Reply-To: <202302241438536013777@zte.com.cn>
References: <202302241438536013777@zte.com.cn>
Subject: RE: [PATCH linux-next] selftests: net: udpgso_bench_tx: Add test for
 IP fragmentation of UDP packets
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

yang.yang29@ wrote:
> From: zhang yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> 
> The UDP GSO bench only tests the performance of userspace payload splitting
> and UDP GSO. But we are also concerned about the performance comparing
> with IP fragmentation and UDP GSO. In other words comparing IP fragmentation 
> and segmentation.
> 
> So we add testcase of IP fragmentation of UDP packets, then user would easy
> to get to know the performance promotion of UDP GSO compared with IP 
> fragmentation. We add a new option "-f", which is to send big data using 
> IP fragmentation instead of using UDP GSO or userspace payload splitting.
> 
> In the QEMU environment we could see obvious promotion of UDP GSO.
> The first test is to get the performance of userspace payload splitting.
> bash# udpgso_bench_tx -l 4 -4 -D "$DST"
> udp tx:     10 MB/s     7812 calls/s    186 msg/s
> udp tx:     10 MB/s     7392 calls/s    176 msg/s
> udp tx:     11 MB/s     7938 calls/s    189 msg/s
> udp tx:     11 MB/s     7854 calls/s    187 msg/s
> 
> The second test is to get the performance of IP fragmentation.
> bash# udpgso_bench_tx -l 4 -4 -D "$DST" -f
> udp tx:     33 MB/s      572 calls/s    572 msg/s
> udp tx:     33 MB/s      563 calls/s    563 msg/s
> udp tx:     31 MB/s      540 calls/s    540 msg/s
> udp tx:     33 MB/s      571 calls/s    571 msg/s
> 
> The third test is to get the performance of UDP GSO.
> bash# udpgso_bench_tx -l 4 -4 -D "$DST" -S 0
> udp tx:     46 MB/s      795 calls/s    795 msg/s
> udp tx:     49 MB/s      845 calls/s    845 msg/s
> udp tx:     49 MB/s      847 calls/s    847 msg/s
> udp tx:     45 MB/s      774 calls/s    774 msg/s
> 
> Signed-off-by: zhang yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
> Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
> ---
>  tools/testing/selftests/net/udpgso_bench_tx.c | 33 ++++++++++++++++++++++-----
>  1 file changed, 27 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/udpgso_bench_tx.c b/tools/testing/selftests/net/udpgso_bench_tx.c
> index 477392715a9a..025e706b594b 100644
> --- a/tools/testing/selftests/net/udpgso_bench_tx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_tx.c
> @@ -64,6 +64,7 @@ static int	cfg_runtime_ms	= -1;
>  static bool	cfg_poll;
>  static int	cfg_poll_loop_timeout_ms = 2000;
>  static bool	cfg_segment;
> +static bool	cfg_fragment;
>  static bool	cfg_sendmmsg;
>  static bool	cfg_tcp;
>  static uint32_t	cfg_tx_ts = SOF_TIMESTAMPING_TX_SOFTWARE;
> @@ -375,6 +376,21 @@ static int send_udp_sendmmsg(int fd, char *data)
>  	return ret;
>  }
> 
> +static int send_udp_fragment(int fd, char *data)
> +{
> +	int ret;
> +
> +	ret = sendto(fd, data, cfg_payload_len, cfg_zerocopy ? MSG_ZEROCOPY : 0,
> +			cfg_connected ? NULL : (void *)&cfg_dst_addr,
> +			cfg_connected ? 0 : cfg_alen);

This should probably disable PMTU discovery with IP_PMTUDISC_OMIT to
allow transmission with fragmentation of a packet that exceeds MTU.
And to avoid send returning with error after ICMP destination
unreachable messages if MTU is exceeded in the path.

> +	if (ret == -1)
> +		error(1, errno, "write");
> +	if (ret != cfg_payload_len)
> +		error(1, errno, "write: %uB != %uB\n", ret, cfg_payload_len);
> +
> +	return 1;
> +}
> +
>  static void send_udp_segment_cmsg(struct cmsghdr *cm)
>  {
>  	uint16_t *valp;
> @@ -429,7 +445,7 @@ static int send_udp_segment(int fd, char *data)
> 
>  static void usage(const char *filepath)
>  {
> -	error(1, 0, "Usage: %s [-46acmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] "
> +	error(1, 0, "Usage: %s [-46acfmHPtTuvz] [-C cpu] [-D dst ip] [-l secs] "
>  		    "[-L secs] [-M messagenr] [-p port] [-s sendsize] [-S gsosize]",
>  		    filepath);
>  }
> @@ -440,7 +456,7 @@ static void parse_opts(int argc, char **argv)
>  	int max_len, hdrlen;
>  	int c;
> 
> -	while ((c = getopt(argc, argv, "46acC:D:Hl:L:mM:p:s:PS:tTuvz")) != -1) {
> +	while ((c = getopt(argc, argv, "46acC:D:fHl:L:mM:p:s:PS:tTuvz")) != -1) {
>  		switch (c) {
>  		case '4':
>  			if (cfg_family != PF_UNSPEC)
> @@ -469,6 +485,9 @@ static void parse_opts(int argc, char **argv)
>  		case 'l':
>  			cfg_runtime_ms = strtoul(optarg, NULL, 10) * 1000;
>  			break;
> +		case 'f':
> +			cfg_fragment = true;
> +			break;
>  		case 'L':
>  			cfg_poll_loop_timeout_ms = strtoul(optarg, NULL, 10) * 1000;
>  			break;
> @@ -527,10 +546,10 @@ static void parse_opts(int argc, char **argv)
>  		error(1, 0, "must pass one of -4 or -6");
>  	if (cfg_tcp && !cfg_connected)
>  		error(1, 0, "connectionless tcp makes no sense");
> -	if (cfg_segment && cfg_sendmmsg)
> -		error(1, 0, "cannot combine segment offload and sendmmsg");
> -	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg))
> -		error(1, 0, "Options -T and -H require either -S or -m option");
> +	if ((cfg_segment + cfg_sendmmsg + cfg_fragment) > 1)
> +		error(1, 0, "cannot combine segment offload , fragment and sendmmsg");

nit: extra whitespace before comma.

> +	if (cfg_tx_tstamp && !(cfg_segment || cfg_sendmmsg || cfg_fragment))
> +		error(1, 0, "Options -T and -H require either -S or -m or -f option");
> 
>  	if (cfg_family == PF_INET)
>  		hdrlen = sizeof(struct iphdr) + sizeof(struct udphdr);
> @@ -695,6 +714,8 @@ int main(int argc, char **argv)
>  			num_sends += send_udp_segment(fd, buf[i]);
>  		else if (cfg_sendmmsg)
>  			num_sends += send_udp_sendmmsg(fd, buf[i]);
> +		else if (cfg_fragment)
> +			num_sends += send_udp_fragment(fd, buf[i]);
>  		else
>  			num_sends += send_udp(fd, buf[i]);
>  		num_msgs++;
> -- 
> 2.15.2


