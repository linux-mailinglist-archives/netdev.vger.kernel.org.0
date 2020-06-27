Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D23620C418
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 22:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725932AbgF0Ue6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 16:34:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgF0Ue5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 16:34:57 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894D5C061794;
        Sat, 27 Jun 2020 13:34:57 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id q198so12036721qka.2;
        Sat, 27 Jun 2020 13:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LElBDHTTMn9qMHSwEfjlESwGT7fS/VgY0FD9zMzhcSk=;
        b=RH/DZm6xtX+1UNWqgY1c5FaBHHY0EVnaxmswqO9z51psOntUVnVXc/0irlzyCvoFZJ
         DCLfXoTwDh8h+iBIA6uDfRR+mq6oApI59ViCHTl51MkBVcMDsKF0vEGZEyezXbZ/MvWB
         FsjJIfCPYR2E4wEjsnTuU8UxtCHmy8/tHaRsuxkKB6m4xJqey8SyyrCJj5ckvOSbxiGB
         DUFw5Aa6mpk56+0Fa7dS4Uh+OboySFTS4jbzrDuHVw19vRSYtkUsJlYsvFck7RjBnO+C
         0+sGGIoLx6I1UAFXr46o4+yR5OHA5oqjhD7EZQGnWe48srbyBmnwoZIsTa66jKnxIa6O
         Ixbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LElBDHTTMn9qMHSwEfjlESwGT7fS/VgY0FD9zMzhcSk=;
        b=TQmC9i48AmAbUg2KqWs6b55LdyqXd/ccn9lKEdEumXxjsHahYm6ceO1KP4Q8okvKgt
         bYX/WWPigwwmie7VfJlpq2SXBl/xDD4oM42Q6ZdD+ltO5es6rR1JZqLAU5riicKxwoUS
         KBPlssYyYKXs+0miEilAWVLy84o3VduidsrlKEmqNCicF5S9SLylfWhIPJCspAMTj8zN
         e8JUcAlkPLoERWAa4FqVrOhF1gyBtVIE6ThyB6gfzdVIxI9b9jWR4Uf7HZ0xAPmkty9P
         iwzfAGhyo7YUET/4Jj9gPi+uHxkXFABQ1nZ2fETKX1e04Df60ZunwASrHSVhLn0TR5cm
         z4GQ==
X-Gm-Message-State: AOAM533qEF6jAIyJLaMTmVUvfsSVRkaFCcKx6011hI+adURrlq8Wy7Nm
        A7cc0irWiyNqpLoeYzBZ29E4bxyTf6A+JAF30jM=
X-Google-Smtp-Source: ABdhPJyFGUc8Z40kzre8jYY3WlNjjmI/QX4JNYy0m+bh8RCzhC0CKvD5TnPIoSIuZpH6LznyoBbcT33pxdq40MaaCck=
X-Received: by 2002:a37:270e:: with SMTP id n14mr7945083qkn.92.1593290096799;
 Sat, 27 Jun 2020 13:34:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200627002609.3222870-1-songliubraving@fb.com> <20200627002609.3222870-2-songliubraving@fb.com>
In-Reply-To: <20200627002609.3222870-2-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jun 2020 13:34:45 -0700
Message-ID: <CAEf4BzY0CbYK=C_wxU8xw=jm8CSpHddfyi7ccPKe2gxJeN6gAA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] perf: expose get/put_callchain_entry()
To:     Song Liu <songliubraving@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Peter Ziljstra <peterz@infradead.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 5:26 PM Song Liu <songliubraving@fb.com> wrote:
>
> Sanitize and expose get/put_callchain_entry(). This would be used by bpf
> stack map.
>
> Suggested-by: Peter Zijlstra <peterz@infradead.org>
> Signed-off-by: Song Liu <songliubraving@fb.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/perf_event.h |  2 ++
>  kernel/events/callchain.c  | 13 ++++++-------
>  2 files changed, 8 insertions(+), 7 deletions(-)
>

[...]
