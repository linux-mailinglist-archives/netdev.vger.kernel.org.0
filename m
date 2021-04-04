Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05B703536FE
	for <lists+netdev@lfdr.de>; Sun,  4 Apr 2021 07:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230405AbhDDFtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 01:49:21 -0400
Received: from mout.gmx.net ([212.227.15.15]:55515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229562AbhDDFtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 4 Apr 2021 01:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1617515344;
        bh=EtmVfcwjiercx5zmkQh5cxhKI9SzywhVz2jQOFCfymY=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=IXr2/2+SqDrYYsP4ZFc30Yku2/qAYUhOnQ1ygnvLdgNrUSJFsiDx3BtoaXDGvTBxh
         L6H1fiOt+pJJPHmD3o2+l64AcRxcLLYJPUf6UYg5x12/KkuUQlMd3yUZYoGYdO3gyA
         6334gYdJ6exUE7eiN2+x9t4BKAD4wvCxdUovmxmU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.178.44] ([95.91.192.147]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1Mq2nA-1lyQhW276o-00nCyI; Sun, 04
 Apr 2021 07:49:04 +0200
Subject: Re: [PATCH net-next v1 1/9] net: dsa: add rcv_post call back
To:     Vladimir Oltean <olteanv@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
References: <20210403114848.30528-1-o.rempel@pengutronix.de>
 <20210403114848.30528-2-o.rempel@pengutronix.de>
 <20210403140534.c4ydlgu5hqh7bmcq@skbuf>
 <20210403232116.knf6d7gdrvamk2lj@skbuf>
From:   Oleksij Rempel <linux@rempel-privat.de>
Message-ID: <14262704-5793-1483-9a6b-c6a29d88ebf7@rempel-privat.de>
Date:   Sun, 4 Apr 2021 07:49:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210403232116.knf6d7gdrvamk2lj@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rrphQ4GuPbWK1qEAlt8Q4/ess2Cx1ll+th+HTzSQPpnaLn5bLG8
 euCKHvX1TGQoJdyPkUOOMqiEUVLRsiCuvd/peQqdjCTyw4SUTNjq/vZ2WPDZbP6zUZvJSXI
 nKUJcaNbdU8NIk0QRMmQgkD9h8Le5zS6dcZXpjswcLm9k3A7PgOeAifA50N5PWji+Fhr6Wd
 EH3ilCG+8MsOBAH6Bs3vg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:NyKLKqn3L9w=:05xbTFsirzI6XGKTTFxZGF
 ZzKXxSga5UMuhIfnRPq5qCTtclOs/g0Bd86uvpcmHt/Tpz9mZLb7MipMuDjdDzNT9WuR1itZQ
 VGLnKvdGboenPshR4GY9hrJhagwtYcYpVucql8JKIiVmOl6ErWoC8EyQomlcjLAPnalasJlBp
 5GovyAoI8iO5xfTSaCorJy9Lh9SktEf7kW6vyJP9RhaYa5m3Wlq+7YEOlhB+9Oo8BssK3YWH+
 WHZGyKMk77ODGj4IGrC8lR36DHYtvOwmFE3VsIcAVHW5e/Gtggn8D7X5mcbLhIg1ui1j5Gu4/
 QhF3Gta+UVCaz7sKuEYgPuifQ+AZXoH/uTF1x9phpX0mt2bCrrHiecyNrswIWoQ1V6n5nrZIW
 bMSTpN3jKziUE83KTPMFoxY1ovPRFaJDTAGLlUf6t3pwDRiUO8kVWZDbVysxTcMlVtXZn3XO+
 i0gaop93zANtEaFGaWh2dmfT5TlQR0Mf1A8n0VXxCH2/QIwpF0O3yhXJ8Ihxqlc8W74P073eG
 tRthwvIuTNaABC3OmrPNwdZD22EI5lG8bmkwQFinSEa6S9rsyupfGhcjBiMD4aMwZiV5fg+1C
 n0frJvCiEwJ6itJYttzbjhcOXyGiH/NxGxNWwzOwDMW95PDyvyYOR3uHSr1I+5sogg/NChd11
 UYhHPkIWruthVufSw7SabYIN7HfrukVWZipqFCGt/cBa5xgAN4N+NBZc5BqXeYVnOgyIWgm/V
 vh+KaD6kBKLtFCHKU8Ro2lT0Rs+exvqDu5PWNZQKl0Umod1znlT3fLrqvVd+4s3xQjtGNkIB/
 LHr5eGi3YjHCfZoxL7fAoNblY3hG80HzPU7fHrJZF2znEOKpF2oP/GXhdkGPMdHE3jZ+zlaFj
 28oaoJQKrgq91NlKqCv7FPpS4NFvaQ+SRmvHvUGRg6Y8ZRdPLcNlgw3+J/o6LkdBrlp3zAKXu
 FuHJ0oQGGuu0Ng0EriUBsPW/tuyi+yOL3tfSoELQ2WRnHxr90taY/rWF2jxnigNuJJcuh+Oiu
 QJFY0+Btsg6gFhIoJ4O4yfPYUDP2lL/KoPobdDOvkuo2NO/sjyZK1I4lZfrlDv/QICoY2Y1cM
 KxE5wIUjXjPqNnqYn3YYeBFI9iWILcKBGNxiq7FfAYTE7ePAfr3bBlRWXKSn55PlNftJUPBZX
 Og9YW6pbGLikhTVOvcYjtoVH7EZqt+vAgskjZ6ovgfaBYjvdDvUJWvCfW974aRaPqs1wzX1qu
 rLh7JDOkPE3BHkfWN
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 04.04.21 um 01:21 schrieb Vladimir Oltean:
> On Sat, Apr 03, 2021 at 05:05:34PM +0300, Vladimir Oltean wrote:
>> On Sat, Apr 03, 2021 at 01:48:40PM +0200, Oleksij Rempel wrote:
>>> Some switches (for example ar9331) do not provide enough information
>>> about forwarded packets. If the switch decision was made based on IPv4
>>> or IPv6 header, we need to analyze it and set proper flag.
>>>
>>> Potentially we can do it in existing rcv path, on other hand we can
>>> avoid part of duplicated work and let the dsa framework set skb header
>>> pointers and then use preprocessed skb one step later withing the rcv_=
post
>>> call back.
>>>
>>> This patch is needed for ar9331 switch.
>>>
>>> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
>>> ---
>>
>> I don't necessarily disagree with this, perhaps we can even move
>> Florian's dsa_untag_bridge_pvid() call inside a rcv_post() method
>> implemented by the DSA_TAG_PROTO_BRCM_LEGACY, DSA_TAG_PROTO_BRCM_PREPEN=
D
>> and DSA_TAG_PROTO_BRCM taggers. Or even better, because Oleksij's
>> rcv_post is already prototype-compatible with dsa_untag_bridge_pvid, we
>> can already do:
>>
>> 	.rcv_post =3D dsa_untag_bridge_pvid,
>>
>> This should be generally useful for stuff that DSA taggers need to do
>> which is easiest done after eth_type_trans() was called.
>
> I had some fun with an alternative method of parsing the frame for IGMP
> so that you can clear skb->offload_fwd_mark, which doesn't rely on the
> introduction of a new method in DSA. It should also have several other
> advantages compared to your solution such as the fact that it should
> work with VLAN-tagged packets.
>
> Background: we made Receive Packet Steering work on DSA master interface=
s
> (echo 3 > /sys/class/net/eth0/queues/rx-1/rps_cpus) even when the DSA
> tag shifts to the right the IP headers and everything that comes
> afterwards. The flow dissector had to be patched for that, just grep for
> DSA in net/core/flow_dissector.c.
>
> The problem you're facing is that you can't parse the IP and IGMP
> headers in the tagger's rcv() method, since the network header,
> transport header offsets and skb->protocol are all messed up, since
> eth_type_trans hasn't been called yet.
>
> And that's the trick right there, you're between a rock and a hard
> place: too early because eth_type_trans wasn't called yet, and too late
> because skb->dev was changed and no longer points to the DSA master, so
> the flow dissector adjustment we made doesn't apply.
>
> But if you call the flow dissector _before_ you call "skb->dev =3D
> dsa_master_find_slave" (and yes, while the DSA tag is still there), then
> it's virtually as if you had called that while the skb belonged to the
> DSA master, so it should work with __skb_flow_dissect.
>
> In fact I prototyped this idea below. I wanted to check whether I can
> match something as fine-grained as an IGMPv2 Membership Report message,
> and I could.
>
> I prototyped it inside the ocelot tagging protocol driver because that's
> what I had handy. I used __skb_flow_dissect with my own flow dissector
> which had to be initialized at the tagger module_init time, even though
> I think I could have probably just called skb_flow_dissect_flow_keys
> with a standard dissector, and that would have removed the need for the
> custom module_init in tag_ocelot.c. One thing that is interesting is
> that I had to add the bits for IGMP parsing to the flow dissector
> myself (based on the existing ICMP code). I was too lazy to do that for
> MLD as well, but it is really not hard. Or even better, if you don't
> need to look at all inside the IGMP/MLD header, I think you can even
> omit adding this parsing code to the flow dissector and just look at
> basic.n_proto and basic.ip_proto.
>
> See the snippet below. Hope it helps.
>
> -----------------------------[ cut here ]-----------------------------
> diff --git a/include/net/flow_dissector.h b/include/net/flow_dissector.h
> index ffd386ea0dbb..4c25fa47637a 100644
> --- a/include/net/flow_dissector.h
> +++ b/include/net/flow_dissector.h
> @@ -190,6 +190,20 @@ struct flow_dissector_key_icmp {
>  	u16 id;
>  };
>
> +/**
> + * flow_dissector_key_igmp:
> + *		type: indicates the message type, see include/uapi/linux/igmp.h
> + *		code: Max Resp Code, the maximum time in 1/10 second
> + *		      increments before sending a responding report
> + *		group: the multicast address being queried when sending a
> + *		       Group-Specific or Group-and-Source-Specific Query.
> + */
> +struct flow_dissector_key_igmp {
> +	u8 type;
> +	u8 code; /* Max Resp Time in IGMPv2 */
> +	__be32 group;
> +};
> +
>  /**
>   * struct flow_dissector_key_eth_addrs:
>   * @src: source Ethernet address
> @@ -259,6 +273,7 @@ enum flow_dissector_key_id {
>  	FLOW_DISSECTOR_KEY_PORTS, /* struct flow_dissector_key_ports */
>  	FLOW_DISSECTOR_KEY_PORTS_RANGE, /* struct flow_dissector_key_ports */
>  	FLOW_DISSECTOR_KEY_ICMP, /* struct flow_dissector_key_icmp */
> +	FLOW_DISSECTOR_KEY_IGMP, /* struct flow_dissector_key_igmp */
>  	FLOW_DISSECTOR_KEY_ETH_ADDRS, /* struct flow_dissector_key_eth_addrs *=
/
>  	FLOW_DISSECTOR_KEY_TIPC, /* struct flow_dissector_key_tipc */
>  	FLOW_DISSECTOR_KEY_ARP, /* struct flow_dissector_key_arp */
> @@ -314,6 +329,7 @@ struct flow_keys {
>  	struct flow_dissector_key_keyid keyid;
>  	struct flow_dissector_key_ports ports;
>  	struct flow_dissector_key_icmp icmp;
> +	struct flow_dissector_key_igmp igmp;
>  	/* 'addrs' must be the last member */
>  	struct flow_dissector_key_addrs addrs;
>  };
> diff --git a/net/core/flow_dissector.c b/net/core/flow_dissector.c
> index 5985029e43d4..8cc8c34ea5cd 100644
> --- a/net/core/flow_dissector.c
> +++ b/net/core/flow_dissector.c
> @@ -202,6 +202,30 @@ static void __skb_flow_dissect_icmp(const struct sk=
_buff *skb,
>  	skb_flow_get_icmp_tci(skb, key_icmp, data, thoff, hlen);
>  }
>
> +static void __skb_flow_dissect_igmp(const struct sk_buff *skb,
> +				    struct flow_dissector *flow_dissector,
> +				    void *target_container, const void *data,
> +				    int thoff, int hlen)
> +{
> +	struct flow_dissector_key_igmp *key_igmp;
> +	struct igmphdr *ih, _ih;
> +
> +	if (!dissector_uses_key(flow_dissector, FLOW_DISSECTOR_KEY_IGMP))
> +		return;
> +
> +	ih =3D __skb_header_pointer(skb, thoff, sizeof(_ih), data, hlen, &_ih)=
;
> +	if (!ih)
> +		return;
> +
> +	key_igmp =3D skb_flow_dissector_target(flow_dissector,
> +					     FLOW_DISSECTOR_KEY_IGMP,
> +					     target_container);
> +
> +	key_igmp->type =3D ih->type;
> +	key_igmp->code =3D ih->code;
> +	key_igmp->group =3D ih->group;
> +}
> +
>  void skb_flow_dissect_meta(const struct sk_buff *skb,
>  			   struct flow_dissector *flow_dissector,
>  			   void *target_container)
> @@ -1398,6 +1422,11 @@ bool __skb_flow_dissect(const struct net *net,
>  					data, nhoff, hlen);
>  		break;
>
> +	case IPPROTO_IGMP:
> +		__skb_flow_dissect_igmp(skb, flow_dissector, target_container,
> +					data, nhoff, hlen);
> +		break;
> +
>  	default:
>  		break;
>  	}
> diff --git a/net/dsa/tag_ocelot.c b/net/dsa/tag_ocelot.c
> index f9df9cac81c5..a2cc824ddeec 100644
> --- a/net/dsa/tag_ocelot.c
> +++ b/net/dsa/tag_ocelot.c
> @@ -2,9 +2,51 @@
>  /* Copyright 2019 NXP Semiconductors
>   */
>  #include <linux/dsa/ocelot.h>
> +#include <linux/igmp.h>
>  #include <soc/mscc/ocelot.h>
>  #include "dsa_priv.h"
>
> +static const struct flow_dissector_key ocelot_flow_keys[] =3D {
> +	{
> +		.key_id =3D FLOW_DISSECTOR_KEY_CONTROL,
> +		.offset =3D offsetof(struct flow_keys, control),
> +	},
> +	{
> +		.key_id =3D FLOW_DISSECTOR_KEY_BASIC,
> +		.offset =3D offsetof(struct flow_keys, basic),
> +	},
> +	{
> +		.key_id =3D FLOW_DISSECTOR_KEY_IGMP,
> +		.offset =3D offsetof(struct flow_keys, igmp),
> +	},
> +};
> +
> +static struct flow_dissector ocelot_flow_dissector __read_mostly;
> +
> +static struct sk_buff *ocelot_drop_igmp(struct sk_buff *skb)
> +{
> +	struct flow_keys fk;
> +
> +	memset(&fk, 0, sizeof(fk));
> +
> +	if (!__skb_flow_dissect(NULL, skb, &ocelot_flow_dissector,
> +				&fk, NULL, 0, 0, 0, 0))
> +		return skb;
> +
> +	if (fk.basic.n_proto !=3D htons(ETH_P_IP))
> +		return skb;
> +
> +	if (fk.basic.ip_proto !=3D IPPROTO_IGMP)
> +		return skb;
> +
> +	if (fk.igmp.type !=3D IGMPV2_HOST_MEMBERSHIP_REPORT)
> +		return skb;
> +
> +	skb_dump(KERN_ERR, skb, true);
> +
> +	return NULL;
> +}
> +
>  static void ocelot_xmit_ptp(struct dsa_port *dp, void *injection,
>  			    struct sk_buff *clone)
>  {
> @@ -84,6 +126,10 @@ static struct sk_buff *ocelot_rcv(struct sk_buff *sk=
b,
>  	u8 *extraction;
>  	u16 vlan_tpid;
>
> +	skb =3D ocelot_drop_igmp(skb);
> +	if (!skb)
> +		return NULL;

I probably like this idea, but i need more understanding :)

In case of ocelot_drop_igmp() you wont to really drop it? Or it is just
example on how it may potentially work?
I ask, because IGMP should not be dropped.

=2D-
Regards,
Oleksij
