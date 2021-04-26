Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA14236AFC3
	for <lists+netdev@lfdr.de>; Mon, 26 Apr 2021 10:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbhDZIcT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 04:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhDZIcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 04:32:18 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 692DCC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:31:37 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id n2so83132299ejy.7
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 01:31:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=3LS/C6v9PlOsX0rnk9KD3LMPQee0aw0PjcSFfHRj7VA=;
        b=mNHjcvBmV7xHyu+usfAYPg/sCa0QZg9DlUBf6DzvXguizIZByCsRYPCGb1o+fEG/88
         7HV68u9zLEguSX47SBGHjoxr6PfqJRslEAYj+CfayXsDgm8VQXAFnkXHROCozxmG2h4N
         khOUKHxbe3HjzNmyNMWpQ/BY7eJ0+g0SG25iCOFM21RxU3o431j1sHzrr/7Yi3cNFzmM
         za7jsgjQoZNN+lvMw+2LEW1WmFE/DaOdweexDpyn2nJQVMYCViaAjize41tg3L+Ht0oz
         m1skdGiTPDSXN4uzNPeBS1BY4DUYGThTV4hFHqRlfpusxTJwBNXmWHb65MeCOOA3tXRP
         v4kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=3LS/C6v9PlOsX0rnk9KD3LMPQee0aw0PjcSFfHRj7VA=;
        b=ULTS/7qbxk+OOtC0aXAx9ZgHkkW0l45qY7UfSr2poyztc4bEdViXethVe81AeM15wE
         D5Z654Q2qWLtdJ9Fjcnr+PAUFhu9y6JENAqyI0eZtlqMf/iOQiK36nhwmeNYz3qIFiYt
         counFddH8nB+u3hUYt8SMlhYZ8bP+rDyDHgdVNt6LActJYO53P4JAFxRuiRPulUg8NPy
         Q9S5ZWTjNvpFnY1LUtrGoR9e3YFDnxz5dISC/y+rvYBHubC/iWCj1uzcALEl42DLpPpB
         rkFckTIfo9dWmiiebJDrX8cb0D5zJe3hpZNyLXmJat1JnNtFj/3flmMalIg96THfDkIj
         Gqfw==
X-Gm-Message-State: AOAM533yyAwcrehJLv4j9ziyApuJvwaf4I45JouxOKD5WfEhGJOli3TB
        aD1s0BRnASZax9qJrOOooUw=
X-Google-Smtp-Source: ABdhPJyu9iO5i8pNbN2wKLo4uMLO8NscSsnZofXFvK2buy0DfKNqbhgcBoq8AR+wia+Tl/D7Kl4sbQ==
X-Received: by 2002:a17:907:c0b:: with SMTP id ga11mr17138438ejc.545.1619425896140;
        Mon, 26 Apr 2021 01:31:36 -0700 (PDT)
Received: from smtpclient.apple ([178.254.237.20])
        by smtp.gmail.com with ESMTPSA id n11sm11227829ejg.43.2021.04.26.01.31.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Apr 2021 01:31:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.80.0.2.43\))
Subject: Re: Bug Report Napi GRO ixgbe
From:   Martin Zaharinov <micron10@gmail.com>
In-Reply-To: <00722e87685db9da3ef76166780dcbf5b4617bf7.camel@redhat.com>
Date:   Mon, 26 Apr 2021 11:31:34 +0300
Cc:     netdev <netdev@vger.kernel.org>, Wei Wang <weiwan@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>, alobakin@pm.me
Content-Transfer-Encoding: quoted-printable
Message-Id: <457C51FA-5AD3-40AE-B8CE-AFBDB81DD258@gmail.com>
References: <20210316223647.4080796-1-weiwan@google.com>
 <6AF20AA6-07E7-4DDD-8A9E-BE093FC03802@gmail.com>
 <CANn89iJxXOZktXv6Arh82OAGOpn523NuOcWFDaSmJriOaXQMRw@mail.gmail.com>
 <AE7C80D4-DD7E-4AA7-B261-A66B30F57D3B@gmail.com>
 <CANn89iKyWgYeD_B-iJxL50C4BHYiDh+dWOyFYXatteF=eU7zoA@mail.gmail.com>
 <9F81F217-6E5C-49EB-95A7-CCB1D3C3ED4F@gmail.com>
 <00722e87685db9da3ef76166780dcbf5b4617bf7.camel@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
X-Mailer: Apple Mail (2.3654.80.0.2.43)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Paolo
Sorry for delay.

After disable gro on eth interface and team0 and now work fine.

In this case I user kernel 5.11.12 but after release 5.12 I will migrate =
to them and will check for problem with kthread.

Thanks,
I will update if have other problem.

Martin=09

> On 12 Apr 2021, at 11:36, Paolo Abeni <pabeni@redhat.com> wrote:
>=20
> Hello,
>=20
> On Sat, 2021-04-10 at 14:22 +0300, Martin Zaharinov wrote:
>> Hi  Team
>>=20
>> One report latest kernel 5.11.12=20
>>=20
>> Please check and help to find and fix
>=20
> Please provide a complete splat, including the trapping instruction.
>>=20
>> Apr 10 12:46:25  [214315.519319][ T3345] R13: ffff8cf193ddf700 R14: =
ffff8cf238ab3500 R15: ffff91ab82133d88
>> Apr 10 12:46:26  [214315.570814][ T3345] FS:  0000000000000000(0000) =
GS:ffff8cf3efb00000(0000) knlGS:0000000000000000
>> Apr 10 12:46:26  [214315.622416][ T3345] CS:  0010 DS: 0000 ES: 0000 =
CR0: 0000000080050033
>> Apr 10 12:46:26  [214315.648390][ T3345] CR2: 00007f7211406000 CR3: =
00000001a924a004 CR4: 00000000001706e0
>> Apr 10 12:46:26  [214315.698998][ T3345] DR0: 0000000000000000 DR1: =
0000000000000000 DR2: 0000000000000000
>> Apr 10 12:46:26  [214315.749508][ T3345] DR3: 0000000000000000 DR6: =
00000000fffe0ff0 DR7: 0000000000000400
>> Apr 10 12:46:26  [214315.799749][ T3345] Call Trace:
>> Apr 10 12:46:26  [214315.824268][ T3345]  =
netif_receive_skb_list_internal+0x5e/0x2c0
>> Apr 10 12:46:26  [214315.848996][ T3345]  napi_gro_flush+0x11b/0x260
>> Apr 10 12:46:26  [214315.873320][ T3345]  =
napi_complete_done+0x107/0x180
>> Apr 10 12:46:26  [214315.897160][ T3345]  ixgbe_poll+0x10e/0x2a0 =
[ixgbe]
>> Apr 10 12:46:26  [214315.920564][ T3345]  __napi_poll+0x1f/0x130
>> Apr 10 12:46:26  [214315.943475][ T3345]  =
napi_threaded_poll+0x110/0x160
>> Apr 10 12:46:26  [214315.966252][ T3345]  ? __napi_poll+0x130/0x130
>> Apr 10 12:46:26  [214315.988424][ T3345]  kthread+0xea/0x120
>> Apr 10 12:46:26  [214316.010247][ T3345]  ? kthread_park+0x80/0x80
>> Apr 10 12:46:26  [214316.031729][ T3345]  ret_from_fork+0x1f/0x30
>=20
> Could you please also provide the decoded the stack trace? Something
> alike the following will do:
>=20
> cat <file contaning the splat> | ./scripts/decode_stacktrace.sh <path =
to vmlinux>
>=20
> Even more importantly:
>=20
> threaded napi is implemented with the merge
> commit adbb4fb028452b1b0488a1a7b66ab856cdf20715, which landed into the
> vanilla tree since v5.12.rc1 and is not backported to 5.11.x. What
> kernel are you really using?
>=20
> Thanks,
>=20
> Paolo

