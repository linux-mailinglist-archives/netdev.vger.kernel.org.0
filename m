Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F508161127
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 12:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728664AbgBQLcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 06:32:13 -0500
Received: from frisell.zx2c4.com ([192.95.5.64]:56779 "EHLO frisell.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728636AbgBQLcM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Feb 2020 06:32:12 -0500
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTP id aa9136e1
        for <netdev@vger.kernel.org>;
        Mon, 17 Feb 2020 11:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
        :references:in-reply-to:from:date:message-id:subject:to:cc
        :content-type; s=mail; bh=J1+43o37F9mhaHojBDC95OYQLFE=; b=AWhL/5
        4ld6KebozTZWRdoRVEu0a3zfnCg1VyRQDaVowvnLKIzYIdUVpWi++8/SoJTfrD3x
        4Ka/OnGR2X7IluAD5oPwnBbuFzsnWTU8/Lv1bp2/ntiamN7oEL3L59DTQxUO2Hzx
        ojwwwZRP6KPVWPMTLh6DFSM188I8mUoP1R1UBNGhXRLUyS3cEuzZ5dsIz7HptiVy
        B/Sg15R11nGW6o770kmbAHpl9MGyxxmBM4bif0BOFvRviD4LMWhf+ZvM9LpwPkMd
        uXrzkFrk8LoERBkEYLYFkDqHHJHKfqvtoq+qNSxa3yR4cTdnZyfPRUuSriqDfpWE
        53ywzfhWzLn3/K5A==
Received: by frisell.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 193f29c9 (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Mon, 17 Feb 2020 11:29:41 +0000 (UTC)
Received: by mail-oi1-f180.google.com with SMTP id j132so16348522oih.9
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 03:32:10 -0800 (PST)
X-Gm-Message-State: APjAAAWdtlIRw7nqcPqS7ADWytB2WtUBX1qyKOHqG/c/Q5Y72uOIDfrE
        OsgPtve/izpEeI+bPOns6D9TKbUwE4EwAU17hOA=
X-Google-Smtp-Source: APXvYqzulskY2RmmruRAShaKIMl9ybJnU+9vP+Bvo4qvdtgOkMLDMcPcvWGmqCHiDnI9gknzPXsxXLGaNWkvAksvDSc=
X-Received: by 2002:a05:6808:29a:: with SMTP id z26mr4057224oic.122.1581939130169;
 Mon, 17 Feb 2020 03:32:10 -0800 (PST)
MIME-Version: 1.0
References: <20191208232734.225161-1-Jason@zx2c4.com> <CACT4Y+bsJVmgbD-WogwU=LfWiPN1JgjBrwx4s8Y14hDd7vqqhQ@mail.gmail.com>
 <CAHmME9o0AparjaaOSoZD14RAW8_AJTfKfcx3Y2ndDAPFNC-MeQ@mail.gmail.com>
 <CACT4Y+Zssd6OZ2-U4kjw18mNthQyzPWZV_gkH3uATnSv1SVDfA@mail.gmail.com>
 <CAHmME9oM=YHMZyg23WEzmZAof=7iv-A01VazB3ihhR99f6X1cg@mail.gmail.com>
 <CACT4Y+aCEZm_BA5mmVTnK2cR8CQUky5w1qvmb2KpSR4-Pzp4Ow@mail.gmail.com>
 <CAHmME9rYstVLCBOgdMLqMeVDrX1V-f92vRKDqWsREROWdPbb6g@mail.gmail.com>
 <CAHmME9qUWr69o0r+Mtm8tRSeQq3P780DhWAhpJkNWBfZ+J5OYA@mail.gmail.com>
 <CACT4Y+YfBDvQHdK24ybyyy5p07MXNMnLA7+gq9axq-EizN6jhA@mail.gmail.com>
 <CAHmME9qcv5izLz-_Z2fQefhgxDKwgVU=MkkJmAkAn3O_dXs5fA@mail.gmail.com>
 <CACT4Y+arVNCYpJZsY7vMhBEKQsaig_o6j7E=ib4tF5d25c-cjw@mail.gmail.com>
 <CAHmME9ofmwig2=G+8vc1fbOCawuRzv+CcAE=85spadtbneqGag@mail.gmail.com>
 <CACT4Y+awD47=Q3taT_-yQPfQ4uyW-DRpeWBbSHcG6_=b20PPwg@mail.gmail.com>
 <CAHmME9q3_p_BX0BC6=urj4KeWLN2PvPgvGy3vQLFmd=qkNEkpQ@mail.gmail.com> <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
In-Reply-To: <CACT4Y+bSBD_=rmGCF3mngiRKOfa7cv0odFaadF1wyEV9NVhQcg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Mon, 17 Feb 2020 12:31:58 +0100
X-Gmail-Original-Message-ID: <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
Message-ID: <CAHmME9pQQhQtg8JymxMbSMgnhZ9BpjEoTb=sSNndjp1rXnzi_Q@mail.gmail.com>
Subject: Re: syzkaller wireguard key situation [was: Re: [PATCH net-next v2]
 net: WireGuard secure network tunnel]
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     netdev <netdev@vger.kernel.org>,
        syzbot <syzkaller@googlegroups.com>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hey Dmitry,

Yes! Our side discussions wound up getting everything pretty squared
away, and coverage on syzkaller looks pretty good to me. By inference,
I think we're hitting most code paths in WireGuard. Syzkaller, though,
is missing non-userspace-process coverage from:

- workqueues
- napi callback
- timer callback
- udp tunnel callback

Seems like there might be some future research to be done on how we
can track these. But tracking it or not, the fact that packets are
flowing on some path implies that other code paths are being hit. So I
feel pretty good about syzkaller's ability to dig up nice wireguard
bugs.

Jason
