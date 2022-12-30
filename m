Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C0E86599BF
	for <lists+netdev@lfdr.de>; Fri, 30 Dec 2022 16:33:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235171AbiL3Pdu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Dec 2022 10:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbiL3Pdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Dec 2022 10:33:47 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980DF1B1F7;
        Fri, 30 Dec 2022 07:33:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1672414384;
        bh=QZE1xIk/afkLkABE1owXrClFFZNx+podxLmjY101Hfk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=eNpLyuzVNMFXZMewJo8kzGCwOGNZvNglAloAWOco3CBBzSPZZztz+c61Ds8igR8cu
         MMwsZFQ0NBvivkqTzJcBr2pSZEK5HSVsRETf7n8NSYI7BZLCeSdowIwagcNgfINKLO
         mXcChc8mWMO1j+mSlZ54VWq9DUKi6KqeGndN6YkYNyUwpaaZxHT/NijkCCiCy4A5mQ
         KGb6+CeGycQWk6pCBVJl8ta3jycju7+MURcevDqjX8J7BsD1bvvCZ+wuNQ9bqFfyIt
         vyj1hyhlm4N/ChyDxFRj5jfYDoca8aTpgn/TcCAh5aJEipQo7S6ttUfQY+BH1A385p
         HkbLUYMZ50zSQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [217.61.149.221] ([217.61.149.221]) by web-mail.gmx.net
 (3c-app-gmx-bap18.server.lan [172.19.172.88]) (via HTTP); Fri, 30 Dec 2022
 16:33:04 +0100
MIME-Version: 1.0
Message-ID: <trinity-b52833dd-883d-4f5e-b221-29bb4d942873-1672414384681@3c-app-gmx-bap18>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Aw: Re:  Re: [PATCH net v3 4/5] net: ethernet: mtk_eth_soc: drop
 generic vlan rx offload, only use DSA untagging
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 30 Dec 2022 16:33:04 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <fc09b981-282e-26cd-661e-86fdc72bedf9@nbd.name>
References: <20221230073145.53386-1-nbd@nbd.name>
 <20221230073145.53386-4-nbd@nbd.name>
 <trinity-a07d48f4-11cf-4a24-a797-03ad4b1150d9-1672400818371@3c-app-gmx-bap18>
 <82821d48-9259-9508-cc80-fc07f4d3ba14@nbd.name>
 <trinity-ace28b50-2929-4af3-9dd2-765f848c4d99-1672408565903@3c-app-gmx-bap18>
 <fc09b981-282e-26cd-661e-86fdc72bedf9@nbd.name>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:XFhZcwksdIibuOGNbKGPYa7y7vlWTRF7XmjcL9Tj/sqTwG5Lp8E2VOOkpLaaUEdHEDrlW
 96f0LKzWfYZHUzhiX2p+ht+6iwzS1wPAvY5q7b3IspA5FlcqIh6MkJSWJgPkx98HMt91juGfgTz9
 hIWXfNRn7gBPG8uUHPsUDtFkDq9vjsY+moqxqGhAjXFbjfXljxcYeS+Lfp+QjnTaIvtVrXjxwAdL
 3ReynmuimXUYYCr6+t84RL1imkWLFp6XU5v0FkNQ+TLknfy5/r0L1f40Fw7/DmEjieG170YICoCg
 pM=
UI-OutboundReport: notjunk:1;M01:P0:QnKiiIhgdmI=;c5RDmf75ZJavF8y4QKelpEKszc7
 3LFhndG3xZFde00fvl53n28ablLgi4kaEd0AAfY7ELLpRyDRoNqxX/629P6gSyMd/XsuCvW/N
 um+JQnGvcVQou6de2sKSlXQTQbgFkhZzlkN0ow9RY+pcZBapPDIpVUz2Zni95l5TaV82ezgZV
 UYYrRi625N6uvvL6G7Mv/ISkHw+iEYEeE/hDwVsJt7Dg7Hg0adtpjmfSatpwdvXeMuyBhm7t6
 ayKeCsIWTLO8a8rbFCeppH4obCiAlLHrbQArCPOcpps/SVLcqyZ1MtDez4U/BX3f4MCRE67ww
 kCsUXuBf1bd+OoqEhZSrS1BOt7t0vFBm8wB/pmN4+7nJS39DPfvPWF2c6fQaeC6ICwCwWK4NZ
 3y3uXDwpO7moqSpz7gZzzAvEL1WRwAX0u16bILvL3yYFRfN5hq9M4ApEl0tiQhgKq6hZrzBMF
 B2Ugz3Se6YCPZNONPBlbap9EkTXQcyVqJeH4Y2GkTA9YPohK7vwsMBbPPedNIgLhQ8rVhU/tb
 V7+EmY+KXaQnpXuUc3I8i6tk6AKV4IXm9j2hgEJJmgZf3294le+avFhpgEQ6EXJkHNiYkMW0X
 Rj352jskxQjiGRKCU3rW1xWs8x9Z43H11uItCx78BvXg16aSoYmN06iTcElifWN+tkFmXkgMC
 6KcoU5J0lsFtECYG6280H/ghK4oJItOL2CE4mK+Q0CYn+Vp+FXUSdoEHxYwtNgFAuJBFRboXj
 Y0ZoDswXQCdvtyQHwhomg11Btnd/06unUBiKTK+VoP2+wAPoxk+lv4L1dhEkjrvKTPQ/2LRtN
 P8cBKXXl+qo5XwaTyYVCHVwg==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi

> Gesendet: Freitag, 30. Dezember 2022 um 15:58 Uhr
> Von: "Felix Fietkau" <nbd@nbd.name>

> Does this help?
> ---
> --- a/net/dsa/tag_mtk.c
> +++ b/net/dsa/tag_mtk.c
> @@ -25,6 +25,14 @@ static struct sk_buff *mtk_tag_xmit(stru
>   	u8 xmit_tpid;
>   	u8 *mtk_tag;
>
> +	/* The Ethernet switch we are interfaced with needs packets to be at
> +	 * least 64 bytes (including FCS) otherwise their padding might be
> +	 * corrupted. With tags enabled, we need to make sure that packets are
> +	 * at least 68 bytes (including FCS and tag).
> +	 */
> +	if (__skb_put_padto(skb, ETH_ZLEN + MTK_HDR_LEN, false))
> +		return NULL;
> +
>   	/* Build the special tag after the MAC Source Address. If VLAN header
>   	 * is present, it's required that VLAN header and special tag is
>   	 * being combined. Only in this way we can allow the switch can parse

no, i verified my vlan-setup ist right by adding additional device (my r2)=
 into the same 2 vlans. My Laptop can ping both vlans of R2, but on r3/mt7=
986 only vlan500 (on eth1) works, not 600 on wan-port of mt7986.

see arp going out on r3, but not received in the other side (laptop/r2)...=
.

any debug i can add for this? ethtool does not show stats for vlans, for w=
an i see no CRC/drops

regards Frank
