Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6175E3A76FF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:23:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhFOGZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:25:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhFOGZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:25:28 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D49C061574;
        Mon, 14 Jun 2021 23:23:24 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id q21so18866012ybg.8;
        Mon, 14 Jun 2021 23:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1G52dZbe7zbZLAVRxdP2yNfSeJPuHgFFHCvs43Nag7E=;
        b=W5ydF1MdDBdzd4xXw/hALSkJ7GJd8tMZXAg/TzyWmDQjIzFQVGwhLoIrJeZqzIcmB0
         ZjOYtTk0DIyXQjMXQN33jDn8+eOlHT08nIFxFcNLqZIHVzbCpjyqJ3uMKZy9IzrKWKIA
         kdaR2h4KZb9q9hutdL2DM8SLDGklCn71fz512KhS9xCvFeMrsqWNi/SL/LVMPNungqu9
         MdN44xC5rgLYcpfEMclbTgGfJj3cP9JADM+tnWhEhy1tGSDAfE3wsHN6daYttBx172F5
         iIr7zZQHJTqWAS0kpnNfmieGn3+oQT66B5wLRmOKBe1Z4FnT5tbg1GllZw2SXLP2Gvez
         VQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1G52dZbe7zbZLAVRxdP2yNfSeJPuHgFFHCvs43Nag7E=;
        b=mNCW/6jobi4bSkuvviKn4T/8YbHWacPOgQG3pnaIQYAYIwro2s8jXcoitB4roioJ5V
         h/vIhx/f6laDOcrabvViJjo67iD5SIJLYPEPiy19qCAFJRESrF6ORzty2KZkSzQM7LQA
         eE1mS7deYq4lq/JPXOHJ73iDG6bisBz/tFt/0MPZLENnmm3D8CDJtvgdcmplkMOgveT6
         Ql5PhR8h8IBkDZraJF/epSK+cbqljwj+1kP1sqK39gsVEpwaTJPHbkCgNZEu3pvXNKpC
         6uXU0+qvHDm6NmgwvVMJ72PXsp66amXCdOOwa9hlS6tkS643CLS1gsG/njyXV1DJEGPJ
         4y1w==
X-Gm-Message-State: AOAM532mkDiChYp4A5Oqa4lEZD++oMRYA36fOXU04hszyL0OgsmfDhhT
        Y6LFCpGeUHFHV89hpiYUlGeI+RUhntB3uY736rn4i2fCeQE=
X-Google-Smtp-Source: ABdhPJyYPw9qe1+HPCpxSg5KNotvIHZQH1xFKX47FoaqKwzOUfpkriVIK9Vk0BP7PSOlkOJwJxh2X5kHuRO0P3JghA0=
X-Received: by 2002:a25:7246:: with SMTP id n67mr30309413ybc.510.1623738203791;
 Mon, 14 Jun 2021 23:23:23 -0700 (PDT)
MIME-Version: 1.0
References: <20210609115916.2186872-1-chengzhihao1@huawei.com> <7883956d-4042-5f6b-e7dd-de135062a2ef@isovalent.com>
In-Reply-To: <7883956d-4042-5f6b-e7dd-de135062a2ef@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 14 Jun 2021 23:23:12 -0700
Message-ID: <CAEf4BzYE=kRDz4e+8MEe6Pget-C4XKg8bwAgEHYf+KujUtFJeQ@mail.gmail.com>
Subject: Re: [PATCH] tools/bpftool: Fix error return code in do_batch()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Zhihao Cheng <chengzhihao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 6:34 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-06-09 19:59 UTC+0800 ~ Zhihao Cheng <chengzhihao1@huawei.com>
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> >
> > Fixes: 668da745af3c2 ("tools: bpftool: add support for quotations ...")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>
> Reviewed-by: Quentin Monnet <quentin@isovalent.com>
>
> Thank you for the fix.

This has been applied to bpf-next last Friday. Patchbot missed it.

> Quentin
