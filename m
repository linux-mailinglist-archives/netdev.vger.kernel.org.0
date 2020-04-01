Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89DBD19B6A1
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 21:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgDAT5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 15:57:47 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:45304 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732397AbgDAT5r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 15:57:47 -0400
Received: by mail-qk1-f193.google.com with SMTP id c145so1368705qke.12
        for <netdev@vger.kernel.org>; Wed, 01 Apr 2020 12:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=4qn7laUxocfpUF7wHojl5fjkob+Ycucgi3hGCUCQQbc=;
        b=hOjKJ5LN06tdG5/Q7oWVjA0SqRoir78Ic27B6yq6FIsNz/XlmL2vOAiz6yBQA8OVlg
         5lakTCDLNQLJY0lk9S8dSDSJVRsCn+05nFmDhFbABPEmQ2H2O+lE48jDz2y3svQVit5F
         DeuV7x9b9QTh1NUsZqBe+86X/90cyUJoG525z56zO27c+onFFcCY8uEYjdwEGv1ktPi+
         pnqQydBwpNDarjWPke5NO9O1rmIY+54KomPZjpPTc48qdNaxUwSCAqhVtg385O0agjQW
         xatep/NO18Vi9kJueXjIE62C6P+IuzYu2AVpl86+BbMXnvY27lqo35DaO4fZSX+Yu/bn
         0U9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4qn7laUxocfpUF7wHojl5fjkob+Ycucgi3hGCUCQQbc=;
        b=SB00eqMTOVtn3Ae8ZyXFNPrWoHH6usqCCzUh0xtiWZCf7/JbSJF0q6daBIvgohrz1f
         3Wl78ThBS7dRoYyGP25CH62/sPpj9xiuyIN7wm67MCXmzf15d5/mXB0c0cJvqZhpLpU+
         TjnzD1MNNs7i9+BTxGlnuT1WxUwS+vKeLOEeRtJLdB5RSQWUQeQFkRboBH6HsdqOvTTs
         B0sgNcM6ruJ1ZPf25ckPct4bwS2LDnwmU27FQUa39sYah9N6FcKgLCJKpusr6Gm6D00g
         I2KUJLZOf5zj7pmwji1A3HsKQ88cHCCRZ/rkvFPAeMCq7Fe8tkSUnj7F8NwuearU4gVv
         Vkfg==
X-Gm-Message-State: ANhLgQ1SmesWkDpKrdj1M04yfAeI2wmn34hGjSkYD5yjGzTlc8SCWAt/
        z0NxAxd5hCv4tjV3WNlmXis=
X-Google-Smtp-Source: ADFU+vttE+CeT9HnVPqckiZcztjgS65fi6fsYNweqL+xCKz81d/E7WIXMTOA1i2PpQMIhtYXgdITtw==
X-Received: by 2002:a05:620a:22ef:: with SMTP id p15mr11694033qki.495.1585771066550;
        Wed, 01 Apr 2020 12:57:46 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:f8fc:a46d:375f:4fa2? ([2601:282:803:7700:f8fc:a46d:375f:4fa2])
        by smtp.googlemail.com with ESMTPSA id c12sm2094993qkg.30.2020.04.01.12.57.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Apr 2020 12:57:46 -0700 (PDT)
Subject: Re: PATCH: Error message if set memlock=infinite failed during bpf
 load
To:     Stefan Majer <stefan.majer@gmail.com>, netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>
References: <CADdPHGsD4b5GNoLy3aPQndkA84P_m33o-G1kP7F7Xkhterw0Vw@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <386b1135-6a3b-f006-021f-95ba07f42ec5@gmail.com>
Date:   Wed, 1 Apr 2020 13:57:44 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <CADdPHGsD4b5GNoLy3aPQndkA84P_m33o-G1kP7F7Xkhterw0Vw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/20 12:57 AM, Stefan Majer wrote:
> Executing ip vrf exec <vrfname> command sometimes fails with:
> 
> bpf: Failed to load program: Operation not permitted
> 
> This error message might be misleading because the underlying reason can be
> that memlock limit is to small.
> 
> It is already implemented to set memlock to infinite, but without
> error handling.
> 
> With this patch at least a warning is printed out to inform the user
> what might be the root cause.
> 
> 
> Signed-off-by: Stefan Majer <stefan.majer@gmail.com>
> 
> diff --git a/lib/bpf.c b/lib/bpf.c
> index 10cf9bf4..210830d9 100644
> --- a/lib/bpf.c
> +++ b/lib/bpf.c
> @@ -1416,8 +1416,8 @@ static void bpf_init_env(void)
>   .rlim_max = RLIM_INFINITY,
>   };
> 
> - /* Don't bother in case we fail! */
> - setrlimit(RLIMIT_MEMLOCK, &limit);
> + if (!setrlimit(RLIMIT_MEMLOCK, &limit))
> + fprintf(stderr, "Continue without setting ulimit memlock=infinity.
> Error:%s\n", strerror(errno));
> 
>   if (!bpf_get_work_dir(BPF_PROG_TYPE_UNSPEC))
>   fprintf(stderr, "Continuing without mounted eBPF fs. Too old kernel?\n");
> 

bpf_init_env is not called for 'ip vrf exec'.

Since other bpf code raises the limit it would be consistent for 'ip vrf
exec' to do the same. I know this limit has been a pain for some users.
