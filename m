Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CB653FBD42
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 22:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhH3UIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 16:08:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231499AbhH3UIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 16:08:04 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E436CC061575;
        Mon, 30 Aug 2021 13:07:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id c6so17622pjv.1;
        Mon, 30 Aug 2021 13:07:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=F4LBFaEfhn9swDd4bPq9l1w+ot+i67zWWaxZ2V4HcAM=;
        b=Lg/oYysYBobHZ/cOycGYVyROhkFjjfgvK/seZ6lWw7mJmITNREPurD+tlgDuynuijQ
         rR7PLWP+A9HDNAspUd0FPEPFJJbUsAkx1TFsuTzGguQV49a8WVg4KyAoz2dmuu9Ngao8
         nyNw7jxgjijjWjNRuDWA6ayJttlg8Jf0TAaGiyQtUu1BuJrnJQGQ29BmTC0X80ucrcK1
         ELZeuAFYMLovJk2QIuSJmAbbL9V7Ifs/ozIO4U9Yo9dQd6aO4zY72j8RAl8o75v6yT0E
         nDnWSQD55UHqQZiZ86J6hcFEOtZGPqwd9RgoOf5MLCZA+cTFNXWFyQJ2+k8uoKQ/pExj
         mnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=F4LBFaEfhn9swDd4bPq9l1w+ot+i67zWWaxZ2V4HcAM=;
        b=cxo8EsXUil8/uSWz88TlTknRbcml7jd0nPo/U0XAinY7PojxvXxfOFYqXjoJRzg90u
         xyN8HjvqLFw4ktH40YYHn2tTVJ7G6zXbn6InP95r6ovxPveFJ40dZaK5QNo3LCgbYDVC
         bX9BU8Oa5Mpr8lYJz1+YWQ0fZ4WlEseik6tqy07E/2SviMORDG9GLrrYtuM/K5bC8DxM
         NBCOPK8//isz9bQDblfvIjuZkReHAHRrYcl8ApzpC0c5oAyR17LmmzOo/YoqzD+eMY/L
         IIcDeME55+HTBdLrUTfQoWBst62BLLoBbX2glfuBGm5eJEh1hKStHDcBRmkeJBqWbJAl
         UIbg==
X-Gm-Message-State: AOAM533dv7Kr6MPHOxo+5OWXbjgn7iQFFzHjGbTTdALitc1+GWgys6mx
        z0uyyq/+jF2ROgqBz9NaCR8=
X-Google-Smtp-Source: ABdhPJwhw5hvYHAp+/sq4BY5aUZWFwbCilX5a3ZH2K9f+2Gi55gorxRe1IWFr/IAoP5UrXZu/9aEkA==
X-Received: by 2002:a17:90a:4306:: with SMTP id q6mr900397pjg.202.1630354030335;
        Mon, 30 Aug 2021 13:07:10 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4106])
        by smtp.gmail.com with ESMTPSA id c64sm14826472pfc.8.2021.08.30.13.07.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Aug 2021 13:07:10 -0700 (PDT)
Date:   Mon, 30 Aug 2021 13:07:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next RFC v1 8/8] bpf, selftests: Add basic test for
 module kfunc call
Message-ID: <20210830200707.zxmj32dq3pvm42mc@ast-mbp.dhcp.thefacebook.com>
References: <20210830173424.1385796-1-memxor@gmail.com>
 <20210830173424.1385796-9-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830173424.1385796-9-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:04:24PM +0530, Kumar Kartikeya Dwivedi wrote:
> diff --git a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> index 2cd5cded543f..d3b0adc2a495 100644
> --- a/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> +++ b/tools/testing/selftests/bpf/prog_tests/ksyms_module.c
> @@ -4,21 +4,19 @@
>  #include <test_progs.h>
>  #include <bpf/libbpf.h>
>  #include <bpf/btf.h>
> -#include "test_ksyms_module.lskel.h"
> -
> -static int duration;
> +#include "test_ksyms_module.skel.h"

bpf_btf_find_by_name_kind supports searching in modules,
so adding support for kfunc in modules to lskel shouldn't be hard to add.
