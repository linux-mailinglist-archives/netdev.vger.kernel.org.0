Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CB7647B26F
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 18:57:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233440AbhLTR5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 12:57:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239565AbhLTR5V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 12:57:21 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EFE5C061574
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 09:57:20 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id e136so31191233ybc.4
        for <netdev@vger.kernel.org>; Mon, 20 Dec 2021 09:57:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YPzQ8aKsf0Myz64J0BIQAjZ66MQeGyufJoS6fdeAggs=;
        b=nrJDqua60hm2fPFU4Ad72zjnbqx9h9KIFvpj8SmgA7cs/WlHVsDDDqp2VCjdLd+Y+5
         zoOFJw9VZt1mofAqR8PcelgbuxeZOEZaFBUeuwx4snsRhha3RG1wwQx3W7BqTcyOBGR6
         wG+ivNS/WlgEoTGMHwe00ADXOt9BBY+/yxjSdQS1STSYVrkM+tQ+QqtExKaZvhePhsdh
         K69vg0Ck1Kz7lIRRvpVTgQVHcqEwscO7H1tZH8se44jOSKh27RAKrEPxTci2vMoyGaej
         wZ+Zqp+m+ZyjJqGBHaiVvlM8fQObRI0ovyRzMUUlDRUg2acXEnAGFgjgII+QEt2d9LwL
         5ikg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YPzQ8aKsf0Myz64J0BIQAjZ66MQeGyufJoS6fdeAggs=;
        b=HKJE+Uj6oZhtrnX7UMrhhIh5OkYRzpBBFJZr1zreJEWowzqUtld/RUvGupVj+XeC10
         WalMkpzWb/wyMN1i71kgIZMER86WfUKx4CM0QkbITw1f+cCxUzSrfFFfzm71Ib3NObY2
         Ci7wFIvsfei3NOnrh9jnpBisMARwjWTs/eQ5WaIqDny7CtPg7JKTeLtvW8WMtCa9ONyI
         06Z8vlKZ8lhJARp9fbdYcNJ3K4F3G1xII2iUVew8Ozx1JRUo2g0xJFw3m/ZFjbz5hbBx
         YQ6khlzxwIVsAVDLfNpUXakT2rafWctY7G6JgOfhG+cmRH0e/u6YmYjTy2eulPiMQIa+
         iYCA==
X-Gm-Message-State: AOAM530sW3dxEGncPXHOR0ZTwBR/O6WWtdEBWGcnY97Akn5mldu8fh3o
        ZnNqO9dm5gzGxdy+l0NARYMx7bo+eVQSkz6hMS4=
X-Google-Smtp-Source: ABdhPJweHMTw+XZqt2yI8dRxiUqgwtXTV+l0QY1seS8Ic+y80k7o3MRH4MBfCSggrdAI81VPKmfouDzeacZOOwwwoH0=
X-Received: by 2002:a25:73cc:: with SMTP id o195mr25370363ybc.740.1640023039300;
 Mon, 20 Dec 2021 09:57:19 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com> <20211220123839.54664-3-xiangxia.m.yue@gmail.com>
In-Reply-To: <20211220123839.54664-3-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 20 Dec 2021 09:57:08 -0800
Message-ID: <CAM_iQpXfZq--ZCUQvggtqE7bEpZFRVcLTqN_R5kLiZj4Y75VAA@mail.gmail.com>
Subject: Re: [net-next v5 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 20, 2021 at 4:39 AM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> This patch allows user to select queue_mapping, range
> from A to B. And user can use skbhash, cgroup classid
> and cpuid to select Tx queues. Then we can load balance
> packets from A to B queue. The range is an unsigned 16bit
> value in decimal format.
>
> $ tc filter ... action skbedit queue_mapping skbhash A B
>
> "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> is enhanced with flags:
> * SKBEDIT_F_TXQ_SKBHASH
> * SKBEDIT_F_TXQ_CLASSID
> * SKBEDIT_F_TXQ_CPUID

Once again, you are enforcing policies in kernel, which is not good.
Kernel should just set whatever you give to it, not selecting policies
like a menu.

Any reason why you can't obtain these values in user-space?
