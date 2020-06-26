Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF1C20BA42
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:25:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgFZUZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:25:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725803AbgFZUZG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:25:06 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F7F2C03E979;
        Fri, 26 Jun 2020 13:25:06 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id u17so8484500qtq.1;
        Fri, 26 Jun 2020 13:25:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NBqm8jgamFb8FzuxrY5iFPmnyDDUNz7yB3Mxq5DaXeE=;
        b=THC3JCJlztphofDqFUKkBPTQQKGgLgAFFYrBov2gUzR4rMiRsIYAvAEW/HYeW9E4hu
         CIlVYubea9rg3yhVlw6cEahgYB5BZ0EtbifFs2Krl2T0FdaPs9jCxP+0RKjcfP/rokAN
         l3bOOwE0kaN/gm1/tLP/kecON3oJF7AwVwlubNx49YdubnKD/m3OWGnvMQDolwoCl7Mq
         KGeOu2PDd2u8xdEt2Ki9R/mzlmSR28X3ZIunp/A1r7JQMH/7L+EIRAnaq1h7HsJTBBYa
         gZGmuDYXgq5Fv/xnOxWzqVR7N4UD4NLTXw6l+DbuNOmeJGQRqiAuqLUHPkfs+nJSDboc
         tYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NBqm8jgamFb8FzuxrY5iFPmnyDDUNz7yB3Mxq5DaXeE=;
        b=n5lFWIBMxReYhqU8tRrDLU9eIciqHsMYmCMmFMIhIfOmht+3NqhH6wVTncB0lUIaz4
         qMeg/vr1oSuFEWhY+mM7cZIdtNiWS5Y8uawdf5M1wyd9b0fmdw2GFAAfIGTQR3uyPzrL
         /bcJrEyyipHt2/yrfaSxJTGw2oSas1moivBPSEXpCbZeOI/Ap5vjGbDHN+I/EnbYiPvD
         +uBrgbEqf0iYqil8kU7IX4phF6XjY3YNxatgk8l9rV80fZAdqBUSeQa6gOkJdK/uK/nu
         tJB0f4LcRdz2PQOcbHYAq/x7Kk1rg0pAdKz07UDwaBmohIGEyxASkLOU0odxbFMmkyMf
         P7uw==
X-Gm-Message-State: AOAM532/pdtnUEkjnjlDuOSK26QRCLAr1p60EIxAEPWYjgXXvFRnv9mq
        /8F91hqpUzLFPpTV9n6STxCiQGinQtjrP0TRO0A=
X-Google-Smtp-Source: ABdhPJwt2XdzAcvgIn/7Pu5Gk6aZSVA4K3DYBezPeRbMva46gvq9lcDAAGRwMvOYD3wc5fD3FgiNvVyEB7tlGXApFaY=
X-Received: by 2002:ac8:1991:: with SMTP id u17mr4494502qtj.93.1593203105628;
 Fri, 26 Jun 2020 13:25:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com> <20200626081720.5546-2-danieltimlee@gmail.com>
In-Reply-To: <20200626081720.5546-2-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:24:54 -0700
Message-ID: <CAEf4BzbWboyWH1NzvDT8AHxUs4mEV9tBUOyksGgaJrN7QKJLXA@mail.gmail.com>
Subject: Re: [PATCH 2/3] samples: bpf: cleanup pointer error check with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Libbpf has its own helper function to check for errors in the bpf
> data structure (pointer). And Some codes do not use this libbbpf
> helper function and check the pointer's error directly.
>
> This commit clean up the existing pointer error check logic with
> libbpf.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

This entire patch is wrong. bpf_object__find_program_by_name() returns
NULL if the program is not found, not an error code.

>  samples/bpf/sampleip_user.c    | 2 +-
>  samples/bpf/trace_event_user.c | 2 +-
>  samples/bpf/tracex1_user.c     | 2 +-
>  samples/bpf/tracex5_user.c     | 2 +-
>  samples/bpf/tracex7_user.c     | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
>

[...]
