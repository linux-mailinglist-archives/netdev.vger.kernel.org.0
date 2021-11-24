Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA6E645B0FB
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 02:05:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232199AbhKXBIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 20:08:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhKXBIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 20:08:34 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFF9DC061574
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 17:05:25 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id v138so2332849ybb.8
        for <netdev@vger.kernel.org>; Tue, 23 Nov 2021 17:05:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wWXrIaIYTByHM1F4c7JDIx/JCRVMNhzD4VcfCGzYrGI=;
        b=SjM1FuucKfkOYuWE8janCh7zVbOUKT/NjU8GPO8sqk+xzq6nwgdLeWSoX1kSLCysGP
         ZJWUAWKSEsPcZkxJkiR8WEUcgxdVTcYpeYmai04g/lMUt5trvmQZM5TFnlFuWm/EjXnL
         VykXAZUn+hOkyeJESll640Np/fFzbrW29jN8GwE7xwhwh/QxGWRpk8bU8Oo2lI/gxzeR
         WsDwILG6YYa2E+sEt3o8TZgYkad6Lpb6VCe31z+CsdNqGh5RJnd3XQMKBClh13CD01Mv
         oy0r1gIKj9orbWV78znimEWKKdwFO41YHxutN4FkACzxYde6jwBRP71lRAv9eeMLZVww
         pmnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wWXrIaIYTByHM1F4c7JDIx/JCRVMNhzD4VcfCGzYrGI=;
        b=hh7696rgR7RCC9IQS9THrqmCHpv43bRx6QNrtgwwjcrfyTqWXoW6jaysiEyngwII03
         i7xIbM0G+F0SDdWy76bW8H1dpENzid2+6AApdIYQEPuqBcZ8RFulZB2r+KBwhQKfm+6c
         Z8OscguzhMrINGbeBczrf5ughdytVFiFBshL0PqNKOWOJCGlXzU9qN1VoKwlgU/dDFJn
         zAg2TWDeZcTIlxHsn70O758rzBFFl1bHTpDko4097O7NE1Audr5QmdQsGNExalB2hgnK
         mfh4RnNNyCfTR+TnPBvnA1TyyM9uqbeIIR8VsgJ1YJWJxhMC25bShuDCt93lAGPqXPKi
         OF4w==
X-Gm-Message-State: AOAM5325wX7FIOsaOqPZsPkl3k7ssf9ZlsUlZdbEPVqnm4HwVJxJqH7b
        UVvb22BJ34MQhdb61zV6aFhc0e5lYtIG+3nO+wLdG+SB
X-Google-Smtp-Source: ABdhPJyDHXJEFlbjhxS9IvVx0sBouuNHq4APRgQ+1GqY5Kfi6coqxzw2hlCj36NXBfwckJmwZcf0pV1YW8XN0HfjfWs=
X-Received: by 2002:a25:a169:: with SMTP id z96mr10713101ybh.491.1637715925288;
 Tue, 23 Nov 2021 17:05:25 -0800 (PST)
MIME-Version: 1.0
References: <20190717214159.25959-1-xiyou.wangcong@gmail.com>
 <20190717214159.25959-3-xiyou.wangcong@gmail.com> <YYuObqtyYUuWLarX@Laptop-X1>
 <CAM_iQpV99vbCOZUj_9chHt8TXeiXqbvwKW7r8T9t1hpTa79qdQ@mail.gmail.com>
 <YZR0y7J/MeYD9Hfm@Laptop-X1> <d83d3013-0a06-b633-fded-b563fa52b200@gmail.com>
In-Reply-To: <d83d3013-0a06-b633-fded-b563fa52b200@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 23 Nov 2021 17:05:14 -0800
Message-ID: <CAM_iQpUHLy8mxcztVKAcRz22-VeDUHwTV5g5UgmxUhQx8hQ9Gw@mail.gmail.com>
Subject: Re: [Patch net v3 2/2] selftests: add a test case for rp_filter
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peilin Ye <yepeilin.cs@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 16, 2021 at 8:15 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 11/16/21 8:19 PM, Hangbin Liu wrote:
> > On Sun, Nov 14, 2021 at 09:08:41PM -0800, Cong Wang wrote:
> >>> Hi Wang Cong,
> >>>
> >>> Have you tried this test recently? I got this test failed for a long time.
> >>> Do you have any idea?
> >>>
> >>> IPv4 rp_filter tests
> >>>     TEST: rp_filter passes local packets                                [FAIL]
> >>>     TEST: rp_filter passes loopback packets                             [FAIL]
> >>
> >> Hm, I think another one also reported this before, IIRC, it is
> >> related to ping version or cmd option. Please look into this if
> >> you can, otherwise I will see if I can reproduce this on my side.
> >
> > I tried both iputils-s20180629 and iputils-20210722 on 5.15.0. All tests
> > failed. Not sure where goes wrong.
> >
>
> no idea. If you have the time can you verify that indeed the failure is
> due to socket lookup ... ie., no raw socket found because of the bind to
> device setting. Relax that and it should work which is indicative of the
> cmsg bind works but SO_BINDTODEVICE does not.

My colleague Peilin is now looking into this.

Thanks!
