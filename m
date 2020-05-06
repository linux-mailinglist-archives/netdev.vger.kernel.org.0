Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DCE51C6744
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 07:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEFFLS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 01:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725821AbgEFFLS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 01:11:18 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6108DC061A0F;
        Tue,  5 May 2020 22:11:18 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id l18so543915qtp.0;
        Tue, 05 May 2020 22:11:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z0SA6GoDq4se4zcKfFdUZiGU9CF+wbjrgmJnm7hbcbI=;
        b=MZ+hBfTM0GKLh8mPuc3cPj1Mnui33KUO22dKtdH6DpJpx9VOol6eR60IxP9XU3/+yB
         VjwbANdGqAzJY3cdG0e5hlxQC7sftL1DH1/gJHZ8Ygm4c6d82mf5fEtUPyNCxhXEgHMb
         ZR0M2cAv5JjA9iHPX/s6YKyuaN1ThicijkZLFj7G8ETkMlin/1TYOcmMQ/xpYcoY5072
         5XJOQtSrmhwuIRT5mucW9HfJQXZw40wqRacqIU+pLOwiyA9s/jS/xAbhd46qLoA1BghG
         lYs54MZitfgi+eaETi23ezVOAmcotCE8mBfzwomrEuKU53otL70L9w8e6Nr+FaimjqoN
         1nXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=z0SA6GoDq4se4zcKfFdUZiGU9CF+wbjrgmJnm7hbcbI=;
        b=A6dTChdexByDUS+8RhH0dBMWPYBxgHs/qU3vujO3VKXvDM+5P/OJhWyUHCF5REVqPa
         PK6OTrOVhNn2Xsp+6zG6ImlIBfw9hNMkFiIdLQOEH3z3S3Ugmc1AnrcPabIJ8wOzWmiz
         FYX86FTtM1nRbyuhf6wp29MIK6HeKntZY3teP4K22Dkal8pbVlg/xi/Ut0AU+f6Atp/Y
         9YUpHbV1JiLc9K/cJVU0+YlN77kMxP2rk86LGnVC64xxo3DOhdPyJhcTbWUQNB0kPFjZ
         SeoNiDzJ9vGYZKoDfgGny3oKdhugbPE9O3Z9BdGqgS6MMWutxmJcEmpyx2zoEzKmjOZD
         Q6NA==
X-Gm-Message-State: AGi0Pual2VkFtSXNZGgJYMaIPGan89heJhTyGVTKe4hhms8dA2THeXET
        Bimn5Nl+brfbSpmZ1qwYlM87TGODgoRLB6b+sKQ=
X-Google-Smtp-Source: APiQypLW2S+26L7KJYLrEiY9fDffKMURVt1Qk64iR5d7M+5nbT/w0mQT3c+MmxrbB4FqRcR97u5ebHt9wvA9bGNw+sA=
X-Received: by 2002:ac8:193d:: with SMTP id t58mr6009595qtj.93.1588741877652;
 Tue, 05 May 2020 22:11:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200504062547.2047304-1-yhs@fb.com> <20200504062557.2048107-1-yhs@fb.com>
In-Reply-To: <20200504062557.2048107-1-yhs@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 May 2020 22:11:06 -0700
Message-ID: <CAEf4BzYHs0Z_uPequLRXx8LBbP+NoRZ92eTPBdqL+8wQo3dyaQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 09/20] bpf: add bpf_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 3, 2020 at 11:28 PM Yonghong Song <yhs@fb.com> wrote:
>
> Implement seq_file operations to traverse all maps.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

Looks great!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/linux/bpf.h   |   1 +
>  kernel/bpf/Makefile   |   2 +-
>  kernel/bpf/map_iter.c | 107 ++++++++++++++++++++++++++++++++++++++++++
>  kernel/bpf/syscall.c  |  19 ++++++++
>  4 files changed, 128 insertions(+), 1 deletion(-)
>  create mode 100644 kernel/bpf/map_iter.c
>

[...]
