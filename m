Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5B9677F87
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 16:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjAWPWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 10:22:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232686AbjAWPVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 10:21:52 -0500
Received: from mail-yw1-x1135.google.com (mail-yw1-x1135.google.com [IPv6:2607:f8b0:4864:20::1135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E82B329E18
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:21:24 -0800 (PST)
Received: by mail-yw1-x1135.google.com with SMTP id 00721157ae682-4c24993965eso176094397b3.12
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 07:21:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugBfr4HQ6vUJYBYoIyvCDCt0C79bN4oDlYgJluHbjPU=;
        b=dOZs1GQJ8lOuVmDSD8KRC55EqW2B+ZwGdtl7ne4J06eXJ43mP1wzXmwAR/q14wPIgl
         SCcCreTg4Bt/JeSq2H9qxJcnBtBdgsfEWY4GaoGphpVyzS4BR4q4M8VsKeSczJkvCe6n
         7yLUGhB09prayHQ1ErhV1Vyyolnc0tsBdiZriZeOUX62N8FQi3MUZyg6D6VbeEb3YHJD
         O72Y7KHW/okJiQHiwHyxFSOuGsF05HL2RuJdPOI7myKOhXFvFBkY/66oW/QaD66F31Zo
         IIGZdcKiriqAOZFVhcfFK71eN/Tm9BpJSon74odp7Eur9n6ju4PfTc3Ws0vpMx8edoUi
         DPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ugBfr4HQ6vUJYBYoIyvCDCt0C79bN4oDlYgJluHbjPU=;
        b=wrxhHxHuMWsmTtvJTKMjSi/OhuY44XvSci3cFURPLbz8gpQxMt6hWoOlzfYy95M6iv
         JQtckxIGPQXB63MAReMUXPd/JH3WQLLo82MLA7UYr9+mNiMKfVV70ZH0DGZmLfJDeTDe
         wssqVZ6odBNjKuf++A6SqrEitEzpa2CA9A/fgMgc4A9nJH+Ibbbx+4qbuEaBW+xzxgj1
         avGSWj5NGRwN7LYM7tq/4o1RoNuXeUTnJGo775LUmpn2S9jp/fRrbIK4FIqv7Pba5npa
         SKpYI/AwpQgXPJ9SLVkx+QZinSJRK25xXMth+Ss8NCcSNDuaZVlW5gwNgqYvwjsFG1QZ
         uvUQ==
X-Gm-Message-State: AFqh2kq1yldkVKNsfzNc1ZLGT2t35VVbRUZJVvd7lzs1PA4snjRAzpT4
        ztOtrxsUMuZB2yiMw14X5AVO5ahMSL740OJjhSH1JA==
X-Google-Smtp-Source: AMrXdXtCvOVnd50rlCyREtjZgCpGTJKxJTu07tM7AeziFA07lrE7cXER87hBkQBV9BEj3S+btFzr33dz8vHwoKLN4N4=
X-Received: by 2002:a81:d42:0:b0:501:5ab3:9e6e with SMTP id
 63-20020a810d42000000b005015ab39e6emr1433919ywn.278.1674487279485; Mon, 23
 Jan 2023 07:21:19 -0800 (PST)
MIME-Version: 1.0
References: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
In-Reply-To: <f171a249-1529-4095-c631-f9f54d996b90@gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Mon, 23 Jan 2023 16:21:08 +0100
Message-ID: <CANn89iK1aPiystTAk2qTnzsN-LFskJ4BxL=XgTk2aLpExrWFEw@mail.gmail.com>
Subject: Re: traceroute failure in kernel 6.1 and 6.2
To:     =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 21, 2023 at 7:09 PM Mantas Mikul=C4=97nas <grawity@gmail.com> w=
rote:
>
> Hello,
>
> Not sure whether this has been reported, but:
>
> After upgrading from kernel 6.0.7 to 6.1.6 on Arch Linux, unprivileged
> ICMP traceroute using the `traceroute -I` tool stopped working =E2=80=93 =
it very
> reliably fails with a "No route to host" at some point:
>
>         myth> traceroute -I 83.171.33.188
>         traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>         byte packets
>          1  _gateway (192.168.1.1)  0.819 ms
>         send: No route to host
>         [exited with 1]
>
> while it still works for root:
>
>         myth> sudo traceroute -I 83.171.33.188
>         traceroute to 83.171.33.188 (83.171.33.188), 30 hops max, 60
>         byte packets
>          1  _gateway (192.168.1.1)  0.771 ms
>          2  * * *
>          3  10.69.21.145 (10.69.21.145)  47.194 ms
>          4  82-135-179-168.static.zebra.lt (82.135.179.168)  49.124 ms
>          5  213-190-41-3.static.telecom.lt (213.190.41.3)  44.211 ms
>          6  193.219.153.25 (193.219.153.25)  77.171 ms
>          7  83.171.33.188 (83.171.33.188)  78.198 ms
>
> According to `git bisect`, this started with:
>
>         commit 0d24148bd276ead5708ef56a4725580555bb48a3
>         Author: Eric Dumazet <edumazet@google.com>
>         Date:   Tue Oct 11 14:27:29 2022 -0700
>
>             inet: ping: fix recent breakage
>
>
>
>
> It still happens with a fresh 6.2rc build, unless I revert that commit.
>
> The /bin/traceroute is the one that calls itself "Modern traceroute for
> Linux, version 2.1.1", on Arch Linux. It seems to use socket(AF_INET,
> SOCK_DGRAM, IPPROTO_ICMP), has neither setuid nor file capabilities.
> (The problem does not occur if I run it as root.)
>
> This version of `traceroute` sends multiple probes at once (with TTLs
> 1..16); according to strace, the first approx. 8-12 probes are sent
> successfully, but eventually sendto() fails with EHOSTUNREACH. (Though
> if I run it on local tty as opposed to SSH, it fails earlier.) If I use
> -N1 to have it only send one probe at a time, the problem doesn't seem
> to occur.



I was not able to reproduce the issue (downloading
https://sourceforge.net/projects/traceroute/files/latest/download)

I suspect some kind of bug in this traceroute, when/if some ICMP error
comes back.

Double check by

tcpdump -i ethXXXX icmp

While you run traceroute -I ....
