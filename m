Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B082130CE
	for <lists+netdev@lfdr.de>; Fri,  3 Jul 2020 03:05:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726228AbgGCBFw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 21:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgGCBFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 21:05:51 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2060AC08C5C1
        for <netdev@vger.kernel.org>; Thu,  2 Jul 2020 18:05:50 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id h19so34643218ljg.13
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 18:05:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xVy0EZL3NGAs5QTxCmkjzf1k1V1ihgTkrtrhEV3LNY=;
        b=H99GEZS5MO7QIILQwwNHlIbzBxV0CLQNGWcZ9HmeKhq1zofWEHlDiUPRy9D0/b7TL/
         hEKqZztq0ddNVL8oPgWQqq7Zt+R4ocmmJVgEE25FY16sEOVbCVVE6hQaQHBljpnBdiix
         koQcoOMiIdbUdvuHOMOEuap/Nq7zErOpE3cCE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xVy0EZL3NGAs5QTxCmkjzf1k1V1ihgTkrtrhEV3LNY=;
        b=iLLUUklzxvDqs8hI7o7ryFoee4PtpovReyssPDCTZfFv357Miw8UFXy554yMDtIiPP
         iQIGaxW0NERWk8ev8zfUcZQ1FrKmvf2q9mnWi8pBJzxuWyLKpG6q8qprev9R10DTzDXJ
         /Op89ryjb1dwA+NBCAH0PeirT0zyM5ieY7yHml16g50eR1gQPeufBU9Ar2KbEsuqjeiS
         yLCMk8KkmzOS8w7eUgkFc/gWw130P2rPeDiOQIg3uXAwTHSB4iUXTCJNFzicnighjZU2
         SmQ0P7fhF+ip+V0qeBYiokbcU57GT2yjv8kWxQqgEslfAodxXM+L+CNnLt6KTqIuDpFx
         tdtQ==
X-Gm-Message-State: AOAM533KYCCVubY6idDYAsB78u2Ssc+4mWdRoBUwbnFENxAhMaQ6rGQW
        uxgwOhFLrgTF4g0G5AVzKHQ2G5bEpeM=
X-Google-Smtp-Source: ABdhPJwAGhTPy429MAcb7+Y1i+rQhZ8lvqqBpRzCWg4F73FCT26ETZ6aMYdjE8K/cFnCZskQqsLifg==
X-Received: by 2002:a2e:8181:: with SMTP id e1mr17718325ljg.161.1593738346925;
        Thu, 02 Jul 2020 18:05:46 -0700 (PDT)
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com. [209.85.167.53])
        by smtp.gmail.com with ESMTPSA id g2sm3945185ljj.90.2020.07.02.18.05.46
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2020 18:05:46 -0700 (PDT)
Received: by mail-lf1-f53.google.com with SMTP id y13so17357822lfe.9
        for <netdev@vger.kernel.org>; Thu, 02 Jul 2020 18:05:46 -0700 (PDT)
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr20239856lfn.30.1593738345743;
 Thu, 02 Jul 2020 18:05:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200702200329.83224-1-alexei.starovoitov@gmail.com> <20200702200329.83224-4-alexei.starovoitov@gmail.com>
In-Reply-To: <20200702200329.83224-4-alexei.starovoitov@gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 2 Jul 2020 18:05:29 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgP8g-9RdVh_AHHi9=Jpw2Qn=sSL8j9DqhqGyTtG+MWBA@mail.gmail.com>
Message-ID: <CAHk-=wgP8g-9RdVh_AHHi9=Jpw2Qn=sSL8j9DqhqGyTtG+MWBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] bpf: Add kernel module with user mode driver
 that populates bpffs.
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 2, 2020 at 1:03 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> The BPF program dump_bpf_prog() in iterators.bpf.c is printing this data about
> all BPF programs currently loaded in the system. This information is unstable
> and will change from kernel to kernel.

If so, it should probably be in debugfs, not in /sys/fs/

                Linus
