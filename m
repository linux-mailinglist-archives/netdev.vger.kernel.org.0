Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D77445FD22
	for <lists+netdev@lfdr.de>; Sat, 27 Nov 2021 07:42:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352638AbhK0Gpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Nov 2021 01:45:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41832 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236810AbhK0Gnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Nov 2021 01:43:45 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D41AB82944;
        Sat, 27 Nov 2021 06:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90BAAC53FCC;
        Sat, 27 Nov 2021 06:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637995228;
        bh=j9Q7WPg7Olse81zE9WUmUkqRYDRcK0cBD+vPzJx2Va0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mat55cEYgVRESO5+pPzVYB4Ce9P5reRTsHNwXhJUc5ViomofUiGWVSHFnpTPqFgAo
         vSL0JxP6XbHDUc/tkA3YxBJCHoVyyvNkLppGGJi9V4vFIijCjZ64iQmD0Gd1v/fGwJ
         D6BQaYrCxsqqhUfx0Mhvw1OHwjrfHwOM0oXVwa9MT5jXfzzPud+ZgJVnpmFJtXrf0u
         7usfjFfSxT8PV1lDPqQqFOlA02iN6YuL31/UGv7q7Tl/Zrwo1VaA5LWWaXfxkjDQFC
         nGlF3viRstABYdWdDyW4H2EW59bZF7VT+aYyZW/i+34XqUEaNLO6NKXUcQ8aCevxEw
         AePHZEMBA1qjQ==
Received: by mail-yb1-f176.google.com with SMTP id f186so25822560ybg.2;
        Fri, 26 Nov 2021 22:40:28 -0800 (PST)
X-Gm-Message-State: AOAM532n2eg8SaPWM00cjBk2pGweRPmUzEBqRjRKB7uh4pglnAnzJmjQ
        Z3QNBrzAI94PwBqv3uxlw7TecdmBoH1Enr9XWow=
X-Google-Smtp-Source: ABdhPJy/H95foMqL7hd7E0HeeB9Lm0N2R32Lsljo37CAMTOJ18OExq6stN5EgynOvaoM5kruWYNaN+tGHUgiQp7nbxg=
X-Received: by 2002:a25:bd45:: with SMTP id p5mr22530188ybm.213.1637995227607;
 Fri, 26 Nov 2021 22:40:27 -0800 (PST)
MIME-Version: 1.0
References: <20211124091821.3916046-1-boon.leong.ong@intel.com> <20211124091821.3916046-3-boon.leong.ong@intel.com>
In-Reply-To: <20211124091821.3916046-3-boon.leong.ong@intel.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 26 Nov 2021 22:40:16 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7URE0jU0DzKu86zaVUZ1rcUFEXHNF3K_O7r5_x_mZAPQ@mail.gmail.com>
Message-ID: <CAPhsuW7URE0jU0DzKu86zaVUZ1rcUFEXHNF3K_O7r5_x_mZAPQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/4] samples/bpf: xdpsock: add Dest and Src MAC
 setting for Tx-only operation
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        bjorn@kernel.org, Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 24, 2021 at 1:21 AM Ong Boon Leong <boon.leong.ong@intel.com> wrote:
>
> To set Dest MAC address (-G|--tx-dmac) only:
>  $ xdpsock -i eth0 -t -N -z -G aa:bb:cc:dd:ee:ff
>
> To set Source MAC address (-H|--tx-smac) only:
>  $ xdpsock -i eth0 -t -N -z -H 11:22:33:44:55:66
>
> To set both Dest and Source MAC address:
>  $ xdpsock -i eth0 -t -N -z -G aa:bb:cc:dd:ee:ff \
>    -H 11:22:33:44:55:66
>
> The default Dest and Source MAC address remain the same as before.
>
> Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>

Acked-by: Song Liu <songliubraving@fb.com>
