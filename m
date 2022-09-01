Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4E465A8E39
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 08:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232932AbiIAGVk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 02:21:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232114AbiIAGVj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 02:21:39 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A8A11AFB5
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 23:21:37 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1662013295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9HrGMhU7g+wyC1zv5jH2PvVonZLyp5e1izrSK23qAM=;
        b=bR4rgt+o4Qg2KCBoLExMvdVPnU4sD6lZffHheqEcP4HqtexU5yCkyLPEOh5w0bSKCubLwL
        lYfe4k//W9cnWN2troDLkImF4jYfRcSsSLYmC2A6j7d0pMryQEXYyRZHK7AS6aF8vY6gBF
        Od5i1dELnwoAMrxr68iXdl6Kp6+O6KvYs8SbRRoOdKyvn0l5MZ41aHtBhCtafYJIJCAj9A
        UVRkkmiKNDsa+WSrVfZrtEBr9J55raONWvCBcRbbL8jotDU/l1zkUOL+A5FGZ7T1eN4NH6
        0274azy4Pjy4PvXKwq/jUD/nnT6XFwXBjtF9EdZsDvsJFemVH7UJAAMBNXD8mA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1662013295;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=u9HrGMhU7g+wyC1zv5jH2PvVonZLyp5e1izrSK23qAM=;
        b=bdcuUR3o+0KLv4bKMDk5lFbMOs1HcgTEdGUVYPuq+SL17DdEjq1u5DYfrXU2tRMjVhCZpm
        nR1bwLT6S1sO3+CA==
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Print warning only once
In-Reply-To: <20220831234329.w7wnxy4u3e5i6ydl@skbuf>
References: <20220830163448.8921-1-kurt@linutronix.de>
 <20220831152628.um4ktfj4upcz7zwq@skbuf> <87v8q8jjgh.fsf@kurt>
 <20220831234329.w7wnxy4u3e5i6ydl@skbuf>
Date:   Thu, 01 Sep 2022 08:21:33 +0200
Message-ID: <87czcfzkb6.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu Sep 01 2022, Vladimir Oltean wrote:
> On Wed, Aug 31, 2022 at 09:34:22PM +0200, Kurt Kanzenbach wrote:
>> I've plugged my hellcreek test device into a Cisco switch and saw these
>> messages flying by. It said it failed to get source port 0 at a constant
>> rate. Turns out the Cisco switch does RSTP by default. Every STP frame
>> received has source port 0 which doesn't make any sense. The switch adds
>> a tail tag to every frame towards the CPU. All STP frames have their
>> tail tag not really at the end of the frame. It's off by exactly four
>> bytes. So, maybe it's the FCS.
>
> Hmm, I'm not sure I'm awake enough to be looking at this. So AFAIU, some
> DWMAC versions can be configured to strip the padding and FCS from
> "Length" frames (EtherType <=3D 0x600) via the ACS bit in the MAC
> configuration register, and some others can also be configured to strip
> the FCS from "Type" frames (EtherType > 0x800) via the CST bit of the
> same register. Ok, I'll go with that, although I'm confused as to why
> some DWMACs would have ACS but not CST available.
>
> The stmmac driver does not support NETIF_F_RXFCS, so it wants frames
> passed up the stack to never have the FCS. That is good. Except that the
> frames passed via the RX buffer descriptors may sometimes have RX FCS,
> and sometimes may not.
>
> This means that the driver needs to make a determination of whether the
> hardware has already stripped the FCS or not, before attempting to strip
> the FCS by itself.
>
> So we may have:
>
> (a) FCS stripped by HW, left alone by SW =3D> frame looks ok
> (b) FCS stripped by HW and also by SW =3D> frame is truncated by 4 bytes
> (c) FCS left alone by HW, left alone by SW =3D> frame has 4 bytes too man=
y (the FCS)
> (d) FCS left alone by HW, stripped by SW =3D> frame looks ok
>
> It seems from what you're saying that you're under circumstance (c).

Yes, exactly.

>
>> The DSA master is a older stmmac. It has this code here:
>>=20
>> |drivers/net/ethernet/stmicro/stmmac/dwmac1000_core.c
>> |	/* Clear ACS bit because Ethernet switch tagging formats such as
>> |	 * Broadcom tags can look like invalid LLC/SNAP packets and cause the
>> |	 * hardware to truncate packets on reception.
>> |	 */
>> |	if (netdev_uses_dsa(dev) || !priv->plat->enh_desc)
>> |		value &=3D ~GMAC_CONTROL_ACS;
>> |
>>=20
>> Actually, this has to be done. Without disabling the ACS bit the STP
>> frames are truncated and the trailer tag is gone.
>
> So from Florian's comment above, he was under case (b), different than yo=
urs.
> I don't understand why you say that when ACS is set, "the STP frames are
> truncated and the trailer tag is gone". Simply altering the ACS bit
> isn't going to change the determination made by stmmac_rx(). My guess
> based on the current input I have is that it would work fine for you
> (but possibly not for Florian).

I thought so too. However, altering the ACS Bit didn't help at all.

>
>> Then, there is
>>=20
>> |drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> |		/* ACS is set; GMAC core strips PAD/FCS for IEEE 802.3
>> |		 * Type frames (LLC/LLC-SNAP)
>> |		 *
>> |		 * llc_snap is never checked in GMAC >=3D 4, so this ACS
>> |		 * feature is always disabled and packets need to be
>> |		 * stripped manually.
>> |		 */
>> |		if (likely(!(status & rx_not_ls)) &&
>> |		    (likely(priv->synopsys_id >=3D DWMAC_CORE_4_00) ||
>> |		     unlikely(status !=3D llc_snap))) {
>> |			if (buf2_len)
>> |				buf2_len -=3D ETH_FCS_LEN;
>> |			else
>> |				buf1_len -=3D ETH_FCS_LEN;
>> |
>> |			len -=3D ETH_FCS_LEN;
>> |		}
>>=20
>> Great. Unfortunately the stmmac used here is a dwmac-3.70. So, the FCS
>> doesn't seem to be stripped for the STP frames.
>
> Yes, neither by hardware nor by software.
>
> It isn't stripped by hardware due to the ACS setting. And it isn't
> stripped by software because, although the synopsys_id is smaller than 4.=
00,
> there's only a single stmmac_desc_ops :: rx_status implementation which
> will ever return "llc_snap" as parse result for a frame, and that isn't
> yours.
>
>> Now, I'm currently testing the patch below and it seems to work:
>>=20
>> |root@tsn:~# dmesg | grep -i 'Failed to get source port'
>> |root@tsn:~# tcpdump -i lan0 stp
>> |tcpdump: verbose output suppressed, use -v[v]... for full protocol deco=
de
>> |listening on lan0, link-type EN10MB (Ethernet), snapshot length 262144 =
bytes
>> |19:25:17.031699 STP 802.1w, Rapid STP, Flags [Learn, Forward, Agreement=
], bridge-id 8000.2c:1a:05:28:06:c1.8006, length 36
>>=20
>> Thanks,
>> Kurt
>>=20
>> Patch:
>>=20
>> diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers=
/net/ethernet/stmicro/stmmac/stmmac_main.c
>> index 9c1e19ea6fcd..74f348e27005 100644
>> --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>> @@ -41,6 +41,7 @@
>>  #include <linux/bpf_trace.h>
>>  #include <net/pkt_cls.h>
>>  #include <net/xdp_sock_drv.h>
>> +#include <net/dsa.h>
>>  #include "stmmac_ptp.h"
>>  #include "stmmac.h"
>>  #include "stmmac_xdp.h"
>> @@ -5209,6 +5210,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int=
 limit, u32 queue)
>>                  */
>>                 if (likely(!(status & rx_not_ls)) &&
>>                     (likely(priv->synopsys_id >=3D DWMAC_CORE_4_00) ||
>> +                    unlikely(netdev_uses_dsa(priv->dev)) ||
>
> This change forces FCS stripping in software for all DWMACs used as DSA
> masters.
>
> Florian solved his problem by moving from case (b) to (d), so the change
> should continue to work for him as well.
>
>>                      unlikely(status !=3D llc_snap))) {
>>                         if (buf2_len)
>>                                 buf2_len -=3D ETH_FCS_LEN;
>
> My 2 cents on this topic are:
>
> 1. The software determination is way too complicated and hard to reason
>    about, there are too many tests in the fast path, and you are adding
>    one more (actually two, if you look at the implementation of netdev_us=
es_dsa).

Yes, exactly. That's why I dislike the extra check.

>    Additionally, someone will probably need to modify the zerocopy rx
>    procedure as well, in a not so distant future.

Yes, i know.

>    It must be taken into consideration how much worse would the
>    performance be if the driver would just configure the hardware to
>    never selectively strip the FCS (i.e. for some packets but not all;
>    in practice this means never strip the FCS. Ideally it would
>    *always* strip the FCS, but I'm not sure whether this is possible
>    with other hardware pre-4.0).  Considering that for the common case
>    of IP traffic the FCS is already stripped in software, I think
>    there will be a net gain by simplifying stmmac_rx() and leaving
>    just the "BD really is last" check.

I was thinking exactly the same. The FCS strip determination logic seems
complicated and is performed in the fast path.

From=20what I see, the stmmac strips the FCS in hardware only for IEEE
802.3 type frames and older versions. Meaning in most cases today the
FCS is stripped in software anyway.

We could do some measurements e.g., with perf to determine whether
removing the FCS logic has positive or negative effects?

>
> 2. The FCS stripping logic actually looks wrong to me.
>
> 			if (buf2_len) {
> 				buf2_len -=3D ETH_FCS_LEN;
> 				len -=3D ETH_FCS_LEN;
> 			} else if (buf1_len) {
> 				buf1_len -=3D ETH_FCS_LEN;
> 				len -=3D ETH_FCS_LEN;
> 			}
>
>    The "if (x !=3D 0) x -=3D 4" idiom seems classically wrong, in that x =
may
>    still be < 4, and this will result in a negative buf2_len, or buf1_len.
>
>    Applied to reality, this would mean a scatter/gather frame where the F=
CS
>    is split between 2 buffers. I don't think the driver handles this case
>    well at all.

Oh, well.

>
> How large can you configure the hellcreek switch to send packets towards
> the DSA master? Could you force a packet size (including hellcreek tail t=
ag)
> comparable to dma_conf->dma_buf_sz?

I don't think so.

> Or if not, perhaps you could hack the way in which stmmac_set_bfsize()
> works, or one of the constants?

I'm not sure if i follow you here.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEvLm/ssjDfdPf21mSwZPR8qpGc4IFAmMQT20THGt1cnRAbGlu
dXRyb25peC5kZQAKCRDBk9HyqkZzghdCEACfMdMCQep0Fz49f8kRwZMQHPUa9Kig
WHxwLH3zvLmR6p+q7ax8nnEMSZehA0tWQksz3za2vOttNXDpvXbCG0Nmj20Gd/FE
YdHs3LFLKv4MzSgd6hXzlC+nXYbJSRCP1AIyIWHZNtmJbq4YXrr2ppdElQ1HkC5h
eyqY/kmEAG6xjcnqGU1zZrYq1NTRpEQhZ+Kxk9DZ/nH4s4GFEwOg1anfZZHPqVWM
PGL80mbVRf9CCipZbMujabsURh1507ZPg7iAYdkQhb/DxE29NOVs2BrdsJqxTWKJ
AXUihL5VROF4dYL0eA6lJ4oo8IN6d5cNRN0fwL9SuRsENwYP3GFgUbFl9f5d2tao
JsHFzgl1A6VPiOzKHygG7fH0TqNjL4Mak2Etmhy0srw1yJfMlDH7vLVA6a/OHlPY
VJo5ZQCMjzpCcqhJPcHUGJCdqO64IfwcYV/xhasv66zmfQ0gWSQdTgeV6YGiVAit
q7k/Yy9iLTQ8zmkz22d1GiX2SOLRHF/jZkogt7kfJ07ppG/BbtT0m995c7zPIjzS
w764+e3WRfxKnlbhO+wJr7BW+thT1O6TGjs3NiL5gVgw6FHZE6X31JoUVw9ET7hj
nzotMHc3ZWHZdS0ht9D8ZIM1Dr9uq8cbhPLcitUkvsVNcXhhVkmAugEWwb6bIfWy
2RHoUyFNWt6eIg==
=OS48
-----END PGP SIGNATURE-----
--=-=-=--
