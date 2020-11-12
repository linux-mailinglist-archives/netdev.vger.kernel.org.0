Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E7C2B109B
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 22:48:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727377AbgKLVsk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 16:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727362AbgKLVsk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 16:48:40 -0500
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF973C0613D4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:48:39 -0800 (PST)
Received: by mail-lf1-x141.google.com with SMTP id s30so10758435lfc.4
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 13:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XMzqJA/g9Ml7RxT+L6FzvTPiS/+31o715qZjyZXr5zU=;
        b=oLWtIOgcOxfLPFvmYnAFCgB8c+9fYXFPie/NwYZXsok/aOldLI269ARRTY6UlCxI5O
         FpqPts307UBfm9w45JEN9/LuLP0b+i/4/AeMhYeeUGXsMBwrCrEdHvdz9zwBgdGxQXXU
         UZ9pktXlrVxd8oCN/wbzIpqNA3RgwhFz8r0+g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XMzqJA/g9Ml7RxT+L6FzvTPiS/+31o715qZjyZXr5zU=;
        b=kXI0sHZMy3VHKLsKv92icgYG7BquB8AHy/Yz6rf5Tu/dcCwUL9UmnI2vwDTPtnVrfn
         9TP+fV/eSBUYUPsdzCmhJ3DqWZ+7ZGXZBzNIzutC8+wWQ4S4YhMPCFZzofkrWXfewwqo
         KXEGbmWrMK7oLhhVoFFJl92C55pP4SzyZpx4+L7UOZueGJz+voKjVa+g2ZMaWfBoibB9
         1lIp2tETPj7yCmLeD+a2IrP/Uf4I5h7JICH4py/cG4X/1PtyHbr3pgKi7rFZBJkftQpe
         2o0bUBrX/vCVeV2LMElt3XLQY+LA7MVWQd/nyV5o3OziTZEl9/S5Jwkpz04/I/vEMBBj
         ArxQ==
X-Gm-Message-State: AOAM5318L6Q6Sa1HTDLARxD9rfbL4nIAVN7lXNIUXxCUO+OoQtZH0OQH
        kk4myLqH921Nm8278kKVDuzN2I6QVa8BvzVVFiuiEUdFWvMIFfrdVgI=
X-Google-Smtp-Source: ABdhPJxxVc0EpNEqKkjp6k4LbJ4UaAhnD8TWopQsK2vPo50HFDLbAOTVSasb9CLUy3tsARW501FMNkIfcnRHz8wkpaQ=
X-Received: by 2002:a19:4a:: with SMTP id 71mr554171lfa.167.1605217718402;
 Thu, 12 Nov 2020 13:48:38 -0800 (PST)
MIME-Version: 1.0
References: <20201112211255.2585961-1-kafai@fb.com> <20201112211301.2586255-1-kafai@fb.com>
In-Reply-To: <20201112211301.2586255-1-kafai@fb.com>
From:   KP Singh <kpsingh@chromium.org>
Date:   Thu, 12 Nov 2020 22:48:27 +0100
Message-ID: <CACYkzJ6ppfsvX9_ujSCg2r0=b8bP4O2QX_HL_kuURvw8pY96qA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/4] bpf: Folding omem_charge() into sk_storage_charge()
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 10:13 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> sk_storage_charge() is the only user of omem_charge().
> This patch simplifies it by folding omem_charge() into
> sk_storage_charge().
>
> Acked-by: Song Liu <songliubraving@fb.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Acked-by: KP Singh <kpsingh@google.com>
