Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44460312BDE
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:35:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhBHId2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:33:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230208AbhBHIdC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:33:02 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2870C061786;
        Mon,  8 Feb 2021 00:31:49 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id q7so14138940iob.0;
        Mon, 08 Feb 2021 00:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=H4KQnnRfuUS6L5EuXTX7dTJKZCfdg+xUKV09H4GebIs=;
        b=mk1RI+29Jo+rI8yhFAB3a14e8aP3omHGJ81j8B5Yl17Xmudk/Ao7XP3yg8nlUpAHwT
         eFheBQTxvGXzUI9tXf2JJNmh2v/y3jHezhKehfwbtBjGbOdTUco06hjz1jAFlMXhKY/W
         p3rYim9hjUKojmvKZorYP62LuNh/k6U02FyjOS7G9x0K2u5azL1ghRvBjYaKXEnGDhyn
         Ids/i2hwar5xvkcUtdLutaJtO5+EuTOsO/frGgJfpK32YTXRDK5eLC1L75WLal9C3sbw
         ok7Z3j/eYb6LuFpHDKy4EZ8wx9NDlNpYTHisKObhyUb/3Vx3APFUkc/zSXi3UOXNdvGb
         vZxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=H4KQnnRfuUS6L5EuXTX7dTJKZCfdg+xUKV09H4GebIs=;
        b=l1sevE0D683UzjDlD0S9cufY9jgdU5RLsIu/ZJJExZ+WAJHGgullLa/mzScIJJitl5
         Csmz5VRwBmCICwpNXoyFuCJ23w9gK4J2VrDHU4w0NAKLy1e9CCikfl25mIeqynBSlyOS
         IMIKxn39XhmH62tQM6dJG2TkDBKJALyXnFASlJZrtb7FUBNRfjgzD5vKT0oolxEc3OVN
         tBmAKP/zBe2NRxa/nWkW0uUVB418Ek49E0HtvN7d2VuzSmoz0WdkN7nMHgYaTBcAWr61
         JUuALKmZGGKxbgvKG9CDDDyV0iy2IKTKjR0d4MY5BYaOC5O0LMlLN3ZSaItYpMrkoVtL
         4sXw==
X-Gm-Message-State: AOAM532Pq5xs8zaudxnI2Is9xLVYSnUAPv9AiiNZTBYTwUbAczjbxvf+
        OZYksS9s/q0+jI1gNE7q0qB2LzOdokZ28w==
X-Google-Smtp-Source: ABdhPJzWnxWtmOxz3tQPsspWrZD6Iqb0dESC0Cr+PBYoM3uBo0bWtusdFLZPnC4STosJgc0xApID6Q==
X-Received: by 2002:a05:6602:21c6:: with SMTP id c6mr839903ioc.94.1612773109059;
        Mon, 08 Feb 2021 00:31:49 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id m11sm8551511iln.44.2021.02.08.00.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 00:31:48 -0800 (PST)
Date:   Mon, 08 Feb 2021 00:31:40 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6020f6eca63de_cc8682084c@john-XPS-13-9370.notmuch>
In-Reply-To: <20210203041636.38555-6-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-6-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next 05/19] sock_map: introduce BPF_SK_SKB_VERDICT
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
> I was planning to reuse BPF_SK_SKB_STREAM_VERDICT but its name is
> confusing and more importantly it seems kTLS relies on it to deliver
> sk_msg too. To avoid messing up kTLS, we can just reuse the stream
> verdict code but introduce a new type of eBPF program, skb_verdict.
> Users are not allowed to set stream_verdict and skb_verdict at the
> same time.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

I think it will be better if we can keep the same name. Does it break
kTLS somehow? I'm not seeing it with a quick scan.

We can always alias a better name with the same value for readability.
