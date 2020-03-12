Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A21182F85
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 12:46:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbgCLLqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 07:46:30 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:38326 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbgCLLq3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 07:46:29 -0400
Received: by mail-wr1-f67.google.com with SMTP id x11so2260962wrv.5
        for <netdev@vger.kernel.org>; Thu, 12 Mar 2020 04:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=inDMtYNsCPgtsoeJuXt25fIlas+Z9MXxfdx1yN6Wg68=;
        b=cQipXksQQTUGXw9jSh3RQsTUzScRdBgJf3JOC0nmBVxnMThl9G8MB5Ea4iVj2qam7X
         z0dHRM/c2adwFXW7bpNpuCjbLTVkxJX8y7TJ0atUqRvZdCelweVNJfe06G/3aQ5la991
         zBY1Cv7okdypjy663mt4fLC4Ya/o3cr8s5vK3UaK9QrsUoKpI8jx8MHbouns+kGZ6CIT
         SUDxOHMYjJulQwNxdOYbQaYGTSKeClWSiDFpeqQvG9IMH5pgDRyKTHXfSzEqcmZtECwq
         XhLlhjrKF2KedfTTCFadDf+gK31jJErjaNMwrxXMopazIu5B+lGX1xR/j2g6slUUX8/h
         RCUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=inDMtYNsCPgtsoeJuXt25fIlas+Z9MXxfdx1yN6Wg68=;
        b=VKY4decX/v6XFVvkSOqCSqIKptloEgjG6jVzwO9heLPKzHwm7oj3suLOfjyFzyLZI2
         7TrxzvuWSDrF+DOEmr07EWDtpF0fWrVrWpXw94Msv9UEnxnv1nPGTbnqeQ4DorC4T1RJ
         YHOv/ybdZzx5Uwt0aV5c+1E0sFIuQeOzPzOkREtXP2wnuEKuDPtHbXyS8suFJIUtuD04
         tZ0/NqWcUL01B5MpJCSskbWaKFsxwBfL8RYRPPzJNv2cicWNIJaPkQ1iAgv2ouqTb+K/
         0ZiS6i8CKWeq+oc1UXlEOmk0FnXK07/+PlSWjXrF6juxrJSstd3A0Q3bamS/uCxRmXmD
         23Rw==
X-Gm-Message-State: ANhLgQ2T8qBIkmnLOWbfB5tWmt6qa6FTUXjmP5E7aDCOBrdwd94DcFax
        PwKSdeVPYG7KBzfB2/UTzGEkjw==
X-Google-Smtp-Source: ADFU+vtPMbwWSzcprz2nw2IMfY/wjhAN16hme2jtbMi+q04V+T3u0M81RM5r9YTmeaBPdBBmqmAlOQ==
X-Received: by 2002:adf:ecca:: with SMTP id s10mr11019797wro.255.1584013587896;
        Thu, 12 Mar 2020 04:46:27 -0700 (PDT)
Received: from [192.168.1.10] ([194.35.118.177])
        by smtp.gmail.com with ESMTPSA id f15sm12164113wmj.25.2020.03.12.04.46.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2020 04:46:27 -0700 (PDT)
Subject: Re: [PATCH v2 bpf-next 1/3] bpftool: only build bpftool-prog-profile
 if supported by clang
To:     Song Liu <songliubraving@fb.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     john.fastabend@gmail.com, kernel-team@fb.com, ast@kernel.org,
        daniel@iogearbox.net, arnaldo.melo@gmail.com, jolsa@kernel.org
References: <20200311221844.3089820-1-songliubraving@fb.com>
 <20200311221844.3089820-2-songliubraving@fb.com>
From:   Quentin Monnet <quentin@isovalent.com>
Message-ID: <50a4f620-c9ad-d17f-07ee-d7c901cb76ed@isovalent.com>
Date:   Thu, 12 Mar 2020 11:46:24 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200311221844.3089820-2-songliubraving@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-03-11 15:18 UTC-0700 ~ Song Liu <songliubraving@fb.com>
> bpftoo-prog-profile requires clang to generate BTF for global variables.

Typo: bpftool (missing "l")

> When compared with older clang, skip this command. This is achieved by
> adding a new feature, clang-bpf-global-var, to tools/build/feature.
> 
> Signed-off-by: Song Liu <songliubraving@fb.com>

Works great when clang is either too old or missing, thanks!

> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 576ddd82bc96..03b1979dfad8 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1545,6 +1545,8 @@ static int do_loadall(int argc, char **argv)
>  
>  static int do_profile(int argc, char **argv)
>  {
> +	fprintf(stdout, "bpftool prog profile command is not supported.\n"
> +		"Please build bpftool with clang >= 10.0.0\n");

Nit: Can we use p_err() instead of fprintf(), and a single-line error
message please? To remain consistent and work with JSON output.

Thanks,
Quentin
