Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682DD3FCAFF
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 17:46:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239540AbhHaPq6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 11:46:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232421AbhHaPq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 11:46:57 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEC1C061575;
        Tue, 31 Aug 2021 08:46:02 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e7so1474942plh.8;
        Tue, 31 Aug 2021 08:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pJp0Oav4zdeje01ztEu8Mt47FJ5/8125TD17CR+t0zs=;
        b=I4sctsiUNkfFQXsd9vZZ/PUhOlM6hlWE4xhk5Tt1nfcnTY/z8ub+0q1U6/oNOiz3Lf
         MULTVa4uWHkRjoJUP39zGVmnPTmH2CNj4Ffd7d59aqMnuJbsCIK/3a07eqaka06fnRh9
         3p9mIMujTL98BxZyrplmODV2OixV0x9ov2cXJVZ1XO2tQ+LooZ3Wg0I20Hg4u0L7AK4n
         z5O40uSzTBPzAiD3PtFUktSHTIlJL9fFR81hBNE/OC0OfN5w3VcK3qSYAXOoH4x82f3b
         yvC7HYPPxynHzAJ5Ctj9bGReL1ud6EvCH4xWLwU7rmFJqbgeu/mJ6KJqoxrKnXQ4MmmY
         K6Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pJp0Oav4zdeje01ztEu8Mt47FJ5/8125TD17CR+t0zs=;
        b=IBaH7qHm5ewFXr/4P2VU6EgEHTUuLSmEp4HXt641anoOn6qy+ExrlLydQEizYNxRMn
         RHR9P7GHYey7dQKN5nv0I58wrF8vCLPwNNb0Ki6nU5vyVHESOS9fca5cSHHwIZrXwpsy
         zFsJVkaFCfvOwtafKgp8+EJMDWhjp6/AOZF6yHnHh4ym3RKyq5g2EQMlBSF/3HEiDcsC
         5rXZeQr80dWdjp3YXJU/fC6IhRBsdAebqSBayBFNdDabxJMWH85kxYx8eNatNx/7hZg6
         76xoOABvBQqeugVWKdlD7CDqgVtGT4qL5F51aSq2ybKwfU1RJSgTuD9/SctBbDUmZQqE
         autA==
X-Gm-Message-State: AOAM532BW2BcDxwn9eWMwlyCLDQeDtfHxQAmRp9Hj20RHw/Dzh2VFiRn
        ktPwO04CvXqVE3CZNQ7gh2AzerKrh0aU0T5dKPU=
X-Google-Smtp-Source: ABdhPJyTc8RbhdDDoPKnMNUxPw7c5JshvE+P9nkrG5wBy1/eJKipC794XyC5x4YZkzf3svfpRqLYbOvyeEhPZlyLI/8=
X-Received: by 2002:a17:90a:cf08:: with SMTP id h8mr6170695pju.1.1630424761902;
 Tue, 31 Aug 2021 08:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210829183608.2297877-1-me@ubique.spb.ru> <20210829183608.2297877-13-me@ubique.spb.ru>
 <20210830194545.rgwg3ks3alikeyzx@ast-mbp.dhcp.thefacebook.com>
 <20210830205443.wx3n2bhw44pji2hn@amnesia> <20210830234515.ncvsdswj4lalgpo3@ast-mbp.dhcp.thefacebook.com>
 <20210831125240.sm3ouie6hxur5cyb@amnesia>
In-Reply-To: <20210831125240.sm3ouie6hxur5cyb@amnesia>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 31 Aug 2021 08:45:50 -0700
Message-ID: <CAADnVQ+H091MfKC724K7FzMXtHdb5HdUK3EigqMbzEvR0YVS+w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 12/13] bpfilter: Add filter table
To:     Dmitrii Banshchikov <me@ubique.spb.ru>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 31, 2021 at 5:52 AM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
>
> Is it ok to add an external dependency to tests? The unit test
> will need to execute iptables binary.

Ideally not, but sometimes it's unavoidable.
iptables cmd is generally available.
selftests/bpf already have few tests that shell out to it.
They're not part of test_progs though.
