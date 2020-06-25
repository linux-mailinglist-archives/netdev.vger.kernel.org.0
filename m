Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBAB20A374
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404060AbgFYQ6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404011AbgFYQ6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:58:23 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D483C08C5C1;
        Thu, 25 Jun 2020 09:58:23 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e12so5159019qtr.9;
        Thu, 25 Jun 2020 09:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZpiDSlucUFQRvmc7FiHNrOpX8D4h7Jrs/1Y3EtD3i+s=;
        b=eNa8ldxqE/+IrK+j5WG+FE5m3J2yXAVBWeH/wIBSSEDyq3wwpLjxtyLIrslBnpSqnc
         2H2iJldav5ZBHjqNdbsGD3gxkg+47bTCdlORJ0TuuugpHuXokKt4jL/aPS2fLxm2r8Kc
         MA4JGDjE3ZhBd8Nw/PQeBrZ3d9zEUv4aRQXne7aa3FF8d3supZ0Kvj7uigwYY1E3NcKz
         5PhIZtjNVarspyt/woGKgGRpdjiqQSPG2PsL80b6KaJhaV/HKJSsX66U3qmQjMTxcbdx
         rDRFXaD8TaxnZ6dT32mXTTNFgBE+Syb1byVaDgas7tak05ao7YvuSMkGOEN4c0KWf0OF
         3BJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZpiDSlucUFQRvmc7FiHNrOpX8D4h7Jrs/1Y3EtD3i+s=;
        b=AvH0c4rP2ebIQNYvEnNiomLGQybe2K34KivaBDWUOkpu0ZxB39zcucCjBbjtXU60+M
         lnnQoUrc26oWMe3Jzv16XlyFYR7RV8Vj2kw5vJk1w82A16Cmz+Wc235Aqvg2Ew83OgMP
         mJITaPw60fpwhQgdxgVBmjwvh8zIF+pttt01PdlR2y5UOB4NSKZZdSTGwtX/9b+ig4Zv
         ZjaIlhDrLL9Q7v4SiitKB/9wovZ7RR4e7Kw6UCYU4M/gewnA8gjLbTdW4ibHSJ4CHeU6
         EHU3qfGNk59gXlux1is+p9458WVOXYH01J9VEsguuwo5PydFLv6ReizbNF0OFGdwRldZ
         u5HA==
X-Gm-Message-State: AOAM532C2OBA0CcsElSSueLqmas0SSvBaY4w5UT8l+ccft0+hcJ6fqjE
        wkytTMLZY+Y+VppkhnOOJIgaTDZmebNQZ0L6lPU=
X-Google-Smtp-Source: ABdhPJx53AAuXbpF098PsNGNkRk2rMU8eR0fh7KqtG+1Rzmq8N/z4RkzCAR0R4wbbZtaEunxaxEsfkLsklbTLM9CvLc=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr25457363qtj.93.1593104302781;
 Thu, 25 Jun 2020 09:58:22 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQ+tiHo1y12ae4EREtBiU=AKUW7upMV4Pfa8Yc7mrAsqEg@mail.gmail.com>
 <159309521882.821855.6873145686353617509.stgit@firesoul>
In-Reply-To: <159309521882.821855.6873145686353617509.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 25 Jun 2020 09:58:11 -0700
Message-ID: <CAEf4BzamWwRwrnG0e1n9Fr2ojXtw3f_R5jQeLKUeVrWnCAK=3A@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: adjust SEC short cut for expected attach type BPF_XDP_DEVMAP
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 7:28 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> Adjust the SEC("xdp_devmap/") prog type prefix to contain a
> slash "/" for expected attach type BPF_XDP_DEVMAP.  This is consistent
> with other prog types like tracing.
>
> Fixes: 2778797037a6 ("libbpf: Add SEC name for xdp programs attached to device map")
> Suggested-by: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c                             |    2 +-
>  .../bpf/progs/test_xdp_with_devmap_helpers.c       |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>

[...]
