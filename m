Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F972794A5
	for <lists+netdev@lfdr.de>; Sat, 26 Sep 2020 01:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgIYXW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 19:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgIYXW1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 19:22:27 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A294FC0613CE;
        Fri, 25 Sep 2020 16:22:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id c2so3732232ljj.12;
        Fri, 25 Sep 2020 16:22:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AKOXnEeFOMUE3ch8rT/xlTlm/6EVmPeM5M9iFVJv2jM=;
        b=AAGnNQ8zkyqOB24ooJ4LPaojGGuLmspdthqv4WOQfOMsU4Wbi4rQBaJxJovLkVmKg9
         sQffaw+n5q9hJnuoqHzKeewAavIWL5lCdIKk/q67Ai4/FCckhHzuEOEuZ66yh/W8d55h
         tiIOkpl5KEZqkCYxSLf+uFoUglmzQnhYvGhKJR8ZgXLM7lWctP8EXKeabTKMseMr/43Z
         rNLmDUl7LIijkCE29qAigUFp7yMkKYRqEdXm7rKZPS6F6gDnTqzG8CE0/4VTm7XXtR8s
         dICV+f/LEVJLVBWhMt33MmkREfLAOI5iMxouVl3tCXoaYp8vuUDTiTeOOjQOWpFLVNVD
         KOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AKOXnEeFOMUE3ch8rT/xlTlm/6EVmPeM5M9iFVJv2jM=;
        b=VRx2n3YBjxW5j46aUXvr/Vg/etqIUpt3RBSl00nTYVSzZetIeyQglqOD2Oz48pYSDz
         7J/wmbRpDDhjq7ccK2zQHVH2+moAZyjYKZOyufO/2bYTqXG8t/5ZzaI/mPKLN0L+UWR2
         kF8WKtSLHvhBOvsQdC+/E4u/6RLMoXIYknj/kXfkJ16/xp8ZG6Cs0lfSYOhu7F5mI2sV
         z3SctJ17KMU6Rbr/QESFfNQQijba/CzNCj/7EM21c7zOpkX+znVNRUBeOq87e9VmcSA0
         AnIyoR3hTIrU4U5Os2ASFF7SjQI6Tj5y0Fxw4jP5o6ugNrJ0MgWGMbNqqSnJaoXWdgUO
         0l8A==
X-Gm-Message-State: AOAM531hx/EiagOLB1nH4Cw3sHXKt6LP7EOUMJnIGBg/Z6vnkyIr49s8
        Wxlv2nYIE1qvjB3qh+sT4845Ho67vePWfLYtPvs=
X-Google-Smtp-Source: ABdhPJwXLqJ6CuyToPH/sLheIX5NjiRNQmQIAz2VcwfAIAQbDbgxnCqb+htCshnQ8D/qw4ph8+d63sp7usQo51bWVoI=
X-Received: by 2002:a2e:8593:: with SMTP id b19mr1929741lji.290.1601076144956;
 Fri, 25 Sep 2020 16:22:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200925000337.3853598-1-kafai@fb.com>
In-Reply-To: <20200925000337.3853598-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 25 Sep 2020 16:22:13 -0700
Message-ID: <CAADnVQ+X53PGyu43gjMu8kmCzD3iqO2oWzEM1AOhrcA1x9sMWw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 00/13] bpf: Enable bpf_skc_to_* sock casting
 helper to networking prog type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 5:03 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This set allows networking prog type to directly read fields from
> the in-kernel socket type, e.g. "struct tcp_sock".

Applied. Thanks
