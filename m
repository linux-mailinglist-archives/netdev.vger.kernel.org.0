Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0321439CD
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 10:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgAUJth (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 04:49:37 -0500
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46398 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727220AbgAUJth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 04:49:37 -0500
Received: by mail-yb1-f193.google.com with SMTP id p129so1049941ybc.13
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 01:49:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1z3mnOKil5HkL669PbtTDr8gfQp3DZ3+MQ+nlCBbP/c=;
        b=egrKvjTO7MrfYKSlH2Rq62lHFIv9wGDo5s/M4+8GKVMdvpZY2LAbyRTaHLQprucA2/
         j48OxFT7x1Ug0SkvvHHvs9X5Q6nVs5leAILjHv2pQBzNWNKOa3ZvM7c5WYi/2sDy1n7f
         1G7lgkOFduwD+3rf0BZsEHlnGbj3CMY04LsAtAejolBqXOyGIUEGNXuLnaWVeqx6VdpO
         rNrt+dng0siSW7Y4eH187KJPqo35k+jR3nubfuS7dK/W0jZJyT2r/Awu4Nzu9PzEdT/M
         L2FAS7Toi+Sz8NbT/Yr/N1vjj/5JL12oHqHLQQwtOQeK+tAuSnAQ/Em07XSXeK0Wujaj
         E6Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1z3mnOKil5HkL669PbtTDr8gfQp3DZ3+MQ+nlCBbP/c=;
        b=W1rVgTlGfsgMyUycvjoiO3d+CTP2sJ97q8uYVfFMhmPrj3lMqJB/idbcaVenygPS96
         NdVGgGtZ5Gl+InIt/DIj4lsnySSb9MIcrJn0daWjP60TnWBTI5ffUZjNpIFgq4m1MRTu
         IVTuiFlvmXiOX1cbigmTWAhVl5nzEz1VtFcSSZNKr1zBPpvKlTH819C2EYNOlzgHpcfF
         QLWHXi/Pf+cGTucDAonYGcYl2IN76X0NTnp9olZlcEPcVSGe2fvrnu9zNvCJedQxxY3W
         dXVIT63Sa8YYnaz6Noc7iqEY212CmnZPvKnDM2r82qpQAa/qfKTEt8Qhn3ciIumiyuBj
         MvUw==
X-Gm-Message-State: APjAAAWQ4UDnp7HKyoVOeXkpjfdVIq8AvaLwAjtI6VCVabJ3SoTKqN+j
        +jlkiOvu37ObGxT42jozqvksbd0hyvQfBUVqw5bMyQ==
X-Google-Smtp-Source: APXvYqzgoKkgxTrB4p+C19Wt/klRNLxoRVvcPjEk9FS+MViBUpn7q2OkwtB/bvpO1JjyrKcb/zhOoPOUo7Oi9V60iow=
X-Received: by 2002:a25:9b48:: with SMTP id u8mr3033841ybo.129.1579600176465;
 Tue, 21 Jan 2020 01:49:36 -0800 (PST)
MIME-Version: 1.0
References: <1579400705-22118-1-git-send-email-xiangxia.m.yue@gmail.com> <73d77bc7-6a1b-44de-a45f-967bbda68894@mellanox.com>
In-Reply-To: <73d77bc7-6a1b-44de-a45f-967bbda68894@mellanox.com>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 21 Jan 2020 11:49:25 +0200
Message-ID: <CAJ3xEMiiYaJ0QorDyKqpo6cpfhQ1k9HV3z=4=5FpB_q9h4ffOA@mail.gmail.com>
Subject: Re: [PATCH net-next v2] net/mlx5e: Don't allow forwarding between uplink
To:     Roi Dayan <roid@mellanox.com>
Cc:     "xiangxia.m.yue@gmail.com" <xiangxia.m.yue@gmail.com>,
        "saeedm@dev.mellanox.co.il" <saeedm@dev.mellanox.co.il>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 11:39 AM Roi Dayan <roid@mellanox.com> wrote:
> On 2020-01-19 4:25 AM, xiangxia.m.yue@gmail.com wrote:

> I noticed you still modified mlx5e_is_valid_eswitch_fwd_dev() which
> is called from parse tc actions and also from resolving route for vxlan rules.
>
> I tested the patch for normal, lag and ecmp modes.
> ecmp vxlan encap rule breaks now as not supported.
> the break is in get_route_and_out_devs() at this part
>
> else if (mlx5e_eswitch_rep(dev) &&
>                  mlx5e_is_valid_eswitch_fwd_dev(priv, dev))
>
> since ecmp is like lag we fail on the same scenario here that
> we test uplink priv but not input vport.

Guys,

I thought we agreed to hold on with blocking this in the driver -
should 1st see that the FW is fixed.
