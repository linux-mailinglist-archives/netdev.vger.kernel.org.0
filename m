Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8BA6D4EA4
	for <lists+netdev@lfdr.de>; Mon,  3 Apr 2023 19:09:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbjDCRJV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Apr 2023 13:09:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230044AbjDCRJU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Apr 2023 13:09:20 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B017272D;
        Mon,  3 Apr 2023 10:09:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680541709; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=S1zMyZnweAolB2TRy/fP+L3GoUKCkvVZHdVc9eafHVqDpoRmVhjI/VHjnOjyciaish4Ize5Dl2CiC1nFdNahUiSp22SMGP0xUJ9jXQWo7EU4eklYaFMdnJ+1dphdY3hiZWEZgL8cCiLAkN8ykyBzYoOafG34P1qya2bxA3g54HQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680541709; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=8RPtHnYiqxYR7jMQ96ruVj9dgpgnpsFINClEHWBWfDc=; 
        b=dJIzMnjYVm0p39GDp4QtNSPtLNmu3l+Puwq+CQbdFTz4zy/1nQoW+Ow1wALzynZuKiOmlv689pFOhb7Eb0YjTRHj2zO2oFFKHcWtehx9dYed3no478LIHZ9Lo0RFAs2DfNPFD24I9Megu5vRWWQYS7CFYy9eq60aVxl65hjDnBE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680541709;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=8RPtHnYiqxYR7jMQ96ruVj9dgpgnpsFINClEHWBWfDc=;
        b=WfLMyM7fcWryl6sOIZfA7AJMwtQUH5gTOwN/iIIu2z/dXmyKv6SIQTv6E+aGorjI
        2+b3YuBV0G1rRO51OsduMhcG5El91IXBFAQsRFBxBA8hmuZ6d+LuHaDRHbhhCNYWjXc
        y8+ZfhJfx4ckUsO1CNx1D+6bxmEnXiBRsit2dGHM=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680541707516945.4680684306775; Mon, 3 Apr 2023 10:08:27 -0700 (PDT)
Message-ID: <53d89480-936d-25b1-6422-cda7769de369@arinc9.com>
Date:   Mon, 3 Apr 2023 20:08:19 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v2 00/14] net: dsa: add support for MT7988
To:     Daniel Golle <daniel@makrotopia.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>
Cc:     Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
References: <cover.1680483895.git.daniel@makrotopia.org>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <cover.1680483895.git.daniel@makrotopia.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-1.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3.04.2023 04:16, Daniel Golle wrote:
> The MediaTek MT7988 SoC comes with a built-in switch very similar to
> previous MT7530 and MT7531. However, the switch address space is mapped
> into the SoCs memory space rather than being connected via MDIO.
> Using MMIO simplifies register access and also removes the need for a bus
> lock, and for that reason also makes interrupt handling more light-weight.
> 
> Note that this is different from previous SoCs like MT7621 and MT7623N
> which also came with an integrated MT7530-like switch which yet had to be
> accessed via MDIO.
> 
> Split-off the part of the driver registering an MDIO driver, then add
> another module acting as MMIO/platform driver.
> 
> The whole series has been tested on various MediaTek boards:
>   * MT7623A + MT7530 (BPi-R2)
>   * MT7986A + MT7531 (BPi-R3)
>   * MT7988A reference board

You did not address the incorrect information I pointed out here. Now 
that the patch series is applied, people reading this on the merge 
branch commit will be misled by the misinformation.

> 
> Changes since v1:
>   * use 'internal' PHY mode where appropriate
>   * use regmap_update_bits in mt7530_rmw
>   * improve dt-bindings

As a maintainer of the said dt-bindings, I pointed out almost 7 things 
for you to change. Of those 7 points, you only did one, a trivial 
grammar change. The patch series is applied now so one of us maintainers 
(you are one too now) need to fix it with additional patches.

Arınç
