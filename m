Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2633A1C5D07
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 18:09:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729857AbgEEQI6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 12:08:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728804AbgEEQI5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 12:08:57 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772A4C061A0F
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 09:08:56 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 186so3005943ybq.1
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 09:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=C14y1R1nSZ3vM1HIHFaSZXYpMS+wZVtIFoe+sKl7Sx4=;
        b=moKdVIimuT/3z6FS0xOOvWFCcpGd3YI3sPCw3Ct3yO7tvyq+25VIUjS4z7R1fdaWiF
         qnGY5m5ePpGjEDDpJ/rTgEEeS3dPgAHZj2dfcUbPETIPQrO1Etpydsd+xvqkJY+C8ziJ
         D7SC+UZqK6wSx5mMf2oSrOZyxp8o6872gCv8IjB8qsSdXcgVe1TWR90bO2O2alX1RsCc
         jBeNVELFIgCWnA54e/BK4VZNkXeb2dIpCYj7uixv7YwZSYBvygxwJhe7SVkLIytAcSXJ
         L9V3O11m1f3Z91L9dxAWfrMVo2M89C9xZeX4V7uKtbaN2pPtSe3siHU+hK6QlvAY1S1l
         ocKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=C14y1R1nSZ3vM1HIHFaSZXYpMS+wZVtIFoe+sKl7Sx4=;
        b=aIQcQKSYRguwJq7mW8dHKLMEK83XgHaOmTWxptUWHic1xaYXmPDj0OAISJsVMA/nDk
         1d1ylARqGzrUa2CgBkPyo8iPvcM59Ybrr5vnB9xOkxKqYS6O2fcoEjNkFTodDWtYqFCU
         pQUCbrI9E6x7SzBfnG7/Q/v9mBZI86AH5DW8jSmVB8aGXoWNBM7KezoXKl1nCuqGDYVq
         qg7yhHXhCE+sguMDHIQ6RF+fGmcO+C1OUQQLzkjUt6iJCWYbTqAFxQUy6vlsMIrat2N4
         tDXpiwbxvotHPbvI8d1NU2F1A1SIEy3xYGHFyuTKiF8bmFezYxTMlGOmIhSYiDJ4k2xY
         bo9g==
X-Gm-Message-State: AGi0PuZhXc9NwaKb+qncacDwVgSOZ65HX6NgHv0/Bw2pH6ktyi1uSaB5
        aIKCmm6GsiqN43T5Xa1dqm5Xdco=
X-Google-Smtp-Source: APiQypKsObMbPI2xbKqjumTZrS8h46fsdt3lKgkxwV64V1h9jGB0PcoxGcvJTJkAvpiWAk2qOSjxVWw=
X-Received: by 2002:a5b:b10:: with SMTP id z16mr5984577ybp.206.1588694935696;
 Tue, 05 May 2020 09:08:55 -0700 (PDT)
Date:   Tue, 5 May 2020 09:08:54 -0700
In-Reply-To: <CAEf4BzahmBZmffPq2xL8ca0TpQPNHZtdOnduhHoA=Ua7oy99Ew@mail.gmail.com>
Message-Id: <20200505160854.GD241848@google.com>
Mime-Version: 1.0
References: <20200504173430.6629-1-sdf@google.com> <20200504173430.6629-2-sdf@google.com>
 <CAEf4BzahmBZmffPq2xL8ca0TpQPNHZtdOnduhHoA=Ua7oy99Ew@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] selftests/bpf: generalize helpers to control
 backround listener
From:   sdf@google.com
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/04, Andrii Nakryiko wrote:
> On Mon, May 4, 2020 at 10:37 AM Stanislav Fomichev <sdf@google.com> wrote:
> >
> > Move the following routines that let us start a background listener
> > thread and connect to a server by fd to the test_prog:
> > * start_server_thread - start background INADDR_ANY thread
> > * stop_server_thread - stop the thread
> > * connect_to_fd - connect to the server identified by fd
> >
> > These will be used in the next commit.
> >
> > Also, extend these helpers to support AF_INET6 and accept the family
> > as an argument.
> >
> > Cc: Andrey Ignatov <rdna@fb.com>
> > Signed-off-by: Stanislav Fomichev <sdf@google.com>
> > ---
> >  .../selftests/bpf/prog_tests/tcp_rtt.c        | 115 +--------------
> >  tools/testing/selftests/bpf/test_progs.c      | 138 ++++++++++++++++++
> >  tools/testing/selftests/bpf/test_progs.h      |   3 +
> >  3 files changed, 144 insertions(+), 112 deletions(-)

> Can this functionality be moved into a separate file, similar to
> cgroup_helpers.{c.h}? This doesn't seem like helper routines needed
> for most tests, so it doesn't make sense to me to keep piling
> everything into test_progs.{c,h}.
test_progs_helpers.{c,h}? And maybe move existing helpers like
bpf_find_map, spin_lock_thread, etc in there?

Or do you think that these networking helpers should be completely  
independent
from test_progs?
