Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EC30247A5B
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 00:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728955AbgHQWUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 18:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728677AbgHQWUm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 18:20:42 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 032FBC061342
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 15:20:42 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id s189so19285251iod.2
        for <netdev@vger.kernel.org>; Mon, 17 Aug 2020 15:20:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=j4jZJaANqFa0CzJRcnoAeSQAeGvQlwHezGeqUP8QMTU=;
        b=m8snYtQ52O+knUhnvpVcleAgmtIPTxwyXa1JHd0j6UUdyKQ+6oS/rjgZBk0ZfgSt4k
         /sH25Zm6e/ZDvpysu1+hWH45chVOGLnlO7luLnrxWmL11lDtTYwyHQ9ok9AGv8xxC5dQ
         IR7ICAf9GS2hu8MXuWYzlQzs/xSkvlRlSzrtgNtCqT6/5jExEXdarUNwaWcjuTbiLJWx
         GArp3m10regdR0znKnB+oMhJyCn9CFY8WL7VIsIRaC41oVocjJPUkg2rJScwnnMUdTmC
         z895PhCfE/aIepZe7LLi10PfvFfl1JkIV7VfvtPgz0xht3x678Y1+XWDcQVmv+O87d7L
         5GsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=j4jZJaANqFa0CzJRcnoAeSQAeGvQlwHezGeqUP8QMTU=;
        b=RH2s48ocFL+bIl5M+cLpoKVeGjL1H3xH81VVHG0uJXsmbIhdsPWMvZa6EppRDELe3N
         ElCG+vN2Nm/YmhKzFKRZ2gJS/HSaTHnsl7m1iTXH7XhSqHlGEKlUHDoK7AN8y7PSfMh1
         zr1QXXmxS4ulB0IabVNeO1v4gCzdcvOMkaBTs5+nVmMNJuCrEi9oWVB7mFnIZV7MMpHA
         ycCzgCt95lBah9nigEYuzlzBguUdQQvUkRuZ2Umuvco23rVjmnh2JrQ6WU1PXewGBIec
         SuLLwzT44eNZYQFKHFteT5RzXninlB4u/zymXvLfznPzc/A2lbxLYcHiApvPbUZ7HMJ4
         1P5g==
X-Gm-Message-State: AOAM531UKeFAUtZ3hgts95QXTlFb8qAYLuHqvONqjF46py9h7vcP/Npz
        4baH6hnUztqYWpiQHKpXf5B97W1yT3zkPyCOzbY=
X-Google-Smtp-Source: ABdhPJx3/9WWpZYoynoaP/MK2BqJmcgylvp+eG/OwYzxxnPKKy+WcoWk1FRr39Y9ylxHd8vAirPNYOXTKkXsWcBJ7Q4=
X-Received: by 2002:a05:6602:1343:: with SMTP id i3mr13781750iov.134.1597702841293;
 Mon, 17 Aug 2020 15:20:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAM_iQpUQtof+dQseFjS6fxucUZe5tkhUW5EvK+XtZE=cRRq4-A@mail.gmail.com>
 <6d7aa56a-5324-87c9-4150-b73be7e3c0a6@infradead.org> <CAM_iQpUEjZzW-e=h30KZVvg02ZZMRHZn9JExxgn6E=XyWsjzNQ@mail.gmail.com>
 <20200817.143939.248108433650303983.davem@davemloft.net>
In-Reply-To: <20200817.143939.248108433650303983.davem@davemloft.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 17 Aug 2020 15:20:29 -0700
Message-ID: <CAM_iQpUZZeZ-RYr-+h=r2TV7evL5AuJXe5gcso14TtBE+U82fg@mail.gmail.com>
Subject: Re: [PATCH net] tipc: not enable tipc when ipv6 works as a module
To:     David Miller <davem@davemloft.net>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        lucien xin <lucien.xin@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 17, 2020 at 2:39 PM David Miller <davem@davemloft.net> wrote:
>
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Mon, 17 Aug 2020 13:59:46 -0700
>
> > Is this a new Kconfig feature? ipv6_stub was introduced for
> > VXLAN, at that time I don't remember we have such kind of
> > Kconfig rules, otherwise it would not be needed.
>
> The ipv6_stub exists in order to allow the troublesome
> "ipv6=m && feature_using_ipv6=y" combination.

Hmm, so "IPV6=m && TIPC=y" is not a concern here as you pick
this patch over adding a ipv6_stub?

Thanks.
