Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA7061D6BCE
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 20:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726349AbgEQSra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 14:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgEQSra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 May 2020 14:47:30 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7A8AC061A0C
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 11:47:29 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id z3so4549872otp.9
        for <netdev@vger.kernel.org>; Sun, 17 May 2020 11:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=X5uUNbwEFxYxWgzgrluo9rHRacidtJEKSYGdCh3Po74=;
        b=O4fLYuuGazN3dCb0c+R7Zr6R3sG2YHO6NelaSyrZxRfY0tkQWaoBsOAz+76T7s5Q6z
         GG1yTbfyvZbRfqGcMbCcYLGaMKMq7ozVhrVSorJxZZP+P6W1PTXyCgzAycynwiGaNXeC
         cK8HdJQFGKsI02hvHf9b4gdQYHIlwChRX0Gu9G1w0UqBwpr6itu0J0D8ZcRJyIPdyHZs
         SkFi7MlqLlXa7o06+ivwpYvDcx4cs+80vlqZjsd0h1hWNXc718KtdmDc+PjRLIBhsxjM
         BjTfWEFXsKD3/CKgm3o2RtPBvLDPSuZVX93Wf4l8VIS9H0aWeXOxUvJpWPSDsUXgXRgC
         DETw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=X5uUNbwEFxYxWgzgrluo9rHRacidtJEKSYGdCh3Po74=;
        b=JdxFegt2STrFqt81C+kdgD6MusQp37hGgHjo3i+ZI2sp7Fp6agw0h2CVBsFFAL8F47
         E9d1B5AuDgpuCh9cFhKR4KTNkIEcbPv3p9YdahfqQDkI2qYXHAC5yf/2W2XHQr3LUvQu
         qvwjwVoCI6XDtLwIHMCwSKpSGap4bFTPxS2b5xf17fkzNT6yr1J1a3MtrY+TBP08kTyL
         WSL/hpECiUv9WRp2HqK0S4nIl396Y0sVf7aCKcZ+cBhFc38RL2z47qVJXebnUt6YoCvX
         OQdvVQhdStWekIuctZKDGjfU5KtDHcVLfG7VX59mJoBFSBgEmDTQJT+FiFfZyeJbQWq4
         4XTQ==
X-Gm-Message-State: AOAM5313hAwKfMPOrNdIXdy2xBPgKAmtlHMKsMJ4LM2tTWKpW18wiS2X
        zZrnJQpeu5rpXewgSIbiIqqysPhAo1cJoj0bg5ppkus2
X-Google-Smtp-Source: ABdhPJzVFlwlqFWe+U/DbPRdJm8gNNOVR44kortQxbragfjLHHCaxLmsudnN943DpiltVWxAjTxbvwXhFLtrhiY4Gvs=
X-Received: by 2002:a9d:4a1:: with SMTP id 30mr6752126otm.319.1589741249088;
 Sun, 17 May 2020 11:47:29 -0700 (PDT)
MIME-Version: 1.0
References: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
In-Reply-To: <1589719591-32491-1-git-send-email-mrv@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 17 May 2020 11:47:18 -0700
Message-ID: <CAM_iQpXx-yBm2jQ57L+vkiU+hR4VExgzFrntw3R2HmOFpzF5Ug@mail.gmail.com>
Subject: Re: [PATCH net 1/1] net sched: fix reporting the first-time use timestamp
To:     Roman Mashak <mrv@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        kernel@mojatatu.com, Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 17, 2020 at 5:47 AM Roman Mashak <mrv@mojatatu.com> wrote:
>
> When a new action is installed, firstuse field of 'tcf_t' is explicitly set
> to 0. Value of zero means "new action, not yet used"; as a packet hits the
> action, 'firstuse' is stamped with the current jiffies value.
>
> tcf_tm_dump() should return 0 for firstuse if action has not yet been hit.

Your patch makes sense to me.

Just one more thing, how about 'lastuse'? It is initialized with jiffies,
not 0, it seems we should initialize it to 0 too, as it is not yet used?

Thanks.
