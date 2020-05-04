Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6FBA1C3EB7
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 17:39:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729304AbgEDPja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 11:39:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:45825 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728294AbgEDPj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 11:39:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588606768;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vomwiI6E3OZTPIwQzb0j4jH7iaAx94lRHkGes+Oyn+c=;
        b=ZFsWXre3xITrF50HzQITQJ5KZB3H7X1wJ27Mtqvq9P88rfnjAiYQXC2Vol+60ZMyMIdLFz
        JsNO9Ku0ekjoCcHqBnnizmqDTv++JB1P+L0oj+OklRHyAs/dqfKKFwvoCs4yiRQutqmOb3
        y3h2uMoiuJRJ6Jd/OmggyP/zpeGy3Nw=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-231-SIM9YJzPPvSfIrG1bf9oiw-1; Mon, 04 May 2020 11:39:23 -0400
X-MC-Unique: SIM9YJzPPvSfIrG1bf9oiw-1
Received: by mail-io1-f72.google.com with SMTP id s26so13693221ioj.2
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 08:39:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vomwiI6E3OZTPIwQzb0j4jH7iaAx94lRHkGes+Oyn+c=;
        b=JH6KtYXyZqMsMEv9xWGon5rBlJ/QG3bk6XNDQCm0aJybKgjW+ct+mtJqAnY3gzHyQh
         UjGVQnR9A3tQOmfPCf40HAA6Kqq9+ax2fVPVRiURhbrFa+9ZrJWJHhK6bHNaqDIQ39Wn
         O5cT2zbWt3NxY5Eki42++EJiZ0BsZUUZXU7YGeoEomMbTXP3F5LdBdAwdFkcAe+6pGjR
         TtIN+ahsEJg7R2OSAlltZIFA6dVK31KPqCr/GghTI3EEa1tuuwg2g4qg5/6N2+lawipv
         wu19uwxnXWo4nZqsDjtMMGqmSZdMRU+WkwiXED/CEw8e9Bx+12kw9p+rBAxMe0KZGzvf
         AaVA==
X-Gm-Message-State: AGi0Pua5kM9fBLYaakql2KUGHd8cQywEXBYEwNuzAWqfLCHjra+S/nd3
        m7diCtDqes/MpPYFYMagS6WbsjhU1eMzaeqkGFXq0B1rKK5vmltddec3HTCpuY2vprQxB3Jr2mg
        jeh2DXasF4T6DDoRCBbWJHfR6KatRH+RY
X-Received: by 2002:a92:8d9d:: with SMTP id w29mr17471390ill.168.1588606763071;
        Mon, 04 May 2020 08:39:23 -0700 (PDT)
X-Google-Smtp-Source: APiQypKq01SVDgWMIMGsXX1mxjePwkT7Q+R7Df8dhr1U+x0jV7hLCrh6nm+34BJ6jr4/pEHRU3/Ofb17hre9+xNsiEA=
X-Received: by 2002:a92:8d9d:: with SMTP id w29mr17471288ill.168.1588606761925;
 Mon, 04 May 2020 08:39:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200430185033.11476-1-maorg@mellanox.com> <CAKfmpSdchyUZT5S7k07tDzwraiePsgRBvGe=SaaHvvm83bbBhg@mail.gmail.com>
 <27196f08-953a-4558-7c95-90fb13976c92@gmail.com>
In-Reply-To: <27196f08-953a-4558-7c95-90fb13976c92@gmail.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Mon, 4 May 2020 11:39:11 -0400
Message-ID: <CAKfmpSdpQDWVf4sdF9UyVyaGp8uW4fC8bVG-q1zmM+j3LKcWMw@mail.gmail.com>
Subject: Re: [PATCH V7 mlx5-next 00/16] Add support to get xmit slave
To:     David Ahern <dsahern@gmail.com>
Cc:     Maor Gottlieb <maorg@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, jgg@mellanox.com,
        Doug Ledford <dledford@redhat.com>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, kuba@kernel.org,
        jiri@mellanox.com, dsahern@kernel.org, leonro@mellanox.com,
        saeedm@mellanox.com, linux-rdma@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>, alexr@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 4, 2020 at 10:42 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 5/4/20 8:36 AM, Jarod Wilson wrote:
> > At a glance, I'm not sure why all the "get the xmit slave" functions
> > are being passed an skb. None of them should be manipulating the skb,
> > that should all be done in the respective xmit functions after the
> > slave has been returned.
>
> a number of them select a slave based on hash of the packet data -- from
> ethernet data only to L3+L4 hashing.

Ah, right, I see it now for the 3ad/xor case. So it makes sense to
pass it into the ndo, but for example
bond_xmit_activebackup_slave_get() simply does "return
rcu_dereference(bond->curr_active_slave);", so no real need to pass it
skb. The per-mode functions are all static, could drop the unneeded
passing of skb there. Looks like v8 is already merged though, so meh.


-- 
Jarod Wilson
jarod@redhat.com

