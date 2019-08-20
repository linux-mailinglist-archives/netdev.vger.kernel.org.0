Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DF995E22
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 14:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729611AbfHTMJd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 08:09:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:34388 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728907AbfHTMJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 08:09:32 -0400
Received: by mail-ed1-f67.google.com with SMTP id s49so6055702edb.1
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 05:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qFWAGFVeWnTfBvcN91wVBqyrdIkSXLBEFQef78nRKhE=;
        b=SB0QmAJEVe2Yu+rJ2pUmNiPQp5B8dNKTDJkIDfhFZL59gPmrkLPBoeBiL9fxd3NCdF
         Kj1gsGO8PF6t+m0dqaeqpXIe9LdE3I8A7rgs2ybjhktrxquZ7G2urwnpUGY3vLF+qR3d
         +EOruiAqpQqzMFpfZSIBdDO0rTPuxfd35e4d07o41PuvyygDGTI0YmJ5GMNu6m5Z8dzI
         LlOYyET1zLIR+BmDWreFhrK+/rxuO1jT1kjHG3WAxoUeDBsPzXCBBGRRQGXvv6cy+U86
         F3XgCEnio3AxRCw/QqlrCnlvjjbKRn0ZWljDiYDwxRyEzLcb82VeDJL3noy7Z6J7GI+O
         wfyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qFWAGFVeWnTfBvcN91wVBqyrdIkSXLBEFQef78nRKhE=;
        b=swVUwthPEZFacdRSuZFJXx+98RddSUrqJNdiTq/jaPUJvSqHOaSKbdb07Nwdrkpn9G
         xDNLnwftrrA2bGRkh9tIbU2DITBPEEqraepF8H9dTo4Ag3JelFL14YsnLZDe7Xf+zaui
         xYWsnB6UU9yN/zGhmakY1J+0HO+zjLkWfvJ64sxS+DKCW4vnfu5IVNbaVfU85GSMx5FF
         uPvdp1eMjLCiBdPkC4JZEw1Ld7Kpf/lKiHghiXZglOkS432IE8NQEZX7wwbHxEFPGNBO
         fARiYzT3YaPjGQd1DJQpiBrRgXohub6Fuit5OvQVODu2LIczZinVuhaWkKnCW7xNYekn
         h6Lg==
X-Gm-Message-State: APjAAAUTbkrNmB8/kJK2tWm5BudCsRQKvSBBdGKLA1gdklrgiOm2OpRH
        eynuHAX7BkBKIzaviD/uduylmGHPQ8kIb4RRKWwUSKCgwd0=
X-Google-Smtp-Source: APXvYqwdDpg8NO978+YMiOZppqG7VwWrcr6S65GpVJBX7K/juTf6sRuiUFnzo0cOtr24EKdJdHEFVhk/+a4oT/ge/Zo=
X-Received: by 2002:a05:6402:1285:: with SMTP id w5mr30981390edv.36.1566302970412;
 Tue, 20 Aug 2019 05:09:30 -0700 (PDT)
MIME-Version: 1.0
References: <20190820000002.9776-1-olteanv@gmail.com> <20190820000002.9776-5-olteanv@gmail.com>
 <19610afd-298a-e434-00ea-48eb5b143c1b@gmail.com>
In-Reply-To: <19610afd-298a-e434-00ea-48eb5b143c1b@gmail.com>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Tue, 20 Aug 2019 15:09:19 +0300
Message-ID: <CA+h21hpCP2KpTnCuki1M6tkQ1Qv-ex5MfKHbwQXsqotoh3ndKw@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] net: dsa: Don't program the VLAN as pvid on
 the upstream port
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Ido Schimmel <idosch@idosch.org>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        nikolay@cumulusnetworks.com,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, 20 Aug 2019 at 06:15, Florian Fainelli <f.fainelli@gmail.com> wrote:
>
>
>
> On 8/19/2019 5:00 PM, Vladimir Oltean wrote:
> > Commit b2f81d304cee ("net: dsa: add CPU and DSA ports as VLAN members")
> > programs the VLAN from the bridge into the specified port as well as the
> > upstream port, with the same set of flags.
> >
> > Consider the typical case of installing pvid 1 on user port 1, pvid 2 on
> > user port 2, etc. The upstream port would end up having a pvid equal to
> > the last user port whose pvid was programmed from the bridge. Less than
> > useful.
> >
> > So just don't change the pvid of the upstream port and let it be
> > whatever the driver set it internally to be.
>
> This patch should allow removing the !dsa_is_cpu_port() checks from
> b53_common.c:b53_vlan_add, about time :)
>
> It seems to me that the fundamental issue here is that because we do not
> have a user visible network device that 1:1 maps with the CPU (or DSA)
> ports for that matter (and for valid reasons, they would represent two
> ends of the same pipe), we do not have a good way to control the CPU
> port VLAN attributes.
>
> There was a prior attempt at allowing using the bridge master device to
> program the CPU port's VLAN attributes, see [1], but I did not follow up
> with that until [2] and then life caught me. If you can/want, that would
> be great (not asking for TPS reports).
>
> [1]:
> https://lists.linuxfoundation.org/pipermail/bridge/2016-November/010112.html
> [2]:
> https://lore.kernel.org/lkml/20180624153339.13572-1-f.fainelli@gmail.com/T/
>

So what was the conclusion of that discussion? Should you or should
you not add the check for vlan->flags & BRIDGE_VLAN_INFO_BRENTRY?
I don't exactly handle the meaning of 'master' and 'self' options from
a user perspective.
Right now (no patches applied) I get the following behavior in DSA
(swp2 is already member of br0):

$ echo 1 | sudo tee /sys/class/net/br0/bridge/vlan_filtering
$ sudo bridge vlan add vid 100 dev swp2
$ sudo bridge vlan add vid 101 dev swp2 self
RTNETLINK answers: Operation not supported
$ sudo bridge vlan add vid 102 dev swp2 master
$ sudo bridge vlan add vid 103 dev br0
RTNETLINK answers: Operation not supported
$ sudo bridge vlan add vid 104 dev br0 self
$ sudo bridge vlan add vid 105 dev br0 master
RTNETLINK answers: Operation not supported

$ bridge vlan
port    vlan ids
eth0     1 PVID Egress Untagged

swp5     1 PVID Egress Untagged

swp2     1 PVID Egress Untagged
         100
         102

swp3     1 PVID Egress Untagged

swp4     1 PVID Egress Untagged

br0      1 PVID Egress Untagged
         104

Who returns EOPNOTSUPP for VID 101 and why?
Why is VID 102 not installed in br0? This part I don't understand from
your patchset. Does it mean that the CPU port (br0) will have to be
explicitly configured from now on, even if I run the commands on swp2
with 'master'?


> >
> > Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> > ---
> >  net/dsa/switch.c | 16 ++++++++++++----
> >  1 file changed, 12 insertions(+), 4 deletions(-)
> >
> > diff --git a/net/dsa/switch.c b/net/dsa/switch.c
> > index 84ab2336131e..02ccc53f1926 100644
> > --- a/net/dsa/switch.c
> > +++ b/net/dsa/switch.c
> > @@ -239,17 +239,21 @@ dsa_switch_vlan_prepare_bitmap(struct dsa_switch *ds,
> >                              const struct switchdev_obj_port_vlan *vlan,
> >                              const unsigned long *bitmap)
> >  {
> > +     struct switchdev_obj_port_vlan v = *vlan;
> >       int port, err;
> >
> >       if (!ds->ops->port_vlan_prepare || !ds->ops->port_vlan_add)
> >               return -EOPNOTSUPP;
> >
> >       for_each_set_bit(port, bitmap, ds->num_ports) {
> > -             err = dsa_port_vlan_check(ds, port, vlan);
> > +             if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> > +                     v.flags &= ~BRIDGE_VLAN_INFO_PVID;
> > +
> > +             err = dsa_port_vlan_check(ds, port, &v);
> >               if (err)
> >                       return err;
> >
> > -             err = ds->ops->port_vlan_prepare(ds, port, vlan);
> > +             err = ds->ops->port_vlan_prepare(ds, port, &v);
> >               if (err)
> >                       return err;
> >       }
> > @@ -262,10 +266,14 @@ dsa_switch_vlan_add_bitmap(struct dsa_switch *ds,
> >                          const struct switchdev_obj_port_vlan *vlan,
> >                          const unsigned long *bitmap)
> >  {
> > +     struct switchdev_obj_port_vlan v = *vlan;
> >       int port;
> >
> > -     for_each_set_bit(port, bitmap, ds->num_ports)
> > -             ds->ops->port_vlan_add(ds, port, vlan);
> > +     for_each_set_bit(port, bitmap, ds->num_ports) {
> > +             if (dsa_is_cpu_port(ds, port) || dsa_is_dsa_port(ds, port))
> > +                     v.flags &= ~BRIDGE_VLAN_INFO_PVID;
> > +             ds->ops->port_vlan_add(ds, port, &v);
> > +     }
> >  }
> >
> >  static int dsa_switch_vlan_add(struct dsa_switch *ds,
> >
>
> --
> Florian

Regards,
-Vladimir
