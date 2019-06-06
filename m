Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1BAC36918
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 03:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbfFFBSD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jun 2019 21:18:03 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37732 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726532AbfFFBSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jun 2019 21:18:03 -0400
Received: by mail-pl1-f194.google.com with SMTP id bh12so216533plb.4
        for <netdev@vger.kernel.org>; Wed, 05 Jun 2019 18:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhlvI/Zrff6I3PcwPFHiXdMgqn+TwMZFCrH/lVRsqfI=;
        b=IGaidPIxY8yEGnhhZkxiPG/gNZVYJUXwKiyYSfX8IMOJoPC5XeRQ5RX55x+JxBbC/q
         B8pK/c/9q4FlfDRHmIPXlgYXNIDMjgE+2HAaXXe61ynm5pybfd3di5iW+t4J478DJgei
         O6P2t5n2Y7JXocO7dP64uKBgaomKztCJ040bo/w9cUAKgUQ/UuV/JI8Oh+wJcS1Y+FbQ
         hFaVPhW/b0MAhka5aez5STwmxKNESVY+9qZlRpMsJ4rKNlacymwOlF0vZvEPwdP9qt2W
         Mv2bz3wAvnQ3k6T3dohhPVedcSQMMhLdNOObFbus9n34PbFNZ/HIm3fJ4HPpDOE31cUW
         uxBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UhlvI/Zrff6I3PcwPFHiXdMgqn+TwMZFCrH/lVRsqfI=;
        b=t1DbsNuTanX9/xywuTqGEzDYvXagVrg1xZZsqE0yHj7b5QTr64zQaSY+HyXHz7OupA
         5jnDBjYOu/m/4w3iXrZTa6ZVXIfXrhuFdxGoioFEhyArOHEPaUuBKAy3Xkn1E+pJ1Ono
         y/EJExynhGm1xT2htg1fJVHw0epNOZ7YbSzFw19VOwJokLSVeBu+Yy9y6VHl0yt/S/7V
         ukGsRQmLijgtzzC5Nb0X/rhYjpLnukEIUvHXxE3ZiqRAN0VvoW8rPy1tQAW8DDuB/d0m
         NuR6c+0Li9lDgafLAABaI9T4KY15QWNqtTs4ZFmjXs/VnE42xX3YTW1EcBfKqyJAp8+e
         6hyA==
X-Gm-Message-State: APjAAAXkHZj2fEemlDLMfBiuC5ZlYFC56tQVnVqsRef1HqzfL4OVbXje
        yFffgTPBc2x0dnLhXep9pIgEdfWsZjQu2SoRDaVj1Q==
X-Google-Smtp-Source: APXvYqyxFvL3/q6PE7jLXSWS3T4/Js4QpnyU+cnqCD2G/Arg35y0p2oNL4/bWwESLKzwzFInDPq4GzNxnZfC8/MnjOA=
X-Received: by 2002:a17:902:d701:: with SMTP id w1mr41596303ply.12.1559783882699;
 Wed, 05 Jun 2019 18:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20190530083508.i52z5u25f2o7yigu@sesse.net> <CAM_iQpX-fJzVXc4sLndkZfD4L-XJHCwkndj8xG2p7zY04k616g@mail.gmail.com>
 <20190605072712.avp3svw27smrq2qx@sesse.net>
In-Reply-To: <20190605072712.avp3svw27smrq2qx@sesse.net>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 5 Jun 2019 18:17:51 -0700
Message-ID: <CAM_iQpXWM35ySoigS=TdsXr8+3Ws4ZMspJCBVdWngggCBi362g@mail.gmail.com>
Subject: Re: EoGRE sends undersized frames without padding
To:     "Steinar H. Gunderson" <steinar+kernel@gunderson.no>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 5, 2019 at 12:27 AM Steinar H. Gunderson
<steinar+kernel@gunderson.no> wrote:
>
> On Tue, Jun 04, 2019 at 09:31:42PM -0700, Cong Wang wrote:
> >> This works fine for large packets, but the system in the other end
> >> drops smaller packets, such as ARP requests and small ICMP pings.
> > Is the other end Linux too?
>
> Yes and no. The other end is Linux with Open vSwitch, which sends the packet
> on to a VM. The VM is an appliance which I do not control, and while the
> management plane runs Linux, the data plane is as far as I know implemented
> in userspace.

Hmm, sounds like openvswitch should pad the packets in this scenario,
like hardware switches padding those on real wires.


>
> The appliance itself can also run EoGRE directly, but I haven't gotten it to
> work.
>
> > If the packet doesn't go through any real wire, it could still be accepted
> > by Linux even when it is smaller than ETH_ZLEN, I think.
>
> Yes, but that's just Linux accepting something invalid, no? It doesn't mean
> it should be sending it out.

Well, we can always craft our own ill-formatted packets, right? :) Does
any standard say OS has to drop ethernet frames shorter than the
minimum?


>
> > Some hardware switches pad for ETH_ZLEN when it goes through a real wire.
>
> All hardware switches should; it's a 802.1Q demand. (Some have traditionally
> been buggy in that they haven't added extra padding back when they strip the
> VLAN tag.)

If so, so is the software switch, that is openvswitch?

>
> > It is still too early to say it is a bug. Is this a regression?
>
> I haven't tried it with earlier versions; I would suspect it's not a
> regression.

Good to know.

Thanks.
