Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470A534D7D3
	for <lists+netdev@lfdr.de>; Mon, 29 Mar 2021 21:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231637AbhC2TLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Mar 2021 15:11:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231594AbhC2TLX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Mar 2021 15:11:23 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13A4EC061574;
        Mon, 29 Mar 2021 12:11:23 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id d2so12107409ilm.10;
        Mon, 29 Mar 2021 12:11:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=IkMFSnrueBedhHaH58r/hTpSZQNhWKbrqLUc7REi4TY=;
        b=u9Dpku76OzPnq43KVDt+WKOH7m0+FwXkcntNsgLS1jKALtZpMsrd3Nn7YNQ6Jl2Bf7
         UtvEbWWamenXHa8Y46gKKgMK0g7KpTHBOr9PoWxcLYzQ0qb9ai/VrKFcmnHuRb2wyQsz
         ndtDGowO8mxsAh9HV4PEmCUn0km2f+XzIY5PHBh+mbPxRMawAbUsd1LqkDMuFZCp4DQ0
         W7hZxxEiwIl7TIrQxzFygP3MndqtbCqNAbrAsqttYrUWg47RD2geBCrcjkjSM6ar2mSg
         RGzKe5H5ANhZrPmZ3KI+yXu6w93eEpNn5QFMRCugRC1ecdUICQ2ienkfY+SoWqAnUl7v
         ogFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=IkMFSnrueBedhHaH58r/hTpSZQNhWKbrqLUc7REi4TY=;
        b=aT4f/MOXL8L/ftgjeNXlGWBxy2cMGAlNizAX5nio9C8gN9U/T7gBhoWvco7gnbROrQ
         0Fo0AQbCt6U3wF6IxkIPsw85GDcz8eZSZWQBp4zCKsUMBDom2U4r4PQ3yMMlVyhII2rG
         xkzY5J81U/KRup6VqajXhsrQEuSoReX9NnBrGMLV3FLjZa48VWaiho3Sd0jNzNB4uysK
         E5doaul0jRdKEcbIYeIjIxAZKBFaVhr/yA+rL1dlSZ1c78Tl10O0q52xiq+5MZ0o62K4
         MjpmNQJkaial1mCKC3Pmo0eu5bkfZJEwfN4saGwade/yhdJpEny2mJUNaqaV32nR/uUa
         YHyg==
X-Gm-Message-State: AOAM531wEqTwCFyrpNajR43fZVHmSRs594+b86zooRKMTuTSxN0bXMnc
        fAsA1V5Cl1fL7bB7LqqX4E8=
X-Google-Smtp-Source: ABdhPJzkJyYTxey1keHMV2hNBJ59deauU75Gr6CAkk099SwyFxvY+g7s8ZB0OdOEcdJ+JVoU3fb7tg==
X-Received: by 2002:a05:6e02:149:: with SMTP id j9mr13684017ilr.57.1617045082530;
        Mon, 29 Mar 2021 12:11:22 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id c5sm9958682ioi.0.2021.03.29.12.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Mar 2021 12:11:22 -0700 (PDT)
Date:   Mon, 29 Mar 2021 12:11:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Jakub Sitnicki <jakub@cloudflare.com>
Message-ID: <6062265295db9_401fb20861@john-XPS-13-9370.notmuch>
In-Reply-To: <20210328202013.29223-3-xiyou.wangcong@gmail.com>
References: <20210328202013.29223-1-xiyou.wangcong@gmail.com>
 <20210328202013.29223-3-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next v7 02/13] skmsg: introduce a spinlock to protect
 ingress_msg
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
> Currently we rely on lock_sock to protect ingress_msg,
> it is too big for this, we can actually just use a spinlock
> to protect this list like protecting other skb queues.
> 
> __tcp_bpf_recvmsg() is still special because of peeking,
> it still has to use lock_sock.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
