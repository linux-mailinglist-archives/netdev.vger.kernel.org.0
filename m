Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03E9C312B94
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 09:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbhBHIWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 03:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhBHIWD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 03:22:03 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49384C06174A;
        Mon,  8 Feb 2021 00:21:23 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id f6so14080600ioz.5;
        Mon, 08 Feb 2021 00:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Qbs+ZPZYOplhMksGGYGueYxsgtZWCEBIveGgFou8FGo=;
        b=FKDdrlcMlEb765ACEyfEfa2AS/UOheZC9GyUADZPKTz0VQ0mez7zDQLTaQnCagiXdH
         MoovO25p7PLQqf092+46itr3asrDIPXsTSduWmkhFlJC00X2b8KYvUyg4m9iH0bbPEiq
         SyD9rRQ8HNQjLXxTEN3xgYOjcWBHE6FvIBvzlSFKb00Aujeg+mtXh+s1p5wqZwK54T5b
         xZpgUPUFTNvukd0hu7rnOXSoytVE2Sn+JcdhT3GQqT4dNztNFJiW0jFviD3gjLNIS9Z7
         ioRscgpmcv+os3dWbxnl8NM1N5nAfMvfST9GP4lB0IujamCKbKw2WItNaNadgaMX08b5
         4vcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Qbs+ZPZYOplhMksGGYGueYxsgtZWCEBIveGgFou8FGo=;
        b=RwyzrkD0VwkJmoMngrmNkA47/AxQhgKNJsr8EFE3O3Q67TV8VzSBs1UwNaC7kPcuDy
         uR3ELrNc8EKREmRxPmemUHKgNPJ6TJDq9kvKytaflBEH8dtS6XzNu/eXWqd34DQdUTF4
         MzpRbuWCW21thYfryCXRpL9UTgEi9OlYBKWJA1vxfxiKXxVcNsTKLfIbzOwSrn9m0M7V
         hydxJjR9UP23IcqtgcjpLjNwb6Zh71gWLnRiMI0KTzG1ZBLMT/l0vd8pdsBw2GQuXVMO
         G0XQvsY494U821KuYKl8B0OP3hUhyGopd5GGKz4x5QmNaDtWGheUdeTrObCx1gUZLSrW
         0l5Q==
X-Gm-Message-State: AOAM530bOM483jlpOwZaPO0rOCAlhX11jT7uv0+oUeFfcpxbBIRlGFOw
        NSw6G0zpVgPFR6n/UGjm+MY=
X-Google-Smtp-Source: ABdhPJx6v+YSPQLvBT6Pt8P61K67QZpAjShsnqF1b3PzbBQk28sowIcbvuEkfjD89cH2vWmnN86WNg==
X-Received: by 2002:a6b:ed02:: with SMTP id n2mr14601498iog.80.1612772482670;
        Mon, 08 Feb 2021 00:21:22 -0800 (PST)
Received: from localhost ([172.243.146.206])
        by smtp.gmail.com with ESMTPSA id g6sm8489729ilf.3.2021.02.08.00.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 00:21:21 -0800 (PST)
Date:   Mon, 08 Feb 2021 00:21:13 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Cong Wang <xiyou.wangcong@gmail.com>, netdev@vger.kernel.org
Cc:     bpf@vger.kernel.org, duanxiongchun@bytedance.com,
        wangdongdong.6@bytedance.com, jiang.wang@bytedance.com,
        Cong Wang <cong.wang@bytedance.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Message-ID: <6020f4793d9b5_cc86820866@john-XPS-13-9370.notmuch>
In-Reply-To: <20210203041636.38555-2-xiyou.wangcong@gmail.com>
References: <20210203041636.38555-1-xiyou.wangcong@gmail.com>
 <20210203041636.38555-2-xiyou.wangcong@gmail.com>
Subject: RE: [Patch bpf-next 01/19] bpf: rename BPF_STREAM_PARSER to
 BPF_SOCK_MAP
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>
> 
> Before we add non-TCP support, it is necessary to rename
> BPF_STREAM_PARSER as it will be no longer specific to TCP,
> and it does not have to be a parser either.
> 
> This patch renames BPF_STREAM_PARSER to BPF_SOCK_MAP, so
> that sock_map.c hopefully would be protocol-independent.
> 
> Also, improve its Kconfig description to avoid confusion.
> 
> Cc: John Fastabend <john.fastabend@gmail.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> Cc: Jakub Sitnicki <jakub@cloudflare.com>
> Cc: Lorenz Bauer <lmb@cloudflare.com>
> Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> ---

The BPF_STREAM_PARSER config was originally added because we need
the STREAM_PARSER define and wanted a way to get the 'depends on'
lines in Kconfig correct.

Rather than rename this, lets reduce its scope to just the set
of actions that need the STREAM_PARSER, this should be just the
stream parser programs. We probably should have done this sooner,
but doing it now will be fine.

I can probably draft a quick patch tomorrow if above is not clear.
It can go into bpf-next outside this series as well to reduce
the 19 patches a bit.

Thanks,
John
