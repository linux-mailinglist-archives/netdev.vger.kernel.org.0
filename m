Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB52E478663
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 09:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbhLQIkJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Dec 2021 03:40:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbhLQIkH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Dec 2021 03:40:07 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5482CC061747;
        Fri, 17 Dec 2021 00:40:07 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id v16so1637293pjn.1;
        Fri, 17 Dec 2021 00:40:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jAkmu0uJQg/B9pO7n5QymGcyVXcAft2zKtbo4iiM1U0=;
        b=Gh/6WuWm9i8f2qct8kBrqxif8u7YCkAlX6mzWOTbFF8U2Zv68NgG6W+5Is5tbSI963
         VzdCJ7o7ph6hXLM0jn4b6bzuCCk7++IHiI48vjZ/kKJ/mtRz+8/dxDY3d+LMwYJer/Kb
         Zh+NONlkAcS5xADFW75arBsBCywwvXc1RIV3jTlRHmWbOBQoTNjxS2GakWe2h/SrHxn0
         XOm0HlvfQql7VPASG0QLjVFo2dZdeQwoB8Ptnn2g2ScTj60ag4IUQyoYTxUV3GhCd+5t
         /TJgEu8K3xF4/e5Bp5hGUwOvhCW+KcWlmgL9qlO96vsNMqcE276WSPR2GvXXV5BAGUEq
         b5Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jAkmu0uJQg/B9pO7n5QymGcyVXcAft2zKtbo4iiM1U0=;
        b=Joi/kBNRIC9oUMAEqvoVhTJcLmdHNmbKl7O8WkbWs9uO6oFkXBiBZe2kBI55rucnmn
         fVqurxYrQKyxL0GQDA2mmORKH8PxV4wrzrhlrbR8l4O3bIk56xevrkY1ekJh/C7yalOu
         /nxvWxtsvzpymMer3Nj9WyR3CKyS/qbqPZjig7VDLmGw9Di/GSRqt0QRAhC5TiTzgt18
         OmqNu0U4/JZJKrnWyk4cdPu5yyHjtRZI617HEjJJ0jk13boq8Lll8LazGBE23NGYqtKs
         D08v/DMPozqYCpYEkqqpKejl+cPlsvqim+hL2HaRbob1AIRzY+iBLrLTVN7vdynJewqZ
         55ig==
X-Gm-Message-State: AOAM532yrMcfK/S6nELWS3dqShSaeqBlNXGJ+trA+l3nE/BMefdXd1py
        f0nkl0jpPvZjJEDNjoDdrDA=
X-Google-Smtp-Source: ABdhPJxuNuwX+LGwDgRD1tZJkgWulxgcZb2riEcvuuNzL2IVRHfP13vo9Copqms9BgJrRzovwFRMQg==
X-Received: by 2002:a17:902:8c94:b0:148:a2e8:2c39 with SMTP id t20-20020a1709028c9400b00148a2e82c39mr2098279plo.136.1639730406752;
        Fri, 17 Dec 2021 00:40:06 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id p20sm8622146pfw.96.2021.12.17.00.40.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 00:40:06 -0800 (PST)
Date:   Fri, 17 Dec 2021 14:10:03 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v4 07/10] net/netfilter: Add unstable CT lookup
 helpers for XDP and TC-BPF
Message-ID: <20211217084003.dr2gv6hismpyib3y@apollo.legion>
References: <20211217015031.1278167-1-memxor@gmail.com>
 <20211217015031.1278167-8-memxor@gmail.com>
 <YbxHy7yLwMQ7L0mN@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbxHy7yLwMQ7L0mN@salvia>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 17, 2021 at 01:48:19PM IST, Pablo Neira Ayuso wrote:
> On Fri, Dec 17, 2021 at 07:20:28AM +0530, Kumar Kartikeya Dwivedi wrote:
> > This change adds conntrack lookup helpers using the unstable kfunc call
> > interface for the XDP and TC-BPF hooks. The primary usecase is
> > implementing a synproxy in XDP, see Maxim's patchset at [0].
> >
> > Export get_net_ns_by_id as nf_conntrack needs to call it.
> >
> > Note that we search for acquire, release, and null returning kfuncs in
> > the intersection of those sets and main set.
> >
> > This implies that the kfunc_btf_id_list acq_set, rel_set, null_set may
> > contain BTF ID not in main set, this is explicitly allowed and
> > recommended (to save on definining more and more sets), since
> > check_kfunc_call verifier operation would filter out the invalid BTF ID
> > fairly early, so later checks for acquire, release, and ret_type_null
> > kfunc will only consider allowed BTF IDs for that program that are
> > allowed in main set. This is why the nf_conntrack_acq_ids set has BTF
> > IDs for both xdp and tc hook kfuncs.
> >
> >   [0]: https://lore.kernel.org/bpf/20211019144655.3483197-1-maximmi@nvidia.com
> >
> > Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
> > ---
> >  include/linux/btf.h               |   2 +
> >  kernel/bpf/btf.c                  |   1 +
> >  net/core/filter.c                 |  24 +++
> >  net/core/net_namespace.c          |   1 +
> >  net/netfilter/nf_conntrack_core.c | 278 ++++++++++++++++++++++++++++++
>
> Toke proposed to move it to net/netfilter/nf_conntrack_bpf.c

Ugh, sorry. I think I completely missed that mail, but I see it now.

I'll wait for this review cycle to conclude, and then put the code in its own
file in the next version.

Thanks.

--
Kartikeya
