Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036875B4103
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 22:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229767AbiIIUre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 16:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiIIUrH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 16:47:07 -0400
X-Greylist: delayed 375 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 09 Sep 2022 13:46:46 PDT
Received: from smtp115.ord1d.emailsrvr.com (smtp115.ord1d.emailsrvr.com [184.106.54.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E718110BA60
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 13:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=openvpn.net;
        s=20170822-45nk5nwl; t=1662756031;
        bh=fmp6kod3e8WlLS1D75IvLxr+XqjtkWAx/iubzieaDkk=;
        h=Date:To:From:Subject:From;
        b=oEG035IDKmZQrKY1PdmEjrqg8GBxnKaLegqrZfqjZNerTF8ZQ//oM6BBeDtO05pzn
         dBbvFt4fWXkhUccH9u25u+l3owpV6XOxJSPK37GsZyP4RNvuTp8zfIyz7FZ0NEQPnq
         GAEAeZUY7OYjLy/ganra2KnUukjplbcGVV/+lt0Q=
X-Auth-ID: antonio@openvpn.net
Received: by smtp7.relay.ord1d.emailsrvr.com (Authenticated sender: antonio-AT-openvpn.net) with ESMTPSA id 2B119200FC;
        Fri,  9 Sep 2022 16:40:30 -0400 (EDT)
Message-ID: <3d4a5efa-347b-c71a-5360-f55602428c5a@openvpn.net>
Date:   Fri, 9 Sep 2022 22:40:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Content-Language: en-US
To:     Sergey Ryazanov <ryazanov.s.a@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <20220719014704.21346-2-antonio@openvpn.net>
 <20220803153152.11189-1-antonio@openvpn.net>
 <CAHNKnsQnHAdxC-XhC9RP-cFp0d-E4YGb+7ie3WymXVL9N-QS6A@mail.gmail.com>
 <1eb71408-c79d-1097-6841-829bc8e272d1@openvpn.net>
 <CAHNKnsTZE5dJJ+r65zCoPB4Yr8R9_sB0BmyX4r0mgfALsUtxOA@mail.gmail.com>
From:   Antonio Quartulli <antonio@openvpn.net>
Organization: OpenVPN Inc.
Subject: Re: [RFC v2] net: introduce OpenVPN Data Channel Offload (ovpn-dco)
In-Reply-To: <CAHNKnsTZE5dJJ+r65zCoPB4Yr8R9_sB0BmyX4r0mgfALsUtxOA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Classification-ID: 8787be67-6094-4d83-8ffc-80b053f3e885-1-1
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sergey,

apologies on my side this time - I was still out of office until early 
this week and I did not have a chance to reply.

Please see below.

On 31/08/2022 05:15, Sergey Ryazanov wrote:
[cut]
> 
> For the review, it is more than acceptable, it is appreciated :)

will proceed with the split up then.

[cut]
>>>> +config OVPN_DCO
>>>> +       tristate "OpenVPN data channel offload"
>>>
>>> Just curious, why do you need this "DCO" suffix? It is not some
>>> commonly recognized abbreviation. Why not just call this module
>>> "OpenVPN"? Or are you planning to move some other components into the
>>> kernel and reserve some naming space?
>>
>> This device driver just implements data channel offloading and it is not
>> a fully fledged OpenVPN impementation, so I thought it was meaningful to
>> make this explicit.
>>
>> Calling the driver just openvpn/ovpn may give the false impression that
>> this is a reimplementation of the whole OpenVPN protocol in kernelspace.
>>
>> Does it make sense?
> 
> Yep, that sounds like a reasonable assumption. But this "DCO" suffix
> just sounds confusing (see my experiment results below).
> 
> There are many data plane implementations in the kernel that are named
> after a protocol, but do not implement a control part at all (e.g.
> L2TP, PPTP, GTP, TLS, etc.). These names are not confusing since an
> "average developer" knows that it is normal practice to implement a
> data plane part in the kernel for performance reasons, while keeping a
> control plane in userspace.
> 
> To be clear, I do not mind specifying in the title and description of
> the option that the module only implements data processing. Such
> remark will only help end users. BTW, you wrote a very clear and
> simple description for the option. But meeting this abbreviation in
> the file names, I want to ask: why is it needed here?
> 
>> The "DCO" acronym may not be so common in other areas, but in the
>> OpenVPN community we have been talking about DCO (Data Channel Offload)
>> since a while, so it was pretty natural for us to use this suffix.
> 
> In the context of OpenVPN development, this can help distinguish the
> components. But outside this context, it may be confusing.
> 
> I did an experiment. I told a couple of developers who was not aware
> about this patch that the OpenVPN community has created and is
> begining a kernel module upstreaming process and that module will be
> called 'openvpn-dco'. Each of them first said "wow, what a good news",
> but then each of them asked me "What does DCO mean?".

Thanks for elaborating your point and for taking the time to conduct 
this little experiment.

I agree with you, like other protocols that have the control plane 
implemented in userspace, also in this case we should go with "ovpn" only.

I think that I'll rename the folder and the config knob :-)

[cut]
>>>> +static struct rtnl_link_ops ovpn_link_ops __read_mostly = {
>>>> +       .kind                   = DRV_NAME,
>>>> +       .priv_size              = sizeof(struct ovpn_struct),
>>>> +       .setup                  = ovpn_setup,
>>>> +       .policy                 = ovpn_policy,
>>>> +       .maxtype                = IFLA_OVPN_MAX,
>>>> +       .newlink                = ovpn_newlink,
>>>> +       .dellink                = ovpn_dellink,
>>>
>>> What is the purpose of creating and destroying interfaces via RTNL,
>>> but performing all other operations using the dedicated netlink
>>> protocol?
>>>
>>> RTNL interface usually implemented for some standalone interface
>>> types, e.g. VLAN, GRE, etc. Here we need a userspace application
>>> anyway to be able to use the network device to forward traffic, and
>>> the module implements the dedicated GENL protocol. So why not just
>>> introduce OVPN_CMD_NEW_IFACE and OVPN_CMD_DEL_IFACE commands to the
>>> GENL interface? It looks like this will simplify the userspace part by
>>> using the single GENL interface for any management operations.
>>
>> As Stephen also said in his reply, I tried to stick to the standard
>> approach of creating interface via RTNL (which is also netlink).
> 
> Probably there is no such thing as a standard here. There is a common
> good practice to use RTNL to create a virtual network device if it can
> be used just after creation. What is a quite common case. But an
> openvpn network device remains useless once created until someone adds
> a peer configuration using the GENL-based management interface.
> Therefore, I still think that the RTNL management in this particular
> case is a dead-end. See my answer to Stephen for more details and
> examples.

Yeah, you have very good points here as well.

I am thinking at wifi/vap interfaces: they are also created via GENL 
(nl80211) and not via RTNL. On top of that, in order to create an AP 
iface you are really supposed to run hostapd - you can't normally create 
a standalone AP iface without the daemon running.

And OpenVPN is somewhat similar as you need the daemon to be running in 
order to do something useful with the iface.

> 
>> With this implementation you can already create an interface as:
>>
>> ip link add vpn0 type ovpn-dco
>>
>> Eventually I will patch iproute2 to support some options as well (we
>> have one only for now).
> 
> What do you think about using ip-l2tp(8) instead of ip-link(8) as a
> reference implementation for the openvpn devices management?

I had a look - L2TP is a bit simpler as it does not carry encryption, 
keys and key renewal. Other than that I think the approach the approach 
I took is somewhat similar.

> 
>>>> +       .get_num_tx_queues      = ovpn_num_queues,
>>>> +       .get_num_rx_queues      = ovpn_num_queues,
>>>
>>> What is the benefit of requesting multiple queues if the xmit callback
>>> places all packets from those kernel queues into the single internal
>>> queue anyway?
>>
>> Good point. This is one of those aspects where I was hoping to get some
>> guidance.
>> In any case, I will double check if having more than one queue is really
>> what we want or not.
> 
> Start with a single queue, make a stable implementation, merge it into
> the kernel so you have a good basis for future performance
> optimizations. Anyway, the single queue implementation inside the
> kernel will be much faster than the userspace implementation with the
> double memory copying.

Makes sense. Will branch off my implementation and test a bit with a 
single queue.

> 
>>>> +};
>>>> +
>>>> +static int __init ovpn_init(void)
>>>> +{
>>>> +       int err = 0;
>>>> +
>>>> +       pr_info("%s %s -- %s\n", DRV_DESCRIPTION, DRV_VERSION, DRV_COPYRIGHT);
>>>
>>> Is this log line really necessary for the regular module usage?
>>
>> Well, it's a reasonable way to give users feedback about the module
>> loading successfully. I see it's pretty common across drivers, so I
>> thought to use the same approach.
> 
> Maybe it is a matter of taste, but I always consider such "hello"
> messages as noise in the boot log. User can check the loaded modules
> list with lsmod(8).

To be honest I don't have a strong opinion.
I just looked at what other drivers do and I did the same.
Personally I prefer consistency across the various drivers.

Should the community decide that the "hellos" are bad, then we should 
probably remove them all, no?
Having all other modules say something when loaded, while ovpn stays 
silent may make the average user think that something went wrong, imho.

>>> [skipped]
>>>
>>>> +static int ovpn_transport_to_userspace(struct ovpn_struct *ovpn, const struct ovpn_peer *peer,
>>>> +                                      struct sk_buff *skb)
>>>> +{
>>>> +       int ret;
>>>> +
>>>> +       ret = skb_linearize(skb);
>>>> +       if (ret < 0)
>>>> +               return ret;
>>>> +
>>>> +       ret = ovpn_netlink_send_packet(ovpn, peer, skb->data, skb->len);
>>>> +       if (ret < 0)
>>>> +               return ret;
>>>
>>> Another interesting decision. Why are you transporting the control
>>> messages via Netlink? Why not just pass them to userspace via an
>>> already existing TCP/UDP socket, like the LT2P module do, for example?
>>> Such design usually requires less changes to the userspace application
>>> since it is still able to process control messages as earlier by
>>> reading them from the socket.
>>
>> As far as I understand the L2TP module implementes its own protocol
>> (IPPROTO_L2TP).
>>
>> In the ovpn-dco case userspace simply opens a normal UDP or TCP socket
>> (as it always used to do), which is later passed to the kernel.
>>
>> In ovpn-dco (kernel) we then use udp_tunnel to take over the UDP socket,
>> while we change the socket ops in case of TCP.
>>
>> While in the UDP case it would be possible to still use the socket to
>> send control packets, in the TCP case this would not work and we would
>> need another method (which is netlink) to send/receive packets from
>> userspace.
> 
> Even if you intercept the whole incoming traffic in the kernel, you
> can still pass some of it to userspace. You just need to override some
> socket protocol ops. See TLS implementation for example
> (/net/tls/{tls_main.c,tls_sw.c}) and c46234ebb4d1 ("tls: RX path for
> ktls"). The same is possible for outgoing traffic too.
> 

Thanks for the pointer!

It's indeed interesting although not straightforward.
I am diving in the ktls code to understand if this is applicable to ovpn 
as well.

>> At this point we did not want to treat TCP and UDP sockets differently,
>> so we decided to always use netlink to send control packets to/from
>> userspace.
>>
>>>
>>>> +       consume_skb(skb);
>>>> +       return 0;
>>>> +}
>>>
>>> [skipped]
>>>
>>>> diff --git a/include/uapi/linux/ovpn_dco.h b/include/uapi/linux/ovpn_dco.h
>>>> new file mode 100644
>>>> index 000000000000..6afee8b3fedd
>>>> --- /dev/null
>>>> +++ b/include/uapi/linux/ovpn_dco.h
>>>> @@ -0,0 +1,265 @@
>>>> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
>>>> +/*
>>>> + *  OpenVPN data channel accelerator
>>>> + *
>>>> + *  Copyright (C) 2019-2022 OpenVPN, Inc.
>>>> + *
>>>> + *  Author:    James Yonan <james@openvpn.net>
>>>> + *             Antonio Quartulli <antonio@openvpn.net>
>>>> + */
>>>> +
>>>> +#ifndef _UAPI_LINUX_OVPN_DCO_H_
>>>> +#define _UAPI_LINUX_OVPN_DCO_H_
>>>> +
>>>> +#define OVPN_NL_NAME "ovpn-dco"
>>>> +
>>>> +#define OVPN_NL_MULTICAST_GROUP_PEERS "peers"
>>>> +
>>>> +/**
>>>> + * enum ovpn_nl_commands - supported netlink commands
>>>> + */
>>>> +enum ovpn_nl_commands {
>>>> +       /**
>>>> +        * @OVPN_CMD_UNSPEC: unspecified command to catch errors
>>>> +        */
>>>> +       OVPN_CMD_UNSPEC = 0,
>>>> +
>>>> +       /**
>>>> +        * @OVPN_CMD_NEW_PEER: Configure peer with its crypto keys
>>>> +        */
>>>> +       OVPN_CMD_NEW_PEER,
>>>> +
>>>> +       /**
>>>> +        * @OVPN_CMD_SET_PEER: Tweak parameters for an existing peer
>>>> +        */
>>>> +       OVPN_CMD_SET_PEER,
>>>> +
>>>> +       /**
>>>> +        * @OVPN_CMD_DEL_PEER: Remove peer from internal table
>>>> +        */
>>>> +       OVPN_CMD_DEL_PEER,
>>>> +
>>>> +       OVPN_CMD_NEW_KEY,
>>>> +
>>>> +       OVPN_CMD_SWAP_KEYS,
>>>> +
>>>> +       OVPN_CMD_DEL_KEY,
>>>> +
>>>> +       /**
>>>> +        * @OVPN_CMD_REGISTER_PACKET: Register for specific packet types to be
>>>> +        * forwarded to userspace
>>>> +        */
>>>> +       OVPN_CMD_REGISTER_PACKET,
>>>> +
>>>> +       /**
>>>> +        * @OVPN_CMD_PACKET: Send a packet from userspace to kernelspace. Also
>>>> +        * used to send to userspace packets for which a process had registered
>>>> +        * with OVPN_CMD_REGISTER_PACKET
>>>> +        */
>>>> +       OVPN_CMD_PACKET,
>>>> +
>>>> +       /**
>>>> +        * @OVPN_CMD_GET_PEER: Retrieve the status of a peer or all peers
>>>> +        */
>>>> +       OVPN_CMD_GET_PEER,
>>>> +};
>>>> +
>>>> +enum ovpn_cipher_alg {
>>>> +       /**
>>>> +        * @OVPN_CIPHER_ALG_NONE: No encryption - reserved for debugging only
>>>> +        */
>>>> +       OVPN_CIPHER_ALG_NONE = 0,
>>>> +       /**
>>>> +        * @OVPN_CIPHER_ALG_AES_GCM: AES-GCM AEAD cipher with any allowed key size
>>>> +        */
>>>> +       OVPN_CIPHER_ALG_AES_GCM,
>>>> +       /**
>>>> +        * @OVPN_CIPHER_ALG_CHACHA20_POLY1305: ChaCha20Poly1305 AEAD cipher
>>>> +        */
>>>> +       OVPN_CIPHER_ALG_CHACHA20_POLY1305,
>>>> +};
>>>> +
>>>> +enum ovpn_del_peer_reason {
>>>> +       __OVPN_DEL_PEER_REASON_FIRST,
>>>> +       OVPN_DEL_PEER_REASON_TEARDOWN = __OVPN_DEL_PEER_REASON_FIRST,
>>>> +       OVPN_DEL_PEER_REASON_USERSPACE,
>>>> +       OVPN_DEL_PEER_REASON_EXPIRED,
>>>> +       OVPN_DEL_PEER_REASON_TRANSPORT_ERROR,
>>>> +       __OVPN_DEL_PEER_REASON_AFTER_LAST
>>>> +};
>>>> +
>>>> +enum ovpn_key_slot {
>>>> +       __OVPN_KEY_SLOT_FIRST,
>>>> +       OVPN_KEY_SLOT_PRIMARY = __OVPN_KEY_SLOT_FIRST,
>>>> +       OVPN_KEY_SLOT_SECONDARY,
>>>> +       __OVPN_KEY_SLOT_AFTER_LAST,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_attrs {
>>>> +       OVPN_ATTR_UNSPEC = 0,
>>>> +       OVPN_ATTR_IFINDEX,
>>>> +       OVPN_ATTR_NEW_PEER,
>>>> +       OVPN_ATTR_SET_PEER,
>>>> +       OVPN_ATTR_DEL_PEER,
>>>
>>> What is the purpose of introducing separate attributes for each
>>> NEW/SET/GET/DEL operation? Why not just use a single OVPN_ATTR_PEER
>>> attribute?
>>
>> The idea is to have a subobject for each operation. Each specific
>> subobject would then contain only the specific attributes allowed for
>> that object. This way attributes from different operations are not mixed.
> 
> I am still puzzled. What is the reason to not mix attributes from
> different operations if they are operations on the same object?

The reason is that different operations on the same object may expect 
different attributes.

For example, the current implementation expects the user calling 
NEW_PEER to pass the fd of the transport socket and the VPN IP 
associated with the client.

Those two are not supposed to be changed later on, therefore the 
SET_PEER does not allow such attributes to be specified.

If we had all the attributes in one single set, the user would not know 
which attributes are expected by NEW_PEER and which by SET_PEER.

Makes any sense? :-)

> 
>>> BTW, generic netlink for some time allows you to have a dedicated set
>>> of attributes (and corresponding policies) for each message. So, if
>>> you have different object types (e.g. peers, interfaces, keys) you can
>>> avoid creating a common set of attributes to cover them all at once,
>>> but just create several attribute sets, one set per each object type
>>> with corresponding policies (see policy field of the genl_ops struct).
>>
>> mh interesting. Any module I could look at that implements this approach?
> 
> See ./kernel/taskstats.c:672 for example
> 
>>>> +       OVPN_ATTR_NEW_KEY,
>>>> +       OVPN_ATTR_SWAP_KEYS,
>>>> +       OVPN_ATTR_DEL_KEY,
>>>> +       OVPN_ATTR_PACKET,
>>>> +       OVPN_ATTR_GET_PEER,
>>>> +
>>>> +       __OVPN_ATTR_AFTER_LAST,
>>>> +       OVPN_ATTR_MAX = __OVPN_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_key_dir_attrs {
>>>> +       OVPN_KEY_DIR_ATTR_UNSPEC = 0,
>>>> +       OVPN_KEY_DIR_ATTR_CIPHER_KEY,
>>>> +       OVPN_KEY_DIR_ATTR_NONCE_TAIL,
>>>> +
>>>> +       __OVPN_KEY_DIR_ATTR_AFTER_LAST,
>>>> +       OVPN_KEY_DIR_ATTR_MAX = __OVPN_KEY_DIR_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_new_key_attrs {
>>>> +       OVPN_NEW_KEY_ATTR_UNSPEC = 0,
>>>> +       OVPN_NEW_KEY_ATTR_PEER_ID,
>>>> +       OVPN_NEW_KEY_ATTR_KEY_SLOT,
>>>> +       OVPN_NEW_KEY_ATTR_KEY_ID,
>>>> +       OVPN_NEW_KEY_ATTR_CIPHER_ALG,
>>>> +       OVPN_NEW_KEY_ATTR_ENCRYPT_KEY,
>>>> +       OVPN_NEW_KEY_ATTR_DECRYPT_KEY,
>>>> +
>>>> +       __OVPN_NEW_KEY_ATTR_AFTER_LAST,
>>>> +       OVPN_NEW_KEY_ATTR_MAX = __OVPN_NEW_KEY_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_del_key_attrs {
>>>> +       OVPN_DEL_KEY_ATTR_UNSPEC = 0,
>>>> +       OVPN_DEL_KEY_ATTR_PEER_ID,
>>>> +       OVPN_DEL_KEY_ATTR_KEY_SLOT,
>>>> +
>>>> +       __OVPN_DEL_KEY_ATTR_AFTER_LAST,
>>>> +       OVPN_DEL_KEY_ATTR_MAX = __OVPN_DEL_KEY_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_swap_keys_attrs {
>>>> +       OVPN_SWAP_KEYS_ATTR_UNSPEC = 0,
>>>> +       OVPN_SWAP_KEYS_ATTR_PEER_ID,
>>>> +
>>>> +       __OVPN_SWAP_KEYS_ATTR_AFTER_LAST,
>>>> +       OVPN_SWAP_KEYS_ATTR_MAX = __OVPN_SWAP_KEYS_ATTR_AFTER_LAST - 1,
>>>> +
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_new_peer_attrs {
>>>> +       OVPN_NEW_PEER_ATTR_UNSPEC = 0,
>>>> +       OVPN_NEW_PEER_ATTR_PEER_ID,
>>>> +       OVPN_NEW_PEER_ATTR_SOCKADDR_REMOTE,
>>>> +       OVPN_NEW_PEER_ATTR_SOCKET,
>>>> +       OVPN_NEW_PEER_ATTR_IPV4,
>>>> +       OVPN_NEW_PEER_ATTR_IPV6,
>>>> +       OVPN_NEW_PEER_ATTR_LOCAL_IP,
>>>> +
>>>> +       __OVPN_NEW_PEER_ATTR_AFTER_LAST,
>>>> +       OVPN_NEW_PEER_ATTR_MAX = __OVPN_NEW_PEER_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_set_peer_attrs {
>>>> +       OVPN_SET_PEER_ATTR_UNSPEC = 0,
>>>> +       OVPN_SET_PEER_ATTR_PEER_ID,
>>>> +       OVPN_SET_PEER_ATTR_KEEPALIVE_INTERVAL,
>>>> +       OVPN_SET_PEER_ATTR_KEEPALIVE_TIMEOUT,
>>>> +
>>>> +       __OVPN_SET_PEER_ATTR_AFTER_LAST,
>>>> +       OVPN_SET_PEER_ATTR_MAX = __OVPN_SET_PEER_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_del_peer_attrs {
>>>> +       OVPN_DEL_PEER_ATTR_UNSPEC = 0,
>>>> +       OVPN_DEL_PEER_ATTR_REASON,
>>>> +       OVPN_DEL_PEER_ATTR_PEER_ID,
>>>> +
>>>> +       __OVPN_DEL_PEER_ATTR_AFTER_LAST,
>>>> +       OVPN_DEL_PEER_ATTR_MAX = __OVPN_DEL_PEER_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_get_peer_attrs {
>>>> +       OVPN_GET_PEER_ATTR_UNSPEC = 0,
>>>> +       OVPN_GET_PEER_ATTR_PEER_ID,
>>>> +
>>>> +       __OVPN_GET_PEER_ATTR_AFTER_LAST,
>>>> +       OVPN_GET_PEER_ATTR_MAX = __OVPN_GET_PEER_ATTR_AFTER_LAST - 1,
>>>> +};
>>>
>>> What is the reason to create a separate set of attributes per each
>>> operation? In my experience, it is easier to use a common set of
>>> attributes for all operations on the same object type. At least it is
>>> easier to manage one enum instead of four. And you are always sure
>>> that attributes with the same semantics (e.g. remote IP) have the same
>>> id in any GET/SET message.
>>
>> The reason is mostly documentation.
>>
>> In my experience (which is mostly wifi related), when using a single set
>> of attributes is (almost) impossible to understand which attributes have
>> to be sent along with a specific command.
>> I always had to look at the actual netlink handlers implementation.
>>
>> With this approach, instead, I can point out immediately what attributes
>> are related to which command.
>>
>> Maybe this is not the best approach, but I wanted a way that allows a
>> developer to immediately understand the ovpn-dco API without having to
>> read the code in ovpn-dco/netlink.c
>>
>> What do you think?
> 
> Looks like the other extreme. By avoiding the case of one set of
> attributes for any command, we got a special set of attributes per
> each command.
> 
> Is it conceptually possible to implement the approach with a
> per-object set of attributes?

I believe my answer above addresses this question as well.

> 
>>>> +enum ovpn_netlink_get_peer_response_attrs {
>>>> +       OVPN_GET_PEER_RESP_ATTR_UNSPEC = 0,
>>>> +       OVPN_GET_PEER_RESP_ATTR_PEER_ID,
>>>> +       OVPN_GET_PEER_RESP_ATTR_SOCKADDR_REMOTE,
>>>> +       OVPN_GET_PEER_RESP_ATTR_IPV4,
>>>> +       OVPN_GET_PEER_RESP_ATTR_IPV6,
>>>> +       OVPN_GET_PEER_RESP_ATTR_LOCAL_IP,
>>>> +       OVPN_GET_PEER_RESP_ATTR_LOCAL_PORT,
>>>> +       OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_INTERVAL,
>>>> +       OVPN_GET_PEER_RESP_ATTR_KEEPALIVE_TIMEOUT,
>>>> +       OVPN_GET_PEER_RESP_ATTR_RX_BYTES,
>>>> +       OVPN_GET_PEER_RESP_ATTR_TX_BYTES,
>>>> +       OVPN_GET_PEER_RESP_ATTR_RX_PACKETS,
>>>> +       OVPN_GET_PEER_RESP_ATTR_TX_PACKETS,
>>>> +
>>>> +       __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST,
>>>> +       OVPN_GET_PEER_RESP_ATTR_MAX = __OVPN_GET_PEER_RESP_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_peer_stats_attrs {
>>>> +       OVPN_PEER_STATS_ATTR_UNSPEC = 0,
>>>> +       OVPN_PEER_STATS_BYTES,
>>>> +       OVPN_PEER_STATS_PACKETS,
>>>> +
>>>> +       __OVPN_PEER_STATS_ATTR_AFTER_LAST,
>>>> +       OVPN_PEER_STATS_ATTR_MAX = __OVPN_PEER_STATS_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_peer_attrs {
>>>> +       OVPN_PEER_ATTR_UNSPEC = 0,
>>>> +       OVPN_PEER_ATTR_PEER_ID,
>>>> +       OVPN_PEER_ATTR_SOCKADDR_REMOTE,
>>>> +       OVPN_PEER_ATTR_IPV4,
>>>> +       OVPN_PEER_ATTR_IPV6,
>>>> +       OVPN_PEER_ATTR_LOCAL_IP,
>>>> +       OVPN_PEER_ATTR_KEEPALIVE_INTERVAL,
>>>> +       OVPN_PEER_ATTR_KEEPALIVE_TIMEOUT,
>>>> +       OVPN_PEER_ATTR_ENCRYPT_KEY,
>>>> +       OVPN_PEER_ATTR_DECRYPT_KEY,
>>>> +       OVPN_PEER_ATTR_RX_STATS,
>>>> +       OVPN_PEER_ATTR_TX_STATS,
>>>> +
>>>> +       __OVPN_PEER_ATTR_AFTER_LAST,
>>>> +       OVPN_PEER_ATTR_MAX = __OVPN_PEER_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_netlink_packet_attrs {
>>>> +       OVPN_PACKET_ATTR_UNSPEC = 0,
>>>> +       OVPN_PACKET_ATTR_PACKET,
>>>> +       OVPN_PACKET_ATTR_PEER_ID,
>>>> +
>>>> +       __OVPN_PACKET_ATTR_AFTER_LAST,
>>>> +       OVPN_PACKET_ATTR_MAX = __OVPN_PACKET_ATTR_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_ifla_attrs {
>>>> +       IFLA_OVPN_UNSPEC = 0,
>>>> +       IFLA_OVPN_MODE,
>>>> +
>>>> +       __IFLA_OVPN_AFTER_LAST,
>>>> +       IFLA_OVPN_MAX = __IFLA_OVPN_AFTER_LAST - 1,
>>>> +};
>>>> +
>>>> +enum ovpn_mode {
>>>> +       __OVPN_MODE_FIRST = 0,
>>>> +       OVPN_MODE_P2P = __OVPN_MODE_FIRST,
>>>> +       OVPN_MODE_MP,
>>>> +
>>>> +       __OVPN_MODE_AFTER_LAST,
>>>> +};
>>>> +
>>>> +#endif /* _UAPI_LINUX_OVPN_DCO_H_ */
> 

Cheers,

-- 
Antonio Quartulli
OpenVPN Inc.
