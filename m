Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8C6B23B1FE
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 02:58:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbgHDA6E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 20:58:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726398AbgHDA6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 20:58:04 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA40AC06174A;
        Mon,  3 Aug 2020 17:58:03 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id t18so32801444ilh.2;
        Mon, 03 Aug 2020 17:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=xuKB4Q6EgWPMUKasTGGb5FbRSxZkSLyN5EO934w53Zk=;
        b=bgo0q+gJYjZVXoEln9y99JBVWhlncQBFrqrEPhVLx7Zg3jEtRU4dCcGEtx5+n6AbZs
         9gI0CCX+AbvyVNSVEAqJN7WlWsrqkAC4g1Ywxp0WfwHwiK8iRJsfQFknh179keKXMByI
         rwdEkyzvh7QqucILse5i9vLAY2SAwLcwQSH5wQjN+R/qgYeI7akOm00KpSAdmU904FMc
         hNwbtqhrA7y2n+hX4Ufgbv/kIwT91F6k2vipHWW01MWj5efAoLrDQDKxUGIzR5dAxxCi
         ZNz0KekIv/CIPgIqrDOrp4aKfMsxBqpJl5PQ3HCcyBtTdfddc01+mtJlq4d4k/IFSiiM
         nEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=xuKB4Q6EgWPMUKasTGGb5FbRSxZkSLyN5EO934w53Zk=;
        b=LBWfbIFx1ys5rMs2DR9gP1pRYE3LoRoVHx9/ZZevGmFwmtWHqowbuQvRFuHAYLpTRP
         4GkJCXKFyIjuk8Jn0yEx8BwHS5r2ofPvT3SgzFlEN9oBVFQNur8XqPdaukMnqZUDbPx+
         a9+GpZx5OPXEM/JqSA6NR3Xtxn9CuXrhHnCY/n3AJu31c7qOAfafcRx7fR18F9HJ81Vq
         lSL4uLfB42RzyKK65f+GkYCghodQucv/2yVeP+5pG1fum6F/P0BV/GoPPzxgcha8ituH
         E7gOooV5g5H9nNJX5OZqEz0YpDAOGoc2bVb5UEfOrPRISiT7Pnd4oon5s2vOnqJoh6Dz
         Xt4w==
X-Gm-Message-State: AOAM5301qKxAoJKwidQaAPGRTIwGHmdgco0N7/JmLJH+uh3IcfA8uvF4
        oIKASdpM2kxc5+pJe9W0qPMJQ+Fj+TU=
X-Google-Smtp-Source: ABdhPJwXK/wNCWtx+vcfAqcg3vvBsqb4OJf87s3Oy7g5jWvLHKZM14o6KyoO+66JYVRcN0QueYNTrQ==
X-Received: by 2002:a92:d4cf:: with SMTP id o15mr2307744ilm.25.1596502683382;
        Mon, 03 Aug 2020 17:58:03 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id j13sm9066676ili.57.2020.08.03.17.58.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 17:58:02 -0700 (PDT)
Date:   Mon, 03 Aug 2020 17:57:56 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>, kernel-team@fb.com,
        Lawrence Brakmo <brakmo@fb.com>,
        Neal Cardwell <ncardwell@google.com>, netdev@vger.kernel.org,
        Yuchung Cheng <ycheng@google.com>
Message-ID: <5f28b29440d41_62272b02d7c945b48e@john-XPS-13-9370.notmuch>
In-Reply-To: <20200803231026.2682120-1-kafai@fb.com>
References: <20200803231013.2681560-1-kafai@fb.com>
 <20200803231026.2682120-1-kafai@fb.com>
Subject: RE: [RFC PATCH v4 bpf-next 02/12] tcp: bpf: Add TCP_BPF_DELACK_MAX
 setsockopt
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> This change is mostly from an internal patch and adapts it from sysctl
> config to the bpf_setsockopt setup.
> 
> The bpf_prog can set the max delay ack by using
> bpf_setsockopt(TCP_BPF_DELACK_MAX).  This max delay ack can be communicated
> to its peer through bpf header option.  The receiving peer can then use
> this max delay ack and set a potentially lower rto by using
> bpf_setsockopt(TCP_BPF_RTO_MIN) which will be introduced
> in the next patch.
> 
> Another later selftest patch will also use it like the above to show
> how to write and parse bpf tcp header option.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
