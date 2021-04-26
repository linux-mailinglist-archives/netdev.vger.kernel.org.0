Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D941236BBE2
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 01:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234579AbhDZXBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 19:01:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhDZXBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 19:01:03 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5195EC061574;
        Mon, 26 Apr 2021 16:00:21 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id md17so2446464pjb.0;
        Mon, 26 Apr 2021 16:00:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yKvzyDW0Nkcjpnv1ah1fbMoG9X95Ly3D/EEtVrjYm5o=;
        b=TQE7sGayf/oQJxC8ce7cTYS3FJuWEt7+aatNEMosDUX5LBWIKuLcFAk6KJ/QK88nsW
         O2eX/meZoweJGzZ9lGnlWrmtCIfqVE2rNbkZ8nWY6Xi1GdYk5dSaf5KZXapBrNjKioHU
         JUnj3829hMRnWvdfhA6vxzRx1Sc9a4ZQDN826SeYwvqhBT2aEXEDF/JU/8EtAi+vcrKx
         E2xVgiMyBDlkyLRPqPCdeDXY0r0zNUo//0ahdRaS7Fe6z/4tC7SGqI2ZA7bphJC9pHq8
         xdOTRhgTjFi2DdBruqPktLv0y4tZ4xRfr387nSy9RTKoJrATVVxGvZq2gP1Gbw5Cnh+i
         iNXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yKvzyDW0Nkcjpnv1ah1fbMoG9X95Ly3D/EEtVrjYm5o=;
        b=LLXTjXhfzVyKIdnN2EAsGf0s0T8FEhj0xp2hVQT6A64wmVxS5lqoQ/hY5isYuOnF1C
         hOSwxb2C83w/RD9OQu1jqfYDpi9drekFeGI/RJ9qkiNzNpbGaumvusbpp6pATGikEUfr
         GDAzB/xzxJouWgXFsQrc3QSBhM80m1qj9OCOfE9u4/O2S5NWfdpXk2YVs2aXgY4bCCko
         X820YCbb944KNgoMGKyEkIyFEjYrFhzPX7A1aXTHGoJfBIEBotpH0BIvG9l5pgTHtAEt
         RK9pso4OQYADnPz0cpfusj10KxAX2alSXzt7z+2uyC4+xBgiQnB4Zo8F+ba+PH2HC9GC
         Feug==
X-Gm-Message-State: AOAM532uyCSvCiyalJThs9d61BAS+cw6yxKWIGIgRXFJaUzT6TFOufB6
        YRLFv7QcmvqgyOB3onUoyzqJmbIU9T+kTzB9MiE=
X-Google-Smtp-Source: ABdhPJzkSvMa/ef38Sy95A2rQ2GuYiCnKB7EYz2kpshOUNnHfMu5YeLi9EzgCr1Zw5Bq6a2j4fE1FsdpHmXjCwJECsk=
X-Received: by 2002:a17:902:10b:b029:ed:2b3e:beb4 with SMTP id
 11-20020a170902010bb02900ed2b3ebeb4mr8488415plb.64.1619478020853; Mon, 26 Apr
 2021 16:00:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210401042635.19768-1-xiyou.wangcong@gmail.com>
 <20210402192823.bqwgipmky3xsucs5@ast-mbp> <CAM_iQpUfv7c19zFN1Y5-cSUiVwpk0bmtBMSxZoELgDOFCQ=qAw@mail.gmail.com>
 <20210402234500.by3wigegeluy5w7j@ast-mbp> <CAM_iQpWf2aYbY=tKejb=nx7LWBLo1woTp-n4wOLhkUuDCz8u-Q@mail.gmail.com>
 <20210412230151.763nqvaadrrg77kd@ast-mbp.dhcp.thefacebook.com>
 <CAM_iQpWePmmpr0RKqCrQ=NPiGrq2Tx9OU9y3e4CTzFjvh5t47w@mail.gmail.com> <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
In-Reply-To: <CAADnVQLsmULxJYq9rHS4xyg=VAUeexJTh35vTWTVgjeqwX4D6g@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 26 Apr 2021 16:00:09 -0700
Message-ID: <CAM_iQpVtxgZNeqh4_Pqftc3D163JnRvP3AZRuFrYNeyWLgVBVA@mail.gmail.com>
Subject: Re: [RFC Patch bpf-next] bpf: introduce bpf timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        Xiongchun Duan <duanxiongchun@bytedance.com>,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Muchun Song <songmuchun@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Pedro Tammela <pctammela@mojatatu.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Alexei

On Wed, Apr 14, 2021 at 9:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Wed, Apr 14, 2021 at 9:02 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
> >
> > Then how do you prevent prog being unloaded when the timer callback
> > is still active?
>
> As I said earlier:
> "
> If prog refers such hmap as above during prog free the kernel does
> for_each_map_elem {if (elem->opaque) del_timer().}
> "

I have discussed this with my colleagues, sharing timers among different
eBPF programs is a must-have feature for conntrack.

For conntrack, we need to attach two eBPF programs, one on egress and
one on ingress. They share a conntrack table (an eBPF map), and no matter
we use a per-map or per-entry timer, updating the timer(s) could happen
on both sides, hence timers must be shared for both.

So, your proposal we discussed does not work well for this scenario. The
proposal in my RFC should still work. Please let me know if you have any
better ideas.

Thanks!
