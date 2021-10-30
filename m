Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26FAB4406AA
	for <lists+netdev@lfdr.de>; Sat, 30 Oct 2021 03:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbhJ3B0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 21:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbhJ3B0d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 21:26:33 -0400
Received: from mail-vk1-xa2c.google.com (mail-vk1-xa2c.google.com [IPv6:2607:f8b0:4864:20::a2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CDE4C061570
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 18:24:04 -0700 (PDT)
Received: by mail-vk1-xa2c.google.com with SMTP id g18so69564vkg.6
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 18:24:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0S57ZF6WVRB7//Y6tPEsvLdvXexwUpCl4bhOPVRy37k=;
        b=M/S26d3uCFQeim/LKhiT3ELf4tAQk8oegQ2dKItoAMHkOBFAPOb4DXEeYeo4H8HmmU
         HS2ZN+Ni8SuqwXyjZgYusu2axed3DiwHQAP/tiTNFwO0cboj7aUzQS075lX5hteTtZoH
         Jis9njFg3fpHzbDjPt0oNC7X3dZaozTuUkk7FPaoF+tNfJOzrk/JlsiDt1CaOu4y4rRO
         MSqhxgFhDQEvscG41hdoXGI7prpUxxIC3yVDRypZtIS3hpcJhjlJRRjWB54l0/QyRcMM
         Q0lsNBN5sVn4TJfXgr5IVp6mRYVcenttvm2Z/Tx3s0ui4ixWZW4jtz4058QeeWIZCPFL
         I9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0S57ZF6WVRB7//Y6tPEsvLdvXexwUpCl4bhOPVRy37k=;
        b=zJz8JIuA7Sh9tBCSyyUlhRl4sxuUFzxKravGNbkkqKRx6EWEC5e5Odkd0eGZfJzmYq
         Mx3b2zP/Ibe3zcN3K326W3jnAzbLf53LP5/nXO4M5DhZJzvzqiXXBfI5tx9oFqTNN3BE
         bNHsobmuEWr3aBfPjGiT8a6kaq2+shuVhrZO3RMpzcdq7icKQ4pgPjAu19Y1gp+w2Ui1
         Hn97/Qn4XwOcpX01ekenBSv6VtHPUcp8Qe6FuOJjHPcFO+hWf70D/Mwzbs+5Nv1+os08
         l/1vIQ9pIhPecmSKMXqV33iXzG9pDYNLb8JmxlBCN9g7//rh96OwgzYGGCtZqUioU6mH
         SOIg==
X-Gm-Message-State: AOAM5313ZRLm+AL9OQ7Tib98UeVqMbt86AZOCZIRl1YmVlE6HAAcNr4z
        AU47sSJZPBB00EZZosDPhIi1qGILU5s=
X-Google-Smtp-Source: ABdhPJzRCltJIqLzFpUdeRiVzjw4CqBLenSCh7zfmJaeZs9pOU9zYpEfVD5/WsqIx9nqUtzMU+qnBw==
X-Received: by 2002:a05:6122:513:: with SMTP id x19mr12238986vko.18.1635557043784;
        Fri, 29 Oct 2021 18:24:03 -0700 (PDT)
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com. [209.85.221.180])
        by smtp.gmail.com with ESMTPSA id m25sm585132vsl.17.2021.10.29.18.24.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 18:24:03 -0700 (PDT)
Received: by mail-vk1-f180.google.com with SMTP id b125so4602198vkb.9
        for <netdev@vger.kernel.org>; Fri, 29 Oct 2021 18:24:03 -0700 (PDT)
X-Received: by 2002:ac5:c5ad:: with SMTP id f13mr16761405vkl.1.1635557043006;
 Fri, 29 Oct 2021 18:24:03 -0700 (PDT)
MIME-Version: 1.0
References: <20211029155135.468098-1-kuba@kernel.org> <20211029155135.468098-2-kuba@kernel.org>
 <ff189fbe-7b72-44ec-266e-1613930fb8cf@gmail.com>
In-Reply-To: <ff189fbe-7b72-44ec-266e-1613930fb8cf@gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Fri, 29 Oct 2021 21:23:26 -0400
X-Gmail-Original-Message-ID: <CA+FuTSf_W3JOk+FTb6x8Y+R8GoejdZgsjxrQAK75fzwm+x0B5Q@mail.gmail.com>
Message-ID: <CA+FuTSf_W3JOk+FTb6x8Y+R8GoejdZgsjxrQAK75fzwm+x0B5Q@mail.gmail.com>
Subject: Re: [PATCH net 1/2] udp6: allow SO_MARK ctrl msg to affect routing
To:     David Ahern <dsahern@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org, yoshfuji@linux-ipv6.org,
        dsahern@kernel.org, Xintong Hu <huxintong@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 29, 2021 at 2:22 PM David Ahern <dsahern@gmail.com> wrote:
>
> On 10/29/21 9:51 AM, Jakub Kicinski wrote:
> > Commit c6af0c227a22 ("ip: support SO_MARK cmsg")
> > added propagation of SO_MARK from cmsg to skb->mark.
> > For IPv4 and raw sockets the mark also affects route
> > lookup, but in case of IPv6 the flow info is
> > initialized before cmsg is parsed.
> >
> > Fixes: c6af0c227a22 ("ip: support SO_MARK cmsg")
> > Reported-and-tested-by: Xintong Hu <huxintong@fb.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > ---
> >  net/ipv6/udp.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
>
> Reviewed-by: David Ahern <dsahern@kernel.org>

Reviewed-by: Willem de Bruijn <willemb@google.com>

Thanks!
