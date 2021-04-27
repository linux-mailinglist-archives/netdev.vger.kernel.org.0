Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A065136BCFD
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 03:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234896AbhD0BoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 21:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232295AbhD0BoG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 21:44:06 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04B5C061574;
        Mon, 26 Apr 2021 18:43:22 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id a13so12555029ljp.2;
        Mon, 26 Apr 2021 18:43:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zp0vZK1HOIEnCaF1j4QvP3uhz9HZEqcrRabmR9n6JD4=;
        b=eaWccpH9BeLVn3z4vXUXlTDN+aKp6mlukx5GQob5DxJJzEmg7grjS8rnh8bgYIQbzw
         WPVkHu002LsPhDGIhgFlmGiZtnJ6ufDKMk2jJZvM4znqrYI178KGaKtv4Wd8SmziGgQi
         Fa5oFh2ObVO1oHGNHq/ncrk6tbbQuzWEtBCp4O5+6MPW9YriWf+Ag9By6Lwu/wNoAyMQ
         CUeTfaq+T6aHtBFsnBhWRN8NPc349grBBY+OVoCcF7wzLs6CPBO7bJ9eZh8Hn+1R0FwF
         m4ZcUkq5ZJze7luZ0irSF9mcwXZxy64AbqQ59LXW5wGIbMRQfS2vdVMtt2CxtELWQVFo
         bYAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zp0vZK1HOIEnCaF1j4QvP3uhz9HZEqcrRabmR9n6JD4=;
        b=U76S6TwlP/ZoNOhwENi5zZSeVz+P0DgueR/iyRAUyp50ZWmRAgwbs/Mhe9YeqmaL+t
         dwuHIsK7woO/bXt3zAXsgxkmkkr3iUtofHz98K4lLnzSa7O57pf+D860g6w3ZBT12oLN
         hNB/M7Kvy8/BT5Iklq7eA1NOI8zisyg39HqB5WrW6t235+WiFhC9DjuBCFrKz847kIvr
         EM2w+ern0xgypC5L913u/x9mJR0GNAV/pQi7HqgzijeT3cVQ7AtfKoM41uaNnjJPFKG9
         hpj8hGfUjLTa0h02aNInkJiy7D2moxj3H97n5u7rXHCeGVdDqSBcbpsTRVl6OQxgAMCo
         7Tzg==
X-Gm-Message-State: AOAM531fWTPqeMUwuZy/eMkZsHWomu8EmfJVYAIU5dzqc2rMS5aG0FWc
        ZY2xJJFmdpFeIFJRyz8J2egkIrFtG8xb3O8zFZ/J7rYw
X-Google-Smtp-Source: ABdhPJwCLbshQTHyEWRT0gUh1x20EkOdO830vSTIjRPVP1Af7CrOmvyGmkgu+wLMXNVteMtkAtQsMGS/xW6wDMePeWs=
X-Received: by 2002:a2e:6c0d:: with SMTP id h13mr14532313ljc.486.1619487800633;
 Mon, 26 Apr 2021 18:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <20210426192949.416837-1-andrii@kernel.org>
In-Reply-To: <20210426192949.416837-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 26 Apr 2021 18:43:09 -0700
Message-ID: <CAADnVQKQ5ZddWKtEbWf16xbN-QXuLP8DZJbHg48y=RyHJ2v8EA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 0/5] CO-RE relocation selftests fixes
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 12:30 PM Andrii Nakryiko <andrii@kernel.org> wrote:
>
> Lorenz Bauer noticed that core_reloc selftest has two inverted CHECK()
> conditions, allowing failing tests to pass unnoticed. Fixing that opened up
> few long-standing (field existence and direct memory bitfields) and one recent
> failures (BTF_KIND_FLOAT relos).
>
> This patch set fixes core_reloc selftest to capture such failures reliably in
> the future. It also fixes all the newly failing tests. See individual patches
> for details.
>
> This patch set also completes a set of ASSERT_xxx() macros, so now there
> should be a very little reason to use verbose and error-prone generic CHECK()
> macro.
>
> v1->v2:
>   - updated bpf_core_fields_are_compat() comment to mention FLOAT (Lorenz).

Applied.
