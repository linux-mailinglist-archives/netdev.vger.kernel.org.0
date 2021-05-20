Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 422F338B88E
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhETUp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:45:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbhETUpz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:45:55 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F1EDC061574;
        Thu, 20 May 2021 13:44:33 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id e17so2660503pfl.5;
        Thu, 20 May 2021 13:44:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LvaO10axZxZnmPP+ubPqfilk3nAKG2iewQZYrOgByIk=;
        b=l2tSCGw3F/DGvf76S2FRAYgdbU9OtEWsGADmPgE40xGwviHCAwty47QVXFXwxHSQS2
         cT20ggWMbUrE327uM2Ce0QV+GdUVvo/JSCZ4qxrP5s0cyXIOCXY0C/MgMAtNO6RJLDWf
         3iSaM6Uqz12NI8mRthZkW8+nXExKlNbFJ9QviUAWKMAZBEFExOIOlgq0iUFQfNND78hd
         ShsyCuIxcwsnnrhtTnsm6v4tDbQ4QGtx7ht61NqOk1FZUnHXjejLE9ubhFSJ7IrGHt6/
         GsaVz+B0wQOa1a81npPoFj0IReH0nGyRPWybGvZAzNl/NbQF+9PVjlxI/v6d9c2iainR
         tv7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LvaO10axZxZnmPP+ubPqfilk3nAKG2iewQZYrOgByIk=;
        b=RLGm9vVNKoj/nP0YDAALe7m6DYZtYUxXf6iboKKM+AlehEECCJPtXJKtErW2XAhS6t
         Zijz28Ev5tYFjBgxnBcHSDZYO3f9RxOk/HCqDjFWHbaiWSfCChDaWQaiQ4KUxxLifdBb
         bUCyV8zmLxv16P51U3WTNelXwXLwBIZf1wSyMreDB29ycZqg0XgiKuAAEyuOglt4iksD
         G4PpFyIHC4yfQM4lU7hndmDld/QGcNEV/iuMDZ9zwck+0R5VhCa6SXrefBRnYqklsNRx
         TB1ti1gjtQmr2fipol8BDO5xNcHaKNucHzIZRk0KpvH0omxE82vbExdKqKdPhb4YgbDe
         CX4Q==
X-Gm-Message-State: AOAM531ufbrx4gsJVa9t2BDPvmpl2xIlqaqff0/TfrW7tnOofw73cVau
        tDiPXKtSXlZDZt0fRwezZmFOrX+4sIe4QQYlhRk=
X-Google-Smtp-Source: ABdhPJz0b1rm58oF7kongxTSvZRt8ZrYLaHAzgRbdRCQy37c2l7i5WKRWjRHbTMfqu1ncsYnvCJ87fY2AQc6h3CNx5o=
X-Received: by 2002:aa7:8f37:0:b029:2db:551f:ed8e with SMTP id
 y23-20020aa78f370000b02902db551fed8emr6184986pfr.43.1621543472617; Thu, 20
 May 2021 13:44:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210519204132.107247-1-xiyou.wangcong@gmail.com>
 <60a5896ca080d_2aaa720821@john-XPS-13-9370.notmuch> <CAM_iQpUC6ZOiH=ifUe1+cdXtTgiBMwPVLSsWB9zwBA7gWh8mgA@mail.gmail.com>
 <CAEf4Bzb7+XrSbYx6x4hqsdfieJu6C5Ub6m4ptCO5v27dwbx_dA@mail.gmail.com>
In-Reply-To: <CAEf4Bzb7+XrSbYx6x4hqsdfieJu6C5Ub6m4ptCO5v27dwbx_dA@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 20 May 2021 13:44:21 -0700
Message-ID: <CAM_iQpVAhOOP_PRsvL37J1WwOxHKmLEnRXVBYag1nNccHN7PYw@mail.gmail.com>
Subject: Re: [Patch bpf] selftests/bpf: Retry for EAGAIN in udp_redir_to_connected()
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
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

On Thu, May 20, 2021 at 1:14 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> Bugs do happen though, so if you can detect some error condition
> instead of having an infinite loop, then do it.

You both are underestimating the problem. There are two different things
to consider here:

1) Kernel bugs: This is known unknown, we certainly do not know
how many bugs we have, otherwise they would have been fixed
already. So we can not predict the consequence of the bug either,
assuming a bug could only cause packet drop is underestimated.

2) Configurations: For instance, firewall rules. If the selftests are run
in a weird firewall setup which drops all UDP packets, there is nothing
we can do in the test itself. If we have to detect this, then we would
have to detect netem cases too where packets can be held indefinitely
or reordered arbitrarily. The possibilities here are too many to detect,
hence I argue the selftests should setup its own non-hostile environment,
which has nothing to do with any specific program.

This is why I ask you to draw a boundary: what we can assume and
what we can't. My boundary is obviously clear: we just assume the
environment is non-hostile and we can't predict any kernel bugs,
nor their consequences.

Thanks.
