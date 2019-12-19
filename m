Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B87B1258E6
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 01:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbfLSAyk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 19:54:40 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45463 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726518AbfLSAyk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 19:54:40 -0500
Received: by mail-qt1-f196.google.com with SMTP id l12so3542480qtq.12;
        Wed, 18 Dec 2019 16:54:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A1Urs4RsdGYBrM/Z6psT6VFuLwM10wg/j95CYysxehQ=;
        b=QafT74dzFrnd5FdUc7ZzJZlaKDob9h1sLpE+XITJl54ZNHghpJtwWE7dcAkDiPKqhX
         lbx2ass0Ebil/RJsJijTZP3Js7drMaUnjPbmxgFL73QBDCWFkHtn8OnDLO7T2pW41HaO
         nPio5pHds+vJOAx6gQvrzuGJzL+qNvKkFbJWykiaU1K1mEuKaGQG3t4zi8vdh6XGuiH8
         ypLnvN3hshsvmwhleq2fcjUpOqWlbaAbajNsGYxNtjdDW5RmWuUhZYXkTQHWs8eDVOTT
         MGsQrBruQfvqqAkjtR3vXomeOsANkyO9SBKlLxmJq+BKIo4lj4y7nlZPQGHhrrLkQvtV
         3yhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=A1Urs4RsdGYBrM/Z6psT6VFuLwM10wg/j95CYysxehQ=;
        b=oZItB2ygC0o5F3mWiVDgyWz6NPeCRL5UaBjJJQ9vuXKBm4qLLtpWFDkiSBuZpy+ls6
         qGcpg4LsYNzArxP1WZAAI0hxEqcy5Ni8sG/8DVdRM7nax4hqM9A3DxsP1+3CGFNf3IvV
         9os9N2OSHx0IseynNSnTve2eC9QmN/IPBVJYQ+WjXZ9HtM8ZiK/UpOoPRCLYidmDxeCS
         i+Dl5VLY1e0C+UNUfTApaUgG0XZrletARbniOUOnDWrlSHu4VD/GXLQFxs/26wgzJdM2
         KNPeV18mx4mgqyEEAVUNGZxySGvSSUIW/M42xOZhuN6L4MyA8Z6D1kBSUIxhssv7O76+
         cbUw==
X-Gm-Message-State: APjAAAWHNDtrueTMU6ZEgEFAq9nRow6hjQaCQ6RxOoEQguewxlVrlX/q
        RcABIhZfkIbqKgCQgtwKEq/+Ob6sJOo9HIR2Atc=
X-Google-Smtp-Source: APXvYqxYXKEfiJIR4aztDlh6AyQHzq1Z+GedyfsEKbjzdal3F7FXFiTAT4o0HbCkk48AOkhwhMPm+llnUg8iQhz4gJw=
X-Received: by 2002:ac8:4050:: with SMTP id j16mr4757783qtl.171.1576716879274;
 Wed, 18 Dec 2019 16:54:39 -0800 (PST)
MIME-Version: 1.0
References: <20191211223344.165549-1-brianvv@google.com> <20191211223344.165549-9-brianvv@google.com>
In-Reply-To: <20191211223344.165549-9-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 18 Dec 2019 16:54:28 -0800
Message-ID: <CAEf4BzaeLV8EkGunioqD=sn0Bin4EL0WMzp1T6GjdBajWaFQ+w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 08/11] libbpf: add libbpf support to batch ops
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Yonghong Song <yhs@fb.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 11, 2019 at 2:35 PM Brian Vazquez <brianvv@google.com> wrote:
>
> From: Yonghong Song <yhs@fb.com>
>
> Added four libbpf API functions to support map batch operations:
>   . int bpf_map_delete_batch( ... )
>   . int bpf_map_lookup_batch( ... )
>   . int bpf_map_lookup_and_delete_batch( ... )
>   . int bpf_map_update_batch( ... )
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

These libbpf APIs should use _opts approach from the get go to make
them extensible, but preserving backwards/forward compatibility.
Please take a look at one of few that are already using them (or
follow Andrey's bpf_prog_attach work, as he's adding opts-based one at
the moment).

>  tools/lib/bpf/bpf.c      | 61 ++++++++++++++++++++++++++++++++++++++++
>  tools/lib/bpf/bpf.h      | 14 +++++++++
>  tools/lib/bpf/libbpf.map |  4 +++
>  3 files changed, 79 insertions(+)
>

[...]
