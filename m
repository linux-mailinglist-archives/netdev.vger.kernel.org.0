Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DCF3839C0
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 18:25:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345486AbhEQQ0s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 12:26:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345345AbhEQQ0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 12:26:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99AFDC068C8D
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:00:36 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id k14so6187014eji.2
        for <netdev@vger.kernel.org>; Mon, 17 May 2021 08:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=pn/+EPQx4YWBX4D95TzzBWysPxewf5b+RmeJB4j91mw=;
        b=PBKn/Xy3D044E9PzIo/ECmHXKMJmzuz8Z4FpOzrCFrj1kB8HD17IkWMygDtbZzgOFU
         oBOYtTVjsUHcgtwIgOi0hkt/oVgJfJsy7Au/Neeg5gBmyKd/hTbOWvdb4NqXZjg4eHYc
         RoPFWop5ILbZzhmwHZi63oNknRwpYoVWPZyatNCu2mXZ88xwcouVj6zBaLqb0yX4BkbV
         zVaqtEl2vVvoIwKrA6teMVuP1z0YFJYCQQ8t3UcVxJ1HAs6pRDMlJD3srBYoafjD0l7K
         3wzB5JX2IxQK+OMra65DHbfSxZ9oGNgbb3p46BkHNLWbLo+t3bmn+jWVa0GuIe19npMW
         auxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pn/+EPQx4YWBX4D95TzzBWysPxewf5b+RmeJB4j91mw=;
        b=sRzLhTQdiCgq+UUJ1amPelbRWicOBNNebR9U5HopPUXJ8pBPUxe6MUQe6dLzxE+ox9
         5mD1xgsA1ZEqxbTBlUlnlCzB65VBTlU/r5herDO7f7ltJ0xbVivFmPLuUNNXpejbv1Ks
         l6r4NrGSZz5ZjALjxkSCU83J/Otgxg8zzGU4WzK6xGdPqzOZePwnLlhFkhPH+kOulVik
         QjQRHJV2d3vhzs0PvCWEqO4iS5JWcRAUYyIznTlSSjCDlRvYqCrjk2jwmyS+b/jJC0cf
         UFtS/o6MVA1QKGF4UQRnVjkAWUgx73rO1F5Il9xCA+KIJYoBVf0j64bclwgq/e6Cfe0f
         ytWw==
X-Gm-Message-State: AOAM533iJ7sYyki4ULNyNutHCEVjuFW8RER2G/rxChxnfKzKns3CNQ/Q
        0DF1WUfX73W604MCma7WWfEzp1cN6Zo=
X-Google-Smtp-Source: ABdhPJxnwHPkUGA2lIGediv2AruWPU1VDf7EvZ2bJwnUCqDGPDlEXFGzpcDynrMFuNot6qk3jXLh7Q==
X-Received: by 2002:a17:906:fc1e:: with SMTP id ov30mr326042ejb.526.1621263633001;
        Mon, 17 May 2021 08:00:33 -0700 (PDT)
Received: from skbuf ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id q16sm8696614ejm.12.2021.05.17.08.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 08:00:32 -0700 (PDT)
Date:   Mon, 17 May 2021 18:00:31 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Eldar Gasanov <eldargasanov2@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] mv88e6xxx: fixed adding vlan 0
Message-ID: <20210517150031.bjdmls4kokjo6quf@skbuf>
References: <20210517062506.5045-1-eldargasanov2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517062506.5045-1-eldargasanov2@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eldar,

On Mon, May 17, 2021 at 09:25:06AM +0300, Eldar Gasanov wrote:
> 8021q module adds vlan 0 to all interfaces when it starts.
> When 8021q module is loaded it isn't possible to create bond
> with mv88e6xxx interfaces, bonding module dipslay error
> "Couldn't add bond vlan ids", because it tries to add vlan 0
> to slave interfaces.
> 
> Signed-off-by: Eldar Gasanov <eldargasanov2@gmail.com>
> ---
>  drivers/net/dsa/mv88e6xxx/chip.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
> index eca285aaf72f..961fa6b75cad 100644
> --- a/drivers/net/dsa/mv88e6xxx/chip.c
> +++ b/drivers/net/dsa/mv88e6xxx/chip.c
> @@ -1618,9 +1618,6 @@ static int mv88e6xxx_port_check_hw_vlan(struct dsa_switch *ds, int port,
>  	struct mv88e6xxx_vtu_entry vlan;
>  	int i, err;
>  
> -	if (!vid)
> -		return -EOPNOTSUPP;
> -
>  	/* DSA and CPU ports have to be members of multiple vlans */
>  	if (dsa_is_dsa_port(ds, port) || dsa_is_cpu_port(ds, port))
>  		return 0;
> @@ -2109,6 +2106,9 @@ static int mv88e6xxx_port_vlan_add(struct dsa_switch *ds, int port,
>  	u8 member;
>  	int err;
>  
> +	if (!vlan->vid)
> +		return 0;
> +
>  	err = mv88e6xxx_port_vlan_prepare(ds, port, vlan);
>  	if (err)
>  		return err;
> -- 
> 2.25.1
> 

Thank you for your patch.

The reason why the 8021q module adds VLAN 0 to the hardware filtering
list of the network device is to ensure that 802.1p-tagged packets are
always received and treated as untagged, while on the other hand
preserving their VLAN ID of 0.

This is described in commit ad1afb003939 ("vlan_dev: VLAN 0 should be
treated as "no vlan tag" (802.1p packet)").

When we look at vlan_device_event(), we see that vlan_vid_add() is
called without checking the error code. So when mv88e6xxx returns
-EOPNOTSUPP, the code carries along.

I spot an inconsistency within the 8021q module, because
vlan_vids_add_by_dev() then checks the return code of vlan_vid_add(),
resulting in the problem you are trying to fix here. I think it would be
more self-consistent if vlan_vids_add_by_dev() would propagate the error
only if vid is != 0.

It can be said that the bug you are fixing is a regression introduced by
my commit 9b236d2a69da ("net: dsa: Advertise the VLAN offload netdev
ability only if switch supports it"). Tobias too tried to fix it here:
https://patchwork.kernel.org/project/netdevbpf/cover/20210308150405.3694678-1-tobias@waldekranz.com/

However that is not the central point. Ignoring the errors operates in
the good faith that the real_dev driver knows what it's doing, and
satisfies the requirements of commit ad1afb003939 mentioned above. This
is user-visible behavior, so it should better be compliant. And this is
where I am not 100% clear on what is going on.

The mv88e6xxx driver can refuse the configuration of VLAN ID 0 if it
does the right thing and we can make either the mv88e6xxx layer, or the
DSA layer (Tobias's patch) or the 8021q layer ignore that error code.
But I would like to make sure that in either case, a packet with VID 0
received by the mv88e6xxx ports will still contain VID 0, in the
following situations:

- The port is standalone
- The port is under a VLAN-unaware bridge
- The port is under a VLAN-aware bridge

I happen to have a mv88e6xxx testing device, and what I see is not
exactly that. In the first two cases, we are ok, but when the port is
under a VLAN-aware bridge, the packets are received as PVID-tagged:

# ip link add br0 type bridge vlan_filtering 1
# ip link set lan24 master br0
# bridge vlan add dev lan24 vid 34 pvid untagged
# tcpdump -i lan24 -e -n
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on lan24, link-type EN10MB (Ethernet), capture size 262144 bytes
17:32:29.896736 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 a9a7 d040  ...............@
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0001  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.898292 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 a9b7 1280  ................
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0002  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.898713 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 a9c6 54c0  ..............T.
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0003  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.899674 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 a9d5 9700  ................
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0004  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.902377 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 a9e4 d940  ...............@
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0005  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.904425 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 a9f4 1b80  ................
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0006  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.905049 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 aa03 5dc0  ..............].
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0007  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.906571 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 aa12 a000  ................
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0008  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.907048 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 aa21 e240  .............!.@
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0009  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:32:29.907575 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 34, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2ef4 aa31 2480  .............1$.
        0x0010:  0000 0000 0000 0000 0000 0000 0000 000a  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
# ip link set br0 type bridge vlan_filtering 0
# tcpdump -i lan24 -e -n
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on lan24, link-type EN10MB (Ethernet), capture size 262144 bytes
17:34:39.884637 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee42 6440  ........../..Bd@
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0001  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.885968 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee51 a680  ........../..Q..
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0002  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.886179 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee60 e8c0  ........../..`..
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0003  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.886559 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee70 2b00  ........../..p+.
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0004  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.887116 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee7f 6d40  ........../...m@
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0005  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.888090 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee8e af80  ........../.....
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0006  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.890813 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 ee9d f1c0  ........../.....
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0007  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.892526 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 eead 3400  ........../...4.
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0008  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.893230 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 eebc 7640  ........../...v@
        0x0010:  0000 0000 0000 0000 0000 0000 0000 0009  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............
17:34:39.895026 00:1f:7b:63:02:08 > d8:58:d7:00:ca:6d, ethertype 802.1Q (0x8100), length 64: vlan 0, p 0, ethertype 0x88f7,
        0x0000:  0402 0000 0000 0000 15f1 2f12 eecb b880  ........../.....
        0x0010:  0000 0000 0000 0000 0000 0000 0000 000a  ................
        0x0020:  0000 dead beef dead beef dead beef       ..............

The packets that were sent to the switch were the same in both cases.

Strange, huh?

There must be some VLAN retagging going on in the switch between VLAN ID
0 and the port's PVID, but I can't find it.
