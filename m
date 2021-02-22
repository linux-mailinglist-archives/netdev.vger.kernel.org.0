Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BE03216C6
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 13:35:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbhBVMdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 07:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbhBVMcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 07:32:50 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 637DDC061574
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:31:54 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id i7so7347571wmb.0
        for <netdev@vger.kernel.org>; Mon, 22 Feb 2021 04:31:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=EvbKa7XJGdz4kFxj0xgQrSvGaK3M1EXJEdfK/OKwz40=;
        b=irWFBXNd21ZhAJIZgZcGzBzgqGVAdPcd1DZfOQ7/qMHSW0RqdMn7Hosxv7YpXpH2gX
         xCQPyQcEubqyB06I5QmK1PE63/o5JamA46N8bByADOuwYcYC9fXJN+umDI4gjgrOTlsK
         H23QLdlrFK6Pxw7R7VEI/Ce2VTMg7t2hSMbak=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=EvbKa7XJGdz4kFxj0xgQrSvGaK3M1EXJEdfK/OKwz40=;
        b=BNce9u1XBtUazKUTzdWltZA3VC0wmWoUmdxm/ea1pQd0NBGT5abFgH9xuowyYd2gQY
         di3omS6p5/zt3wFkFcAIB8eAWnBdY1ZQzBh+q4KBdLYT4vDfft7ti4+FiE6i69b+tUXu
         4uXqlk1oCA+QFiCnIIO5+O0243+t8ggtXEyWwd3rTXGbnYWu0Vz8csbGSCjaKebt7jcm
         psLL6u7S5XfzdDWwKg96wNad2PRgBtTlwJYqiqV9s4e6/vVbBHJxwn9oAMFjDM4VxO46
         fayRQCjvV/QbQTzLjw1y62zBo2vPuTPc6mcxo1XHEqXtFMBmVRBiAEJtyc6YrkNPUcDI
         6kGA==
X-Gm-Message-State: AOAM533ROLx/f6gTGO+fPZIrT1Qlj9faJStkHAfZhuTXMbFd4AgHgzRP
        G1YkRwtz0SFqeqhjuwZBZJ36Mg==
X-Google-Smtp-Source: ABdhPJx7pxQF1bPVCG5YEBgV2yOEvjFFl6m/a6186WQl289/2v7b5lyigLtVEF+zRCNQltDEkHBxAg==
X-Received: by 2002:a1c:3c86:: with SMTP id j128mr11901821wma.40.1613997113122;
        Mon, 22 Feb 2021 04:31:53 -0800 (PST)
Received: from cloudflare.com (79.184.34.53.ipv4.supernova.orange.pl. [79.184.34.53])
        by smtp.gmail.com with ESMTPSA id n66sm26448246wmn.25.2021.02.22.04.31.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 04:31:52 -0800 (PST)
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-9-xiyou.wangcong@gmail.com>
User-agent: mu4e 1.1.0; emacs 27.1
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [Patch bpf-next v6 8/8] skmsg: get rid of sk_psock_bpf_run()
In-reply-to: <20210220052924.106599-9-xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 13:31:51 +0100
Message-ID: <878s7g472g.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
>
> It is now nearly identical to bpf_prog_run_pin_on_cpu() and
> it has an unused parameter 'psock', so we can just get rid
> of it and call bpf_prog_run_pin_on_cpu() directly.
>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Cc: John Fastabend <john.fastabend@gmail.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

Acked-by: Jakub Sitnicki <jakub@cloudflare.com>
