Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E7B3C8652
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 16:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239471AbhGNOv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 10:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbhGNOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 10:51:27 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8559FC06175F;
        Wed, 14 Jul 2021 07:48:34 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id r16so3769950ljk.9;
        Wed, 14 Jul 2021 07:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Mo9k5jH4GSmtjL5FK+4ioKx5/w8roNFm40fznUJSv1k=;
        b=qNMhfZkpwQ9kHPYRZBvnFXJy4iJX5d0r4jc5KeikV4A36it2sTXZEJf15OhF8uyHPn
         MNZrI1KJNrY+q0nRg9POMpOr26C8eSTpIPssDHgs2EqB2PopJAoN3Os7hybK8o313l9n
         SOO6kc2yQgNz3iiplkESxxQ8kPNqqgJ4jzmqcdOZbOjCchRsRMAM8gBQYv+6fsffnbtz
         01Yqn/+gpJ6ejpoeYn6X5VWfeY9tjS0C16tfptkro8URGwsl5eTZ1HtKJxjiozJaduCl
         S5zJbVHVnBshmAbr3nRVX4z5Joh1U/ObJjWEglqHo+AuBxMs8RTFNS+Mqdo51Je9rQFM
         4EmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Mo9k5jH4GSmtjL5FK+4ioKx5/w8roNFm40fznUJSv1k=;
        b=IV/FsGyZcn9jUCiaALCEQXia3C9sGlNyldaZRUxrMmpq71LNoyzUFmx+5qlrhkIEvx
         ChHQxYqSxLMzPgOU9K8Z0PdZNbXZQwKbKTpig5VkAM44JR3ZNu5oXnyPoN0YM2Q0JMOn
         DRI9pzXLrLHBDV+vL3DHbqjjEvZUpIcBwEwn0n/OWT6jJBvzPcdN8hKix+Bni05PIJx4
         j8J0aOWaPP5pfDYe8n9XQh1OwIvUQQzxIaE6TvTcRsUPTwfy8P3NDBB7ZQFUOmZUMSk/
         +C3GH9JmT4e1+vUKO+0PGdPO/b0LSMWzrThrPO+yUqK8vEOSelWy1GIcf2iw+gZSEQK3
         Q0zA==
X-Gm-Message-State: AOAM533M2XpyxlbH7FM8EL4T2GHLf9KOLINyrLmtWr4TvgOUYByXA1dD
        YmzGPnDsx1EUpLyZfKMJvo/S6ugWW49E8y0oHtw=
X-Google-Smtp-Source: ABdhPJzZe7IX8mOnMD0jz+QP5R3gPQuTuh+AXucJn6oBudyIem5/LP7GqzNU4wnyLwJPoBk7nMJ2BWoQduTg1Xfon38=
X-Received: by 2002:a2e:b5d6:: with SMTP id g22mr9745446ljn.236.1626274112788;
 Wed, 14 Jul 2021 07:48:32 -0700 (PDT)
MIME-Version: 1.0
References: <5aebe6f4-ca0d-4f64-8ee6-b68c58675271@huawei.com>
 <CAEf4BzZpSo8Kqz8mgPdbWTTVLqJ1AgE429_KHTiXgEVpbT97Yw@mail.gmail.com>
 <8735sidtwe.fsf@toke.dk> <d1f47a24-6328-5121-3a1f-5a102444e50c@huawei.com>
 <26db412c-a8b7-6d37-844f-7909a0c5744b@huawei.com> <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
In-Reply-To: <189e4437-bb2c-2573-be96-0d6776feb5dd@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 14 Jul 2021 07:48:21 -0700
Message-ID: <CAADnVQJYhtpEcvvYfozxiPdUJqcZiJxbmT2KuOC6uQdC1VWZVw@mail.gmail.com>
Subject: Re: Ask for help about bpf map
To:     "luwei (O)" <luwei32@huawei.com>
Cc:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        David Ahern <dahern@digitalocean.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 1:24 AM luwei (O) <luwei32@huawei.com> wrote:
>
> Hi Andrii and toke,
>
>      I have sovled this issue. The reason is that my iproute2 does not
> support libbpf, once I compile iproute2 with libbpf, it works. Thanks
> for reply!

How did you figure that out?
I thought iproute folks should have included that info as part of -V output.
Since this exact concern was hotly debated in the past.
Non-vendoring clearly causes this annoying user experience.
