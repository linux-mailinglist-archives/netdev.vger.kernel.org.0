Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C80C22FB37
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 23:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgG0VUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 17:20:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:47632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726110AbgG0VUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 17:20:08 -0400
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FDC620786;
        Mon, 27 Jul 2020 21:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595884807;
        bh=6j3NXKDPyNMzvr0aZkCKTa8GIyTcECwWsas17kFPnK4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=EuUPUNM4VRJeCvDK0x0hQcezKxXd9FqjM60MZm1TpLfnmcDzn6F9peR1oEUns/ciO
         p1bYVGTXAyGUlb7Z2p7oibdguUBXvZknHXNiUbDBEVtXDM9TXRu6P7MbCQp0YRX3eN
         CkXTcD/gnvBkXccKAmUy6eiybdm4TL7jeG7N3/ik=
Received: by mail-lf1-f51.google.com with SMTP id i80so9785004lfi.13;
        Mon, 27 Jul 2020 14:20:07 -0700 (PDT)
X-Gm-Message-State: AOAM532XYi/N9uEWXdZkd2vz7rCb1qxneeVGS8RbwskAsjwhA4FpD3pD
        B/yR64IhWOM+21Y0KSRecXG4l/gbFz1ExmZFIXk=
X-Google-Smtp-Source: ABdhPJxYevQx5HJlpLMRKc7Lis17ceeicmScJMM2zZlJWrUx5YzR5CryZbtFdTPMtBiI2bwHwOlEfDBKEg0X1XVq0j4=
X-Received: by 2002:ac2:5683:: with SMTP id 3mr12397793lfr.69.1595884805753;
 Mon, 27 Jul 2020 14:20:05 -0700 (PDT)
MIME-Version: 1.0
References: <20200724090618.16378-1-quentin@isovalent.com> <20200724090618.16378-2-quentin@isovalent.com>
In-Reply-To: <20200724090618.16378-2-quentin@isovalent.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 27 Jul 2020 14:19:54 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7O=ScckAzDJCxgokR=VnwtQJayr8_0+PMQAbMJLKRNBQ@mail.gmail.com>
Message-ID: <CAPhsuW7O=ScckAzDJCxgokR=VnwtQJayr8_0+PMQAbMJLKRNBQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] tools: bpftool: skip type probe if name is
 not found
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Paul Chaignon <paul@cilium.io>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 24, 2020 at 2:07 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> For probing program and map types, bpftool loops on type values and uses
> the relevant type name in prog_type_name[] or map_type_name[]. To ensure
> the name exists, we exit from the loop if we go over the size of the
> array.
>
> However, this is not enough in the case where the arrays have "holes" in
> them, program or map types for which they have no name, but not at the
> end of the list. This is currently the case for BPF_PROG_TYPE_LSM, not
> known to bpftool and which name is a null string. When probing for
> features, bpftool attempts to strlen() that name and segfaults.
>
> Let's fix it by skipping probes for "unknown" program and map types,
> with an informational message giving the numeral value in that case.
>
> Fixes: 93a3545d812a ("tools/bpftool: Add name mappings for SK_LOOKUP prog and attach type")
> Reported-by: Paul Chaignon <paul@cilium.io>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>

Acked-by: Song Liu <songliubraving@fb.com>
