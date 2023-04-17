Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B31C6E4D2D
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:28:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjDQP2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231324AbjDQP2V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:28:21 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC2E1A26D;
        Mon, 17 Apr 2023 08:27:53 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id qh25so15461530qvb.1;
        Mon, 17 Apr 2023 08:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681745272; x=1684337272;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZEQ2oNibFotvr5G4IgFOlkkqVrIF5WmB966PXHAIqYs=;
        b=lp2FjqYR9bRT7soE2oA/pVOtVUPK7imTwVeA6scU73HX+nuoo5W0Bp2bLLqKNh6AXq
         IB0OuZsPg71BwKREtj+eURmUL7cP8gDYiZf6NbPAeOsyYAXBhC2aIbmMNb3G7A8r/Yrh
         Y4GRE/tLCMujisIMF+5dst248YxCIGK7nipw9CFihrFwkFLmY3Z8068w+7QdSw+golU4
         BoadS3ifDUJqdwXyaO67rpi1G2VP2Ca63TdaqTGmegf8Z3u+hQFzHi3B/b0sUtXwxvMq
         44JD7/WSaBEW3wUgMcSbHgk/5fZ0JN3NsiYnaRNabk7/Chfp1wkvwqKSChqzqXhFutJZ
         HUXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681745272; x=1684337272;
        h=content-transfer-encoding:mime-version:subject:references
         :in-reply-to:message-id:cc:to:from:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZEQ2oNibFotvr5G4IgFOlkkqVrIF5WmB966PXHAIqYs=;
        b=SyDYk640GE/wpnWVRs+Il8GRB1G89Be1blcSDKOYmkHMz/c9eFZUqGVaA2USXWY40m
         mD9ILgkHkv0WNZCJ7cJXuNEpawAK9Z/BkntEDj/ukaRK4GNopXl28/unE4/AwZ1DEC+U
         agNpVZ/quhZQABBwX3lWQuqpO3Oty7+QfkzX72K1sIKBgZ7dqg9vGJb71f2uRM/Qhsr3
         aqHmlTGi4MZP5Yhasnl23hFjWYWY8gUPnD2Z2eOOP3HvikR+RLx2cjolgZhVXPifj8Nd
         39aUy1VNsCUmyVBocfmC0oFFUXHyKjSRsJnOggt0CJsX4s/MCkc5oXK1Y+If6fu+hoUz
         Mt9w==
X-Gm-Message-State: AAQBX9euaYfwHtmDUkrEsghr5gj1WONTLTsMercfbbIh5aPsUbKPy7LF
        WMsZ9Vur7W/cmUwFtQZpz4o=
X-Google-Smtp-Source: AKy350YvxV0rJQsZ8oURwTNvCim8hlxVVBwPkX6XTLeGhzsGNA1SAk+qA3MjK7dMm41fm7k7vYJijg==
X-Received: by 2002:a05:6214:20a3:b0:5ef:4e96:11c5 with SMTP id 3-20020a05621420a300b005ef4e9611c5mr15756682qvd.17.1681745272640;
        Mon, 17 Apr 2023 08:27:52 -0700 (PDT)
Received: from localhost (240.157.150.34.bc.googleusercontent.com. [34.150.157.240])
        by smtp.gmail.com with ESMTPSA id 70-20020a370649000000b0074df1d74841sm882413qkg.72.2023.04.17.08.27.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:27:52 -0700 (PDT)
Date:   Mon, 17 Apr 2023 11:27:51 -0400
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
To:     Yang Yang <yang.yang29@zte.com.cn>, davem@davemloft.net,
        edumazet@google.com, willemdebruijn.kernel@gmail.com
Cc:     yang.yang29@zte.com.cn, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com, shuah@kernel.org,
        zhang.yunkai@zte.com.cn, xu.xin16@zte.com.cn,
        Xuexin Jiang <jiang.xuexin@zte.com.cn>
Message-ID: <643d6577e81f1_29b64929414@willemb.c.googlers.com.notmuch>
In-Reply-To: <20230417122504.193350-1-yang.yang29@zte.com.cn>
References: <202304172017351308785@zte.com.cn>
 <20230417122504.193350-1-yang.yang29@zte.com.cn>
Subject: RE: [PATCH linux-next 3/3] selftests: net: udpgso_bench_rx: Fix
 packet number exceptions
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

Yang Yang wrote:
> From: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> 
> The -n parameter is confusing and seems to only affect the frequency of
> determining whether the time reaches 1s.

This statement seems irrelevant to this patch.

Is the point that cfg_expected_pkt_nr is tested in do_flush_udp to
stop reading, but not in the caller of that function, do_recv, to
break out of the loop? That's a fair point and may deserve a fix.

> However, the final print of the
> program is the number of messages expected to be received, which is always
> 0.
> 
> bash# udpgso_bench_rx -4 -n 100
> bash# udpgso_bench_tx -l 1 -4 -D "$DST"
> udpgso_bench_rx: wrong packet number! got 0, expected 100
> 
> This is because the packets are always cleared after print.

This looks good to me. Would be a fix to the commit that introduced
that wrong packet number branch, commit 3327a9c46352
("selftests: add functionals test for UDP GRO").
> 
> Signed-off-by: Zhang Yunkai (CGEL ZTE) <zhang.yunkai@zte.com.cn>
> Reviewed-by: xu xin (CGEL ZTE) <xu.xin16@zte.com.cn>
> Reviewed-by: Yang Yang (CGEL ZTE) <yang.yang29@zte.com.cn>
> Cc: Xuexin Jiang (CGEL ZTE) <jiang.xuexin@zte.com.cn>
> ---
>  tools/testing/selftests/net/udpgso_bench_rx.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/udpgso_bench_rx.c b/tools/testing/selftests/net/udpgso_bench_rx.c
> index 784e88b31f7d..b66bb53af19f 100644
> --- a/tools/testing/selftests/net/udpgso_bench_rx.c
> +++ b/tools/testing/selftests/net/udpgso_bench_rx.c
> @@ -50,7 +50,7 @@ static int  cfg_rcv_timeout_ms;
>  static struct sockaddr_storage cfg_bind_addr;
>  
>  static bool interrupted;
> -static unsigned long packets, bytes;
> +static unsigned long packets, total_packets, bytes;
>  
>  static void sigint_handler(int signum)
>  {
> @@ -405,6 +405,7 @@ static void do_recv(void)
>  					"%s rx: %6lu MB/s %8lu calls/s\n",
>  					cfg_tcp ? "tcp" : "udp",
>  					bytes >> 20, packets);
> +			total_packets += packets;
>  			bytes = packets = 0;
>  			treport = tnow + 1000;
>  		}
> @@ -415,7 +416,7 @@ static void do_recv(void)
>  
>  	if (cfg_expected_pkt_nr && (packets != cfg_expected_pkt_nr))
>  		error(1, 0, "wrong packet number! got %ld, expected %d\n",
> -		      packets, cfg_expected_pkt_nr);
> +		      total_packets + packets, cfg_expected_pkt_nr);
>  
>  	if (close(fd))
>  		error(1, errno, "close");
> -- 
> 2.15.2


