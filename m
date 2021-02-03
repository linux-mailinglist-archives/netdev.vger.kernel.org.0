Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C625430DFB3
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbhBCQ0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbhBCQ0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Feb 2021 11:26:48 -0500
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D90C061573
        for <netdev@vger.kernel.org>; Wed,  3 Feb 2021 08:26:07 -0800 (PST)
Received: by mail-qt1-x849.google.com with SMTP id o20so263648qtx.22
        for <netdev@vger.kernel.org>; Wed, 03 Feb 2021 08:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=EKSWs4oHbdvSr3JCVuE/WyEGXbHNjwSY5+CA0/uAaTo=;
        b=uVQBMo5xdaLkoYHQL5bDzmVuvyDAP57aUThKL3COMCeMZijVb2z86F5o56RbGkFjhp
         FyTM1pkIjjVUQV7uvv5JFqtpU0AplVAjyZib0VNxgJ1WYvqIHcNa3BKmTwOt0RRYiv0Q
         SjG7N0jQFqoy7xVUa+oqb8LEFbNf8camf/Rx3/O5195V7c5FkeI2d3TmezZlRVsXaK6g
         ZPpJgppm1AmFUblHWjwgo3koH7J3ttgGxYjHYLU0HDW3fcdOhjnfcXAU1JQQglPIKZ0p
         mM41UYlhr2zEHjqmTvRkQeEnITVvih8pY7e79XF9/aQgAepygbimq0P3HgMPnKKcEovN
         J06g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EKSWs4oHbdvSr3JCVuE/WyEGXbHNjwSY5+CA0/uAaTo=;
        b=gYzdqrazrb1XhgH8ZcBfXdSuQsN7dxVzvJqcRZZTe77b3EDK1RU2TaJzHLTbawKVpw
         m6/3i+ffrcbJZAXQ8YacjvJG6eYqGRnZPa2aIfVFNVaMmlwa/3hLehWOWIstSMbNVd3Q
         ez+zSjUp8kPT12ToILzlAVEpxZuhiItgSDQCa0xtJYMktLebHxiar2PzRT31/EdCAmCs
         dbSnJ9Wb1kWakgG52EiiGKNLEO37G5auoRyTLuU0pm90ZNZZ6uH0pd9qAMQGb6jpbQ07
         rHOyHd16HkVTH6qdhnShggVf2SyL00mfrPgk7ToWrRyZEWg0VT6y7nR4YWtHc252mdur
         evyg==
X-Gm-Message-State: AOAM530Szzlu0HWgcZB7VK/g667eboUxK+nQ+TJo0LlmfOIFLIhbXM2E
        6Gvl/9B05uYrVyTmq8J05Z9DD28=
X-Google-Smtp-Source: ABdhPJztvF9a4haVIw8TdKLDdV8zCJzp3EdeErR+e5syJliNjXlPk6zXgWUSo/JiGmhIINZULbSq084=
Sender: "sdf via sendgmr" <sdf@sdf2.svl.corp.google.com>
X-Received: from sdf2.svl.corp.google.com ([2620:15c:2c4:1:f84b:ed96:ea48:8bdb])
 (user=sdf job=sendgmr) by 2002:ad4:4993:: with SMTP id t19mr3574360qvx.41.1612369566632;
 Wed, 03 Feb 2021 08:26:06 -0800 (PST)
Date:   Wed, 3 Feb 2021 08:26:04 -0800
In-Reply-To: <CANn89i+ZggZvj_bEo7Jd+Ac=kiE9SZGxJ7JQ=NVTHCkM97jE6g@mail.gmail.com>
Message-Id: <YBrOnJvBGKi0aa7G@google.com>
Mime-Version: 1.0
References: <20210129001210.344438-1-hari@netflix.com> <20210201140614.5d73ede0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+ZggZvj_bEo7Jd+Ac=kiE9SZGxJ7JQ=NVTHCkM97jE6g@mail.gmail.com>
Subject: Re: [PATCH] net: tracepoint: exposing sk_family in all tcp:tracepoints
From:   sdf@google.com
To:     Eric Dumazet <edumazet@google.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Hariharan Ananthakrishnan <hari@netflix.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Brendan Gregg <bgregg@netflix.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/02, Eric Dumazet wrote:
> On Mon, Feb 1, 2021 at 11:06 PM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Fri, 29 Jan 2021 00:12:10 +0000 Hariharan Ananthakrishnan wrote:
> > > Similar to sock:inet_sock_set_state tracepoint, expose sk_family to
> > > distinguish AF_INET and AF_INET6 families.
> > >
> > > The following tcp tracepoints are updated:
> > > tcp:tcp_destroy_sock
> > > tcp:tcp_rcv_space_adjust
> > > tcp:tcp_retransmit_skb
> > > tcp:tcp_send_reset
> > > tcp:tcp_receive_reset
> > > tcp:tcp_retransmit_synack
> > > tcp:tcp_probe
> > >
> > > Signed-off-by: Hariharan Ananthakrishnan <hari@netflix.com>
> > > Signed-off-by: Brendan Gregg <bgregg@netflix.com>
> >
> > Eric, any thoughts?


> I do not use these tracepoints in production scripts, but I wonder if
> existing tools could break after this change ?

> Or do we consider tracepoints format is not part of the ABI and can be
> arbitrarily changed by anyone ?
They are not ABI and since we are extending tracepoints with additional
info (and not removing any existing fields) it shouldn't be a problem.
