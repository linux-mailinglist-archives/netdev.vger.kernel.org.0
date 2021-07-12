Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF42A3C424C
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 05:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233431AbhGLDyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Jul 2021 23:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233382AbhGLDyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Jul 2021 23:54:06 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D9F8C0613DD
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:51:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso9741843pjp.5
        for <netdev@vger.kernel.org>; Sun, 11 Jul 2021 20:51:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3wV4vX82evdwAGYM+XXrr8Ay744kn0LexQRi2YBKBdg=;
        b=XHdFO7I6bAoqVaXEnxmUnItXFTQ0J+1Htcy9zabimsQktbsYEM9J44jrX3j6EPUCvb
         VIXavLIKJxmrcTVwtqm/9wELufeXlkA9bW1Oydj32rQfV0MaPH/YQ/khH9GMReD3Vc+l
         oKYAiCbVmqWbDJHUU+gnnTRiQ/Y9KjuQDh0MBxbhnAuJXvnQtLmxtAfxI4+vuo3LndMH
         XJMF85PK++m5HQAkUH2pwJoMK9rCbbxop4MMcVqZO1vsFSVpebB/s6luPr/nWFFBGVTZ
         ynMXPx3QtGgznUzO5zzWwpCXjMCY+884SSOl0acqDgkVlZrM6YudR2s5q/1aSDDESCjy
         IyoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3wV4vX82evdwAGYM+XXrr8Ay744kn0LexQRi2YBKBdg=;
        b=mkK0dD3VfYkB9KGTRczFKp+Mz0X8JgxoCOipylc13FvUWvHkBKN36br7Iy4apISoW0
         JwLaaiCfthPrnqD38fRqFWij/g2tC8f2O8UYMMM/fBhCFg33KnKsl8RV5xiYUZQI5aKR
         phPUBPRFmw/BAVHZQQ38BJfo2uVcgIKYXulLbLvBPPfrjEOU9x67vOvfaXwVtbjjA5TL
         rG35Cb+cr5fIqJ0IGL67Tx2XBC0V9oBISrQrJ6J9HcdJg4ryJ7rzSN73a/ODHkVbHmbr
         sNiqPSFpwTnPj1NvquL9XMIKoYY8lvdOLpJCaR+DHY+PLztEyUZ8PsW5rEElpHwHOPOq
         1l7g==
X-Gm-Message-State: AOAM532jT0BCP7oUtBL/bzBfhVa8rCFjo49giRX3ApSNStdVq2tBDCGC
        l5Qi6T9qDv4g67XBPo0ByQpOUSwZQDsdV/o3i0o787siXCE=
X-Google-Smtp-Source: ABdhPJyOrTuoS9+NjW7Awr/fgDro5oPsvBa2UVtmawUj8aQIWaypeNZjRux/lntZ2JqDY71tn6w8I5hJqLZVGAPRDnc=
X-Received: by 2002:a17:90a:590d:: with SMTP id k13mr51370025pji.56.1626061878588;
 Sun, 11 Jul 2021 20:51:18 -0700 (PDT)
MIME-Version: 1.0
References: <20210711050007.1200-1-xiangxia.m.yue@gmail.com> <20210711050007.1200-2-xiangxia.m.yue@gmail.com>
In-Reply-To: <20210711050007.1200-2-xiangxia.m.yue@gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 11 Jul 2021 20:51:07 -0700
Message-ID: <CAM_iQpUtQGDx6yJtY5sxYVd3wNqBSDYAZ4uHZonkFQDrnLo8cQ@mail.gmail.com>
Subject: Re: [net-next 2/2] qdisc: add tracepoint qdisc:qdisc_requeue for
 requeued SKBs
To:     Tonghao Zhang <xiangxia.m.yue@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 10:00 PM <xiangxia.m.yue@gmail.com> wrote:
>
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>
> The main purpose of this tracepoint is to monitor what,
> how many and why packets were requeued. The txq_state can
> be used for determining the reason for packets requeued.

Hmm, how can I figure out the requeue is caused by
validate_xmit_skb_list() when it returns again==true?
I fail to see you trace it.

For the other case, we can figure it out by trace_net_dev_xmit().

So, in short, your patch looks useless.

Thanks.
