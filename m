Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA192309364
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhA3J3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233620AbhA3Dru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 22:47:50 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB65C061797;
        Fri, 29 Jan 2021 19:15:11 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id y14so139588ljn.8;
        Fri, 29 Jan 2021 19:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=doa+5fNckm+U+JQAFdQrZFzGNQq/v41AFTpeJoWLi58=;
        b=l1B8afdMhvcQfT0XO12ZQnuIcRf/Ys56m0I3+UzFbuEZBdn+uH60ycI9X8eHmi0N8i
         g/DUg1mw9LCllSHkeio8L1rkBdkefkP90RlZN+Rlh214a2hs7QY4ii8x3pxwikAygKtD
         DivEXWu0Bx3KZWnbc2QD/HemWCv5RRzB2fibsXUNxZc8eNFPdGdwsTpdw22e6T/HJHt3
         92uh/2P5ZRKiXqGC2Iq7b4oy3g0L7Wus3fufDo2srA1v6EpJWw4Q0p17OmGjwjqJYC++
         qV+Z3AFGhnrT/Klgjjk88OpzkDC1yW1pvbW34FGhi5iUQ2KIZfQ+DGB2ehLa6zxdUcrS
         +b/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=doa+5fNckm+U+JQAFdQrZFzGNQq/v41AFTpeJoWLi58=;
        b=VP6HFigOooTwM+AKP/qPfxgWI/ebQq3ymkEl6WfFSsTS7k5bNiZnlc6IdfZhIpTsUL
         /Y5BdfZYbOD2V2824MxibLOu0nyqDwTQFvKuPZWTt9HnK0+yOUFurXzIODlW/4pDcRLa
         U1RlgoRioT+ya3csdNlE46o5dGy0ceLTfCmjU+a2TBvRVc9koVEOMK0O0wAH22Bz/nxe
         YY1FmoUxQJJDQZbc1Pj3OderPT79HwdQj3eh5nYb47IIJSnIpuCU5sfnvIlvROp7cYpd
         i+lONTuK9dsnhNLxr7xU//adww3Oq4EeS7llypS/jj3XH/UwGH0wfZ83VzND5RB5EuQ/
         UxtA==
X-Gm-Message-State: AOAM532Bpq536z+EOyV6REg6oKBR7slVQCMrJAAKNLT5UHERcE7bAgUC
        r9rS8oqhMxIVtPJehFVgiqhaZQdPhs57D5avicc=
X-Google-Smtp-Source: ABdhPJzbxQ5cN++AtpzAqmD2OePxAlYunYl08IQrwOnRAjlBnqDHd6JRv1cfB7SuatsZUJdpy7K3RVuivCO29rFBzyU=
X-Received: by 2002:a2e:54d:: with SMTP id 74mr3833166ljf.44.1611976510480;
 Fri, 29 Jan 2021 19:15:10 -0800 (PST)
MIME-Version: 1.0
References: <20210122205415.113822-1-xiyou.wangcong@gmail.com>
 <20210122205415.113822-2-xiyou.wangcong@gmail.com> <d69d44ca-206c-d818-1177-c8f14d8be8d1@iogearbox.net>
 <CAM_iQpW8aeh190G=KVA9UEZ_6+UfenQxgPXuw784oxCaMfXjng@mail.gmail.com>
 <CAADnVQKmNiHj8qy1yqbOrf-OMyhnn8fKm87w6YMfkiDHkBpJVg@mail.gmail.com>
 <CAM_iQpXAQ7AMz34=o5E=81RFGFsQB5jCDTCCaVdHokU6kaJQsQ@mail.gmail.com>
 <20210129025435.a34ydsgmwzrnwjlg@ast-mbp.dhcp.thefacebook.com>
 <f7bc5873-7722-e359-b450-4db7dc3656d6@mojatatu.com> <dc5ddf32-2d65-15a9-9448-5f2d3a10d227@mojatatu.com>
In-Reply-To: <dc5ddf32-2d65-15a9-9448-5f2d3a10d227@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 29 Jan 2021 19:14:59 -0800
Message-ID: <CAADnVQJafr__W+oPvBjqisvh2vCRye8QkT9TQTFXH=wsDGtKqA@mail.gmail.com>
Subject: Re: [Patch bpf-next v5 1/3] bpf: introduce timeout hash map
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 29, 2021 at 6:14 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-01-29 9:06 a.m., Jamal Hadi Salim wrote:
>
> > Which leads to:
> > Why not extend the general feature so one can register for optional
> > callbacks not just for expire but also add/del/update on specific
> > entries or table?
> > add/del/update could be sourced from other kernel programs or user space
> > and the callback would be invoked before an entry is added/deleted etc.
> > (just like it is here for expiry).
>
> Sorry - shouldve read the rest of the thread:
> Agree with Cong that you want per-map but there are use cases where you
> want it per entry (eg the add/del/update case).

That was my point as well.
bpf_timer api should be generic, so that users can do both.
The program could use bpf_timer one for each flow and bpf_timer for each map.
And timers without maps.
