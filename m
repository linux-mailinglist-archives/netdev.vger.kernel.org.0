Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17E7F38BDCA
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 07:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230346AbhEUFOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 01:14:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbhEUFOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 01:14:01 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41D36C061574;
        Thu, 20 May 2021 22:12:37 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id b13so24478268ybk.4;
        Thu, 20 May 2021 22:12:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G+ZE7911HfFWAUq08fRAK7qsCW/yHSCCc+PxVN2vjus=;
        b=hdUWeImL7hmeAFOixgUCff92DmEodm7SlmTMDNLOczI7urrwLUAgN6Q3PcwUeKBXHH
         kp5kNL/Jnwe5FAzjlYa5nFTktnBkzCl3HZS9GLaPfWICrh3pSYZ8RPa3gCbfi7J8feeP
         6e6OIiOs3BywtkkPOUkySc8rDoIRVszQlRlc0M5cvxNfDb1QE53nbtHxvzdG6Iv8FJx/
         UsHa6U2nmP7U4goB1AZz2+GxEIO3q0SdbhmkG7noF+LUG8HosIhSIVemAfREl3ygea9o
         asA5oZysGNsh+EVSEfMpLkNKhLEb9NODODQc52jm6K31Kk8iOIhNq1dIGHWqYVAdXWgj
         jPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G+ZE7911HfFWAUq08fRAK7qsCW/yHSCCc+PxVN2vjus=;
        b=phP43aD7D8Xqo2v4/1oO3GBzeLTjH9z+GavqAhV1FjswlhzGvozV9dQzducSASCmsu
         CA28NJyo31r1ZRZP90EpLpEXNC1FclKZsgynEJNXcfwJrx4D/6mj08iNPE2xl0cEniYz
         dldv2AGjceYdHKT+g6YhKWStZPg3N4gQrfDo4kpPzsjKhM1xolg71StGe8Fsssul7SYY
         Iw4FfnU7ujjA11lHnLmtgleIfQXLMxcGCmryD+WEkqYYyre28fuNH4BtCxGCsTKd8YVi
         KjjIdnlKEKQgPiD3AkoSWyW1GACRr/DKoH8JAyNAx6aCMDkdEWbnwqFD4WipaFznWs9T
         SGUQ==
X-Gm-Message-State: AOAM531Cr4dhwN/UYOxfC7lTSLeQH89tsINK8CSwxdu7qeVOOvLm2sEm
        XSE9qa3SV3BYfUvBU2GYYXtneraFBdgFJ/yTThrm92b8
X-Google-Smtp-Source: ABdhPJz0omcwvM8+TAZPc0ueITZea4OyYIzUPTacPMisR6VcTEbBUE0c6Z8Myne1MdgjnlGUy/SgbA9pM0y/OTU7kDU=
X-Received: by 2002:a5b:286:: with SMTP id x6mr13198182ybl.347.1621573956500;
 Thu, 20 May 2021 22:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch> <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
 <CAEf4Bzb7+XrSbYx6x4hqsdfieJu6C5Ub6m4ptCO5v27dwbx_dA@mail.gmail.com> <CAM_iQpVAhOOP_PRsvL37J1WwOxHKmLEnRXVBYag1nNccHN7PYw@mail.gmail.com>
In-Reply-To: <CAM_iQpVAhOOP_PRsvL37J1WwOxHKmLEnRXVBYag1nNccHN7PYw@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 May 2021 22:12:25 -0700
Message-ID: <CAEf4BzYUw8bTUXEdrkRwqFg0OGsMTNe+kwxkbdqAMV9we4xifw@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 1:44 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Thu, May 20, 2021 at 1:14 PM Andrii Nakryiko
> <andrii.nakryiko@gmail.com> wrote:
> >
> > Bugs do happen though, so if you can detect some error condition
> > instead of having an infinite loop, then do it.
>
> You both are underestimating the problem. There are two different things
> to consider here:
>
> 1) Kernel bugs: This is known unknown, we certainly do not know
> how many bugs we have, otherwise they would have been fixed
> already. So we can not predict the consequence of the bug either,
> assuming a bug could only cause packet drop is underestimated.
>
> 2) Configurations: For instance, firewall rules. If the selftests are run
> in a weird firewall setup which drops all UDP packets, there is nothing
> we can do in the test itself. If we have to detect this, then we would
> have to detect netem cases too where packets can be held indefinitely
> or reordered arbitrarily. The possibilities here are too many to detect,
> hence I argue the selftests should setup its own non-hostile environment,
> which has nothing to do with any specific program.
>
> This is why I ask you to draw a boundary: what we can assume and
> what we can't. My boundary is obviously clear: we just assume the
> environment is non-hostile and we can't predict any kernel bugs,
> nor their consequences.

It doesn't matter. Instead of having an endless loop, please add a
counter and limit the number of iterations to some reasonable number.
That's all, no one is asking you to do something impossible, just
prevent looping forever in some unforeseen situations and just fail
the test instead.

>
> Thanks.
