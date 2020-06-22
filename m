Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B0552032C5
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 11:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgFVJDx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 05:03:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725907AbgFVJDv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 05:03:51 -0400
Received: from kernel.org (unknown [104.132.0.74])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3708D20716;
        Mon, 22 Jun 2020 09:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592816630;
        bh=uHzWPbIY/41z+WQ/nEUcOLsdKXZ7Qrprx0s9J3nM1WI=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Xh/zfNmL3ERN7ZAuWqJeou0LUUvk4MxvRvqg/wo1SCR+kIFKaY9IoS91eJwSGmLxN
         41gDTQtH3HmNO1ivPmHrDiY28L/xmHDYW6B2Zu88FibzNrSxqjvk4opMhmkVX7J1zb
         BUvEkLF+J6WNitfbDSFytorOw4J66B/N2vbM1fp8=
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200620033007.1444705-10-keescook@chromium.org>
References: <20200620033007.1444705-1-keescook@chromium.org> <20200620033007.1444705-10-keescook@chromium.org>
Subject: Re: [PATCH v2 09/16] clk: spear: Remove uninitialized_var() usage
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
        Alexander Potapenko <glider@google.com>,
        Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, x86@kernel.org,
        drbd-dev@lists.linbit.com, linux-block@vger.kernel.org,
        b43-dev@lists.infradead.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-mm@kvack.org,
        clang-built-linux@googlegroups.com
To:     Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Date:   Mon, 22 Jun 2020 02:03:49 -0700
Message-ID: <159281662960.62212.15318119299039755482@swboyd.mtv.corp.google.com>
User-Agent: alot/0.9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Kees Cook (2020-06-19 20:30:00)
> Using uninitialized_var() is dangerous as it papers over real bugs[1]
> (or can in the future), and suppresses unrelated compiler warnings (e.g.
> "unused variable"). If the compiler thinks it is uninitialized, either
> simply initialize the variable or make compiler changes. As a precursor
> to removing[2] this[3] macro[4], initialize "i" to zero. The compiler
> warning was not a false positive, since clk_pll_set_rate()'s call to
> clk_pll_round_rate_index() will always fail (since "prate" is NULL), so
> "i" was never being initialized.
>=20
> [1] https://lore.kernel.org/lkml/20200603174714.192027-1-glider@google.co=
m/
> [2] https://lore.kernel.org/lkml/CA+55aFw+Vbj0i=3D1TGqCR5vQkCzWJ0QxK6Cern=
OU6eedsudAixw@mail.gmail.com/
> [3] https://lore.kernel.org/lkml/CA+55aFwgbgqhbp1fkxvRKEpzyR5J8n1vKT1VZdz=
9knmPuXhOeg@mail.gmail.com/
> [4] https://lore.kernel.org/lkml/CA+55aFz2500WfbKXAx8s67wrm9=3DyVJu65TpLg=
N_ybYNv0VEOKA@mail.gmail.com/
>=20
> Fixes: 7d4998f71b29 ("clk: SPEAr: Vco-pll: Fix compilation warning")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>
