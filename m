Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2F13D9574
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 20:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhG1SoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 14:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229603AbhG1SoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 14:44:06 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13688C061757;
        Wed, 28 Jul 2021 11:44:04 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id f8so110381ilr.4;
        Wed, 28 Jul 2021 11:44:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=wmPIkTYbBobxWST6LQmuVMQlTMfaFfpDWmYgKkRXHwc=;
        b=B5HLLOOX3RBe9jiWrKNNMO2OKh7Ye4afxIPULkl2/NweBu6n3f9QZEtvc+T8uTyXJs
         OTXXqCzXmRlkcJIAAet97y5NJoacWjw/hFxkxwMne/N3K5rpFRP0j3TP7Pm2/wtUObTI
         pLPuHTgkvTuRi6uM4802fHY9BD93+6AbSOKrs0jcCbOAuyki/oKa9g78EPWJotWdflIo
         kdnManes6HZ9PUjCiYkg4Ujs+jXgDezgqGTm1DAKvZ7bkPYqZD3DZdLxqO3czBSOXDbY
         GLQW1snU4Y6Kd+dY/FUCKeCU7ZyskNjlA0qv1DSsJHnLEKvIW41MuPMeqNuYYybweBKy
         B0Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=wmPIkTYbBobxWST6LQmuVMQlTMfaFfpDWmYgKkRXHwc=;
        b=kFfkSugglJ7RZ6OXE7XaVmYuF/IY5TCRGjJKRCBkkrClpbAeZUOhe4HN3IXRj79O/m
         wBkh9FTgo5SFCIHdA4xYJJjM/xq7OF33olbZ/YZv8NojxhA153Ti2FBL71tZwfR2NbbV
         bH4TyLpT3nIxlFP73gvaah77aW9qhERbz1AjDIGqWqZsCzPTxMR9u785BjzQ0loNXsNR
         6SQKjyLKRVAYC1R40+Wnhh/e49OxTHI6lR9wApVjwZwcw45ddJoydQNZv24uXIfD4HNe
         T9ZmWsbfbcJvj/XxL4/skA/2KqNMLhT2D/R4cv8Mj9qA5x6Yj/Tq00i/mpbLlVV7Cy6j
         xr6w==
X-Gm-Message-State: AOAM533qVpwqd+LbwMLcjPPukfoY36yqMNBAXfbMB7sg4FDte/D7fWmz
        AwNVzIKQyP2ZzG40Ok6s3E4=
X-Google-Smtp-Source: ABdhPJxjF8hn46z7uMSWgrXBCCOHwY9FnQV4Lx9XbybrJHr6+L1a1SGwOi0acnFpWuIKW2M9nLGeqQ==
X-Received: by 2002:a92:8747:: with SMTP id d7mr816819ilm.173.1627497843488;
        Wed, 28 Jul 2021 11:44:03 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id n14sm425428ili.22.2021.07.28.11.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 11:44:03 -0700 (PDT)
Date:   Wed, 28 Jul 2021 11:43:55 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Jiang Wang <jiang.wang@bytedance.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "Cong Wang ." <cong.wang@bytedance.com>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        xieyongji@bytedance.com, chaiwen.cc@bytedance.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Johan Almbladh <johan.almbladh@anyfinetworks.com>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Message-ID: <6101a56bf2a11_1e1ff620813@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpVedTzRbf-bC7WuGMFYF=qnUxbnUdqJ9+FaxrTAn5DkTw@mail.gmail.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-3-jiang.wang@bytedance.com>
 <6100363add8a9_199a412089@john-XPS-13-9370.notmuch>
 <CAM_iQpVedTzRbf-bC7WuGMFYF=qnUxbnUdqJ9+FaxrTAn5DkTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/5] af_unix: add unix_stream_proto for
 sockmap
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> On Tue, Jul 27, 2021 at 9:37 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > Do we really need an unhash hook for unix_stream? I'm doing some testing
> > now to pull it out of TCP side as well. It seems to be an artifact of old
> > code that is no longer necessary. On TCP side at least just using close()
> > looks to be enough now.
> 
> How do you handle the disconnection from remote without ->unhash()?

Would close() not work for stream/dgram sockets?

> 
> For all stream sockets, we still only allow established sockets to stay
> in sockmap, which means we have to remove it if it is disconnected
> or closed.

+1.

> 
> But it seems Jiang forgot to call ->unhash() when disconnecting.

Aha so we need to add it in af_unix code I guess. Anyways looking forward
to v2.

Thanks.
