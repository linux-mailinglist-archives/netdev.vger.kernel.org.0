Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED2D936AF7D
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232158AbhDZILc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232349AbhDZILP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 04:11:15 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 497E9C06175F
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:10:34 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id b23so4368357lfv.8
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:10:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/3PTK86IuJli8BfpofGbB9edK2Z13Oa5858Hm/N4QK0=;
        b=oy+0CEP5bH/GdhzT03FTFfJO2XHlB/fzTwUcVb3//T2XcLhq4DPwAcdFISF4m23nuI
         rTCZivvUUZbZlUDEEWEMychSOYJDYim+VEGOSSo8fq41PgydcvwBIpcCdcl1Q15mpMM9
         I53nlUSlQqVNK5NPw1eD3iy6gL3j/hrMMScQI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/3PTK86IuJli8BfpofGbB9edK2Z13Oa5858Hm/N4QK0=;
        b=XJSxV2nb3fH4g806Oi1xxn1h85U76InWdgAnDX568niXl74cT5xmGziTf5GMMqUKVv
         MVUzKLOkEF89N7J0pXZ7/sKegZCe2wf8wwhArVKwUtWT14ix2DaDtfZZhSf2SnP47O7I
         rIf7knBd4OqwLTMLY98okJKqaUZBvGG7zjKugJmk/ObQiDVF+36K5w4pQYJEkdb7fUCH
         wOmrwXdxjlDS1qHzMfvObcHlDnHxCYtosvIHo1z5xg+ldfbx2M6/KkwetSLid4O/ZDeQ
         cFa8JxS64pwq8SzFdMvkEx6aSKKODoepCz1Ta6HygyMc9t/IIWO6OvY+c7wykkbVP6Eg
         r53Q==
X-Gm-Message-State: AOAM53392JzF4zlFc3Wx4CiwjnKKtSutV6etKawCphgxfpjE+Ksp9tvD
        2LfVgaEbXFtdE318fopusTKklCma1jj/dN1Hm40d1w==
X-Google-Smtp-Source: ABdhPJx6TCWPc2SEfCzteJpHau5fVeFAzpu3/woWXjCJTPJXWczLcVQJTlq8TdaOEjMoEQ2RyqR3+qZ1JA5rfPuXVbA=
X-Received: by 2002:a19:480f:: with SMTP id v15mr11890068lfa.13.1619424632825;
 Mon, 26 Apr 2021 01:10:32 -0700 (PDT)
MIME-Version: 1.0
References: <20210423233058.3386115-1-andrii@kernel.org> <20210423233058.3386115-4-andrii@kernel.org>
In-Reply-To: <20210423233058.3386115-4-andrii@kernel.org>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Mon, 26 Apr 2021 09:10:22 +0100
Message-ID: <CACAyw98yy6K_TPRs2Q7E8FbW2tocfFWRgRRoEM15NTBcRFV2+Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] selftests/bpf: fix BPF_CORE_READ_BITFIELD() macro
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 24 Apr 2021 at 00:36, Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Fix BPF_CORE_READ_BITFIELD() macro used for reading CO-RE-relocatable
> bitfields. Missing breaks in a switch caused 8-byte reads always. This can
> confuse libbpf because it does strict checks that memory load size corresponds
> to the original size of the field, which in this case quite often would be
> wrong.

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
