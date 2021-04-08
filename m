Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9759B359059
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 01:33:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232903AbhDHXdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 19:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232488AbhDHXdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 19:33:16 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDD8AC061760;
        Thu,  8 Apr 2021 16:33:04 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id x17so4056526iog.2;
        Thu, 08 Apr 2021 16:33:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=g0MO//g1eHnuGjQMGpSJYn8kcxA0ivKNFXwqru0lxHc=;
        b=ZKvlJr4IeCDdIBM++NJhgqzfu3Af6Cj7e8GzHXycvwK8ucjrmsoYH3mEaEeAehWVyr
         DDUJDFWg8najFWJx53WuAYEgOA5TzpE0HwdV0BakXbdEQX8Xj3kWeQ3Pma1wvYkBVJCX
         nelk6BXPLD8setxBnprzXlcmAII5drfb4GLZpStms949BYoItzxQ/U4sSydQwi1lXvBa
         JZbTJSLvEy3zubz2kQZGqVd6EtPv5EYBaBPtrpfcEToGfRBoTGUF2kGkWMeWdvDoervE
         o1dxb1M9lK38ZzvFgAV0t8O8Kaw0QOC6C799SSnVGO1oxMaGTDX9hw4DkioCrVfLOhl4
         t9pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=g0MO//g1eHnuGjQMGpSJYn8kcxA0ivKNFXwqru0lxHc=;
        b=pu7UuSan6GTykRAPdopPf0YeMZK6V/2hJjHyU6VJMHqAccyCkSbAPYUtZ+1Rjzwlw1
         qHV1TPQ1si1T3h6eEmYDtjbtGx5GJHX/jfU8kYUVM3thXDBpL2WyMi7UiLNGoUfpTCo/
         AObc0MPoqJ6yKhe8/75mr1Kr2QYss5fa675inxsuHMhlVchOn8nZz9cG031elZJtG5g4
         4IF/0TZKX+2g5AcEccHx3qXY4PijBp7dtIoaZHCnrzQfeiPYu3TnZIWcKpT+UyG6feZQ
         nYZuR8awMjBdMupJ8Qw+jT34WvYYa1CmpmNLJvHgtsItsIiR8tEYCAaLvsqaXCfJvJ1L
         FEfw==
X-Gm-Message-State: AOAM5336gttxB11Im1M3PQBpH0u//GBH1rIWXantQwLfjISglwmxIB9U
        JBPX0s67r2QCVxm4ysNpdOCshZJOiXw=
X-Google-Smtp-Source: ABdhPJzMGT86b9iJfydFPddWRfHNaJTuccMh4WktLlg0JKYmcu6IeZ2T47t2dodrUOeDCJ6jicpCyA==
X-Received: by 2002:a05:6638:3013:: with SMTP id r19mr10462001jak.36.1617924782876;
        Thu, 08 Apr 2021 16:33:02 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id x5sm441405ilq.6.2021.04.08.16.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Apr 2021 16:33:02 -0700 (PDT)
Date:   Thu, 08 Apr 2021 16:32:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, Cong Wang <cong.wang@bytedance.com>,
        syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com,
        John Fastabend <john.fastabend@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <606f92a74c10a_c8b9208c1@john-XPS-13-9370.notmuch>
In-Reply-To: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
References: <20210407032111.33398-1-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next] skmsg: pass psock pointer to
 ->psock_update_sk_prot()
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
> Using sk_psock() to retrieve psock pointer from sock requires
> RCU read lock, but we already get psock pointer before calling
> ->psock_update_sk_prot() in both cases, so we can just pass it
> without bothering sk_psock().
> 
> Reported-and-tested-by: syzbot+320a3bc8d80f478c37e4@syzkaller.appspotmail.com
> Fixes: 8a59f9d1e3d4 ("sock: Introduce sk->sk_prot->psock_update_sk_prot()")
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
