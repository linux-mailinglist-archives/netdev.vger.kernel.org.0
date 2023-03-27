Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E21F6CB0E8
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229845AbjC0Vpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232153AbjC0VpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:45:13 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C23171FF2;
        Mon, 27 Mar 2023 14:45:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679953466; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=FpaQAKo96iijQL09OHyq7oXJOia9ek47qTry412zgpp6ecAzuPjSFT07mmjBB8QJHMwmEEiwIRys/jzXv5v5NyAV5zO6qXkCOdden2SGGT6KeN+abPayDsUBrGcy7JYasWrheOa3A6wYhf1oYaVgNwUnpLtuOqrHmmr1ojoUocA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1679953466; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=7JfmAC/E4FArAkJLqHhygEkjSsgmfY7ECoy3BidHAuo=; 
        b=CTOtdQf+Aiaz0FM8XaXNHXCLCfOECIxsKHaGovToteltYf6BBlKs67PeLaMLGnVvkfk+5rxaKhukVQI+8yiHja1CpDNRgJJ31P3u1pJ8O1coctja1hOBwfEpw9BvEq+tjGh6s8z2CT2k/AcfZLrpmLL5t9jEUegqjyOWKzIwgmE=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1679953466;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=7JfmAC/E4FArAkJLqHhygEkjSsgmfY7ECoy3BidHAuo=;
        b=HtfcyjvEu4aopAbw/VE4Lit7cBmsmAa8Bc3k3HYcwHNuY8VsUPsluDl3feo/Jgs9
        OYi+Eottd5ejp6E58dOOvgparzpdQ7jz+/aRc3CcnhlanV6V0NZ+Z4cQWGh1fxqAFV9
        0dnkyRZVyavOWq25/8T9a9wWMEMHdSTZSXOgclZA=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1679953465201776.7811029158123; Mon, 27 Mar 2023 14:44:25 -0700 (PDT)
Message-ID: <2f5ba94a-e48d-7927-4902-9736da2b8cbf@arinc9.com>
Date:   Tue, 28 Mar 2023 00:44:18 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 2/7] net: dsa: mt7530: fix phylink for port 5 and fix
 port 5 modes
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
 <20230326140818.246575-3-arinc.unal@arinc9.com>
 <20230327184944.oahce2iizpauw4nm@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230327184944.oahce2iizpauw4nm@skbuf>
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

On 27.03.2023 21:49, Vladimir Oltean wrote:
> On Sun, Mar 26, 2023 at 05:08:13PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> There're two call paths for setting up port 5:
>>
>> mt7530_setup()
>> -> mt7530_setup_port5()
>>
>> mt753x_phylink_mac_config()
>> -> mt753x_mac_config()
>>     -> mt7530_mac_config()
>>        -> mt7530_setup_port5()
>>
>> The first call path is supposed to run when phy muxing is being used. In
>> this case, port 5 is somewhat of a hidden port. It won't be defined on the
>> devicetree so phylink can't be used to manage the port.
>>
>> The second call path used to call mt7530_setup_port5() directly under case
>> 5 on mt7530_phylink_mac_config() before it was moved to mt7530_mac_config()
>> with 88bdef8be9f6 ("net: dsa: mt7530: Extend device data ready for adding a
>> new hardware"). mt7530_setup_port5() will never run through this call path
>> because the current code on mt7530_setup() bypasses phylink for all cases
>> of port 5.
>>
>> Leave it to phylink if port 5 is used as a CPU port or a user port. For the
>> cases of phy muxing or the port being disabled, call mt7530_setup_port5()
>> directly from mt7530_setup_port5() without involving phylink.
> 
> You probably don't mean "call X() from X()" (that would make it recursive),
> but maybe from mt7530_setup(). But it was already called from mt7530_setup(),
> so I don't understand what is being transmitted here...

Oops, I meant to say call mt7530_setup_port5() directly from 
mt7530_setup() without involving phylink. Will fix.

> 
>>
>> Move setting the interface and P5_DISABLED mode to a more specific
>> location. They're supposed to be overwritten if phy muxing is detected.
>>
>> Add comments which explain the process.
>>
>> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> Sorry, I didn't understand... so what was the problem, and how does the
> movement of the mt7530_setup_port5() call that isn't under phylink solve
> that problem?

Port 5 being used as a CPU or user port was being set up from 
mt7530_setup() instead of using phylink. This patch fixes that.

Arınç
