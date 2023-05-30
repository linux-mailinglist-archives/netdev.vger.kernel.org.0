Return-Path: <netdev+bounces-6361-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BBF8715F20
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 14:25:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C05081C20C1A
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 12:25:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C3EC19920;
	Tue, 30 May 2023 12:25:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29FBB17AC6;
	Tue, 30 May 2023 12:25:45 +0000 (UTC)
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD033B0;
	Tue, 30 May 2023 05:25:43 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso3259066b3a.1;
        Tue, 30 May 2023 05:25:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685449543; x=1688041543;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Xureu22+xTCV4Guuaw1tQBhTRBYqPO/y9LUOVEvi1/8=;
        b=bbAK3h7l1gRsrhtYdWpgm0fLaJ0+yjut9XNAZV0cljWv9c1e/5gpTrCW4XL4Gpsohg
         Rb9a5maH14Y9XNIUqRRtFrJ0d4DfCbdPt2x0VKJBdl8lQYmC+1kDR5mxKiLpVMVJQU44
         3Ar1kzeYaklnK1nsMRd3uRwbA7l01D4tw4kGCk7k3J7jl/2z9AHEvT9+Kcmtt3OW+mpJ
         LQ6Ep3fZCtafb7E/7TxYHRRb9sTFSWv2WpkLrmoqo2otjpmPE1nWKfMyQYu16Vx6WaEv
         UYMqJRbLym1R+qLIHO2Z0UKXUJXr+4EfFGNIR2IAtH5RSKb5Utrf6O3iMr5rsZEOn7z5
         uPJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685449543; x=1688041543;
        h=content-transfer-encoding:cc:to:subject:from:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=Xureu22+xTCV4Guuaw1tQBhTRBYqPO/y9LUOVEvi1/8=;
        b=OKNjWI208Jy4OAdPC9ULBRf0mOHKB9yTeMtpk1jqM5/AAOoAT6n0pnYXCpKFQG4O0Y
         bu/6yVPe1gy/iKOSywCJXiy2evUEN4YVd35UdOv9C+GYWItjPcqc81eMOmIgiv5SrAbn
         psYIiwEMF5zZW+LspecUYRjnG0HMvLpEF8ZW3dME2gLIZLPO6yjjxYYw4k1mkaYTa/vP
         adQ6Aki3mcoO7LPXd8n4bUnnnSbgxiVO21uqmiF+YryHgcy7ANXVs0FZkt0cdPN/tVRC
         dbp7JUw8r1e1RpH1ciHdANfq+UtOWi4Ddq8PvYfk5SjGrEdmTP92PDhpPJRmmuqh7kAI
         v3sQ==
X-Gm-Message-State: AC+VfDySZRUsh5jFRdirvtcXbO9ZTl+csIhgwewf4X1QgUktnCG15SHn
	eeDJo7h/VG/lqS3fFvJUGtSx4phinAk=
X-Google-Smtp-Source: ACHHUZ4YlfnkfFUHeLIgNRoe1MEw5eL/vXECbC/CHLe8zqgvMoc1ERBPMl21QEDw9u4jIfXP0Y7C5g==
X-Received: by 2002:a05:6a00:1915:b0:64f:3fc8:5d26 with SMTP id y21-20020a056a00191500b0064f3fc85d26mr2316156pfi.9.1685449543024;
        Tue, 30 May 2023 05:25:43 -0700 (PDT)
Received: from [192.168.43.80] (subs02-180-214-232-12.three.co.id. [180.214.232.12])
        by smtp.gmail.com with ESMTPSA id x25-20020a62fb19000000b0062e0c39977csm1514741pfm.139.2023.05.30.05.25.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 05:25:42 -0700 (PDT)
Message-ID: <15dd93af-fcd5-5b9a-a6ba-9781768dbae7@gmail.com>
Date: Tue, 30 May 2023 19:25:36 +0700
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Content-Language: en-US
From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Fwd: nvsp_rndis_pkt_complete error status and net_ratelimit:
 callbacks suppressed messages on 6.4.0rc4
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux Regressions <regressions@lists.linux.dev>,
 Linux Kernel Network Developers <netdev@vger.kernel.org>,
 Linux BPF <bpf@vger.kernel.org>,
 Linux on Hyper-V <linux-hyperv@vger.kernel.org>
Cc: Michael Kelley <mikelley@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

I notice a regression report on Bugzilla [1]. Quoting from it:

> After building 6.4.0rc4 for my VM running on a Windows 10 Hyper-V host, I see the following 
> 
> [  756.697753] net_ratelimit: 34 callbacks suppressed
> [  756.697806] hv_netvsc cd9dd876-2fa9-4764-baa7-b44482f85f9f eth0: nvsp_rndis_pkt_complete error status: 2
> (snipped repeated messages)
> 
> *but*, I'm only able to reliably reproduce this if I am generating garbage on another terminal, e.g. sudo strings /dev/sda
> 
> 
> This doesn't appear to affect latency or bandwidth a huge amount, I ran an iperf3 test between the guest and the host while trying to cause these messages.
> Although you if you take 17-18 gigabit as the "base" speed, you can see it drop a bit to 16 gigabit while the errors happen and "catch up" when I stop spamming the console.
> 
> [  5]  99.00-100.00 sec  1.89 GBytes  16.2 Gbits/sec
> [  5] 100.00-101.00 sec  1.91 GBytes  16.4 Gbits/sec
> [  5] 101.00-102.00 sec  1.91 GBytes  16.4 Gbits/sec
> [  5] 102.00-103.00 sec  1.91 GBytes  16.4 Gbits/sec
> [  5] 103.00-104.00 sec  1.92 GBytes  16.5 Gbits/sec
> [  5] 104.00-105.00 sec  1.94 GBytes  16.6 Gbits/sec
> [  5] 105.00-106.00 sec  1.89 GBytes  16.2 Gbits/sec
> [  5] 106.00-107.00 sec  1.90 GBytes  16.3 Gbits/sec
> [  5] 107.00-108.00 sec  2.23 GBytes  19.2 Gbits/sec
> [  5] 108.00-109.00 sec  2.57 GBytes  22.0 Gbits/sec
> [  5] 109.00-110.00 sec  2.66 GBytes  22.9 Gbits/sec
> [  5] 110.00-111.00 sec  2.64 GBytes  22.7 Gbits/sec
> [  5] 111.00-112.00 sec  2.65 GBytes  22.7 Gbits/sec
> [  5] 112.00-113.00 sec  2.65 GBytes  22.8 Gbits/sec
> [  5] 113.00-114.00 sec  2.65 GBytes  22.8 Gbits/sec
> [  5] 114.00-115.00 sec  2.65 GBytes  22.8 Gbits/sec
> [  5] 115.00-116.00 sec  2.66 GBytes  22.9 Gbits/sec
> [  5] 116.00-117.00 sec  2.63 GBytes  22.6 Gbits/sec
> [  5] 117.00-118.00 sec  2.69 GBytes  23.1 Gbits/sec
> [  5] 118.00-119.00 sec  2.66 GBytes  22.9 Gbits/sec
> [  5] 119.00-120.00 sec  2.67 GBytes  22.9 Gbits/sec
> [  5] 120.00-121.00 sec  2.66 GBytes  22.9 Gbits/sec
> [  5] 121.00-122.00 sec  2.49 GBytes  21.4 Gbits/sec
> [  5] 122.00-123.00 sec  2.15 GBytes  18.5 Gbits/sec
> [  5] 123.00-124.00 sec  2.16 GBytes  18.6 Gbits/sec
> [  5] 124.00-125.00 sec  2.16 GBytes  18.6 Gbits/sec
> 

See bugzilla for the full thread.

Anyway, I'm adding it to regzbot:

#regzbot introduced: dca5161f9bd052 https://bugzilla.kernel.org/show_bug.cgi?id=217503
#regzbot title: net_ratelimit and nvsp_rndis_pkt_complete error due to SEND_RNDIS_PKT status check

Thanks.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=217503

-- 
An old man doll... just what I always wanted! - Clara

