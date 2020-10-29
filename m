Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EA0329F64B
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 21:39:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgJ2UjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 16:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726464AbgJ2UiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 16:38:24 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1188C0613D4;
        Thu, 29 Oct 2020 13:38:23 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id z7so1409732ybg.10;
        Thu, 29 Oct 2020 13:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4ZLqZ1ZWh2hC4KIJReQI+w6LC8VHRNivLhuGXbN8Uvk=;
        b=Dj8j/mFJMCskYFHPmAPSmYj0atVO2mjq9+OG/5c8j3zFabXIHDcGfTeN0PXptLS//7
         Rd2c5oOoPpb7Y+kCBv+MsCYuRVk/RuN+S8Y1rw0a2xvLmrkqfkTSYz/ArdWCgx5Fp0M0
         A/L/psot8a6uSuVjjfJoFwnbcpXvjPXoxZOGPsJyDQCmCISE5iXWVOtjnG+ZZzAiM5g7
         b1D7Mf+I68hWkdxLMUCX3JXXY6DaKLWO6/qiYYwYZPM2S2xsB7wJTXfEMjVv2sWkV8gt
         NXt1EzhfaVeGm4JN656QJqSTlw+NXOb0C0qJ5YhOtzAqHvlJk7Wxs556w44SDS9c6Frl
         OoEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4ZLqZ1ZWh2hC4KIJReQI+w6LC8VHRNivLhuGXbN8Uvk=;
        b=SVfX6vK/TbuWSFC7O1E+hiyS4+KtT01o9hZerRAlbfBJcXtYIe2x9152JhKC5y5rQ/
         0+RzxslstEM+aZbgi4wWB3jAPufrivhzCiLcyZJwtesSrNp4FpLQaRmR38CNOZW/OIOm
         V4DSxBGtB1KqBpv05lp+9Wm/NcX38l4J0Z5RUvivjnaxto3M7tUhrW6ilJW6flVZ0tDK
         pFsD9jAsQmpYWILfHDPSOgOdoXCaKajhUE6SZMuUtDuQU9MfjtwCDRDu9KfnkByeG4Ol
         KcCYlwAebadRU9jKGiiHQXmJEYScoye1UVjvuDSdNpKb0iMZTqRSBl6h7kiJz+N2G5ii
         cGcQ==
X-Gm-Message-State: AOAM531mH9VqtNTZkhwT+oFd9pyv9msWEnf9//K2LNef0CjEOtOs2Hwg
        qRdtykIl23apou9G4JDJrNFSVc+RDowUxIej+u7EzWQymV6ZKg==
X-Google-Smtp-Source: ABdhPJxYcg6+OIv+1IZ+Zbdxpi+7zsFfTOg3MTlqeooTE7WKGNS6+JTTjO1udCbihzJziHlOE0U8863qNSyr3y5pR7c=
X-Received: by 2002:a25:b0d:: with SMTP id 13mr8674236ybl.347.1604003902999;
 Thu, 29 Oct 2020 13:38:22 -0700 (PDT)
MIME-Version: 1.0
References: <20201029201442.596690-1-dev@der-flo.net>
In-Reply-To: <20201029201442.596690-1-dev@der-flo.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Oct 2020 13:38:12 -0700
Message-ID: <CAEf4BzaR8D1tHSN+s4xjqdHc1ScL_O13E7fsyYgsD=Cj8vohmQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5] bpf: Lift hashtab key_size limit
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 29, 2020 at 1:16 PM Florian Lehner <dev@der-flo.net> wrote:
>
> Currently key_size of hashtab is limited to MAX_BPF_STACK.
> As the key of hashtab can also be a value from a per cpu map it can be
> larger than MAX_BPF_STACK.
>
> The use-case for this patch originates to implement allow/disallow
> lists for files and file paths. The maximum length of file paths is
> defined by PATH_MAX with 4096 chars including nul.
> This limit exceeds MAX_BPF_STACK.
>
> Changelog:
>
> v5:
>  - Fix cast overflow
>
> v4:
>  - Utilize BPF skeleton in tests
>  - Rebase
>
> v3:
>  - Rebase
>
> v2:
>  - Add a test for bpf side
>
> Signed-off-by: Florian Lehner <dev@der-flo.net>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---

LGTM.
Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/hashtab.c                          | 16 +++----
>  .../selftests/bpf/prog_tests/hash_large_key.c | 43 ++++++++++++++++++
>  .../selftests/bpf/progs/test_hash_large_key.c | 44 +++++++++++++++++++
>  tools/testing/selftests/bpf/test_maps.c       |  3 +-
>  4 files changed, 94 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c
>

[...]
