Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A698399680
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 01:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhFBXw4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 19:52:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhFBXwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 19:52:55 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DAC7C06174A;
        Wed,  2 Jun 2021 16:51:04 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id s14so2601078pfd.9;
        Wed, 02 Jun 2021 16:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xJN4h0Af4vbWS+F0SPnPqFWxpb+PEYbshYpn2hAAdeQ=;
        b=ufUyI7WdxZ5iZJoDtwMffMqA3HWT7Oy9bJmRUsxKSI571a390l4dv+JYhZcHp9AhpV
         w3CcWYyOtNd9qZ/aYyrmRtPlf+jPmqjPAVQAzjd5n3GSOfpLEZJj0RqJ0Ydt8dwlUQil
         RPIcyN1xLKrzhipDGNnNHIdYA/g+sJqwQYIcUqHhfx2mq/Ea45QHjhdOphyafin5xtli
         zTGL1xwhcZAacw1yNsAjaX1t05WHrV0Y6Cf0iVLufZxphH2stRv1VibWFE75clCnWmGt
         QtFVdhqNrZwiqsJM9+8sLaXHJCpEsfHrXttCpYacZn3xZXRrCNHc6FnisUY/4QasWJvT
         DCZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xJN4h0Af4vbWS+F0SPnPqFWxpb+PEYbshYpn2hAAdeQ=;
        b=dTC68+A1+ZmIeWR/iZY0uDY3FlSfOY8gUwljltJMe23A+CXf777q4Xm/JBpJgaSWDF
         OCPXqLDMAL9JOydW07ihRkcsYvjhmk++rYouc0U6uM7aandXEQ3EucW34PQuHLNa/9GU
         COl5URuzIvQWmoyzKlLSLkBtxL/mQnrZ318ycFkGG71hXp9/ncjAJQ7hlm4P/qRHO+qH
         vLWhAnfGcjKCjQKmsv0B4fcLcri6I6ez1P6MjguFXw453o6+dsCFrjOf04l53QO5hwh/
         1kLjoU/L0rSwgeqtui+lDoqUM4iikTFVqpuqEC4mrmzxSsTj5cG6LIugkf+ceihTVkrW
         /Kqw==
X-Gm-Message-State: AOAM53270XIh90wDHG9c4E8c9Etvzgvdgz66aX0vxAUMj138XHmX4ycg
        au7W+UYXyiRboOo33Jvrcg8jCp8NMAg=
X-Google-Smtp-Source: ABdhPJzey9N1phCoubDBGdfDpkPEurxP3JlKDiG4fbN+SBwgKkTuuuPqgD7WzRwi55dG1iUAfhAYRQ==
X-Received: by 2002:a62:2c0e:0:b029:2e9:dcb9:4a09 with SMTP id s14-20020a622c0e0000b02902e9dcb94a09mr15954386pfs.75.1622677863620;
        Wed, 02 Jun 2021 16:51:03 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:27da])
        by smtp.gmail.com with ESMTPSA id j10sm419162pjb.36.2021.06.02.16.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 16:51:02 -0700 (PDT)
Date:   Wed, 2 Jun 2021 16:50:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
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
Message-ID: <20210602235058.njuz2gzsd5wqxwes@ast-mbp.dhcp.thefacebook.com>
References: <20210528195946.2375109-1-memxor@gmail.com>
 <CAEf4BzZt5nRsfCiqGkJxW2b-==AYEVCiz6jHC-FrXKkPF=Qj7w@mail.gmail.com>
 <20210602214513.eprgwxqgqruliqeu@apollo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210602214513.eprgwxqgqruliqeu@apollo>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 03:15:13AM +0530, Kumar Kartikeya Dwivedi wrote:
> 
> > The problem is that your patch set was marked as spam by Google, so I
> > suspect a bunch of folks haven't gotten it. I suggest re-sending it
> > again but trimming down the CC list, leaving only bpf@vger,
> > netdev@vger, and BPF maintainers CC'ed directly.
> >
> 
> Thanks for the heads up, I'll resend tomorrow.

fyi I see this thread in my inbox, but, sadly, not the patches.
So guessing based on cover letter and hoping that the following is true:
link_fd is returned by BPF_LINK_CREATE command.
If anything is missing in struct link_create the patches are adding it there.
target_ifindex, flags are reused. attach_type indicates ingress vs egress.
