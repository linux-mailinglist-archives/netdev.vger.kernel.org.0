Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7693F36E5
	for <lists+netdev@lfdr.de>; Sat, 21 Aug 2021 00:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240660AbhHTWvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 18:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240854AbhHTWvr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 18:51:47 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01337C061757;
        Fri, 20 Aug 2021 15:51:09 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id u22so23517048lfq.13;
        Fri, 20 Aug 2021 15:51:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wS2+Os8U5Xqw5DO4Q5hTcwa/1+R2naY8oX8X+CBPw30=;
        b=uHLhnitdWHLhLg11KD1TwttomzAOumdZmia6bK7YCs45El5yVQbGUm0sVlcsWSslGU
         Mk0fyQNnRTbFXXRuqVvxVTdAyCt8WReyBegBD9cirqJVuNERu+BjM6/yh1EppxqNX9GZ
         OORZcRfwLFSVlG+eSN6899/XIFeadhGbMUb3njaaQTQ75m75NVEEEwIH47D3TIBuWPMk
         cLNNcTsteRZ/YM291Mv9wNgggq7sU9Zhe6hHDHVL9Ye3VQlOoe3dxkxrpY5AJJnNI0zx
         BJYha6pbVdw9CdlyOrbLBWOjHtahNR+VvaDn9KWhRwVgwKQZeK2SYcr6qRzli1/Nss3n
         yerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wS2+Os8U5Xqw5DO4Q5hTcwa/1+R2naY8oX8X+CBPw30=;
        b=OqPnv9fSaAMyp/qXQYExymq5jiYBUnT0mVuMuhXaeo0nR/M27JLeFZNOr8n3nvdOhy
         9udrH9H0cpn59k3czYkrquj7toNviv8OKgCV7LyVK6S57Eqy75D0dU+BTnssGu1XRNmA
         Dvo+9dNgqE4zOsSynO5uP/koYuX9GOik/JZtcMDFzigtPJRe8T59LdS8kU+J1KzoXgKx
         bHwmDW1c3wOoU1T+UubHeyBBSNWAct2bbXNx/XsjXd4Cx+CXdosgyH/MQ5szHVgdM8aG
         ncNWuBX9ueZqEF4EX+Dby/blJ/RSj1pQJJnauzmNflxDWfo072vkqxnM3nPLl+7/1Nx8
         WcBg==
X-Gm-Message-State: AOAM531tA1zQLEpuE+1eVLigH18xiQyxd7VgT3B0R65EBGwBOzUdDftr
        k0wCnvEdOu9ij58ktzclB6w5jUgXu5o=
X-Google-Smtp-Source: ABdhPJyj4L8ydMBQtl9P8mkO+LULFuurWz5U0xkbLNF/Vzi2l5aTv/dqqF2Km4Obr4InOCmuRYUaow==
X-Received: by 2002:a05:6512:3c99:: with SMTP id h25mr9064665lfv.400.1629499867133;
        Fri, 20 Aug 2021 15:51:07 -0700 (PDT)
Received: from [192.168.2.145] (46-138-120-72.dynamic.spd-mgts.ru. [46.138.120.72])
        by smtp.googlemail.com with ESMTPSA id x74sm634452lff.54.2021.08.20.15.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 15:51:06 -0700 (PDT)
Subject: Re: [PATCH bpf-next v7 2/5] af_unix: add unix_stream_proto for
 sockmap
To:     Jiang Wang <jiang.wang@bytedance.com>, netdev@vger.kernel.org
Cc:     cong.wang@bytedance.com, duanxiongchun@bytedance.com,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Rao Shoaib <rao.shoaib@oracle.com>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
References: <20210816190327.2739291-1-jiang.wang@bytedance.com>
 <20210816190327.2739291-3-jiang.wang@bytedance.com>
From:   Dmitry Osipenko <digetx@gmail.com>
Message-ID: <424626ed-5a56-9460-8635-5a850da36656@gmail.com>
Date:   Sat, 21 Aug 2021 01:51:04 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210816190327.2739291-3-jiang.wang@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

16.08.2021 22:03, Jiang Wang пишет:
> Previously, sockmap for AF_UNIX protocol only supports
> dgram type. This patch add unix stream type support, which
> is similar to unix_dgram_proto. To support sockmap, dgram
> and stream cannot share the same unix_proto anymore, because
> they have different implementations, such as unhash for stream
> type (which will remove closed or disconnected sockets from the map),
> so rename unix_proto to unix_dgram_proto and add a new
> unix_stream_proto.
> 
> Also implement stream related sockmap functions.
> And add dgram key words to those dgram specific functions.
> 
> Signed-off-by: Jiang Wang <jiang.wang@bytedance.com>
> Reviewed-by: Cong Wang <cong.wang@bytedance.com>
> ---
>  include/net/af_unix.h |  8 +++-
>  net/core/sock_map.c   |  1 +
>  net/unix/af_unix.c    | 83 ++++++++++++++++++++++++++++++++------
>  net/unix/unix_bpf.c   | 93 +++++++++++++++++++++++++++++++++----------
>  4 files changed, 148 insertions(+), 37 deletions(-)

This patch broke Qt WebEngine using recent linux-next (tested on ARM32
only), please fix.

 8<--- cut here ---
 Unable to handle kernel NULL pointer dereference at virtual address
00000000
 pgd = 2fba1ffb
 *pgd=00000000
 Internal error: Oops: 80000005 [#1] PREEMPT SMP THUMB2
 Modules linked in:
 CPU: 1 PID: 1999 Comm: falkon Tainted: G        W
5.14.0-rc5-01175-g94531cfcbe79-dirty #9240
 Hardware name: NVIDIA Tegra SoC (Flattened Device Tree)
 PC is at 0x0
 LR is at unix_shutdown+0x81/0x1a8
 pc : [<00000000>]    lr : [<c08f3311>]    psr: 600f0013
 sp : e45aff70  ip : e463a3c0  fp : beb54f04
 r10: 00000125  r9 : e45ae000  r8 : c4a56664
 r7 : 00000001  r6 : c4a56464  r5 : 00000001  r4 : c4a56400
 r3 : 00000000  r2 : c5a6b180  r1 : 00000000  r0 : c4a56400
 Flags: nZCv  IRQs on  FIQs on  Mode SVC_32  ISA ARM  Segment none
 Control: 50c5387d  Table: 05aa804a  DAC: 00000051
 Register r0 information: slab PING start c4a56400 pointer offset 0
 Register r1 information: NULL pointer
 Register r2 information: slab task_struct start c5a6b180 pointer offset 0
 Register r3 information: NULL pointer
 Register r4 information: slab PING start c4a56400 pointer offset 0
 Register r5 information: non-paged memory
 Register r6 information: slab PING start c4a56400 pointer offset 100
 Register r7 information: non-paged memory
 Register r8 information: slab PING start c4a56400 pointer offset 612
 Register r9 information: non-slab/vmalloc memory
 Register r10 information: non-paged memory
 Register r11 information: non-paged memory
 Register r12 information: slab filp start e463a3c0 pointer offset 0
 Process falkon (pid: 1999, stack limit = 0x9ec48895)
 Stack: (0xe45aff70 to 0xe45b0000)
 ff60:                                     e45ae000 c5f26a00 00000000
00000125
 ff80: c0100264 c07f7fa3 beb54f04 fffffff7 00000001 e6f3fc0e b5e5e9ec
beb54ec4
 ffa0: b5da0ccc c010024b b5e5e9ec beb54ec4 0000000f 00000000 00000000
beb54ebc
 ffc0: b5e5e9ec beb54ec4 b5da0ccc 00000125 beb54f58 00785238 beb5529c
beb54f04
 ffe0: b5da1e24 beb54eac b301385c b62b6ee8 600f0030 0000000f 00000000
00000000
 [<c08f3311>] (unix_shutdown) from [<c07f7fa3>] (__sys_shutdown+0x2f/0x50)
 [<c07f7fa3>] (__sys_shutdown) from [<c010024b>]
(__sys_trace_return+0x1/0x16)
 Exception stack(0xe45affa8 to 0xe45afff0)


