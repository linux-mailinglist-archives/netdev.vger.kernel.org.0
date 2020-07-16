Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE9A22286E
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729434AbgGPQjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728562AbgGPQju (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 12:39:50 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CED95C061755
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:39:49 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id c80so10902307wme.0
        for <netdev@vger.kernel.org>; Thu, 16 Jul 2020 09:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=20fCXzpt5xrhYy1Y13gD3+QE2NdQzEx5fXxgZJMqHMA=;
        b=JIrzFmjxrGCpRUvAIGa3w6dCDS62bwx4fatzmPS/Pt7KZFaI0QOOJDzfWVVK08ekI2
         +ojXZwqD0TRI4ODoR/ccLXEfhhmB8xT5HtiO1jQlMNwtHlZKQEDOIRTn1ycZClLTS7i9
         uDeY55drkgGr1wmDQx/hp2VI+UYjAm1rPaGMvnm5VaLcXFePDbEQsTg0z2zgYtFC1Ezu
         RAXvdmdUb45S9fBi6M7PWUAkw3GbB3E4eU+38/4SlCJqdPXJywxOBdCukz09j/oqXmL7
         vx6WCS/Kgmq7SCga6sV2c4Wu6sCUCCJHlrAIW6Vg/XscxG0Mf0qGE3jr/1EkEmh1bKBc
         9Njw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=20fCXzpt5xrhYy1Y13gD3+QE2NdQzEx5fXxgZJMqHMA=;
        b=Y1xOWIysr4dPIaTDIOUKGlxRlGaa4oyAFbPlVI0r3AuqUKJEBy56BJeSnor1I5b7tE
         wdk0RxiqbzqB/x8cycklIMip+iP6TdqwlUXwtu/SsCD1S3J3IPd/SZ531RqzOFRaVBsg
         7JD8YZTo6dy7DLlV+ZUqmPmD4FRWuAAjylGkqvYlHg55QnK9HsliCR0ZvvF2hbfADE+f
         w3ucM2NS6b3NX7AA9Iv1C7jzhZonklKh1a4E0su1/j7UlCUpQTs5gsyjm+uHgKGgrwWo
         lR4ySwYb5wyJyzzXedjopdadWN6G23BTRDbkq3RrhJQojEEJa2uQJKduI1jfd9z37dYX
         nyTw==
X-Gm-Message-State: AOAM531zW2RXg4FiGt25qpBM3AEKVrOCi1OBVCjtqpNsHKc9zDBQBUhB
        FfrpaYfoV9K1DF5BdYORgGMKqg==
X-Google-Smtp-Source: ABdhPJz4xSCI0ZITQq2yaFpHxbVW+beJsF/461Fz0KP7tEPiYoIYNhwY+BBGt/691TccxBy8mQDP+Q==
X-Received: by 2002:a1c:a7c4:: with SMTP id q187mr5025307wme.0.1594917588433;
        Thu, 16 Jul 2020 09:39:48 -0700 (PDT)
Received: from [192.168.1.12] ([194.35.117.51])
        by smtp.gmail.com with ESMTPSA id y20sm9228648wmi.8.2020.07.16.09.39.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2020 09:39:47 -0700 (PDT)
Subject: Re: [PATCH bpf-next 09/13] tools/bpftool: add bpftool support for bpf
 map element iterator
To:     Yonghong Song <yhs@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
References: <20200713161739.3076283-1-yhs@fb.com>
 <20200713161749.3077526-1-yhs@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <9f865c02-291c-8622-b601-f4613356a469@isovalent.com>
Date:   Thu, 16 Jul 2020 17:39:47 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200713161749.3077526-1-yhs@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-07-13 09:17 UTC-0700 ~ Yonghong Song <yhs@fb.com>
> The optional parameter "map MAP" can be added to "bpftool iter"
> command to create a bpf iterator for map elements. For example,
>   bpftool iter pin ./prog.o /sys/fs/bpf/p1 map id 333
> 
> For map element bpf iterator "map MAP" parameter is required.
> Otherwise, bpf link creation will return an error.
> 
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---
>  .../bpftool/Documentation/bpftool-iter.rst    | 16 ++++++++--
>  tools/bpf/bpftool/iter.c                      | 32 ++++++++++++++++---
>  2 files changed, 42 insertions(+), 6 deletions(-)
> 
> diff --git a/tools/bpf/bpftool/Documentation/bpftool-iter.rst b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
> index 8dce698eab79..53ee4fb188b4 100644
> --- a/tools/bpf/bpftool/Documentation/bpftool-iter.rst
> +++ b/tools/bpf/bpftool/Documentation/bpftool-iter.rst
> @@ -17,14 +17,15 @@ SYNOPSIS
>  ITER COMMANDS
>  ===================
>  
> -|	**bpftool** **iter pin** *OBJ* *PATH*
> +|	**bpftool** **iter pin** *OBJ* *PATH* [**map** *MAP*]
>  |	**bpftool** **iter help**
>  |
>  |	*OBJ* := /a/file/of/bpf_iter_target.o
> +|       *MAP* := { **id** *MAP_ID* | **pinned** *FILE* }

Please don't change the indentation style (other lines have a tab).

>  
>  DESCRIPTION
>  ===========
> -	**bpftool iter pin** *OBJ* *PATH*
> +	**bpftool iter pin** *OBJ* *PATH* [**map** *MAP*]
>  		  A bpf iterator combines a kernel iterating of
>  		  particular kernel data (e.g., tasks, bpf_maps, etc.)
>  		  and a bpf program called for each kernel data object
> @@ -37,6 +38,10 @@ DESCRIPTION
>  		  character ('.'), which is reserved for future extensions
>  		  of *bpffs*.
>  
> +                  Map element bpf iterator requires an additional parameter
> +                  *MAP* so bpf program can iterate over map elements for
> +                  that map.
> +

Same note on indentation.

Could you please also explain in a few words what the "Map element bpf
iterator" is? Reusing part of your cover letter (see below) could do,
it's just so that users not familiar with the concept can get an idea of
what it does.

---
User can have a bpf program in kernel to run with each map element,
do checking, filtering, aggregation, etc. without copying data
to user space.
---

>  		  User can then *cat PATH* to see the bpf iterator output.
>  
>  	**bpftool iter help**

[...]

> @@ -62,13 +83,16 @@ static int do_pin(int argc, char **argv)
>  	bpf_link__destroy(link);
>  close_obj:
>  	bpf_object__close(obj);
> +close_map_fd:
> +	if (map_fd >= 0)
> +		close(map_fd);
>  	return err;
>  }
>  
>  static int do_help(int argc, char **argv)
>  {
>  	fprintf(stderr,
> -		"Usage: %1$s %2$s pin OBJ PATH\n"
> +		"Usage: %1$s %2$s pin OBJ PATH [map MAP]\n"

You probably want to add HELP_SPEC_MAP (as in map.c) to tell the user
what MAP should be.

Could you please also update the bash completion?

Thanks,
Quentin
