Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3622DF84F3
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:12:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727074AbfKLAM0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:12:26 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:34461 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726887AbfKLAMZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:12:25 -0500
Received: by mail-pf1-f194.google.com with SMTP id n13so11984263pff.1
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 16:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZCEqZJdhNr+ifz9PyOlEXuZDyTYtFiXpw6aHxufADT4=;
        b=HYiswEW4DBDkcoAZTnMVqr+/sYp12P/bDENa1PLFQGroEFLb/sq+snN934v6Utbw7p
         OHxRNS2gnqxBeKQG4BzS2vyTxcV2QlYq3zNIJO4GUpaTEIiuJeI6Y32yCm9ydKV+iQzI
         vmu1a3PN1eCnEnwa75RnX1qOAE35X1v8Fu53ON/LGEQghfTTgKkhwxTQkKA6sg6RxIk0
         ynpHWtBt72NngU63g8VfIIVJLg9/CFarvV8wQ64zyzK8diWHuQimCFqnal18jeNjey91
         z5wPU638sdrd6fy8AIZbL4qCfX6M/n5eoyS8Q2g6hdRry2uCUXleIdGYGvsAkTOW9R4W
         N5Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZCEqZJdhNr+ifz9PyOlEXuZDyTYtFiXpw6aHxufADT4=;
        b=Ie2gxvxU1vRxoTHco299XeqDJh+QNdXG1WjGBeK8SH7AI2mlOQYCJ9bGrvIT3jNPKN
         +G6xmxZAH4IFAK2gpiMFdlFGWOt4s9azijGLoJ4Tjxb9MJsfO+p0GrroCooOiZToOkYp
         6Y5bw+MYuONSvLOeNFdlN8kLJbVR0VTPaRirJweMTjkQVjH13+QBu8JVCPPARNvAAmTJ
         UT2Ol+yEMSWbHJG12vABBERTXft5tWILthAR4yMxOGnJvY2tFs06tic+12M4quS1AqM8
         ohEI2oyxDCI73FHcaGXGD4wlL9YUCrKVIW3AZUDd8xaNCDp6btJ+5QtOKNl3E8FjLFpz
         SXwA==
X-Gm-Message-State: APjAAAWLqKgsC0RwEuDZkjkjdMqPYtZHNBkrieg2H4vEHuBhMfhvCMw8
        tELSWkgmUlj89PjIDxLO/cQvi+s3/kO+/U394Kc=
X-Google-Smtp-Source: APXvYqwPZ1J0ctQ+5lSlQJ7O68CZ5EhkxxME3A/5ZMZs8MqAXE99Kz/8nkqh518kQUo9BXwcs6WQ+HCDOUPa9/auGBs=
X-Received: by 2002:a65:44ca:: with SMTP id g10mr8327272pgs.104.1573517544916;
 Mon, 11 Nov 2019 16:12:24 -0800 (PST)
MIME-Version: 1.0
References: <CABT=TjGqD3wRBBJycSdWubYROtHRPCBNq1zCdOHNFcxPzLRyWw@mail.gmail.com>
In-Reply-To: <CABT=TjGqD3wRBBJycSdWubYROtHRPCBNq1zCdOHNFcxPzLRyWw@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 11 Nov 2019 16:12:13 -0800
Message-ID: <CAM_iQpUpof_ix=HJyxgjS4G9Mv5Zmno05bq0cmSVVN9E_Mzasg@mail.gmail.com>
Subject: Re: Unix domain socket missing error code
To:     Adeel Sharif <madeel.sharif@googlemail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 5:41 AM Adeel Sharif
<madeel.sharif@googlemail.com> wrote:
>
> Hello,
>
> We are a group of people working on making Linux safe for everyone. In
> hope of doing that I started testing the System Calls. The one I am
> currently working on is send/write.
>
> If send() is used to send datagrams on unix socket and the receiver
> has stopped receiving, but still connected, there is a high
> possibility that Linux kernel could eat up the whole system memory.
> Although there is a system wide limit on write memory from wmem_max
> parameter but this is sometimes also increased to system momory size
> in order to avoid packet drops.
>
> After having a look in the kernel implementation of
> unix_dgram_sendmsg() it is obvious that user buffers are copied into
> kernel socket buffers and they are queued to a linked list. This list
> is growing without any limits. Although there is a qlen parameter but
> it is never used to impose a limit on it. Could we perhaps impose a
> limit on it and return an error with errcode Queue_Full or something
> instead?

Isn't unix_recvq_full() supposed to do what you said? It is called inside
unix_dgram_sendmsg() to determine whether to wake up the dst socket.

Thanks.
