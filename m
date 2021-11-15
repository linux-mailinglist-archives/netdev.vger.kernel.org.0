Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 041FB44FE14
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 06:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbhKOFLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 00:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhKOFLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 00:11:49 -0500
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B032C061746
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 21:08:53 -0800 (PST)
Received: by mail-yb1-xb34.google.com with SMTP id u60so43308720ybi.9
        for <netdev@vger.kernel.org>; Sun, 14 Nov 2021 21:08:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f3ouGoYXHhWL6NCT4LYaFGCUbt9wZCfLipDgThRGPP0=;
        b=hk6IWo+kYUzNq1PK/4Dp/OnQn3o1qvf7tzJUew4qo0PS6AAASdDzgavPQLqfIO/67o
         FfT9/RMe5aujmPHpTtKU3Bk1PUqm62m2eTD+oOyr+qos/M1P/kb1gU/psNUPqWWGS+k7
         4fudDTC4T76gR3sg5GyCO6PNxZ2yFeTIKrCJv4FbcVruTuaJOzlVLvJNk36gQKfYqmjy
         WKRV7CBea/EnFq+QEU5s1dMNlVD2yja1tUjui+J8ecMNnC01KPtFmd5VYygxkWZ0XoHM
         rxsSfZVAgFKgZU4UIt5zlYUMIRHpovikosSwqeSSCGq/bHmEcBpW1FNqwmk9FoIRlTmV
         DfSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f3ouGoYXHhWL6NCT4LYaFGCUbt9wZCfLipDgThRGPP0=;
        b=L3rgwV93XAVcfs4Nkrf0ERTff14UFG4sqUXms0ybj9gHq4XkN259BKHzB5OxqMvPk8
         KkLJV5XinXZKpQLFcXO7Vsnn0B3WV/qP74YlHvBRB4N9e7FlBKXIPA2hzjvUkPyxqsfk
         6scjCoJAvzZCK23dExo7sI/NR9/h4B8Rw36/9XBgxY5QHCrFvVYFda+H9srANMQiDn3W
         fVk7k1rrTQpRGqVo/BLt4P2jHJLXCqr1MX2Lcn9n1EZrZv66Y4nR96+TpFAl9jZIt1eD
         3gcN9WF+VpUNaiE8alaPxzm3zG4M6ynyfcIhgbA/QmUD1Ihh9nvAsE0nWdS3QKn1K1+O
         q0rw==
X-Gm-Message-State: AOAM533gjk2r3uiBgdLcNjnAPFtZKg0bpO2wWKerBN3q65B9jd/wlzG5
        NsO2Hv6n7B+HumRTnuPWytaqncC6PKTBqmewGVai3KW0
X-Google-Smtp-Source: ABdhPJzvOlc9XNv+nP6aX5CnmfTYrA0Fk6kh8kNyAtEajqNfFmh8FbvDa1oNM3TSHUBItvrIZp/4j6lm+2BsWVvh9VE=
X-Received: by 2002:a25:5003:: with SMTP id e3mr37438129ybb.482.1636952932745;
 Sun, 14 Nov 2021 21:08:52 -0800 (PST)
MIME-Version: 1.0
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com> <YYuObqtyYUuWLarX@Laptop-X1>
In-Reply-To: <YYuObqtyYUuWLarX@Laptop-X1>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 14 Nov 2021 21:08:41 -0800
Message-ID: <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 1:18 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
>
> On Wed, Jul 17, 2019 at 02:41:59PM -0700, Cong Wang wrote:
> > Add a test case to simulate the loopback packet case fixed
> > in the previous patch.
> >
> > This test gets passed after the fix:
> >
> > IPv4 rp_filter tests
> >     TEST: rp_filter passes local packets                                [ OK ]
> >     TEST: rp_filter passes loopback packets                             [ OK ]
>
> Hi Wang Cong,
>
> Have you tried this test recently? I got this test failed for a long time.
> Do you have any idea?
>
> IPv4 rp_filter tests
>     TEST: rp_filter passes local packets                                [FAIL]
>     TEST: rp_filter passes loopback packets                             [FAIL]

Hm, I think another one also reported this before, IIRC, it is
related to ping version or cmd option. Please look into this if
you can, otherwise I will see if I can reproduce this on my side.

Thanks.
