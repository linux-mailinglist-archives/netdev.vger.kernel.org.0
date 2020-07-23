Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76AF422B73D
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 22:09:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbgGWUJG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 16:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGWUJF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 16:09:05 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF773C0619DC;
        Thu, 23 Jul 2020 13:09:05 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id a11so5430594ilk.0;
        Thu, 23 Jul 2020 13:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=bLSPLWFPUYatzpPGMSwY8PGRalv0YCgMUYV5BWjWsG6K+jxU0oOYCdaCuT3Q5CBsA8
         f8C9CoqEPoXpKg2te19bAOXKUBLCaffZVHJTg6q+bcCFl+zUK/ghi9H/805pv0XhTuoV
         76c5hgFtAtfbxb1RWSRqXBhA6GS5QOOWKaU7bCMQUr9IYr7LvZHylt+cRYaEsoMy5MQL
         8MIn8UJwTJijGiURy83bw4ZiBcYjvOu6gtSjHFXkx7UMuQBq5xjFkC22CegqpNt3Acls
         ufAroUlixWrBFDD7avG5dW0gY6AN+nFgnUk3R+nmYR1w3BxS4TE7avzIkqq6iL13nq+j
         HAyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZypJVFE6v/3Jo2AiBRXxfrvf66bExjGHXFBsT718YSg=;
        b=ShwDMb/fh6bQvfkzk+JC3303kjxE3brOVYNsOpFBGpcpk+w0y8FWdn39EgxN7evDLQ
         xgs4lwWLF3aZQ5X8fJhHtAOOIEpCs0/Tc/+9a6DoVQsjf86WBTW7mS3U0GykhxBwe6kJ
         ST6NTULge7G2/giqZ3jDLXt4D6K/kmXKtc36xKABxUI8/q9i9AxBCDGqdIMOjnMwCAxU
         NXFl/FAuma4T2vt1W3hUj8EN3A/3Qhk3orDklIdNUmEhK7m3wBmamxRrHwFYAdivUDhf
         euF+DsOL859LvsGZ/TTGR3/OgPDaI8nodCR9QfPnNRC98Q25v4P2kfmeMSC10Y/oopnN
         VJMg==
X-Gm-Message-State: AOAM533n/J07EUxcNtNGyeV2+H/F+2Zslq5UyPznevMP1d3Ulstn2bg9
        PCwMXXI8wT4b9UVr/cV2YVNgOAVGTBHrNhxvChlfoQwUlRA=
X-Google-Smtp-Source: ABdhPJx8TQODPy60tmUDEP6q1R8QCRznpSiMWaVSF2+aT6RUj2ygg7oF8EYodrl7Fxb0piW5yw1GbXuWuTiFihbRTDw=
X-Received: by 2002:a92:9a45:: with SMTP id t66mr4259372ili.268.1595534944808;
 Thu, 23 Jul 2020 13:09:04 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000047d80905ab1fccdb@google.com>
In-Reply-To: <00000000000047d80905ab1fccdb@google.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 23 Jul 2020 13:08:53 -0700
Message-ID: <CAM_iQpXq9dYj67Lrv73UazJWG5UVVuMO0iFwJJWg7S_H-z1YcA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in vlan_dev_get_iflink
To:     syzbot <syzbot+d702fd2351989927037c@syzkaller.appspotmail.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

#syz test: https://github.com/congwang/linux.git net
