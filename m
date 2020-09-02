Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF625A56D
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 08:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgIBGPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 02:15:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726144AbgIBGPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 02:15:07 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60AD4C061244;
        Tue,  1 Sep 2020 23:15:06 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id mm21so1856125pjb.4;
        Tue, 01 Sep 2020 23:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=7UexMl4Oz9FPSyV+T67D6cz0OdUMIiPQjUqcVWaXsGQ=;
        b=GUNAzZkpecE92/CDBLaZgdVB3RrJt39Lo7RvumJAh+07vh239+s5SmaDRMP7Y5ivo0
         qlfr4Yymf/ia4jkUiuGP7sc+l/05Z4ZRELPxP0I/x/ywlt2BsglVz8xcU+ZHS0b3Lspj
         787WnOsMf1+EEfrUQE2zus+9DkjLuemMSkgeXoQpnR5k5cVhddLGQlD4I0qUJS3UOQDZ
         QkMXIVk/BPldPIcniCpGhDs6XVW8vc7chb72NvDqLD4GXq5vQSkuSARpHsUUnFHEJ/+A
         un6x/dYEfFINTo4EnAdRlkd+YdEOhjuL2/em/pU06zVh7R84FGVTEHQ0kGW2j5nEA0if
         RuSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=7UexMl4Oz9FPSyV+T67D6cz0OdUMIiPQjUqcVWaXsGQ=;
        b=BH4PST6jSoeWaIXSkFL++MfID/gY7K/JaZkQMMKQXMr1xtki+/qaTVzfiDKVJ3ZwDT
         Qq8w4dHVWV0RfIsrAQ6OjNdByh/9FRPDuZp6yFM6rfdfVVapIIBobixTjKllROh74CSr
         4DsO/F7DZ2mcduw53ImIrIB5bZb+RNLfFq/5zqeJMe6e76ncwPUSeh8E0hFEZ9MmQlFc
         jBJ/zA5e3CEJ7Bve0AJB/C3m1QLB/TY64ewnNJiQqsioP8DAH9RHezTP8NkSW1MfGOfN
         mgi6DD4t9u8AOjfpqcCf5mul5I7AvNmE/5wzu8jQI+MT4MMhiDSIy5GVe6/X063qAHs5
         vENg==
X-Gm-Message-State: AOAM533ofTs5pbgwiB5c85mmDlPoyRj8llKVkcvCAbF4qsyDTDrspwhY
        kUpjMFSNmAeOCvxBUbuSmpo=
X-Google-Smtp-Source: ABdhPJwIFwbvs0jkx65H9HyddcBDPgvXBsvrP1yzp9EI7UkwnTzcwJrx666RyFZQCC3i4RByRk/N3g==
X-Received: by 2002:a17:90a:aa8a:: with SMTP id l10mr903919pjq.110.1599027302505;
        Tue, 01 Sep 2020 23:15:02 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id n2sm4149342pfa.182.2020.09.01.23.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2020 23:15:01 -0700 (PDT)
Date:   Tue, 01 Sep 2020 23:14:53 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andriin@fb.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii.nakryiko@gmail.com, kernel-team@fb.com,
        Andrii Nakryiko <andriin@fb.com>
Message-ID: <5f4f385de8cd3_5f39820863@john-XPS-13-9370.notmuch>
In-Reply-To: <20200901015003.2871861-4-andriin@fb.com>
References: <20200901015003.2871861-1-andriin@fb.com>
 <20200901015003.2871861-4-andriin@fb.com>
Subject: RE: [PATCH v2 bpf-next 03/14] libbpf: support CO-RE relocations for
 multi-prog sections
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Fix up CO-RE relocation code to handle relocations against ELF sections
> containing multiple BPF programs. This requires lookup of a BPF program by its
> section name and instruction index it contains. While it could have been done
> as a simple loop, it could run into performance issues pretty quickly, as
> number of CO-RE relocations can be quite large in real-world applications, and
> each CO-RE relocation incurs BPF program look up now. So instead of simple
> loop, implement a binary search by section name + insn offset.
> 
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.c | 82 +++++++++++++++++++++++++++++++++++++-----
>  1 file changed, 74 insertions(+), 8 deletions(-)
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
