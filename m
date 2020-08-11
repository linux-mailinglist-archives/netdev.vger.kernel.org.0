Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B84C241A0E
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 13:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728550AbgHKLBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 07:01:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728416AbgHKLB3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Aug 2020 07:01:29 -0400
Received: from mail-oo1-xc42.google.com (mail-oo1-xc42.google.com [IPv6:2607:f8b0:4864:20::c42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A5BEC06174A
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 04:01:29 -0700 (PDT)
Received: by mail-oo1-xc42.google.com with SMTP id p137so2524282oop.4
        for <netdev@vger.kernel.org>; Tue, 11 Aug 2020 04:01:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=0CfAWiOLHPM+GE/ykTTmqNnylfycowdFemnAk/Vhwgc=;
        b=FxEre9drYf/9wx+1OzpT7gf93G9SRRMZ6C1duCAmzMPnYl+p6FMEYGe7oNSN7OUpHe
         KCU7VPV+PTAcJ9JJyb4T5YdeHXfn8WEnjqjkCVhVTaLH02EJnxOGY5IkYXVwRMVoBwEA
         3e6AfFOjj0zNY2F7XN3lSGyOoNLtXVBUApc4bc5OV1U5PwrO8VmqaenQNidCCo3SHSB+
         WJkS6D1Nw+NhUrWOQXXMhCEfe93JzHmXK/eT9YIRuHlZ4zwvZDQKBp8nwhXrM1bKHIXC
         WYKmT/wuYQPEP6BHnlstg71d+MsnzXL14xP2uTCnSh5/1iCpDa/zYBGuNqMgm2nw34cq
         kKZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=0CfAWiOLHPM+GE/ykTTmqNnylfycowdFemnAk/Vhwgc=;
        b=Hb8yXvleZjREdiBkwa9WAswV++o0+QtRnQLNSieaT1CxCABrRQXoSdwkjvDpbnGBmN
         /QzO0tjIz3fe+Ha9rZk7utr7ghZVFWVc9UN1MRPHYvrM78mkeMTnhbzm7lK+lHcpiC8S
         T2VDxjQpNqczirFG0O0e9sUeY3jY49n6HV7pm4dFd2lg4YDkp81UrcP+EZw0dam7E8IO
         AitYEyvITlJX53tcDFyyXf9KhB/FvA2XqnGPSK10+D27xmCmXyzPDnoFpenxqDnJzYDp
         NdiB09jMCszFSHwtQPWPQOyqUtWasYxDVt8HClXlx/EViS0Jx3X/mcq+6WnlM2f/WShK
         vXJg==
X-Gm-Message-State: AOAM532ncuIB798x3zzQan4vGhPg/3coF8sYR/TFrl/bjJikMzHdM2ih
        Urcgh46hIrmwcSNJNkdcuS8OcVwwE8EZy48EXLk=
X-Google-Smtp-Source: ABdhPJw1HvS89bbec6J913X2b92xngMe9W+uoHAU+fLOCwZpfG/R2KQ8lSSmQTuHvAmQzas7G0jGSavmX6KHW8mXQqA=
X-Received: by 2002:a4a:7b4b:: with SMTP id l72mr4609078ooc.74.1597143688606;
 Tue, 11 Aug 2020 04:01:28 -0700 (PDT)
MIME-Version: 1.0
References: <CA+icZUVnsmf1kXPYFYufStQ_MxnLuxL+EWfDS2wQy1VbAEMwkA@mail.gmail.com>
 <20200809235412.GD25124@SDF.ORG> <20200810034948.GB8262@1wt.eu>
 <20200811053455.GH25124@SDF.ORG> <20200811054328.GD9456@1wt.eu>
 <20200811062814.GI25124@SDF.ORG> <20200811074538.GA9523@1wt.eu> <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
In-Reply-To: <CA+icZUVkaKorjHb4PSh1pKnYVF7696cfqH_Q87HsNpy9Qx9mxQ@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Tue, 11 Aug 2020 13:01:17 +0200
Message-ID: <CA+icZUXVpVSRn74N_3b2CNPa_hh+aWXMBmtYStBTRf2ARvr-Xw@mail.gmail.com>
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     Willy Tarreau <w@1wt.eu>
Cc:     George Spelvin <lkml@sdf.org>, Amit Klein <aksecurity@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Andy Lutomirski <luto@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the previous discussion...

"Flaw in "random32: update the net random state on interrupt and activity"

...someone referred to <luto/linux.git#random/fast>.

Someone tested this?
Feedback?

- Sedat -

[0] https://marc.info/?t=159658903500002&r=1&w=2
[1] https://git.kernel.org/pub/scm/linux/kernel/git/luto/linux.git/log/?h=random/fast
