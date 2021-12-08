Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E04D46DB0D
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 19:28:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238885AbhLHSbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 13:31:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234072AbhLHSbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 13:31:35 -0500
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E52C061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 10:28:03 -0800 (PST)
Received: by mail-yb1-xb2b.google.com with SMTP id x32so7954204ybi.12
        for <netdev@vger.kernel.org>; Wed, 08 Dec 2021 10:28:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MAnOimVYjfL0e9dMhmolD95QLJSvSzLjH/SXXaFwDMc=;
        b=nIu4GcMNlQyvdhFEKXXWfbFmGo15f3OgU/AVDkXaQIJ0liB/ypEnaIUySZL1JbuxS/
         fMFlq1kezTFgG8nnpfD/qndrWn8Wees/iscaXSYa9462rhFXhYnNeR+cOGy4F8mXxIjG
         el9+F+4guHyPNx6vEAnp8KH0jZOyPzxYyc5w1hP8LqqWyQ3cUZCJAHqAcZ9iUw9IVWbd
         vMl7IQ8Rw3A7Fcps5Md6GpszA4gSUQ2AQeJD/QD7QxX8m81xw38Xyp9bKlxtquq36/Kk
         OQ7pkYSSzVMxuXuYVFmOfI417f+WO7uBnqw+1xDUU3sQ82bwe/5JAXZFLzHe0y3oBe95
         gH+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MAnOimVYjfL0e9dMhmolD95QLJSvSzLjH/SXXaFwDMc=;
        b=kKp6quzCtLHnFqz0b5XE7NCFTWBmIcJM2wmjFwfY/t35LKoC8/JqLXPbRQAXvMfk/e
         oTnW/88240iuCTzbZYpoEYxq61LVggXfWTMWOdrLnV8daeawQzO0u+21AW5KEIUP6xZn
         dP4wPFuTjXj1RBnpf0setoHrpjmyjtYOvv5XgSC1UZZ9gTUt6xI7JDc9t3d0l9hn8r/G
         rSkD7E0VVswT+DoVaTc0y23TpD2WsPFKRC2LJ6iHBhk9V3QnLWsFOiUTJcVRTwMEsrE5
         1IlIMp1LhHOA1qVnvweLjuWLAB9RFsBGRwRVbhADMbLcZi4yUP4MkGeD9oKS8jBJ1pc7
         rOLg==
X-Gm-Message-State: AOAM532hT/6eE04FQh4gfb5VgFYftx7NfZZiA4KtjVEuqjYTSX54xfpJ
        EORy3Q2zdQLzk7kKtOLFpHU90M4EYALLq5gJ1ACa0w==
X-Google-Smtp-Source: ABdhPJy1Hq8s+Bo6Fi/hQqAo1KB9HYOWcPXrr9Sg6Ve6MuiCo9m5hdgbw34mUH2qYyYNPdM1vwiapiErcjZRbrS/KJg=
X-Received: by 2002:a25:760d:: with SMTP id r13mr492620ybc.296.1638988082353;
 Wed, 08 Dec 2021 10:28:02 -0800 (PST)
MIME-Version: 1.0
References: <20211207020102.3690724-1-kafai@fb.com> <20211207020108.3691229-1-kafai@fb.com>
 <CA+FuTScQigv7xR5COSFXAic11mwaEsFXVvV7EmSf-3OkvdUXcg@mail.gmail.com>
 <83ff2f64-42b8-60ed-965a-810b4ec69f8d@iogearbox.net> <20211208081842.p46p5ye2lecgqvd2@kafai-mbp.dhcp.thefacebook.com>
 <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20211208083013.zqeipdfprcdr3ntn@kafai-mbp.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 Dec 2021 10:27:51 -0800
Message-ID: <CANn89iLXjnDZunHx04UUGQFLxWhq52HhdhcPiKiJW4mkLaLbOA@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 2/2] net: Reset forwarded skb->tstamp before
 delivering to user space
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 8, 2021 at 12:30 AM Martin KaFai Lau <kafai@fb.com> wrote:

> For non bpf ingress, hmmm.... yeah, not sure if it is indeed an issue :/
> may be save the tx tstamp first and then temporarily restamp with __net_timestamp()

Martin, have you looked at time namespaces (CLONE_NEWTIME) ?

Perhaps we need to have more than one bit to describe time bases.
