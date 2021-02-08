Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88216312BAD
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhBHI2V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhBHI2L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:28:11 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31C7C061756;
        Mon,  8 Feb 2021 00:27:30 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id q5so11961206ilc.10;
        Mon, 08 Feb 2021 00:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IYjYPV5QmtnO79p+zl0S6mt47duqcV21Aa0O+5kiDl0=;
        b=JHHk9Msx06dv+AG30ZgBzN5s0NCYVkhtyOaGYUFBOh1IpGrCsYIvHgIkjdLumGu4v5
         zwUEr7EVwJekvaGviyvT+eBY/BLS57LKMOByhyEryFk+iBVyYXPvO91Zxv7K+RuFhMAW
         VFo543h1RcqGS9bxWbIjgAgU2UJr7fWulbrXugp9KdB1WF5LLeOhUEsxMj0oCY9Yp0Th
         mzv/s8iIGVo+jRDC8HIxeh03DQp4rj8QHrLjAIENPKNGGdLO5PJkjrDuAwVo/vsB7cdp
         0ToOx8GN3WDSQUNwFIWV11ovAtF83aM+JVlLuJjJKgyqzukR5r5JEd+q4vctckdkL1XO
         C3Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IYjYPV5QmtnO79p+zl0S6mt47duqcV21Aa0O+5kiDl0=;
        b=ZAnv9V1EhSv4M8dMhDqK69fZKAjvsaOdONkKBqi5g1DPADsxqX5uIpshl47hDzetiX
         PjITVYWvPxNRlrMFrMO0K0JHNacKMymQNSgdzilOgz6UVy1u/gepdSqcYMqabr2WsOXf
         4v+jvhfGHkLZd66V9VDVdMIr++aZvHsvUsaqo5/CSTK/ArP/KZmZ3pue/bdC5jPKoaWq
         /NZ9M6PB/eXjOMuCNxqU6CVErTBfIEoIm09VYvEArLrdMFbpoewEY1QEQ47Fa3gD7+vG
         UwSoAhycY1YWx09VBLWLQsG8Lsk+dU9eyUwuibhTygsX0K2m33q12PyjEKF72nfRMYNI
         gRrg==
X-Gm-Message-State: AOAM5326RHyz0d4B10LMKuyn1Nujf1zp5naBNpkrI1jvSGpFoSw9lAlJ
        5IYriyDGxLbj5qRRUO11E+M=
X-Google-Smtp-Source: ABdhPJwJUH3shI1zxtJ+bya2cjgLg6AD2adKDMDZmGK43yH+mMXXgHfoUB201ts8P8S3FPkgfs7dug==
X-Received: by 2002:a92:cd81:: with SMTP id r1mr14602202ilb.252.1612772850320;
        Mon, 08 Feb 2021 00:27:30 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id t6sm3461921ilf.62.2021.02.08.00.27.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 00:27:29 -0800 (PST)
Date:   Mon, 08 Feb 2021 00:27:22 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6020f5ea24078_cc8682086e@john-XPS-13-9370.notmuch>
In-Reply-To: <20210203041636.38555-5-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-5-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next 04/19] sock_map: rename skb_parser and
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
> These two ebpf programs are tied to BPF_SK_SKB_STREAM_PARSER
> and BPF_SK_SKB_STREAM_VERDICT, rename them to reflect the fact
> they are currently used for TCP. And save the generic name
> skb_verdict for general use.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>

We've recently added support for running a verdict without a stream
parser. But the rename should also be OK, then it will match the
prog names which is nice.
