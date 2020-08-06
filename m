Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C755B23D677
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 07:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbgHFFln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 01:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgHFFll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 01:41:41 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D89AC061574;
        Wed,  5 Aug 2020 22:41:41 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id y18so30989545ilp.10;
        Wed, 05 Aug 2020 22:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=HIGPgBL7n98bpEVZBM/4G2APCFecCIPvFc7WiIgCYY0=;
        b=FiJgIehPKvn2HJA91Zt1bLnAxrIVtSKzm8V2TXidY17vnP9eFbF33heWll62gghlgO
         XfMOrBzima/hMa6eeD21FBfFGWkNznqaMlpoGEIhvI6RGOWsbYCiu404LXAJnsqhZsI1
         WFN2Mo/MV6O5TG9DqXjZBcM7xJEsHjZVgvnbmaCOMagFpIm9W6cex5AQj1s5JAqndb03
         Bi5x+kYXZSSUYKBZajnFd3deR5qcTVmv7GdpyIT1cGJFTclKzRgbq3lgXTfpwe0BTCvN
         v6N5t+yTKM30fvYyAjJxtOuxbiJG9eHmsM19GAQk9Ur+6dPGjj3c7iKUUrGHR5XdRbTV
         MgeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=HIGPgBL7n98bpEVZBM/4G2APCFecCIPvFc7WiIgCYY0=;
        b=Ch5xNxILbM0D9L3WBQForNm0mf9jZRG9ZcHmh4Z3K04Vn1KHYqERY1sGbUxM/zCgI4
         vpyYmz9065MJe5Igl+GzMy+X2iywAw3SQV1iXaE9TFcs4zNFDthPDLDSbWApT1AHJzlk
         BeaLmU3vBaXzMcbOXibwltSSdyTMkZ35BOGmuKxxxuIM7BLQDcoSydVdatfVnvcVEunc
         dTRxJz+K0BfuNagU/RRenrPYMv7oCGjHgE0/WlMy99j1Dp0nGwZDS2GqAF0JaL4Uuo/Y
         Q97bFpERfduSynkmLFX2A0NDBk6Rq4WI1vVe+WVelbn7uCruWPXI8SpvO4iT6Pn57TX0
         atpA==
X-Gm-Message-State: AOAM530wU8jJjQbQ/iHKkxZFsX7zSZl7wpLqH2Y9h8U+YZUn4SvBoluR
        wH58CgImD2I1m06q/KAgYY8=
X-Google-Smtp-Source: ABdhPJzfFQrkhxfiSuEnos5KxcjG3hgktUyK5qO7wvdWxUZYYXobmNCqd9eumJE1qTchwrRO1oLRCA==
X-Received: by 2002:a92:d34c:: with SMTP id a12mr8492912ilh.20.1596692500154;
        Wed, 05 Aug 2020 22:41:40 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n10sm2879634ila.2.2020.08.05.22.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2020 22:41:39 -0700 (PDT)
Date:   Wed, 05 Aug 2020 22:41:30 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Muchun Song <songmuchun@bytedance.com>, rostedt@goodmis.org,
        naveen.n.rao@linux.ibm.com, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, mhiramat@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, john.fastabend@gmail.com,
        kpsingh@chromium.org, sfr@canb.auug.org.au, mingo@kernel.org,
        akpm@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Muchun Song <songmuchun@bytedance.com>
Message-ID: <5f2b980abeaad_291f2b27e574e5b82@john-XPS-13-9370.notmuch>
In-Reply-To: <20200805172046.19066-1-songmuchun@bytedance.com>
References: <20200805172046.19066-1-songmuchun@bytedance.com>
Subject: RE: [PATCH] kprobes: fix compiler warning for
 !CONFIG_KPROBES_ON_FTRACE
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Muchun Song wrote:
> Fix compiler warning(as show below) for !CONFIG_KPROBES_ON_FTRACE.
> 
> kernel/kprobes.c: In function 'kill_kprobe':
> kernel/kprobes.c:1116:33: warning: statement with no effect
> [-Wunused-value]
>  1116 | #define disarm_kprobe_ftrace(p) (-ENODEV)
>       |                                 ^
> kernel/kprobes.c:2154:3: note: in expansion of macro
> 'disarm_kprobe_ftrace'
>  2154 |   disarm_kprobe_ftrace(p);
> 
> Link: https://lore.kernel.org/r/20200805142136.0331f7ea@canb.auug.org.au
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
