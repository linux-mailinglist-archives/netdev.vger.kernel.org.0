Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D4911035A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 01:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbfD3Xdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 19:33:41 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34165 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbfD3Xdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Apr 2019 19:33:41 -0400
Received: by mail-pg1-f195.google.com with SMTP id c13so6599832pgt.1;
        Tue, 30 Apr 2019 16:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yfh9BzfzF2kTBQWbbF//TMwNJfjcByuhaFdN+KNSCPY=;
        b=MBqQmkmeWTkfrQNTOhiybCv6h3lmsmddjluCeIfh0JOaFsPZm7uvpVuaYn/NjhRJu/
         GW0XRtE6gKh1QFL08ubQLvoeCuDZnOp1qLHuzseWONl5X1oYZvRE5/eoM/CJU6SGw+ta
         GlCtYd8bNl5QxVEBB8iqC5U8KCBstuWEaxYwgnN04HNedQpielHoWvX84+U4pmoTQEqb
         4wt5a7Zo+O0SnpSflR5I2QEuLprgsqC65aOrdFflN8LkLsmNEwthD670BDgMxz1qKgI0
         McxxxhpbNA4130Dj6e5AUUA+9ODoiYQtOw6uq7+NdSxMX/HZPfXEQ4VdD0XQFNptSHoL
         ulAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yfh9BzfzF2kTBQWbbF//TMwNJfjcByuhaFdN+KNSCPY=;
        b=k8ylkl1DN0uNncRwA0R5WHHm452MlquTyeNxrpy0kgWqRG+3jGgteMJyNqiLCL8l+V
         o528K5YTNWQD5ZYGrRm2Om577OSsgaD2gc6k5g/aOYAZsMUl2bnG4Voxommr8qxqAJIn
         vIkNDfmu8mznCuqm48886U5xwau5UOcniBlqavfXp6VUUQO6tH95zOcMXIXu9sqSUHTS
         FkiUIdRIJ6T7mo1XNYg5wBZvBIXV0FKV/YWLl9UgO82hag0m9Cr15Y/ZGVYJFdmGi3Yy
         /ffCPa1v9+N2udt1souv8A8lGKvsOn22sHcl2+1hz9jIiGeuXm48tyuN9I3ztSpSOOeA
         nVDg==
X-Gm-Message-State: APjAAAWI204+TmbYALEEtseYyUdjrUjLuM6Ru5dvw8nIMMfU9wKQKa5t
        YgA5RTUxwi9TSDll3oxmlBtYl6ItLmMF7SH4FKk=
X-Google-Smtp-Source: APXvYqyj3rW7My3WNzBw5igeS1yAx1PECJvSaIg5pyZXw55zAl4M71Uo5sGHZggSWwy7P+khkn9g9PUhG21xhlk9IZE=
X-Received: by 2002:a63:6604:: with SMTP id a4mr38265766pgc.104.1556667220498;
 Tue, 30 Apr 2019 16:33:40 -0700 (PDT)
MIME-Version: 1.0
References: <71250616-36c1-0d96-8fac-4aaaae6a28d4@redhat.com>
 <20190428030539.17776-1-yuehaibing@huawei.com> <516ba6e4-359b-15d0-e169-d8cc1e989a4a@redhat.com>
 <2c823bbf-28c4-b43d-52d9-b0e0356f03ae@redhat.com> <6AADFAC011213A4C87B956458587ADB4021F7531@dggeml532-mbs.china.huawei.com>
 <b33ce1f9-3d65-2d05-648b-f5a6cfbd59ab@redhat.com> <CAM_iQpUfpruaFowbiTOY7aH4Ts-xcY4JACGLOT3CUjLqpg_zXw@mail.gmail.com>
 <528517144.24310809.1556504619719.JavaMail.zimbra@redhat.com>
 <CAM_iQpXNp4h-ZAf4S+OH_1kVE_qk_eb+r6=ZUsK1t2=3aQOOtw@mail.gmail.com> <89f38a2b-c416-f838-ee85-356bffed5bdb@huawei.com>
In-Reply-To: <89f38a2b-c416-f838-ee85-356bffed5bdb@huawei.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 30 Apr 2019 16:33:28 -0700
Message-ID: <CAM_iQpUvv5yMZYecaKeiThfoUqqK1Lwvn0gi8KLAeksUxDEyLA@mail.gmail.com>
Subject: Re: [PATCH] tun: Fix use-after-free in tun_net_xmit
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        "weiyongjun (A)" <weiyongjun1@huawei.com>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "Li,Rongqing" <lirongqing@baidu.com>,
        nicolas dichtel <nicolas.dichtel@6wind.com>,
        Chas Williams <3chas3@gmail.com>, wangli39@baidu.com,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Peter Xu <peterx@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 29, 2019 at 7:44 PM YueHaibing <yuehaibing@huawei.com> wrote:
>
> With SOCK_RCU_FREE tfile is ok ,
>
> but tfile->sk is freed by sock_put in __tun_detach, it will trgger

SOCK_RCU_FREE is exactly for sock and for sock_put(),
you need to look into sock_put() path to see where SOCK_RCU_FREE
is tested.


>
> use-after-free in tun_net_xmit if tun->numqueues check passed.

Why do you believe we still have use-after-free with SOCK_RCU_FREE?

tun_net_xmit() holds RCU read lock, so with SOCK_RCU_FREE,
the sock won't be freed until tun_net_xmit() releases RCU read lock.
This is just how RCU works...
