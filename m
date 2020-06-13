Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8F0E1F7FF1
	for <lists+netdev@lfdr.de>; Sat, 13 Jun 2020 02:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgFMAjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jun 2020 20:39:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgFMAjs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jun 2020 20:39:48 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DB6AC03E96F;
        Fri, 12 Jun 2020 17:39:46 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id 9so13048121ljc.8;
        Fri, 12 Jun 2020 17:39:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0VKrcd9/p9CakrZgNtVhE8F8+3C2DvKyDw9YWgNT+hA=;
        b=o8RysxtcY9fH3657eL8BklqtjYeEVjVvD125xcWPGTt4Pq6TrKNsyK+T1OgKYGCKo/
         H2YTrlDhX8QZrRjnZc28dwHgsXQUGE9mnG15vgTg9P0lcR3xH6wQuZFp8bEToPfn3fs6
         QIoaSRx1hRv4BDA9oSeTt/uZ+gPpNoRDVuafPdmGNp6iZR/PkZfpicQtQ/nN6Can6frG
         EZBPEbrB1Tr8o9FJbl5Vbwkbn+Y+9I4sHWkBnWu431vPOVMKpgAcxlB+hZQCFEi33asI
         /H9xeOJwRCPNozGvk83HK+AGMkWPSvlRhLf5O2qPkRUe++/jC5cqpcvowfUAPulpnKVF
         WpZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0VKrcd9/p9CakrZgNtVhE8F8+3C2DvKyDw9YWgNT+hA=;
        b=g6PZgjcgx8pXLxrDCj4pJ1jHIUrskzcw9qFmBtKXNQ7GvY2VneLNZJSwUwLhgNmPJP
         pGYVNuMkADwVjMM0DdU+mdJ1mGDKoDdoop1DmqPD06XSU3TIRDLs5Ri+QyF80BaaKjiL
         XQnDXV4GGjH9/LrgO4st0XAUImyXTb47iz2RpsknwcwWakxI19RteGHK9YNw7qAAakMB
         Gh8ESy06+QJ9ESIyKM8igxxdbrfQgPqvfGx+2cZSmjvLvPYXUCqsLo+/LcaBqzgQ2KPP
         ACn39g/+uJr7tDWmPIvsxsACMu+8fHzaJ+SGSJA+7TLDzGC4mwokcmZ5CxTqABZebvz2
         zIjw==
X-Gm-Message-State: AOAM533zyN48KKpQM9P4uOGOO9yz6JN/Dh2hjwSGJ5aOI7LwRvOj5XVl
        H2q9A33/iW8qsR2hoaBNY4bwoZT0TqzpF2pwd+U=
X-Google-Smtp-Source: ABdhPJy/aWDUbNDhol1f8C/lxHyLcVzECKJ2ZRLtec1BbQW63+NuK89qPezVrY3aaDNREo7S/+ugTzzYXDY0lcoys68=
X-Received: by 2002:a2e:b1d4:: with SMTP id e20mr7598102lja.290.1592008784327;
 Fri, 12 Jun 2020 17:39:44 -0700 (PDT)
MIME-Version: 1.0
References: <20200613002115.1632142-1-andriin@fb.com>
In-Reply-To: <20200613002115.1632142-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 12 Jun 2020 17:39:33 -0700
Message-ID: <CAADnVQLoj5=efiZRF+PJ5guJD2op2WN82iehd81HcLvG0Zm1dg@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: undo internal BPF_PROBE_MEM in BPF insns dump
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 12, 2020 at 5:22 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> BPF_PROBE_MEM is kernel-internal implmementation details. When dumping BPF
> instructions to user-space, it needs to be replaced back with BPF_MEM mode.
>
> Fixes: 2a02759ef5f8 ("bpf: Add support for BTF pointers to interpreter")
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
