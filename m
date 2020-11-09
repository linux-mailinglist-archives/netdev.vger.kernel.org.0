Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28ADA2AC6E8
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 22:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730844AbgKIVTL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 16:19:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730621AbgKIVTI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 16:19:08 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5936FC0613D3;
        Mon,  9 Nov 2020 13:19:08 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id k26so11843456oiw.0;
        Mon, 09 Nov 2020 13:19:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mNCXb6okOAQ5bU8t6b7mqJM0F9PZekApdw3/WSH9rAA=;
        b=nfC1W94rW35FMn3nyK0xnllzvWCOqq8GBpcNtezWALYI+7XIMjQge37o0AU0yHsBxC
         y5gbh/pnrhx0kaYd7gx7k3REEPAnCC7tMOVmyFY9mtAVo+wFzRQ1TqyTR3pX6e+L5R0n
         5KBDvSWPpHNncLeAEPnQo2Xh8PPxeeY653c21jzSfv5orDOHnWCqW9hC5KoHJTyuE7M3
         UsYVMOyUlJHMqF1Hg+ZM3vU5XukFZme1ZWHiNF6Tn0D1Mybv97eM98m9+8U0tBXAgSGl
         o8t6EeQoiZwZbbQg2rlDr9g5u71gIRlbgEO9M8U/SwXNJ8wgZNyEUjMAAiPPzlJbs+KQ
         4dLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mNCXb6okOAQ5bU8t6b7mqJM0F9PZekApdw3/WSH9rAA=;
        b=GWZYrXwWtPiezI4BUq/j3tT4x/Baud2pE0pZH5cRMiDQhrmvAsXTo41p5HTPsHKpS3
         At7XWLVcDweLooNK5WlIrluYwaXrK92z66HRfLakYa0ktB/fluEPzhrcIMU8KnOCXapv
         tgyzuu+oW9KRiVhGWrcyu1Pm8iQSQZzT86vWnLKh65j1hNfx9FaDDnQZhQz4Yo+erxon
         a9ieSqNX9vRUOMObV0CvNjacgj502PUQ5HITlhSbM95Ey6tgJSsIACB+IxKXI6kqnl5t
         fbHTLEyxQVWsax3TkFNYbSnXnxG1ws8+bKRbDEfAtAcHX26oRsq53jwlPm+8Xg4EfA3Z
         y7wA==
X-Gm-Message-State: AOAM532X7j7yajhyisKtWBWdhoaJRYWoBbTXWtPXaFJAT2NShWyAVBrH
        9Kc0+v+nlkrHPUXHuMJMAFw=
X-Google-Smtp-Source: ABdhPJxk9AUSFZj+rVipOwvEPHfbYj9JrGpo2jFIelJWkqTEU4c1VA7H4tPKmzo014VdO/vax1EGMA==
X-Received: by 2002:aca:5742:: with SMTP id l63mr763944oib.166.1604956747718;
        Mon, 09 Nov 2020 13:19:07 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id z19sm2697381ooi.32.2020.11.09.13.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 13:19:07 -0800 (PST)
Date:   Mon, 09 Nov 2020 13:19:00 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com,
        Dmitrii Banshchikov <dbanschikov@fb.com>
Message-ID: <5fa9b2442542d_8c0e2085b@john-XPS-13-9370.notmuch>
In-Reply-To: <20201107000251.256821-1-andrii@kernel.org>
References: <20201107000251.256821-1-andrii@kernel.org>
Subject: RE: [PATCH bpf] libbpf: don't attempt to load unused subprog as an
 entry-point BPF program
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> If BPF code contains unused BPF subprogram and there are no other subprogram
> calls (which can realistically happen in real-world applications given
> sufficiently smart Clang code optimizations), libbpf will erroneously assume
> that subprograms are entry-point programs and will attempt to load them with
> UNSPEC program type.
> 
> Fix by not relying on subcall instructions and rather detect it based on the
> structure of BPF object's sections.
> 
> Reported-by: Dmitrii Banshchikov <dbanschikov@fb.com>
> Fixes: 9a94f277c4fb ("tools: libbpf: restore the ability to load programs from .text section")
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
