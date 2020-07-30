Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF74232CD5
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 10:02:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgG3IC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 04:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726774AbgG3ICW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 04:02:22 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8417C061794;
        Thu, 30 Jul 2020 01:02:22 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id a9so3462276pjd.3;
        Thu, 30 Jul 2020 01:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=XCmfqFtBUrWLGb0HRDwnKJuQyG0oIwWAg+A2BuLLHlk=;
        b=Ni9dtpixzC9T0JSf1dz8WSqnJqMFFOr6aMpkKq7RUF8VMgW6JliqG5FYvO+SjUr0RC
         jrgYAaQ2ukMMAjW34DThgLXD+Q3NhOfu7tt0H6kG5lCdNjEqU2yBUkxbEp7xBGE61hQ8
         Q51KOI1vwwm/fFJwiOdcDWp6ssn2nut+QzTXRuny6Vy0kReeTK/tw8EdBqq+dw6OSzXj
         BDT2LQBtrxDO6psEf8/6zRasJlWUlVvqw3JKT3gmes8ZViJ+2puSPCRSGkXfVMoO76J/
         xPp2dxWO/fW345mYWUygzMqthWQQNz9E/loJYeGFZzh/xHyAVWGITVnviouF0XVMGPo+
         q4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=XCmfqFtBUrWLGb0HRDwnKJuQyG0oIwWAg+A2BuLLHlk=;
        b=KseAtjvgp5z+RICrPhBZuZOOemur5w3Cc+oXzQlP3enHy2pQH1OKuSVM86cgBzzTw5
         mmSVNafQVNE8BoBjCwQLOFbYltBJ2yePKy4MJv05xJ4d/W4scRGUL6o88ixbnO+1bDnb
         DFHdbgEoPucEFqIEIU2wzBtQH20UfSmdd+FFu2hS6ZbF+jLx83T/sHngkJzUNxen43dL
         om6eI8hyEEb34tdF3MBstnCukRdBqVQj1CpQ66pemyTdg5htEVeo5KaQ/fdn6Lgoe8EP
         JjwhQ2ispHvZihwYCxuIFWl82VB5dHd3MFErgh3sx9Nfwqsobwci4JMC0hcP1i6ocykI
         SIeQ==
X-Gm-Message-State: AOAM531sOAj3HBM6G/TJw/X37FLFFmnAXbB4PL2qTZz6sHZ9VTuzJgDK
        MVneADHdx/Ll4QpJJfFFF2eFNbtQf4zGfaMigT9gHQhM
X-Google-Smtp-Source: ABdhPJy0ddlORXpGjQKfME9zoUWY2prLtamhgQ18XGO0AYNnAP3SyIkK4wzxBORjSqX7wRmj4S5RG2ytTbL1az8lNR8=
X-Received: by 2002:a17:90b:11c4:: with SMTP id gv4mr1944336pjb.198.1596096141675;
 Thu, 30 Jul 2020 01:02:21 -0700 (PDT)
MIME-Version: 1.0
References: <20200730073702.16887-1-xie.he.0141@gmail.com>
In-Reply-To: <20200730073702.16887-1-xie.he.0141@gmail.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Thu, 30 Jul 2020 01:02:10 -0700
Message-ID: <CAJht_EO1srhh68DifK61+hpY+zBRU8oOAbJOSpjOqePithc7gw@mail.gmail.com>
Subject: Re: [PATCH v2] drivers/net/wan/lapbether: Use needed_headroom instead
 of hard_header_len
To:     Martin Schiller <ms@dev.tdt.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Martin,

I'm currently working on a plan to make all X.25 drivers (lapbether.c,
x25_asy.c, hdlc_x25.c) to set dev->hard_header_len /
dev->needed_headroom correctly. So that upper layers no longer need to
guess how much headroom a X.25 device needs with a constant value (as
they currently do).

After studying af_packet.c, I found that X.25 drivers needed to set
needed_headroom to reserve the headroom instead of using
hard_header_len. Because hard_header_len should be the length of the
header that would be created by dev_hard_header, and in this case it
should be 0, according to the logic of af_packet.c.

So my first step is to fix the settings in lapbether.c. Could you
review this patch and extend your support via a "Reviewed-by" tag? If
this can be fixed, I'll go on and fix other X.25 drivers. Thanks!

It's very hard to find reviewers for X.25 code because it is
relatively unmaintained by people. I hope I can do some of the
maintenance work. I greatly appreciate your support!
