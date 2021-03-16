Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E35933DCBD
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 19:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240080AbhCPSoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 14:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234517AbhCPSnt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 14:43:49 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 879A4C06174A;
        Tue, 16 Mar 2021 11:43:47 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id x29so23198869pgk.6;
        Tue, 16 Mar 2021 11:43:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7UgBChjZpHGGBdJz45MNfk2R0PgaJI9RIsUqJZWEEBg=;
        b=l2O/tdtwHTVc0iET1er/VEODA9L9wa5qHiP7wNPIX7Y1qE9OXqg9vOjetPqgmoPwiT
         h48n5cE9y8647npjRt9zlhxaC1wkH6pqQ7oQ3U+O/x46RImVPz9Dx4a60Tnff3yV2RsW
         234P6+nT4R7LFEC+WHpFDOwX8Px1gW7wU491sr5BW1ShWYP9VMBFhirTbVWABGvl9kGZ
         u07bxSP5joMIH61ukdFm7fprNvDDD6R1HBdJEpwHn+9El438e5Uek+7HD4PGJYofe5Yb
         DIjYdPZmcdfQSICLo2bUFqQBvHvTqCTAVuUN8JwusCe/YU1y+z5lGzLOfO2KQdgZH0B5
         kyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7UgBChjZpHGGBdJz45MNfk2R0PgaJI9RIsUqJZWEEBg=;
        b=A4lmKnD4licSDBnAtFWc37gXDI/7ay1IuWSu54OhKuzvptpdzz/0Lg1Ren/l1pMwz5
         5fPVedPXlgOXwkRUGSjV4YBJU79/rwmlG/Bc4d35KC6OifADlP35qP+aZwCXYgcbUfUt
         nMcQPJ86TRaBBkc7XJeOpxIGeLFQ03N/JcW2nRMTbETgOYii4Izm3Rb417aXRDPA41s1
         qR4bXhfnXUnbtwskCKeFAdOomutWX3UmBBpawofaUc6IR42H8ENx91s5Vu5H2SPFxXSc
         XLF6A0hLxvc12UQ2pTpymdsnWomOWazcQZKAo+uWBkjVr8llR7efb9AtDGpLuU++OUD5
         JAkA==
X-Gm-Message-State: AOAM533mNFGjtpGik1/L9QpeDO6oJ+w+Watw/G67Lwj11TKH2pguKmAf
        v3QD7DwN8MkTBHWf7RcZssMHUN0/cW/6OZ9cs8s=
X-Google-Smtp-Source: ABdhPJzkjw+riPDdKPZ7e0APAki+fUeTEDADQ6YafUXUv3g/dKs/k9cOusTUQ7imNWkKGKoCH+Q4mb0do9k4fNjGYDU=
X-Received: by 2002:a63:1266:: with SMTP id 38mr917541pgs.266.1615920227155;
 Tue, 16 Mar 2021 11:43:47 -0700 (PDT)
MIME-Version: 1.0
References: <1615800610-34700-1-git-send-email-linyunsheng@huawei.com> <20210315.164151.1093629330365238718.davem@redhat.com>
In-Reply-To: <20210315.164151.1093629330365238718.davem@redhat.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 16 Mar 2021 11:43:36 -0700
Message-ID: <CAM_iQpWPSouO-JP4xHFqOLM8H4Rn5ucF68sa_EK5hUWSYw8feA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: sched: remove unnecessay lock protection
 for skb_bad_txq/gso_skb
To:     David Miller <davem@redhat.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 15, 2021 at 4:42 PM David Miller <davem@redhat.com> wrote:
>
> From: Yunsheng Lin <linyunsheng@huawei.com>
> Date: Mon, 15 Mar 2021 17:30:10 +0800
>
> > Currently qdisc_lock(q) is taken before enqueuing and dequeuing
> > for lockless qdisc's skb_bad_txq/gso_skb queue, qdisc->seqlock is
> > also taken, which can provide the same protection as qdisc_lock(q).
> >
> > This patch removes the unnecessay qdisc_lock(q) protection for
> > lockless qdisc' skb_bad_txq/gso_skb queue.
> >
> > And dev_reset_queue() takes the qdisc->seqlock for lockless qdisc
> > besides taking the qdisc_lock(q) when doing the qdisc reset,
> > some_qdisc_is_busy() takes both qdisc->seqlock and qdisc_lock(q)
> > when checking qdisc status. It is unnecessary to take both lock
> > while the fast path only take one lock, so this patch also changes
> > it to only take qdisc_lock(q) for locked qdisc, and only take
> > qdisc->seqlock for lockless qdisc.
> >
> > Since qdisc->seqlock is taken for lockless qdisc when calling
> > qdisc_is_running() in some_qdisc_is_busy(), use qdisc->running
> > to decide if the lockless qdisc is running.
> >
> > Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
>
> What about other things protected by this lock, such as statistics and qlen?
>
> This change looks too risky to me.

They are per-cpu for pfifo_fast which sets TCQ_F_CPUSTATS too.

Thanks.
