Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C5514A89E0
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 18:23:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352756AbiBCRXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 12:23:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231389AbiBCRXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 12:23:17 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB97FC061714;
        Thu,  3 Feb 2022 09:23:16 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n17so4124077iod.4;
        Thu, 03 Feb 2022 09:23:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=00rjZ1Yl8mUuY70UCPH13Shea97szUItT+m0m9+961Y=;
        b=MErhnmSytClk/s8BPz2Lci8Z7vcRu7b0tgQYbgx70XqpC5PO/su4ve9C+1zINjIY5p
         fQaDumvFwkcJEoTimJbf3uwG/aYJwgrx0jWBb9MRwNreZFn9Prs5O6/JHoWtHGGxwTfO
         9PPAv2//FMrUAbY87h+Ji41K5I2mxcmxkwE4WjAkaeSR/HQGek8UNSY854rYCd1EdZgp
         dpjvW4PAe5in4H1VzMauGSsxQb+HYzYxWXKqKDkXhewgwKgk2zIdrHy2Rh1kzl/g09E9
         g+zDNxGKtUWIWT4DrjIniyIub3h28v+e/wnEQPzN7Q2H/aagzI+f7FyB2MzdnkPiadY8
         NbXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=00rjZ1Yl8mUuY70UCPH13Shea97szUItT+m0m9+961Y=;
        b=Q4GDX155HEYEBV5jana2waIAMxFHLpMS/ZHxLrFClrTC6eIK6EqgfuQG7w8BRMNEvV
         drkNHJ2jrfF3z7HQvwz5yZgTjSXscETij2vVRt9MF7hkLBE/2AN0n4dozwAqbKXjF7D5
         L5HzEU8RP+glTkDHCwIcQ6raWw0F6WCUV46942ACnlpPPAnDeGmFhVAeIHrx2+ewu+3e
         F4YuvY9UWAAV1j4pLl1YiG46qPXPc/n+o9LpNe3T55z26MTAr6AxIQ9+K3ZmxrBR8to5
         XfjuGoWbeb8r6GUG4JxnXzXolrlKcDOciOClTz9tnprXeUhlruHalfaBOA9JiLJEQxGC
         NoAg==
X-Gm-Message-State: AOAM533l9GzS9prD3ZSNrnWjts1x2cMtpagDhkZdKAJFe0sYllkKVgs0
        1M+35l8jOIGONXS4Qy2fDCrymh0gWHTLcr+Xsei4EiXa
X-Google-Smtp-Source: ABdhPJwf7mebXWgypq8PMBvQlV9N58BT1QgleNQeI6Q5DdyJ8o949oG1wyyzyLY91mDMgtNGE8KCTMsUbbawx7ZbCL8=
X-Received: by 2002:a02:2422:: with SMTP id f34mr18057308jaa.237.1643908996305;
 Thu, 03 Feb 2022 09:23:16 -0800 (PST)
MIME-Version: 1.0
References: <20220128223312.1253169-1-mauricio@kinvolk.io> <20220128223312.1253169-4-mauricio@kinvolk.io>
 <CAEf4BzYW54DRsJxgeXKcHPLSXs45DsCVKumV7WNd2UH=1G4MPA@mail.gmail.com> <CAHap4zumCF_pC6-J+dpSiT+qzZVt=scb-AMdpcFSFfz6iSx1HQ@mail.gmail.com>
In-Reply-To: <CAHap4zumCF_pC6-J+dpSiT+qzZVt=scb-AMdpcFSFfz6iSx1HQ@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Feb 2022 09:23:05 -0800
Message-ID: <CAEf4BzYG2f=S7Qz4v+fTv=mg3v3DLZ5aS+9Y83LAWhXaTRqALg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 3/9] bpftool: Implement btf_save_raw()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 3, 2022 at 8:07 AM Mauricio V=C3=A1squez Bernal
<mauricio@kinvolk.io> wrote:
>
> > The logic looks good, but you need to merge adding this static
> > function with the patch that's using that static function. Otherwise
> > you will break bisectability because compiler will warn about unused
> > static function.
> >
>
> It only emits a warning but it compiles fine. Is that still an issue?

Yes, it breaks selftests build (warnings are treated as errors for
bpftool, it seems).
