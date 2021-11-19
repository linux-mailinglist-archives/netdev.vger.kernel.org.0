Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 798A74568F3
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 05:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233029AbhKSEPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 23:15:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbhKSEPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 23:15:02 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8CF4C061574;
        Thu, 18 Nov 2021 20:12:01 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id p18so7097925plf.13;
        Thu, 18 Nov 2021 20:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=eEqSzygGSjhx2aXkg9j1/S8ZDkmYqyyREKYjNrWoQRQ=;
        b=AZ6HHEJKc2X08STGDE0jNV96OVQKQb/JxZl+3vIp3dUqEnOIuOZcwYpiPjtNYcOc3J
         H3wmOmBROOY3o7dhy7bdnq8FR/9GyJxQ5VbE/DoEGQv9oaagVhRpAV2iQj9BE6cPV0HQ
         vLC14rWbWYFsN1u9g8HL6YYGMw5PQ69cgeHERaTv/PW2yprnzm11z0x07y4qkgTnYe2x
         hrq/adLfsWfN2F0BdTcZYd6W3sVlYwGlKFUZHNck6DmbSbadq+Cm0HpG9rUhGaB6ECHw
         X0oM5egr7eI4veYVGrviePMpam4MmbRxXR99iFn5DbT0xIxk5uTmMd8yeX76tos+zkDX
         avyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=eEqSzygGSjhx2aXkg9j1/S8ZDkmYqyyREKYjNrWoQRQ=;
        b=Yh9fJbZLAHnYYuGROWTwA8TlRwpN8g6QMwphpFpHMLUq3n9BfmD/V/u3PbcWw3ALGx
         BLGR51rs4qLFDj9glEEpiblG7xUpM/rLz7PExpZ8jYqPILE2GxzHNb8cXPClH1U+7923
         orJIzjxZDzDAWJdxEEvFXZdrLIyELOEHvASJFEwBO29B7BZfa7iXdITJmqRKRO1f3Ys6
         x//QDqest5c4ZwuAavTVLi1xywdxujgrzF5LjoP+dBvRuQqwRHHyhNv4JJS8xmi+djqM
         2fcs4NMzaErOZW/BqZAHZ+4BqX38/bpeZDgJglQC9OD/Z74/cKM2yzkaQFseIlRRu3AT
         MaKQ==
X-Gm-Message-State: AOAM530mCd4kDSEdjSOD9T30ib999+lGorIjyqSAX6mGWtMzLXK9MEe9
        ADLaGhx6KZmCM80g8Z9pxeY=
X-Google-Smtp-Source: ABdhPJyVlTazncf0DoICoxC0P2NqXV4h9fo1k/eqZqaeA5JMYYtV7eGK+v/2KuKVx71d75TxcRu+Dg==
X-Received: by 2002:a17:903:249:b0:143:c077:59d3 with SMTP id j9-20020a170903024900b00143c07759d3mr51798503plh.26.1637295121130;
        Thu, 18 Nov 2021 20:12:01 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:4e33])
        by smtp.gmail.com with ESMTPSA id oa17sm896935pjb.37.2021.11.18.20.11.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 20:12:00 -0800 (PST)
Date:   Thu, 18 Nov 2021 20:11:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Subject: Re: [PATCH bpf-next 09/29] bpf: Add support to load multi func
 tracing program
Message-ID: <20211119041159.7rebb5lz2ybnygqr@ast-mbp.dhcp.thefacebook.com>
References: <20211118112455.475349-1-jolsa@kernel.org>
 <20211118112455.475349-10-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211118112455.475349-10-jolsa@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 18, 2021 at 12:24:35PM +0100, Jiri Olsa wrote:
> +
> +DEFINE_BPF_MULTI_FUNC(unsigned long a1, unsigned long a2,
> +		      unsigned long a3, unsigned long a4,
> +		      unsigned long a5, unsigned long a6)

This is probably a bit too x86 specific. May be make add all 12 args?
Or other places would need to be tweaked?

> +BTF_ID_LIST_SINGLE(bpf_multi_func_btf_id, func, bpf_multi_func)
...
> -	prog->aux->attach_btf_id = attr->attach_btf_id;
> +	prog->aux->attach_btf_id = multi_func ? bpf_multi_func_btf_id[0] : attr->attach_btf_id;

Just ignoring that was passed in uattr?
Maybe instead of ignoring dopr BPF_F_MULTI_FUNC and make libbpf
point to that btf_id instead?
Then multi or not can be checked with if (attr->attach_btf_id == bpf_multi_func_btf_id[0]).
