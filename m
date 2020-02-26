Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5E581705EF
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 18:22:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726695AbgBZRWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 12:22:16 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:51320 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgBZRWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 12:22:15 -0500
Received: by mail-wm1-f66.google.com with SMTP id t23so97261wmi.1
        for <netdev@vger.kernel.org>; Wed, 26 Feb 2020 09:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bTX6ADjL8vd+1qplRyyAzTsyyfpkgH9hYlmjz7+N2Q0=;
        b=PbDPEOi+fj86MtC89e+Ab3x5aotS6IyLV5IACbabN9wT7k1i+NDmdFkVEiKkZEVWiq
         svt1s7hrVlk7WnONe38fPZEyIX4+X/gmiN7BLWqoiRLdBJmtui1AaEeBvs/CyRe2PqI+
         /dIE7j9fLxKG3TcHzGyrouk3FE2va6/P+wQF8wR8xq1SWuPn5Qvw7L/hAcPKNBncUIzv
         Gm9H5gu15hPIF1fv0VeAoue3GsLkCCam2NCQlP82I44waIzXmCDY9x8CkN4HE52PG5oP
         VfZxAJRjyfmW1YybszVGDjiwEo7zjU94JGvngRE6JfkFnAbiiNf8phyKIoH/IAMVdC6A
         Qcsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bTX6ADjL8vd+1qplRyyAzTsyyfpkgH9hYlmjz7+N2Q0=;
        b=cLxIjJUo3dg9qBy1W5RVqHE/oXe+P4GMMoFuwjy1gZeq9j8lNUncwmYYc+1EympBv7
         hxwSQtm/h97DIAoyCFYPITEfG+MhgkguYlnnM92k7XaGibkou7XvKdFfUJr6MASi/PGr
         GK3nMn6vNSmLKCNv3wEYTKlaObVoMnlY19HxhnSyLwAc4Vx5GcouxlU0LHoS4KvZ7iMi
         lc50CerT7ZiyLv69N1OCs5vsYPVBsR7S0U1BbDmPexgDeL8lMKWiLiuj2DYuju+Umke9
         0evt9EQv4GbnCENJxeeebMeLZKgIuwN5ZUOInXYIlyZ+0yyl97nsaeWtOAyiIIiO1iIW
         dlgA==
X-Gm-Message-State: APjAAAUnDY3teYjwnq7lLspakvDgWoQV2XkNuOv5q4obwsfX4pRSdHU1
        fz/e77E/3KfmkU6raM4DtttiYA==
X-Google-Smtp-Source: APXvYqzbcqZ95aNNDTCdQeIB3SiyudumgAQ9BSTiz9xzK+KHIy5xt/tjC1JqpGisnkeW7Z3obD/lzQ==
X-Received: by 2002:a7b:c935:: with SMTP id h21mr6401277wml.173.1582737733834;
        Wed, 26 Feb 2020 09:22:13 -0800 (PST)
Received: from [192.168.1.10] ([194.35.116.65])
        by smtp.gmail.com with ESMTPSA id u62sm3830555wmu.17.2020.02.26.09.22.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Feb 2020 09:22:13 -0800 (PST)
Subject: Re: [PATCH bpf-next v4 0/5] Make probes which emit dmesg warnings
 optional
To:     Michal Rostecki <mrostecki@opensuse.org>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
References: <20200226165941.6379-1-mrostecki@opensuse.org>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <e4777396-dbf0-855d-beaf-ba7fd533a4fb@isovalent.com>
Date:   Wed, 26 Feb 2020 17:22:12 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200226165941.6379-1-mrostecki@opensuse.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-26 17:59 UTC+0100 ~ Michal Rostecki <mrostecki@opensuse.org>
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
> v3 -> v4:
> - Use enum to check for helper functions.
> - Make selftests compatible with older versions of Python 3.x than 3.7.
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
>   tools/testing/selftests/bpf/test_bpftool.py   | 178 +++++++++++
>   tools/testing/selftests/bpf/test_bpftool.sh   |   5 +
>   7 files changed, 373 insertions(+), 123 deletions(-)
>   create mode 100644 tools/testing/selftests/bpf/test_bpftool.py
>   create mode 100755 tools/testing/selftests/bpf/test_bpftool.sh
> 

Reviewed-by: Quentin Monnet <quentin@isovalent.com>
(Please keep tags between versions.)

Your change looks good. The tests in patch 5 still pass with Python 
3.7.5 (but I have not tried to run with an older version of Python).

Quentin
