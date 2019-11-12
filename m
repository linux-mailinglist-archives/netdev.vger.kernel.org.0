Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1765DF8798
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 05:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfKLExL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 23:53:11 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37542 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfKLExL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 23:53:11 -0500
Received: by mail-pf1-f194.google.com with SMTP id p24so12459814pfn.4
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 20:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=mjINTL6L6LPzJj0Fr5x3S95C2PCahmAefdYE+b3ZKVc=;
        b=LRx233K/9rm8bncwyLdJ21CU5FH95EeqvGZvWnJlo5WrOlMzr7LtoXNJId4FXypMKS
         Rcb45LWQn8Dap0jk5PIxYcgzd9dxFyN+es7a3ypP1JrVUwGdWeokWVJOYOcw3ZJw7N4E
         ZlzNaXRzjcj5XYoHZVLS77agK/lS8xp08SJ23ClaL9KesQo4GJQUWAusm0pCJoKIIs4V
         rCFxdZHXIWLW2XdHgmwRKrfqAYGv2rAo/MAVUSC1cAu60oExUN22mgNTwxBO/IaNk1et
         wu/LpJX7xh27GIjXDaB6+HmmOdmiz1DuVvHoOMZo2RL8mPvkk9I0HyjIWY+l5H/qupEN
         Y69A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=mjINTL6L6LPzJj0Fr5x3S95C2PCahmAefdYE+b3ZKVc=;
        b=RdAOapAPfeL/P3Nhdb5vop+MW3fuvbDTeqqC8/UYAbAu9qe7WAe9v9SafA6qu198AG
         P39E6ka1hr1l+kb1INPJwOsIHCtPeXG7EgIPMKaA1WWr++t34Jy3I0kFJecXXDNuB7fT
         TQ8bpr0SM+kYxI5pzePPc9rVPT6UV4PcItBRjvpJbjHtgcSvX5JcmV1GMAMToMjARqu5
         jxxsWNeAtftdsUrVgw+yPQxJExcRpVUi9XjNmzZEeyBMxWxr2ZRB1qKKrikTOxWeJ8/y
         FNVDQCo34Ictvh19smrCgpDH8CGVkbcX1bsL0z/2n3yBWB/AclIHjCFCZec9QhdOqhsb
         T5LA==
X-Gm-Message-State: APjAAAWch4vpQKjVQksQ9IBmP2FTUDhoks6p4uizn5aXm6G7qoSHYlL8
        T+6Sag+aub6wljZ3We2I6DY=
X-Google-Smtp-Source: APXvYqy3Ckpdr0Fej77VcWyy2yHqcDvwcGuowSnxaEoO8Ly3VngZ9R7DwYAHaH/Waqg8FIp+eTl1ag==
X-Received: by 2002:a63:cc56:: with SMTP id q22mr5198299pgi.439.1573534390145;
        Mon, 11 Nov 2019 20:53:10 -0800 (PST)
Received: from [10.54.128.71] ([114.242.249.189])
        by smtp.gmail.com with ESMTPSA id n5sm1883124pgg.80.2019.11.11.20.53.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 11 Nov 2019 20:53:09 -0800 (PST)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH net-next] net: openvswitch: add hash info to upcall
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
X-Mailer: iPhone Mail (16F203)
In-Reply-To: <CAOrHB_CmtDnqpuEtiBSJvS5tDjP8A+6a4ynYGWahF8k3heezUw@mail.gmail.com>
Date:   Tue, 12 Nov 2019 12:53:07 +0800
Cc:     Ben Pfaff <blp@ovn.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        ovs dev <dev@openvswitch.org>, ychen103103@163.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <01C51609-C58C-4D45-9A10-DA5B400CCF4A@gmail.com>
References: <1573386258-35040-1-git-send-email-xiangxia.m.yue@gmail.com> <CAOrHB_CmtDnqpuEtiBSJvS5tDjP8A+6a4ynYGWahF8k3heezUw@mail.gmail.com>
To:     Pravin Shelar <pshelar@ovn.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Nov 12, 2019, at 12:35 PM, Pravin Shelar <pshelar@ovn.org> wrote:
>=20
>> On Sun, Nov 10, 2019 at 3:44 AM <xiangxia.m.yue@gmail.com> wrote:
>>=20
>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>>=20
>> When using the kernel datapath, the upcall don't
>> add skb hash info relatived. That will introduce
>> some problem, because the hash of skb is very
>> important (e.g. vxlan module uses it for udp src port,
>> tx queue selection on tx path.).
>>=20
>> For example, there will be one upcall, without information
>> skb hash, to ovs-vswitchd, for the first packet of one tcp
>> session. When kernel sents the tcp packets, the hash is
>> random for a tcp socket:
>>=20
>> tcp_v4_connect
>>  -> sk_set_txhash (is random)
>>=20
>> __tcp_transmit_skb
>>  -> skb_set_hash_from_sk
>>=20
>> Then the udp src port of first tcp packet is different
>> from rest packets. The topo is shown.
>>=20
>> $ ovs-vsctl add-br br-int
>> $ ovs-vsctl add-port br-int vxl0 -- \
>>                set Interface vxl0 type=3Dvxlan options:key=3D100 options:=
remote_ip=3D1.1.1.200
>>=20
>> $ __tap is internal type on host
>> $ or tap net device for VM/Dockers
>> $ ovs-vsctl add-port br-int __tap
>>=20
>> +---------------+          +-------------------------+
>> |   Docker/VMs  |          |     ovs-vswitchd        |
>> +----+----------+          +-------------------------+
>>     |                       ^                    |
>>     |                       |                    |
>>     |                       |  upcall            v recalculate packet has=
h
>>     |                     +-+--------------------+--+
>>     |  tap netdev         |                         |   vxlan modules
>>     +--------------->     +-->  Open vSwitch ko   --+--->
>>       internal type       |                         |
>>                           +-------------------------+
>>=20
>> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/=
364062.html
>> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
>> ---
>> include/uapi/linux/openvswitch.h |  2 ++
>> net/openvswitch/datapath.c       | 31 ++++++++++++++++++++++++++++++-
>> net/openvswitch/datapath.h       |  3 +++
>> 3 files changed, 35 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/include/uapi/linux/openvswitch.h b/include/uapi/linux/openvs=
witch.h
>> index 1887a451c388..1c58e019438e 100644
>> --- a/include/uapi/linux/openvswitch.h
>> +++ b/include/uapi/linux/openvswitch.h
>> @@ -170,6 +170,7 @@ enum ovs_packet_cmd {
>>  * output port is actually a tunnel port. Contains the output tunnel key
>>  * extracted from the packet as nested %OVS_TUNNEL_KEY_ATTR_* attributes.=

>>  * @OVS_PACKET_ATTR_MRU: Present for an %OVS_PACKET_CMD_ACTION and
>> + * @OVS_PACKET_ATTR_HASH: Packet hash info (e.g. hash, sw_hash and l4_ha=
sh in skb)
>>  * @OVS_PACKET_ATTR_LEN: Packet size before truncation.
>>  * %OVS_PACKET_ATTR_USERSPACE action specify the Maximum received fragmen=
t
>>  * size.
>> @@ -190,6 +191,7 @@ enum ovs_packet_attr {
>>        OVS_PACKET_ATTR_PROBE,      /* Packet operation is a feature probe=
,
>>                                       error logging should be suppressed.=
 */
>>        OVS_PACKET_ATTR_MRU,        /* Maximum received IP fragment size. *=
/
>> +       OVS_PACKET_ATTR_HASH,       /* Packet hash. */
>>        OVS_PACKET_ATTR_LEN,            /* Packet size before truncation. *=
/
>>        __OVS_PACKET_ATTR_MAX
>> };
>> diff --git a/net/openvswitch/datapath.c b/net/openvswitch/datapath.c
>> index 2088619c03f0..f938c43e3085 100644
>> --- a/net/openvswitch/datapath.c
>> +++ b/net/openvswitch/datapath.c
>> @@ -350,7 +350,8 @@ static size_t upcall_msg_size(const struct dp_upcall_=
info *upcall_info,
>>        size_t size =3D NLMSG_ALIGN(sizeof(struct ovs_header))
>>                + nla_total_size(hdrlen) /* OVS_PACKET_ATTR_PACKET */
>>                + nla_total_size(ovs_key_attr_size()) /* OVS_PACKET_ATTR_K=
EY */
>> -               + nla_total_size(sizeof(unsigned int)); /* OVS_PACKET_ATT=
R_LEN */
>> +               + nla_total_size(sizeof(unsigned int)) /* OVS_PACKET_ATTR=
_LEN */
>> +               + nla_total_size(sizeof(u64)); /* OVS_PACKET_ATTR_HASH */=

>>=20
>>        /* OVS_PACKET_ATTR_USERDATA */
>>        if (upcall_info->userdata)
>> @@ -393,6 +394,7 @@ static int queue_userspace_packet(struct datapath *dp=
, struct sk_buff *skb,
>>        size_t len;
>>        unsigned int hlen;
>>        int err, dp_ifindex;
>> +       u64 hash;
>>=20
>>        dp_ifindex =3D get_dpifindex(dp);
>>        if (!dp_ifindex)
>> @@ -504,6 +506,24 @@ static int queue_userspace_packet(struct datapath *d=
p, struct sk_buff *skb,
>>                pad_packet(dp, user_skb);
>>        }
>>=20
>> +       if (skb_get_hash_raw(skb)) {
> skb_get_hash_raw() never fails to return hash, so I do not see point
> of checking hash value.
If hash value is 0, we don't add hash info to upcall.
>=20
>> +               hash =3D skb_get_hash_raw(skb);
>> +
>> +               if (skb->sw_hash)
>> +                       hash |=3D OVS_PACKET_HASH_SW;
>> +
>> +               if (skb->l4_hash)
>> +                       hash |=3D OVS_PACKET_HASH_L4;
>> +
>> +               if (nla_put(user_skb, OVS_PACKET_ATTR_HASH,
>> +                           sizeof (u64), &hash)) {
>> +                       err =3D -ENOBUFS;
>> +                       goto out;
>> +               }
>> +
>> +               pad_packet(dp, user_skb);
>> +       }
>> +
>>        /* Only reserve room for attribute header, packet data is added
>>         * in skb_zerocopy() */
>>        if (!(nla =3D nla_reserve(user_skb, OVS_PACKET_ATTR_PACKET, 0))) {=

>> @@ -543,6 +563,7 @@ static int ovs_packet_cmd_execute(struct sk_buff *skb=
, struct genl_info *info)
>>        struct datapath *dp;
>>        struct vport *input_vport;
>>        u16 mru =3D 0;
>> +       u64 hash;
>>        int len;
>>        int err;
>>        bool log =3D !a[OVS_PACKET_ATTR_PROBE];
>> @@ -568,6 +589,14 @@ static int ovs_packet_cmd_execute(struct sk_buff *sk=
b, struct genl_info *info)
>>        }
>>        OVS_CB(packet)->mru =3D mru;
>>=20
>> +       if (a[OVS_PACKET_ATTR_HASH]) {
>> +               hash =3D nla_get_u64(a[OVS_PACKET_ATTR_HASH]);
>> +
>> +               __skb_set_hash(packet, hash & 0xFFFFFFFFUL,
>> +                              !!(hash & OVS_PACKET_HASH_SW),
>> +                              !!(hash & OVS_PACKET_HASH_L4));
>> +       }
>> +
>>        /* Build an sw_flow for sending this packet. */
>>        flow =3D ovs_flow_alloc();
>>        err =3D PTR_ERR(flow);
>> diff --git a/net/openvswitch/datapath.h b/net/openvswitch/datapath.h
>> index 81e85dde8217..ba89a08647ac 100644
>> --- a/net/openvswitch/datapath.h
>> +++ b/net/openvswitch/datapath.h
>> @@ -248,3 +248,6 @@ do {                                                 =
               \
>>                pr_info("netlink: " fmt "\n", ##__VA_ARGS__);   \
>> } while (0)
>> #endif /* datapath.h */
>> +
>> +#define OVS_PACKET_HASH_SW     (1ULL << 32)
>> +#define OVS_PACKET_HASH_L4     (1ULL << 33)
>=20
> We could define these using enum pkt_hash_types values, rather than
> constant values.
