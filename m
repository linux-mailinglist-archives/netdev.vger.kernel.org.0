Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12F186D4341
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 13:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbjDCLSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 07:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232390AbjDCLSU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 07:18:20 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 051FF1710
        for <netdev@vger.kernel.org>; Mon,  3 Apr 2023 04:18:10 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l10-20020a05600c1d0a00b003f04bd3691eso2981541wms.5
        for <netdev@vger.kernel.org>; Mon, 03 Apr 2023 04:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680520688;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=6FHr1fLLaZ+lzCWl3wb43+wRrbD2mdbBZwOfBsvu1jE=;
        b=gCRNxh/HZ/PZjmfkVC6vSnVQQYGA+dCZOIGjrFx9BULIT+bVe756wCB3Ty6mzsoKq7
         lL2I0QudxKUX6rMZPHqzvRgiyigjK/F8MmWHSP1hh+EWichh8mM2r/dpM86PUThWuTe2
         otNPqz0qyxLcuvJS7apvKInW4fgwDCuPY+3VVaIiCa6MjJj+hQoW1+MSQsHWXMYhySxs
         jCDuu3GhpE2XBeY2xuNmS0agKHiE+MBoig8Nhh0BgJmQLv+kFr0a98HvOf0U/Ffb7Btu
         t1m8cA8UxyFvUkMSMhwlnpmKOz2IAxAwuaV1EIdjVm8y/jqtYuUXAUjCUdSZkzfAYNQ5
         4GFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680520688;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6FHr1fLLaZ+lzCWl3wb43+wRrbD2mdbBZwOfBsvu1jE=;
        b=GupgTaXeehAeThkYdBa5eJuNBeTdSz5MNWBRKWUF6/C72bCjXh8kp2HphGVFHHW5hI
         lWP/F8p/ECmj+HDAL9D41cQv/9GuLw8JebKmFcdfCWluuIOctsNwic1nBK9veI5vTmbf
         fEZR6jAWxW6vueEB/kMn5ZBAYRNWBH9U2d1a5ufy0DE1SyNWwKa+ykpEj/7USSnRdFRD
         ytRwhzwo7INz1A3tDvsb69mX6htIePFdnrBmKvc+8B40oZjU406WZl2Qo0tGYoaxHCgL
         r20lCUzGflJ7RiLy4o6ocEcVwMRnNZlmS81TdnWpmIGNhxcRlO0Mwoh6oqS2JcQAXhc8
         DGsQ==
X-Gm-Message-State: AO0yUKW/C+m6VUzYkH2VEFbM4HAgG66hoyK6XyK8cUeKtqA1qMRG53nO
        GfAqcfcoLpMjrm1KpOuFxPc=
X-Google-Smtp-Source: AK7set9XwQcEDGf1zkbHPbRheoRoWQnpSCsG12uPCJhnTPVK0dsAzbsBS7VNWQRLz9QWE2V0Ziqo/w==
X-Received: by 2002:a05:600c:acb:b0:3ed:29e1:ed21 with SMTP id c11-20020a05600c0acb00b003ed29e1ed21mr26800172wmr.37.1680520688202;
        Mon, 03 Apr 2023 04:18:08 -0700 (PDT)
Received: from [10.148.83.3] (business-89-135-192-225.business.broadband.hu. [89.135.192.225])
        by smtp.gmail.com with ESMTPSA id h16-20020a05600c315000b003eda46d6792sm19096930wmo.32.2023.04.03.04.18.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Apr 2023 04:18:07 -0700 (PDT)
Message-ID: <6546e93dca588c3c01e56466e6f5ae10e37870bf.camel@gmail.com>
Subject: Re: [PATCH iproute2-next 0/9] Add tc-mqprio and tc-taprio support
 for preemptible traffic classes
From:   Ferenc Fejes <primalgamer@gmail.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        =?ISO-8859-1?Q?P=E9ter?= Antal <antal.peti99@gmail.com>
Date:   Mon, 03 Apr 2023 13:18:07 +0200
In-Reply-To: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
References: <20230403105245.2902376-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.46.4-1 
MIME-Version: 1.0
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vladimir!

On Mon, 2023-04-03 at 13:52 +0300, Vladimir Oltean wrote:
> This is the iproute2 support for the tc program to make use of the
> kernel feature for preemptible traffic classes described here:
> https://patchwork.kernel.org/project/netdevbpf/cover/20230403103440.28956=
83-1-vladimir.oltean@nxp.com/
>=20
> The state of the man pages prior to this work was a bit
> unsatisfactory,
> so patches 03-07 contain some man page cleanup in tc-taprio(8) and
> tc-mqprio(8).
>=20
> Vladimir Oltean (9):
> =C2=A0 uapi: add definitions for preemptible traffic classes in mqprio an=
d
> =C2=A0=C2=A0=C2=A0 taprio
> =C2=A0 utils: add max() definition
> =C2=A0 tc/taprio: add max-sdu to the man page SYNOPSIS section
> =C2=A0 tc/taprio: add a size table to the examples from the man page

Seems like Stephen merged P=C3=A9ter's manpages patch [1] but IMO your
version [2] is a better overhaul of that, also P=C3=A9ter ACK-ed to go
forward with that version. Looks like you rebased this work on the new
manpages, you have any plan to submit the changes from [2] separately?
Probably Stephen missed the whole discussion and about [2] and I'm
admit that putting acked/reviewed into a mail inside the discussion
might be misleading (probably thats show up for the original patch in
patchwork). Sorry for making it complicated.

> =C2=A0 tc/mqprio: fix stray ] in man page synopsis
> =C2=A0 tc/mqprio: use words in man page to express min_rate/max_rate
> =C2=A0=C2=A0=C2=A0 dependency on bw_rlimit
> =C2=A0 tc/mqprio: break up synopsis into multiple lines
> =C2=A0 tc/mqprio: add support for preemptible traffic classes
> =C2=A0 tc/taprio: add support for preemptible traffic classes
>=20
> =C2=A0include/uapi/linux/pkt_sched.h | 17 ++++++
> =C2=A0include/utils.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 8 +++
> =C2=A0man/man8/tc-mqprio.8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 92 ++++++++++++++++++++++---------
> =C2=A0man/man8/tc-taprio.8=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 | 27 ++++++++--
> =C2=A0tc/q_mqprio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 98
> +++++++++++++++++++++++++++++++++
> =C2=A0tc/q_taprio.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 99 +++++++++++++++++++++=
++++-------
> --
> =C2=A06 files changed, 289 insertions(+), 52 deletions(-)
>=20

[1]
https://lore.kernel.org/netdev/167789641838.26474.2747633103367439718.git-p=
atchwork-notify@kernel.org/

[2]
https://lore.kernel.org/netdev/20230220161809.t2vj6daixio7uzbw@skbuf/

Best,
Ferenc
