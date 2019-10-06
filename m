Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72B37CD9C6
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 01:57:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfJFX47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 19:56:59 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:45665 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfJFX47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 19:56:59 -0400
Received: by mail-lj1-f194.google.com with SMTP id q64so11681252ljb.12;
        Sun, 06 Oct 2019 16:56:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=R6ZrOq6Miys7DN98z41JiuV4CLUfaznvLXIua2XszwY=;
        b=hZVBOMbGMzBOLMSELytaY4fuo/nRbVATAIPzOEylDmpPM30zYGis52e9U9mdoEThQ3
         Sb1nplztU2ZSODFJPEzlKmoPelDHfPMckVh81O17jJEIHrgiYp4Crv9rH6oIhgWCnJXV
         4PEic4SQ0QJYNNHWPQIG+WlShQgy80lbGldN6JN+R++OpWHpkBMcifkx2icAiW1fg1Nb
         uIqgbhqk9JimeoFj4xwJOdaq6NQgx/6r9eWsyRiWKbBZRYif1qrnApjw2PEn5vZsIQ6J
         9+5nztxzgCv5eiJnwyF87M/sMkJlvcrnaIHYyiwIuDuYauJWtBm127FRZZxXBRoqFs45
         Ov2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=R6ZrOq6Miys7DN98z41JiuV4CLUfaznvLXIua2XszwY=;
        b=AbqBBfnGVOmnUwjHYKp/i9KOGfT5Vzvf4fLSDaFKOQ7Caaisc6BKEIIN4AxW3zMfaO
         3yx+HdLmYAvuWxSZwPOvDv6r1KMn9OAkB/qFPp0Kqz4WhZaMu/cgd/uftt7GATFiDU54
         rfB9rk/7gFu6KjEjmIsYCFB8YvFsRS/z7kRKhngEhfQiOsGNMZQ48JkrmH3IKOdKNHy5
         kFevinVFYk/TAOUKD+q/7tQ02q4NTYuZ9SmKT3cSygpb4CVNCUvkwcAQcW/wGTGROBsW
         IYT9uy7Vo0v/mx8y/MLzF4EKFQbGCTnaogh6WkcFE6l3xAFl6Kpgr48y4a/ALbE3rcCu
         uc1w==
X-Gm-Message-State: APjAAAVlJFx3rQ61SSv6/ipMVFth3JXP4spwbAb+3OwR/HOv9JiSFmHN
        1PRtyYO5mtZCExr+NRPu+SndTUTVOuNA/CSKiFs=
X-Google-Smtp-Source: APXvYqwgDkByaciNTBuR2795nhHZhzcJ1PkJx3x66Ia3RCD0ZX7H3u/GA0OcQdPRPIaEmKMnSib0dIuR3gmleyHwj5o=
X-Received: by 2002:a2e:b0f4:: with SMTP id h20mr16257442ljl.10.1570406216891;
 Sun, 06 Oct 2019 16:56:56 -0700 (PDT)
MIME-Version: 1.0
References: <20191006054350.3014517-1-andriin@fb.com> <20191006054350.3014517-4-andriin@fb.com>
In-Reply-To: <20191006054350.3014517-4-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 6 Oct 2019 16:56:45 -0700
Message-ID: <CAADnVQ+CmZ+=GTrW=GOOnaJBB-th60SEnPacX4w7+gt8bKKueQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 3/3] libbpf: auto-generate list of BPF helper definitions
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Quentin Monnet <quentin.monnet@netronome.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 5, 2019 at 10:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Get rid of list of BPF helpers in bpf_helpers.h (irony...) and
> auto-generate it into bpf_helpers_defs.h, which is now included from
> bpf_helpers.h.
>
> Suggested-by: Alexei Starovoitov <ast@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/.gitignore    |   1 +
>  tools/lib/bpf/Makefile      |  10 +-
>  tools/lib/bpf/bpf_helpers.h | 264 +-----------------------------------
>  3 files changed, 10 insertions(+), 265 deletions(-)

This patch doesn't apply to bpf-next.
