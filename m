Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A88A2E188D
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 06:31:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbgLWFaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 00:30:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725820AbgLWFaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Dec 2020 00:30:18 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD00C0613D6
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 21:29:38 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id f132so17132888oib.12
        for <netdev@vger.kernel.org>; Tue, 22 Dec 2020 21:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ckDdbUcmSv8suHJ0Br0fYaqVg4stCeKAgQL1SJGUzN4=;
        b=ZTf5JopKkhBTo52bTwN8FLIb3S2t0sfmXWc8KKAMzcurRe60VTjQ5se0hf+A7kFZ5s
         yEtJW0WN6s2LNyWDv7cqOYWuuy0INFF3vnIljt2krH3i8nwdUNqh4ATTkpql3pyTb/94
         i2ZGdC1f5AgA3RW0JnG7dtPNoHCYqMXjQqVnNVOA6p3zK3fPg201VekPtSazoFxK/rHu
         pz9dcVtpw4bsItpmNmMYRBqLnZ1/DFseOGDJIC1G/ma1qogROXImO2ywq3YWN0keBqz9
         x11r5dHaOy9OvEyXzwMw8ZKgJsRWGSVAHkJtdqbl1Jb437fYCJVFlJzCd6UCJIKr6YkQ
         J9UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ckDdbUcmSv8suHJ0Br0fYaqVg4stCeKAgQL1SJGUzN4=;
        b=TAmjOScEyxksy0v90dtGR7gibDsw2yCFopUfDUc9sIbdCrhJfT9hi/bQOKDmEUykky
         PENgjPeSOciy6BctqG47wqrKA6/hOduIfbGcOpMOGKWUaMwBD0wtJp11gpRNTEEta0+R
         XtuB2ER7KxNhWy+ucM05wRBLYRdItKYQv0YvdfKWmVEl0bZiUqwk1NtFg1VH0FYCOWMu
         QP3851Ski+k03w0625chtw2qrlnS6l/ix9aaN0bK3c365sJZWPjBYD9V4p/2NzVorqms
         AH64V3DaGPkht9cdN2m6Vxfp0sgEQD08GtF6RcY+8x1rFaYTQUwWZHZWCH5FjH37gGQl
         2DhA==
X-Gm-Message-State: AOAM530EYmCMKzCN5TSnNwTojmmBRAJZVhKFiwQ6nqfXu98xkf6+VPXv
        r6W+oadPHFDLba+Nw3enTijBjZNZ9b8dM6/H1qadmQ==
X-Google-Smtp-Source: ABdhPJxoT0Y5RB5h/wdMRwBJfSojVFR1qtn0SkjV5n57Zer5wK4gcMmNUWO5DnHF8Zw065hpqMBZrkAydq8Sq81wk5Q=
X-Received: by 2002:a05:6808:2cb:: with SMTP id a11mr16735294oid.93.1608701377553;
 Tue, 22 Dec 2020 21:29:37 -0800 (PST)
MIME-Version: 1.0
References: <20201220123957.1694-1-wangzhiqiang.bj@bytedance.com>
 <CACPK8XexOmUOdGmHCYVXVgA0z5m99XCAbixcgODSoUSRNCY+zA@mail.gmail.com>
 <4a9cab3660503483fd683c89c84787a7a1b492b1.camel@mendozajonas.com> <20201222182458.4651c564@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201222182458.4651c564@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   John Wang <wangzhiqiang.bj@bytedance.com>
Date:   Wed, 23 Dec 2020 13:29:26 +0800
Message-ID: <CAH0XSJvAKqYTeL+=7biS2jgwUL4mgY-WqZhwDb4Mx46Z0PSpWw@mail.gmail.com>
Subject: Re: [External] Re: [PATCH] net/ncsi: Use real net-device for response handler
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Samuel Mendoza-Jonas <sam@mendozajonas.com>,
        Joel Stanley <joel@jms.id.au>,
        Lotus Xu <xuxiaohan@bytedance.com>,
        =?UTF-8?B?6YOB6Zu3?= <yulei.sh@bytedance.com>,
        "David S. Miller" <davem@davemloft.net>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Bo Chen <chenbo.gil@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 23, 2020 at 10:25 AM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Tue, 22 Dec 2020 10:38:21 -0800 Samuel Mendoza-Jonas wrote:
> > On Tue, 2020-12-22 at 06:13 +0000, Joel Stanley wrote:
> > > On Sun, 20 Dec 2020 at 12:40, John Wang wrote:
> > > > When aggregating ncsi interfaces and dedicated interfaces to bond
> > > > interfaces, the ncsi response handler will use the wrong net device
> > > > to
> > > > find ncsi_dev, so that the ncsi interface will not work properly.
> > > > Here, we use the net device registered to packet_type to fix it.
> > > >
> > > > Fixes: 138635cc27c9 ("net/ncsi: NCSI response packet handler")
> > > > Signed-off-by: John Wang <wangzhiqiang.bj@bytedance.com>
>
> This sounds like exactly the case for which orig_dev was introduced.
> I think you should use the orig_dev argument, rather than pt->dev.

will send a v2

>
> Can you test if that works?

Yes,  it works.

>
> > > Can you show me how to reproduce this?

On g220a, eth1 is the dedicated interface, eth0 is the ncsi interface

kernel cfg:
CONFIG_BONDING=y

cat /etc/systemd/network/00-bmc-bond1.netdev
[NetDev]
Name=bond1
Description=Bond eth0 and eth1
Kind=bond

[Bond]
Mode=active-backup

cat /etc/systemd/network/00-bmc-eth0.network
[Match]
Name=eth0
[Network]
Bond=bond1

cat /etc/systemd/network/00-bmc-eth0.network
[Match]
Name=eth1
[Network]
Bond=bond1
PrimarySlave=true

ip addr
....
6: bond1: <BROADCAST,MULTICAST,UP,LOWER_UP400> mtu 1500 qdisc noqueue qlen 1000
    link/ether b4:05:5d:8f:6a:ad brd ff:ff:ff:ff:ff:ff
    inet 169.254.11.178/16 brd 169.254.255.255 scope link bond1
       valid_lft forever preferred_lft forever
    inet 192.168.1.108/24 brd 192.168.1.255 scope global bond1
       valid_lft forever preferred_lft forever
    inet 10.2.16.118/24 brd 10.2.16.255 scope global bond1
       valid_lft forever preferred_lft forever
    inet6 fe80::b605:5dff:fe8f:6aad/64 scope link
...


Without this patch:
After bmc boots:
echo eth0 > /sys/class/net/bond1/bonding/active_slave
admin@g220a:~#
admin@g220a:~# echo eth0 > /sys/class/net/bond1/bonding/active_slave
[  105.964357] bond1: (slave eth0): making interface the new active one
admin@g220a:~# ping 10.2.16.1
PING 10.2.16.1 (10.2.16.1): 56 data bytes
64 bytes from 10.2.16.1: seq=0 ttl=255 time=7.096 ms
64 bytes from 10.2.16.1: seq=1 ttl=255 time=2.143 ms
64 bytes from 10.2.16.1: seq=2 ttl=255 time=2.111 ms
[  112.642734] ftgmac100 1e660000.ethernet eth0: NCSI Channel 0 timed out!
64 bytes from 10.2.16.1: seq=3 ttl=255 time=2.039 ms
64 bytes from 10.2.16.1: seq=4 ttl=255 time=2.037 ms
[  117.842814] ftgmac100 1e660000.ethernet eth0: NCSI: No channel with
link found, configuring channel 0
[  134.482746] ftgmac100 1e660000.ethernet eth0: NCSI Channel 0 timed out!
[  139.682820] ftgmac100 1e660000.ethernet eth0: NCSI: No channel with
link found, configuring channel 0

with this patch:
After bmc boots:

admin@g220a:~# echo eth0 > /sys/class/net/bond1/bonding/active_slave
[58332.123754] bond1: (slave eth0): making interface the new active one
admin@g220a:~# ping 10.2.16.1
PING 10.2.16.1 (10.2.16.1): 56 data bytes
64 bytes from 10.2.16.1: seq=0 ttl=255 time=7.279 ms
...
...
64 bytes from 10.2.16.1: seq=N ttl=255 time=2.037 ms



> > >
> > > I don't know the ncsi or net code well enough to know if this is the
> > > correct fix. If you are confident it is correct then I have no
> > > objections.
> >
> > This looks like it is probably right; pt->dev will be the original
> > device from ncsi_register_dev(), if a response comes in to
> > ncsi_rcv_rsp() associated with a different device then the driver will
> > fail to find the correct ncsi_dev_priv. An example of the broken case
> > would be good to see though.
>
> From the description sounds like the case is whenever the ncsi
> interface is in a bond, the netdev from the second argument is
> the bond not the interface from which the frame came. It should
> be possible to repro even with only one interface on the system,
> create a bond or a team and add the ncsi interface to it.
>
> Does that make sense? I'm likely missing the subtleties here.

:)  I guess so.
