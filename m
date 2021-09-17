Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32EF9410155
	for <lists+netdev@lfdr.de>; Sat, 18 Sep 2021 00:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344770AbhIQWgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 18:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231624AbhIQWgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 18:36:01 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95EC061574;
        Fri, 17 Sep 2021 15:34:38 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id h29so11912470ila.2;
        Fri, 17 Sep 2021 15:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=rzVScc/3fhxtLP4lpidcQPT7ZyYnaMhrA6du6nm5lkE=;
        b=DiCyntqNleRWupMrnr+b5Ruvq0fYk874Zi0OoUAw7wPJNAdDWvLdpS+2ebLboWw5k3
         aQbljm/j4ugc8FSjVtaWR9xvR+aUEoenOgPFKL/XgHPcodPOu37pyQFEx2ZQ9vz7WV1R
         DDVN0F2NkakA83/mpKRVBNZX5tktCB1WAAAE5N1VM0p42cIFNyN2BI0JezPsFivnq/nb
         7vgC76bEdyl4QE3JBAiiSjNNYXZItfua+TUPFyhDq+SiYfNUBLQo6F+g86bgSkxbD/zD
         Ey2FQRPW408yvaWqg+nkW/Qs51T4gs6LxbizCSbRzBhArhYCnvpEkiNlJs30nwEc8KrY
         2OfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=rzVScc/3fhxtLP4lpidcQPT7ZyYnaMhrA6du6nm5lkE=;
        b=kaD6PrsZuKywrqGUYhvbCSUc/Aq2+WhyfWSFGn9NNrn/MJLQ+vIG516PwM12sIc5Nv
         +D9fayRAoLeFdYoZ7UTanxqQW5eVfGtGNY1Kt7vtfPw+asnWfckbGYCpP0/TC8AmmntV
         0bLRdzRScx8CwqHSYQFSH4vQY6SbCBTznCMnqz7CoEZVz8r9uiWzK0/xJFsk6Q/uN6mc
         sjzBCzsQsi0A39XC+HIEsREaJR+5CwXP7QSSQePVMjWXfAxm8uDqSGVkq/isnjzwN+PZ
         pILJfFoEuM0y92iUnphVPFzrfyDgMWN9y/S1QUD+mJVXysXRqQAEF9j30jbsA6+K9KnI
         Tz+g==
X-Gm-Message-State: AOAM531iaE1fH62oe+ddDEO4er1PjXL3itSVW1rnhLEEaehhbPenAJdK
        fQKgeN3ZEjtNajxRMvr/RLg=
X-Google-Smtp-Source: ABdhPJzO/UwzioGL+88d2ZKgwGyqGd0ooIXS/evyvAW1pwmV/JiA9IO7K3L0PgUHe1Fw6PfELbPFmA==
X-Received: by 2002:a92:bf01:: with SMTP id z1mr9265689ilh.155.1631918078114;
        Fri, 17 Sep 2021 15:34:38 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id i14sm4092619iog.47.2021.09.17.15.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 15:34:37 -0700 (PDT)
Date:   Fri, 17 Sep 2021 15:34:29 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Liu Jian <liujian56@huawei.com>, john.fastabend@gmail.com,
        daniel@iogearbox.net, jakub@cloudflare.com, lmb@cloudflare.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     liujian56@huawei.com
Message-ID: <614517f5ed44e_8d5120847@john-XPS-13-9370.notmuch>
In-Reply-To: <20210917013222.74225-1-liujian56@huawei.com>
References: <20210917013222.74225-1-liujian56@huawei.com>
Subject: RE: [PATCH v2] skmsg: lose offset info in sk_psock_skb_ingress
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Liu Jian wrote:
> If sockmap enable strparser, there are lose offset info in
> sk_psock_skb_ingress. If the length determined by parse_msg function
> is not skb->len, the skb will be converted to sk_msg multiple times,
> and userspace app will get the data multiple times.
> 
> Fix this by get the offset and length from strp_msg.
> 
> Signed-off-by: Liu Jian <liujian56@huawei.com>
> ---
> v1->v2: fix build error when disable CONFIG_BPF_STREAM_PARSER
> 

LGTM thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
