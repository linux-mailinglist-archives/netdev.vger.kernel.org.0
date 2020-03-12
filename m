Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E19C1838B2
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgCLS3c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 14:29:32 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:34999 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgCLS3a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 14:29:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id d5so8449337wrc.2
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 11:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BRHCWhmFlQPURHq+pBoLkGTysC+hecjyJW1t2JsHSNo=;
        b=0F+83U6vTNMbdxCfzp+9BGDCgJ+jfRfz+fpPiZtdHECW9DgBIRQvXb3oigJ2D5OBnD
         AFjjkcURKEUON/mmfIg6jBuYe/v0dMKdsCrzmssotT49QQ5xatloFHcHsrmNNzxpAQPp
         4/Aw5sXbxlKLvslU+ZRqkszwZEI1ZALuxx/qeILfrZgvWUt/NYAo0pZkASqJV5cIrdwr
         nUx84v5gVJMNbF+kpHQUX4zYy1WgZKHy8ssIPsTB5wxIkjkii+z2iO2fL0Duj+yvyL88
         zF80qSys1rAKitNELa5z08LXsV3Hr6VvWDtLk5KOI5Rb7uwyiz+l2h76AQopCRjAe3yh
         8H3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BRHCWhmFlQPURHq+pBoLkGTysC+hecjyJW1t2JsHSNo=;
        b=KIABSmvtIU8HE4As3U8tzvAMSJ6m6i3u5uzUk1Hv3BSq5Oz0vUrUv+mnfNGxsh3PF8
         t8uRp+aY6HiY3VQ1MN5MTpCCUBoEnEXwBBPVRn2ZutHpWz8GM/cXokuxsY0gQiWyuh5q
         HnSbqlYqcKy1GaKEXGx+idmRtPobk/Ir7yH7hss583tjLfg/KIHcwnPOISgx6MO1DtAj
         t+wLytoawfGXG2gmEPJR+9WAJYqzTr7jSr+WodDclEf3dLLo1K5qjB+VnN5HMb9dPss3
         S0GqwQNs+useJjshPacIJeh5vV65uaIuf/naTcRGpAGT6VadjLXLCMNYSbMIPjA+39C7
         P7JQ==
X-Gm-Message-State: ANhLgQ3s891LZIg0cDcgsTppu7ysE1K1vwhVBHqc96/i6BjsXJsVw+cP
        tNK/UAHuJqanJb0C7CTV4dcGGQ==
X-Google-Smtp-Source: ADFU+vvnu5jhezFpKMT+q/UzwIwyGAsFngjVM2cWS8rR8k8ojNctNy1ZNn6SEm0BEXqVT+ko0vT/yQ==
X-Received: by 2002:a5d:52d0:: with SMTP id r16mr11893374wrv.379.1584037767514;
        Thu, 12 Mar 2020 11:29:27 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id e22sm13237842wme.45.2020.03.12.11.29.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 11:29:27 -0700 (PDT)
Subject: Re: [PATCH v3 bpf-next 0/3] Fixes for bpftool-prog-profile
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     john.fastabend@gmail.com, kernel-team@fb.com, ast@kernel.org,
        daniel@iogearbox.net, arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200312182332.3953408-1-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <461f01a8-1506-97c9-11db-4f1f1bad092b@isovalent.com>
Date:   Thu, 12 Mar 2020 18:29:26 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200312182332.3953408-1-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-12 11:23 UTC-0700 ~ Song Liu <songliubraving@fb.com>
> 1. Fix build for older clang;
> 2. Fix skeleton's dependency on libbpf;
> 3. Add files to .gitignore.
> 
> Changes v2 => v3:
> 1. Add -I$(LIBBPF_PATH) to Makefile (Quentin);
> 2. Use p_err() for error message (Quentin).
> 
> Changes v1 => v2:
> 1. Rewrite patch 1 with real feature detection (Quentin, Alexei).
> 2. Add files to .gitignore (Andrii).
> 
> Song Liu (3):
>   bpftool: only build bpftool-prog-profile if supported by clang
>   bpftool: skeleton should depend on libbpf
>   bpftool: add _bpftool and profiler.skel.h to .gitignore
> 
>  tools/bpf/bpftool/.gitignore                  |  2 ++
>  tools/bpf/bpftool/Makefile                    | 20 +++++++++++++------
>  tools/bpf/bpftool/prog.c                      |  1 +
>  tools/build/feature/Makefile                  |  9 ++++++++-
>  .../build/feature/test-clang-bpf-global-var.c |  4 ++++
>  5 files changed, 29 insertions(+), 7 deletions(-)
>  create mode 100644 tools/build/feature/test-clang-bpf-global-var.c
> 
> --
> 2.17.1
> 

Series looks great, thank you!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
