Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22F6116FD48
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 12:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728444AbgBZLRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 06:17:30 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:51974 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728168AbgBZLRZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 06:17:25 -0500
Received: by mail-wm1-f68.google.com with SMTP id t23so2585251wmi.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 03:17:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+aewCnTNGy8KuaeqGtx90I+oSQVy+5V29tI+27/JzTo=;
        b=D5KgMuEPCN514AD3a5eUqIdkkIe9aHOLwMX6eisi+8vWMQ0Q9l1ABDAfIarIU4NYB6
         eXITWDgzdZfGC3ZR0IQEPGVoxAnxUz1vT/7GOL15j+LoJ35Q2LEN71Ur1L7YFU27N7j6
         EJPAYGERRcDA5KwHBW6XyhINrXF065mGb1Cr/AQ5TyqasNZ2cn/QcWAVikJ376p31Ics
         k38acqY8gYslHMQQGC8Wi76z0cPYrTllrdyNy+yYlHweSdTSZm/MOOh67ABJxyqn94M3
         YHZh+GwcuETQL9VvFi877MPKW77tiCglJqe7F9BP0oo4F/Nq+6AKpBaHxmWiCHXArTjU
         0K4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+aewCnTNGy8KuaeqGtx90I+oSQVy+5V29tI+27/JzTo=;
        b=njhqMg/O0dWiCpUtV7NzlMBiQ2Cc6FhuivQ4B4kNd+OiSZZr/hBKtgP2v4OIDiC6vM
         R4wGlPbSNIhHYK34YDypXChiFW+FZ7xGk3NeMOCELZ1Re2vlIXlJJVgtrQymuCwNXrYd
         iSeXrpwwMDeUHH1y7R5QOJOKppeVEMEaSDIZGnkLfKU5SEMuRTBDr+boHxpl0LjNpkjs
         iCOFAfhRpvMzn5vcqZMZGl4fanTwrGjt185VnnOpY8u6KaOKRN58cYOJbvs1DgMIAltw
         trDvRaDvhY9mX/jkGYKm4f+Y06zR7UkMrejp7vl+aJVqpNWdrfnzMtNj9JjIrMY07ix0
         alzg==
X-Gm-Message-State: APjAAAUMMPfbdPz0Z2JZOVfvKoqetAjl7NoVX1mpe2m43cHCPravRSc8
        3/WzzXGLWJ4rPStb58FZvYLq2A==
X-Google-Smtp-Source: APXvYqwW7X83G2uoPsVuS+xc1lYqGj2pts2NmdFwwGGKVZzwiMOH6f6iH/O7vNJglR+Cr+Y7yAqBPw==
X-Received: by 2002:a1c:6308:: with SMTP id x8mr5118270wmb.80.1582715843459;
        Wed, 26 Feb 2020 03:17:23 -0800 (PST)
Received: from [192.168.1.10] ([194.35.116.65])
        by smtp.gmail.com with ESMTPSA id o27sm2828658wro.27.2020.02.26.03.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 03:17:22 -0800 (PST)
Subject: Re: [PATCH bpf-next v3 0/5] bpftool: Make probes which emit dmesg
 warnings optional
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20200225194446.20651-1-mrostecki@opensuse.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <e4929660-21ff-e394-37a0-d72b67a3770a@isovalent.com>
Date:   Wed, 26 Feb 2020 11:17:21 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225194446.20651-1-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-25 20:44 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
> Feature probes in bpftool related to bpf_probe_write_user and
> bpf_trace_printk helpers emit dmesg warnings which might be confusing
> for people running bpftool on production environments. This patch series
> addresses that by filtering them out by default and introducing the new
> positional argument "full" which enables all available probes.
> 
> The main motivation behind those changes is ability the fact that some
> probes (for example those related to "trace" or "write_user" helpers)
> emit dmesg messages which might be confusing for people who are running
> on production environments. For details see the Cilium issue[0].
> 
> v1 -> v2:
> - Do not expose regex filters to users, keep filtering logic internal,
> expose only the "full" option for including probes which emit dmesg
> warnings.
> 
> v2 -> v3:
> - Do not use regex for filtering out probes, use function IDs directly.
> - Fix bash completion - in v2 only "prefix" was proposed after "macros",
>    "dev" and "kernel" were not.
> - Rephrase the man page paragraph, highlight helper function names.
> - Remove tests which parse the plain output of bpftool (except the
>    header/macros test), focus on testing JSON output instead.
> - Add test which compares the output with and without "full" option.
> 
> [0] https://github.com/cilium/cilium/issues/10048
> 
> Michal Rostecki (5):
>    bpftool: Move out sections to separate functions
>    bpftool: Make probes which emit dmesg warnings optional
>    bpftool: Update documentation of "bpftool feature" command
>    bpftool: Update bash completion for "bpftool feature" command
>    selftests/bpf: Add test for "bpftool feature" command
> 
>   .../bpftool/Documentation/bpftool-feature.rst |  19 +-
>   tools/bpf/bpftool/bash-completion/bpftool     |   3 +-
>   tools/bpf/bpftool/feature.c                   | 283 +++++++++++-------
>   tools/testing/selftests/.gitignore            |   5 +-
>   tools/testing/selftests/bpf/Makefile          |   3 +-
>   tools/testing/selftests/bpf/test_bpftool.py   | 179 +++++++++++
>   tools/testing/selftests/bpf/test_bpftool.sh   |   5 +
>   7 files changed, 374 insertions(+), 123 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
>   create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh
> 

This version looks good to me, thanks!

Reviewed-by: Quentin Monnet <quentin@isovalent.com>

(Please keep Acked-by/Reviewed-by tags between versions if there are no 
significant changes, here for patch 1.)

That's a lot of tests now that we don't have the regex and filtering is 
very straightforward, but it does not hurt. I checked and they all pass 
on my system.

Thanks,
Quentin
