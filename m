Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E591BCC924
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 11:40:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727478AbfJEJki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 05:40:38 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:46877 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbfJEJki (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 05:40:38 -0400
Received: by mail-lf1-f66.google.com with SMTP id t8so6081072lfc.13;
        Sat, 05 Oct 2019 02:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aVRDxYV4dMpoh5znQUv7N4yEjpgDh3+PtwLiyhKu390=;
        b=LEa9raUWB/OH/7g5yNvb/kCz5TdtOFMHBMniRYbfVbr4IUnl4JvqtpG51zveMAFt7A
         NWbaH9sBSYGerNO4IFDlICA/AS6z7TsHIGAsaXEXc3Hwg8pm2E2zOiPqk3oxqfcBtHbi
         Mcp460eE9c9kCyhqm3/KtfZI49cLquEzuLPDpUE/ESrrb/pBs02mAeEGGnVsifMJpydv
         JxNyFm/ekfsO+x1qSDaavRKqpgXvznEyXL3lWrTc9ijI4MDBOmDhdeFJiB382aEXFNkB
         S7tSmup8QFU4b/eOo1mL+zHTQBMYnzfMbL9SZ6xy1MegbLHo0/ZbbRyPdw0/GDNnS9+x
         TkcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aVRDxYV4dMpoh5znQUv7N4yEjpgDh3+PtwLiyhKu390=;
        b=I73hAGes7dXd6wjGSp0BYyKsTKm2BySrAv0cq8RSV8NXWcF6xpFmp3B7EzwQdMMY+s
         SJBYlA7OXNMLaZpMJRAd7KA1ceSWzt6Bw7s5kuE/G6qd7ZXU7Pt03ktdznje5ntwrSmI
         0+2XxtqERYiyMmB9QKKwlZufJHVAghOfnvvtlDceVr6eRuRZlJ90u1kAp3jyyHrXZe70
         dm/iPFs2vs5x0FvQTw5YQML6X6ClYCjO1Di6eGS4LNUO6CTXcD+QUntem3d08SUYynqv
         TUBKUtqy7Z3rmz/A5D7wgsh4rjJ/TwKYrGGtJzIgSz1rjD2V2psYnujIsrkXIamCGBTH
         DaPA==
X-Gm-Message-State: APjAAAXMg6zeCtdNJ6i3CrPc5FGkF+QhJ7vq6CuObhusTGlLf99Es3xB
        uBez+hk/1m5OjNRt2bX4TU5Z7QbdPZg5Ye7DyUA=
X-Google-Smtp-Source: APXvYqyUi2hDZTA61rtQuJUB6VCJ2Tf9MrTM1cRtz4jQywnfTptBgYlCuTqmbP4+yHloPzCDurPTrpwuSsZJOV3hbME=
X-Received: by 2002:ac2:4218:: with SMTP id y24mr5975087lfh.148.1570268435362;
 Sat, 05 Oct 2019 02:40:35 -0700 (PDT)
MIME-Version: 1.0
References: <20190928164843.31800-1-ap420073@gmail.com> <2e836018c7ea299037d732e5138ca395bd1ae50f.camel@sipsolutions.net>
 <CAMArcTWs3wzad7ai_zQPCwzC62cFp-poELn+jnDaP7eT1a9ucw@mail.gmail.com> <1b17084d8649bab347b952231d9312b7fb7307f4.camel@sipsolutions.net>
In-Reply-To: <1b17084d8649bab347b952231d9312b7fb7307f4.camel@sipsolutions.net>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sat, 5 Oct 2019 18:40:24 +0900
Message-ID: <CAMArcTWkoroZq1RU=a9XK2HpJbtcQ5xr-vn6ntxLjPN4Lks6mw@mail.gmail.com>
Subject: Re: [PATCH net v4 00/12] net: fix nested device bugs
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     David Miller <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>, linux-wireless@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        =?UTF-8?B?SmnFmcOtIFDDrXJrbw==?= <jiri@resnulli.us>,
        sd@queasysnail.net, Roopa Prabhu <roopa@cumulusnetworks.com>,
        saeedm@mellanox.com, manishc@marvell.com, rahulv@marvell.com,
        kys@microsoft.com, haiyangz@microsoft.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        sashal@kernel.org, hare@suse.de, varun@chelsio.com,
        ubraun@linux.ibm.com, kgraul@linux.ibm.com,
        Jay Vosburgh <jay.vosburgh@canonical.com>,
        Cody Schuffelen <schuffelen@google.com>, bjorn@mork.no
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Oct 2019 at 16:39, Johannes Berg <johannes@sipsolutions.net> wrote:
>

Hi,

> On Sun, 2019-09-29 at 17:31 +0900, Taehee Yoo wrote:
>
> > virt_wifi case is a little bit different case.
>
> Well, arguably, it was also just missing this - it just looks different
> :)
>
> > I add the last patch that is to fix refcnt leaks in the virt_wifi module.
> > The way to fix this is to add notifier routine.
> > The notifier routine could delete lower device before deleting
> > virt_wifi device.
> > If virt_wifi devices are nested, notifier would work recursively.
> > At that time, it would make stack memory overflow.
> >
> > Actually, before this patch, virt_wifi doesn't have the same problem.
> > So, I will update a comment in a v5 patch.
>
> OK, sure.
>
> > Many other devices use this way to avoid wrong nesting configuration.
> > And I think it's a good way.
> > But we should think about the below configuration.
> >
> > vlan5
> >    |
> > virt_wifi4
> >    |
> > vlan3
> >    |
> > virt_wifi2
> >    |
> > vlan1
> >    |
> > dummy0
> >
> > That code wouldn't avoid this configuration.
> > And all devices couldn't avoid this config.
>
> Good point, so then really that isn't useful to check - most people
> won't try to set it up that way (since it's completely useless) and if
> they do anyway too much nesting would be caught by your patchset here.
>

Yes, Thanks!

> > I have been considering this case, but I couldn't make a decision yet.
> > Maybe common netdev function is needed to find the same device type
> >  in their graph.
>
> I don't think it's worthwhile just to prevent somebody from making a
> configuration that we think now is nonsense. Perhaps they do have some
> kind of useful use-case for it ...
>

I agree with your opinion.

> > This is a little bit different question for you.
> > I found another bug in virt_wifi after my last patch.
> > Please test below commands
> >     ip link add dummy0 type dummy
> >     ip link add vw1 link dummy0 type virt_wifi
> >     ip link add vw2 link vw1 type virt_wifi
> >     modprobe -rv virt_wifi
> >
> > Then, you can see the warning messages.
> > If SET_NETDEV_DEV() is deleted in the virt_wifi_newlink(),
> > you can avoid that warning message.
> > But I'm not sure about it's safe to remove that.
> > I would really appreciate it if you let me know about that.
>
> Hmm, I don't see any warnings. SET_NETDEV_DEV() should be there though.
Okay, thanks. I will do not remove SET_NETDEV_DEV() in a v5 patch.
> Do you see the same if you stack it with something else inbetween? If
> not, I guess preventing virt_wifi from stacking on top of itself would
> be sufficient ...
>

Yes, the below test commands will make warning messages.
So, I will add a new patch for this without removing SET_NETDEV_DEV().

Reproducer :
    ip link add dummy0 type dummy
    ip link add vw1 link dummy0 type virt_wifi
    ip link add vlan2 link vw1 type vlan id 1
    ip link add vw3 link vlan2 type virt_wifi
    modprobe -rv virt_wifi

Messages:
[12734.236946] sysfs group 'byte_queue_limits' not found for kobject 'tx-0'
[12734.238862] WARNING: CPU: 1 PID: 19710 at fs/sysfs/group.c:280
sysfs_remove_group+0x11b/0x170
[ ... ]
12734.256132] Call Trace:
[12734.256430]  netdev_queue_update_kobjects+0x1f5/0x340
[12734.257025]  netdev_unregister_kobject+0x142/0x1d0
[12734.257580]  rollback_registered_many+0x618/0xc80
[12734.258175]  ? notifier_call_chain+0x90/0x160
[12734.258688]  ? generic_xdp_install+0x310/0x310
[12734.259208]  ? netdev_upper_dev_unlink+0x114/0x180
[12734.259791]  unregister_netdevice_many.part.126+0x13/0x1b0
[12734.260434]  __rtnl_link_unregister+0x156/0x320
[12734.260967]  ? rtnl_unregister_all+0x120/0x120
[ ... ]
[12734.283395] sysfs group 'power' not found for kobject 'vw3'
[12734.284081] WARNING: CPU: 1 PID: 19710 at fs/sysfs/group.c:280
sysfs_remove_group+0x11b/0x170
[ ... ]
[12734.337509] sysfs group 'statistics' not found for kobject 'vw3'
[12734.338375] WARNING: CPU: 1 PID: 19710 at fs/sysfs/group.c:280
sysfs_remove_group+0x11b/0x170
[ ... ]
[12734.391687] sysfs group 'wireless' not found for kobject 'vw3'
[12734.392525] WARNING: CPU: 1 PID: 19710 at fs/sysfs/group.c:280
sysfs_remove_group+0x11b/0x170
[ ... ]

> johannes
>

Thanks,
Taehee Yoo
