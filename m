Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1776A485F52
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 04:46:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231165AbiAFDqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 22:46:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiAFDqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 22:46:05 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70387C061245;
        Wed,  5 Jan 2022 19:46:05 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id x15so1119079ilc.5;
        Wed, 05 Jan 2022 19:46:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3gV3xZ2h/EE4U6Pp/2sO2sTK0mMF/xknIRpxJ9B4orY=;
        b=N75pw4f2fQeOV6BaLGZbQ/QG90Egzu/xYD3Nas9/uNy5gURoGxtFY/hrBLR1sahETe
         jbv/jZwMEYAKQv2kMvHSQZLbaV9ILEnhTp1N2+eDG+LsZacGlPslL/PLtzb8ktaiBBT/
         XrKkaSYBDr0+hCme4c+pn5YsA8QvmNSDO/NmW9yWpwsshzCrwGa5rfOlKQ6ymP0N0DFU
         Aw3HHw0uNysmT9VsHByYXe/pmsUDGUYcDE/dMFxB8+drQEzAiN4/Dlgg82F9kTORQsAP
         cZgP2kebSxrecHJh3+Cd2S7TfUM/P7FqnQ82OvW6a/VIOWgf5lr0teBVIHeAJNDqRxOP
         Oa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3gV3xZ2h/EE4U6Pp/2sO2sTK0mMF/xknIRpxJ9B4orY=;
        b=nQXgCmdZnfRva38gGzXwTidhx9UfTAHJPPZEelImffKcfbqe3FV73RXBmkPyDiP2mj
         HcrH7MLP9Lxs8Kzk9/ixnzkpXmTuElPAub5L/0yteQlPh2RjawmaVvUXh6CxC/5tduIv
         HPHeGLvzgZtS2GCEip7D9/7bI/PRk6b2cCwk0Dqru0y5ob3I3ridxIaK5iK+cRKLXC1V
         HH4V27mu9XCBS5NyWFFfiq2R7l4ZlvABWQudF/BjprsnVV9x5nTOHTd7Jqssdo1o7TA9
         DYcgYHRQIPNtcII7z428FdXe7fDVNNpkZJumYx4qq8UQ7x7uRuC30A9X9rQkHswDZOIi
         FRlg==
X-Gm-Message-State: AOAM530Li+dEC7twuopTB4M6bKmr+DW/o3a69mqStVza9mhqvCM/jd1T
        dHb9Iem3FozpRN7+VMq9rbeecq9XmD0f55jSF6X2uLAA
X-Google-Smtp-Source: ABdhPJynxqvMBai3T5C2S21CJWj6eleJmvpAtHMF2HeCRtIBcT8QGMI7jgK2GV1djEpPYNpn2GXDjOgoxtXQOF92QR8=
X-Received: by 2002:a05:6e02:1c01:: with SMTP id l1mr27742076ilh.239.1641440764892;
 Wed, 05 Jan 2022 19:46:04 -0800 (PST)
MIME-Version: 1.0
References: <20211231075607.94752-1-saeed@kernel.org> <8cf93086-4990-f14a-3271-92bc2ee0519e@iogearbox.net>
 <20220105221419.tlp4lp2h5ttvssuh@sx1>
In-Reply-To: <20220105221419.tlp4lp2h5ttvssuh@sx1>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 5 Jan 2022 19:45:53 -0800
Message-ID: <CAEf4BzaYf5SMYrcj=uTrAW0PN6npGLwio79Mi+MAY8FX=QaaYA@mail.gmail.com>
Subject: Re: [PATCH net] scripts/pahole-flags.sh: Make sure pahole --version works
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 5, 2022 at 2:14 PM Saeed Mahameed <saeed@kernel.org> wrote:
>
> On Wed, Jan 05, 2022 at 02:42:01PM +0100, Daniel Borkmann wrote:
> >On 12/31/21 8:56 AM, Saeed Mahameed wrote:
> >>From: Saeed Mahameed <saeedm@nvidia.com>
> >>
> >>I had a broken pahole and it's been driving me crazy to see tons of the
> >>following error messages on every build.
> >>
> >>pahole: symbol lookup error: pahole: undefined symbol: btf_gen_floats
> >>scripts/pahole-flags.sh: line 12: [: : integer expression expected
> >>scripts/pahole-flags.sh: line 16: [: : integer expression expected
> >>
> >>Address this by redirecting pahole --version stderr to devnull,
> >>and validate stdout has a non empty string, otherwise exit silently.
> >
> >I'll leave this up to Andrii, but broken pahole version sounds like it would
> >have been better to fix the local pahole installation instead [rather than the
> >kernel having to guard against it, especially if it's driving you crazy]?
> >
>
> Already did :)
>
> >I could image that silent exit on empty version string due to broken pahole
> >deployment might rather waste developer's time to then go and debug why btf
> >wasn't generated..
> >
>
> Good point, I was mainly thinking about developers who are not familiar with btf
> and who have no time debugging irrelevant build issues, but up to you, I
> personally like silent build scripts.
>

Sorry, trying to understand. If you didn't use BTF (and thus
CONFIG_DEBUG_INFO_BTF is not set), is pahole still being called? If
yes, we might want to address that, I suppose.

But if you have a broken pahole that emits something to stderr
(undefined symbol in shared library), then I agree with Daniel that we
shouldn't be working around that in Linux build script.

> >>Fixes: 9741e07ece7c ("kbuild: Unify options for BTF generation for vmlinux and modules")
> >>CC: Andrii Nakryiko <andrii@kernel.org>
> >>CC: Jiri Olsa <jolsa@redhat.com>
> >>Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
> >>---
> >>  scripts/pahole-flags.sh | 3 ++-
> >>  1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >>diff --git a/scripts/pahole-flags.sh b/scripts/pahole-flags.sh
> >>index e6093adf4c06..b3b53f890d40 100755
> >>--- a/scripts/pahole-flags.sh
> >>+++ b/scripts/pahole-flags.sh
> >>@@ -7,7 +7,8 @@ if ! [ -x "$(command -v ${PAHOLE})" ]; then
> >>      exit 0
> >>  fi
> >>-pahole_ver=$(${PAHOLE} --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> >>+pahole_ver=$(${PAHOLE} --version 2>/dev/null | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/')
> >>+[ -z "${pahole_ver}" ] && exit 0
> >>  if [ "${pahole_ver}" -ge "118" ] && [ "${pahole_ver}" -le "121" ]; then
> >>      # pahole 1.18 through 1.21 can't handle zero-sized per-CPU vars
> >>
> >
