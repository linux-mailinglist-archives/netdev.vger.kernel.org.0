Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF7096CB11A
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbjC0V7O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjC0V7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:59:09 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4118D30D3;
        Mon, 27 Mar 2023 14:59:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679954286; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=anV16UVMtNp/NW2ItYLiRB4AQ1SLN50vfbExP7irbCMV9YCnPN8JgnZff1N4KZ4OCApLXdn/m/9f1OKbZRLTniTMpR0AeV9WVbxb88/xdMM5opnS2lF1cpi0s7NDNV9t0JUItFQaoKsCvj0bf0qwd9tB8WCVYOGC7y0oEC52xao=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1679954286; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=m3Nxnw2EJKi8PgND390b4ttccCknFAa+VCeuBtlni8M=; 
        b=F99QbKOhBuUMdCEMnGaJw5EdSw2SS4kCm822f0A913FJ4g3N0PXHDdc70fCskgcCR1Pb0KZ7Znobd572rOywpd3Dt86MZ3S7v1dy3ewywfxnw1IlyAXhVhlscqLGVyND4piXdfLuqVa8Tn7lIpw95yyjChuhNZpeL6BoIIu5B2o=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1679954286;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=m3Nxnw2EJKi8PgND390b4ttccCknFAa+VCeuBtlni8M=;
        b=ciE8XK1PKqy/bE+GnsMM82LHIa2TtViiZ1rMMxc0lyZi2Wde8VL628n6LTpIyEgK
        ETSgndvMVoSDkOx8t99wmW5jnfweSGjh+yza1K3XxQzaJ3ZhM9ChFTJIpqJI0ncSlFR
        CfeKkCTQr0Azx2Qy12XWLcb+6ofC0oS1/EZErJus=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1679954284745209.8283533930612; Mon, 27 Mar 2023 14:58:04 -0700 (PDT)
Message-ID: <8450084e-1474-17fa-32c2-a4653b74ff17@arinc9.com>
Date:   Tue, 28 Mar 2023 00:57:57 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 4/7] net: dsa: mt7530: set both CPU port interfaces to
 PHY_INTERFACE_MODE_NA
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Russell King <linux@armlinux.org.uk>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>,
        Richard van Schagen <richard@routerhints.com>,
        Richard van Schagen <vschagen@cs.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        erkin.bozoglu@xeront.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-5-arinc.unal@arinc9.com>
 <20230327191242.4qabzrn3vtx3l2a7@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230327191242.4qabzrn3vtx3l2a7@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 27.03.2023 22:12, Vladimir Oltean wrote:
> On Sun, Mar 26, 2023 at 05:08:15PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> Set interfaces of both CPU ports to PHY_INTERFACE_MODE_NA. Either phylink
>> or mt7530_setup_port5() on mt7530_setup() will handle the rest.
>>
>> This is already being done for port 6, do it for port 5 as well.
>>
>> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
> 
> This is getting comical.. I think I'm putting too much energy in
> trying to understand the hidden meaning of this patch set.
> 
> In include/linux/phy.h we have:
> 
> typedef enum {
> 	PHY_INTERFACE_MODE_NA,
> 
> In lack of other initializer, the first element of an enum gets the
> value 0 in C.
> 
> Then, "priv" is allocated by this driver with devm_kzalloc(), which
> means that its entire memory is zero-filled. So priv->p5_interface and
> priv->p6_interface are already set to 0, or PHY_INTERFACE_MODE_NA.
> 
> There is no code path between the devm_kzalloc() and the position in
> mt7530_setup() that would change the value of priv->p5_interface or
> priv->p6_interface from their value of 0 (PHY_INTERFACE_MODE_NA).
> For example, mt753x_phylink_mac_config() can only be called from
> phylink, after dsa_port_phylink_create() was called. But
> dsa_port_phylink_create() comes later than ds->ops->setup() - one comes
> from dsa_tree_setup_ports(), and the other from dsa_tree_setup_switches().
> 
> The movement of the priv->p6_interface assignment with a few lines
> earlier does not change anything relative to the other call sites which
> assign different values to priv->p6_interface, so there isn't any
> functional change there, either.
> 
> So this patch is putting 0 into a variable containing 0, and claiming,
> through the presence of the Fixes: tag and the submission to the "net"
> tree, that it is a bug fix which should be backported to "stable".
> 
> Can it be that you are abusing the meaning of a "bug fix", and that I'm
> trying too hard to take this patch set seriously?

I don't appreciate your consistent use of the word "abuse" on my 
patches. I'm by no means a senior C programmer. I'm doing my best to 
correct the driver.

Thank you for explaining the process of phylink with DSA, I will adjust 
my patches accordingly.

I suggest you don't take my patches seriously for a while, until I know 
better.

Arınç
