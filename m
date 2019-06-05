Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E24E435539
	for <lists+netdev@lfdr.de>; Wed,  5 Jun 2019 04:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbfFECZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 22:25:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40080 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726354AbfFECZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 22:25:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id v19so618959wmj.5
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 19:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SnYR6UZNsIvvezN/6trGEygcm/uVduKyboqjmbEpP9c=;
        b=ultpNBTaJe8wTr2RMZjxbkkAHpcs+N5Qbak1KbsiqMtl4gzjHFdM3RVb14kGvH+zCx
         st1ppCYB+VD6eAs+XHKXu1AIi+vV3eA7VcK0JpV1vV0t9NgsTniggY2oVAB7umjlQeS0
         7Kdq7zVpVq3adlId/zIcr+ga3ASd20C7cUSOvwjJFbJ/HFnyWneTxd5cub/0zBTxbJ/Z
         0jDM345kodlVKkwBHp59Po/AEBE5Nons9o974ASL2Y+4ZxvOhT1Zkcpv5dLitG7oiAFk
         n0WuzYguAYR/B8nNHHOxs9J3f22s0va9mhcFGMClWs4TNGpISboO/E9fVhDVaB8og4R3
         TB9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SnYR6UZNsIvvezN/6trGEygcm/uVduKyboqjmbEpP9c=;
        b=eKBifxVCSO4JprW8383342lhADc8EpRtaQMw1q+z3EvwThbK+r8NVlpNwM7yrMQ2By
         L8RWWwNRCU634cAxwuxAW1tTwdKjKf2BqPiv6m4bI7skAcrXielmI8lF4gsNmcb/uA/N
         BsmCWDdTVvl5YYPasTTGvKrubTla75rOcAN+enTEY0CVusBbwwDeTjceHjJCVWaFDgpu
         UIwqVtuJR8LUCaC4zOFUilMUcrTPNo7ogoAiIAZdZkskP1tPXjDxvrcTGsMYgX+wENq4
         YimStQC/1Xtrj0VKOtk0Ukux15Eh/szbDXkeD1jPPW17tP5ZBUVynomZkXjfaqALOi7O
         Ds4A==
X-Gm-Message-State: APjAAAUpJ9SlftulSwkC/qYNsjUQSd1TSqsBDLWldkxqd3ZPmO6SQbrb
        1+DyW+YU/oE2kYq2gpiq/Y6w4rFa4yh3Um7I4/M+aA==
X-Google-Smtp-Source: APXvYqzrkj4SrglYfwm2m8irSGKyjWgmAMoRYHzLGbNogklt6ZQGQnKoULwjcAA8pSaU4VYQO16wXtOgifHiJhRHdR4=
X-Received: by 2002:a7b:c444:: with SMTP id l4mr8285341wmi.15.1559701524983;
 Tue, 04 Jun 2019 19:25:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190507091118.24324-1-liuhangbin@gmail.com> <20190508.093541.1274244477886053907.davem@davemloft.net>
 <CAHo-OozeC3o9avh5kgKpXq1koRH0fVtNRaM9mb=vduYRNX0T7g@mail.gmail.com>
 <20190605014344.GY18865@dhcp-12-139.nay.redhat.com> <CAKD1Yr3px5vCAmmW7vgh4v6AX_gSRiGFcS0m+iKW9YEYZ2wG8w@mail.gmail.com>
 <20190605021533.GZ18865@dhcp-12-139.nay.redhat.com>
In-Reply-To: <20190605021533.GZ18865@dhcp-12-139.nay.redhat.com>
From:   Lorenzo Colitti <lorenzo@google.com>
Date:   Wed, 5 Jun 2019 11:25:11 +0900
Message-ID: <CAKD1Yr1UNV-rzM3tPgcsmTRok7fSb43cmb4bGktxNsU0Bx3Hzw@mail.gmail.com>
Subject: Re: [PATCH net] fib_rules: return 0 directly if an exactly same rule
 exists when NLM_F_EXCL not supplied
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     David Ahern <dsahern@gmail.com>,
        David Miller <davem@davemloft.net>,
        Yaro Slav <yaro330@gmail.com>,
        Thomas Haller <thaller@redhat.com>,
        Alistair Strachan <astrachan@google.com>,
        Greg KH <greg@kroah.com>,
        Linux NetDev <netdev@vger.kernel.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 11:15 AM Hangbin Liu <liuhangbin@gmail.com> wrote:
> How do you add the rules? with ip cmd it should has NLM_F_EXCL flag and
> you will get -EEXIST error out.

The fact that the code worked before this commit implies that it was
*not* using NLM_F_EXCL. :-)
The code is here if you want to take a look.

https://android.googlesource.com/platform/system/netd/+/master/server/RouteController.cpp#576
https://android.googlesource.com/platform/system/netd/+/master/server/NetlinkCommands.h#33
