Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A6D65B64A6
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 02:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiIMAuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 20:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiIMAt6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 20:49:58 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DBACDEFC;
        Mon, 12 Sep 2022 17:49:57 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id s11so5441707ilt.7;
        Mon, 12 Sep 2022 17:49:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=6cu7pFErco2XwbYI7dtF3h2efkfg7dP4hhpnepoxwPI=;
        b=BHgoRiZeZft06jhxOQC7FLq+uHL9/8pj00+HUvv/DmXOE8lrE4BwbBnAO0x/9l91bx
         sDA1yTw8APZ7E4k/iMaJqGiZiMh76Ya6FoP02fzFf9Or/xPmh4az/isJG+bJWHHxi5mD
         Nw9SkRIy1Pd8E8IuZeg03t6M6uYLmZXjaTQiMacbSZCnImHFGcfWMAwkPw12/lBSF1Pz
         rMy6v/r9UwUevF7kFIitN2pnyQ5VS9iVLurxIT/CD05CbZv0/wakzDysZRBWwwP22yyn
         NqhctgSM2e0rbj+DH3Ai3BM5w71+ho6UAZPThrgeeyad/36E7EcQuFMteE1u+H0OTaEa
         QY4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=6cu7pFErco2XwbYI7dtF3h2efkfg7dP4hhpnepoxwPI=;
        b=OcMdZOP8c4PzPXs97bE8uG+bvDEY+LswmDT52eq9LDCzP+8Ip0UmELQinX5H1d+GS6
         39+IRrsznFaA+9ACb2bIYf2d/+5svBlHyK991NDW7t+tYYrB7saGMP5NkRQVGeL96gYz
         or58/P4DZW+oLt9NLhQZwTLV925jvVusU3bdxyjLoQP7Q4xH12FRI0VXa3nw8TUm63EO
         ZYZBjiRfK7IpxXzTVDu2W8Ldu9ETPi0XQGoKN1O/nPKSMRpfLZo2pwQfvKPfN/9uN1H7
         Ug/qC0kJtHV4HkTtOUhU6f1pztl9N+tBNBcs9vRZYKvnbxetkTjDQIqnOIfTS4SyuXh7
         TSaw==
X-Gm-Message-State: ACgBeo3WPfNnF3AZmeSrDEqJqghIpUqljaAkgJ/cUB6Dj5H5r1riR9OL
        NqpFf8QfVHn4yIlwTn7CF5+PVkk/ubE7udwGeTnUPUkybTs=
X-Google-Smtp-Source: AA6agR4Rjw4Vx8aWjTX32BHBljDiN9Tntf90g5E6OkOV7q2AgtcPfQ3yFGlnuakZ5pcIm50Q3Qy53F4ROiFHs4QRgzw=
X-Received: by 2002:a05:6e02:20c3:b0:2f1:b33c:63e4 with SMTP id
 3-20020a056e0220c300b002f1b33c63e4mr12395335ilq.144.1663030196311; Mon, 12
 Sep 2022 17:49:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220719014704.21346-2-antonio@openvpn.net> <20220803153152.11189-1-antonio@openvpn.net>
 <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com>
 <1eb71408-c79d-1097-6841-829bc8e272d1@openvpn.net> <CAHNKnsTZE5dJJ+r65zCoPB4Yr8R9_sB0BmyX4r0mgfALsUtxOA@mail.gmail.com>
 <3d4a5efa-347b-c71a-5360-f55602428c5a@openvpn.net>
In-Reply-To: <3d4a5efa-347b-c71a-5360-f55602428c5a@openvpn.net>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Tue, 13 Sep 2022 03:49:46 +0300
Message-ID: <CAHNKnsQ8on1SwPRTts3xEMW7XY1gMqfZHQi9S=yKRpcqQcz0+w@mail.gmail.com>
Subject: Re: [RFC v2] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
To:     Antonio Quartulli <antonio@openvpn.net>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Antonio,

On Fri, Sep 9, 2022 at 11:40 PM Antonio Quartulli <antonio@openvpn.net> wrote:
> On 31/08/2022 05:15, Sergey Ryazanov wrote:
>>>>> +static struct rtnl_link_ops ovpn_link_ops __read_mostly = {
>>>>> +       .kind                   = DRV_NAME,
>>>>> +       .priv_size              = sizeof(struct ovpn_struct),
>>>>> +       .setup                  = ovpn_setup,
>>>>> +       .policy                 = ovpn_policy,
>>>>> +       .maxtype                = IFLA_OVPN_MAX,
>>>>> +       .newlink                = ovpn_newlink,
>>>>> +       .dellink                = ovpn_dellink,
>>>>
>>>> What is the purpose of creating and destroying interfaces via RTNL,
>>>> but performing all other operations using the dedicated netlink
>>>> protocol?
>>>>
>>>> RTNL interface usually implemented for some standalone interface
>>>> types, e.g. VLAN, GRE, etc. Here we need a userspace application
>>>> anyway to be able to use the network device to forward traffic, and
>>>> the module implements the dedicated GENL protocol. So why not just
>>>> introduce OVPN_CMD_NEW_IFACE and OVPN_CMD_DEL_IFACE commands to the
>>>> GENL interface? It looks like this will simplify the userspace part by
>>>> using the single GENL interface for any management operations.
>>>
>>> As Stephen also said in his reply, I tried to stick to the standard
>>> approach of creating interface via RTNL (which is also netlink).
>>
>> Probably there is no such thing as a standard here. There is a common
>> good practice to use RTNL to create a virtual network device if it can
>> be used just after creation. What is a quite common case. But an
>> openvpn network device remains useless once created until someone adds
>> a peer configuration using the GENL-based management interface.
>> Therefore, I still think that the RTNL management in this particular
>> case is a dead-end. See my answer to Stephen for more details and
>> examples.
>
> Yeah, you have very good points here as well.
>
> I am thinking at wifi/vap interfaces: they are also created via GENL
> (nl80211) and not via RTNL. On top of that, in order to create an AP
> iface you are really supposed to run hostapd - you can't normally create
> a standalone AP iface without the daemon running.
>
> And OpenVPN is somewhat similar as you need the daemon to be running in
> order to do something useful with the iface.

Yep, NL80211 is also a good example. Probably, some wireless
management operations can be expressed using RTNL. But in general this
interface will never be fully functional due to the inability of
augmenting it with new subsystem specific message types (new objects).
So cfg80211 does not have an RTNL interface at all.

>>> With this implementation you can already create an interface as:
>>>
>>> ip link add vpn0 type ovpn-dco
>>>
>>> Eventually I will patch iproute2 to support some options as well (we
>>> have one only for now).
>>
>> What do you think about using ip-l2tp(8) instead of ip-link(8) as a
>> reference implementation for the openvpn devices management?
>
> I had a look - L2TP is a bit simpler as it does not carry encryption,
> keys and key renewal. Other than that I think the approach the approach
> I took is somewhat similar.
>
>>>>> +};
>>>>> +
>>>>> +static int __init ovpn_init(void)
>>>>> +{
>>>>> +       int err = 0;
>>>>> +
>>>>> +       pr_info("%s %s -- %s\n", DRV_DESCRIPTION, DRV_VERSION, DRV_COPYRIGHT);
>>>>
>>>> Is this log line really necessary for the regular module usage?
>>>
>>> Well, it's a reasonable way to give users feedback about the module
>>> loading successfully. I see it's pretty common across drivers, so I
>>> thought to use the same approach.
>>
>> Maybe it is a matter of taste, but I always consider such "hello"
>> messages as noise in the boot log. User can check the loaded modules
>> list with lsmod(8).
>
> To be honest I don't have a strong opinion.
> I just looked at what other drivers do and I did the same.
> Personally I prefer consistency across the various drivers.

I also like to add hello/tracing messages to init and exit functions
at the earlier module development stage. But then I drop this trace
before release, due to the rule of silence: when a program has nothing
surprising to say, it should say nothing.

As far as I know, there are no rules related to printing a hello
message. So it is up to you to print or not to print. I just want to
show that there are some reasons not to.

> Should the community decide that the "hellos" are bad, then we should
> probably remove them all, no?

Yes, you are right. Perhaps someday I or someone else will get tired
of digging into dmesg so much that they will overcome their laziness
and send an RFC patch that removes most of these messages.

> Having all other modules say something when loaded, while ovpn stays
> silent may make the average user think that something went wrong, imho.

It is possible that some drivers are still printing a hello message in
the log. And, most likely, these are old drivers that were developed
out-of-tree for a long time, and then were merged into the tree as is.
But I can not agree that this is a common practice. E.g. my laptop
runs a kernel with 50+ modules, and only a few of them print a hello
message: USB HID, Intel Ethernet and Wi-Fi drivers, and the VLAN
supporting module. The last one, in earlier times, printed as many as
two lines of hello, so now it behaves decently :)

>>>>> diff --git a/include/uapi/linux/ovpn_dco.h b/include/uapi/linux/ovpn_dco.h
>>>>> new file mode 100644
>>>>> index 000000000000..6afee8b3fedd
>>>>> --- /dev/null
>>>>> +++ b/include/uapi/linux/ovpn_dco.h
>>>>> @@ -0,0 +1,265 @@
>>>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>>>> +/*
>>>>> + *  OpenVPN data channel accelerator
>>>>> + *
>>>>> + *  Copyright (C) 2019-2022 OpenVPN, Inc.
>>>>> + *
>>>>> + *  Author:    James Yonan <james@openvpn.net>
>>>>> + *             Antonio Quartulli <antonio@openvpn.net>
>>>>> + */
>>>>> +
>>>>> +#ifndef _UAPI_LINUX_OVPN_DCO_H_
>>>>> +#define _UAPI_LINUX_OVPN_DCO_H_
>>>>> +
>>>>> +#define OVPN_NL_NAME "ovpn-dco"
>>>>> +
>>>>> +#define OVPN_NL_MULTICAST_GROUP_PEERS "peers"
>>>>> +
>>>>> +/**
>>>>> + * enum ovpn_nl_commands - supported netlink commands
>>>>> + */
>>>>> +enum ovpn_nl_commands {
>>>>> +       /**
>>>>> +        * @OVPN_CMD_UNSPEC: unspecified command to catch errors
>>>>> +        */
>>>>> +       OVPN_CMD_UNSPEC = 0,
>>>>> +
>>>>> +       /**
>>>>> +        * @OVPN_CMD_NEW_PEER: Configure peer with its crypto keys
>>>>> +        */
>>>>> +       OVPN_CMD_NEW_PEER,
>>>>> +
>>>>> +       /**
>>>>> +        * @OVPN_CMD_SET_PEER: Tweak parameters for an existing peer
>>>>> +        */
>>>>> +       OVPN_CMD_SET_PEER,
>>>>> +
>>>>> +       /**
>>>>> +        * @OVPN_CMD_DEL_PEER: Remove peer from internal table
>>>>> +        */
>>>>> +       OVPN_CMD_DEL_PEER,
>>>>> +
>>>>> +       OVPN_CMD_NEW_KEY,
>>>>> +
>>>>> +       OVPN_CMD_SWAP_KEYS,
>>>>> +
>>>>> +       OVPN_CMD_DEL_KEY,
>>>>> +
>>>>> +       /**
>>>>> +        * @OVPN_CMD_REGISTER_PACKET: Register for specific packet types to be
>>>>> +        * forwarded to userspace
>>>>> +        */
>>>>> +       OVPN_CMD_REGISTER_PACKET,
>>>>> +
>>>>> +       /**
>>>>> +        * @OVPN_CMD_PACKET: Send a packet from userspace to kernelspace. Also
>>>>> +        * used to send to userspace packets for which a process had registered
>>>>> +        * with OVPN_CMD_REGISTER_PACKET
>>>>> +        */
>>>>> +       OVPN_CMD_PACKET,
>>>>> +
>>>>> +       /**
>>>>> +        * @OVPN_CMD_GET_PEER: Retrieve the status of a peer or all peers
>>>>> +        */
>>>>> +       OVPN_CMD_GET_PEER,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_cipher_alg {
>>>>> +       /**
>>>>> +        * @OVPN_CIPHER_ALG_NONE: No encryption - reserved for debugging only
>>>>> +        */
>>>>> +       OVPN_CIPHER_ALG_NONE = 0,
>>>>> +       /**
>>>>> +        * @OVPN_CIPHER_ALG_AES_GCM: AES-GCM AEAD cipher with any allowed key size
>>>>> +        */
>>>>> +       OVPN_CIPHER_ALG_AES_GCM,
>>>>> +       /**
>>>>> +        * @OVPN_CIPHER_ALG_CHACHA20_POLY1305: ChaCha20Poly1305 AEAD cipher
>>>>> +        */
>>>>> +       OVPN_CIPHER_ALG_CHACHA20_POLY1305,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_del_peer_reason {
>>>>> +       __OVPN_DEL_PEER_REASON_FIRST,
>>>>> +       OVPN_DEL_PEER_REASON_TEARDOWN = __OVPN_DEL_PEER_REASON_FIRST,
>>>>> +       OVPN_DEL_PEER_REASON_USERSPACE,
>>>>> +       OVPN_DEL_PEER_REASON_EXPIRED,
>>>>> +       OVPN_DEL_PEER_REASON_TRANSPORT_ERROR,
>>>>> +       __OVPN_DEL_PEER_REASON_AFTER_LAST
>>>>> +};
>>>>> +
>>>>> +enum ovpn_key_slot {
>>>>> +       __OVPN_KEY_SLOT_FIRST,
>>>>> +       OVPN_KEY_SLOT_PRIMARY = __OVPN_KEY_SLOT_FIRST,
>>>>> +       OVPN_KEY_SLOT_SECONDARY,
>>>>> +       __OVPN_KEY_SLOT_AFTER_LAST,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_attrs {
>>>>> +       OVPN_ATTR_UNSPEC = 0,
>>>>> +       OVPN_ATTR_IFINDEX,
>>>>> +       OVPN_ATTR_NEW_PEER,
>>>>> +       OVPN_ATTR_SET_PEER,
>>>>> +       OVPN_ATTR_DEL_PEER,
>>>>
>>>> What is the purpose of introducing separate attributes for each
>>>> NEW/SET/GET/DEL operation? Why not just use a single OVPN_ATTR_PEER
>>>> attribute?
>>>
>>> The idea is to have a subobject for each operation. Each specific
>>> subobject would then contain only the specific attributes allowed for
>>> that object. This way attributes from different operations are not mixed.
>>
>> I am still puzzled. What is the reason to not mix attributes from
>> different operations if they are operations on the same object?
>
> The reason is that different operations on the same object may expect
> different attributes.
>
> For example, the current implementation expects the user calling
> NEW_PEER to pass the fd of the transport socket and the VPN IP
> associated with the client.
>
> Those two are not supposed to be changed later on, therefore the
> SET_PEER does not allow such attributes to be specified.
>
> If we had all the attributes in one single set, the user would not know
> which attributes are expected by NEW_PEER and which by SET_PEER.
>
> Makes any sense? :-)

Hmm, sounds interesting. What do you think about limiting attributes
with the GENL policies? Are they not enough to clearly show which
attributes are allowed and which are not for each operation?

BTW, thanks to Johannes, since the v5.10 release, usespace may dump
GENL family policies from the kernel to discover what the kernel
actually supports.

I spend so much time discussing attribute sets since they are hard to
change as soon as they become an API. And I am afraid of hard-to-debug
errors caused by similar constant names. E.g.

enum ovpn_netlink_get_peer_response_attrs {
    ...
    OVPN_GET_PEER_RESP_ATTR_LOCAL_PORT = 6,
    OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_INTERVAL = 7,
    ...
};

enum ovpn_netlink_peer_attrs {
    ...
    OVPN_PEER_ATTR_KEEPALIVE_INTERVAL = 6,
    ...
};

In userspace, it is easy to write code like this (assuming libnl usage):

void peer_nlmsg2data(struct genlmsghdr *msg, struct peer *p)
{
    ...
    nla_parse(tb, ..., genlmsg_attrdata(msg, 0), ...);
    ...
    p->ka_int = tb[OVPN_PEER_ATTR_KEEPALIVE_INTERVAL];
    ...
}

Now the ka_int field contains the local port number.

The similar error could be made in the kernel code:

static int send_peer_data(..., struct peer *p)
{
    ...
    genlmsg_put(skb, ..., OVPN_CMD_NEW_PEER);
    nla_put_u32(skb, OVPN_PEER_ATTR_KEEPALIVE_INTERVAL, p->ka_it);
    ...
    return genlmsg_reply(skb, ...);
}

Here, the kernel will return the keep-alive interval inside the local
port attribute.

By these examples, I would like to show how easy it is to make a
mistake when you have many constants with similar names. The worst
thing about this case is that a code will compile successfully, but
will not work as expected. And such bugs can stay unnoticed for a long
time.

>>>> BTW, generic netlink for some time allows you to have a dedicated set
>>>> of attributes (and corresponding policies) for each message. So, if
>>>> you have different object types (e.g. peers, interfaces, keys) you can
>>>> avoid creating a common set of attributes to cover them all at once,
>>>> but just create several attribute sets, one set per each object type
>>>> with corresponding policies (see policy field of the genl_ops struct).
>>>
>>> mh interesting. Any module I could look at that implements this approach?
>>
>> See ./kernel/taskstats.c:672 for example
>>
>>>>> +       OVPN_ATTR_NEW_KEY,
>>>>> +       OVPN_ATTR_SWAP_KEYS,
>>>>> +       OVPN_ATTR_DEL_KEY,
>>>>> +       OVPN_ATTR_PACKET,
>>>>> +       OVPN_ATTR_GET_PEER,
>>>>> +
>>>>> +       __OVPN_ATTR_AFTER_LAST,
>>>>> +       OVPN_ATTR_MAX = __OVPN_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_key_dir_attrs {
>>>>> +       OVPN_KEY_DIR_ATTR_UNSPEC = 0,
>>>>> +       OVPN_KEY_DIR_ATTR_CIPHER_KEY,
>>>>> +       OVPN_KEY_DIR_ATTR_NONCE_TAIL,
>>>>> +
>>>>> +       __OVPN_KEY_DIR_ATTR_AFTER_LAST,
>>>>> +       OVPN_KEY_DIR_ATTR_MAX = __OVPN_KEY_DIR_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_new_key_attrs {
>>>>> +       OVPN_NEW_KEY_ATTR_UNSPEC = 0,
>>>>> +       OVPN_NEW_KEY_ATTR_PEER_ID,
>>>>> +       OVPN_NEW_KEY_ATTR_KEY_SLOT,
>>>>> +       OVPN_NEW_KEY_ATTR_KEY_ID,
>>>>> +       OVPN_NEW_KEY_ATTR_CIPHER_ALG,
>>>>> +       OVPN_NEW_KEY_ATTR_ENCRYPT_KEY,
>>>>> +       OVPN_NEW_KEY_ATTR_DECRYPT_KEY,
>>>>> +
>>>>> +       __OVPN_NEW_KEY_ATTR_AFTER_LAST,
>>>>> +       OVPN_NEW_KEY_ATTR_MAX = __OVPN_NEW_KEY_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_del_key_attrs {
>>>>> +       OVPN_DEL_KEY_ATTR_UNSPEC = 0,
>>>>> +       OVPN_DEL_KEY_ATTR_PEER_ID,
>>>>> +       OVPN_DEL_KEY_ATTR_KEY_SLOT,
>>>>> +
>>>>> +       __OVPN_DEL_KEY_ATTR_AFTER_LAST,
>>>>> +       OVPN_DEL_KEY_ATTR_MAX = __OVPN_DEL_KEY_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_swap_keys_attrs {
>>>>> +       OVPN_SWAP_KEYS_ATTR_UNSPEC = 0,
>>>>> +       OVPN_SWAP_KEYS_ATTR_PEER_ID,
>>>>> +
>>>>> +       __OVPN_SWAP_KEYS_ATTR_AFTER_LAST,
>>>>> +       OVPN_SWAP_KEYS_ATTR_MAX = __OVPN_SWAP_KEYS_ATTR_AFTER_LAST - 1,
>>>>> +
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_new_peer_attrs {
>>>>> +       OVPN_NEW_PEER_ATTR_UNSPEC = 0,
>>>>> +       OVPN_NEW_PEER_ATTR_PEER_ID,
>>>>> +       OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE,
>>>>> +       OVPN_NEW_PEER_ATTR_SOCKET,
>>>>> +       OVPN_NEW_PEER_ATTR_IPV4,
>>>>> +       OVPN_NEW_PEER_ATTR_IPV6,
>>>>> +       OVPN_NEW_PEER_ATTR_LOCAL_IP,
>>>>> +
>>>>> +       __OVPN_NEW_PEER_ATTR_AFTER_LAST,
>>>>> +       OVPN_NEW_PEER_ATTR_MAX = __OVPN_NEW_PEER_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_set_peer_attrs {
>>>>> +       OVPN_SET_PEER_ATTR_UNSPEC = 0,
>>>>> +       OVPN_SET_PEER_ATTR_PEER_ID,
>>>>> +       OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL,
>>>>> +       OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT,
>>>>> +
>>>>> +       __OVPN_SET_PEER_ATTR_AFTER_LAST,
>>>>> +       OVPN_SET_PEER_ATTR_MAX = __OVPN_SET_PEER_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_del_peer_attrs {
>>>>> +       OVPN_DEL_PEER_ATTR_UNSPEC = 0,
>>>>> +       OVPN_DEL_PEER_ATTR_REASON,
>>>>> +       OVPN_DEL_PEER_ATTR_PEER_ID,
>>>>> +
>>>>> +       __OVPN_DEL_PEER_ATTR_AFTER_LAST,
>>>>> +       OVPN_DEL_PEER_ATTR_MAX = __OVPN_DEL_PEER_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_get_peer_attrs {
>>>>> +       OVPN_GET_PEER_ATTR_UNSPEC = 0,
>>>>> +       OVPN_GET_PEER_ATTR_PEER_ID,
>>>>> +
>>>>> +       __OVPN_GET_PEER_ATTR_AFTER_LAST,
>>>>> +       OVPN_GET_PEER_ATTR_MAX = __OVPN_GET_PEER_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>
>>>> What is the reason to create a separate set of attributes per each
>>>> operation? In my experience, it is easier to use a common set of
>>>> attributes for all operations on the same object type. At least it is
>>>> easier to manage one enum instead of four. And you are always sure
>>>> that attributes with the same semantics (e.g. remote IP) have the same
>>>> id in any GET/SET message.
>>>
>>> The reason is mostly documentation.
>>>
>>> In my experience (which is mostly wifi related), when using a single set
>>> of attributes is (almost) impossible to understand which attributes have
>>> to be sent along with a specific command.
>>> I always had to look at the actual netlink handlers implementation.
>>>
>>> With this approach, instead, I can point out immediately what attributes
>>> are related to which command.
>>>
>>> Maybe this is not the best approach, but I wanted a way that allows a
>>> developer to immediately understand the ovpn-dco API without having to
>>> read the code in ovpn-dco/netlink.c
>>>
>>> What do you think?
>>
>> Looks like the other extreme. By avoiding the case of one set of
>> attributes for any command, we got a special set of attributes per
>> each command.
>>
>> Is it conceptually possible to implement the approach with a
>> per-object set of attributes?
>
> I believe my answer above addresses this question as well.
>
>>
>>>>> +enum ovpn_netlink_get_peer_response_attrs {
>>>>> +       OVPN_GET_PEER_RESP_ATTR_UNSPEC = 0,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_PEER_ID,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_SOCKADDR_REMOTE,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_IPV4,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_IPV6,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_LOCAL_IP,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_LOCAL_PORT,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_INTERVAL,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_TIMEOUT,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_RX_BYTES,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_TX_BYTES,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_RX_PACKETS,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_TX_PACKETS,
>>>>> +
>>>>> +       __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST,
>>>>> +       OVPN_GET_PEER_RESP_ATTR_MAX = __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_peer_stats_attrs {
>>>>> +       OVPN_PEER_STATS_ATTR_UNSPEC = 0,
>>>>> +       OVPN_PEER_STATS_BYTES,
>>>>> +       OVPN_PEER_STATS_PACKETS,
>>>>> +
>>>>> +       __OVPN_PEER_STATS_ATTR_AFTER_LAST,
>>>>> +       OVPN_PEER_STATS_ATTR_MAX = __OVPN_PEER_STATS_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_peer_attrs {
>>>>> +       OVPN_PEER_ATTR_UNSPEC = 0,
>>>>> +       OVPN_PEER_ATTR_PEER_ID,
>>>>> +       OVPN_PEER_ATTR_SOCKADDR_REMOTE,
>>>>> +       OVPN_PEER_ATTR_IPV4,
>>>>> +       OVPN_PEER_ATTR_IPV6,
>>>>> +       OVPN_PEER_ATTR_LOCAL_IP,
>>>>> +       OVPN_PEER_ATTR_KEEPALIVE_INTERVAL,
>>>>> +       OVPN_PEER_ATTR_KEEPALIVE_TIMEOUT,
>>>>> +       OVPN_PEER_ATTR_ENCRYPT_KEY,
>>>>> +       OVPN_PEER_ATTR_DECRYPT_KEY,
>>>>> +       OVPN_PEER_ATTR_RX_STATS,
>>>>> +       OVPN_PEER_ATTR_TX_STATS,
>>>>> +
>>>>> +       __OVPN_PEER_ATTR_AFTER_LAST,
>>>>> +       OVPN_PEER_ATTR_MAX = __OVPN_PEER_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_netlink_packet_attrs {
>>>>> +       OVPN_PACKET_ATTR_UNSPEC = 0,
>>>>> +       OVPN_PACKET_ATTR_PACKET,
>>>>> +       OVPN_PACKET_ATTR_PEER_ID,
>>>>> +
>>>>> +       __OVPN_PACKET_ATTR_AFTER_LAST,
>>>>> +       OVPN_PACKET_ATTR_MAX = __OVPN_PACKET_ATTR_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_ifla_attrs {
>>>>> +       IFLA_OVPN_UNSPEC = 0,
>>>>> +       IFLA_OVPN_MODE,
>>>>> +
>>>>> +       __IFLA_OVPN_AFTER_LAST,
>>>>> +       IFLA_OVPN_MAX = __IFLA_OVPN_AFTER_LAST - 1,
>>>>> +};
>>>>> +
>>>>> +enum ovpn_mode {
>>>>> +       __OVPN_MODE_FIRST = 0,
>>>>> +       OVPN_MODE_P2P = __OVPN_MODE_FIRST,
>>>>> +       OVPN_MODE_MP,
>>>>> +
>>>>> +       __OVPN_MODE_AFTER_LAST,
>>>>> +};
>>>>> +
>>>>> +#endif /* _UAPI_LINUX_OVPN_DCO_H_ */

-- 
Sergey
