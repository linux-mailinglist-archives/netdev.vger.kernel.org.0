Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00EB21CC5D3
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 02:51:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726906AbgEJAvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 20:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725927AbgEJAvD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 20:51:03 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17E9AC061A0C;
        Sat,  9 May 2020 17:51:03 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x2so2938312pfx.7;
        Sat, 09 May 2020 17:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SJngHyL3xoBUmmywOxoE/zc4Jwe0BGO/NPlqdh97Cxk=;
        b=G5X80piG+IGgC+PAAYXaBYC7Pa8zS63h64wwCUF/IduNKs0hhRjgY9A4SFS1qa2+AU
         YINOYG2e00UZV8Mq69qhFH2hfdVREc7+NbL0QuLnQ3WFX7y/w8aNeV6RgIsePBu5bgNi
         NykVYIboV3R8D2jJvLcG2Rql4toFVhM2Yd7qVCSN/ZFWX2sVzrpblLxllSTmdNIIQ82x
         Okb5yhKG6t5JYiJ20heZScOgO9DnmnyXtC3cPRDNGo0PFXxirOwAp4HBHkcr7gITAGkZ
         wOcymcwYFT8MkuewV3Og7ezarvghC6qSDNEEbmG3KyPyS6JQs1zlMMZ+pXeeuAz7MbFi
         frqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SJngHyL3xoBUmmywOxoE/zc4Jwe0BGO/NPlqdh97Cxk=;
        b=Cca13wCHN23FZFJcMAMOFehGCHV5e2joSUEaTnavAtKqSWaZDUNxZmr+0H494lZ2XM
         24niuOry6VJhLeHHkteU414fLe2oISLGCPVNk9e46OlyH8bRhhoT5PMTa00Kk+ZUWXgk
         5/Yw2SvhusBqnHRvFExKTWQqB3rV2MPgb65itQbPhXu79q3GNJIlLo0Aw4QUGK0ZCBv4
         gtATd+X2o5G9YsyB7zFiy5vMcmmki0n9fQrkipu0jJXxcaiICQuEeg0xIQCbddC3NV5F
         TQ0MWmo8foqqsDfsOPUPpyeGTrBKLJ/Zuh3FEYkg8N2QysHdKOjP/YdNwRmhDNZ30B6g
         eWng==
X-Gm-Message-State: AGi0Pub+BDpfqpMXHE3uERMRAVkDc0Wxm6PMlpZsafK57oeqBkmIkW20
        f0TBELipN6uUOa0idv5ZqS7DtdXs
X-Google-Smtp-Source: APiQypIY6Am0CycNqR/u+hT6VWOOLxAb5K88QLKXAXhklxRvfFZGzzF36UxbEoW4vPlUZLWYO9FCMw==
X-Received: by 2002:a62:e70b:: with SMTP id s11mr9878653pfh.32.1589071861866;
        Sat, 09 May 2020 17:51:01 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:7bdb])
        by smtp.gmail.com with ESMTPSA id n30sm508434pgc.87.2020.05.09.17.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 May 2020 17:51:00 -0700 (PDT)
Date:   Sat, 9 May 2020 17:50:59 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>, netdev@vger.kernel.org,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com
Subject: Re: [PATCH bpf-next v4 12/21] bpf: add PTR_TO_BTF_ID_OR_NULL support
Message-ID: <20200510005059.d3zocagerrnsspez@ast-mbp>
References: <20200509175859.2474608-1-yhs@fb.com>
 <20200509175912.2476576-1-yhs@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200509175912.2476576-1-yhs@fb.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 09, 2020 at 10:59:12AM -0700, Yonghong Song wrote:
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index a2cfba89a8e1..c490fbde22d4 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -3790,7 +3790,10 @@ bool btf_ctx_access(int off, int size, enum bpf_access_type type,
>  		return true;
>  
>  	/* this is a pointer to another type */
> -	info->reg_type = PTR_TO_BTF_ID;
> +	if (off != 0 && prog->aux->btf_id_or_null_non0_off)
> +		info->reg_type = PTR_TO_BTF_ID_OR_NULL;
> +	else
> +		info->reg_type = PTR_TO_BTF_ID;

I think the verifier should be smarter than this.
It's too specific and inflexible. All ctx fields of bpf_iter execpt first
will be such ? let's figure out a different way to tell verifier about this.
How about using typedef with specific suffix? Like:
typedef struct bpf_map *bpf_map_or_null;
 struct bpf_iter__bpf_map {
   struct bpf_iter_meta *meta;
   bpf_map_or_null map;
 };
or use a union with specific second member? Like:
 struct bpf_iter__bpf_map {
   struct bpf_iter_meta *meta;
   union {
     struct bpf_map *map;
     long null;
   };
 };
