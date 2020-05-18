Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 457181D7172
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 09:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgERHBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 03:01:47 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:44177 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726803AbgERHBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 03:01:47 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 441742312;
        Mon, 18 May 2020 03:01:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 May 2020 03:01:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=D79LSw
        VO50RGw1DQqJ9lh6dg7KElIolVdAlwtqzVLus=; b=cOWk8BdlCNrX6QLFJtgqgs
        NEKl/wd5IU1RcCMH3Y7/WxOEY2vvVbp41l9r94VXJSYcpxCZOQRWzBozqXbCph8/
        AYUzVHwQxj6a/uDM/L1K0d4nLLPc6//TK6DXe2hYCrPVjvLbVn7WCdRwpjQQMCHW
        rx31Q5YAeNK2tfEf9IjiSrmZqzKLCnMWXlDsBVrOtZaoPIHMaKPVD7Tm+li5cywY
        mgw8GiM/YXav5EuDEtUEhpAnA4juzvGolcOmQSxF4L0vUPyk9cssaev1ThRIfIRj
        8+IzwFiyHpiHhqV6cj6a34uOGXGp1JMKVsrK3x1ghLj838WDgj0FaqF9Yliz47+w
        ==
X-ME-Sender: <xms:2DLCXkE9CKoNGQ7DgdQKfdMDXNiy3LAhcCTdIVBXqrI3xP6vjuaZnQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtgedgudduvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpefhgfdvgfdvhedtfedtledtkefhff
    ehieeutddvheehgfefueffgeevuedviefgveenucffohhmrghinhepfihikhhiphgvughi
    rgdrohhrghenucfkphepjeelrddujeeirddvgedruddtjeenucevlhhushhtvghrufhiii
    gvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdho
    rhhg
X-ME-Proxy: <xmx:2DLCXtWWbOoPTMyfZ5ahQIeQ6J5kvyPtIwaDRZ4Af9h7WGf-HEU9nA>
    <xmx:2DLCXuLuexnlG9SSMUp4rIvPh01nIDTNKQB5XiySSsFOKOLgtjOXng>
    <xmx:2DLCXmEun6srIQdw4yPe70pDcVIZwhbXtC4cp-b-g4s6BzC8OVRneA>
    <xmx:2TLCXozIQhwuJ5TshHXqc1tFjuJEhcH21yElzhXzAcaAJ5I2wl-GRg>
Received: from localhost (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B57CB30663E5;
        Mon, 18 May 2020 03:01:43 -0400 (EDT)
Date:   Mon, 18 May 2020 10:01:36 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Huang Qijun <dknightjun@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, ap420073@gmail.com,
        tglx@linutronix.de, gregkh@linuxfoundation.org,
        allison@lohutok.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vlan: fix the bug that cannot create vlan4095
Message-ID: <20200518070136.GA944082@splinter>
References: <20200518052755.27467-1-dknightjun@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200518052755.27467-1-dknightjun@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 01:27:55PM +0800, Huang Qijun wrote:
> According to the 8021q standard, the VLAN id range is 1 to 4095.

No, on IEEE8021VlanIndex the standard says:

"A value used to index per-VLAN tables: values of 0 and 4095 are not
permitted. If the value is between 1 and 4094 inclusive, it represents
an IEEE 802.1Q VLAN-ID with global scope within a given bridged domain
(see VlanId textual convention). If the value is greater than 4095, then
it represents a VLAN with scope local to the particular agent, i.e., one
without a global VLAN-ID assigned to it. Such VLANs are outside the
scope of IEEE 802.1Q, but it is convenient to be able to manage them"

From Wikipedia as well:

"A 12-bit field specifying the VLAN to which the frame belongs. The
hexadecimal values of 0x000 and 0xFFF are reserved. All other values may
be used as VLAN identifiers, allowing up to 4,094 VLANs. [...] The VID
value 0xFFF is reserved for implementation use; it must not be
configured or transmitted. 0xFFF can be used to indicate a wildcard
match in management operations or filtering database entries."

https://en.wikipedia.org/wiki/IEEE_802.1Q

> But in the register_vlan_device function, the range is 1 to 4094,
> because ">= VLAN_VID_MASK" is used to determine whether the id
> is illegal. This will prevent the creation of the vlan4095 interface:
>     $ vconfig add sit0 4095
>     vconfig: ioctl error for add: Numerical result out of range
> 
> To fix this error, this patch uses ">= VLAN_N_VID" instead to
> determine if the id is illegal.
> 
> Signed-off-by: Huang Qijun <dknightjun@gmail.com>
> ---
>  net/8021q/vlan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
> index d4bcfd8f95bf..5de7861ddf64 100644
> --- a/net/8021q/vlan.c
> +++ b/net/8021q/vlan.c
> @@ -219,7 +219,7 @@ static int register_vlan_device(struct net_device *real_dev, u16 vlan_id)
>  	char name[IFNAMSIZ];
>  	int err;
>  
> -	if (vlan_id >= VLAN_VID_MASK)
> +	if (vlan_id >= VLAN_N_VID)
>  		return -ERANGE;
>  
>  	err = vlan_check_real_dev(real_dev, htons(ETH_P_8021Q), vlan_id,
> -- 
> 2.17.1
> 
