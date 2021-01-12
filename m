Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B77E12F2660
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 03:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbhALCqa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 21:46:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbhALCqa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 21:46:30 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4099C061575;
        Mon, 11 Jan 2021 18:45:49 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id y8so586977plp.8;
        Mon, 11 Jan 2021 18:45:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6XqupT+NjHhwRWSp24cJ/RUACqfVNalLw0wWMcvtN/s=;
        b=MKz8QTsuq5hx1jBTfdZfZFryCt6qjG/egPDg+PNtbkEb/+6cV5ou5q04koQqkHqJqJ
         HygQxno9CmSETwbMdEG6ExkB6+7bD8mtSiGgrNbP3cY8kA5pzJZUO/y0ojgqJmhiPjoN
         M7UWNoMNmcnmdjBbZSxWEYe8wvLg+vUCg765nHY1R/LQiN0T4Je5C+HnnrS5Ve2o9ELu
         zu7zYbJIPBCtyo4D1Aet2QEMPFGnNn519UKtik1dQvvZ6Hdfb1GUBWcgM5tQ4Hclb4JS
         pus+wFExBLfQIi3cE+9u9ATE2JR9LiXXwdUbUxbL0GR0sHYETUPIF4+M/kzFlHbslsad
         OZpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6XqupT+NjHhwRWSp24cJ/RUACqfVNalLw0wWMcvtN/s=;
        b=U70AJWa7qftuY6ymXcJ/LRP8/XLN598HzU8Im3ynX06/+VSejklHG4f5jJsuKbmf+X
         sWP9VPz/6xtjf8P+wb5JXjlOcE21p4k1Sxe0miCsg9herxJjU7KTO3b4CRAW5hwh9ZRK
         MBORA0HcDymAzC4xubBMdX+nS543rRziq5UoAHs0I5vxmCZzF891YV8XkIFUOm8uORkJ
         37+26B5G8RYgkdG7fAKQ2DF2zN4OPEWuEnp6jUf3ZiSQAyNkZ8Buuk0sN04O7p1rFk9H
         m3ngH288/eMVVvKMcM6SwvaNkbdYScf7i9lZ2nv0JxjGAHse8DrytXx3lhvPmYk4DH3s
         YP8Q==
X-Gm-Message-State: AOAM532oB75Atqn/yrcoXjZAi6aq2+q5XTcjBHg//fPNYEPn14HSiUre
        pYOObSbVm2ylqJ1uy1K4RzI=
X-Google-Smtp-Source: ABdhPJw+FjmZm11u+d4zLb2iW1uRdyLev2FhsB+YK2Pu9miPRIeCui9VhNhfIeuGKVLZhnZfiv/pQg==
X-Received: by 2002:a17:90b:1a86:: with SMTP id ng6mr1959703pjb.113.1610419549028;
        Mon, 11 Jan 2021 18:45:49 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:3e79])
        by smtp.gmail.com with ESMTPSA id x1sm977548pfn.48.2021.01.11.18.45.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 18:45:47 -0800 (PST)
Date:   Mon, 11 Jan 2021 18:45:45 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, haoluo@google.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kselftest@vger.kernel.org,
        shuah@kernel.org
Subject: Re: [RFC PATCH bpf-next 0/2] bpf, libbpf: share BTF data show
 functionality
Message-ID: <20210112024545.spoxpownh5dybffa@ast-mbp>
References: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610386373-24162-1-git-send-email-alan.maguire@oracle.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 05:32:51PM +0000, Alan Maguire wrote:
> The BPF Type Format (BTF) can be used in conjunction with the helper
> bpf_snprintf_btf() to display kernel data with type information.
> 
> This series generalizes that support and shares it with libbpf so
> that libbpf can display typed data.  BTF display functionality is
> factored out of kernel/bpf/btf.c into kernel/bpf/btf_show_common.c,
> and that file is duplicated in tools/lib/bpf.  Similarly, common
> definitions and inline functions needed for this support are
> extracted into include/linux/btf_common.h and this header is again
> duplicated in tools/lib/bpf.

I think duplication will inevitable cause code to diverge.
Could you keep a single copy?
Take a look at kernel/bpf/disasm.[ch]
It compiled once for the kernel and once for bpftool.
So should be possible to do something similar for this case as well?
