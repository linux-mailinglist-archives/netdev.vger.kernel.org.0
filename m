Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225FB60968F
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 23:33:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbiJWVdR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 17:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiJWVdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 17:33:15 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510F46C944
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 14:33:14 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id 63so9176406ybq.4
        for <netdev@vger.kernel.org>; Sun, 23 Oct 2022 14:33:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=knsQJRxhDINme/Qdnf0gCt2O9Wr/+W3AyV7JHm/gPMQ=;
        b=CaCuFzLH1RCIwdB+sOjaj0Hr0tFjhPThAqp/KkWBbY3BZhRJW5bUOvgcHh/pTEKWoS
         +G+laevVFIo8P0zKEhicGosd0z7T1YGHZU9w7kr23lYTTYbyHgeZohfX9hWVB0xOhmsJ
         adosakiQ/rNPwrC4QpA9mm4bxoFkiD4xyELgVtdTfZ4OXQ7Q5xbfBit4USMpBqlJ22rF
         W23F84c5I43nv5dtOijd1pJQaLuyRYsVIPo5KToA/z2FRK48Qoap61TZr1I1VXEANkuJ
         f3wb0MByY6yC0J3nFS1Z+rUfoo76rfBxBQMSgOeOHSucqUqU3N4VfDlZO/nsbyY3O6hF
         FA9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=knsQJRxhDINme/Qdnf0gCt2O9Wr/+W3AyV7JHm/gPMQ=;
        b=SmIWK+OZV4JevQeburFd2hMGrbP/P6+orMDYQEEWoa4swt+aMO655JSUkZsXvuTL6h
         WbawLyCPcF11lI8QX1chnMOeLSoVC4N/ApNnOZNw8aNlkgC8f+kAeJllwbTVjSMgMYv7
         pur3dpFPETLLhMwWQAMrJoBIUfLCAGbZqSCKMb3FBN5DGKgpxn94HJ0oAiGGRARVdGDb
         yvJKUz+f3gs/RVgHngM8Joz0JjBgUMAXQiaRK1ueZfkBO1jIFKoFtGWa2jDl0cuanxmv
         EXHdVDEIz2b9IdW3wGaiCgoygIhWPsLRDmDPsMN6wIWziOcEm8hJrhz0smQlZcEuik/F
         Mtrw==
X-Gm-Message-State: ACrzQf2D1XH6eCN/QOquk7DndytRF9ZSZ7Pw530eLdmYGvn7ga8AIbF+
        b3pUj9AlTL1L5oUZ4UFDmGpV/vhvlk4iHoCGStoZLA==
X-Google-Smtp-Source: AMsMyM4p1T8kOtyXx+aC8lBlX/a0e2b5m9+7jQjgLkSvpGPbuH78GY3le80vPvvEpMSHbHUxRFKW/Xg+rOQ3wNFiinQ=
X-Received: by 2002:a25:156:0:b0:6ca:258:9d24 with SMTP id 83-20020a250156000000b006ca02589d24mr20258804ybb.598.1666560793238;
 Sun, 23 Oct 2022 14:33:13 -0700 (PDT)
MIME-Version: 1.0
References: <20221020224512.3211657-1-edumazet@google.com> <20221020224512.3211657-3-edumazet@google.com>
 <Y1SrBJUOKkpEHiPz@pop-os.localdomain>
In-Reply-To: <Y1SrBJUOKkpEHiPz@pop-os.localdomain>
From:   Eric Dumazet <edumazet@google.com>
Date:   Sun, 23 Oct 2022 14:33:02 -0700
Message-ID: <CANn89iLRkPu6XVhcwridPTrPRtfwQu61jdKZGcZ7aOXRkJy0zQ@mail.gmail.com>
Subject: Re: [PATCH net 2/2] kcm: annotate data-races around kcm->rx_wait
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, syzbot <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 22, 2022 at 7:46 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, Oct 20, 2022 at 10:45:12PM +0000, Eric Dumazet wrote:
> > kcm->rx_psock can be read locklessly in kcm_rfree().
>
> Copy-n-paste typo here.
>
> > Annotate the read and writes accordingly.
>
> I wonder why not simply acquire mux->rx_lock earlier?

I would think kcm_rfree() is called very often (per skb)

Grabbing the spinlock would add a performance regression.

READ_ONCE()  is a no brainer here.

>
> Thanks.
