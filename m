Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58C6E354C2E
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 07:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbhDFFOy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 01:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242601AbhDFFOw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 01:14:52 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCE94C061574;
        Mon,  5 Apr 2021 22:14:44 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id 6so2350745ilt.9;
        Mon, 05 Apr 2021 22:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:message-id:in-reply-to:references:subject:mime-version
         :content-transfer-encoding;
        bh=SevySIBPYqz+GGUbC4xMDqR9S4bpUfdhFldX1XZVVFg=;
        b=Soy3X6XYJK6XGQA+cSTakoSKz/kobK+OetawsmdgeHBQ0DZbCtPelupJqctCI+LZYa
         oqXSD3pcGKL0NGf0qXQ+Hidjb2JYJKQX8wojP5eSsPanXEeNb6OhqdBwLMYJVv3i/e8F
         JjgERFFfc+UxX3QarvSV2NAFjYdwSDlwhssjPmSglmjUx1G1nMJFtkhPqTK2u82Dlm3f
         Pf8Geu/LgNwLsSQtYV6Uv8YdNvnGVJKg6lEP3QOkXN1JsLNfO0rhjpzzjVB4qrcUbVPT
         q0z5d4MzLJmchjS0+MkcP2EI2KmFsZa2jkIjTXbI8Tu/ORNEW7M4FznkPOIv+lWYGgr9
         neIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:message-id:in-reply-to:references
         :subject:mime-version:content-transfer-encoding;
        bh=SevySIBPYqz+GGUbC4xMDqR9S4bpUfdhFldX1XZVVFg=;
        b=tPv5BrgcleHdaI257dGRCkRQ/vcyI0XawYc8max5pifF1ZTlcQp7zmOFXUBmhyoI+o
         RSottDHzHfzp/iqoo1iKrs5UuqDT4OOoaFGdXrReRKlLJoftbf6EJZdflmjj/MttHQCl
         spI6ANusloznfRm3tfhDQ63p6w1OtQVArKkjv790SGq1UsJWwBzc9VhpgSR7YkyeQHCD
         5fkEVktq84jjmGMflMabY1L+WBKiybmOF2XgBgBkctb0xQha9Zhx2GPRpX0y/j6fLZ6C
         5poVGzvcPsRg7lDjWywnjUnWY0EFd4ifHVIOTsJZBA4AWVsPC2neLouC+4y0xlrbOT8s
         ZeFQ==
X-Gm-Message-State: AOAM532LDnPqgPoE3MknlqktK9Jx2XbVmvmX/l2ry9Xxu5NJBm3IA/dB
        i+HGKdonfmcpZw/ttul3x7Y=
X-Google-Smtp-Source: ABdhPJz6m6NHq0EJQDxo5EVdbsgQDjUA3ihC3p90SsyoLwUXIOb4Td00ohl5d/B3wLM9No3cwLsjeQ==
X-Received: by 2002:a05:6e02:174d:: with SMTP id y13mr3092347ill.83.1617686084204;
        Mon, 05 Apr 2021 22:14:44 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id o13sm13014914iob.17.2021.04.05.22.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Apr 2021 22:14:43 -0700 (PDT)
Date:   Mon, 05 Apr 2021 22:14:37 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Pedro Tammela <pctammela@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Pedro Tammela <pctammela@mojatatu.com>,
        David Verbeiren <david.verbeiren@tessares.net>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        "(open list:BPF \\(Safe dynamic programs and tools\\))" 
        <netdev@vger.kernel.org>,
        bpf@vger.kernel.org (open list:BPF \(Safe dynamic programs and tools\)),
        "(open list:BPF \\(Safe dynamic programs and tools\\) open list)" 
        <linux-kernel@vger.kernel.org>,
        "(open list:BPF \\(Safe dynamic programs and tools\\) open list open
        list:KERNEL SELFTEST FRAMEWORK)" <linux-kselftest@vger.kernel.org> (open
        list:BPF \(Safe dynamic programs and tools\) open list open list:KERNEL
        SELFTEST FRAMEWORK)
Message-ID: <606bee3dd51_d4646208fe@john-XPS-13-9370.notmuch>
In-Reply-To: <20210404200256.300532-3-pctammela@mojatatu.com>
References: <20210404200256.300532-1-pctammela@mojatatu.com>
 <20210404200256.300532-3-pctammela@mojatatu.com>
Subject: RE: [PATCH bpf-next 2/3] libbpf: selftests: refactor
 'BPF_PERCPU_TYPE()' and 'bpf_percpu()' macros
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pedro Tammela wrote:
> This macro was refactored out of the bpf selftests.
> 
> Since percpu values are rounded up to '8' in the kernel, a careless
> user in userspace might encounter unexpected values when parsing the
> output of the batched operations.
> 
> Now that both array and hash maps have support for batched ops in the
> percpu variant, let's provide a convenient macro to declare percpu map
> value types.
> 
> Updates the tests to a "reference" usage of the new macro.
> 
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---

Other than the initial patch needing a bit of description the series
looks good to me. Thanks.
