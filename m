Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A24B2CF928
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 04:15:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgLEDPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 22:15:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLEDPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 22:15:04 -0500
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B97C0613D1;
        Fri,  4 Dec 2020 19:14:23 -0800 (PST)
Received: by mail-lj1-x244.google.com with SMTP id j10so8799082lja.5;
        Fri, 04 Dec 2020 19:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bhnaUEstsq49uk/fb5x2ARUhEHo6K3HNgE+BC9eamaA=;
        b=oZFYYlsQCzEe9E03e1RLzM8JPqad72TY9Rj5HzvwilkHczQP4sLP9MepHecr4U6iD5
         FjRAj2WasZZAmAGwMfhjgb+vGQu/wp5UWYbCISvk3hTzIxeUduw0OpuSTgUzbzrLaYSN
         1fDELZFrCZzJ9joUJsZ1VsWzwpkqQHpGcPonhuB33TGmZK1hqtD3iKoQ9HEbhEK2xoei
         Fm1gL3yNeheSlnIo9zZaipoEaa8Az+TCzyc+2EXe/gLytoyKiQln1YShMkrljl6eUXbu
         Zuch6sne81LWpxLZi+u/UPcQXXx+IF1D1+ZJXDShDpwWDsADSGGMSWvX+nGPs3jVhaVk
         g8fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bhnaUEstsq49uk/fb5x2ARUhEHo6K3HNgE+BC9eamaA=;
        b=g581+HpLL8ZaH33uj2heDYN/GEjujWCMsGGr8WXqawiE9p8IdYH4gjnz9gKeEdO4eD
         FVJnP05LBPwJTgyMlDkE7FGxY+ViPKfy83gLujb8nrcaeMujrdsSWLES3yfz5/yKdJkZ
         KDTvG0tGlfP3/L4liZdxd4u59CSm9T8r37hKlIAWE0PBRDpVzu511bP+qFzoIh3wXiNC
         Xb9GBryI5VStoB4pJU2EcSm5kDC4aZS4DXXbVwXWEfq5U2IbLf32OfI+J1wjVRUwdsUu
         /Mm9eThRP5LLwRZhbjHWuc0hqYumZvPFpg/XX3dLjUONWsZblBoQPzGiUAVSuunCtOGR
         ww/Q==
X-Gm-Message-State: AOAM5311+NU4/8v7iiMoeF5GMYoEq9/KjVk2F3xAeCfkbF1Tbf533oC/
        IP4i1JJzrmbHPS+8cMj6h6KYtYWRNCHt/2asMI84BsgWy6U=
X-Google-Smtp-Source: ABdhPJyudMU3m1DeyEwjyVniEdUz6gQ+Cqqdg5l5d7SN7Oay2RvC0I7kTWt5yorQuywHmF/fNpiM2nEc0x8gogQPKNc=
X-Received: by 2002:a2e:8891:: with SMTP id k17mr4275030lji.290.1607138062460;
 Fri, 04 Dec 2020 19:14:22 -0800 (PST)
MIME-Version: 1.0
References: <20201205030952.520743-1-andrii@kernel.org>
In-Reply-To: <20201205030952.520743-1-andrii@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 4 Dec 2020 19:14:11 -0800
Message-ID: <CAADnVQK25OLC+C7LLCvGY7kgr_F2vh5-s_4rnwCY7CqMEcfisw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: return -EOPNOTSUPP when attaching to
 non-kernel BTF
To:     Andrii Nakryiko <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 4, 2020 at 7:11 PM Andrii Nakryiko <andrii@kernel.org> wrote:
> +                               return -EOPNOTSUPP;

$ cd kernel/bpf
$ git grep ENOTSUPP|wc -l
46
$ git grep EOPNOTSUPP|wc -l
11
