Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6161F2D7FB8
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 20:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392192AbgLKT5D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 14:57:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390134AbgLKT42 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 14:56:28 -0500
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B600BC0613CF;
        Fri, 11 Dec 2020 11:55:47 -0800 (PST)
Received: by mail-yb1-xb44.google.com with SMTP id w135so9078121ybg.13;
        Fri, 11 Dec 2020 11:55:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eTjfaHSrdCOzqItoXPjoUbitJh68Tkt5gBw7hhWkKdA=;
        b=oK96XtfTvVQUc6Z/j/rXPthdkCHnC82TvA2CEoa3Qqgedo02sQjagq5fF8jjAr5RDn
         +Cv3mO+KYIVPpua9EjIeOoOyx73ylb6wiqpoiZJ+Vuhcrv0ACl+q0nnKucSRvRlbDfPL
         qjkZb6VJiLKFEEaMX5468Cfv6PCvqNO4l3ahbgX5SHGMPOlwfbzMdZLDyKrgnw7JadDm
         l7Qk8kvH5nVH+VeuYRrxEoKjy0PgiPzL9MuYv5Gidgf9D6YCLrOSxkYASccshXXIdquQ
         6lc+HlEgrMN7bX8A9O34+SdDwc+jggkdahV+jGbbSvInl63Q1wCeKT3COcvtGbokw3+B
         Zeyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=eTjfaHSrdCOzqItoXPjoUbitJh68Tkt5gBw7hhWkKdA=;
        b=BgWAr/fDZOoDJBRLGNlrz+Tr8LGWLuZxAR0dYjxXx9jtnLFHUbhsztcaE/Ivfr/ClA
         bcquAJGeLJJ63gCwEh/aN6YHJ3HPwDy9cYjm5O+cboSz76iJQ/NaUjt+CnaYhTOOE0ss
         90MiyLpISc6QAQIrYKz+WZVl+PGG+vbdinZzf43fSq/J2Uhx2Qa+Jc8/htsoxwkzOAP2
         bw7pb8rVvWYAHq7dZFq9TbodyVux3/yahZ4SuXXcTaVoeM6mSICcEmaWTCMj/phgMyLR
         HHNUDBOcBEWxIEhWk/NQ0iiiu0ZKnRSTQ1x2OCwmhOXOjDcUmCvkA7HjxGQpmNCQF7G3
         tiUw==
X-Gm-Message-State: AOAM533sB9jTqF2wNYC2Gh4LDn0yArmmDF3iaoXv/V6b2UdZtnn9Q35j
        aI2+Xpl4wzLpTLaVbxIFOEHpDigZHDMLoJ0kG2iWsiHmNr81uQ==
X-Google-Smtp-Source: ABdhPJyMxS8Luxn5mjw7le2I2Id/nRi/hoVU3IABQUpc9uQ8tQYXLlwezyvD1+IZDg0pJ18gK4sd+mH6Sf794Xuxjp4=
X-Received: by 2002:a25:c089:: with SMTP id c131mr20299643ybf.510.1607716547010;
 Fri, 11 Dec 2020 11:55:47 -0800 (PST)
MIME-Version: 1.0
References: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
In-Reply-To: <20201211000649.236635-1-xiyou.wangcong@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 11 Dec 2020 11:55:36 -0800
Message-ID: <CAEf4BzY_497=xXkfok4WFsMRRrC94Q6WwdUWZA_HezXaTtb5GQ@mail.gmail.com>
Subject: Re: [Patch bpf-next 0/3] bpf: introduce timeout map
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Cong Wang <cong.wang@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 11, 2020 at 2:28 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> From: Cong Wang <cong.wang@bytedance.com>
>
> This patchset introduces a new bpf hash map which has timeout.
> Patch 1 is a preparation, patch 2 is the implementation of timeout
> map, patch 3 contains a test case for timeout map. Please check each
> patch description for more details.
>
> ---

This patch set seems to be breaking existing selftests. Please take a
look ([0]).
Also patch #3 should have a commit message, even if pretty trivial one.

  [0] https://travis-ci.com/github/kernel-patches/bpf/builds/207928289

> Cong Wang (3):
>   bpf: use index instead of hash for map_locked[]
>   bpf: introduce timeout map
>   tools: add a test case for bpf timeout map
>
>  include/linux/bpf_types.h               |   1 +
>  include/uapi/linux/bpf.h                |   3 +-
>  kernel/bpf/hashtab.c                    | 296 +++++++++++++++++++++---
>  kernel/bpf/syscall.c                    |   3 +-
>  tools/include/uapi/linux/bpf.h          |   1 +
>  tools/testing/selftests/bpf/test_maps.c |  41 ++++
>  6 files changed, 314 insertions(+), 31 deletions(-)
>
> --
> 2.25.1
>
