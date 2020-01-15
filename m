Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1313B728
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 02:46:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAOBoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 20:44:10 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36997 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728844AbgAOBoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 20:44:09 -0500
Received: by mail-qt1-f194.google.com with SMTP id w47so14411451qtk.4;
        Tue, 14 Jan 2020 17:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3mqVS9DBlywDqi6+FLa7SAx2QVby5ixPoTqqNPEq/SI=;
        b=BEdqIWMcigy95FTOqkMhBm6SqvqHkay54i3OrWQ9tn8p+gcmOhFBFE+AIAgb0WBB9H
         aVUdEt1HPMPcNhHbV6UPn6CwculVGW7roiZu80l2hbBkX1kACLRPG6QOkQmi+174+8MW
         dNCaoKYp6g/vVB3MT3WKCXj5Lc6IVZJoFqGg52yRMR0RBPQC+DxH1yvxGRuj9n9BSEZ7
         zInbMenJlfQ0ZHJD7ZpoxfdSNkRzxebbHU8Vk/Sme4FVG0jsf2k3pLRmzXreq36wThFo
         KXBUistE9fC+eiKtStSttrKt/lYRCiUtT+jLPoNEwo8i29khmuJ4lRawevuECDKpr6RD
         wo+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3mqVS9DBlywDqi6+FLa7SAx2QVby5ixPoTqqNPEq/SI=;
        b=Mun0xdwENSust4vqGNU3hQqbu341RfT1qBA/ZC0c8Fx+UvAUYChNgU6du60QBi9LCy
         1Qwr2wK+EF+35Eq6SgaM4ck0QmEuO1v8AXUNVGHk5dsGG0AdzXbCf6gfrU/XpZdPc2Q5
         LVekXBCbjF8igzN2S9T/TFHGTBaDWQqf7yQM4pb1E93jRMR79ZulvydiN1VDz9p8mvuQ
         PIPaDPxaJmkF2Nme/Dn+skNnTB4zh3WktiBsgLOAcIAN6DNMdyI/oyBhZ8MAXIevs2Cl
         6kNZLfSAX08nVJBER+ji/A9YvPgR9Jq5g6NU0uG7WkhZVcSU/vL1t3iX4bgaioL2q5bz
         Fs+Q==
X-Gm-Message-State: APjAAAWJJNuUlec7ZR4qty9/6V5lSQ7qTDzzSMqZzld1sIU+Pd3sLKa9
        p0DdIcBgHqZzU5xeRVM62QZjKacOL7Uiw5poOX71Nw==
X-Google-Smtp-Source: APXvYqy8Tx/IxYllo8dsmo0WKCJkCI7Qpn9qZbrfssr5ba37Rgkc6gNouqVKYXJWZJwcDSs9hwHmMnquI7IBEWLOkPk=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr1400451qtl.171.1579052648893;
 Tue, 14 Jan 2020 17:44:08 -0800 (PST)
MIME-Version: 1.0
References: <20200114224358.3027079-1-kafai@fb.com> <20200114224412.3028054-1-kafai@fb.com>
In-Reply-To: <20200114224412.3028054-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 14 Jan 2020 17:43:58 -0800
Message-ID: <CAEf4BzYOjgCbbr_zofZcGMiJj=fpH5JMBbL=jZqD5KXzYjmahA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/5] libbpf: Expose bpf_find_kernel_btf to libbpf_internal.h
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 14, 2020 at 2:44 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch exposes bpf_find_kernel_btf() to libbpf_internal.h.
> It will be used in 'bpftool map dump' in a following patch
> to dump a map with btf_vmlinux_value_type_id set.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---

This function comes up not a first time, I guess it makes sense to
finally make it a public API. We should also try to minimize number of
internal APIs used by bpftool.

So if no one objects to expose it, should we call it a bit more
precisely and according to libbpf naming guidelines:
libbpf_load_kernel_btf? libbpf_find_kernel_btf is acceptable, but it
does more than just finding, thus "load". It should also probably live
in btf.c+btf.h? WDYT?


>  tools/lib/bpf/libbpf.c          | 3 +--
>  tools/lib/bpf/libbpf_internal.h | 1 +
>  2 files changed, 2 insertions(+), 2 deletions(-)
>

[...]
