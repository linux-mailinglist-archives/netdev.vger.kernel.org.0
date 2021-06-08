Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5432039EAF6
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 02:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhFHAsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 20:48:42 -0400
Received: from mail-yb1-f175.google.com ([209.85.219.175]:46970 "EHLO
        mail-yb1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFHAsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 20:48:41 -0400
Received: by mail-yb1-f175.google.com with SMTP id y2so27585283ybq.13;
        Mon, 07 Jun 2021 17:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wAeCfS9iaVJBSI175timC+YpcqrmesZy+/g5SRxMcsY=;
        b=h5d9k7yOoW7S/0rpuC4f5HDaZZi0GJ20Abacpwz3DsUDrsrREp5r3i4jKGl0lTTDFk
         Hr5lEJNNouzb6MDs00B4D+55LFplIKRgm9GhOEgY8xvvef9MwQJgeqVErxrrm4s8mJ9q
         K9drRIVLe8eEmS5EhBe805OrvcYyvmfT2YGweKEKH5h2ppS01rT9n1Fi7hvsHUDiHGF0
         EhgkSK1cXcffdviW7Rm02JfDK5fqz4KQHfXadM6i5OkMMazdzXugqf+VzzrcRLcFTbp7
         5giPdI3UtlACU+Obc7meDZkB+bhwTONWMdKosJfDISLXqasHU+aZZi5WZl8TmmQFQrVS
         Ro5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wAeCfS9iaVJBSI175timC+YpcqrmesZy+/g5SRxMcsY=;
        b=pFv+XvxCYahQqY4+H5gV081W0JY9DuQLfQjENipNOsE5IaX8Y+a8lJ90E75adqhfpS
         DYi4gTHLbodEIFKy21PYLh04qUGcqhnfh0u1SlANlBsH0fIIYtKBKs8eyuc/zyE2vPCb
         R2Xc0onkBkgnjNZ6yrVPgOUdPfhyCCpXDFuVBPnqNMr8FVpg7JSbVkMGrMixdlD259Cb
         amc468qCOfVqHxYt4tS/2Lm+y4DtqSpFpFJCo/wmEi7DUZwIKagcC9xQsaapncrur3G7
         oA/w48kcw9A4minzYmY8tjn6ieBVFw8Bh8aaxdlBqoG3YoYxWTUXINdL1OVMt/DhQqtq
         7UFg==
X-Gm-Message-State: AOAM532YVzW7fvbyrR+T6uRPG4XoSXi30PuVCOBb9yEKGK4xnk4GWYRY
        fSGLdbkigyCsqtr0+tF/A8XHPEPUBFGbS17UJjg=
X-Google-Smtp-Source: ABdhPJyNEb5N8zlSd1g5AAeN050SmMxCNWcf83WGtFzS4QxSx3LI00mEZGLTi8MpIzActpbng8TG/K8Ju9lXxgLGBnI=
X-Received: by 2002:a25:4182:: with SMTP id o124mr27027899yba.27.1623113149079;
 Mon, 07 Jun 2021 17:45:49 -0700 (PDT)
MIME-Version: 1.0
References: <YL4aU4f3Aaik7CN0@linux-dev> <39e483bc-6aa5-7ee2-1aed-ad0844b30146@fb.com>
In-Reply-To: <39e483bc-6aa5-7ee2-1aed-ad0844b30146@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Jun 2021 17:45:38 -0700
Message-ID: <CAEf4BzYBYmBz6QR5=nkhUhT7oSGSs6LKYaJvC+_1DwC7KsD8Lg@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fixes incorrect rx_ring_setup_done
To:     Yonghong Song <yhs@fb.com>
Cc:     Kev Jackson <foamdino@gmail.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 7, 2021 at 8:04 AM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 6/7/21 6:08 AM, Kev Jackson wrote:
> > When calling xsk_socket__create_shared(), the logic at line 1097 marks a
> > boolean flag true within the xsk_umem structure to track setup progress
> > in order to support multiple calls to the function.  However, instead of
> > marking umem->tx_ring_setup_done, the code incorrectly sets
> > umem->rx_ring_setup_done.  This leads to improper behaviour when
> > creating and destroying xsk and umem structures.
> >
> > Multiple calls to this function is documented as supported.
> >
> > Signed-off-by: Kev Jackson <foamdino@gmail.com>
>
> Acked-by: Yonghong Song <yhs@fb.com>

Applied to bpf tree, thanks. Also added

Fixes: ca7a83e2487a ("libbpf: Only create rx and tx XDP rings when necessary")

Please don't forget Fixes: tag in the future.
