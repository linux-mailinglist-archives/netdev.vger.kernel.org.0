Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B50632AC6B4
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729776AbgKIVNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:13:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgKIVNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:13:34 -0500
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com [IPv6:2607:f8b0:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26E05C0613CF;
        Mon,  9 Nov 2020 13:13:34 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id n15so10395638otl.8;
        Mon, 09 Nov 2020 13:13:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=6LKRrsHdKXReU3TBe4kSaTHSrqPQkgh4JeE0J2CjMyY=;
        b=CXN2E3frsn+cCVTsSnV673WZp61jCIMgfSv6QI9DXWiXiLz/Yp11yTXT1ovx7Y5s2Q
         /EqywseEPn2DEwoHKzjwHw0E7A0dq2e4UAugtaVASRrF6GUibbzFqzchfT/RuXHoWJt0
         12cJU7cLwdzG1K1eC+xvdRO40XrICmd/YpMztxi54w04w+VXXCARMaAVzxbDoViUiO1x
         ozhPgOMwVp1uCgq8XnVYHnqRU9fWAAru6ID75oF4xMmxTskCC0ZAE590vWNSwk7C3bkp
         mjiv3s2aI8IPsjPnVmhT92Ec1Kk6fu+vZ54KIorDvtPt3HCrDTAz/TuktImmEwpJhnTE
         6pww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=6LKRrsHdKXReU3TBe4kSaTHSrqPQkgh4JeE0J2CjMyY=;
        b=DJBkOi7HbkYNgs6VrLa8tDWYR6fe26IQfbbslhbIH7uUHZ3TuOiVqF7UERmEXah2gK
         obPwEr2WxpnU/KrvYVbCCxaa7qEN+aiBwutMMaZR6eXpz/N10X9LiTrnAnjg3kjN1q7G
         b5CE6rtD6xMZgxVpsCnUv0wUCXoB/qdo6A+DZsED5eCxeaGCkpZhomqFBRN7lHPYm9Ce
         yTunwrN4UZiYbHyalAAfkqOR9pBwvrCGi9WoDNEtY0Ctt+tkfqoTVr4EwOABW3PRxlty
         b6jLCTBnFXpVoi91Pustnk+lRI73r0r0IWTrSYcD3FDdSa3SJMtiWcV3lNiama9axloP
         xn4g==
X-Gm-Message-State: AOAM533vc0uYMNXT682zLRJgTgInaPvs7dD3xMLHcIPIaWCae1Z/LLS5
        IO0hqjm/xxQErUdhnn2N6Lc=
X-Google-Smtp-Source: ABdhPJy3euBqWwt6vcBeSL7pSg+brIV2jPE3uZQKJdyOd0kLBc3wPOCJ2d4PkLurDVxKobEBFQAWzw==
X-Received: by 2002:a05:6830:2058:: with SMTP id f24mr2457111otp.250.1604956413401;
        Mon, 09 Nov 2020 13:13:33 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id p17sm2664084oov.1.2020.11.09.13.13.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:13:32 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:13:25 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Wang Qing <wangqing@vivo.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Message-ID: <5fa9b0f5eb2f6_8c0e20854@john-XPS-13-9370.notmuch>
In-Reply-To: <1604736650-11197-1-git-send-email-wangqing@vivo.com>
References: <1604736650-11197-1-git-send-email-wangqing@vivo.com>
Subject: RE: [PATCH] bpf: remove duplicate include
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wang Qing wrote:
> Remove duplicate header which is included twice.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> ---
>  kernel/bpf/btf.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index ed7d02e..6324de8
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -22,7 +22,6 @@
>  #include <linux/skmsg.h>
>  #include <linux/perf_event.h>
>  #include <linux/bsearch.h>
> -#include <linux/btf_ids.h>
>  #include <net/sock.h>
>  
>  /* BTF (BPF Type Format) is the meta data format which describes
> -- 
> 2.7.4
> 

Looks fine to me. But, these types of things should go to bpf-next I
see no reason to push these into bpf tree.
