Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFEA549B0CF
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 11:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbiAYJtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 04:49:10 -0500
Received: from sender4-op-o14.zoho.com ([136.143.188.14]:17479 "EHLO
        sender4-op-o14.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbiAYJo2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 04:44:28 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1643103853; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=IxNn0w/mTMWWSG0HR2/sERiSwkF4ovDqmMENhkhWrIQ3As1Gdvz86GetMPxGqUF52/y/I59rAkNV53xH6Crb9ifOrBj7riBTNoY+w1Ik4n0aAuCEjE9cfrnnVfKxncP7WGIU2qnF0ZtbRTvAN96CWJzyeBoiiqnG83+mYm7pigY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1643103853; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=OMA8ku6KdQLT1/01LbbzKfjiscVVtNA5NRLjrtLh7JE=; 
        b=cXmba6M6vTpuNZNxxrVSEJ9tYRTweTT6BCZqM8WDm7hMJFO5rI6lAQEXvG6ymE0Ry13JQ4GglQe9Fk3eBdpSTPVRSh4JezDZsbBWLB2JkuFCGspTC3QFTgl4x63cyc7o/tuoWDxVVGtX2bRA3EbxKneHrTCvrFXvDHbXYpO9/R4=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1643103853;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=OMA8ku6KdQLT1/01LbbzKfjiscVVtNA5NRLjrtLh7JE=;
        b=F6uDb911zGe722YeZ5KJNa11lYE2aeFdxwhD0csjI0s/0u6FBC81UuQtgQezwKLW
        6phZiyORPk7IrcPXlj2bdPza2g2hoebfqxFcrHURSpy/4DX0V+UUzJoP2qz/8HMtSUN
        LKGyt5bvkRkbDnZLSwjRL5ZkkkalqHOt91U5SriE=
Received: from [10.10.10.216] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 16431038508751015.7524216853523; Tue, 25 Jan 2022 01:44:10 -0800 (PST)
Message-ID: <e5f1f484-5682-6338-f974-23e77f415018@arinc9.com>
Date:   Tue, 25 Jan 2022 12:44:03 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH net-next v4 11/11] net: dsa: realtek: rtl8365mb: multiple
 cpu ports, non cpu extint
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Frank Wunderlich <frank-w@public-files.de>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <ALSI@bang-olufsen.dk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>
References: <20220124084649.0918ba5c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124165535.tksp4aayeaww7mbf@skbuf>
 <228b64d7-d3d4-c557-dba9-00f7c094f496@gmail.com>
 <20220124172158.tkbfstpwg2zp5kaq@skbuf>
 <20220124093556.50fe39a3@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124102051.7c40e015@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124190845.md3m2wzu7jx4xtpr@skbuf>
 <20220124113812.5b75eaab@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124205607.kugsccikzgmbdgmf@skbuf>
 <20220124134242.595fd728@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <20220124223053.gpeonw6f34icwsht@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220124223053.gpeonw6f34icwsht@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/01/2022 01:30, Vladimir Oltean wrote:
> On Mon, Jan 24, 2022 at 01:42:42PM -0800, Jakub Kicinski wrote:
>> On Mon, 24 Jan 2022 22:56:07 +0200 Vladimir Oltean wrote:
>>> On Mon, Jan 24, 2022 at 11:38:12AM -0800, Jakub Kicinski wrote:
>>>> On Mon, 24 Jan 2022 21:08:45 +0200 Vladimir Oltean wrote:
>>>>> So before we declare that any given Ethernet driver is buggy for declaring
>>>>> NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM and not checking that skb->csum_start
>>>>> points where it expects it to (taking into consideration potential VLAN
>>>>> headers, IPv6 extension headers),
>>>>
>>>> Extension headers are explicitly not supported by NETIF_F_IPV6_CSUM.
>>>>
>>>> IIRC Tom's hope was to delete NETIF_F_IP*_CSUM completely once all
>>>> drivers are converted to parsing and therefore can use NETIF_F_HW_CSUM.
>>>
>>> IIUC, NETIF_F_IP*_CSUM vs NETIF_F_HW_CSUM doesn't make that big of a
>>> difference in terms of what the driver should check for, if the hardware
>>> checksum offload engine can't directly be given the csum_start and
>>> csum_offset, wherever they may be.
>>>
>>>>> is there any driver that _does_ perform these checks correctly, that
>>>>> could be used as an example?
>>>>
>>>> I don't think so. Let me put it this way - my understanding is that up
>>>> until now we had been using the vlan_features, mpls_features etc to
>>>> perform L2/L2.5/below-IP feature stripping. This scales poorly to DSA
>>>> tags, as discussed in this thread.
>>>>
>>>> I'm suggesting we extend the kind of checking we already do to work
>>>> around inevitable deficiencies of device parsers for tunnels to DSA
>>>> tags.
>>>
>>> Sorry, I'm very tired and I probably don't understand what you're
>>> saying, so excuse the extra clarification questions.
>>>
>>> The typical protocol checking that drivers with NETIF_F_HW_CSUM do seems
>>> to be based on vlan_get_protocol()/skb->protocol/skb_network_header()/
>>> skb_transport_header() values, all of which make DSA invisible. So they
>>> don't work if the underlying hardware really doesn't like seeing an
>>> unexpected DSA header.
>>>
>>> When you say "I'm suggesting we extend the kind of checking we already do",
>>> do you mean we should modify the likes of e1000e and igb such that, if
>>> they're ever used as DSA masters, they do a full header parse of the
>>> packet (struct ethhdr :: h_proto, check if VLAN, struct iphdr/ipv6hdr,
>>> etc.) instead of the current logic?
>>
>> That was my thinking, yes. The exact amount of work depends on the
>> driver, I believe that more recent Intel parts (igb, ixgbe and newer)
>> pass a L3 offset to the HW. They treat L2 as opaque, ergo no patches
>> needed. At a glance e1000e passes the full skb_checksum_start_offset()
>> to HW, so likely even better.
> 
> Ah, right, I missed that. I agree that a driver that uses
> skb->csum_start is very likely to work unmodified with DSA headers
> (not trailers). I didn't notice this in e1000 because I was just
> searching for csum_start.
> 
>> It's only drivers for devices which actually want to parse the Ethertype
>> that would need extra checks. (Coincidentally such devices can't support
>> MPLS given the lack of L3 indication in the frame.)
>>
>>> It will be pretty convoluted unless
>>> we have some helper. Because if I follow through, for a DSA-tagged IP
>>> packet on xmit, skb->protocol is certainly htons(ETH_P_IP):
>>>
>>> ntohs(skb->protocol) = 0x800, csum_offset = 16, csum_start = 280, skb_checksum_start_offset = 54, skb->network_header = 260, skb_network_header_len = 20
>>>
>>> skb_dump output:
>>> skb len=94 headroom=226 headlen=94 tailroom=384
>>> mac=(226,34) net=(260,20) trans=280
>>> shinfo(txflags=0 nr_frags=0 gso(size=0 type=1 segs=1))
>>> csum(0x100118 ip_summed=3 complete_sw=0 valid=0 level=0)
>>> hash(0x7710ee84 sw=0 l4=1) proto=0x0800 pkttype=0 iif=0
>>> dev name=eno2 feat=0x00020100001149a9
>>> sk family=2 type=1 proto=6
>>> skb headroom: 00000000: 6c 00 03 02 64 65 76 00 fe ed ca fe 28 00 00 00
>>> ...(junk)...
>>> skb headroom: 000000e0: 5f 43
>>>                          20 byte DSA tag
>>>                          |
>>>                          v
>>> skb linear:   00000000: 88 80 00 0a 80 00 00 00 00 00 00 00 08 00 30 00
>>>                                      skb_mac_header()
>>>                                      |
>>>                                      v
>>> skb linear:   00000010: 00 00 00 00 68 05 ca 92 af 20 00 04 9f 05 f6 28
>>>                                skb_network_header()
>>>                                |
>>>                                v
>>> skb linear:   00000020: 08 00 45 00 00 3c 26 47 40 00 40 06 00 49 0a 00
>>>                                            skb_checksum_start_offset
>>>                                            |
>>>                                            |                       csum_offset
>>>                                            v                       v
>>> skb linear:   00000030: 00 2c 0a 00 00 01 b6 08 14 51 11 1f 91 4f 00 00
>>> skb linear:   00000040: 00 00 a0 02 fa f0 14 5b 00 00 02 04 05 b4 04 02
>>> skb linear:   00000050: 08 0a 2e 00 e5 b8 00 00 00 00 01 03 03 07
>>
>> Oof, so in this case the DSA tag is _before_ the skb_mac_header()?
>> Or the prepend is supposed to be parsable as a Ethernet header?
>> Seems like any device that can do csum over this packet must already
>> use L3/L4 offsets or have explicit knowledge of DSA, right?
> 
> I'm sorry, there's a mistake, skb_mac_header() points to the DSA tag
> here (and skb_mac_header_len is 34), I wanted to say "real MAC header"
> but failed to do so. This case shouldn't pose any special problems.
> 
>>> I don't know, I just don't expect that non-DSA users of those drivers
>>> will be very happy about such changes. Do these existing protocol
>>> checking schemes qualify as buggy?
>>
>> Unfortunate reality of the checksum offloads is that most drivers for
>> devices which parse on Tx are buggy, it's more of a question of whether
>> anyone tried to use an unsupported protocol stack :( Recent example
>> that comes to mind is 1698d600b361 ("bnxt_en: Implement
>> .ndo_features_check().").
> 
> Nice hook this ndo_features_check! In my reading of validate_xmit_skb()
> I went right past it.
> 
>>> If this is the convention that we want to enforce, then I can't really
>>> help Luiz with fixing the OpenWRT mtk_eth_soc.c - he'll have to figure
>>> out a way to parse the packets for which his hardware will accept the
>>> checksumming offload, and call skb_checksum_help() otherwise.
>>>
>>>> We can come up with various schemes of expressing capabilities
>>>> between underlying driver and tag driver. I'm not aware of similar
>>>> out-of-band schemes existing today so it'd be "DSA doing it's own
>>>> thing", which does not seem great.
>>>
>>> It at least seems less complex to me, and less checking in the fast path
>>> if I understand everything that's been said correctly.
>>
>> I understand, I'm primarily trying to share some context and prior work.
>> I don't mean to nack all other approaches.
>>
>> I believe writing a parser matching the device behavior would be easier
>> for a driver author than interpreting the runes of our csum offload API
>> and getting thru the thicket of all the bits. If that's not the case my
>> argument is likely defeated.
> 
> Ok, writing a parser might be needed if the DSA master is going, for
> some reason, to support TX checksum offloading with some DSA headers but
> not with others.
> 
> If that is not the case, and that Ethernet controller simply doesn't
> support TX checksumming unless it's the plain old Ethernet {+ VLAN} +
> IP/IPv6 + TCP/UDP, then this blanket patch below should fix the problem
> almost elegantly, and parsing is a useless complication (warning, not
> even compile-tested!):

I tried it on the upstream mtk_eth_soc on an mt7621a board with an 
rtl8367s switch connected to the 2nd GMAC of the SoC running 5.17-rc1.

Although "ethtool --show-offload eth1" does not show anything different, 
I can now ssh to the device (only way that came into my mind to quickly 
check TCP traffic).

--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -1986,6 +1986,16 @@ static int mtk_hwlro_get_fdir_all(struct
  	return 0;
  }

+static netdev_features_t fe_features_check(struct sk_buff *skb,
+					   struct net_device *dev,
+					   netdev_features_t features)
+{
+	if (netdev_uses_dsa(dev))
+		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
+
+	return features;
+}
+
  static netdev_features_t mtk_fix_features(struct net_device *dev,
  					  netdev_features_t features)
  {
@@ -2906,6 +2916,7 @@ static const struct net_device_ops mtk_n
  #ifdef CONFIG_NET_POLL_CONTROLLER
  	.ndo_poll_controller	= mtk_poll_controller,
  #endif
+	.ndo_features_check	= fe_features_check,
  	.ndo_setup_tc		= mtk_eth_setup_tc,
  };


> 
> -----------------------------[ cut here ]-----------------------------
>  From 5ef3d3cd8441d756933558212f518f48754c64d9 Mon Sep 17 00:00:00 2001
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> Date: Tue, 25 Jan 2022 00:16:57 +0200
> Subject: [PATCH] ramips: ethernet: ralink: disable TX checksumming on DSA
>   masters
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>   .../files/drivers/net/ethernet/ralink/mtk_eth_soc.c  | 12 ++++++++++++
>   1 file changed, 12 insertions(+)
> 
> diff --git a/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c b/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
> index e07e5ed5a8f8..6ed9bc5942fd 100644
> --- a/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
> +++ b/target/linux/ramips/files/drivers/net/ethernet/ralink/mtk_eth_soc.c
> @@ -31,6 +31,7 @@
>   #include <linux/io.h>
>   #include <linux/bug.h>
>   #include <linux/netfilter.h>
> +#include <net/dsa.h>
>   #include <net/netfilter/nf_flow_table.h>
>   #include <linux/of_gpio.h>
>   #include <linux/gpio.h>
> @@ -1497,6 +1498,16 @@ static int fe_change_mtu(struct net_device *dev, int new_mtu)
>   	return fe_open(dev);
>   }
>   
> +static netdev_features_t fe_features_check(struct sk_buff *skb,
> +					   struct net_device *dev,
> +					   netdev_features_t features)
> +{
> +	if (netdev_uses_dsa(dev))
> +		features &= ~(NETIF_F_CSUM_MASK | NETIF_F_GSO_MASK);
> +
> +	return features;
> +}
> +
>   static const struct net_device_ops fe_netdev_ops = {
>   	.ndo_init		= fe_init,
>   	.ndo_uninit		= fe_uninit,
> @@ -1514,6 +1525,7 @@ static const struct net_device_ops fe_netdev_ops = {
>   #ifdef CONFIG_NET_POLL_CONTROLLER
>   	.ndo_poll_controller	= fe_poll_controller,
>   #endif
> +	.ndo_features_check	= fe_features_check,
>   };
>   
>   static void fe_reset_pending(struct fe_priv *priv)
> -----------------------------[ cut here ]-----------------------------
> 
> This is essentially what Florian said ages ago, it just took me a very
> long time to process. I guess what hadn't fully clicked in my head is
> that the TX checksumming offload being functional is more a matter of
> telling the hardware what are the L3 and L4 offsets, and the csum_offset,
> rather than it requiring any particular understanding of the DSA header.
> In turn, it means that for "nice" Ethernet controller implementations
> where that is the case, it would be actively detrimential to add a new
> .ndo_get_dsa_features() or something like that - because such a driver
> would report that it supports all DSA header-type formats (trailers are
> still broken as long as there isn't a csum_end). And keeping that kind
> of driver in sync with all DSA protocols that appear will become a
> repetitive task.
> 
> So crisis averted, I guess?
> Thanks a lot to both of you for the patient explanations!
> I retract my proposal for a new ndo and also suggest that the DSA master
> driver takes care to not leave as zero a TX checksum it can't offload.
