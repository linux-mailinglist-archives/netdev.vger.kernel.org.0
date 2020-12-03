Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 136C22CCE59
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 06:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbgLCFMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 00:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725872AbgLCFMS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Dec 2020 00:12:18 -0500
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17923C061A4D;
        Wed,  2 Dec 2020 21:11:32 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id k26so996816oiw.0;
        Wed, 02 Dec 2020 21:11:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=mStopwWOz0xIkkpl/15MvqpRuIjXn/ImyaZMizzR1G4=;
        b=NtvPoPeK28VfmXBWFIAumDi3dvlGUik5EDInliq87yqIkkVoVgLF+OqL4Wz3j+9kUq
         KKzu2G9VALOVGsWB+B6RaQfOa7ooPqa45PWz0VIdgcZjStaFmtNMzNHhrS8OxaixCc1P
         lvE6OwqYjF0Ayl81fZS87hpKoUPWeYSnMgVoDrSDFUHU9IIlcWliizKGWZY+ZB5KMbmT
         JBBLnaslLz/tJeVi9HVQQR4Ft+6WmWB1jfefn3JkwfuWXCz0WVEkiwU8FkRpSxTTfri7
         7dxE9Oon2fLu0o1oojVMd4FjjzfN6P23byOMUF+JYs404hPOs+X6i1gGWLFI/t66+hLf
         CPAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=mStopwWOz0xIkkpl/15MvqpRuIjXn/ImyaZMizzR1G4=;
        b=UzirvC/jhVx66FEfsI0/wU3EqsjHWu0+JxAFJ8t8ua7S6451CCsivUH5bSSaHb6PZv
         z2LsgBe690BJfqRvnEFaUr66nncpwilA23bZum2HXQIsjE16mPBRlTI40USCPgInLzga
         Yv7XBPs1MSSVIJQ1SDkh4+gEAYfhmF3y0axtw/RoXRvTpSzt4gsMnO6l9jRlMwxjS01F
         r6s9MuQmDHbvNkHE9+SIW5hagmTLmk7w37V8xD1aPgYJf0a+NhQjNPdatVP19GofuiV4
         kT7rh4Iq3bz1hfT8wuRiKs1HLEEB9CpS2KwalU8/SGSbNL4kAug2xsP/hh4xKhVhgsJM
         mSVg==
X-Gm-Message-State: AOAM530i0OKw2WeLpoN5O57cnUPV0LYAhqwL/IWlyGn/9DilYawv5Umv
        4CbzJvQIkTeq/YXLuqp8qwU=
X-Google-Smtp-Source: ABdhPJzRVvujUEPtUAa6HqZaftP+coqFmiMHhvAd/BLNXQk6BDnmHsFKUqGpXbSPvq/qSbAftAvgzw==
X-Received: by 2002:aca:6287:: with SMTP id w129mr830660oib.82.1606972291597;
        Wed, 02 Dec 2020 21:11:31 -0800 (PST)
Received: from localhost ([184.21.204.5])
        by smtp.gmail.com with ESMTPSA id w66sm90067oib.0.2020.12.02.21.11.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 21:11:30 -0800 (PST)
Date:   Wed, 02 Dec 2020 21:11:21 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, ast@fb.com, daniel@iogearbox.net
Cc:     andrii@kernel.org, kernel-team@fb.com,
        Martin KaFai Lau <kafai@fb.com>
Message-ID: <5fc873794acba_1123e20836@john-XPS-13-9370.notmuch>
In-Reply-To: <20201203035204.1411380-5-andrii@kernel.org>
References: <20201203035204.1411380-1-andrii@kernel.org>
 <20201203035204.1411380-5-andrii@kernel.org>
Subject: RE: [PATCH v5 bpf-next 04/14] libbpf: refactor CO-RE relocs to not
 assume a single BTF object
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> Refactor CO-RE relocation candidate search to not expect a single BTF, rather
> return all candidate types with their corresponding BTF objects. This will
> allow to extend CO-RE relocations to accommodate kernel module BTFs.
> 
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c | 187 ++++++++++++++++++++++++-----------------
>  1 file changed, 111 insertions(+), 76 deletions(-)

LGTM.

Acked-by: John Fastabend <john.fastabend@gmail.com>
