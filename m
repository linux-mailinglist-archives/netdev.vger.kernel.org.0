Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C9A520FEB6
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 23:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730699AbgF3V0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 17:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730694AbgF3V0e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 17:26:34 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 138CBC061755;
        Tue, 30 Jun 2020 14:26:34 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 80so20159881qko.7;
        Tue, 30 Jun 2020 14:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u6QrfK0w5ybbH9fi34xXU8b52YrlyrA/11EhFWPjHcY=;
        b=CqI5q8x8tEfzpcgQJRXsrlzwKqVx+wSi8n79eup4ry7b6IboG8x3Mo5ta+oAtr6eao
         1am7Wn0i/Uv0SJ6VTpa5eBmBnp+9xy/x+bEisQE5ZlhxVjJWCyOa4cDwY+hue3zb2+j5
         j+h6l6giCeAFx5TefdU1ML9TNV4SFpFD91ZvzwAxHPj2Gm2frJI+s+JacWMiAKVnNHVp
         OhoZhO5O6ui0V4njxE3Pg+SFDtt9Rpo5cKZZQ3UNYJRgXEdJW08Sx82AIQrZI7uouNUw
         sM1Vt2FerL4pXP5AQu6BVts9FOnYKboA+BPb8w2Ed3J7+aD5NlhNJRkvTxi9d/tLDKnk
         51Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=u6QrfK0w5ybbH9fi34xXU8b52YrlyrA/11EhFWPjHcY=;
        b=UI5tSun2jrcj88D91B5J+fXwmpgUmN4QPlAoVvU1yfoh6qojEXvIPeReH2VtywhZVA
         Y5zurzQBlj/4d6A3iJDMtefGhSrRF3hdwYcu8LqeA15Kt8R2pO2FAVVO5bxI0uaCnVN+
         +pBsgNmcV32++UiZRDLrHSK02IOA8RDvPz/00o5VNAXZz/yV6KdKhsoCV6A7GJXh/VX+
         c4o3xmTs66YJS9Bo3Wm8PsDPmsNk8D3QgqhnIhXQ4tTG/qBV/rcRlacXiCFfSkXS3hyr
         qIgbzoNymK0g3LJSrcwOBV7s7oPeROGJLqA7sOqvb1HP7fGBySDGh6QHAAaQUpIyZnft
         5Cdg==
X-Gm-Message-State: AOAM533fNLeFO3C1E+TGEqnfKYaajboPX3feKrQ0PuZYCnQq3EFdqrxU
        o8Me8C+ga3RtBMkSudhkKUNbgtrHu4mZJur83Zk=
X-Google-Smtp-Source: ABdhPJzNTMwPYp9iv+oRxOsQCp2yESwoibyek38j7BPYdMXfXDzKD6C5b60bb9+VFoBgf+eNaEiI78MjsxtvU5aRFpY=
X-Received: by 2002:a37:270e:: with SMTP id n14mr20807794qkn.92.1593552393299;
 Tue, 30 Jun 2020 14:26:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200630184922.455439-1-haoluo@google.com>
In-Reply-To: <20200630184922.455439-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 14:26:21 -0700
Message-ID: <CAEf4BzaH3TJWMsNHFPUTgEotErX0WS8R8ds1LYs6eXvLy1YbxQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Switch test_vmlinux to use hrtimer_range_start_ns.
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 1:47 PM Hao Luo <haoluo@google.com> wrote:
>
> The test_vmlinux test uses hrtimer_nanosleep as hook to test tracing
> programs. But it seems Clang may have done an aggressive optimization,
> causing fentry and kprobe to not hook on this function properly on a
> Clang build kernel.
>
> A possible fix is switching to use a more reliable function, e.g. the
> ones exported to kernel modules such as hrtimer_range_start_ns. After
> we switch to using hrtimer_range_start_ns, the test passes again even
> on a clang build kernel.
>
> Tested:
>  In a clang build kernel, the test fail even when the flags
>  {fentry, kprobe}_called are set unconditionally in handle__kprobe()
>  and handle__fentry(), which implies the programs do not hook on
>  hrtimer_nanosleep() properly. This could be because clang's code
>  transformation is too aggressive.
>
>  test_vmlinux:PASS:skel_open 0 nsec
>  test_vmlinux:PASS:skel_attach 0 nsec
>  test_vmlinux:PASS:tp 0 nsec
>  test_vmlinux:PASS:raw_tp 0 nsec
>  test_vmlinux:PASS:tp_btf 0 nsec
>  test_vmlinux:FAIL:kprobe not called
>  test_vmlinux:FAIL:fentry not called
>
>  After we switch to hrtimer_range_start_ns, the test passes.
>
>  test_vmlinux:PASS:skel_open 0 nsec
>  test_vmlinux:PASS:skel_attach 0 nsec
>  test_vmlinux:PASS:tp 0 nsec
>  test_vmlinux:PASS:raw_tp 0 nsec
>  test_vmlinux:PASS:tp_btf 0 nsec
>  test_vmlinux:PASS:kprobe 0 nsec
>  test_vmlinux:PASS:fentry 0 nsec
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

Took me a bit of jumping around to find how it is related to nanosleep
call :) But seems like it's unconditionally called, so should be fine.

Acked-by: Andrii Nakryiko <andriin@fb.com>


>  tools/testing/selftests/bpf/progs/test_vmlinux.c | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>

[...]
