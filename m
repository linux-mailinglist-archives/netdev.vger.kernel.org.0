Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA6A261654
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 19:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgIHRJO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 13:09:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732152AbgIHRJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 13:09:02 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA4ACC061756
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 10:09:01 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id b123so9413731vsd.10
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uxqwH7GZBnEMFxjmA1dYQN29QuSs6NC/OtdCV0Jyouk=;
        b=dqmW3Vd3XOIXohmkuHyoBu+pD6bpqoalFXzjFXRuZxBqw4z3PXroPnxf6am6dhBWvo
         qJQGL6tmjieqKDd+3plyj037k/DsTzb+MpCTCRUYC128bEsa1SY0bfoFYEtjCV/qRKba
         p+sQMxE2dYUwnfD+1E958TNquOG573qSX6pAMpTBv6KAFeTC3lfZz4mlxijLrWdEU1gs
         IlF4u4G4+Ln8wacwDtx44YT7RyK/lLSlacUSb9TxzQ7QjJcjxrHKbq4zMlmiQP9QS9r2
         UwJDsfhG4kNpOTcKgYyVfx9d3SRuIz+utNrv1Amz5NvOgKVB3vHAql0wEnsNcpQh7ZiA
         mGxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uxqwH7GZBnEMFxjmA1dYQN29QuSs6NC/OtdCV0Jyouk=;
        b=hTgeQN63QMDYkZk8tqbpGGHIRuUTF/k5kULubZPOiN4W5n4hyERPqqvWvjoBEf9CbP
         lmUbDh5X64oyZ1VTMpyZksCfvj3b0rQ8wDNA1EM4j8xl5KT6bFyXLDuXe7/NcQwf0hHc
         D5z6WzNdckmeMHJoFKvlN8GJYTk7zPBk05h+E+/oBpX31twwY7l0IGprdVmlnOBkIvXn
         NEI/PzvjHHh2fHHh0hOmgDvolbHnsgVKK9nSZIdgSfHZJkLsufgEX8gX1m9GR9NlzpoA
         8Q07AdjCJPSZaWdYQVfWP7DpMx7I8zSwZ/qnwnoDGR9pgTqBKnBh7Pp4OelzsNWKTUnw
         13YQ==
X-Gm-Message-State: AOAM531qZc/AHsoQPqXIOPCw957KN5rv2i73tcEifUXjbNU3TGLNItaa
        l8pcOZDPIzpeaPDV4jdDoazHuAvpJFERkQ==
X-Google-Smtp-Source: ABdhPJzWcu+I4IYP6kJOc7kWiwZ/dxIKyyegc5O4+Tcislx58MSQp6qYEec45bblzwNN7edmlr+1Pg==
X-Received: by 2002:a67:31cb:: with SMTP id x194mr1589998vsx.19.1599584937918;
        Tue, 08 Sep 2020 10:08:57 -0700 (PDT)
Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com. [209.85.222.49])
        by smtp.gmail.com with ESMTPSA id s4sm2496932vsc.2.2020.09.08.10.08.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 10:08:56 -0700 (PDT)
Received: by mail-ua1-f49.google.com with SMTP id y15so5287332uan.9
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 10:08:56 -0700 (PDT)
X-Received: by 2002:ab0:60d7:: with SMTP id g23mr92852uam.122.1599584935769;
 Tue, 08 Sep 2020 10:08:55 -0700 (PDT)
MIME-Version: 1.0
References: <CAJht_EOu8GKvdTAeF_rHsaKu7iYOmW8C64bQA21bgKuiANE5Zw@mail.gmail.com>
 <CAJht_EP=g02o2ygihNo=EWd1OuL3HSjmhqgGiwUGrMde=urSUA@mail.gmail.com>
 <CA+FuTSdm35x9nA259JgOWcCWJto9MVMHGGgamPPsgnpsTmPO8g@mail.gmail.com>
 <CAJht_EPEqUMXNdQLL9d5OtzbZ92Jms7nSUR8bS+cw2Ah5mv6cQ@mail.gmail.com>
 <CA+FuTSeJS22R2VYSzcEVvXiUhX79RYE0o3G6V3NKGzQ4UGaJQg@mail.gmail.com>
 <CAJht_EN7SXAex-1W49eY7q5p2UqLYvXA8D6hptJGquXdJULLcA@mail.gmail.com>
 <CA+FuTSfgxt6uqcxy=wnOXo8HxMJ3J0HAqQNiDJBLCs22Ukb_gQ@mail.gmail.com> <CAJht_EN-aBo8rfHAxYxwW2Jb38S2PW3WtxhWuHn5HS1fAWeA1w@mail.gmail.com>
In-Reply-To: <CAJht_EN-aBo8rfHAxYxwW2Jb38S2PW3WtxhWuHn5HS1fAWeA1w@mail.gmail.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Tue, 8 Sep 2020 19:08:17 +0200
X-Gmail-Original-Message-ID: <CA+FuTScyyE_s8PodEQhj3=s2wO3kGnWP3nL9SESJddf=U6DEfQ@mail.gmail.com>
Message-ID: <CA+FuTScyyE_s8PodEQhj3=s2wO3kGnWP3nL9SESJddf=U6DEfQ@mail.gmail.com>
Subject: Re: Question about dev_validate_header used in af_packet.c
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 8, 2020 at 6:23 PM Xie He <xie.he.0141@gmail.com> wrote:
>
> On Tue, Sep 8, 2020 at 4:53 AM Willem de Bruijn
> <willemdebruijn.kernel@gmail.com> wrote:
> >
> > On Tue, Sep 8, 2020 at 1:04 PM Xie He <xie.he.0141@gmail.com> wrote:
> > >
> > > I was recently looking at some drivers, and I felt that if af_packet.c
> > > could help me filter out the invalid RAW frames, I didn't need to
> > > check the validity of the frames myself (in the driver when
> > > transmitting). But now I guess I still need to check that.
> > >
> > > I feel this makes the dev_validate_header's variable-length header
> > > check not very useful, because drivers need to do this check again
> > > (when transmitting) anyway.
> > >
> > > I was thinking, after I saw dev_validate_header, that we could
> > > eventually make it completely take over the responsibility for a
> > > driver to validate the header when transmitting RAW frames. But now it
> > > seems we would not be able to do this.
> >
> > Agreed. As is, it is mainly useful to block users who are ns_capable,
> > but not capable.
> >
> > A third option is to move it behind a sysctl (with static_branch). Your
> > point is valid that there really is no need for testing of drivers against
> > bad packets if the data is validated directly on kernel entry.
>
> I was thinking about this again and it came to me that maybe sometimes
> people actually wanted to send invalid frames on wire (for testing the
> network device on the other end of the wire)? Having thought about
> this possibility I think it might be good to keep the ability for
> people to have 2 choices (either having their RAW frames validated, or
> not validated) through "capability" or through "sysctl" as you
> mentioned. We can keep the default to be not validating the RAW frames
> because RAW sockets are already intended for very special use and are
> not for normal use.

That offers some configurability. But really, I would just leave it as is.
