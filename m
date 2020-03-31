Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB332198963
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 03:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgCaBG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 21:06:27 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40645 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729129AbgCaBG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 21:06:27 -0400
Received: by mail-qk1-f196.google.com with SMTP id l25so21382812qki.7;
        Mon, 30 Mar 2020 18:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tVKVtW6MtTH0mX5V06UkVCiPRQRgx7w8m+rc4TistTI=;
        b=eaAUJVkj3w0MHX1Rin7M81B1S8HRhjAPtRolU420NkHU0mnPDye5oe9uAqftNCTkIn
         S3sY3g7Su98zvr3v3QuHiUtjimxKyRBML4S95qM+wvmaU3+0bg4q2P/YnPI9/cn/56oe
         mEi4v2eJ5/Sm9+7SxgduwQZbk01dLfuTpKhh0pklS5odDr22Zvo/CcXV/HA2F4Kv/WGe
         3o8O/Qu/N9vXGLx3TcZ8L55KnylUl6+15gp+W5c92qOOITSrpdA+JEC6VjdIUUmvvjPG
         X1ZK0CWWA026n2HnIJgD3DrKsgpoVhv02CEY6YoyWdXU5wxJEPVPx2Cdspzvk2AE5FgQ
         iJ1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tVKVtW6MtTH0mX5V06UkVCiPRQRgx7w8m+rc4TistTI=;
        b=X0mg98Zzd0pI39GKrlJAuzvds6Q2ryrBsOo+lVHPkhvAkLZpelOMHLFjiLU7o2ps+q
         IuTaKIQTzmnKJPINDtd3aFL5T1RwSNzOomdJEMqTkpXWsZ50M15yT3/9bnKSyU7Nzhe8
         PaMen6fyh455zYJVjp4Iz4MnuwLkFK2LbtkK7C4oyxWKaul7dBWiyOvE6LHsvHCs+4+J
         NdUCA0ddOXZ95ea43J8zUtzxEZhMD5IpX1J4O+fX2ghYP9qoll41xZQ30RxRjeMsDf88
         Cd3xu2t/Lj4iPD2mPpCh+xITmjo3R1NCCtCCRKeKEMMObIx94pyTq3eVnFmkJqteumms
         N3IQ==
X-Gm-Message-State: ANhLgQ1CVGYU0v/GeZV09HIMcC3zc6mRU3/BhZ0RG8etHmrSBLXRIjpy
        C1CVL5N24f2FLPR3FANB8cu0jddU+/fcrO3Yf7a1lOpc
X-Google-Smtp-Source: ADFU+vsx+Lo4aJZgnxs9hF+iWH25KIXT9sBLw1YJJR6HRbyliKqXh2CPRJT6lENyFfDiAPMbqH6DElqwxI0zhldcvKo=
X-Received: by 2002:a37:992:: with SMTP id 140mr2089291qkj.36.1585616785898;
 Mon, 30 Mar 2020 18:06:25 -0700 (PDT)
MIME-Version: 1.0
References: <20200330030001.2312810-1-andriin@fb.com> <20200330030001.2312810-2-andriin@fb.com>
 <20200331000513.GA54465@rdna-mbp.dhcp.thefacebook.com> <20200331003833.2cimhnn5scfroyv7@ast-mbp>
In-Reply-To: <20200331003833.2cimhnn5scfroyv7@ast-mbp>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 30 Mar 2020 18:06:14 -0700
Message-ID: <CAEf4BzZ2-a+m_wV2sffKMQ1Zi7wREvV=mkBmQC4ExQsi9zpbww@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/4] bpf: implement bpf_link-based cgroup BPF
 program attachment
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrey Ignatov <rdna@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 30, 2020 at 5:38 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Mar 30, 2020 at 05:05:13PM -0700, Andrey Ignatov wrote:
> > >
> > > +#define BPF_LINK_CREATE_LAST_FIELD link_create.flags
> > > +static int link_create(union bpf_attr *attr)
> > > +{
> >
> > From what I see this function does not check any capability whether the
> > existing bpf_prog_attach() checks for CAP_NET_ADMIN.
>
> Great catch! It's a bug.
> I fixed it up.

Thanks!

>
> > This is pretty importnant difference but I don't see it clarified in the
> > commit message or discussed (or I missed it?).

Yeah, not intentional, thanks for catching!

> >
> > Having a way to attach cgroup bpf prog by non-priv users is actually
> > helpful in some use-cases, e.g. systemd required patching in the past to
> > make it work with user (non-priv) sessions, see [0].
> >
> > But in other cases it's also useful to limit the ability to attach
> > programs to a cgroup while using bpf_link so that only the thing that
> > controls cgroup setup can attach but not any non-priv process running in
> > that cgroup. How is this use-case covered in BPF_LINK_CREATE?
> >
> >
> > [0] https://github.com/systemd/systemd/pull/12745
>
> yeah. we need to resurrect the discussion around CAP_BPF.
>
> PS
> pls trim your replies.
