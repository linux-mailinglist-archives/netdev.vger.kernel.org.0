Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95ABB3E7DF1
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 19:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229474AbhHJRE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 13:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230042AbhHJREz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Aug 2021 13:04:55 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B52C0613C1;
        Tue, 10 Aug 2021 10:04:32 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id x10so22301982iop.13;
        Tue, 10 Aug 2021 10:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=qKjLpOXK2E4x5JMD/1Vmmi19gIauGt4KxUD98Wehp14=;
        b=C4k686O0v0ff0siTcVNGZOuwLSM9CxMC+GGzNAZIMG+utS3u3kiHTh31vLukr29RXO
         c9Wcx6YEZvD5T9uFjJd6IUA4q4nhL100ZC6GgjEWFCC9vktBdRuUhK6tR69PgBAmGL+g
         G9oSwkdrBIc59hYur/Z0ZFwMdcV7Mhi3HigxDgaspa/RiufWazatGolkskySoFxaUtuC
         +ve1tybj23pShl3zzDb0PaBxAqu75SLfDCBbG+aidT1kT+KZ77auR9xYz9b0lkMDmfbj
         10TKDKZziGNF8oAuy/uD8ixlW8TSP8WE/Lq+3Ghmf4Ac8Dp7/wbXo7bDJVj+i3lG1tpt
         pZhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=qKjLpOXK2E4x5JMD/1Vmmi19gIauGt4KxUD98Wehp14=;
        b=HhpSfXh8EcM7da5EU6nOkOBvo48x71PA9LW0MOc5B3cUKttqqH6fyFWSXB1nhRS6E1
         cVgIr5wkhoe5pbJL7Cd2MumrpHvlfTzK2Jv9ZAMUyOskNF+0YJJ8DnUXkBHr8V1KZO/u
         Wyae5VrMxgwk+WM37Zx1O1TESf21rhC8NP55+Sphbq9tcLlyYbbHh72IwVLK88XIQUGp
         qhFTM4xM9ov7FhxLsXctni8+3L9/Ik4xlysJOb0Ly+GWNRFAuGrUkqEZ7XRdIefjFUjQ
         km6dz14ngUTbww9TfOYVa2pBtWu+tVKuWjD/3X/vrjAtYK5098qRWGvnJMQQzg/38I5i
         zu1w==
X-Gm-Message-State: AOAM531bIpQ1TDgbJ6D0b35DQpDCHggAGqiJ8vcxlbfNSdtNBMbCy7wU
        XaQNLPudZVq8GQdH3op42xM=
X-Google-Smtp-Source: ABdhPJx7vGesJitEUC/rVgfxeFrtliJzvWzTg2gRC8q71LZvPzBhsGoM1kiiTTVevxkjfPFdVcWymQ==
X-Received: by 2002:a5d:9bcf:: with SMTP id d15mr65210ion.88.1628615072105;
        Tue, 10 Aug 2021 10:04:32 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id l5sm2607191iln.13.2021.08.10.10.04.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 10:04:31 -0700 (PDT)
Date:   Tue, 10 Aug 2021 10:04:26 -0700
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
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Message-ID: <6112b19a30160_1c2c820888@john-XPS-13-9370.notmuch>
In-Reply-To: <CAM_iQpXiqhfL9M04x1hvJ_6zCCUoDAv1_ywysu=O7wnCUuJaTw@mail.gmail.com>
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-3-jiang.wang@bytedance.com>
 <6100363add8a9_199a412089@john-XPS-13-9370.notmuch>
 <CAM_iQpVedTzRbf-bC7WuGMFYF=qnUxbnUdqJ9+FaxrTAn5DkTw@mail.gmail.com>
 <6101a56bf2a11_1e1ff620813@john-XPS-13-9370.notmuch>
 <CAM_iQpXiqhfL9M04x1hvJ_6zCCUoDAv1_ywysu=O7wnCUuJaTw@mail.gmail.com>
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
> On Wed, Jul 28, 2021 at 11:44 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Cong Wang wrote:
> > > On Tue, Jul 27, 2021 at 9:37 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > Do we really need an unhash hook for unix_stream? I'm doing some testing
> > > > now to pull it out of TCP side as well. It seems to be an artifact of old
> > > > code that is no longer necessary. On TCP side at least just using close()
> > > > looks to be enough now.
> > >
> > > How do you handle the disconnection from remote without ->unhash()?
> >
> > Would close() not work for stream/dgram sockets?
> 
> close() is called when the local closes the sockets, but when the remote
> closes or disconnects it, unhash() is called. This is why TCP calls unhash()
> to remove the socket from established socket hash table. unhash() itself
> might not make much sense for AF_UNIX as it probably does not need a
> hash table to track established ones, however, the idea is the same, that
> is, we have to handle remote disconnections here.

Following up on this series. Leaving a socket in the sockmap until close()
happens is not paticularly problematic, but does consume space in the map
so unhash() is slightly better I guess. Thanks.

> 
> Thanks.


