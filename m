Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F8C3DAE54
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 23:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbhG2V13 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 17:27:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbhG2V12 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 17:27:28 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26ECAC061765;
        Thu, 29 Jul 2021 14:27:24 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id c16so8514809plh.7;
        Thu, 29 Jul 2021 14:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CmUz25v47EVa8gRZMq5MLvl4L4iFYPzewIDb5rn7kIM=;
        b=SORUYDWsPT1mdtbTKodQJcv9mUm1olu6HMr4QDAkVdC+quIpbsQcHkbJlqdK4TXOSL
         MtWLhjVlUb1zReImAq0EdZTUjGgE//o1T+UnAHL5a9KIXw5s+qvWDL9LLWESASgQgkwj
         Ir5R/rcLaHiqf5NzeCffZ/Gs5Ronm9P/VFKO+4HJH1GIoulmE5CUbEiO2RyQr3eO7Rn6
         hEuLUZmW/0RrVUShatRfqHxBAmuqMJ8QQhzKOCcGc+zMDUw+lhDVTBVyNt/GLhPvLYim
         7In52S/+PV5DBJG+c0dStIuFe+9NcCZ0h0MUP3YbZzbyzvjTxr1ugmv8arPjJiV41HBP
         MzUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CmUz25v47EVa8gRZMq5MLvl4L4iFYPzewIDb5rn7kIM=;
        b=RXKw8AHvbq3BrvZ5MUCC5iN0z8zLlAeP55BJXKhBBU+29xTw9uju5vSPppVs1wefcw
         aWz9kuSmZuoq26B0R+cPk3Ba994IuiFyblpSXZQvMaMxEAMHP8PBXv2QkXhEHOVb8+cc
         RJF2F+W1aHFmhFj4Cc9CmNAS5WQmfZenj5JLkrkCyZxpxghrHOBFcwRdbrHIWtKZAMH8
         eIPEN7VYj+qzOSMoTf68k6ZBV51hm6fV9ta5E6501yUPMSmR2QnA2VjlSE6YiHxLlvUj
         xv85CJ2ncSYq791rIXm5kU3feJa03nw8g8xq/gmgPTsiu/LpGKmY53S68+lMUTowmRtH
         y+kw==
X-Gm-Message-State: AOAM531+6vQ46NlP3im7tn60wK9lIZeXGJBPZIuTqEp3F4427j8uD4h2
        IL4XzTn/TLLSZVwUs1FcFfVuPp6Fyws0q3t9Uvg=
X-Google-Smtp-Source: ABdhPJzcwd8CEaU5dsVlvlXTZD3ucVxwPiCBIwPZZKnWXpoWb19DKemjYFPzIC1Px66OiyySjVG1CK1cfBOjKtHRZT8=
X-Received: by 2002:a62:1609:0:b029:3ab:afdb:acf3 with SMTP id
 9-20020a6216090000b02903abafdbacf3mr2117397pfw.43.1627594043670; Thu, 29 Jul
 2021 14:27:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210727001252.1287673-1-jiang.wang@bytedance.com>
 <20210727001252.1287673-3-jiang.wang@bytedance.com> <6100363add8a9_199a412089@john-XPS-13-9370.notmuch>
 <CAM_iQpVedTzRbf-bC7WuGMFYF=qnUxbnUdqJ9+FaxrTAn5DkTw@mail.gmail.com> <6101a56bf2a11_1e1ff620813@john-XPS-13-9370.notmuch>
In-Reply-To: <6101a56bf2a11_1e1ff620813@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 29 Jul 2021 14:27:12 -0700
Message-ID: <CAM_iQpXiqhfL9M04x1hvJ_6zCCUoDAv1_ywysu=O7wnCUuJaTw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 2/5] af_unix: add unix_stream_proto for sockmap
To:     John Fastabend <john.fastabend@gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 11:44 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Tue, Jul 27, 2021 at 9:37 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > Do we really need an unhash hook for unix_stream? I'm doing some testing
> > > now to pull it out of TCP side as well. It seems to be an artifact of old
> > > code that is no longer necessary. On TCP side at least just using close()
> > > looks to be enough now.
> >
> > How do you handle the disconnection from remote without ->unhash()?
>
> Would close() not work for stream/dgram sockets?

close() is called when the local closes the sockets, but when the remote
closes or disconnects it, unhash() is called. This is why TCP calls unhash()
to remove the socket from established socket hash table. unhash() itself
might not make much sense for AF_UNIX as it probably does not need a
hash table to track established ones, however, the idea is the same, that
is, we have to handle remote disconnections here.

Thanks.
