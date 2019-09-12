Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 95804B0E4E
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731320AbfILLyd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:54:33 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:37060 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730923AbfILLyc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:54:32 -0400
Received: by mail-lj1-f194.google.com with SMTP id y5so12487304lji.4
        for <netdev@vger.kernel.org>; Thu, 12 Sep 2019 04:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vj0SR+yzDIZpsuoRQslUYdAjMnyWuXc5vlr+ljKbMWU=;
        b=fmejUcQpGOOhu1yXz7XvwtipwgqumIj9D8OGvChNKN+y9mXI+gwrqF8E0SfE8Op4sS
         0xVEsbkdVdolyNdHzm6SptgMdKSG9Aqsp8uARdQtLNL0Ndi9vr6RVVYvbC0O5h7A15EU
         p8M54Y4Gdbh2MIx9vuwv06jZJzNAZZzF1hyUOs3tb3cDyzup2W9JqBZlBfHKGsJSdstL
         Ix1IDfFjYf7oI3ebWu6NArCNrf9EK/1Vefxb1JlhkHhoJFKz3XnmqAIFj5de2EzIWVRH
         W2DZKH8ejj9hcE+e2P5A9NNlc2qQqwQglAPJcTfwKO4Lrk13gf14VaXrVYOTb3e5HgzQ
         FRxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vj0SR+yzDIZpsuoRQslUYdAjMnyWuXc5vlr+ljKbMWU=;
        b=Ytc2tqcozAG2QHk4fs+Yl6QLSxZFUhYiirYPIZqq7PGe6rkXIhCqytWuAzOC8f7DW+
         kum2VN4C3B/GI7y6bHJfBVGyIg0PD4FPYHDbHu+cWy1YgGZ5rIcM7stLzUeOcm4umY7p
         UaN2gnGVLiEUsoIJY14Hx0dKzJYBeOoNUwnEffHcugi04U8tuBl70OOV0Zzl3R/4vMYn
         OpB7Fb5qL5MeXcEauj5wCbdLscTY+U5v9y6Y7U+AcuemeSqhJu79eTZbFgAw8tHzUgPi
         g0Kve88TuFnHokdjkF08G9RH+V/1FIX4/hm+rWSJryH4BlFTCaNvxv523UJXcBOjNbBn
         JfOQ==
X-Gm-Message-State: APjAAAX/2pJYnG49+mG3Hx6NksWQQblAHINdkUHlHpjxDitUEq0l0fdH
        RjUeNAPaSp4t2CWljF5jD1zXm5SvQ0flj1AysCM=
X-Google-Smtp-Source: APXvYqxeaeWhKT6vNuTKX5/soTx/nSLjq4jLtpUicAFrQzga/3r0y15qBSgKneJ6mhD4PriApxxLQi+S/3JeHHE7myI=
X-Received: by 2002:a2e:9d88:: with SMTP id c8mr11449093ljj.157.1568289270610;
 Thu, 12 Sep 2019 04:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAMArcTV-Qvfd7xA0huCh_dbtr7P4LA+cQ7CpnaBBhdq-tq5fZQ@mail.gmail.com>
 <20190912.113807.52193745382103083.davem@davemloft.net> <CAMArcTWMjTsZB8Ssx+hVMK-3-XozZw7AqVE62-H+zrJ+doC5Lw@mail.gmail.com>
 <20190912.133717.257813019167130934.davem@davemloft.net>
In-Reply-To: <20190912.133717.257813019167130934.davem@davemloft.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Thu, 12 Sep 2019 20:54:19 +0900
Message-ID: <CAMArcTVgQBdYbOUd1AZGQ3f97NqbYNM9Ain-nn1Cz7tgcu1ijA@mail.gmail.com>
Subject: Re: [PATCH net v2 01/11] net: core: limit nested device depth
To:     David Miller <davem@davemloft.net>
Cc:     Netdev <netdev@vger.kernel.org>, j.vosburgh@gmail.com,
        vfalico@gmail.com, Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Sep 2019 at 20:37, David Miller <davem@davemloft.net> wrote:
>
> From: Taehee Yoo <ap420073@gmail.com>
> Date: Thu, 12 Sep 2019 19:14:37 +0900
>
> > On Thu, 12 Sep 2019 at 18:38, David Miller <davem@davemloft.net> wrote:
> >>
> >> From: Taehee Yoo <ap420073@gmail.com>
> >> Date: Thu, 12 Sep 2019 12:56:19 +0900
> >>
> >> > I tested with this reproducer commands without lockdep.
> >> >
> >> >     ip link add dummy0 type dummy
> >> >     ip link add link dummy0 name vlan1 type vlan id 1
> >> >     ip link set vlan1 up
> >> >
> >> >     for i in {2..200}
> >> >     do
> >> >             let A=$i-1
> >> >
> >> >             ip link add name vlan$i link vlan$A type vlan id $i
> >> >     done
> >> >     ip link del vlan1 <-- this command is added.
> >>
> >> Is there any other device type which allows arbitrary nesting depth
> >> in this manner other than VLAN?  Perhaps it is the VLAN nesting
> >> depth that we should limit instead of all of this extra code.
> >
> > Below device types have the same problem.
> > VLAN, BONDING, TEAM, VXLAN, MACVLAN, and MACSEC.
> > All the below test commands reproduce a panic.
>
> I think then we need to move the traversals over to a iterative
> rather than recursive algorithm.

I agree with that.
So I will check it out then send a v3 patchset.

Thank you!
