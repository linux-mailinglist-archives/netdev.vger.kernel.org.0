Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E91771249C2
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbfLROda (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:33:30 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43266 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfLROda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:33:30 -0500
Received: by mail-pl1-f193.google.com with SMTP id p27so1047182pli.10;
        Wed, 18 Dec 2019 06:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=S7VuXH2/a6Sp4J23Z7HyebUXkj6FvY8kwo3J39MAX3U=;
        b=bVktt/ZGMTEU4Plk/R1hGLU3ycvr9tXipByRQqViuESYblINVHxn5eBupumCDQJ1SS
         o/bFwX7U5jUm6wYQCBfcMLvOQiPVnQi5P6MVxKYxSf4672ZZAX6Y9J1z9t9XXHw6f5hV
         Xe8guEMu3ISJv5vXnXfCydpYQ0iqOTwr5RufJ7XWuWfqrImhFtbzJto1ndzfwQzRfqgu
         lIMG6R68O4Ipaqt8gY8qHmEIBxwHqktyJ1Ya/NuLbTAi5P7l2q5XNV3gBAeg/xQ55KG9
         i2BgexLG4WfBO7ua7CJe52mmCnqmqrzAW/G/XRr22DvlwaRGvPCI4lGpevJfm9DaFQI+
         C7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=S7VuXH2/a6Sp4J23Z7HyebUXkj6FvY8kwo3J39MAX3U=;
        b=UpwSuzX9cLVo2KFODP4JJyNi9rTdjxIJviBaQ337TUyqgM9/9BV+lZLKsOdf7+qgfY
         57VytyntDL/4Mtk1eooU/yxYYq7KtdLN3VbZ2iFXWNOpx1yk/TwpCTHiZAXozmGTfa/c
         Uaz06QPrk5Jo0epqUAmdv7omA66RGKe6uaNwuB2uZ4QKDUwVGjVsc0cYIJ9scZOJ0weC
         N4Q2OYbD44GcdZI751EDPhPy8hn3cAP0PdlT2YmTqKikcu0FsgcEbjtywSIJnTbLaUfD
         25E1/70zQzIjo7PPfFij+ARz6pbrYDtm3zz3quaXwT4F4lHOZzkj6vhOn20imj1kACcN
         15Nw==
X-Gm-Message-State: APjAAAViNfNj0GaxnBuch3aFNxKSjRYQyQ4CNYR4FlADKscjoIsAO3qB
        UnM6qetRmYC39xzGNmD9HJc=
X-Google-Smtp-Source: APXvYqztBgzoAs1ZfcOvHZsCTT447fzwCtV+/kcyavj5LTE6+7P+iXnqZOyqq8h18Ok308rSyjw/kQ==
X-Received: by 2002:a17:902:6948:: with SMTP id k8mr2962890plt.223.1576679608939;
        Wed, 18 Dec 2019 06:33:28 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id 68sm3516621pge.14.2019.12.18.06.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:33:28 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id ED4F840352; Wed, 18 Dec 2019 11:33:25 -0300 (-03)
Date:   Wed, 18 Dec 2019 11:33:25 -0300
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
Message-ID: <20191218143325.GE13395@kernel.org>
References: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211080109.18765-1-andrey.zhizhikin@leica-geosystems.com>
X-Url:  http://acmel.wordpress.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, Dec 11, 2019 at 08:01:09AM +0000, Andrey Zhizhikin escreveu:
> GCC9 introduced string hardening mechanisms, which exhibits the error
> during fs api compilation:
> 
> error: '__builtin_strncpy' specified bound 4096 equals destination size
> [-Werror=stringop-truncation]
> 
> This comes when the length of copy passed to strncpy is is equal to
> destination size, which could potentially lead to buffer overflow.
> 
> There is a need to mitigate this potential issue by limiting the size of
> destination by 1 and explicitly terminate the destination with NULL.

Thanks, applied and collected the reviewed-by and acked-by provided,

- Arnaldo
 
> Signed-off-by: Andrey Zhizhikin <andrey.zhizhikin@leica-geosystems.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/api/fs/fs.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
> index 11b3885e833e..027b18f7ed8c 100644
> --- a/tools/lib/api/fs/fs.c
> +++ b/tools/lib/api/fs/fs.c
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
>  	return true;
>  }
>  
> -- 
> 2.17.1

-- 

- Arnaldo
