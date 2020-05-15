Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EBD1D41F8
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 02:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728056AbgEOAJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 20:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbgEOAJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 20:09:26 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4304CC061A0C;
        Thu, 14 May 2020 17:09:25 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 23so115799pfy.8;
        Thu, 14 May 2020 17:09:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ah0+2uSyJ1tzkppjBImuG7UEaIqlnYN0RR1RbLnlBGY=;
        b=NczCZ3UGdi1OaVj2w53MUQTPs1fmLRzdv0SwUbupu6J8bdYITMhm+VNz1ld5OrdU/Q
         GEwZB/00I5bYWvfqzl1AopN2rHHz52xDbXU9zMb36xuCM8KQSHKb/Ti+nxZb/5/ylX6Z
         bnCFqUnNCSYlgjdxuF+sVWVm61hdgYYxjO4TRDqD0DhOIYz459K/rSuMoOR4kbw6Kss3
         ojChb4Bf91wZ7mMCDQw9zBZ4gc6Idd2AjRXopqCFoF0hX2wNLxAK98xi1LfLPsKVtMbY
         z0Ys6rAKegzXN1MvvwbHeQOqMo86dD601BR/2Qbk1PUjmq5OQnrZILkQ4P18+o65zM9K
         oQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ah0+2uSyJ1tzkppjBImuG7UEaIqlnYN0RR1RbLnlBGY=;
        b=CjkYazk+iC4C1WlHf7WPCpXXO0c5JY8fuNwHiy2iWPhO32rkOf5gCpgdI7TEKFO+LO
         QwovoOBRUnvtJDjztvVboy0980FxKp0P6Gt7SnKhpzZMoVlkkMBj/LxVw7ZJ0ujjQCVb
         2wJT8XBEaCrQMBMuWHjkDTsYvCuKW27oIZq/b2NyOj+qQhLjhoM9GWVLU7+Euci1nstF
         QWrCyoGl9PdDuPz+Wiz8O4+Q4Z4kNfle7HpT8vEo0W+T6KcWlgG5a2uayGm5MljXxoys
         pViKwALoKm8tgDAqj3q4pxyEsLLvZvJ7JaIlap25+BhL6NJEsZT/YyO6feaNZIDwwToV
         vv9A==
X-Gm-Message-State: AOAM530AThrJ/6dSlYUdXdQ8RNF2I2/SKyme4nTCnWkoiN0NMA9QRyO2
        Vkl1Baf1s890+wkUM2q5cNZt51Z4
X-Google-Smtp-Source: ABdhPJx99L0ylPt+Bg7Btel5BxtMlGxF6reoE1F7WRl4oCm9enpKkLtCR88stej65RVFvBhdBqoILg==
X-Received: by 2002:a63:3d7:: with SMTP id 206mr600878pgd.45.1589501364772;
        Thu, 14 May 2020 17:09:24 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9720])
        by smtp.gmail.com with ESMTPSA id b11sm278737pgq.50.2020.05.14.17.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 17:09:23 -0700 (PDT)
Date:   Thu, 14 May 2020 17:09:20 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Alan Maguire <alan.maguire@oracle.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 bpf-next 4/7] printk: add type-printing %pT format
 specifier which uses BTF
Message-ID: <20200515000920.2el4jyrwqqbd6jw3@ast-mbp.dhcp.thefacebook.com>
References: <1589263005-7887-1-git-send-email-alan.maguire@oracle.com>
 <1589263005-7887-5-git-send-email-alan.maguire@oracle.com>
 <1b63a6b193073674b6e0f9f95c62ce2af1b977cc.camel@perches.com>
 <CAADnVQK8osy9W8-u-K=ucqe5q-+Uik41fBw6d-SfG-m6rgVwDQ@mail.gmail.com>
 <397fb29abb20d11003a18919ee0c44918fc1a165.camel@perches.com>
 <28145b05ee792b89ab9cb560f4f9989fd3d5d93b.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28145b05ee792b89ab9cb560f4f9989fd3d5d93b.camel@perches.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 14, 2020 at 04:43:24PM -0700, Joe Perches wrote:
>  The ``BTF_INT_BITS()`` specifies the number of actual bits held by this int
>  type. For example, a 4-bit bitfield encodes ``BTF_INT_BITS()`` equals to 4.
> diff --git a/include/uapi/linux/btf.h b/include/uapi/linux/btf.h
> index 5a667107ad2c..36f309209786 100644
> --- a/include/uapi/linux/btf.h
> +++ b/include/uapi/linux/btf.h
> @@ -90,6 +90,7 @@ struct btf_type {
>  #define BTF_INT_SIGNED	(1 << 0)
>  #define BTF_INT_CHAR	(1 << 1)
>  #define BTF_INT_BOOL	(1 << 2)
> +#define BTF_INT_HEX	(1 << 3)

Nack.
Hex is not a type.
