Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 214183A397D
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 04:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231243AbhFKCDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 22:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbhFKCDL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Jun 2021 22:03:11 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9DFBC061574;
        Thu, 10 Jun 2021 19:01:01 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id ei4so4784561pjb.3;
        Thu, 10 Jun 2021 19:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zmBr2+tx5LxvDo66vLoZA8O8Gldo6LQgWs3Y7QEUUso=;
        b=KtD/RY/IZ3trP847UBvvuwUnjxG45qim66JouocjFLZTLKq5YCMNdn2Yoc3MM5d9/u
         PpTCRmNZld1Ew69QqdXNGhLkEq8CTFijEJaLZ0x3zTJoxqG1IZC9Nt2yb4vH8jTyrSj9
         E2hk1fXATRlEW3D067vrP2SN3z9MPt1jo1kZcgPIg0dosI2iKXk4HDs7ecorbnkJBmWs
         /25OinKCbvFsu7RGCEhq76/Cq1PYBugg58KBbRZGmVfTUMCVzzp+nveFq6axHKYqHJMa
         CZiXjEmWXOxfQ5Wxs8Y6DEnaoVYoLSJK/dwtvdKczWnOLcw8o83iCV5EJDPxtx4/r+J9
         E4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zmBr2+tx5LxvDo66vLoZA8O8Gldo6LQgWs3Y7QEUUso=;
        b=tsFKcL8zFeCDmWQdFzqkbgCl+z3hJJdHw0oSl74FYA+OJCsVMCxmLKWkuJVWnFzYt7
         yzU/LrQi+4oaaOlzB3AZlqjH2P6uxQuZtE/jZkWZw89Yqr5mi/QsADmPM14eOlxbJtre
         WKDa7ukdjRgtxdeajLXExW08TD7Ycz5izsmnjwEFWyibJU5I59iTfRlK4ukS75cV6NLD
         j06li8E3iLg4bL59UevkVseauBmBkXgmOVvo5KxCCN76Cakiws5MLoLGL0xpHra13FEx
         XUOXSLQrYC7hgFNgluRGScWqQNdJLhWqut5f1EZDrUFE0y83zX75pT9oH0YRv/8nYpt0
         ApFA==
X-Gm-Message-State: AOAM533XFZ2OtNt7LUjby0SZbHJ077O8wCh+0sjY4PM180UtsSElNlw+
        biQRyvfxsyR+sKgsioz7zXpksmpb5PXO0jnH+UE=
X-Google-Smtp-Source: ABdhPJxahos3XQuNRTTjm3cMimGSmSzF1ErwwQLQKvA8a2rYrBsXu4M7JyPES9rQvhKZVgV0I0QNFGbxaEyExlq7MNA=
X-Received: by 2002:a17:90a:1141:: with SMTP id d1mr1902258pje.56.1623376861252;
 Thu, 10 Jun 2021 19:01:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210528195946.2375109-1-memxor@gmail.com> <CAM_iQpVqVKhK+09Sj_At226mdWpVXfVbhy89As2dai7ip8Nmtw@mail.gmail.com>
 <20210607033724.wn6qn4v42dlm4j4o@apollo> <CAM_iQpVCnG8pSci2sMbJ1B5YE-y=reAUp82itgrguecyNBCUVQ@mail.gmail.com>
 <20210607060724.4nidap5eywb23l3d@apollo> <CAM_iQpWA=SXNR3Ya8_L2aoVJGP_uaRP8EYCpDrnq3y8Uf6qu=g@mail.gmail.com>
 <20210608071908.sos275adj3gunewo@apollo>
In-Reply-To: <20210608071908.sos275adj3gunewo@apollo>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 10 Jun 2021 19:00:49 -0700
Message-ID: <CAM_iQpXFmsWhMA-RO2j5Ph5Ak8yJgUVBppGj2_5NS3BuyjkvzQ@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
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

On Tue, Jun 8, 2021 at 12:20 AM Kumar Kartikeya Dwivedi
<memxor@gmail.com> wrote:
>
> So we're not really creating a qdisc here, we're just tying the filter (which in
> the current semantics exists only while attached) to the bpf_link. The filter is
> the attachment, so tying its lifetime to bpf_link makes sense. When you destroy
> the bpf_link, the filter goes away too, which means classification at that
> hook (parent/class) in the qdisc stops working. This is why creating the filter
> from the bpf_link made sense to me.

I see why you are creating TC filters now, because you are trying to
force the lifetime of a bpf target to align with the bpf program itself.
The deeper reason seems to be that a cls_bpf filter looks so small
that it appears to you that it has nothing but a bpf_prog, right?

I offer two different views here:

1. If you view a TC filter as an instance as a netdev/qdisc/action, they
are no different from this perspective. Maybe the fact that a TC filter
resides in a qdisc makes a slight difference here, but like I mentioned, it
actually makes sense to let TC filters be standalone, qdisc's just have to
bind with them, like how we bind TC filters with standalone TC actions.
These are all updated independently, despite some of them residing in
another. There should not be an exceptional TC filter which can not
be updated via `tc filter` command.

2. For cls_bpf specifically, it is also an instance, like all other TC filters.
You can update it in the same way: tc filter change [...] The only difference
is a bpf program can attach to such an instance. So you can view the bpf
program attached to cls_bpf as a property of it. From this point of view,
there is no difference with XDP to netdev, where an XDP program
attached to a netdev is also a property of netdev. A netdev can still
function without XDP. Same for cls_bpf, it can be just a nop returns
TC_ACT_SHOT (or whatever) if no ppf program is attached. Thus,
the lifetime of a bpf program can be separated from the target it
attaches too, like all other bpf_link targets. bpf_link is just a
supplement to `tc filter change cls_bpf`, not to replace it.

This is actually simpler, you do not need to worry about whether
netdev is destroyed when you detach the XDP bpf_link anyway,
same for cls_bpf filters. Likewise, TC filters don't need to worry
about bpf_links associated.

Thanks.
