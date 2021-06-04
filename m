Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3E539B2CC
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 08:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbhFDGqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 02:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230092AbhFDGqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 02:46:11 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5F8C061760;
        Thu,  3 Jun 2021 23:44:09 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id o17-20020a17090a9f91b029015cef5b3c50so6880222pjp.4;
        Thu, 03 Jun 2021 23:44:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3lY7p/u7GioL1Vux+6QXVoEdXdtGYLzRSaAk61G4V5c=;
        b=GVR481rCMQMyr5bI0UEuhgjcXsuiBRScn1t8jpe5n4y37B8mUFmLeAr41O29osxJfu
         Le+xTXVDOM8GLp9qZD36Euhhqaf5jkk6o9NSXGdOtaEz/hBgdLwUyE4gXLiSsXnnujEu
         1Vz78YrV5QD7RrMA6T2eCur9FqQJqC52kY8gj9A9mlqc11B1DPXJiwNmho2WwrNlOyEn
         20GDuMTy23KcJdSNY+Z6J542YBJivUbhkarzFGkj5xaD/oQs2BJP6WLbwF9eN9oAqLET
         gZMwkG24jS6Se9ooFkm8txhBPcrvBOFmyRigwGKWQ7naOC+yNQ82N9HLOnXyA0MNbNHb
         +YTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3lY7p/u7GioL1Vux+6QXVoEdXdtGYLzRSaAk61G4V5c=;
        b=g3aWEJ+hHTG9l+2Xkndu+7YvUAG0vF+Lt+FQZ4ULq6Pcw0fSfewSxAcKm66xOgXEmy
         HI/uVnuvxPZTIvLLqC+AdTv0fSBQ0RPPRwxH0qqghFW6hnh/LwmQ6vKxLe8EZA0Gdpk9
         Co3333H4zoGiMCO9/gi4JArl130/ExEvg0QKmexUCj324mU68qqADekZb7aMEIw3RRsd
         dCvgtPEP+T2Gd+YlMDjWO3jwPUu46dy9vRCACUEj8cNmltCKyZkzCoW3nsMtPGTgr1Y7
         KOX8gDfTga1WlzHqnmWeeoGZblEVQ9r2TVpEQrEgYb84PTnt19gvcG5+nsvVQmPSkiLX
         yxIQ==
X-Gm-Message-State: AOAM530rsSe0tWpZD8+xWr2/pORQZ/21ieSZ7VT+LBlEVXWVKWIoGgsT
        Nl+EOIuFzr3vQv+5W2qeoJk=
X-Google-Smtp-Source: ABdhPJyUu+3m01oYdHZruJCA+TOkEcavRSZi/MPypBU6Qm7Q2/MzPrA7rvvO6c79G1pe69KNX8NQDw==
X-Received: by 2002:a17:902:db06:b029:102:6e01:cecb with SMTP id m6-20020a170902db06b02901026e01cecbmr2935902plx.9.1622789048826;
        Thu, 03 Jun 2021 23:44:08 -0700 (PDT)
Received: from localhost ([2402:3a80:11cb:b599:c759:2079:3ef5:1764])
        by smtp.gmail.com with ESMTPSA id s6sm3785564pjr.29.2021.06.03.23.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 23:44:08 -0700 (PDT)
Date:   Fri, 4 Jun 2021 12:13:03 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Vlad Buslov <vladbu@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Joe Stringer <joe@cilium.io>,
        Quentin Monnet <quentin@isovalent.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC bpf-next 0/7] Add bpf_link based TC-BPF API
Message-ID: <20210604064303.bfso3oml2ouazwia@apollo>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAEf4BzZt5nRsfCiqGkJxW2b-==AYEVCiz6jHC-FrXKkPF=Qj7w@mail.gmail.com>
 <20210602214513.eprgwxqgqruliqeu@apollo>
 <20210602235058.njuz2gzsd5wqxwes@ast-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602235058.njuz2gzsd5wqxwes@ast-mbp.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 05:20:58AM IST, Alexei Starovoitov wrote:
> On Thu, Jun 03, 2021 at 03:15:13AM +0530, Kumar Kartikeya Dwivedi wrote:
> >
> > > The problem is that your patch set was marked as spam by Google, so I
> > > suspect a bunch of folks haven't gotten it. I suggest re-sending it
> > > again but trimming down the CC list, leaving only bpf@vger,
> > > netdev@vger, and BPF maintainers CC'ed directly.
> > >
> >
> > Thanks for the heads up, I'll resend tomorrow.
>
> fyi I see this thread in my inbox, but, sadly, not the patches.
> So guessing based on cover letter and hoping that the following is true:
> link_fd is returned by BPF_LINK_CREATE command.
> If anything is missing in struct link_create the patches are adding it there.
> target_ifindex, flags are reused. attach_type indicates ingress vs egress.

Everything is true except the attach_type part. I don't hook directly into
sch_handle_{ingress,egress}. It's a normal TC filter, and if one wants to hook
into ingress, egress, they attach it to clsact qdisc. The lifetime however is
decided by the link fd.

The new version is here:
https://lore.kernel.org/bpf/20210604063116.234316-1-memxor@gmail.com

--
Kartikeya
