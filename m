Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42678221998
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727042AbgGPBoV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:44:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgGPBoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 21:44:21 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C87C061755;
        Wed, 15 Jul 2020 18:44:20 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 80so4042682qko.7;
        Wed, 15 Jul 2020 18:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=naPN2pgn1CoFHy/WdyHRlNwNE91H2f4tM8G4xjO1cYM=;
        b=MtQw+LV6ZE3aEDfRev6QNVAddubjs9cHJMCluny2VebrGrLsJ1VODqiVNlRC/Kjk5K
         6k3zng+M9Cvn2T2kXIpSlMRkzXm2aVpisq8uw6S2J4oFmLTgxoAh6bD83H0xZOEJn+d+
         1uz5JHGHO1CoKHF2TsJgXAtDUfg9Haslgzj014Z1AqD2iBdJNgR6otkDtY+qXE8VwgDH
         3WYaFjE2wNX3cd2C6fdqpGX2AYDGWsm8AfbpVMm+oVgO3Gs62sjjUYR7m6yRmXr3ZOPg
         u45QzpMtcktoI6U5WBqSDn1eIybCfCi/yz90RlUgzag2ObSeMwzqgZJ2pSQt3R8usUST
         5ePQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=naPN2pgn1CoFHy/WdyHRlNwNE91H2f4tM8G4xjO1cYM=;
        b=CJeNkBM2JhyrOw2NLw/XACkyeG3Y2i+qznd1z5OqJlCcOUEyitE2pfstX07uU1GS0+
         sdnnwvp2Q8k8s1lfb7bqpJppXx9eoCdcCb88P4q8xwhsIBC0O/dqy4ywH8i3r1DS9o3h
         mXM8WfpThFw4Iz6gWpfJSXEnfSAZ+ZiMhTtjRLjq0ZB0iCHsF3QtLpGYTQlvdtr3DZD6
         iUycQsRfBoSdCF+wWg1iVU3o5b+uNLO8L7+45n/MRbgCct64chlBa5+uXJvkdo3CWQez
         OFqC4mDBrObiEl+znq5yYRAsWfnJh4GhA7Pqj/kE9WIoofSV5gjnvgfnJm3/1spqvRMF
         sGtA==
X-Gm-Message-State: AOAM533u7NnhEwq63zDETY8TT5XZUWbUYVaiqtgSI7qypZDSW0Mbdwyx
        PrzFmc1wLyNERdRIrQgP9O9P/724I7DHJPSkETg=
X-Google-Smtp-Source: ABdhPJxIUHOM9w9p8pN06EvoRA2Rt7MQhI6pm3DnNVOkNOjH4MIPP1+FN1gT3cylnO8cgq9yN6w3s8iipi5CKdFrbbE=
X-Received: by 2002:ae9:f002:: with SMTP id l2mr1867467qkg.437.1594863860064;
 Wed, 15 Jul 2020 18:44:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200713174654.642628-1-jakub@cloudflare.com> <20200713174654.642628-4-jakub@cloudflare.com>
In-Reply-To: <20200713174654.642628-4-jakub@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 15 Jul 2020 18:44:09 -0700
Message-ID: <CAEf4BzbyqcqJyqLxvzVEms0oGmXdact_78JH=rhC5450_OFkHw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 03/16] inet: Extract helper for selecting
 socket from reuseport group
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 10:47 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> Prepare for calling into reuseport from __inet_lookup_listener as well.
>
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  net/ipv4/inet_hashtables.c | 29 ++++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 9 deletions(-)
>

[...]
