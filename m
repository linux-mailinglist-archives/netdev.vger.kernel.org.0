Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA78F1D8EF7
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 07:03:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbgESFDt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 01:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgESFDs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 01:03:48 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63CE4C061A0C;
        Mon, 18 May 2020 22:03:47 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 190so13340680qki.1;
        Mon, 18 May 2020 22:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hV84v5t8tiL1MnM1/M+7LUEu9+6IlFPVfYs3qhzKTUk=;
        b=iE7fbvHHUDpS0wrGvoYcAZqVPyWLCOm1xKdtQi2EHv4zdlnFfs7uMAL++bRAJq1wbl
         QOhvN72jnq52ZBYlP2k1T4y2tDP9bMItUwQkGQvcL6mzWC9LPgPQqqetlKZvjrTfL1cP
         ex/SwWktDHmOq7cOPOGYJUxrEuxcRJGE+ISZ+4YFJqORnHGnCjQ95P71CJm+y2iUFjxi
         2nFEteJvuAygCP2mGzRSUYaCuoxtvKplsR9ct0dnCYfrIpNGibsPMasJirJe8vYWJZwm
         4GPphSEJvUl0uTX4YnGHzpo+Uxp9BJyuXi18YFeN03CzrqVqkU8SV29p7Q25JjQzgr3H
         xHqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hV84v5t8tiL1MnM1/M+7LUEu9+6IlFPVfYs3qhzKTUk=;
        b=Fagg5PVPQq+3eBKvgya+03zztPWHS+l4dn5ieJUbx1qui4S2a0rN8sOROYGjz9llJL
         s4aWFr94U/n5iF9oyBXYLSuUDVNJGdC3pLjW1OO+PJZE5sQGV05mRSkD41NwMTSxk3Ut
         HGqrUvSbxpOzpHy368WcsxoqIsvLRjip/wP4mwLi+NZk6JMpKW+xQNKw65mplDE4kzlH
         z7xU6X8DVZn78alA6jTBfJi6+13+I1zWZ146DHKgcJwhoO9K1QopcdPxmWnYlnIjNrGq
         ZU8xyN7ELuIQhSq8UR+/mVxi0Qi6tVwAWag6CyHnmCLmkBU2rE6WnaCKKl2/JcUs6EI7
         D3fA==
X-Gm-Message-State: AOAM530LP86gUlmRrfFFC4LhIzEMvexgMQ3OiJUEBeVlSBy9Jpbpi51k
        TAkgc11etYRQvG/ai/IBEw66rAlFzmMGNcK02tg=
X-Google-Smtp-Source: ABdhPJwByTXLieLUjnrkeRA+mPS6N542CJ1EPA5GRCGxiXnmTYmQHtMb8FR8L1YOjDwIuTc/vuIfPajtYJ5/ER2vCqg=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr18578396qkj.92.1589864626619;
 Mon, 18 May 2020 22:03:46 -0700 (PDT)
MIME-Version: 1.0
References: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
In-Reply-To: <158983199930.6512.18408887419883363781.stgit@john-Precision-5820-Tower>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 18 May 2020 22:03:35 -0700
Message-ID: <CAEf4BzZ6gnXD23oxaKT3jB2t4kLVczmx+8q+n-KtyFWGv1ZqJw@mail.gmail.com>
Subject: Re: [bpf-next PATCH 0/4] verifier, improve ptr is_branch_taken logic
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 1:05 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Verifier logic to track pointer is_branch_taken logic to prune paths
> that can not be taken. For many types we track if the pointer is null

I re-read first sentence many times, still not sure what it is saying.
Do you mind rephrasing it a bit for clarity? Thanks!

> or not. We can then use this information when calculating if branches
> are taken when jump is comparing if pointer is null or not.
>
> First patch is the verifier logic, patches 2/3 are tests for sock
> pointers and map values. The final patch adds a printk to one of
> the C test cases where the issue was initially reported. Feel free
> to drop this if we think its overkill. OTOH it keeps a nice test
> of a pattern folks might actually try and also doesn't add much in
> the way of test overhead.
>
> ---
>
> John Fastabend (4):
>       bpf: verifier track null pointer branch_taken with JNE and JEQ
>       bpf: selftests, verifier case for non null pointer check branch taken
>       bpf: selftests, verifier case for non null pointer map value branch
>       bpf: selftests, add printk to test_sk_lookup_kern to encode null ptr check
>
>
>  .../selftests/bpf/progs/test_sk_lookup_kern.c      |    1 +
>  .../testing/selftests/bpf/verifier/ref_tracking.c  |   16 ++++++++++++++++
>  .../testing/selftests/bpf/verifier/value_or_null.c |   19 +++++++++++++++++++
>  3 files changed, 36 insertions(+)
>
> --
> Signature
