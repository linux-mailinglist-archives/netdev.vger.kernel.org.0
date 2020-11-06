Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C21182A8D72
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 04:19:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725885AbgKFDTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 22:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKFDTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 22:19:18 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5525C0613CF;
        Thu,  5 Nov 2020 19:19:17 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id v12so1684pfm.13;
        Thu, 05 Nov 2020 19:19:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rsX+ZOkCDabl7U+y+5TWomfX73W7lzEa2lWErJBJJEA=;
        b=S+I/PL4E08bK0RUKlVZljVInvlmziQomhFts0ZJ9tIOSTY0W9NADaUFZFkn2gur/Bw
         MuJTeAZZAasNN7QWon6SW0xwUgAPooezwQ/MoNqvUw754ZX/4Dq6benpqDGkJ6hZPro3
         OCpLQtNLZ78VW8dB4AsFM0ZNJcvXbFwiHoECUl/TnSR4qGK4mQqh8/3Z2jImD7wcL4ni
         +zCRtJcY4qQ9o0EhGCSRK32zY22CVHSxnSasFM5Mw6WQhU92icYxUjTjZONNc2R+TzSZ
         EPhalqse3ELwwHsiVFFhADrORqV2MpCy9Bg1BphkE9vMzDwleXfSnqv/34IWVZyb/PEG
         Aprg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rsX+ZOkCDabl7U+y+5TWomfX73W7lzEa2lWErJBJJEA=;
        b=MrtluV5IEow688/ofgdUhRg5pavoKtm7GDTSmB1xpCBY00aP3Wov3NTayWt3QEw48q
         3vtffdMesSxac4Vfn3cBSPLYibuDWcA1T0cRKhLcRJs60RM46rh7PAp3EMvGUYFuFaNR
         IUovx121M+U6M0Ihp/gUDxBwE35e6mxhMcU4+X6azNfAWutYkiJjNl/rfYoiSRR1vzPG
         S9c6O83aW061CbS2wMMZmYNdvA2B4OoNX4gMJZ7A6fTV2NQ6vjm2ZY0KXXG6zYSP2YL5
         U9I4hzmp/mz5Qh5Ypc/OQLWQr0IE+lJw9lbBTgyBYStF4Xamn1rUm8ctppSiilbqnil4
         Zgzg==
X-Gm-Message-State: AOAM531fZH83c9B08KppaFxXYyv4a30o8iym/RUYvSZJCTRlCerTvwbV
        awekZTkjSCZQJgZtZdW1CkU=
X-Google-Smtp-Source: ABdhPJw56sGrVsYznFt7Io0IJseTgLVUTQSVok1XqEVtnEKgJi17hbVOsG9kVqLP9AY9a7ilgyKc4g==
X-Received: by 2002:aa7:9387:0:b029:18b:42dd:41c with SMTP id t7-20020aa793870000b029018b42dd041cmr89473pfe.60.1604632757334;
        Thu, 05 Nov 2020 19:19:17 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:b55b])
        by smtp.gmail.com with ESMTPSA id t12sm12641pfq.79.2020.11.05.19.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 19:19:16 -0800 (PST)
Date:   Thu, 5 Nov 2020 19:19:14 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@fb.com,
        daniel@iogearbox.net, kernel-team@fb.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC PATCH bpf-next 2/5] bpf: assign ID to vmlinux BTF and
 return extra info for BTF in GET_OBJ_INFO
Message-ID: <20201106031914.dugp23xaiwnjbv7g@ast-mbp>
References: <20201105045140.2589346-1-andrii@kernel.org>
 <20201105045140.2589346-3-andrii@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105045140.2589346-3-andrii@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 04, 2020 at 08:51:37PM -0800, Andrii Nakryiko wrote:
> @@ -215,6 +215,8 @@ struct btf {
>  	struct btf *base_btf;
>  	u32 start_id; /* first type ID in this BTF (0 for base BTF) */
>  	u32 start_str_off; /* first string offset (0 for base BTF) */
> +	char name[MODULE_NAME_LEN];
> +	bool kernel_btf;
>  };
>  
>  enum verifier_phase {
> @@ -4441,6 +4443,7 @@ struct btf *btf_parse_vmlinux(void)
>  
>  	btf->data = __start_BTF;
>  	btf->data_size = __stop_BTF - __start_BTF;
> +	btf->kernel_btf = true;

imo it's a bit weird for vmlinux's BTF to be flagged as 'kernel_btf'
and empty name, but kernel module's BTFs will not be marked as kernel,
but will have a name.
I think it's more natural to make vmlinux and module's BTF with kernel_btf=true flag
and give "vmlinux" name to base kernel BTF.
If somebody creates a kernel module with "vmlinux" name we will have a conflict,
but that name is for human pretty printing only anyway, so I think it's fine.
