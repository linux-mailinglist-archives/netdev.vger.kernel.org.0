Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8B249ACAF
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 07:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359596AbiAYGtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 01:49:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358959AbiAYGq5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 01:46:57 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0CEC07597D;
        Mon, 24 Jan 2022 21:09:26 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id y17so7711284plg.7;
        Mon, 24 Jan 2022 21:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oeTEp2rB9dc4PJgyacmkSyq1DnjRfsybkwCycdXUsGs=;
        b=Hr9ia0X3q2nSdh1Yg8YMr9AAWSS8SVvWVgNhE6UYrGE5ZCVqKWYNluuId3WuC4LaTV
         Ivt1YKz1q/2uukeTwh49RYp/3015L8kuwEUB4lv9WsSvJ25loEEORzt7fxx42V0sOK9q
         jXv9jIZiekuycv+NoZOg/f7WSg0Psbr0EfFC+O9aQyNcJ54yfGKg/BH6+NF70INvBmlZ
         edwm83UJRLH1BO2A93v+xSSwEeuN8rv4/w2GbD+BHeNxC50K2xkcENur4jD3vzg0rH4k
         lOZpzSBv6T9BLSjARPFOY8lJiKM8Fi/ajHDRx0b/ZQ0hW562VK6jDlocp8xl0u6vEszg
         +S7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oeTEp2rB9dc4PJgyacmkSyq1DnjRfsybkwCycdXUsGs=;
        b=e47t0dOWxkJNS3k4hirlEZ0xoiR1O7KWNQeZucTaorg6qlawz3KO/fzWKEdMn9ZAeD
         xrJGS3mNyIvKpcvHSKTwDmWFDl4hDBB8rzdXn2IotRPP8EbSyAiV7LgDLxxSdRX41c3w
         F48a2cl1Ip2PK0HrA7nrkNDSzi/LdsGUWLMkg3GQ3dkrvjhiDYOZQX/VOazDymrH7kBv
         R0Ym+XOtccKpv4WH9ndwc33GyhVrXog5dbclrwvSNiA+PMz3x3o41aEj24lKBwRzoGTc
         4ee3bv29DCWOFNT8qJB/yX7vYxh0FR0PD/t8oKCn8t/JG9dEeKGUzDX+Z2noEtsjsuCC
         anxQ==
X-Gm-Message-State: AOAM530jDDlltJE1X6V75QZMvdWOd8nqbFHT0m9ySqVOsm1IIn7PCthu
        cz3TDenNzoF8Iu4W9bJsd3l8FsnhvVrDLQvj3Ic=
X-Google-Smtp-Source: ABdhPJyUtrKWz0OmWyEGNqCQX55GG982KCy3AQdz5/9oHR4o1sMC1wA2bpD+RF03LRejqB4Haey+WHxRFVLeNRYhHKg=
X-Received: by 2002:a17:90a:d203:: with SMTP id o3mr1762084pju.122.1643087365668;
 Mon, 24 Jan 2022 21:09:25 -0800 (PST)
MIME-Version: 1.0
References: <cover.1643044381.git.lorenzo@kernel.org> <720907692575488526f06edc2cf5c8f783777d4f.1643044381.git.lorenzo@kernel.org>
 <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
In-Reply-To: <61553c87-a3d3-07ae-8c2f-93cf0cb52263@nvidia.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 24 Jan 2022 21:09:14 -0800
Message-ID: <CAADnVQLv=45+Symc-8Y9QuzOAG40e3XkvVxQ-ibO-HOCyJhETw@mail.gmail.com>
Subject: Re: [RFC bpf-next 1/2] net: bridge: add unstable br_fdb_find_port_from_ifindex
 helper
To:     Nikolay Aleksandrov <nikolay@nvidia.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@kernel.org>,
        Yoshiki Komachi <komachi.yoshiki@gmail.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        Ido Schimmel <idosch@idosch.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 24, 2022 at 10:32 AM Nikolay Aleksandrov <nikolay@nvidia.com> wrote:
> >
> > +int br_fdb_find_port_from_ifindex(struct xdp_md *xdp_ctx,
> > +                               struct bpf_fdb_lookup *opt,
> > +                               u32 opt__sz)
> > +{
> > +     struct xdp_buff *ctx = (struct xdp_buff *)xdp_ctx;
> > +     struct net_bridge_port *port;
> > +     struct net_device *dev;
> > +     int ret = -ENODEV;
> > +
> > +     BUILD_BUG_ON(sizeof(struct bpf_fdb_lookup) != NF_BPF_FDB_OPTS_SZ);
> > +     if (!opt || opt__sz != sizeof(struct bpf_fdb_lookup))
> > +             return -ENODEV;
> > +
> > +     rcu_read_lock();
> > +
> > +     dev = dev_get_by_index_rcu(dev_net(ctx->rxq->dev), opt->ifindex);
> > +     if (!dev)
> > +             goto out;

imo that is way too much wrapping for an unstable helper.
The dev lookup is not cheap.

With all the extra checks the XDP acceleration gets reduced.
I think it would be better to use kprobe/fentry on bridge
functions that operate on fdb and replicate necessary
data into bpf map.
Then xdp prog would do a single cheap lookup from that map
to figure out 'port'.
