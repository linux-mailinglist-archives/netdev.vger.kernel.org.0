Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3E6214D96
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 17:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgGEPPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 11:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726826AbgGEPPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 11:15:47 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AE9C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 08:15:47 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id ed14so5680336qvb.2
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 08:15:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=LQZBm1N88ysN/Vb99I6+UF6RMyu/DL0IGZIhUxQB2NA=;
        b=D1GrL3l4eP7UL5PeKhCO+NEGItTzFeyC/q1iUqP72xa1ZkLh/9wvYJHhNde6IqG5vv
         NeioeazxJBiuofYJTWF+vMxZ7vPEiZhTN+cgkd6D/7HZZlf7UUQxxZKzDjcT2kRGlJMA
         6arf2deWlvVDIZa3fw8tW/z+3VTNt2cIBxzPWAHUPyVSDYJV7CJpIhBt2jBVPX0gV4bD
         K3x/OzCeT5N7goFPEVEoB256kj4igdpgor/vfSHRhsw9leuMKmH/FPw9EYTvFuJxWXTa
         RbbUjNGFQ+Idv/GQziy/YrLQpl5yfola+7XNqtwsnbz6MZ3Vnkd70NfwkiRYiskOwf6K
         MsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LQZBm1N88ysN/Vb99I6+UF6RMyu/DL0IGZIhUxQB2NA=;
        b=dTVGrt+97yNJLQr/HbBnDKvQQuRHF91HImM/ygQZMlBT7KQrkgsoxLD2yvgRwgeid5
         NdCiG/gOjL85JwNpXFb1C6bPNUjrzluxWVQ8y4T6deVKrhkHyFp8jAHZFtnAhwRxdQx3
         y279yf98ISImV3I/UeuoNcwiOk37lt4zLZZcgqRNEss7cp3ZgZvC1bEUMtsWXHwUviLj
         /z433fPbSAj4I5veO/jE5Rj+2G+7SEHhMt0TTrOo+iFQdTfwq19bkm3HJxzBcUsAEZY/
         4SC3dKx1jI+ELZOnaEwFRDnGsW5/hlAKGk8uaHUCpySuSTw4bxCjRQWZtCY/XdlSka0p
         VBsw==
X-Gm-Message-State: AOAM531lDfLAYCTrA9FuaSZkBZ8mCalTxk8ajClYxYYlneVjp65r9FCF
        Di0hOUPvrI5ivEdtyVDlVsI=
X-Google-Smtp-Source: ABdhPJzJX8WTh2jP0pDDja9ePNXMTlH2JhSR2NxtYNzRY+9jHlxsI8Zn/ySu8O8BIvmosZj2TowsJw==
X-Received: by 2002:a0c:fde4:: with SMTP id m4mr28235645qvu.97.1593962146843;
        Sun, 05 Jul 2020 08:15:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f517:b957:b896:7107? ([2601:282:803:7700:f517:b957:b896:7107])
        by smtp.googlemail.com with ESMTPSA id p186sm16536413qkf.33.2020.07.05.08.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 08:15:46 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] lib: fix checking of returned file handle
 size for cgroup
To:     Dmitry Yakunin <zeil@yandex-team.ru>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200625114657.49115-1-zeil@yandex-team.ru>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <80ae9017-7a2d-bde6-318a-08cfd40e428d@gmail.com>
Date:   Sun, 5 Jul 2020 09:15:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200625114657.49115-1-zeil@yandex-team.ru>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/25/20 5:46 AM, Dmitry Yakunin wrote:
> Before this patch check is happened only in case when we try to find
> cgroup at cgroup2 mount point.
> 

needs to go to main branch with
Fixes: d5e6ee0dac64 ("ss: introduce cgroup2 cache and helper functions")

> Signed-off-by: Dmitry Yakunin <zeil@yandex-team.ru>
> ---
>  lib/fs.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/lib/fs.c b/lib/fs.c
> index e265fc0..4b90a70 100644
> --- a/lib/fs.c
> +++ b/lib/fs.c
> @@ -148,10 +148,10 @@ __u64 get_cgroup2_id(const char *path)
>  					strerror(errno));
>  			goto out;
>  		}
> -		if (fhp->handle_bytes != sizeof(__u64)) {
> -			fprintf(stderr, "Invalid size of cgroup2 ID\n");
> -			goto out;
> -		}
> +	}
> +	if (fhp->handle_bytes != sizeof(__u64)) {
> +		fprintf(stderr, "Invalid size of cgroup2 ID\n");
> +		goto out;
>  	}
>  
>  	memcpy(cg_id.bytes, fhp->f_handle, sizeof(__u64));
> 

