Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B25D91CFF8
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 21:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbfENTdi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 15:33:38 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:34342 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbfENTdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 15:33:38 -0400
Received: by mail-io1-f50.google.com with SMTP id g84so244678ioa.1
        for <netdev@vger.kernel.org>; Tue, 14 May 2019 12:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yF9D7RyTc74v56sXOIKGpWiiTOyUHJ8PD6rDSoCbYe0=;
        b=TB4T9ZHKSWr+9ofptOWs8J7Fj5h6A4eyQru/3X+iIdg9YaWZ29AyxvadBAKWNkwstf
         mcNKZzCZiSlK2Jhb2ppq1X4YdZlFucdFoG4hzfny9gZ4/6nV9n3Nm5UvQ+d3PrOJbgCC
         zXjrTeijJtxquqFbrpuYRmW6H+JiEF9+B3iE2+jVI5zB8nCoIGXcc9hB7TjxP7nhBSrL
         yPEjY2pNaVHSOUfaZkqG2ADa5AJP94SdmZdswcHz0nR7IxDyoMJEnqNHEKZMdT+GOZD0
         jfmvDLwTUZCNJz4er9mco8pEcGp5Lo2XtKA1bl8+Nqcrulu6dVz4/1R+865ake1tWa8q
         8DkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yF9D7RyTc74v56sXOIKGpWiiTOyUHJ8PD6rDSoCbYe0=;
        b=ivdImlvcRF9xqkRGBwqWFPevNXpTIphQDEhYMV2+YIUhSC+n2I4uG2BMos/xhJIu1H
         9p/9PoPR/Jh7q/8eDQMcCaCSAvARzD5FYukW1Jy0RFByqm9a+5hZtHBVDuJR5QnBUtL6
         9ITaTDQy1oHQFg2hXU7CXMmp8uVJDPEkclZTVWhSTOeaffiWvUNgDF+nyrpEozA7ykvI
         0LcSxJaIfgXvDtt9xrP6kdAjk1WO5W02rHKcyDuvtq8/2A8XY4fi+yW3HYdaeiU/6B5d
         mK7JXqK6mtX0Ypd2x9xcG0oMgUHBJXCzIugrezl09GuVYuDgKTUDZxDaF/5CvUfuJj1R
         fqZQ==
X-Gm-Message-State: APjAAAWskfVUxRWqLfWYX0Siszpp9Lq1quF4b+efv9QJQSQ6Kh2Ak3Bf
        4xRp+I70YnGNQMcy+ucjuxHFiQq3Je+gruwOHzXeqQ==
X-Google-Smtp-Source: APXvYqyMgmB4b3VLXZCANCsNAeTblu+5sJNO8dBl8Elk0lnNF2muvtY5tUpX31b9um++Ol11/j/e/Zv42xHj1FuhcoY=
X-Received: by 2002:a5d:9cc9:: with SMTP id w9mr20851514iow.287.1557862417288;
 Tue, 14 May 2019 12:33:37 -0700 (PDT)
MIME-Version: 1.0
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
 <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com> <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
 <20190514163308.2f870f27@redhat.com>
In-Reply-To: <20190514163308.2f870f27@redhat.com>
From:   Wei Wang <weiwan@google.com>
Date:   Tue, 14 May 2019 12:33:25 -0700
Message-ID: <CAEA6p_Cs7ExpRtTHeTXFFwLEF27zs6_fFOMVN7cgWUuA3=M1rA@mail.gmail.com>
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Mikael Magnusson <mikael.kernel@lists.m7n.se>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think the bug is because when creating exceptions, src_addr is not
always set even though fib6_info is in the subtree. (because of
rt6_is_gw_or_nonexthop() check)
However, when looking up for exceptions, we always set src_addr to the
passed in flow->src_addr if fib6_info is in the subtree. That causes
the exception lookup to fail.
I will make it consistent.
However, I don't quite understand the following logic in ip6_rt_cache_alloc():
        if (!rt6_is_gw_or_nonexthop(ort)) {
                if (ort->fib6_dst.plen != 128 &&
                    ipv6_addr_equal(&ort->fib6_dst.addr, daddr))
                        rt->rt6i_flags |= RTF_ANYCAST;
#ifdef CONFIG_IPV6_SUBTREES
                if (rt->rt6i_src.plen && saddr) {
                        rt->rt6i_src.addr = *saddr;
                        rt->rt6i_src.plen = 128;
                }
#endif
        }
Why do we need to check that the route is not gateway and has next hop
for updating rt6i_src? I checked the git history and it seems this
part was there from very early on (with some refactor in between)...


From: Stefano Brivio <sbrivio@redhat.com>
Date: Tue, May 14, 2019 at 7:33 AM
To: Mikael Magnusson
Cc: Wei Wang, David Ahern, Linux Kernel Network Developers, Martin KaFai Lau

> On Mon, 13 May 2019 23:12:31 -0700
> Wei Wang <weiwan@google.com> wrote:
>
> > Thanks Mikael for reporting this issue. And thanks David for the bisection.
> > Let me spend some time to reproduce it and see what is going on.
>
> Mikael, by the way, once this is sorted out, it would be nice if you
> could add your test as a case in tools/testing/selftests/net/pmtu.sh --
> you could probably reuse all the setup parts that are already
> implemented there.
>
> --
> Stefano
