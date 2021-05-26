Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3916390D7A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 02:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhEZAnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 20:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232578AbhEZAnr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 20:43:47 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6576C061574;
        Tue, 25 May 2021 17:42:15 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id t17so23816031ljd.9;
        Tue, 25 May 2021 17:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+piT8Fdohb0iFmmBUD57ZYS5Ltu/okIMiqp6KzJEJo=;
        b=P/ic7B9r6UgOVcG7esQgBalb0Bf0ergjXeiaWtFki47z05gtDzUF1oh7JtQl7HiDnx
         n6PUjUAqVquyhDBSovTvs7ejQ2x3FhhqqS454nCk3rR6xulPOisbwZ1Jufs6PhdoX9xJ
         qOqmT9OFsEekoKOMHpLQrchKNqWWfVwx4p0US8hsPyxdUEPgdelmdqOf3aUu10E35+Mu
         kzvZmahzULMJ0onjDpRtu6may7qePJ7Ii7g2Bkc3DjSgKELp1eoEU81INAWGS0Bv5kPQ
         UOhnclv7X/PanBWbRb+ac8q+FyM/2Kva9S2nrezNTzmPicmgomt2W+tj3gIgH5vyJnoB
         Li/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u+piT8Fdohb0iFmmBUD57ZYS5Ltu/okIMiqp6KzJEJo=;
        b=BKCMNt9I1P4RaQQ7clAriVzFY6Lo6wD2W6pxUMXtdBVhhLydobegykoL4Wb5ytcQQS
         qLf5A44W3puI/zupbaqklaJJ/nebINuNgDw1yxuCpAU1d6US73103sJkfO+QcD8W6547
         mLdAzRKYhdyhM/kPpb8txZ+c0S6/ksoD0xEheDhp/L3SX28QuJUK+XWFWMr7FLpz6ruP
         5Sw9rjawaeA7oQQ+wCpdO+AhXKH8fwzinunbnDqKPHuTjudx60XbwN5wyCq+XU0Xsoph
         tZkKrD0y9TSh2a2hZQLIDn0XuQvLWTKZy+OI92TJfBJi8ZEWUFZ4YtJoOHpGQb4Bmmqa
         m50A==
X-Gm-Message-State: AOAM531cPgCZ1ouvLZDqvo5v5L7RM5aUpGFMXNxAsUOgqfbqdDE8cpm3
        drBfd8gUiNMnfxojgjPgJSA1pUzjRtbtV/4g9Yw=
X-Google-Smtp-Source: ABdhPJxZnXX5q9JxC5axIiMAGHrfPGw/aV4Mu3UFWMevH7Ns3s6kUmpbK7CcaewWL9L3SE0kfcY0Mxmmq41FgE3hoQU=
X-Received: by 2002:a2e:575d:: with SMTP id r29mr210668ljd.32.1621989734077;
 Tue, 25 May 2021 17:42:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210525035935.1461796-1-andrii@kernel.org>
In-Reply-To: <20210525035935.1461796-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 May 2021 17:42:00 -0700
Message-ID: <CAADnVQJbUQGqPVWJEHO2tdSF99qWzGrBTzW9_AsLP0=sGeE3pQ@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/5] libbpf: error reporting changes for v1.0
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 24, 2021 at 9:04 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
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
> v1->v2:
>   - move libbpf_set_strict_mode() implementation to patch #1, where it belongs
>     (Alexei);
>   - add acks, slight rewording of commit messages.

Applied. Thanks
