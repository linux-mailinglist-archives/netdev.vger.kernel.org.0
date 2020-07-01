Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E467C211096
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 18:28:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732377AbgGAQ2x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 12:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731672AbgGAQ2x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 12:28:53 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBC0C08C5C1
        for <netdev@vger.kernel.org>; Wed,  1 Jul 2020 09:28:52 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id h28so20565532edz.0
        for <netdev@vger.kernel.org>; Wed, 01 Jul 2020 09:28:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NHY/ua7d/0aAP6JnSEnvQrLvcbc/95n4E5SSH5dP4oY=;
        b=gk/sPw2ifW9fcvord6BRBV1uai57gwxNWxzgvytkMKcxj9Bqoh9eynB98p17o5PX+A
         QeMY3XiXa3rPPeZ2xfDzII7bWAcf4xMnu457kvOcU4QEto/Q4QyTNgMp1H8LKYJiIhYT
         JVzeA4iP0SzFYsqjMDqLYAMb6C7U19r2MdTsdJirFAzk58uxo9LzN0GB80Kq5vSemBLU
         lsUtdcNY3a7ReUhAuHkdYTyCQVHJHc9WdujjJ8wU4XMQkejJ/JsFyoenGTVzCkIIPi41
         vYvHeNfJ8LfCrdFBNJ7izEAnyQBbF5VDmk1E+ltcrsRgmOb3QzDElUccEMQvwUA6xB/O
         aDqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NHY/ua7d/0aAP6JnSEnvQrLvcbc/95n4E5SSH5dP4oY=;
        b=d0ENEdLyMyRkm4X6ViU0vc8NpyYKfKuE9yNPBlTL2Ah149iXk05g5aFOwc92bpV1+G
         YcPEnzN6fWu9vhV5EpHudHavWkNV3H+fm0EQAaDH1p2kHjFhkUiKo80ZQVnyTVSf46Bo
         eV350PuYTYcW0rKzxo8d1ubVEDq+gdd9VjgXYc+sQE9XXlrfEWQts8wu4wkFH1xVXgWX
         s/oki+C5CKuSrFVz9WgkPTjJILEtkdsIRyoCeTl5MUF9f/A7rQRcME5KJmdM7lqymcAQ
         NpeMP5rKDXJuC/HdtF4qg2tfIKCx0aduXVT7kjUNfSsPzg++MBP9fWtiAHwjtlyEyxhh
         UkoQ==
X-Gm-Message-State: AOAM531hqFz5vKGSwBFLya72Po3ZNQZcjVlZqLza6Fwkp78CSwTlDe88
        JVz6dyO+PTsZlfIa+fY9mnp3Fom7LF1K1WxRCYSPsA==
X-Google-Smtp-Source: ABdhPJxWIgJ60DwfGmJ4FdRAb7qrnZ8zejs3cR1pgCQULhtal2J5ArjoMKo8ahbL39DNAPsfNCc5aUS5GTdlB/35890=
X-Received: by 2002:aa7:d3cd:: with SMTP id o13mr29388589edr.176.1593620931106;
 Wed, 01 Jul 2020 09:28:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200626201330.325840-1-ndev@hwipl.net> <CAHmME9r7Q_+_3ePj4OzxZOkkrSdKA_THNjk6YjHxTQyNA2iaAw@mail.gmail.com>
 <CAHmME9pX30q1oWY3hpjK4u-1ApQP7RCA07BmhtRQx=dR85MS9A@mail.gmail.com>
 <CAHmME9oCHNSNAVTNtxO2Oz10iqj_D8JPmN8526FbQ8UoO0-iHw@mail.gmail.com>
 <CA+FuTSdpU_2w9iU+Rtv8pUepOcwqHYaV1jYVfB6_K157E6CSZw@mail.gmail.com> <CAHmME9rZieNAYeeK90HLoaoeKJEv5vE9MHfn-q5zFY8_ebNqxw@mail.gmail.com>
In-Reply-To: <CAHmME9rZieNAYeeK90HLoaoeKJEv5vE9MHfn-q5zFY8_ebNqxw@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 1 Jul 2020 12:28:13 -0400
Message-ID: <CAF=yD-KaG=SS5ujdYyeYXh6528SawgNBHteVf1ywDhMugV64Og@mail.gmail.com>
Subject: Re: wireguard: problem sending via libpcap's packet socket
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     Hans Wippel <ndev@hwipl.net>,
        WireGuard mailing list <wireguard@lists.zx2c4.com>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > header_ops looks like the best approach to me, too. The protocol field
> > needs to reflect the protocol of the *outer* packet, of course, but if
> > I read wg_allowedips_lookup_dst correctly, wireguard maintains the
> > same outer protocol as the inner protocol, no sit (6-in-4) and such.
>
> WireGuard does allow 6-in-4 and 4-in-6 actually. But parse_protocol is
> only ever called on the inner packet. The only code paths leading to
> it are af_packet-->ndo_start_xmit, and ndo_start_xmit examines
> skb->protocol of that inner packet, which means it entirely concerns
> the inner packet.

Of course, you are right. This inspects the packet before passing to
the device ndo_start_xmit, so before any encapsulation would take
place.

> And generally, for wireguard, userspace only ever
> deals with the inner packet. That inner packet then gets encrypted and
> poked at in strange ways, and then the encrypted blob of sludge gets
> put into a udp packet and sent some place. So I'm quite sure that the
> behavior just committed is right.
>
> And from writing a few libpcap examples, things seem to be working
> very well, including Hans' example.

Definitely. Thanks again.
