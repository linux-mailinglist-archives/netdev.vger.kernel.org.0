Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0361B349F5F
	for <lists+netdev@lfdr.de>; Fri, 26 Mar 2021 03:12:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhCZCLd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 22:11:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230413AbhCZCLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 22:11:22 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94656C06174A;
        Thu, 25 Mar 2021 19:11:22 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id f19so3945765ion.3;
        Thu, 25 Mar 2021 19:11:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=vqxRIZFQNDcMWXEa6+tKs5ETE2AGfhIkuRAIOobuQsY=;
        b=ZhZjJlcACvaIq9lQO4WWMmEU97ai4sKdt+GvGg6XlCR5BS2zl0WHy2TPsXbQAK/IU0
         lmQ0CKRf7Vq6etkR70pKq33k5+oDTMrnPR0VVkXXGGXQELEuUZAH9gxo/QEyaQRDkQQM
         h+qkR4gcnxxpOXlOa716U9rCMpmvWxuZIEWRhiB+uP/+vfRledJ+ZAQRUEqRAzm5a5id
         LBSWeEakz1feO1aPCytsg01h9FehgRYNhhAc9EAUVqNnZX0t3kPsOelpEdX9FjyBKqIB
         n2f+l4D7MIlsrs8rgdhufcYD/QF1iy9VN27vgLNGUpM8MHyRFNaGbGyk2u3fVSWkVlSH
         Wwjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=vqxRIZFQNDcMWXEa6+tKs5ETE2AGfhIkuRAIOobuQsY=;
        b=X4M6xZm7GG3KvO+FultbCya0LyheEH5ykdfuBgK+qBU8eS6xLCA33Vitv5nC4NMdtv
         d+Ykm5nEokqtYYkNrngkr3IR+lcCByI/w1+50bsxm9Ka4JABXlbYpc6aD/M0OlXjh3Tv
         Q14kEb4XiZiLyndPUaRVbt7u2+3eJO2EtX6LZzwrE15DN1TLn1QMOy8eUUo7S+VIa+7J
         /jbB4PyJhOwBny0E+pR5sRnQ97M8EwLjSHA7uq4vEDRCgbYkr4nIFIbUhbmuAxDCi69c
         GLHD6u+OD0D52ZfJGPaFeqMBWIw5CKUSD1wQUPPnrj+ucy9VRm2sXvQp9R42YNrDF7KT
         PONg==
X-Gm-Message-State: AOAM532y3lMSvP29gL9yEGKUC+/3bsG+ymODq8ayiIrNL+iFoz5K0h8P
        RJY0mpByGId+GR8syu72phc=
X-Google-Smtp-Source: ABdhPJxGPuVk09QQ9ZvaagLPt/OGgVTegRmdHCI6JY/OyPdEKp/NYRPpDpTiRRLhZDnIHvV3gc19xQ==
X-Received: by 2002:a6b:3a82:: with SMTP id h124mr8394127ioa.207.1616724682188;
        Thu, 25 Mar 2021 19:11:22 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id i12sm3467739ila.1.2021.03.25.19.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 19:11:21 -0700 (PDT)
Date:   Thu, 25 Mar 2021 19:11:13 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <605d42c15b958_9529c208c1@john-XPS-13-9370.notmuch>
In-Reply-To: <20210323003808.16074-6-xiyou.wangcong@gmail.com>
References: <20210323003808.16074-1-xiyou.wangcong@gmail.com>
 <20210323003808.16074-6-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v6 05/12] skmsg: use rcu work for destroying
 psock
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
> The RCU callback sk_psock_destroy() only queues work psock->gc,
> so we can just switch to rcu work to simplify the code.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
