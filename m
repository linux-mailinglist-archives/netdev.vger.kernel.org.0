Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 280543A398E
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:12:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231150AbhFKCOS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:14:18 -0400
Received: from mail-pj1-f48.google.com ([209.85.216.48]:45902 "EHLO
        mail-pj1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230168AbhFKCOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:14:17 -0400
Received: by mail-pj1-f48.google.com with SMTP id z3-20020a17090a3983b029016bc232e40bso5056118pjb.4;
        Thu, 10 Jun 2021 19:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m1nvfkedOhC2O/Z+HXKqfInqZLv5+44mNv+t9W0XDcU=;
        b=FYQJZt9x7DDitcHxk0wAE0nKmhjgrSe6CN3w/YhNedKFLVgN49HxVqMpaQWpJJpFde
         RJnc5VLAaTeC+PEdHx8BwOUVHxR2vuPv8ADctPpwytXrHNLRUxDZv6VJp6pnsjF++LBg
         G9JUaIZgOecP2zZ23P31+XnvQiK05bKOHjKP507+uKYSNvFJhFdGHvCU7s/bJB47mNXN
         Ax5TGB3qOmeDS80LfYdoUh2AxlsH10/e7214pl6hHjmkYBvXkX2Rq2d3rm7X8HKZGxE3
         VT2+pz4DTjGVoKlhVfmkcCgz40/EPM9sQDHZ8cPPLR/vL6uz9snZ1unEkXciNbqMKfpF
         KZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m1nvfkedOhC2O/Z+HXKqfInqZLv5+44mNv+t9W0XDcU=;
        b=ub7Tu+07AL3WvRYuXb5dPz45RwZHifUl1i/yEEOUa6bRDmEw5PwjxHzt/D3TyYE8eR
         S64nmH5/2v08OFZoHAzx5ZpO5Wg4gVd8HGMCo2zUs2mfSScv0JcA6/YYCNIQz7BBGkb4
         VFxZqoNh5nd4I9ZOOQ4g0SAl/6gEPoyj4RXHR4sBIzfrOoizlIQJ8b0vDDL93NnfEnQD
         YzSBgWb4M+tMJbki3ac1j5HAvmy9fng4BFkWMaXfnZIHbbw7qW8QaYJ2eWPdT4dqsdWz
         TmV16YSVCy8EpHzE2JwIGctbz05LuRIE/AnY6TUeozCe3Yayj31sUj2liqfPt0Bso+TV
         OJWg==
X-Gm-Message-State: AOAM532JjmL3t58jxHSveWE8rxZNDwDwVFgcoPHRkzHy5SBs3FqPfKGu
        NbJqoFJUgb7cRxXamNGp8cqL/NED+7aamQeBlZ1AlypQrDaFKQ==
X-Google-Smtp-Source: ABdhPJyjUfN9ndUVuBE7eld55wahdYSdMDQhYFCWq+qhpWeAGsrEX35EPSgZI++lz1sK4jevcCvnnu1P3JlljdcgKxo=
X-Received: by 2002:a17:90b:190a:: with SMTP id mp10mr6610963pjb.145.1623377467527;
 Thu, 10 Jun 2021 19:11:07 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo> <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo> <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo> <CAADnVQLRVikjNe-FqYxcSYLSCXGF_bV1UWERWuW8NvL8+4rJ6A@mail.gmail.com>
In-Reply-To: <CAADnVQLRVikjNe-FqYxcSYLSCXGF_bV1UWERWuW8NvL8+4rJ6A@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Jun 2021 19:10:56 -0700
Message-ID: <CAM_iQpWtBFr+KA=nHT1h1cLspeJ6vDQT6as9Vpd2Vtm98CnxBA@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>, Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 8, 2021 at 8:39 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
> I think it makes sense to create these objects as part of establishing bpf_link.
> ingress qdisc is a fake qdisc anyway.
> If we could go back in time I would argue that its existence doesn't
> need to be shown in iproute2. It's an object that serves no purpose
> other than attaching filters to it. It doesn't do any queuing unlike
> real qdiscs.
> It's an artifact of old choices. Old doesn't mean good.
> The kernel is full of such quirks and oddities. New api-s shouldn't
> blindly follow them.
> tc qdisc add dev eth0 clsact
> is a useless command with nop effect.

Sounds like you just need a new bpf attach point outside of TC,
probably inside __dev_queue_xmit(). You don't need to create
any object, probably just need to attach it to a netdev.

Thanks.
