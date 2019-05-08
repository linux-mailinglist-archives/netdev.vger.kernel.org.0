Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 109DF18198
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:22:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbfEHVWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:22:04 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:42095 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfEHVWE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:22:04 -0400
Received: by mail-yw1-f65.google.com with SMTP id s5so122303ywd.9
        for <netdev@vger.kernel.org>; Wed, 08 May 2019 14:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=boAd+a/J/ScFtZAPFE0KAwS4GNA7JLtZBc+33QPTJK4=;
        b=jKwgefpyUD1ZKUv5/5CyzxgXstKaDAwuIAqItVVq8EPIhLY5TbAbiYn4W7h2S0JSDA
         CqYIYx+YJwEYUymYOEvzTfM0mhls0erPyUIlYkpREMSyd4He5cM1jbUXC0iWUtFABk5d
         mX1XYNJgDbCuo6rys41HOowqbpJqmNnpqjF6l1gXOkQO5/oxKc0LKyeYFeWRJ22tc1DW
         9ci12LWbkqGCeeX2AAhrsjEycRe+RhBLG/Gdn0p3woZ2fbBBGuIMyCUKar0H3aqvA4ez
         W/qk1bTMBd0eU6ZGmhRUYQK5QWmjiOAjL27rYR/iNP/SnH5PatUxdb/9mgXPkpPclbub
         dKFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=boAd+a/J/ScFtZAPFE0KAwS4GNA7JLtZBc+33QPTJK4=;
        b=pH6uEyaaOpgJr6tIBJxmhHyZN66c2pyu/oWB9sk0BcU/7di9cX/zMsQ9XlaFgqpGHY
         w92Xg2wQ2MGGf/qb2PKt+1fvHrL0nEg5IxsmRYJg3IuTJI4JkKcMt/QwoZbjhSOodn9u
         sBAzw+6tYJ9toee1cR+LcOjITsdpGZTQy6bKEROD8xVf3opZc8oz4JPppkJ1kraM9yKH
         giLnDTDwrB4odym0lxwKC2KDX57UFDFeRspeGOQQ5fsG1H3mFcjzhvgmtHgMDITCzqU3
         RW0B090m8+n2U3vFZ3P1u3EwbwyI0J5ZYHpWY23qArxCP1jMjprM/hbSDAWTVcl7DaHK
         RJFw==
X-Gm-Message-State: APjAAAVLrnSAnmSyEaEaDU7nnwfNulKRAgGYHJn52rerELL00DRJj2e9
        YjylYwQYMl88HJz33j6/LONK89vlKi82vfhhs6eOJ4SymjLk8A==
X-Google-Smtp-Source: APXvYqwqMJyCQ2aliKFLK6lIq4oijxjcpfCYSqRhGyGhkrTN/BOHUwMil521HbqrsrhbwWzgd6mS4U8pwBByGgFg5Ro=
X-Received: by 2002:a0d:f346:: with SMTP id c67mr27424120ywf.37.1557350523269;
 Wed, 08 May 2019 14:22:03 -0700 (PDT)
MIME-Version: 1.0
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 8 May 2019 14:21:52 -0700
Message-ID: <CANn89iL_XLb5C-+DY5PRhneZDJv585xfbLtiEVc3-ejzNNXaVg@mail.gmail.com>
Subject: Question about seccomp / bpf
To:     Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexei and Daniel

I have a question about seccomp.

It seems that after this patch, seccomp no longer needs a helper
(seccomp_bpf_load())

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=bd4cf0ed331a275e9bf5a49e6d0fd55dffc551b8

Are we detecting that a particular JIT code needs to call at least one
function from the kernel at all ?

If the filter contains self-contained code (no call, just inline
code), then we could use any room in whole vmalloc space,
not only from the modules (which is something like 2GB total on x86_64)

Thanks.
