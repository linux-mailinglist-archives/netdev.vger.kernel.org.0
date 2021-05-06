Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A9E37597F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 19:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236291AbhEFRg6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 13:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236251AbhEFRg6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 13:36:58 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA5AC061574
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 10:35:59 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id z1so8418863ybf.6
        for <netdev@vger.kernel.org>; Thu, 06 May 2021 10:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VAC9n+0/V5rMt+EvMxuyzNCWD7GY2IIp0a+9mKsP4QI=;
        b=Uc1iwHnp8mpQMgRtwtvZ4mY6bhd5NjHCJkLi9Y8rwPeq8Y/0dfrQ6sZDzMxQ/gi7rZ
         YMOF/MWI2teTvJZ9WrFkcXkfThuATE+6UiWW0UYjwGXRwrHHILxzTMOenaXTIlUwpG02
         ZqmzbkMqPVXUEHyvD4OzrcOv99ahYSFxZlY7vLr4NnK+Rmw0mdziVuqb+VYlzuJsaxI1
         qCFAHluI/nRjE/Ruy9JaC378x19vhRoVTw9fnvpaSEqnsrvoQmXgIct5HbPPCx7DuLBJ
         d0FYLncCPMGc5ptBbDRgQ+XxDWIeLeNdKG8y0gDIDIQI3gaSWGnpAHrG5JtYu3fUJLSO
         NyTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VAC9n+0/V5rMt+EvMxuyzNCWD7GY2IIp0a+9mKsP4QI=;
        b=p+sz8P5N1CspUlHxdYDyi9aPF3ZLprs3bVo+j5e6VEVtUVfGbTXuJQ+V9Y72+curcn
         o1JA7kLKaA+BN/64ixdsgE+2UWy9lHtyKmjs0+672SaHtyrBAH+bTN/UeLFCfe4QvtrM
         aPC5iqz7R6vo4kRvlhA0P0gwUZJNCYK2hfncc2mfgV1mD3/LiGWCWP3pqkZbXf850ZFa
         1tjnCDxzfOf5u+TQMnKVzRfiLCj6x8jpoy+eXxZNi7myp11mlTMKqiLLZ4HiU4p1TKk6
         pn+fkLiwCYT9WRTG+VqKKs5QKLtHE5aQRCU8jc2RB+6gHfOpgF4N+tovzweXL9EhoJOo
         0SDw==
X-Gm-Message-State: AOAM531jmPuGYHdhmCSLe076f7S81SAvvcpYPLJdLAwqhBVzYYkiCCxW
        m6kTgALny9EvSAoOOrPUome3uojbHc+Knq4D8RJ3vQ==
X-Google-Smtp-Source: ABdhPJyWQuFDK3qmVvYFdY7zmx52edh60RMw+xCeAxw1Cdh4ueDnxZY1Upwmcd/MMR3z+8SomRsnxSMPgFFLqtx9Y+g=
X-Received: by 2002:a25:4641:: with SMTP id t62mr7723433yba.253.1620322558832;
 Thu, 06 May 2021 10:35:58 -0700 (PDT)
MIME-Version: 1.0
References: <20210506172021.7327-1-yannick.vignon@oss.nxp.com> <20210506172021.7327-2-yannick.vignon@oss.nxp.com>
In-Reply-To: <20210506172021.7327-2-yannick.vignon@oss.nxp.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 6 May 2021 19:35:47 +0200
Message-ID: <CANn89i+kZnGHmiVoQSj4Xww7uNwhaj8+XV2C+4a_6k+T4UcY7g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next v1 1/2] net: add name field to napi struct
To:     Yannick Vignon <yannick.vignon@oss.nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Taehee Yoo <ap420073@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        netdev <netdev@vger.kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        sebastien.laveze@oss.nxp.com,
        Yannick Vignon <yannick.vignon@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 6, 2021 at 7:20 PM Yannick Vignon
<yannick.vignon@oss.nxp.com> wrote:
>
> From: Yannick Vignon <yannick.vignon@nxp.com>
>
> An interesting possibility offered by the new thread NAPI code is to
> fine-tune the affinities and priorities of different NAPI instances. In a
> real-time networking context, this makes it possible to ensure packets
> received in a high-priority queue are always processed, and with low
> latency.
>
> However, the way the NAPI threads are named does not really expose which
> one is responsible for a given queue. Assigning a more explicit name to
> NAPI instances can make that determination much easier.
>
> Signed-off-by: Yannick Vignon <yannick.vignon@nxp.com>
> -

Having to change drivers seems a lot of work

How about exposing thread id (and napi_id eventually) in
/sys/class/net/eth0/queues/*/kthread_pid  ?
