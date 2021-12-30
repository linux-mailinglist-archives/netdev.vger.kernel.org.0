Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D6684818D1
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 04:04:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235070AbhL3DEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 22:04:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbhL3DEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 22:04:15 -0500
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52B04C061574;
        Wed, 29 Dec 2021 19:04:15 -0800 (PST)
Received: by mail-pg1-x541.google.com with SMTP id f8so10223185pgf.8;
        Wed, 29 Dec 2021 19:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Yo6JeoWvRH+ovlwbmL1s9hAJypLA4AJYicdWPLb+vPE=;
        b=T/tLz7PtVOVFIrJ6+YvW7x1K6h14PPQYVKswJ66LR4V3xQq8T/Bnnvz/AVj6V2SJrk
         TbtswT6JwBNSSPXILP7EhYtoiX7/WA5sPcBkvBJmejMISDYtoYXDN/lWFeIWgEIJotHb
         iZaOBgrPVKztJYOpL66x4PIV4e0EL+bI4pGd2o159SjFSab8qIDtXUbDkbZtag5poQvY
         M6wtci84nLFPAiDiFXNumT1Q5+gzSAF+vO3Rq65nFGyAAcjuOKCIVZoopZsuc2PFqMgJ
         RzwkODMUoAKFp+dY5wpeIWEmtQ+bK2UymcbdyBcTggABHsGQ4p2xcXLqpb/KAGOuQ+uj
         zLeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Yo6JeoWvRH+ovlwbmL1s9hAJypLA4AJYicdWPLb+vPE=;
        b=6c2XXUp/XRTNJ5q6Z3bJ5RFUdR6tR6Wrio+Z3p/G96Wz9co2IKf5aCKnc2ujDGIX+f
         q1FhyqTcXJ29zhDb2jYYkQLaoMVrjfwamuz1lgjFia4Xg8wDjdCzqCxiQIoh7SFdmwZ+
         XyNZBBZOp94TOZxBEtmyL+jMNCKOjn4nZqw3pAcrJFuFbnNBCuuRdQ+JtQDA6Z2bEff/
         ZVrnU8fOwcnPG3RnagmoGs85uoWuu3iw6Mb25XfqLd3PJnpxbGDJSRBGq/FzyogxnFE/
         gn0K/hKLHUMJnFJ3TkToJSAjjpbZw+GOMkeT4YZofFw66VYy6kbaH7bcjvXUNmPQpsez
         +GNQ==
X-Gm-Message-State: AOAM5307Z3Lgmkan2ghlxyIXsrlNwlOHJFui4O8bvy2MyYIh3KNRXOiR
        8Gd3qw7ADivp8kSAqaOUzuOKaaNh0kk=
X-Google-Smtp-Source: ABdhPJwlbiweowUhWcevZtX3JRqqCasGsiuBrLwlt9+2QKTuF8j4FLssG78S535qv70jFLIeC45s1A==
X-Received: by 2002:a62:6043:0:b0:4bb:d8d9:e9ec with SMTP id u64-20020a626043000000b004bbd8d9e9ecmr19199067pfb.7.1640833454679;
        Wed, 29 Dec 2021 19:04:14 -0800 (PST)
Received: from localhost ([2405:201:6014:d064:3d4e:6265:800c:dc84])
        by smtp.gmail.com with ESMTPSA id y126sm24387823pfy.40.2021.12.29.19.04.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 19:04:14 -0800 (PST)
Date:   Thu, 30 Dec 2021 08:34:11 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: Re: [PATCH bpf-next v5 0/9] Introduce unstable CT lookup helpers
Message-ID: <20211230030411.7areovj3pz7pmmz2@apollo.legion>
References: <20211230023705.3860970-1-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211230023705.3860970-1-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 08:06:56AM IST, Kumar Kartikeya Dwivedi wrote:
> This series adds unstable conntrack lookup helpers using BPF kfunc support.  The
> patch adding the lookup helper is based off of Maxim's recent patch to aid in
> rebasing their series on top of this, all adjusted to work with module kfuncs [0].
>
>   [0]: https://lore.kernel.org/bpf/20211019144655.3483197-8-maximmi@nvidia.com
>
> To enable returning a reference to struct nf_conn, the verifier is extended to
> support reference tracking for PTR_TO_BTF_ID, and kfunc is extended with support
> for working as acquire/release functions, similar to existing BPF helpers. kfunc
> returning pointer (limited to PTR_TO_BTF_ID in the kernel) can also return a
> PTR_TO_BTF_ID_OR_NULL now, typically needed when acquiring a resource can fail.
> kfunc can also receive PTR_TO_CTX and PTR_TO_MEM (with some limitations) as
> arguments now. There is also support for passing a mem, len pair as argument
> to kfunc now. In such cases, passing pointer to unsized type (void) is also
> permitted.
>
> Please see individual commits for details.
>
> Changelog:
> ----------

PR [0] and [1] are needed to make BPF CI green for this set.

[0]: https://github.com/kernel-patches/vmtest/pull/53
[1]: https://github.com/libbpf/libbpf/pull/429

> [...]

--
Kartikeya
