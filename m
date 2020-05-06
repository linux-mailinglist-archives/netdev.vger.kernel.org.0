Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BEFD1C763B
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 18:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729923AbgEFQ2F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 12:28:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729907AbgEFQ2F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 12:28:05 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DCBC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 09:28:05 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id n22so2989125qtp.15
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 09:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=coxNnLbWPC326Mrpkn1JFdCLcBMx+ouIrI1YVFoqF0c=;
        b=a0GWbpNkcFlthlZUKxsEQ1fcB/kr//t8djblSVGO9rJW87DWdb2tmaYucPNPbUyRe+
         XgGJiJ+1fYY6UyN1VO7lI0lLKJoWyejwTkvEgpU7XlZ5vJCrqrz5WZfgOxirEBCsm2ff
         GvBKTir9SG380Tu+EG0SSdEjtQgsaI+loKANCwUwM7LmMD+v94XuJqwQZbTxrrEPCwMk
         T57f+thr5vlDoo4o95OVTXVsL0EXFSTGmL3KfgnBiiMA2Pm0nK2dWLD4Gf5UAt0qOeO5
         BqGWqdXqL3emJNYpkhOwuRGnKqGuOoIVxVKXE9D1shd7vgolmQiU0eW3zhblpeV+Ef22
         YlkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=coxNnLbWPC326Mrpkn1JFdCLcBMx+ouIrI1YVFoqF0c=;
        b=awURogS25cNE/tW72N6oZuLW72T9yQ98fX83UZBSL4qa2G/HOGB7vm8J3o31bYi3jS
         iGCpx/GXg5PmeF+TY56qMgCAn2RrkypSNTCWEMuzjKCDysJ3kYTKnQuX2lKXfJR2/RDm
         rk80UbtvM39Y88Se6NOnG4Kh8LiRv/d0uck7dI5KkwNnL3+vyOl4W/gMNElL5VN27VBH
         fiAQiXcAuxMq2wodWH+OIJiO2X5ukvq0bn0ytIwPHn/zs19zZlCiXEyh+NekCavLOgfD
         nxk5LLgI9BNd9WH0G3RJeHCFLyYiUuhCMWWvQqCNtxrn6A067PmHpISCJ/kValS3BiRy
         yroA==
X-Gm-Message-State: AGi0PubIP61uDfQ8DDIEttEbImRSpVMkf8g/32Q5CksIeoWNcrxT/g17
        JJq0TP1/AfPhqn1Wubx2XT9fMD8=
X-Google-Smtp-Source: APiQypJT2E7PiYaQxXqTvwXVfsxw+IiDVCw46UHt19BGqYT09z03mctdfjmXPlYQwV31hiMGSV+TH3U=
X-Received: by 2002:a0c:b604:: with SMTP id f4mr8783396qve.40.1588782484152;
 Wed, 06 May 2020 09:28:04 -0700 (PDT)
Date:   Wed, 6 May 2020 09:28:02 -0700
In-Reply-To: <20200506070025.kidlrs7ngtaue2nu@kafai-mbp>
Message-Id: <20200506162802.GH241848@google.com>
Mime-Version: 1.0
References: <20200505202730.70489-1-sdf@google.com> <20200505202730.70489-2-sdf@google.com>
 <20200506070025.kidlrs7ngtaue2nu@kafai-mbp>
Subject: Re: [PATCH bpf-next v2 1/5] selftests/bpf: generalize helpers to
 control background listener
From:   sdf@google.com
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/06, Martin KaFai Lau wrote:
> On Tue, May 05, 2020 at 01:27:26PM -0700, Stanislav Fomichev wrote:
> > Move the following routines that let us start a background listener
> > thread and connect to a server by fd to the test_prog:
> > * start_server_thread - start background INADDR_ANY thread
> > * stop_server_thread - stop the thread
> > * connect_to_fd - connect to the server identified by fd
> >
> > These will be used in the next commit.
> The refactoring itself looks fine.

> If I read it correctly, it is a simple connect() test.
> I am not sure a thread is even needed.  accept() is also unnecessary.
> Can all be done in one thread?
I'm looking at the socket address after connection is established (to
verify that the port is the one we were supposed to be using), so
I fail to understand how accept() is unnecessary. Care to clarify?

I thought about doing a "listen() > non-blocking connect() > accept()"
in a single thread instead of background thread, but then decided that
it's better to reuse existing helpers and do proper connection instead
of writing all this new code.
