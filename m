Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2992D47A3BB
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 04:00:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237301AbhLTDAR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 22:00:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231167AbhLTDAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 22:00:16 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62499C061574;
        Sun, 19 Dec 2021 19:00:16 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id m24so6919388pls.10;
        Sun, 19 Dec 2021 19:00:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uO7Nod4MihX5QhcjP+eT/44K4BJ2U8rVUr20mbnNgEk=;
        b=PayumOENrgE4Xp9YQwwE8UjEpth3Z4kQdwF22tv12oWBgGYJLfZpq2OBSxCUuF63OK
         szK0LRmzvWMvAZKM3XnlmmkTeU2n+HOxA75ihQ8/ie2mmT+Pgs0B3dyFzIf1ci3rgTaP
         TPS3MVaLXlTFntOfN1YyJQYUsV0tpSLetOOcGbbzGvTWKMRerxrfb5hY+e6jsWbIcyQ4
         nS0vIWyT1JnDZjHVoIBckdxH/A+z43cg4qs4c7umXebVgJ7+qbQSqbnYIR6WnnCRf3F0
         uhwSd/9D+bM09dmG2h4crOxy4mVbMxWbrwN65SC0jTv2K8l8e56acnTYiAgA+vYcnD+M
         AzqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uO7Nod4MihX5QhcjP+eT/44K4BJ2U8rVUr20mbnNgEk=;
        b=M2HoNOqRreuWEdQY++xWeT/hULL1bKGoerCMz3AQlMTEz/+8OBrTKmxun2Lij4q7YE
         yKp1iWm81p1qTY1zIpVlAUPhjJJrNRuny9VZyAYF/dXiLUSm6fdztJr9hrcedF9f/7oK
         rBWx2UFztucbNNJ5H1YVDgPPz7Bt9YbkGuIcIAMT2rTBFKnViJkCJUApE6cDGNHKlM2/
         DguYyRQnWNDNHOrLXFcMJXJCCFMVrX+XYyfUqPjW+35NV2SKEkA1wso2upOndcqg79oQ
         LqFnf/10f8ZPYs/EsxaDIS26/KrjoDdW2d28RTTPEqkrZwXt2lpjn+4dOCTDrz3uIxx8
         3jVA==
X-Gm-Message-State: AOAM531dpbBef7+WVHW8lb3069nkDyJ0/VCJhFE2HGGGG8TFsPNBp3U0
        HzauQzagi3DeyDTuVsoPIFw=
X-Google-Smtp-Source: ABdhPJw6dInBNPmUcpWVUkd0PF7rjNIeHaUtRe9K6/aTcKNTYzAreBJFpyUkcI1mAOAcKV4bBPbOJg==
X-Received: by 2002:a17:90b:4c11:: with SMTP id na17mr13766751pjb.136.1639969215885;
        Sun, 19 Dec 2021 19:00:15 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:9150])
        by smtp.gmail.com with ESMTPSA id p7sm2873018pjg.35.2021.12.19.19.00.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 19:00:15 -0800 (PST)
Date:   Sun, 19 Dec 2021 19:00:13 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, yunbo.xufeng@linux.alibaba.com
Subject: Re: [RFC PATCH bpf-next 0/3] support string key for hash-table
Message-ID: <20211220030013.4jsnm367ckl5ksi5@ast-mbp.dhcp.thefacebook.com>
References: <20211219052245.791605-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211219052245.791605-1-houtao1@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 19, 2021 at 01:22:42PM +0800, Hou Tao wrote:
> Hi,
> 
> In order to use string as hash-table key, key_size must be the storage
> size of longest string. If there are large differencies in string
> length, the hash distribution will be sub-optimal due to the unused
> zero bytes in shorter strings and the lookup will be inefficient due to
> unnecessary memcpy().
> 
> Also it is possible the unused part of string key returned from bpf helper
> (e.g. bpf_d_path) is not mem-zeroed and if using it directly as lookup key,
> the lookup will fail with -ENOENT (as reported in [1]).
> 
> The patchset tries to address the inefficiency by adding support for
> string key. During the key comparison, the string length is checked
> first to reduce the uunecessary memcmp. Also update the hash function
> from jhash() to full_name_hash() to reduce hash collision of string key.
> 
> There are about 16% and 106% improvment in benchmark under x86-64 and
> arm64 when key_size is 256. About 45% and %161 when key size is greater
> than 1024.
> 
> Also testing the performance improvment by using all files under linux
> kernel sources as the string key input. There are about 74k files and the
> maximum string length is 101. When key_size is 104, there are about 9%
> and 35% win under x86-64 and arm64 in lookup performance, and when key_size
> is 256, the win increases to 78% and 109% respectively.
> 
> Beside the optimization of lookup for string key, it seems that the
> allocated space for BPF_F_NO_PREALLOC-case can also be optimized. More
> trials and tests will be conducted if the idea of string key is accepted.

It will work when the key is a string. Sooner or later somebody would need
the key to be a string and few other integers or pointers.
This approach will not be usable.
Much worse, this approach will be impossible to extend.
Have you considered a more generic string support?
Make null terminated string to be a fist class citizen.
wdyt?
