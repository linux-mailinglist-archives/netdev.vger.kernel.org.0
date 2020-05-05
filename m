Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA451C61CF
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 22:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729221AbgEEUQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 16:16:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727785AbgEEUQD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 16:16:03 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BDBEC061A0F;
        Tue,  5 May 2020 13:16:03 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b188so3744512qkd.9;
        Tue, 05 May 2020 13:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TqRbVHLIMt67JTCk+jjBMibZD2NP6+r1URSVPlpIb6c=;
        b=LmxoHCytX9SU4Ya2lIHtO+3d7XsiXVF4x+Jcdi+7PTa2CySfIHKyI7EBLc8lfWlI1+
         FW1IXwWBXjqQobqcp1p7z8S9rtBgeDDjO4NWFpgpFKZ757gNThDgDp6gHVYR2pwWapLJ
         PpsUY+nvcyi961L5NWs32eABLwaYMhEpOfcD0aPRU5RsqywDIiYZWoAvpmpz0aAT/f9j
         K3HFHpEzlB2imar35W/REjwxjxiSnPHhUI+6+SK6SBlLuUxN2HmCXeyAzmjIZnmxcM2K
         1ZZ+nYLsbCR/oSyVsZef1d4pH5lbuwB6+nj+a/iMTIfdt2Ea15p6TjCUC3hqcejZ6H7M
         UjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TqRbVHLIMt67JTCk+jjBMibZD2NP6+r1URSVPlpIb6c=;
        b=h53/N1kVeI5jGzWpMYUEvTdSlB3UTGcIZhepLxdyCe5CQPs1/41Lb0egTWexpSXiUH
         +1DV6G5Aj7C9UNMM2SZqL6E+imSWV+QHnBueNDGH/EcE/vJmz/Wu9FBEPupungFMQPlH
         X9Olog5kU+64BRpzI12HmIwsB6rC60Q5FU43+RMa+izzNjNA/xitnm55c3OvXnHUsHEA
         4I6YksxlFDmxCV4Ldtbxrh1zyitqFPR7PCnHK3xfWuN/xLZTOxjwiyol3mCk9Ul3W9I0
         mD0ALCcSiCMoiWakFVFKTCLzbcI6ZA/14R6wHS2CQjxaXgzbGtKC3tVDPL5vV2z7/EPW
         o0Mw==
X-Gm-Message-State: AGi0PuYcPB3sFG6m8g775k23yJKa4y2hj9LtVKAaR2tsdHhwwxNTCqUu
        zlxHqYuVjrnsxekihJdRrZpDtnrow05tykmEN68=
X-Google-Smtp-Source: APiQypLL/41T5XJ5f77N1Y9DqxAnKNB9tmD/hcokoaqiolvAmxnaLOtNbbLqbbNPnCNXwO40g9yCXxMFfwRexkoNMoM=
X-Received: by 2002:a37:68f:: with SMTP id 137mr5493096qkg.36.1588709762191;
 Tue, 05 May 2020 13:16:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062554.2047969-1-yhs@fb.com>
In-Reply-To: <20200504062554.2047969-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 13:15:51 -0700
Message-ID: <CAEf4Bzbrjq86rtfxvbfmNRbgtOnZ5LCe9PoCDSxtyUXOxFzFrA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 07/20] bpf: create file bpf iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:26 PM Yonghong Song <yhs@fb.com> wrote:
>
> To produce a file bpf iterator, the fd must be
> corresponding to a link_fd assocciated with a
> trace/iter program. When the pinned file is
> opened, a seq_file will be generated.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   |  2 ++
>  kernel/bpf/bpf_iter.c | 17 ++++++++++++++++-
>  kernel/bpf/inode.c    |  5 ++++-
>  3 files changed, 22 insertions(+), 2 deletions(-)
>

[...]
