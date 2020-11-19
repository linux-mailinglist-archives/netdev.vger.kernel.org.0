Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E6AB2B947C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 15:23:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727408AbgKSOTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 09:19:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727211AbgKSOTa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 09:19:30 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 030BDC0613CF
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:19:30 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id i19so8117427ejx.9
        for <netdev@vger.kernel.org>; Thu, 19 Nov 2020 06:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=73HPf0HP0X+izlyQlk4DSNYGFdqsmbQ2peF4bypejPg=;
        b=jK2iwwC5Z5N+Vs2ixeN30Q31Gwd2kysImcpU/6ts0Vgw46CtggCzvlRdQdEkaF8vS5
         rnJvUrl/SNG0dtphukCkIRX/BoVFlHJvPFjeiXyXJWQjbJmcr0xA6V4lNsgxOCvq4mJt
         YhmG4n2s1DBulLldAtXMPnVTY3nAa3khlYzTxN+4Wr4wTYGEnY3B6YFsGCzVxwEA6+9A
         7u7goju3nT8Ix77+aH4VL2rsoNzW0XFSmt84Z9gSwmcFhn+XSafh9E7iCUzULpGSsaFT
         QwrUgifY/zEcHJpG+ENqItzMvmLJPziTZ7OyGvNP5T3mBh2Y879Pxojtxp76sbkWlW4x
         lSaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=73HPf0HP0X+izlyQlk4DSNYGFdqsmbQ2peF4bypejPg=;
        b=Rum3ELgQFN3bxMcNv95BE554mmQcYF5sezEDq/wO7+X2RQ+YTlxYrbazjSc/jRTqnk
         8rL2yVanzC8iHpKPRG5vs5Rc/YGnKydVK2voy4tB3o3gNNy6hrcgXtpsU7ZrkrfrPIGG
         bk1Bk154PVIBkLnEnyVL2VzCAscluMWSe4LCZXk82fI21fNRDX5m4lCd/W1nek+ZsJXK
         H5vTcD/JGnlRpGIaEzaxr7L1RfD2zKBRAno3RUM+Bu/NTSRM410tWjheSRZ9o+H7WSwt
         xxH0hluJ3wjv1H+sRMzAZOHLkr4AHr+7ldtTZ5LJoO/mZLAj450zGFJe4YVbH/a2Gewt
         EfZQ==
X-Gm-Message-State: AOAM533G80VkoRUeN6osTX81UquYLFAXMxdFldcE2WrSQ6MxHUOZutmj
        0ccM0nl8HkjK012hDtYKC8qMwqTk11HpTEoOr0BNEQ==
X-Google-Smtp-Source: ABdhPJwSMYQo9xZ8yQIwvvhVzzf3e+YQYjoGmQLQs5u4UhFKHMR1wU5fIqmIMSIrtvPJHXkbp+V4ZsDbR2rfSBujffs=
X-Received: by 2002:a17:906:7043:: with SMTP id r3mr27672626ejj.287.1605795568580;
 Thu, 19 Nov 2020 06:19:28 -0800 (PST)
MIME-Version: 1.0
References: <1a72039f112cae048c44d398ffa14e0a1432db3d.1605737083.git.pabeni@redhat.com>
 <d69c8138-311b-f94e-74b8-1e759846eec0@linux.intel.com>
In-Reply-To: <d69c8138-311b-f94e-74b8-1e759846eec0@linux.intel.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 19 Nov 2020 19:49:16 +0530
Message-ID: <CA+G9fYstUYSeXh=w2YSmytHfBg2=tnwyAx_hCJtn2Dfi_Ts91g@mail.gmail.com>
Subject: Re: [MPTCP] [PATCH net-next] mptcp: update rtx timeout only if required.
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     Paolo Abeni <pabeni@redhat.com>, Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, mptcp@lists.01.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 at 06:13, Mat Martineau
<mathew.j.martineau@linux.intel.com> wrote:
>
>
> On Wed, 18 Nov 2020, Paolo Abeni wrote:
>
> > We must start the retransmission timer only there are
> > pending data in the rtx queue.
> > Otherwise we can hit a WARN_ON in mptcp_reset_timer(),
> > as syzbot demonstrated.
> >
> > Reported-and-tested-by: syzbot+42aa53dafb66a07e5a24@syzkaller.appspotmail.com
> > Fixes: d9ca1de8c0cd ("mptcp: move page frag allocation in mptcp_sendmsg()")
> > Signed-off-by: Paolo Abeni <pabeni@redhat.com>
> > ---
> > net/mptcp/protocol.c | 9 +++++----
> > 1 file changed, 5 insertions(+), 4 deletions(-)
> >
>
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

The reported kernel warning was fixed after applying this fix on top of
Linux next tag  20201119.

- Naresh
