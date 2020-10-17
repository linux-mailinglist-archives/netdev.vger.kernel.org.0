Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7934C291255
	for <lists+netdev@lfdr.de>; Sat, 17 Oct 2020 16:20:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438315AbgJQOUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Oct 2020 10:20:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37314 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392579AbgJQOUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 17 Oct 2020 10:20:48 -0400
Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 85598207C4
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602944447;
        bh=MlLcGAmr9JWymolHAXnLBcXm6VpyIqHq55mEcGChNN8=;
        h=From:Date:Subject:To:From;
        b=sYAbe35DugQjVa7PgRzsOxt4kTVxzn1dzsZzzhs/SUhzhumme7j8IK76726z3mRC6
         NzZpwprwBGilREQ6X/K4uCeANDBllJsxVSQETa2EnARjhfNT6EXOD+wvmdbG/RR3hX
         Sq5GHXfIhr/lJ3u0j4RAgjQgomatyCZMXJKgikxU=
Received: by mail-ot1-f43.google.com with SMTP id n15so5394391otl.8
        for <netdev@vger.kernel.org>; Sat, 17 Oct 2020 07:20:47 -0700 (PDT)
X-Gm-Message-State: AOAM533VlWqOdATMv6ZsGjg/d8RzYZnYsTD9gBlvb4bcf+tzq3yxA+A5
        Ebjxp7OJcFy2vwNLogW8giNVEJU8tyU4E75RRwQ=
X-Google-Smtp-Source: ABdhPJw8h7CRrDEqNKJXivZk4DLL8c0l7ev16knYbi+d6hep1Qk0FEBcZkLuOnzrTvb2xh303KBRlpKo+lnr/vIlOE4=
X-Received: by 2002:a9d:6c92:: with SMTP id c18mr6019200otr.108.1602944446843;
 Sat, 17 Oct 2020 07:20:46 -0700 (PDT)
MIME-Version: 1.0
From:   Ard Biesheuvel <ardb@kernel.org>
Date:   Sat, 17 Oct 2020 16:20:36 +0200
X-Gmail-Original-Message-ID: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
Message-ID: <CAMj1kXEEF_Un-4NTaD5iUN0NoZYaJQn-rPediX0S6oRiuVuW-A@mail.gmail.com>
Subject: realtek PHY commit bbc4d71d63549 causes regression
To:     "open list:BPF JIT for MIPS (32-BIT AND 64-BIT)" 
        <netdev@vger.kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Willy Liu <willy.liu@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Masahisa Kojima <masahisa.kojima@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello all,

I just upgraded my arm64 SynQuacer box to 5.8.16 and lost all network
connectivity. This box has a on-SoC socionext 'netsec' network
controller wired to a Realtek 80211e PHY, and this was working without
problems until the following commit was merged

commit bbc4d71d63549bcd003a430de18a72a742d8c91e
Author: Willy Liu <willy.liu@realtek.com>
Date:   Tue Sep 29 10:10:49 2020 +0800

net: phy: realtek: fix rtl8211e rx/tx delay config

It was backported to v5.8 as b9f0dcfbfc07719be7cc732cda4e609280704605

The commit log in question is a bit vague, as it does not explain what
is wrong with the commit it aims to fix, or what the changes are meant
to achieve.

Since it breaks h/w in the field, can we please revert it? (and
backport the revert?)

Regards,
Ard.
