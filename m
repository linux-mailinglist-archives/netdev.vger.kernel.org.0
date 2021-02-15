Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E63F631C23B
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 20:12:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229764AbhBOTKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 14:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhBOTKI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 14:10:08 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FEDEC061574;
        Mon, 15 Feb 2021 11:09:28 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id u20so7792197iot.9;
        Mon, 15 Feb 2021 11:09:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=+iSFnwZDqHzel2EupBWqWFgjxdKdshK6b9ZbgQmOaGs=;
        b=u4/ZBTN49aQkxbwTEUoyrxiGRfHZ5FQ+//1XPbCI//hL2HqDMbclQxLbW7VP8Do/nt
         s19WkNFkaVS/GlbNIdkSPBVv1eIxOo9Il2oWIUVQNfkRl8144rt5hQaIIA2anP2BRzwj
         qa6BPjcRMU25g7Px5pnwM3B+nYxHARVVeHloQM7yj09AVZHScORtE2aEeoG1dPr6H+Kq
         4At/uBWsna6J2/v87VGpzosw4Li1z+P3ITLQ820/jKy4TUARQxocr+Cnue9asQv2lxas
         sLsUE7hCxkR3MW5KPeXZNfNyR0VINJQF2+B/lFcKkCCsZglwh7HdX5MOlU2xV7kfpx3q
         T2Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=+iSFnwZDqHzel2EupBWqWFgjxdKdshK6b9ZbgQmOaGs=;
        b=Iqww9DOKjp7lOtEX61/nB1Y41F8xFpssdHC4NdOHXMVQcltGhm4pHaTB3gQKQdPFDY
         7EwBoL0rzBXYp3HmpzapuCDh8RWHRhidoknQzm5KWfPMAiqdLXXLKL+tap/pOjp3LvRU
         fZ6eNuYpWpxO1kW7oI3L9A4K+MMzFowGfh0PxDB1rTwLLfPK+o28KHB3BqTxygTY2MbE
         +hX1iELaWp6jRGR5PfsZnC0EJ+FuGP3LKJThtd0G+28y+NYlqJV6HiWlPJN00pavAvlb
         JemDk1vwCaWAIi4E7SsG+OdKOMETi60/Mnt/0VukWWCmjhgupPy/sGPbI4pyHlYcr6DC
         5nMg==
X-Gm-Message-State: AOAM5336lts+zmu+34O+7V50ceUfXgAGux9omd/YiLAbAY34yEW7H7ey
        RQaqHi3mjOjZMfmoa1rKkZ8=
X-Google-Smtp-Source: ABdhPJyVrRDz+mBKu/VJs65+ygptlSiJPtJq12BsFX/yvWxBP6RuVP7kNbe/zOlasZv4isVCJVXKKA==
X-Received: by 2002:a6b:b44b:: with SMTP id d72mr12560833iof.55.1613416167604;
        Mon, 15 Feb 2021 11:09:27 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id s6sm9786664ild.45.2021.02.15.11.09.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 11:09:27 -0800 (PST)
Date:   Mon, 15 Feb 2021 11:09:21 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <602ac6e11579_3ed41208af@john-XPS-13-9370.notmuch>
In-Reply-To: <20210213214421.226357-6-xiyou.wangcong@gmail.com>
References: <20210213214421.226357-1-xiyou.wangcong@gmail.com>
 <20210213214421.226357-6-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v3 5/5] sock_map: rename skb_parser and
 skb_verdict
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> These two eBPF programs are tied to BPF_SK_SKB_STREAM_PARSER
> and BPF_SK_SKB_STREAM_VERDICT, rename them to reflect the fact
> they are only used for TCP. And save the name 'skb_verdict' for
> general use later.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
