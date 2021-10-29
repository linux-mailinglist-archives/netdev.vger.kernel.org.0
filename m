Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED0743F6CE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:51:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231864AbhJ2FyM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:54:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbhJ2FyJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 01:54:09 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C61C061570;
        Thu, 28 Oct 2021 22:51:41 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id h11so15059692ljk.1;
        Thu, 28 Oct 2021 22:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=e47xHDKaM01MvOsHRikgqLLV4TYv+/klsDh8VWoFM+g=;
        b=eZ/vMdvxivGA1M9WAuL+qG7yqdGdph8O9bObvAiya5EgPwYWVBLTia9QoVJgGBHbFw
         Ap1EcOZghGGccqYE9macGXaYKvvUCy90IIrEbR0Qct97iLf4CF83QsrpkXNvaZZ+6pql
         YITom8yhIqsqlelvf4Tg4rApsUlx4fsmrrOD8I+96Wb0H1S4MRmIgXEZReIjGQo7Ux24
         5FTRezSWtn1buuhxJjhgU/lxBEv5Ox3H9ow/RYvR7uMugqYUKnTudxgpg6drTc7hSeD2
         3ywxw/pRyBPQFtniclXCJPadKhdwD8SpL/T7YYoEED/BSP9qFPCMXyFN5MZy9/Ewmwvb
         kAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=e47xHDKaM01MvOsHRikgqLLV4TYv+/klsDh8VWoFM+g=;
        b=QhkEO2wSDlwX96nA//PVXId9+Q1SHDlcR75C76JIkHCetXV/rsfO+3/CvMWDO34sLE
         5w+CwPzJZ6YOZo4WZkN2uOYLKOnifja6/UymoFDaLEWfFlMaQQ98QqLhEm6PZrbhkYtd
         CuXfYpOMHwa152eXawW8gO5b3Vzl95fQWtETGEOTySASXTBnP381tVxZNVidzd+bT78y
         E+p7CjzeABwOS2lEmZmb/LQ4IFisi2xP8gyWOQRXNIibHbwQtrogyJf2q55JT35JvqPt
         H9bGZ5BxRi4n/CaUsO9VZfRQV7lgYGjeq6+EbkBXbwNU348fZJvonk/GLcDfE/Ws2u9X
         +Keg==
X-Gm-Message-State: AOAM532I/W3kY4eaxK0BOR2d/26p3zHNfZPvRsBda9mtDfNwzqh99kVW
        3MWiG7JQA8qyFMrr1lyqgWRmLb87j1Hah2CxSG5xYTtdRw==
X-Google-Smtp-Source: ABdhPJxhebn/iC3Zqkl3b126LLZ2zLZQlPF2ENb8QdQD3y4DDgOFsj9+OxTni2iT0NQ8aza9/a2j6TOCNhKlsMwze/M=
X-Received: by 2002:a05:651c:160e:: with SMTP id f14mr5332305ljq.379.1635486700157;
 Thu, 28 Oct 2021 22:51:40 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <CAADnVQK2Bm7dDgGc6uHVosuSzi_LT0afXM6Hf3yLXByfftxV1Q@mail.gmail.com>
 <CAGqxgpuB_L519RK6mGUrt9XTHnYJTrZY9AuQqgQ+p196k+oE1g@mail.gmail.com>
In-Reply-To: <CAGqxgpuB_L519RK6mGUrt9XTHnYJTrZY9AuQqgQ+p196k+oE1g@mail.gmail.com>
From:   Rafael David Tinoco <rafaeldtinoco@gmail.com>
Date:   Fri, 29 Oct 2021 02:51:16 -0300
Message-ID: <CAGqxgpvC2W24NGTVBoxSgcsifw=_6kbv6wOagHva9LUZyDjOjw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] libbpf: Implement BTF Generator API
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Have you considered generating kernel BTF with fields that are accessed
> > by bpf prog only and replacing all other fields with padding ?
>
> That is exactly the result of our final BTF file. We only include the
> fields and types being used by the given eBPF object:

A full explanation on this here:

https://github.com/aquasecurity/btfhub/tree/main/tools#how-to-use-libbpf-co-re-relocations-to-build-a-btf-file
