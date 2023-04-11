Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF5D66DE502
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 21:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbjDKTbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 15:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjDKTa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 15:30:59 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2114412B;
        Tue, 11 Apr 2023 12:30:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1681241416; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=TGzaa2BIW0gfYqShX3j6kQf3wpOX358BqzlxOYmeghBT/jc1PMvXM+wHGra0QKPE/lMnSn2aQUl8z5aJipet/3qW82SeiZnhg8ZP0v54FphbcLLvACR3CO7nMkNWpd+HZFcKhyZ6sl0U7RdfbeHO6nTJiNP8x+GsCuMGhL38OoU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1681241416; h=Content-Type:Content-Transfer-Encoding:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=kfGH9HkW5py1NH3SwhLhjxeBMz1IuBOSJ0oOK5CZiX0=; 
        b=GJgI3CHlN1xmx6NDVJlVsPCji0io1XKfk2rPkYOucSmbBmXeM2QybOWrqL+vywCmC+e95532bSZAhcovA2neYUua/eDqGyqaabwiGF/spW497m2dtcKhXHz75SbyItLWNmC42aGMzt6sHcJIAWYclm2JODgyb+kzZu8NmLLKV8Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1681241416;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
        bh=kfGH9HkW5py1NH3SwhLhjxeBMz1IuBOSJ0oOK5CZiX0=;
        b=BTHzBAOJssUIUmmm/csAJIZSsAjDwEcJkazWpKMZBHiA9v1WpW+k0P+UmFTHLpgN
        XrnRwEZ99+ncRJQ06sWNDcE1lhap1Mr5KnpYHfS8V7fr1zCiq3tLKownUT1aGxMBWVt
        KFRobea7lU8AgesXfgkEZZLNqFj84DMBFuiTHq+8=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 168124141340520.562359472014464; Tue, 11 Apr 2023 12:30:13 -0700 (PDT)
Message-ID: <13aedaa6-6b7b-727e-e932-4a5139c54f39@arinc9.com>
Date:   Tue, 11 Apr 2023 22:30:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next] net: dsa: mt7530: fix support for MT7531BE
To:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
References: <ZDSlm-0gyyDZXy_k@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <ZDSlm-0gyyDZXy_k@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.04.2023 03:11, Daniel Golle wrote:
> There are two variants of the MT7531 switch IC which got different
> features (and pins) regarding port 5:
>   * MT7531AE: SGMII/1000Base-X/2500Base-X SerDes
>   * MT7531BE: RGMII
> 
> Moving the creation of the SerDes PCS from mt753x_setup to mt7530_probe
> with commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS creation to
> mt7530_probe function") works fine for MT7531AE which got two instances
> of mtk-pcs-lynxi, however, MT7531BE requires mt7531_pll_setup to setup
> clocks before the single PCS on port 6 (usually used as CPU port)
> starts to work and hence the PCS creation failed on MT7531BE.
> 
> Fix this by introducing a pointer to mt7531_create_sgmii function in
> struct mt7530_priv and call it again at the end of mt753x_setup like it
> was before commit 6de285229773 ("net: dsa: mt7530: move SGMII PCS
> creation to mt7530_probe function").

If I understand correctly, this patch does two things.

Run mt7531_create_sgmii() from mt753x_setup(), after mt7531_setup() and 
mt7531_setup_common() is run so that PCS on MT7531BE works.

Run the PCS creation code inside the loop only once if 
mt7531_dual_sgmii_supported() is false so it doesn't set the nonexistent 
port 5 SGMII on MT7531BE.

Regarding the first part:
I was actually in the middle of moving the code until after 
mt7530_pll_setup() and mt7531_pll_setup() on mt7530_setup() and 
mt7531_setup() to mt7530_probe(). To me it makes more sense to run them 
on mt7530_probe() as there's a good amount of duplicate code on 
mt7530_setup() and mt7531_setup().

This will resolve the problem here, and make my future work regarding 
the PHY muxing feature on the MT7530 switch possible to do.

Regarding the second part:
I'll take your changes to my current RFC patch series while addressing 
Jesse's suggestion if this is fine by you.

Arınç
