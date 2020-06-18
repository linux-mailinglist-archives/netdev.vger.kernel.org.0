Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45FEB1FEA8C
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 07:01:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgFRFBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 01:01:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgFRFBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 01:01:13 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55FB7C06174E;
        Wed, 17 Jun 2020 22:01:13 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id c75so4534528ila.8;
        Wed, 17 Jun 2020 22:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Hmlgb0kshx2wMfxkcoful6TZ5DnpZrqmHttLkGE0Vww=;
        b=V7fKP5QKisZa73lR+j+mb8Jl7UQGqcX9UbEqzE44iEc1meYhzKmIqGDEwuKI6ZVG/7
         F5RHdtegSJgwmNnSVJDiHOOYMT0GfdTDtZe6yoY3rAuAJULlYsZ0E37FZx2H9T5yRWuc
         qQ1uJIjeyxBJ2TJInTPmGp9yd4sU3kQi3Az2dvMAbKfYXV67+JPxgLTm3FDhzoSMPvUZ
         IZIn761JXoL21cX3LIcWb4Q3Z6IWRzjMjDoWnMXb9CprUeDa51lw9WNoHPgcMS7mY17M
         DTc+VMn0d3ph3TrIVwcXYllI4kxAemwLGLBlqrf8J3TF3IUqS4f2b/7794SvlgAHcTpJ
         iVvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Hmlgb0kshx2wMfxkcoful6TZ5DnpZrqmHttLkGE0Vww=;
        b=CEoyS7JO74qTVIFhSn7JmaGBnnqUbURfOn3JqAHG6rbTQ+fI91OFBaA8kk4qIFSJsw
         Vqu82kvigyObTgSwwQFzHrj+eFPS1YD3Ym/k+xH5a6Yi4Jcbl2sRFgNZmrnhugNGUkXF
         Ge2+qUB/RBkGFI6C3fJqvePGowZevcKmDDl7yZjjmsna06i8AzxTGObdyy6oQdAh2ZvZ
         QT9NP5aoLrexJG2I/8I6cdeRjxNXLhN+loyCz6JdXokdZ8nT+hJbKDWhAMdWAbCmsQbT
         HBrNeda1QB8m7ANt7W9nmNHzJGj2Jl7QXsdLuAAOcFKEtfhKD9MPjAuioTsJFgGjuMHg
         UpAQ==
X-Gm-Message-State: AOAM531Nq7Uq4pmVaCPTRJIoUEehkNp6tLktjAG5On++i+8yLWl46/xz
        IDnTg3nrjl9eocSy2/GLAgc=
X-Google-Smtp-Source: ABdhPJznI6iUQnMasNuNUdSCyYZBMz5VAwwcadz//pZMiqmXGQa98geqeEdgx0Tl+iiD082r/zWyoA==
X-Received: by 2002:a05:6e02:f44:: with SMTP id y4mr2423963ilj.237.1592456472735;
        Wed, 17 Jun 2020 22:01:12 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id y5sm911010ilp.57.2020.06.17.22.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2020 22:01:11 -0700 (PDT)
Date:   Wed, 17 Jun 2020 22:01:03 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Martin KaFai Lau <kafai@fb.com>, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, kernel-team@fb.com,
        netdev@vger.kernel.org
Message-ID: <5eeaf50fec904_38b82b28075185c44c@john-XPS-13-9370.notmuch>
In-Reply-To: <20200617174226.2301909-1-kafai@fb.com>
References: <20200617174226.2301909-1-kafai@fb.com>
Subject: RE: [PATCH bpf-next] bpf: sk_storage: Prefer to get a free cache_idx
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Martin KaFai Lau wrote:
> The cache_idx is currently picked by RR.  There is chance that
> the same cache_idx will be picked by multiple sk_storage_maps while
> other cache_idx is still unused.  e.g. It could happen when the
> sk_storage_map is recreated during the restart of the user
> space process.
> 
> This patch tracks the usage count for each cache_idx.  There is
> 16 of them now (defined in BPF_SK_STORAGE_CACHE_SIZE).
> It will try to pick the free cache_idx.  If none was found,
> it would pick one with the minimal usage count.
> 
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  net/core/bpf_sk_storage.c | 41 +++++++++++++++++++++++++++++++++++----
>  1 file changed, 37 insertions(+), 4 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
