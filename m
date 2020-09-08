Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29A9D260ABB
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 08:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgIHGTp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 02:19:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726787AbgIHGTo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 02:19:44 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84FA8C061573;
        Mon,  7 Sep 2020 23:19:43 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id c10so13911233otm.13;
        Mon, 07 Sep 2020 23:19:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O6IpCwnpVtuGiVfJIjlwB8wH7sUVjdjhn0wXwD10MTI=;
        b=uP2Fx1u17fd93yAjsHtJWGchrz7RZ2ywazWvuDld9ZK5zydAWJ8wes1PlVcqECWVpE
         IY/cmwCrpRC3FOaG90diGm4+pfRbmZIuR1YczmGjFAsaArDShQbWc1dBw73ZIOgOLRhJ
         1DNH6FWN5BQps7sQUlP8vnjcLs1yPA77tVYV90HpBJOcKs020rGgURxipCEibHKlndWI
         lmIyH2dhGxo0534Ybz6iSUZsS8DWkfLKGqCkuDv6P4QQjPV2dwYvOeVr9NTw11OLEPxP
         fYPdb9/ap+NPfkK9qbbkIX1BBx7iAdls1qHvIgZG2JDTv0KaWOgS2KMtmARs5q/zXKPr
         Zbog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O6IpCwnpVtuGiVfJIjlwB8wH7sUVjdjhn0wXwD10MTI=;
        b=fr+kddgMQkAW2EL1jgI37W5D1hvTHevCRhYjEoTTuAA7jawjE0vJJeVNfniCfEt/k4
         fv3MieXUQMbtzVVHdcQkwU5a20WSNrwyM/t1UY++Jm0A9w/tM6P3pwXPG0vMOKo4rX2L
         52SO0ckwbdogE+q4WzypOXccLnESoH1wBw3LQNp96ZndGJWimA9nf9kXG/IQVolU9pmQ
         pNYFzJaz7VJ3CDd+hx4niDMS9uo7DgsbHBllKN93MiaeLitviGbAPZLp15V9Q1MG2exY
         X5hPdpijcKhUG7LD/+Z7i7+IGlaONUkeQucgIRwkVC2eGLDtokl9few0+D+0hDI4U4+B
         DK/Q==
X-Gm-Message-State: AOAM53395ugeFdmzQxvh7smL6t4zmC5iDwlbjq7KMTQojs/dh+/VDGvm
        FYjv1tQ6JzfzUaC2eoMEryaLZyVJsDkOGHPyhZs=
X-Google-Smtp-Source: ABdhPJwPVozyVw2sgKIYfk4YB+lMYcydSx1Iyg5o+9TfaKmqOSlJ6yvBOGNKcX9PGZPtulqcEd0HWDjDn69Shq0NALY=
X-Received: by 2002:a9d:315:: with SMTP id 21mr305769otv.278.1599545982863;
 Mon, 07 Sep 2020 23:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200904162154.GA24295@wunner.de> <813edf35-6fcf-c569-aab7-4da654546d9d@iogearbox.net>
 <CAF90-WhWpiAPcpU81P3cPTUmRD-xGkuZ9GZA8Q3cPN7RQKhXeA@mail.gmail.com> <b1ae75ac-82b5-aa24-c59a-3988d94d6a10@iogearbox.net>
In-Reply-To: <b1ae75ac-82b5-aa24-c59a-3988d94d6a10@iogearbox.net>
From:   =?UTF-8?Q?Laura_Garc=C3=ADa_Li=C3=A9bana?= <nevola@gmail.com>
Date:   Tue, 8 Sep 2020 08:19:31 +0200
Message-ID: <CAF90-WjhAS6V_UFYpsnxUDH=sH+1j_2y+Sz2RHU7CWo4iPiC7w@mail.gmail.com>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Lukas Wunner <lukas@wunner.de>,
        John Fastabend <john.fastabend@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        Netfilter Development Mailing list 
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, David Miller <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Daniel,

On Tue, Sep 8, 2020 at 12:11 AM Daniel Borkmann <daniel@iogearbox.net> wrot=
e:
>
> On 9/5/20 1:18 PM, Laura Garc=C3=ADa Li=C3=A9bana wrote:
> > On Fri, Sep 4, 2020 at 11:14 PM Daniel Borkmann <daniel@iogearbox.net> =
wrote:
> [...]
> > Something like this seems more trivial to me:
> >
> > table netdev mytable {
> >      chain mychain {
> >          type filter hook egress device "eth0" priority 100; policy dro=
p;
> >          meta protocol !=3D 0x419C accept
> >      }
> > }
>
> Sure, different frontends, so what?! You could also wrap that code into a
> simple a.out or have nft style syntax jit to bpf ...

Not only syntax but get rid of bpf and tc from the application stack
and only maintain 1 interface.

Thanks!
