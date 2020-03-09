Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D69317E411
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 16:54:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgCIPyF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 11:54:05 -0400
Received: from mail-io1-f41.google.com ([209.85.166.41]:39057 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgCIPyF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 11:54:05 -0400
Received: by mail-io1-f41.google.com with SMTP id f21so5456264iol.6
        for <netdev@vger.kernel.org>; Mon, 09 Mar 2020 08:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vL8ZN+MMMNaCIekqum8LNYiK8VJ2YU5ya1NwO5tzhaY=;
        b=aCRRXbIcoGSv4Jl1pX8VYEC6FMXePUQUDauzTmhwCE22eZtEEr0S6dZj9ErggVMpYM
         rmyyqFTCKA8LoGOaLVonRQV2eVXGhbMuw17wJo/gMfIWEifSUKNkKbecNZ+QhGN+rHJ7
         ywelQf/O/5B+JSA0JAlrO/5SyfywNjInrKxBmw0J5fmYSUFMVHZHHrzuomsHJakFt3yR
         SdPOMTwiVtx2Gjb0rGeA4Cpf6O78Dis5CyN2TFUWLq3sheaHuSUOa+5tWD8cThjZorQ/
         kjtjdSSPnZFUiOyk4ABFjKR0M0S3R87HBa2pzEp3YhpZoAYeKWEgeZ/WtO8cDmikk/6v
         dFsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vL8ZN+MMMNaCIekqum8LNYiK8VJ2YU5ya1NwO5tzhaY=;
        b=ReOYx5azYPBgK+98NfyFe7UYMSgvR/7y0P1Biwnbe4Jm4K71g81lBMm6q0XBfKfIVs
         XUTwDB10iQt05X3PqDVXA2RfGLbSqbsXYqUxdv1eVlkWckK3/vudJZRN8W6i8+B2DbKU
         nYD+oA0OEsVmoXJ8HWJh8qqVV9/J/BRAKNEXokrJgMNd9Ox5xRrYatrb+6/wPnm6C02/
         ruMx6bAC/gWDbXROWJssTDGDKSx12FzwiuBti5haaVGKJT1koU140y36GxcVYa8Hst7n
         I1mRnA6T8xGFKZn6w1HF7zi9TAmZm0GRstC3376Q3wLsZDOhlywA306YVx0XLtHQhLOG
         o+qg==
X-Gm-Message-State: ANhLgQ3kvJZ46IxcXW1SePri6fO+PqQc/G2jwQHQxeWJK2Eu4O99UYgs
        jsavqrkh1b6HF/huI3dXQI8IkzmtCXAsnAQYvN8191ll
X-Google-Smtp-Source: ADFU+vtKqYBlrZmdt5jNHpQsDTTklpHnwTqHL8iB3AGukMrL1qg0Fd1PT59m6Ij+pdAP1Yz4LvC5tlAnfKrnFPOS8u4=
X-Received: by 2002:a6b:7d04:: with SMTP id c4mr13943218ioq.5.1583769244373;
 Mon, 09 Mar 2020 08:54:04 -0700 (PDT)
MIME-Version: 1.0
References: <CADvbK_evghCnfNkePFkkLbaamXPaCOu-mSsSDKXuGSt65DSivw@mail.gmail.com>
 <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com>
In-Reply-To: <1441d64c-c334-8c54-39e8-7a06a530089d@gmail.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 9 Mar 2020 08:53:53 -0700
Message-ID: <CAKgT0UcbycqgrfviqUmvS9S7+F6q-gMzrz-KKQuEb77ruZZLRQ@mail.gmail.com>
Subject: Re: route: an issue caused by local and main table's merge
To:     David Ahern <dsahern@gmail.com>
Cc:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        davem <davem@davemloft.net>, mmhatre@redhat.com,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 8, 2020 at 7:31 PM David Ahern <dsahern@gmail.com> wrote:
>
> [ This got lost in the backlog ]
>
> On 3/2/20 1:38 AM, Xin Long wrote:
> > Hi, David A.
> >
> > Mithil reported an issue, which can be reproduced by:
> >
> >   # ip link  add dummy0 type dummy
> >   # ip link  set dummy0 up
> >   # ip route add to broadcast 192.168.122.1 dev dummy0 <--- broadcast
> >   # ip route add 192.168.122.1 dev dummy0   <--- unicast
> >   # ip route add 1.1.1.1 via 192.168.122.1  <--- [A]
> >   Error: Nexthop has invalid gateway.
> >   # ip rule  add from 2.2.2.2
> >   # ip route add 1.1.1.1 via 192.168.122.1  <--- [B]
> >
> > cmd [A] failed , as in fib_check_nh_v4_gw():
> >
> >     if (table)
> >             tbl = fib_get_table(net, table);
> >
> >     if (tbl)
> >             err = fib_table_lookup_2(tbl, &fl4, &res,
> >                                    FIB_LOOKUP_IGNORE_LINKSTATE |
> >                                    FIB_LOOKUP_NOREF);
> >
> >     if (res.type != RTN_UNICAST && res.type != RTN_LOCAL) { <--- [a]
> >             NL_SET_ERR_MSG(extack, "Nexthop has invalid gateway");
> >             goto out;  <--[a]
> >     }
> >
> > It gets the route for '192.168.122.1' from the merged (main/local)
> > table, and the broadcast one returns, and it fails the check [a].
> >
> > But the same cmd [B] will work after one rule is added, by which
> > main table and local table get separated, it gets the route from
> > the main table (the same table for this route), and the unicast
> > one returns, and it will pass the check [a].
> >
> > Any idea on how to fix this, and keep it consistent before and
> > after a rule added?
> >
>
> I do not have any suggestions off the top of my head.
>
> Adding Alex who as I recall did the table merge.

As far as the table merge it is undone as soon as any rules are added
or deleted. From that point on it will not re-merge the table. So if
you are using rules you are going to need to modify the rules first
and then add routes as this will guarantee the table is consistent as
any further rule modifications will not re-merge the table.

Also, is it really a valid configuration to have the same address
configured as both a broadcast and unicast address? I couldn't find
anything that said it wasn't, but at the same time I haven't found
anything saying it is an acceptable practice to configure an IP
address as both a broadcast and unicast destination. Everything I saw
seemed to imply that a subnet should be at least a /30 to guarantee a
pair of IPs and support for broadcast addresses with all 1's and 0 for
the host identifier. As such 192.168.122.1 would never really be a
valid broadcast address since it implies a /31 subnet mask.

- Alex
