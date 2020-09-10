Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC9C2263C7F
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 07:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726932AbgIJFfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 01:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgIJFf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 01:35:28 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EEFC061573;
        Wed,  9 Sep 2020 22:35:27 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id q8so2891791lfb.6;
        Wed, 09 Sep 2020 22:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9u6TSCY/UfuXfk4u7dA/c63LroJdzdLBydJRLukFiY4=;
        b=hZheDb9tEFdquBYGQqGqTbIKUOhh5bFdVlaF0OJ0u4fL3ThF1FgEY2UkfiC6X3/eT7
         Q1F7uDLueOtlu/a80PSuL/q1o3++YUKcg6Nh8MOXA2OVE/ygIo1vOjNeij6u9tXTirkb
         4AogYDzofHWdlxzJ92ULTyu/xYeV0tJ/9JKkIZ8cYJgNk1As/GmENQM+8FYYvJpGp1xh
         mNJyLgGyU02y1GBhP2Fu/kQDtdzdAMlrRP7RYSVgEHdB6jGfEckCSDQzU+0Hyxm4G6Fl
         ZKVMDBDR79cb4KqNWQOh4MuAJM7Lf8DPKN79cvAkS+d94LoPdkY2gDeenCDdggDff6BE
         HM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9u6TSCY/UfuXfk4u7dA/c63LroJdzdLBydJRLukFiY4=;
        b=Uo1aP+8efKU/5ssmxGJ/wkuMCDC2KgBU/gbh6ok+gDZgSRmCby7GUKqxrMMinPlvk3
         +tRnBwuBCPBs+I/fetJxblHarObAAeCwa3bXwhlLuFPzRcHYeyHMjd2ekzskUhVIY379
         VRZuum0Sp+kKMelF3D7KFB/3VvQrmdljzUln5Fg6f146XiKH0cz7WbifjZmxvtL85DbE
         T2e/LgJCWqs6WorraU5tmwcqmaP9QslKF6x9adzVGgG6cpH7sdb+eiNbr7LrpDjsunR6
         v89cP+IVJch5gjZtSQdHsPA5wuvSy3gM5joSWmxMx3Iv1bGd72ZqqD3xJKXEntefbCQP
         bF/Q==
X-Gm-Message-State: AOAM530F78rQTHLe1jTNLg1gg2YB5DIqHPukEPizVHtRDCpnEZwy1joB
        6Hh8bevVIUViXkabYERxeBEl4X3LgR80YFXjpHI=
X-Google-Smtp-Source: ABdhPJyJuFEErx7A+172WzbU4kE7hPKw+IjGnKv1Lc3EzR8vmGjW75t1H6pzjzXlb6GwgiKrI37R2UuqhqYfL4Xj5S0=
X-Received: by 2002:a19:4ad8:: with SMTP id x207mr3389190lfa.73.1599716124627;
 Wed, 09 Sep 2020 22:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200903102701.3913258-1-liuhangbin@gmail.com>
 <20200907082724.1721685-1-liuhangbin@gmail.com> <20200907082724.1721685-3-liuhangbin@gmail.com>
 <20200909215206.bg62lvbvkmdc5phf@ast-mbp.dhcp.thefacebook.com>
 <20200910023506.GT2531@dhcp-12-153.nay.redhat.com> <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
In-Reply-To: <a1bcd5e8-89dd-0eca-f779-ac345b24661e@gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 9 Sep 2020 22:35:12 -0700
Message-ID: <CAADnVQ+CooPL7Zu4Y-AJZajb47QwNZJU_rH7A3GSbV8JgA4AcQ@mail.gmail.com>
Subject: Re: [PATCHv11 bpf-next 2/5] xdp: add a new helper for dev map
 multicast support
To:     David Ahern <dsahern@gmail.com>
Cc:     Hangbin Liu <liuhangbin@gmail.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Jiri Benc <jbenc@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 8:30 PM David Ahern <dsahern@gmail.com> wrote:
> >
> > I think the packets modification (edit dst mac, add vlan tag, etc) should be
> > done on egress, which rely on David's XDP egress support.
>
> agreed. The DEVMAP used for redirect can have programs attached that
> update the packet headers - assuming you want to update them.

Then you folks have to submit them as one set.
As-is the programmer cannot achieve correct behavior.
