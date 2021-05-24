Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F4A38E10E
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 08:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhEXGiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 02:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232120AbhEXGiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 02:38:10 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE4DAC061574;
        Sun, 23 May 2021 23:36:41 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e10so22394171ilu.11;
        Sun, 23 May 2021 23:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gsEPpc50kiPdBX//NG4sB7Isvj881VgBN2NzqFt2mSI=;
        b=cE9gKAq96PReZEznrdnqgCdpYE46rMrKQUWCgJjmInoXpM6hzuXaJk2JqOQ+KOThjE
         KkKk0aFZvXwd9SDV/CwJm4+kOBwwEvq8y4Fv91uRd1SBi1OcIe76ZEilT5UjlLeIbV3q
         /m7Ot5t65Uf/qkrztcIB9vXelRGwMoqNPSkAu/nTKywbRN6TXv/QLEx4l0fnPtG9x6y7
         RdvvlIOauoffIvoRtNsy6UspekuWN6IPev5uDhmG7qMOha5BhuTJui2d+P/TF7tGg8yp
         WD4fEJfMcqBE9AbiHFmAWStMHIuEdiR3UDgOutcp4akwUKARGYa92m6jIFzeT9GKtDxZ
         i9rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gsEPpc50kiPdBX//NG4sB7Isvj881VgBN2NzqFt2mSI=;
        b=UjHtwSiYtaRRZzoYXSyFaycmPxvkdv48zEyMQZS4FVaE2esxwj0vfuzQBnB86CkDQL
         G4meNWlnj61jTaDqqK3jZHsnFckYgdF6Bpw+2fTUEwQhSIY+WNpnkWR6Qyj2IUpq6Jtk
         pI0RQWBdZ9G7Ma2N7G00AZIkw5ByZN7NCEe37ouIkGPgnRCKhsJuxed2KJl+8jMZLJyi
         2/fktgCjxTg4VXsg2WOdvK3JV6wfxvMi7xcQCHYDP5UGds2VcacOG3nT/is7y/MrYf0y
         R5mdQ/oitE5NHXl0JtDGJY8t4fv2lpPqaTEs/v60sK7Lo+bdOCWZWTgzxMp7l9Ztzb4x
         A5NA==
X-Gm-Message-State: AOAM530vTGAvBG0LHPtWTJELkfkUkGy2Uu/fEnJqwZ73frUfkUdFwjCG
        usl5iF1BogxVZLNXsdJTgvw=
X-Google-Smtp-Source: ABdhPJxLAbzjrWDQHkbpEMPY4+UWyFD20pWd3zt5tJ5Iku+NZPgWMpz5Y5NW7IOQfuipEBqA9Zvjig==
X-Received: by 2002:a05:6e02:490:: with SMTP id b16mr15275273ils.213.1621838201159;
        Sun, 23 May 2021 23:36:41 -0700 (PDT)
Received: from localhost ([172.242.244.146])
        by smtp.gmail.com with ESMTPSA id h16sm10778725ilr.56.2021.05.23.23.36.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 23:36:40 -0700 (PDT)
Date:   Sun, 23 May 2021 23:36:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com
Message-ID: <60ab496e3e211_2a2cf208d2@john-XPS-13-9370.notmuch>
In-Reply-To: <20210521234203.1283033-1-andrii@kernel.org>
References: <20210521234203.1283033-1-andrii@kernel.org>
Subject: RE: [PATCH bpf-next 0/5] libbpf: error reporting changes for v1.0
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Implement error reporting changes discussed in "Libbpf: the road to v1.0"
> ([0]) document.
> 
> Libbpf gets a new API, libbpf_set_strict_mode() which accepts a set of flags
> that turn on a set of libbpf 1.0 changes, that might be potentially breaking.
> It's possible to opt-in into all current and future 1.0 features by specifying
> LIBBPF_STRICT_ALL flag.
> 
> When some of the 1.0 "features" are requested, libbpf APIs might behave
> differently. In this patch set a first set of changes are implemented, all
> related to the way libbpf returns errors. See individual patches for details.
> 
> Patch #1 adds a no-op libbpf_set_strict_mode() functionality to enable
> updating selftests.
> 
> Patch #2 gets rid of all the bad code patterns that will break in libbpf 1.0
> (exact -1 comparison for low-level APIs, direct IS_ERR() macro usage to check
> pointer-returning APIs for error, etc). These changes make selftest work in
> both legacy and 1.0 libbpf modes. Selftests also opt-in into 100% libbpf 1.0
> mode to automatically gain all the subsequent changes, which will come in
> follow up patches.
> 
> Patch #3 streamlines error reporting for low-level APIs wrapping bpf() syscall.
> 
> Patch #4 streamlines errors for all the rest APIs.
> 
> Patch #5 ensures that BPF skeletons propagate errors properly as well, as
> currently on error some APIs will return NULL with no way of checking exact
> error code.
> 
>   [0] https://docs.google.com/document/d/1UyjTZuPFWiPFyKk1tV5an11_iaRuec6U-ZESZ54nNTY
> 
> Andrii Nakryiko (5):
>   libbpf: add libbpf_set_strict_mode() API to turn on libbpf 1.0
>     behaviors
>   selftests/bpf: turn on libbpf 1.0 mode and fix all IS_ERR checks
>   libbpf: streamline error reporting for low-level APIs
>   libbpf: streamline error reporting for high-level APIs
>   bpftool: set errno on skeleton failures and propagate errors
> 

LGTM for the series,

Acked-by: John Fastabend <john.fastabend@gmail.com>
