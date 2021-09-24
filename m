Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C51417E75
	for <lists+netdev@lfdr.de>; Sat, 25 Sep 2021 01:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344740AbhIXXzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 19:55:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344372AbhIXXzy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 19:55:54 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 359E2C061571;
        Fri, 24 Sep 2021 16:54:21 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id j14so7612491plx.4;
        Fri, 24 Sep 2021 16:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=enDOBx8AhFUUk23pyqhCJpowg8QgfNEpn0KLYrav1xI=;
        b=HFQTtlpPW8gmZzId6Tvhe0EQiOBIubLiVwBXHvScTO0SorPq7n0lR98XmdcU4iUizz
         vCcUXj146JkQYSXo4zI2T6djcpIEk6S9SENbMxRavxHFORIyAXNE4/UWAybt23tOqIF0
         Lth1y/z/uZko8JqGv44/buarVhuxevaNQ/NTrhgTfOmHgq9mjWiDoQuB/ZGU/kuUT8Hp
         AM0fxgpv7uFe8eC/VA+AmTixUCLCQX9xhBoRYM83EQ/wfH09fgAZXGMx3gisI3GCo1ed
         HTkf06Ux/TMicj1jsb+Ro//1sMLDzdajuopkDE3wnADTjHWpw5oFG1H6+mUpgaj8CrUB
         CSKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=enDOBx8AhFUUk23pyqhCJpowg8QgfNEpn0KLYrav1xI=;
        b=IVBnaaAG1DwHHpHH6Af3lQL2F/PkfOBcY8YFtEl19f3siUDje31hOy618dA7ymJ3F2
         WSYtWgBH9ItBsIDxMEed9p1pkG3QXaQxhXI+U3uYDu7sckPrXQWVCdHJw6KFp1DCT7u7
         b05o23GvghFkN8a0FWuROE7NNYz1g/y/QeDsCUSGlbzNcabZW/9tRRz/fbzCAihoKhte
         SsyDxI7VhkwoB9mogJfxtgGv2NHD/xYd+Qrorr4cU5agAjW0gW+NdJcoiGEGb4Gy8UYe
         tKNQHUAjAiPQsZXTWDNbQ8sOPw2LVpPDWlf6Dwt2dn4Pzbekdi8eDLX08ivxEgKRYj7b
         ErJA==
X-Gm-Message-State: AOAM530xioaaXJX1L2SnrHaC1k6ZO3btV69JpSMlUBvOJt2/ntKJl8p/
        31xWWAuiIdSwaHnYRSuNAl8=
X-Google-Smtp-Source: ABdhPJx2bHAA1fMSgKXcNGaVnJa8dK/a+Z+hEfHbwcvzM6pqThq36otVcr/zHS7MdayqTNC7l2o/kg==
X-Received: by 2002:a17:90b:4012:: with SMTP id ie18mr5433848pjb.105.1632527660684;
        Fri, 24 Sep 2021 16:54:20 -0700 (PDT)
Received: from localhost ([2405:201:6014:d058:a28d:3909:6ed5:29e7])
        by smtp.gmail.com with ESMTPSA id j11sm13263488pjd.45.2021.09.24.16.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 16:54:20 -0700 (PDT)
Date:   Sat, 25 Sep 2021 05:24:17 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Networking <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v4 06/11] libbpf: Support kernel module function
 calls
Message-ID: <20210924235417.eqhzbrajwkenk6rd@apollo.localdomain>
References: <20210920141526.3940002-1-memxor@gmail.com>
 <20210920141526.3940002-7-memxor@gmail.com>
 <CAEf4BzaZOv5c=-hs4UX3UcqP-fFkv8ABx5FAWXRMCDE8-vZ9Lg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzaZOv5c=-hs4UX3UcqP-fFkv8ABx5FAWXRMCDE8-vZ9Lg@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 22, 2021 at 04:11:13AM IST, Andrii Nakryiko wrote:
> On Mon, Sep 20, 2021 at 7:15 AM Kumar Kartikeya Dwivedi
> <memxor@gmail.com> wrote:
> > [...]
> > +                       return -E2BIG;
> > +               }
> > +               ext->ksym.offset = index;
>
> > +       } else {
> > +               ext->ksym.offset = 0;
> >         }
>
> I think it will be cleaner if you move the entire offset determination
> logic after all the other checks are performed and ext is mostly
> populated. That will also make the logic shorter and simpler because
> if ayou find kern_btf_fd match, you can exit early (or probably rather

Ack to everything else (including the other mail), but...

> goto to report the match and exit). Otherwise
>

This sentence got eaten up.

> >
> >         kern_func = btf__type_by_id(kern_btf, kfunc_id);
>
> this is actually extremely wasteful for module BTFs. Let's add
> internal (at least for now) helper that will search only for "own" BTF
> types in the BTF, skipping types in base BTF. Something like
> btf_type_by_id_own()?
>

Just to make sure I am not misunderstanding: I don't see where this is wasteful.
btf_type_by_id seems to not be searching anything, but just returns pointer in
base BTF if kfunc_id < btf->start_id, otherwise in module BTF.

What am I missing? I guess the 'kern_btf' name was the source of confusion? If
so, I'll rename it.

Thanks.

--
Kartikeya
