Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D49E5F74F8
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:31:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfKKNbb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:31:31 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:33724 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727109AbfKKNba (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:31:30 -0500
Received: by mail-oi1-f194.google.com with SMTP id m193so11486535oig.0
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 05:31:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lGbf2Dc9C3MaMMZf9tcEUAWy5nVZH41T271h0X0pq+8=;
        b=nTv+5HfvQbk3AmVEs1de/Yxo3SLLzS+wZB3G9V0iev64TXDN+YkUwkBNUywhQMEJeH
         W79v65a9sa0Z5AmG2qOnWd2XrclrXaZboL7wDyesL1/fGdV7MjwMPB12molM2q/V1yZz
         sJRjPvCHdgoXOXETbRUf/+roF4VVowcPrXEapfAQKVLvDD1NWN0/YCPRL9NDyXfFSRcm
         qMnAOFrRk/gqUqOBQVRXZV9anMmr0GKah7A9t9TGRE6z5dM6/gB+UIbzSvZX8QVtOX7z
         8aMQU+WwE4+eXNNrXszJS7DCcTRzmHjhg9emOOq3lw2QWndym8xN6B5vEapjSS/vAZwu
         Sb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lGbf2Dc9C3MaMMZf9tcEUAWy5nVZH41T271h0X0pq+8=;
        b=hqr7BMZo5kOkPcy2HFXKVpz7/mnYp9U0GwETN/3pjI5xWEJ07PNuZZJV5SvOqy6upa
         9IOo4AielVCsmgRIXlLUWQvlnC9o55/QFdjB4E+YTa3h2VdsNnpAMD2kyTAyQOVHx4VW
         up9/fMVZw7qWhjIyJIS1uDrzGXe26ey4IqozZ6PnG4WMrT/uspeWqN3yF3gnPQEeiWIl
         uWEqBMzZdwwWccP+IBXCEPVaJBanInEnSiqO55B3K7hym7GI7IPY1z0F0U6gjlFG6L4E
         1UKf73lvA/nR78BuwQBFNkvrUYRbbmHERY45QZNxzTnYSjlqEHrtzePkmu8kaltF11ZG
         DF+Q==
X-Gm-Message-State: APjAAAUgoUFwKgqO0+bWn9zs6SD+4Tx8yyN1cE3CQYcrld/kBdK88bA8
        AVcU5qivpuMfDpd5H4X+t2zdBUxPTMkDzsIwUD0=
X-Google-Smtp-Source: APXvYqwgM+FMMyDFTHGhFmdF8oVo86FDnvww4GZyF/fjfta7ceqNls3rATFDLnTwj0LeHExjCcTyPfRCCzWy0Qj8iH8=
X-Received: by 2002:aca:5104:: with SMTP id f4mr23788778oib.40.1573479089043;
 Mon, 11 Nov 2019 05:31:29 -0800 (PST)
MIME-Version: 1.0
References: <1573386258-35040-1-git-send-email-xiangxia.m.yue@gmail.com> <20191111130736.pyicdoc7x55fqosq@netronome.com>
In-Reply-To: <20191111130736.pyicdoc7x55fqosq@netronome.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Mon, 11 Nov 2019 21:30:53 +0800
Message-ID: <CAMDZJNWv7u79Y2hqgRoj1KicG-kPPQqzWD8cEE8+0YfkMrMciQ@mail.gmail.com>
Subject: Re: [PATCH net-next] net: openvswitch: add hash info to upcall
To:     Simon Horman <simon.horman@netronome.com>
Cc:     Pravin Shelar <pshelar@ovn.org>, Ben Pfaff <blp@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, ychen <ychen103103@163.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 11, 2019 at 9:07 PM Simon Horman <simon.horman@netronome.com> wrote:
>
> On Sun, Nov 10, 2019 at 07:44:18PM +0800, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > When using the kernel datapath, the upcall don't
> > add skb hash info relatived. That will introduce
> > some problem, because the hash of skb is very
> > important (e.g. vxlan module uses it for udp src port,
> > tx queue selection on tx path.).
> >
> > For example, there will be one upcall, without information
> > skb hash, to ovs-vswitchd, for the first packet of one tcp
> > session. When kernel sents the tcp packets, the hash is
> > random for a tcp socket:
> >
> > tcp_v4_connect
> >   -> sk_set_txhash (is random)
> >
> > __tcp_transmit_skb
> >   -> skb_set_hash_from_sk
> >
> > Then the udp src port of first tcp packet is different
> > from rest packets. The topo is shown.
> >
> > $ ovs-vsctl add-br br-int
> > $ ovs-vsctl add-port br-int vxl0 -- \
> >               set Interface vxl0 type=vxlan options:key=100 options:remote_ip=1.1.1.200
> >
> > $ __tap is internal type on host
> > $ or tap net device for VM/Dockers
> > $ ovs-vsctl add-port br-int __tap
> >
> > +---------------+          +-------------------------+
> > |   Docker/VMs  |          |     ovs-vswitchd        |
> > +----+----------+          +-------------------------+
> >      |                       ^                    |
> >      |                       |                    |
> >      |                       |  upcall            v recalculate packet hash
> >      |                     +-+--------------------+--+
> >      |  tap netdev         |                         |   vxlan modules
> >      +--------------->     +-->  Open vSwitch ko   --+--->
> >        internal type       |                         |
> >                            +-------------------------+
>
> I think I see the problem that you are trying to solve, but this approach
> feels wrong to me. In my view the HASH is transparent to components
> outside of the datapath (in this case the Open vSwitch ko box).
The hash affects the vxlan modules to select the udp src port and tx
queue selection.

> For one thing, with this change ovs-vswitchd can now supply any hash
> value it likes.
the patch for ovs-vswitchd is not sent for now, this patch will get
the hash from upcall
and sent it back to kernel.
> Is it not possible to fix things so that "recalculate packet hash"
> in fact recalculates the same hash value as was calculated before
> the upcall?
Hi, Simon
I don't get a better solution, because the hash calculated with
different way, for example
hash is random for tcp which may come from host or VMs, and hash may
is calculated in hw, software.

> >
> > Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> > Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > ---
> >  include/uapi/linux/openvswitch.h |  2 ++
> >  net/openvswitch/datapath.c       | 31 ++++++++++++++++++++++++++++++-
> >  net/openvswitch/datapath.h       |  3 +++
> >  3 files changed, 35 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvswitch.h
> > index 1887a451c388..1c58e019438e 100644
> > --- a/include/uapi/linux/openvswitch.h
> > +++ b/include/uapi/linux/openvswitch.h
> > @@ -170,6 +170,7 @@ enum ovs_packet_cmd {
> >   * output port is actually a tunnel port. Contains the output tunnel key
> >   * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.
> >   * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
> > + * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_hash in skb)
> >   * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
> >   * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragment
> >   * size.
> > @@ -190,6 +191,7 @@ enum ovs_packet_attr {
> >       OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe,
> >                                      error logging should be suppressed. */
> >       OVS_PACKET_ATTR_MRU,        /* Maximum received IP fragment size. */
> > +     OVS_PACKET_ATTR_HASH,       /* Packet hash. */
> >       OVS_PACKET_ATTR_LEN,            /* Packet size before truncation. */
> >       __OVS_PACKET_ATTR_MAX
> >  };
> > diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
> > index 2088619c03f0..f938c43e3085 100644
> > --- a/net/openvswitch/datapath.c
> > +++ b/net/openvswitch/datapath.c
> > @@ -350,7 +350,8 @@ static size_t upcall_msg_size(const struct dp_upcall_info *upcall_info,
> >       size_t size = NLMSG_ALIGN(sizeof(struct ovs_header))
> >               + nla_total_size(hdrlen) /* OVS_PACKET_ATTR_PACKET */
> >               + nla_total_size(ovs_key_attr_size()) /* OVS_PACKET_ATTR_KEY */
> > -             + nla_total_size(sizeof(unsigned int)); /* OVS_PACKET_ATTR_LEN */
> > +             + nla_total_size(sizeof(unsigned int)) /* OVS_PACKET_ATTR_LEN */
> > +             + nla_total_size(sizeof(u64)); /* OVS_PACKET_ATTR_HASH */
> >
> >       /* OVS_PACKET_ATTR_USERDATA */
> >       if (upcall_info->userdata)
> > @@ -393,6 +394,7 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
> >       size_t len;
> >       unsigned int hlen;
> >       int err, dp_ifindex;
> > +     u64 hash;
> >
> >       dp_ifindex = get_dpifindex(dp);
> >       if (!dp_ifindex)
> > @@ -504,6 +506,24 @@ static int queue_userspace_packet(struct datapath *dp, struct sk_buff *skb,
> >               pad_packet(dp, user_skb);
> >       }
> >
> > +     if (skb_get_hash_raw(skb)) {
> > +             hash = skb_get_hash_raw(skb);
> > +
> > +             if (skb->sw_hash)
> > +                     hash |= OVS_PACKET_HASH_SW;
> > +
> > +             if (skb->l4_hash)
> > +                     hash |= OVS_PACKET_HASH_L4;
> > +
> > +             if (nla_put(user_skb, OVS_PACKET_ATTR_HASH,
> > +                         sizeof (u64), &hash)) {
> > +                     err = -ENOBUFS;
> > +                     goto out;
> > +             }
> > +
> > +             pad_packet(dp, user_skb);
> > +     }
> > +
> >       /* Only reserve room for attribute header, packet data is added
> >        * in skb_zerocopy() */
> >       if (!(nla = nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {
> > @@ -543,6 +563,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
> >       struct datapath *dp;
> >       struct vport *input_vport;
> >       u16 mru = 0;
> > +     u64 hash;
> >       int len;
> >       int err;
> >       bool log = !a[OVS_PACKET_ATTR_PROBE];
> > @@ -568,6 +589,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb, struct genl_info *info)
> >       }
> >       OVS_CB(packet)->mru = mru;
> >
> > +     if (a[OVS_PACKET_ATTR_HASH]) {
> > +             hash = nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
> > +
> > +             __skb_set_hash(packet, hash & 0xFFFFFFFFUL,
> > +                            !!(hash & OVS_PACKET_HASH_SW),
> > +                            !!(hash & OVS_PACKET_HASH_L4));
> > +     }
> > +
> >       /* Build an sw_flow for sending this packet. */
> >       flow = ovs_flow_alloc();
> >       err = PTR_ERR(flow);
> > diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
> > index 81e85dde8217..ba89a08647ac 100644
> > --- a/net/openvswitch/datapath.h
> > +++ b/net/openvswitch/datapath.h
> > @@ -248,3 +248,6 @@ do {                                                              \
> >               pr_info("netlink: " fmt "\n", ##__VA_ARGS__);   \
> >  } while (0)
> >  #endif /* datapath.h */
> > +
> > +#define OVS_PACKET_HASH_SW   (1ULL << 32)
> > +#define OVS_PACKET_HASH_L4   (1ULL << 33)
>
> I think that BIT macro is appropriate here.
I got it, thanks.
> > --
> > 2.23.0
> >
