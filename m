Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8B4A20472F
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 04:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730983AbgFWCSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 22:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbgFWCSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 22:18:38 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 149F8C061573;
        Mon, 22 Jun 2020 19:18:38 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id m81so21932887ioa.1;
        Mon, 22 Jun 2020 19:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mG0wlCSoepw+ip9MmpFcrXSkYo7RaSEIeBvF0uxMtXI=;
        b=WDHXZGPbutDZt7otrg+mz7gUXNIUkhtZmVgZzBuGYvFTCxWaarakYKyxBzo1mE3PZC
         qAwCDvphdtPUYIzBQ2v3ueMx4CVxmjvItNOMj7n5Ky1+a47EFrjWQ/Hj/BBFPA8PFRnx
         uoNNiBWuQtd6fCyG+XoJ6FWj9tCsMkFg/HTZ5nHl5gKeoghpA6Ac5qjHmGNPOEvyWlOA
         mrJTZ/bHcqxGv6XctgepuBiz3PsjhoajnfeMRvTJIe0AdjLGZ8E8IHW4SlRXiXXUCwvY
         pzrptW1JKjHNBnQnHFjQUlyI0ZDeSAdNBOAp3J9kpqfrV8DhCkQc13PcvOHBeGUOLRGL
         bLxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mG0wlCSoepw+ip9MmpFcrXSkYo7RaSEIeBvF0uxMtXI=;
        b=JRQB1xAWUgwah5HcU+LMIxcRHN8Cy25FlDDGjdxd0c7+YfRXYlaJSck9tOKcTFzfjc
         5cSY2ASC0BGeHd4OzkBGjupO2239TSK57s+7qaAGjqTn8VXMrJBg0JXaoOQZsNV+xnop
         Awh44hHZeRYn5OS+fKgXIv1qsP45manNDGvp18j9EGECeQOi/LrfaC/lQFQYNh8RSfKY
         lCZL+vgauL58Z4E1JJXrZNibHWmj4z8/3QYObzWO2vHPzX7F0JkUDyKZnsC9OMofmWEb
         ioepAAxdznsqABfI8zAQ9/1GBceWmn62hBYumX2K2G4ryepa8VkdvAbUpklgggNzsyzF
         pJXQ==
X-Gm-Message-State: AOAM531PxNf3+Wspo29NL8jgfiPtT4EiDJUvAmsrJ0mbNAoWne3+/1gm
        g0foTcglqNP8EDhzngnXJh6679hCraE=
X-Google-Smtp-Source: ABdhPJys5YHQ9Jz6RYf3nKiOCRN6ODxxjd0H/fMql4NsHSg0eFtVVKoGsjFvrvMtR/RtHng7xKqkAQ==
X-Received: by 2002:a6b:8ed4:: with SMTP id q203mr6724393iod.193.1592878717259;
        Mon, 22 Jun 2020 19:18:37 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id c85sm9062625ilg.41.2020.06.22.19.18.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 19:18:36 -0700 (PDT)
Date:   Mon, 22 Jun 2020 19:18:28 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net,
        john.fastabend@gmail.com
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5ef16674b315b_295f2ac8b51605b45d@john-XPS-13-9370.notmuch>
In-Reply-To: <20200623000905.3076979-1-andriin@fb.com>
References: <20200623000905.3076979-1-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 1/3] bpf: switch most helper return values
 from 32-bit int to 64-bit long
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Switch most of BPF helper definitions from returning int to long. These
> definitions are coming from comments in BPF UAPI header and are used to
> generate bpf_helper_defs.h (under libbpf) to be later included and used from
> BPF programs.

[...]

> There could be two variations with slightly different code generated: when len
> is 64-bit integer and when it is 32-bit integer. Both variations were analysed.
> BPF assembly instructions between two successive invocations of
> bpf_probe_read_kernel_str() were used to check code regressions. Results are
> below, followed by short analysis. Left side is using helpers with int return
> type, the right one is after the switch to long.
> 
> ALU32 + INT                                ALU32 + LONG
> ===========                                ============
> 
> 64-BIT (13 insns):                         64-BIT (10 insns):
> ------------------------------------       ------------------------------------
>   17:   call 115                             17:   call 115
>   18:   if w0 > 256 goto +9 <LBB0_4>         18:   if r0 > 256 goto +6 <LBB0_4>
>   19:   w1 = w0                              19:   r1 = 0 ll
>   20:   r1 <<= 32                            21:   *(u64 *)(r1 + 0) = r0
>   21:   r1 s>>= 32                           22:   r6 = 0 ll

If you roll a v3 for Alexei's comment might be worth mentioning that
above <<=,s>> is a result of the >256 test if you do this as a more
standard <0 test the 'w1 = w0' assignment should be enough.

>   22:   r2 = 0 ll                            24:   r6 += r0
>   24:   *(u64 *)(r2 + 0) = r1              00000000000000c8 <LBB0_4>:
>   25:   r6 = 0 ll                            25:   r1 = r6
>   27:   r6 += r1                             26:   w2 = 256
> 00000000000000e0 <LBB0_4>:                   27:   r3 = 0 ll
>   28:   r1 = r6                              29:   call 115
>   29:   w2 = 256
>   30:   r3 = 0 ll
>   32:   call 115
>

Thanks,
John
