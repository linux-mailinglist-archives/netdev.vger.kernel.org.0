Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C8FC6BA11A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 22:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjCNVB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 17:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjCNVBN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 17:01:13 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8856A305C4;
        Tue, 14 Mar 2023 14:01:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1678827590; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=kpDDPDRhSHp/DrdqP6wSfVHIDQTg983v/pQBtxiUN1rM4m5sXuoL+Rc/G6TJsPiKj/M42tTSVSUUWC3INJFe3jpK/+CZgekS9JVjcKhA7h2w9agITvWj2BgxCbujb1CLNl9bZDfxaIizvHYoNMVdPqV/MU5AtK2O+Pjbt7JNNxI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1678827590; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=dq3Zzhtvt0x5MEoRcRnMrw4bf9BbRLcVhg9nNb0HqcA=; 
        b=afjnuVnFARu1wi7qOZ4cR1Scfg5iDnE1ozu5fsaYY/2InCFb9GqNqiNv04r14Q7o7sNBtWws5fWzbW4ffmI+lEjnYtwltRwV/SFEqi0490vSVdRBuqZgw69KpWJ0nQnhIBvhMcqKfoPm8lcGazudCOjKQMDOHCU13PM1LSzOulE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1678827590;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=dq3Zzhtvt0x5MEoRcRnMrw4bf9BbRLcVhg9nNb0HqcA=;
        b=Ylm9ClfyaO1efhNdC4GfE2cZmfEHGuWp+yl3+Yr1aLsHR9DNriUtl/x4oBE0DP8s
        SROo6P8OkwvxpkSmTAcfSrY55zuzKMFUfhJdkyDY8xIc5/nX2kq4NJDRLciXvSgDEvq
        RmIM/v1oTCuudJdZUQseSY+bhvptrWR0eZ372+mg=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1678827588900188.13596216997087; Tue, 14 Mar 2023 13:59:48 -0700 (PDT)
Message-ID: <3e3e6a1e-61ba-a6e8-5503-258fb8e949bb@arinc9.com>
Date:   Tue, 14 Mar 2023 23:59:40 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net-next v13 11/16] net: dsa: mt7530: use external PCS
 driver
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Daniel Golle <daniel@makrotopia.org>, netdev@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Frank Wunderlich <frank-w@public-files.de>,
        Alexander Couzens <lynxis@fe80.eu>
References: <cover.1678357225.git.daniel@makrotopia.org>
 <2ac2ee40d3b0e705461b50613fda6a7edfdbc4b3.1678357225.git.daniel@makrotopia.org>
 <e99cc7d1-554d-5d4d-e69a-a38ded02bb08@arinc9.com>
 <ZBCyqdfaeF/q8oZr@makrotopia.org>
 <c07651cd-27b4-5ba4-8116-398522327d27@arinc9.com>
 <20230314195322.tsciinumrxtw64o5@skbuf>
Content-Language: en-US
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230314195322.tsciinumrxtw64o5@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/03/2023 22:53, Vladimir Oltean wrote:
> On Tue, Mar 14, 2023 at 09:21:40PM +0300, Arınç ÜNAL wrote:
>> I was going to send a mail to netdev mailing list to ask for opinions
>> whether we should rename the mt7530 DSA driver to mt753x and rename these
>> functions you mentioned to mt753x so it's crystal clear what code is for
>> what hardware. Now that we glossed over it here, I guess I can ask it here
>> instead.
> 
> My 2 cents - make your first 100 useful commits on this driver, which at
> the very least produce a change in the compiled output, and then go on a
> renaming spree as much as you want.

Look, I don't ask for renaming just for the sake of renaming things. I 
see a benefit which would make things clearer.

If you rather mean to, know the driver very well, by saying do 100 
useful commits on the driver beforehand, that makes sense. But I think 
I'm capable of managing this. I've got the time and energy.

Arınç
