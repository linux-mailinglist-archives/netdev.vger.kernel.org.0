Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F14991627A6
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 15:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726772AbgBROFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 09:05:21 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:41220 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726556AbgBROFU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 09:05:20 -0500
Received: by mail-ed1-f66.google.com with SMTP id c26so24939667eds.8
        for <netdev@vger.kernel.org>; Tue, 18 Feb 2020 06:05:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4Kj9k5jCAauZHUGLdR01UFe5z+TfeUoeZRYGm9jwYdg=;
        b=hUxDg+0tKrZXhu0xBHHwcFprs5ZrqhGmAuKV/0miDidk00aYXuXncx0evr6dgbxsbt
         hGofv0sjGfgwanktFw18aVWM8u1QhX0NGXPuPOLYUyqcYEAqbkv2TZ/irwblw80J45ca
         eNfqnYp/iOnVaCCtePyCQbJMUeVpBs9k+09iJ8bACLDcxJrmTuVQdoVwBpcvMzlA5FDA
         DEIUn9EUdOZagYaZXSL7SrhHvlD/ctA8DVhq3mH6AT80fpikMJP/QsY7E9xzuznZtRwb
         RaB3Mr180iz7NijkDOptW9oR8g1fADOnSx6dUjrLcAYLk+9hSFpy54LcD4JIkrpMYZ7g
         xk7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4Kj9k5jCAauZHUGLdR01UFe5z+TfeUoeZRYGm9jwYdg=;
        b=k5Hl2V0bDOxiiEDgmu05rHEpo3csWL0GG12dciM5TVo6Cwr28aaMR8ve1I006aRDVE
         Gber/T0JToPpW9c26VumXdXlWdP3t75sFbZ4yBO47uFV3TlJN7gRNPb/Nkt2MKXYcE5b
         aAyhebcKCL1bD6ojrizwQACQ9Yzg0UbdxLnLRSUT5joF2wmC7R+dp7gVOY7OkDDyUHD0
         YL8WluH/AqmF30QXFiQkQupjat/zpv7puAZKBPs/TEdk1uCNVa+jMcSQXAO5fEDYfkAi
         9ftmn60hQ4DbAZs9ngNa4pylzJK9r28ekIlFcgKrLq6eKAUtLymB2cQs2uNYDJ6u2x/P
         JFcQ==
X-Gm-Message-State: APjAAAVjIgcNvLWTqk9I+J0agwsVZXkKg6ncgTYW/gySm2pSM8KKOmnS
        +0Qp58KxCZTrqhrAYpv0ysrv7YSZeo7Vz2eQVs4=
X-Google-Smtp-Source: APXvYqyezJKuGiGNceDlZzVYADt53HOkAtJMlYB+ywmil549+K1QkSl4nvA5POx9gzVmFJkUclAEyE/zYNNCJUTk6Xk=
X-Received: by 2002:a17:906:f49:: with SMTP id h9mr20374029ejj.6.1582034718924;
 Tue, 18 Feb 2020 06:05:18 -0800 (PST)
MIME-Version: 1.0
References: <20200217150058.5586-1-olteanv@gmail.com> <20200218113159.qiema7jj2b3wq5bb@lx-anielsen.microsemi.net>
 <CA+h21hpAowv50TayymgbHXY-d5GZABK_rq+Z3aw3fngLUaEFSQ@mail.gmail.com> <20200218140111.GB10541@lunn.ch>
In-Reply-To: <20200218140111.GB10541@lunn.ch>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 18 Feb 2020 16:05:08 +0200
Message-ID: <CA+h21hpFwQyW0HwYpMRgBHBn51ySR_SxS5eDQ2ixwqiEbLj2mA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: mscc: ocelot: Workaround to allow traffic
 to CPU in standalone mode
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        netdev <netdev@vger.kernel.org>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

On Tue, 18 Feb 2020 at 16:01, Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Tue, Feb 18, 2020 at 02:29:15PM +0200, Vladimir Oltean wrote:
> > Hi Allan,
> >
> > On Tue, 18 Feb 2020 at 13:32, Allan W. Nielsen
> > <allan.nielsen@microchip.com> wrote:
> > >
> > > On 17.02.2020 17:00, Vladimir Oltean wrote:
> > > >EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> > > >
> > > >From: Vladimir Oltean <vladimir.oltean@nxp.com>
> > > >
> > > >The Ocelot switches have what is, in my opinion, a design flaw: their
> > > >DSA header is in front of the Ethernet header, which means that they
> > > >subvert the DSA master's RX filter, which for all practical purposes,
> > > >either needs to be in promiscuous mode, or the OCELOT_TAG_PREFIX_LONG
> > > >needs to be used for extraction, which makes the switch add a fake DMAC
> > > >of ff:ff:ff:ff:ff:ff so that the DSA master accepts the frame.
> > > >
> > > >The issue with this design, of course, is that the CPU will be spammed
> > > >with frames that it doesn't want to respond to, and there isn't any
> > > >hardware offload in place by default to drop them.
> > > In the case of Ocelot, the NPI port is expected to be connected back to
> > > back to the CPU, meaning that it should not matter what DMAC is set.
> > >
> >
> > You are omitting the fact that the host Ethernet port has an RX filter
> > as well. By default it should drop frames that aren't broadcast or
> > aren't sent to a destination MAC equal to its configured MAC address.
> > Most DSA switches add their tag _after_ the Ethernet header. This
> > makes the DMAC and SMAC seen by the front-panel port of the switch be
> > the same as the DMAC and SMAC seen by the host port. Combined with the
> > fact that DSA sets up switch port MAC addresses to be inherited from
> > the host port, RX filtering 'just works'.
>
> It is a little bit more complex than that, but basically yes. If the
> slave interface is in promisc mode, the master interface is also made
> promisc. So as soon as you add a slave to a bridge, the master it set
> promisc. Also, if the slave has a different MAC address to the master,
> the MAC address is added to the masters RX filter.
>
> If the DSA header is before the DMAC, you need promisc mode all the
> time. But i don't expect the CPU port to be spammed. The switch should
> only be forwarding frames to the CPU which the CPU is actually
> interested in.
>
> > Be there 4 net devices: swp0, swp1, swp2, swp3.
> > At probe time, the following doesn't work on the Felix DSA driver:
> > ip addr add 192.168.1.1/24 dev swp0
> > ping 192.168.1.2
>
> That is expected to work.
>
> > But if I do this:
> > ip link add dev br0 type bridge
> > ip link set dev swp0 master br0
> > ip link set dev swp0 nomaster
> > ping 192.168.1.2
> > Then it works, because the code path from ocelot_bridge_stp_state_set
> > that puts the CPU port in the forwarding mask of the other ports gets
> > executed on the "bridge leave" action.
>
> It probably also works because when the port is added to the bridge,
> the bridge puts the port into promisc mode. That in term causes the
> master to be put into promisc mode.

Promisc on the DSA master is not why this works. The switch drops the
packets instead of forwarding them to the CPU, because the CPU is not
in the list of valid destination for unknown unicast traffic received
on the front panel ports.
Promiscuous mode on the DSA master is also disabled when the switch
ports exit the bridge, by the way.

>
>        Andrew

Regards,
-Vladimir
