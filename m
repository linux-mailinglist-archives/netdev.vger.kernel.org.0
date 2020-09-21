Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA611272A8D
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 17:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgIUPog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 11:44:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727671AbgIUPof (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 11:44:35 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B006BC061755;
        Mon, 21 Sep 2020 08:44:35 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id f2so9385458pgd.3;
        Mon, 21 Sep 2020 08:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=nMlmdMcGoUi9KnNPeiIqpuPN1ITm1hi8rhCIaBDvBDs=;
        b=h+xEOCR7L5hGw0aqJCIZS/ylJJQNF6e4xxF+s2WVQcKaS0R3zl4r+UmTwTEC8nSNKE
         HI9QdsHwmlFRAklNzZKBKublOBpHM+WmnQJye0JP5YvKfXjT2cvl8HiSdRmj2LzeEkwT
         ypeUTAXkJNX96QS9A/lclvJym6CB0siTlqH9VNamWUzrdu1DZ1HSPUr1nw2AIfB1nZ7b
         G5uynSOy+QHaHhf1Pgs/I/IyoRwVhkj8YrPcjrKBr36FWGvEcGhVm5iugXFGks/hUkh/
         kmepZqYBFFDLlUs8m88BkdbDFhrETkYj8oNqyyOuGOdKN9fiyDZhLjy0o1GyL6maQTKz
         bqxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=nMlmdMcGoUi9KnNPeiIqpuPN1ITm1hi8rhCIaBDvBDs=;
        b=LNFQAePozR0t+sqESqorxYjZ24/AIwX0PZ0fg16mIDR2IJWkkGjXcgEjqrCxdizkED
         Xzu+DRw1DulH1rO13rrFIyfieWHiWA4vb3XOhISEGEs+KfnxkerAQCq3xOeDibxXlwHV
         BiRCv8/rJQG7PmL/roddTfQOhlAVXfnUMnWcdF2E4pCRh+JzlPb8oADkwlzWkwhhszY3
         3DZ+q6yBf90XS1UTcUEzodRg3Lszi4tYz3+kbe/sP8f5GFYafrb05NtFqytFf9ypIHD7
         NndJ0A83RSnLJgxUX75rpeXAKNxpstGYZZu/Xf9NvBysoGHjURpLGhJ8oejb40nEoThw
         34mw==
X-Gm-Message-State: AOAM5318X55n949PtgsEAdQYjSDSN3Rd2GjHlxPj1z4zDlFk7Jkj8Ol0
        HUmnAlD67PYQ1DN5dUtjmJ0Xq9WNr3vP0w==
X-Google-Smtp-Source: ABdhPJxM6cLG4MMcPYMGz/m3eg3SQWysPfmBkpoXyysf8yTJ1H3QfJiUvCn0SfbkI5mzqgi2h/8clQ==
X-Received: by 2002:a17:902:eb54:b029:d1:f365:a5d2 with SMTP id i20-20020a170902eb54b02900d1f365a5d2mr445477pli.73.1600703075239;
        Mon, 21 Sep 2020 08:44:35 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z9sm11889114pfk.118.2020.09.21.08.44.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 08:44:34 -0700 (PDT)
Date:   Mon, 21 Sep 2020 08:44:27 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Tony Ambardar <tony.ambardar@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-arch@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <5f68ca5b74a34_17370208a4@john-XPS-13-9370.notmuch>
In-Reply-To: <b38db205a66238f70823039a8c531535864eaac5.1600417359.git.Tony.Ambardar@gmail.com>
References: <cover.1600417359.git.Tony.Ambardar@gmail.com>
 <b38db205a66238f70823039a8c531535864eaac5.1600417359.git.Tony.Ambardar@gmail.com>
Subject: RE: [PATCH bpf v1 1/3] bpf: fix sysfs export of empty BTF section
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tony Ambardar wrote:
> If BTF data is missing or removed from the ELF section it is still exported
> via sysfs as a zero-length file:
> 
>   root@OpenWrt:/# ls -l /sys/kernel/btf/vmlinux
>   -r--r--r--    1 root    root    0 Jul 18 02:59 /sys/kernel/btf/vmlinux
> 
> Moreover, reads from this file succeed and leak kernel data:
> 
>   root@OpenWrt:/# hexdump -C /sys/kernel/btf/vmlinux|head -10
>   000000 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
>   *
>   000cc0 00 00 00 00 00 00 00 00 00 00 00 00 80 83 b0 80 |................|
>   000cd0 00 10 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
>   000ce0 00 00 00 00 00 00 00 00 00 00 00 00 57 ac 6e 9d |............W.n.|
>   000cf0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 |................|
>   *
>   002650 00 00 00 00 00 00 00 10 00 00 00 01 00 00 00 01 |................|
>   002660 80 82 9a c4 80 85 97 80 81 a9 51 68 00 00 00 02 |..........Qh....|
>   002670 80 25 44 dc 80 85 97 80 81 a9 50 24 81 ab c4 60 |.%D.......P$...`|
> 
> This situation was first observed with kernel 5.4.x, cross-compiled for a
> MIPS target system. Fix by adding a sanity-check for export of zero-length
> data sections.
> 
> Fixes: 341dfcf8d78e ("btf: expose BTF info through sysfs")
> 
> Signed-off-by: Tony Ambardar <Tony.Ambardar@gmail.com>
> ---
>  kernel/bpf/sysfs_btf.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/bpf/sysfs_btf.c b/kernel/bpf/sysfs_btf.c
> index 3b495773de5a..11b3380887fa 100644
> --- a/kernel/bpf/sysfs_btf.c
> +++ b/kernel/bpf/sysfs_btf.c
> @@ -30,15 +30,15 @@ static struct kobject *btf_kobj;
>  
>  static int __init btf_vmlinux_init(void)
>  {
> -	if (!__start_BTF)
> +	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
> +
> +	if (!__start_BTF || bin_attr_btf_vmlinux.size == 0)
>  		return 0;
>  
>  	btf_kobj = kobject_create_and_add("btf", kernel_kobj);
>  	if (!btf_kobj)
>  		return -ENOMEM;
>  
> -	bin_attr_btf_vmlinux.size = __stop_BTF - __start_BTF;
> -
>  	return sysfs_create_bin_file(btf_kobj, &bin_attr_btf_vmlinux);
>  }

Thanks LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
