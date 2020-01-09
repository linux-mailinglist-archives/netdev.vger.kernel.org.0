Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11AFD13607D
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:51:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388568AbgAISvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:51:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:35958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732156AbgAISvf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jan 2020 13:51:35 -0500
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 210CF206ED;
        Thu,  9 Jan 2020 18:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578595895;
        bh=tKJje9+dp03GEJOfiL5sNBnC71wvGbWqSo1RqXFHWrk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=G1Kcuv5hplswtZqY0MGFmhl9eDWjOf+EIWuvIHhfuJNDH5Zsi5lFbqxGNAiJeqvGk
         Oc2UkkIZVEl+0HcQ1Ccyg70zoHEB8EP142nw0f1DkZk+3x5xuRSNvg8gBhur2guX0l
         yr8qmoXdFvLKrs3BzSJesNURHh6Jw31MZgvH6yb4=
Received: by mail-qt1-f171.google.com with SMTP id j5so6725488qtq.9;
        Thu, 09 Jan 2020 10:51:35 -0800 (PST)
X-Gm-Message-State: APjAAAXvQK7BnfocmsLeBWe6M11fkHVZHgJQOBpYGaSaD4EVcXAv6vfl
        w8HQyojCXbkkW533Ryk8lPzSyZUX3yikpbMLnEI=
X-Google-Smtp-Source: APXvYqxo/pCQoSlNVLx5fqqsy3W7SNjM/P8PZtgXsWcR6gzhf7FjdxtTyIRVFR4Xl8WjiwkDaY97KkQS24NhbwNWTo8=
X-Received: by 2002:ac8:6f0b:: with SMTP id g11mr9290798qtv.308.1578595894339;
 Thu, 09 Jan 2020 10:51:34 -0800 (PST)
MIME-Version: 1.0
References: <157851776348.1732.12600714815781177085.stgit@ubuntu3-kvm2> <157851811621.1732.15187089912852035409.stgit@ubuntu3-kvm2>
In-Reply-To: <157851811621.1732.15187089912852035409.stgit@ubuntu3-kvm2>
From:   Song Liu <song@kernel.org>
Date:   Thu, 9 Jan 2020 10:51:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6TDtB8Rw9toznYfxkypYZUU-ddbicms3n_FOeFJjv-5w@mail.gmail.com>
Message-ID: <CAPhsuW6TDtB8Rw9toznYfxkypYZUU-ddbicms3n_FOeFJjv-5w@mail.gmail.com>
Subject: Re: [bpf PATCH 5/9] bpf: sockmap/tls, msg_push_data may leave end
 mark in place
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 8, 2020 at 1:15 PM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Leaving an incorrect end mark in place when passing to crypto
> layer will cause crypto layer to stop processing data before
> all data is encrypted. To fix clear the end mark on push
> data instead of expecting users of the helper to clear the
> mark value after the fact.
>
> This happens when we push data into the middle of a skmsg and
> have room for it so we don't do a set of copies that already
> clear the end flag.
>
> Fixes: 6fff607e2f14b ("bpf: sk_msg program helper bpf_msg_push_data")
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
