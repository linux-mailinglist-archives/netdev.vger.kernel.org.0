Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FBFA32B39A
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1449833AbhCCEDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1579205AbhCBQqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 11:46:47 -0500
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62788C061A2E
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 08:32:05 -0800 (PST)
Received: by mail-lj1-x230.google.com with SMTP id e2so17541085ljo.7
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 08:32:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XQihGGsHn2Ec1V5JNWmQEWb+2T5lqpeyNq/VKNaEHRw=;
        b=E6cwBE5VzlV4wVDgZ+5gfHO3FSSotA0JLRjTSZdu7Bb7zSfQ/wTreBDQhnVBdNVO0P
         BmEv42CMpVK7DbnhKX6fiE4gqmwCmby9jvYIPF3++DRR6GDQipmcvet6zeKbeOFhwVjn
         9f9svBYlPd0qNABkFpXH8BuQNzAFjzNzfhXdw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XQihGGsHn2Ec1V5JNWmQEWb+2T5lqpeyNq/VKNaEHRw=;
        b=CqYKUU84F3HOWDtGUhmjMPgybRUCaWzvCX5rg7fFJEGVqzy+hyEaT6gWeXr24fRhAD
         13z+XPef5cz9LNVYzkkbCAgjISHPqxXOenzXl7Wekqle0iPaCncT86Wz+p2Ky7kmnC6O
         xhNOtiCrsZivpL4fFqOrb/TPGs5dt1dL5/F6c1n/D7jLXth2r9hZF17JdmD3bZebGGXA
         mbUYe+lz1swCxXq4cqe9okWpp8ieTVM1DKk+OKzDEns/qOMUX6Go5fMh9Ftd3DpqsSMa
         n7aLGc8Wqibc4j+l0fYQ4VwrPb0Ndq7LK8nd8Sxot9Ic46Dw8fJyLjW8VBxPXgt4cGwx
         y/Dg==
X-Gm-Message-State: AOAM531fDx9DlvsZuw2KoFiuXtNx12v0w0ZXtaByAuSl+yU36KC1q179
        9ind1/Q7uvHUVJX35Fpchb5VZfZ9z4sTYzLuZMo4sw==
X-Google-Smtp-Source: ABdhPJyqTCMe34NCYpbrf7DiAJUDrgXX6BaBkGrG0BXnYkXVOSQp6WYMnnPCYNt3vtXA9wfKPEJHoEWayR97nwfzEkY=
X-Received: by 2002:a05:651c:1318:: with SMTP id u24mr12776204lja.426.1614702723884;
 Tue, 02 Mar 2021 08:32:03 -0800 (PST)
MIME-Version: 1.0
References: <20210302023743.24123-1-xiyou.wangcong@gmail.com> <20210302023743.24123-10-xiyou.wangcong@gmail.com>
In-Reply-To: <20210302023743.24123-10-xiyou.wangcong@gmail.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Tue, 2 Mar 2021 16:31:53 +0000
Message-ID: <CACAyw9-wmN-pGYPkk4Ey_bazoycWAn+1-ewccTKeo-ebpHqyPA@mail.gmail.com>
Subject: Re: [Patch bpf-next v2 9/9] selftests/bpf: add a test case for udp sockmap
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        duanxiongchun@bytedance.com, wangdongdong.6@bytedance.com,
        jiang.wang@bytedance.com, Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Mar 2021 at 02:38, Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> Add a test case to ensure redirection between two UDP sockets work.

I basically don't understand how splicing works, but watching from the
sidelines makes me think it'd be good to have more thorough tests.
tools/testing/selftests/bpf/test_sockmap.c has quite elaborate tests
for the TCP part, it'd be nice to get similar tests going for UDP. For
example:

* sendfile?
* sendmmsg
* Something Jakub mentioned: what happens when a connected, spliced
socket is disconnected via connect(AF_UNSPEC)? Seems like we don't
hook sk_prot->disconnect anywhere.

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
