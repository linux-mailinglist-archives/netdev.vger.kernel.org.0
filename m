Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5396E288C42
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389129AbgJIPIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:08:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388727AbgJIPIr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Oct 2020 11:08:47 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DACAC0613D2;
        Fri,  9 Oct 2020 08:08:47 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id 77so833426lfl.2;
        Fri, 09 Oct 2020 08:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tXhVd7/r28nxjNqX+hID20rmcnQF5zBIPjoCLjo1J+c=;
        b=BQVaDQhtLbYKu+MXc9G/HKP2KDxJ31OHANcTWSAJB0udY3RIuf0UgziG9nQsV+R+Lv
         OQllhCR7RDJd0sLL4K78uXcGItgXVaTdnZvzo1qJEJBER+t034/G3mze2UrJHOe2DjX2
         Um4CwCNjkILKRN/ZEQ7kqcUeOpA2O0OsjtJ34aP11Z+qKfBxDfqf+QPCP5Xh0Whq8L9m
         eiDtOxPWjLhhzgGlMKCijIAmRBBTae0M3T4lc8+GQ+xupwF6tnUhlpXG6UmWQEM5CAAY
         br71bC9Zw9ovoMDqoArBdkgFxl16d06B+FJlHi7ZMFaXOSQsYJNX47XTJBaIgjoYRMle
         gTsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tXhVd7/r28nxjNqX+hID20rmcnQF5zBIPjoCLjo1J+c=;
        b=eNQo1425fbjVcuFvyrH9hVG0vAg39KvMBZLmJoD/KZmneRUDC4A8qwiJ/RlpPXUUjb
         H7hvt0KLcOY2Ss0o0buq54EvQVtYNlWGKhLCYwZkQlZ6Nhn+mO8x0MbrbYbP60BvABVQ
         09RZY7yOzqPXdybo+SaQERcydmI8DVVbUx9o0YF3AAeaYZAZDYQknFrpDAhfZ6tXK4i4
         nbl0dWkFx7YLVUOlaqcsDI9fEGZX2sqakIWJ5H4zsAS3YW7GERiXvbQRs2SWaQCheJbe
         E5neQsRbRchGEpZrMcbOQzYYU1ojiV3AA0M/cICuy86W2n4j23eDD1hWVJBunu9ZnKZL
         loeg==
X-Gm-Message-State: AOAM53274kSOjpmInuBzGj5GE5jYNJ3THVn9eUp3bmi0qf9/Xe2SAGxT
        v9v6egHbC9Te5hc4Ff9t1ClM/2CHlA2AcV3M3DI=
X-Google-Smtp-Source: ABdhPJy7SP06VdQ77Y+5ScE+pINmrxGmKP1bh1vtrmJcWtfWu1N536E8lMd6V6X5oWY4qfZPyVzAK0vRZeY3nOOscnU=
X-Received: by 2002:a05:6512:3f0:: with SMTP id n16mr4128906lfq.554.1602256125862;
 Fri, 09 Oct 2020 08:08:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201009011240.48506-1-alexei.starovoitov@gmail.com>
 <20201009011240.48506-4-alexei.starovoitov@gmail.com> <5c129fe9-85ad-b914-67d3-435ca7eb2d47@fb.com>
In-Reply-To: <5c129fe9-85ad-b914-67d3-435ca7eb2d47@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 9 Oct 2020 08:08:34 -0700
Message-ID: <CAADnVQ+MCPWoCOB7_ZWsiT7Xs3ek-s-ti+Gx7uYOjpDtAO1oYA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] selftests/bpf: Add profiler test
To:     Yonghong Song <yhs@fb.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 8, 2020 at 11:49 PM Yonghong Song <yhs@fb.com> wrote:
> >
> > profiler[23].c may fail on older llvm that don't have:
> > https://reviews.llvm.org/D85570
>
> Not sure but the below equivalent URL may be more intuitive:
>    https://reviews.llvm.org/D85570

It's the same URL :)
See it unmangled here:
https://patchwork.kernel.org/patch/11824813/#23675319
