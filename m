Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 734DA32484B
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 02:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234680AbhBYBHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 20:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231154AbhBYBHF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 20:07:05 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46433C061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 17:06:25 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id m188so3750148yba.13
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 17:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WOMs78JD5Xo8EnYv5df09UVXzQVXwvFHJJlUpBEm+EM=;
        b=jfyYUnHslciUWLPEaOat8oTtaT2ltoNuxNKPqVWcVcpxkrB4xxIaGwqfsZ9qBvxaUf
         wbqF1PENnhgbX4xtz/kM9oyNwvgaSADITy+9ev5VsY9P0jnzxI0H03Uf2vmEOTFnCh8T
         yIoZPOPnXtX+VKbRTIAgK6+9gJQjzNDC9jaZ+JZq69rOSIdySbsgCfVumEgIY9/seFbK
         ksX69+vpYn81xvU0QHdwTw9bYPd6xs7gE+6EvRE1A7fazf+nExAdIAwBNuYHTYw7Usin
         E0AXWvzbgpv87ooBZ8iFSEeBvcn4KAKRp2N7/a6nFlVucsuZcgNV2/P2DMXbqcsKFqGl
         OmzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WOMs78JD5Xo8EnYv5df09UVXzQVXwvFHJJlUpBEm+EM=;
        b=rMWJJ4gtWMwEAr+vJjtCWY75XOPXkIa4dxMrF6DmcXl6TVu2QG+tZz6CF5wPr/PbCj
         +xnmYy+h1h0cpYr2pEgUlclOLrCd42v9TBynX9cPw6r/LM/5wf0xlaJ+VzSSA8XB8N8s
         TuPkCYZmIiaq32ad4+9FMHp8l+d7htW6U0LW5ypcGe/0dsOOPLf4EUeErqyfgbRW8e7H
         WLD4fJfBiExtzdnftm4Cyld2pKyxtyAXNsVBaoz8cZ0i3DG6d4eUeWfj8636dh6yvcoi
         g6MritKUXbRi6/jUE2xDxFPV6wgB7/2kWObzmCydvsS+dljv46lCV0da5MOfIGuf7FuK
         WqOA==
X-Gm-Message-State: AOAM531CsSLLzJMRbEw7k1JpzwHuO9GtqofmYMU1aS0/gWQdfdUVTwQo
        Ew3ACJLGBFSe/j1XMftMkDSV7kX/9mMbCNp2CtYCHg==
X-Google-Smtp-Source: ABdhPJx+Y/Xv8PQ3D+pEYyr5Z0I+it1a8oGaQs4ZE/ceyF3Uu71LUGHW3UC/zlqaXeGihYnEBcoiZcRxURIC0ANi5H4=
X-Received: by 2002:a25:2a44:: with SMTP id q65mr524545ybq.195.1614215184354;
 Wed, 24 Feb 2021 17:06:24 -0800 (PST)
MIME-Version: 1.0
References: <20210223234130.437831-1-weiwan@google.com> <20210224114851.436d0065@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+jO-ym4kpLD3NaeCKZL_sUiub=2VP574YgC-aVvVyTMw@mail.gmail.com>
 <20210224133032.4227a60c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+xGsMpRfPwZK281jyfum_1fhTNFXq7Z8HOww9H1BHmiw@mail.gmail.com>
 <20210224155237.221dd0c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89iKYLTbQB7K8bFouaGFfeiVo00-TEqsdM10t7Tr94O_tuA@mail.gmail.com>
 <20210224160723.4786a256@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BN8PR15MB2787694425A1369CA563FCFFBD9E9@BN8PR15MB2787.namprd15.prod.outlook.com>
 <CAEA6p_BGgazFPRf-wMkBukwk4nzXiXoDVEwWp+Fp7A5OtuMjQA@mail.gmail.com>
 <20210224163257.7c96fb74@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAEA6p_Cp-Q4BRr_Ohd7ee7NchQBB37+vgBrauZQJLtGzgcqZWw@mail.gmail.com> <20210224164946.2822585d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210224164946.2822585d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Wei Wang <weiwan@google.com>
Date:   Wed, 24 Feb 2021 17:06:13 -0800
Message-ID: <CAEA6p_CN9UzGvLKoX8Y=D49p4N+rgWPWtg0haXJ3T0HP+gJvxA@mail.gmail.com>
Subject: Re: [PATCH net] net: fix race between napi kthread mode and busy poll
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Duyck <alexanderduyck@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Martin Zaharinov <micron10@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I really have a hard time reproducing the warning Martin was seeing in
his setup. The difference between my setup and his is that mine uses
mlx4 driver, while Martin is using ixgbe driver.

To keep everyone up to date with Martin's previous email, with this
patch applied to 5.11.1, the following warning is triggered when
enabling threaded mode without enabling busy poll:
echo 1 > /sys/class/net/eth0/threaded
echo 1 > /sys/class/net/eth1/threaded
echo 1 > /sys/class/net/eth2/threaded
echo 1 > /sys/class/net/eth3/threaded

Warning message:
[   92.883326] WARNING: CPU: 10 PID: 37100 at net/core/dev.c:6993
napi_threaded_poll+0x144/0x150
[   92.883333] Modules linked in: iptable_filter xt_TCPMSS
iptable_mangle xt_addrtype xt_nat iptable_nat ip_tables  pppoe pppox
ppp_generic slhc team_mode_loadbalance team netconsole coretemp ixgbe
mdio mdio_devres libphy
[   92.884616]  ip_tables  pppoe pppox ppp_generic slhc
team_mode_loadbalance team netconsole coretemp ixgbe mdio mdio_devres
libphy nf_nat_sip nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp
[   92.886001]  nf_nat_sip
[   92.887262]  nf_nat_tftp
[   92.891169]  nf_conntrack_sip
[   92.894696]  nf_conntrack_tftp nf_nat_ftp nf_conntrack_ftp nf_nat
nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 acpi_ipmi ipmi_si
ipmi_devintf ipmi_msghandler rtc_cmos
[   92.894705] CPU: 18 PID: 37132 Comm: napi/eth3-703 Tainted: G
    O      5.11.1 #1
[   92.895133]  nf_nat_pptp
[   92.895570] Hardware name: Supermicro Super Server/X10DRi-LN4+,
BIOS 3.2 11/19/2019
[   92.895572] RIP: 0010:napi_threaded_poll+0x144/0x150
[   92.895576] Code: 83 e8 f0 2b 9f ff 80 7c 24 07 00 0f 84 e9 fe ff
ff e8 40 75 1f 00 e9 77 ff ff ff 48 8d 74 24 07 48 89 df e8 2e fd ff
ff eb cb <0f> 0b e9 53 ff ff ff 0f 1f 44 00 00 41 57 41 56 41 55 41 54
55 53
[   92.896097]  nf_conntrack_pptp
[   92.898490] RSP: 0018:ffffa3af62857ee0 EFLAGS: 00010287
[   92.898493] RAX: ffffa3af434fcf50 RBX: ffff94e5da281050 RCX: 0000000000000000
[   92.898494] RDX: 0000000000000001 RSI: 0000000000000246 RDI: ffff94e5da281050
[   92.898495] RBP: ffff94e60f463b00 R08: ffff94e9afa21758 R09: ffff94e9afa21758
[   92.898496] R10: 0000000000000000 R11: 0000000000000000 R12: ffff94e5db0bf800
[   92.898497] R13: ffffa3af4521fd10 R14: ffff94e5da281050 R15: ffff94e60f463b00
[   92.898499] FS:  0000000000000000(0000) GS:ffff94e9afa00000(0000)
knlGS:0000000000000000
[   92.898501] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   92.898502] CR2: 00007f76000a1b60 CR3: 00000001db40a005 CR4: 00000000001706e0
[   92.898503] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   92.898504] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   92.898506] Call Trace:
[   92.898508]  ? __kthread_parkme+0x43/0x60
[   92.898514]  ? __napi_poll+0x190/0x190
[   92.898516]  kthread+0xea/0x120
[   92.898520]  ? kthread_park+0x80/0x80
[   92.898523]  ret_from_fork+0x1f/0x30
[   92.898527] ---[ end trace 51046c7b7172e5a2 ]---

This is the line in net/core/dev.c:6993
 WARN_ON(!list_empty(&napi->poll_list));
in napi_threaded wait()

Martin, do you think the driver version you are using could be at fault here?




On Wed, Feb 24, 2021 at 4:49 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 24 Feb 2021 16:44:55 -0800 Wei Wang wrote:
> > On Wed, Feb 24, 2021 at 4:33 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Wed, 24 Feb 2021 16:16:58 -0800 Wei Wang wrote:
> > > > On Wed, Feb 24, 2021 at 4:11 PM Alexander Duyck <alexanderduyck@fb.com> wrote:
> >  [...]
> > > >
> > > > Please help hold on to the patch for now. I think Martin is still
> > > > seeing issues on his setup even with this patch applied. I have not
> > > > yet figured out why. But I think we should not merge this patch until
> > > > the issue is cleared. Will update this thread with progress.
> > >
> > > If I'm looking right __busy_poll_stop() is only called if the last
> > > napi poll used to re-enable IRQs consumed full budget. You need to
> > > clear your new bit in busy_poll_stop(), not in __busy_poll_stop().
> > > That will fix the case when hand off back to the normal poller (sirq,
> > > or thread) happens without going thru __napi_schedule().
> >
> > If the budget is not fully consumed, napi_complete_done() should have
> > been called by the driver which will clear SCHED_BUSY_POLL bit.
>
> Ah, right.
