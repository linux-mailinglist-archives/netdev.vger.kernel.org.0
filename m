Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E09A712A5D3
	for <lists+netdev@lfdr.de>; Wed, 25 Dec 2019 04:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726407AbfLYD0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 22:26:55 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40121 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726325AbfLYD0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Dec 2019 22:26:54 -0500
Received: by mail-lj1-f193.google.com with SMTP id u1so22044659ljk.7;
        Tue, 24 Dec 2019 19:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=aHHVqfLYHMRToLhVYPGytsm1bSssA6Z3fhzgTsYtpxk=;
        b=ELPo/u/860upyNhSZEIDPUD3AIf688ncQhO+dYZClUmoLuIjHAOFEU5DxpUTUgsmBZ
         qzRjuj1GpuIQ2vcmV97I5FuqPndI0d/UAHIcnooI9FZrBwNccCoJflqmUBO8karrGqLA
         qttQG7qhhQke85hznYqCKBQFGUaL9zNUwwAFZ3ba5kLGkne2BU8BM4tP3ZS0Cp4qtBWL
         cX/3GRsMirOCxt2+sT4XN0gBTJ+7gDyPC458FVwSrCiChyQ3vGakJzEnlRUiyVWTEoNl
         3YwByHgUoaqAv/UiFswsRD1mYq+yGFofL3AQs3c46PWNQX21/TpDvz/PnnTtN7j3JQb9
         49Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aHHVqfLYHMRToLhVYPGytsm1bSssA6Z3fhzgTsYtpxk=;
        b=CI/O1YAn9P4e08okb4cgHiX51spiSn1VMJxbOF3Svwms7UaxA/mqYf/PUBbLCWncuR
         GE70nFNIP8SpE8q/lzFPUL4cZhofSldXzTpozC7Iyekvb4XVzuuXfSFXLTe/Fy76jmzY
         /YVDdts8Czjx/4WKieB3LRpfWnyjMu9UNBpINdqmlSmQNNpFNuVvAW6EpkNt8FCKYRHJ
         s4BlFqk4hSOP3fv5zx+yWLfOP3rx/BOxpK7z5Ub8/UiVkC6fbdbRfOIAL2JuF0kRfGtq
         5Ztj71GaXzfgMAUo2LYOy2MckiOuDOm+WjTGGj7ZfU2BqNK1ZTns092kfSmzbCMUy3Tn
         Ha9w==
X-Gm-Message-State: APjAAAWrhq3TdHcr6l3+T22SByB+hFgGk7+Pe/IXMeHIvGZyL1jsprxM
        Owb/zW1KHeh/yocNYigoG24mNOWtgGrCtzvA4gQ=
X-Google-Smtp-Source: APXvYqymrsdL5RCmAcSR9RDWs8R7f9zINWXbD2iaOYj05I5965/cNCggsSwWk3IQyK8XeunzCIdSuNxB2MiykvlHzIk=
X-Received: by 2002:a05:651c:1b3:: with SMTP id c19mr17563548ljn.115.1577244411692;
 Tue, 24 Dec 2019 19:26:51 -0800 (PST)
MIME-Version: 1.0
References: <20191217155102.46039-1-mcroce@redhat.com> <cf5b01f8-b4e4-90da-0ee7-b1d81ee6d342@cumulusnetworks.com>
 <CAGnkfhxaT9_WL4UR8qurjBTkkdkuZFbfTQucLjoKOP-1eDEoTw@mail.gmail.com>
 <CAMDZJNUQHR2zJwzbqKJWqMEYSKpz3-VHu4LTUzWKX94rQgMzxw@mail.gmail.com> <CAEPJBmo5ju_2+XdmOEscb_bWL6+qZ72ewk1LTdmiHEgxeE5+VA@mail.gmail.com>
In-Reply-To: <CAEPJBmo5ju_2+XdmOEscb_bWL6+qZ72ewk1LTdmiHEgxeE5+VA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 25 Dec 2019 11:26:15 +0800
Message-ID: <CAMDZJNXfCyAOQU0-aFr_pC=ezihW0QQwHj8L+EaOHXZCM=j29Q@mail.gmail.com>
Subject: Re: [ovs-dev] [PATCH net-next v2] openvswitch: add TTL decrement action
To:     bindiya Kurle <bindiyakurle@gmail.com>
Cc:     Matteo Croce <mcroce@redhat.com>,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        ovs dev <dev@openvswitch.org>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 25, 2019 at 7:16 AM bindiya Kurle <bindiyakurle@gmail.com> wrot=
e:
>
> Hi Tonghao,
> Once this kernel patch is integrated . I will be submitting patch to ovs-=
dpdk  for implementing dec_ttl action on dpdk datapath.
Good=EF=BC=8C thanks
> Regards,
> Bindiya
>
> On Tue, Dec 24, 2019 at 2:12 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> =
wrote:
>>
>> Hi Matteo,
>> Did you have plan to implement the TTL decrement action in userspace
>> datapath(with dpdk),
>> I am doing some research offloading about TTL decrement action, and
>> may sent patch TTL decrement offload action,
>> using dpdk rte_flow.
>>
>> On Fri, Dec 20, 2019 at 8:37 PM Matteo Croce <mcroce@redhat.com> wrote:
>> >
>> > On Tue, Dec 17, 2019 at 5:30 PM Nikolay Aleksandrov
>> > <nikolay@cumulusnetworks.com> wrote:
>> > >
>> > > On 17/12/2019 17:51, Matteo Croce wrote:
>> > > > New action to decrement TTL instead of setting it to a fixed value=
.
>> > > > This action will decrement the TTL and, in case of expired TTL, dr=
op it
>> > > > or execute an action passed via a nested attribute.
>> > > > The default TTL expired action is to drop the packet.
>> > > >
>> > > > Supports both IPv4 and IPv6 via the ttl and hop_limit fields, resp=
ectively.
>> > > >
>> > > > Tested with a corresponding change in the userspace:
>> > > >
>> > > >     # ovs-dpctl dump-flows
>> > > >     in_port(2),eth(),eth_type(0x0800), packets:0, bytes:0, used:ne=
ver, actions:dec_ttl{ttl<=3D1 action:(drop)},1,1
>> > > >     in_port(1),eth(),eth_type(0x0800), packets:0, bytes:0, used:ne=
ver, actions:dec_ttl{ttl<=3D1 action:(drop)},1,2
>> > > >     in_port(1),eth(),eth_type(0x0806), packets:0, bytes:0, used:ne=
ver, actions:2
>> > > >     in_port(2),eth(),eth_type(0x0806), packets:0, bytes:0, used:ne=
ver, actions:1
>> > > >
>> > > >     # ping -c1 192.168.0.2 -t 42
>> > > >     IP (tos 0x0, ttl 41, id 61647, offset 0, flags [DF], proto ICM=
P (1), length 84)
>> > > >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 386, seq =
1, length 64
>> > > >     # ping -c1 192.168.0.2 -t 120
>> > > >     IP (tos 0x0, ttl 119, id 62070, offset 0, flags [DF], proto IC=
MP (1), length 84)
>> > > >         192.168.0.1 > 192.168.0.2: ICMP echo request, id 388, seq =
1, length 64
>> > > >     # ping -c1 192.168.0.2 -t 1
>> > > >     #
>> > > >
>> > > > Co-authored-by: Bindiya Kurle <bindiyakurle@gmail.com>
>> > > > Signed-off-by: Bindiya Kurle <bindiyakurle@gmail.com>
>> > > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
>> > > > ---
>> > > >  include/uapi/linux/openvswitch.h |  22 +++++++
>> > > >  net/openvswitch/actions.c        |  71 +++++++++++++++++++++
>> > > >  net/openvswitch/flow_netlink.c   | 105 ++++++++++++++++++++++++++=
+++++
>> > > >  3 files changed, 198 insertions(+)
>> > > >
>> > >
>> > > Hi Matteo,
>> > >
>> > > [snip]
>> > > > +}
>> > > > +
>> > > >  /* When 'last' is true, sample() should always consume the 'skb'.
>> > > >   * Otherwise, sample() should keep 'skb' intact regardless what
>> > > >   * actions are executed within sample().
>> > > > @@ -1176,6 +1201,44 @@ static int execute_check_pkt_len(struct dat=
apath *dp, struct sk_buff *skb,
>> > > >                            nla_len(actions), last, clone_flow_key)=
;
>> > > >  }
>> > > >
>> > > > +static int execute_dec_ttl(struct sk_buff *skb, struct sw_flow_ke=
y *key)
>> > > > +{
>> > > > +     int err;
>> > > > +
>> > > > +     if (skb->protocol =3D=3D htons(ETH_P_IPV6)) {
>> > > > +             struct ipv6hdr *nh =3D ipv6_hdr(skb);
>> > > > +
>> > > > +             err =3D skb_ensure_writable(skb, skb_network_offset(=
skb) +
>> > > > +                                       sizeof(*nh));
>> > >
>> > > skb_ensure_writable() calls pskb_may_pull() which may reallocate so =
nh might become invalid.
>> > > It seems the IPv4 version below is ok as the ptr is reloaded.
>> > >
>> >
>> > Right
>> >
>> > > One q as I don't know ovs that much - can this action be called only=
 with
>> > > skb->protocol =3D=3D  ETH_P_IP/IPV6 ? I.e. Are we sure that if it's =
not v6, then it must be v4 ?
>> > >
>> >
>> > I'm adding a check in validate_and_copy_dec_ttl() so only ipv4/ipv6
>> > packet will pass.
>> >
>> > Thanks,
>> >
>> > --
>> > Matteo Croce
>> > per aspera ad upstream
>> >
>> > _______________________________________________
>> > dev mailing list
>> > dev@openvswitch.org
>> > https://mail.openvswitch.org/mailman/listinfo/ovs-dev
