Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D243239E8A
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 07:05:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgHCFEZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 01:04:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgHCFEZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 01:04:25 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F1DC06174A;
        Sun,  2 Aug 2020 22:04:25 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id w12so23686764iom.4;
        Sun, 02 Aug 2020 22:04:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=jG5Ttu2IFR0hBTgY1CkuGVNQzM97L3YaR4HgFRRkO2Y=;
        b=qsuUjjXaCVRc88NKXyC1q3qETut38wpfLJsTYlOf8l4aOOcJaEJmxmrmVNsiCzx16v
         Sej6ZBkm3+CloRFsjDkncvSWsgoE2W9OXxYIRyUT2ES93/ZaV5DBmkdlYg/DsvM1Pkw8
         5ohLFELVgacdOGMSg39B9a66dQCNXk3GazOqO/1x+odVwWyqm7RZDgwUuOJ/Zm7ZiQCa
         S2V2lqbrZx0fVhu0euDtebgKVAdTH5yGgpVctvzW6qw+iWvuLY7d/uYI07LJmkMqaBhp
         V76sIXuXsMD66hhshZ77fu7qHIjpLAarO9lQA9XN1XHAbsn41mP5KGoD2C4++d+KUqWP
         Q/Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=jG5Ttu2IFR0hBTgY1CkuGVNQzM97L3YaR4HgFRRkO2Y=;
        b=STVT+odWGgRWdQCNC1tp+iMRPPdaEgE4NZCAb3GvRsq2S+pgZC8iG3ppuTMZKiDB1S
         hPUMecyW0fpAElyVPIgN/wvO1qxqfZ0sKva8Gw3xPJW0J3s3KY+pVRkB/O4+0U5Qc7pa
         cf83LMHJYqJlIu+ac9DH+lj42ccnSb276atzS4qYQ/QjVK+9WqkiHOKZUAMcuaywfTCP
         nFnGjvR70+t+owaz3OLmKtQteVr2AyFKaqz792s1MF7toCZKfeh7lXiqyfnPTYKkTmZA
         OiwPjj3x73jb7kkVgAqJg7J1ZUYnF3BqrjoJoMaUodiXgFJc8EKJHBcREoZlCZLD9Dfe
         ZUmw==
X-Gm-Message-State: AOAM531R0Rw/tO2RHju6noNHLPJLxQhnpzeg0vTprpoOacnr9PfZvgTh
        M/oqABTQ9Sra6sFHl39n7hw=
X-Google-Smtp-Source: ABdhPJwM7KXEwGDiCmEWj+KcqyzW3x/5HxDbNTDIWoKV7ADzASuPsYT9zqef5MTsxeg3n21QqWRYjw==
X-Received: by 2002:a02:838e:: with SMTP id z14mr19188094jag.84.1596431064695;
        Sun, 02 Aug 2020 22:04:24 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id f84sm5869159ilh.72.2020.08.02.22.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2020 22:04:23 -0700 (PDT)
Date:   Sun, 02 Aug 2020 22:04:14 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Jakub Kicinski <kuba@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Tobias Klauser <tklauser@distanz.ch>,
        Jiri Olsa <jolsa@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        tianjia.zhang@alibaba.com
Message-ID: <5f279aceeb809_5782b0a7167a5c487@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4Bza0C3iB3S8wXkkQxPoE+ndNuUtkmU3L8g7NzMgjHzkx8Q@mail.gmail.com>
References: <20200802111540.5384-1-tianjia.zhang@linux.alibaba.com>
 <CAEf4Bza0C3iB3S8wXkkQxPoE+ndNuUtkmU3L8g7NzMgjHzkx8Q@mail.gmail.com>
Subject: Re: [PATCH] tools/bpf/bpftool: Fix wrong return value in do_dump()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Sun, Aug 2, 2020 at 4:16 AM Tianjia Zhang
> <tianjia.zhang@linux.alibaba.com> wrote:
> >
> > In case of btf_id does not exist, a negative error code -ENOENT
> > should be returned.
> >
> > Fixes: c93cc69004df3 ("bpftool: add ability to dump BTF types")
> > Cc: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> > ---
> 
> 
> Acked-by: Andrii Nakryiko <andriin@fb.com>
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
