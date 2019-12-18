Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E062123DB5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 04:10:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726559AbfLRDKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 22:10:23 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33553 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726492AbfLRDKX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 22:10:23 -0500
Received: by mail-pf1-f193.google.com with SMTP id z16so397641pfk.0;
        Tue, 17 Dec 2019 19:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=LBIJn2SIZiHMOC6lsPrhyQmx9/2pEAlUVfbj1V0vjFE=;
        b=Qwwbu5sj4BzO7U3jn3USIMtRwYHavd9JDZjw0Nb48usgD/8tBvg+4hFL+ILtaj3jEo
         ejORVvFlZtBjNjwnegzV0uRhh/rmS+OkCxrwOGmk2dMkHpQ1UyqJzp0sU+xNbTT4ttV4
         SEolmKSh5fSMzfgCGuhfmbNHFcZarhTPCexBWNAD2t2oFUyzWXuIqa+hC5gDQkc6SpUw
         xMoocQ9/b6ZLPGeqZgmUwSfWhi07BsmXaTOsMAx13bvkWoZBPbZSRB5B1WZn0+DCD0B+
         SKj7lCmWvR5c4DdaJdYuPpNAmutNfQdCpUSryK7FP9inxE8YN7k31+6cccGdTugaK+QX
         oc0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=LBIJn2SIZiHMOC6lsPrhyQmx9/2pEAlUVfbj1V0vjFE=;
        b=WEUieMnPp15/gLUNdxjSh6hDVm2XCVL7uf5AtLoHOhOiZRzR5QSBF+XApAkTMM+pwT
         6Py4gnZ5UVT8In0aZSpnYSkV3mOtlV1VNJOCYBexXlD01seFT1rxfNuJNEa0siDK26cG
         w/mM115jCC3wUUBqNgGV3US+0YegvpHz1lrq8kpkhKW32UPaQJTjoCmb3yChDQy5Hnbe
         HxcGm7qe+Un789xe2W18PLljmopv49Vv/bb6ZGuCS2hKHC7Jzqu12x3Y6Ybj4k9rBHMy
         iONjUeROKa8jNJCFEArJORFGYrHgc2n8UI4PJ61ofAEgth8NOlECaILgeLyMK8qGzWI9
         q0uw==
X-Gm-Message-State: APjAAAUvmsl0KAQ9rkYF18eMkxgaYnG2ZBz7AlEbZyId8paFdSX11SOa
        sWeJ2eToJI8lU/2DQlCAIY4=
X-Google-Smtp-Source: APXvYqz2GChr1K+TwAaGIzAlqerx7xix7fmcXiIYcRXvukmY3DBUQ91mdZ6oKRvfmPNkEAwESf6mSg==
X-Received: by 2002:a63:dc0d:: with SMTP id s13mr254770pgg.129.1576638622465;
        Tue, 17 Dec 2019 19:10:22 -0800 (PST)
Received: from localhost ([2a00:79e1:abc:f604:6e29:95ff:fe2d:8f34])
        by smtp.gmail.com with ESMTPSA id v29sm459617pgl.88.2019.12.17.19.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:10:21 -0800 (PST)
From:   Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
X-Google-Original-From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Date:   Wed, 18 Dec 2019 12:10:19 +0900
To:     Andrey Zhizhikin <andrey.z@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        sergey.senozhatsky@gmail.com, pmladek@suse.com,
        wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH] tools lib api fs: fix gcc9 compilation error
Message-ID: <20191218031019.GB419@tigerII.localdomain>
References: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On (19/12/11 08:01), Andrey Zhizhikin wrote:
[..]
> @@ -210,6 +210,7 @@ static bool fs__env_override(struct fs *fs)
>  	size_t name_len = strlen(fs->name);
>  	/* name + "_PATH" + '\0' */
>  	char upper_name[name_len + 5 + 1];
> +
>  	memcpy(upper_name, fs->name, name_len);
>  	mem_toupper(upper_name, name_len);
>  	strcpy(&upper_name[name_len], "_PATH");
> @@ -219,7 +220,8 @@ static bool fs__env_override(struct fs *fs)
>  		return false;
>  
>  	fs->found = true;
> -	strncpy(fs->path, override_path, sizeof(fs->path));
> +	strncpy(fs->path, override_path, sizeof(fs->path) - 1);
> +	fs->path[sizeof(fs->path) - 1] = '\0';

I think the trend these days is to prefer stracpy/strscpy over
strcpy/strlcpy/strncpy.

	-ss
