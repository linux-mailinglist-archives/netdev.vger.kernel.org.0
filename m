Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FB16CB0F7
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 23:47:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbjC0VrF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 17:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230049AbjC0VrA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 17:47:00 -0400
Received: from sender3-op-o17.zoho.com (sender3-op-o17.zoho.com [136.143.184.17])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA84826AA;
        Mon, 27 Mar 2023 14:46:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1679953572; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=S8cnUlpZue2d3XspE8TCRLNnx+YWi9gHt55JRvyNyWG3JRVe4KqSRcVnGBD65NOInrMXWqMwmumZ5unboKOHfW8FTFA47dJ7v68KCKJ8TUApwV56WGXcRCxQBcjSWbbfemURsBFrxX8/krvJ4E3XdTkJtL8gJOYYXPhUl+IXScQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1679953572; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=tAwTr4O+qa08St3yRauD1SYHdR3S9sJkSbpqbDz0KMc=; 
        b=MVVXQL1aLb8AnpioAA3Jpdc8daw9YX08FkGu2+XqDi9A7Ps7KniGpd3SZMnf5xua5PLNQoqqr6FT1lt19S6rwAQCa3AgEswrqaCj0AtPbjdmulTDCzZH7+jkFXItq4cSm0B+2JeX3EIE473RKrhRXxTDU1kzus9ShWG35DTNwGc=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1679953572;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=tAwTr4O+qa08St3yRauD1SYHdR3S9sJkSbpqbDz0KMc=;
        b=Qt0IOQwNF4C6kbSKTMJX40pfut0MvBfMP2Lz+psriW8MmpQogvWWUJuhpjluSlmc
        KGF3Fo8rtZY/ZJYM7BCVNt9ERS5O+67cVthyTBed8QfIWH73XlQYTWP4k10dUXJLcnM
        dxGj8epl5tZAYQoYNpCMYT/m0ES/J07QkxR77Yjw=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1679953571602159.85533940011294; Mon, 27 Mar 2023 14:46:11 -0700 (PDT)
Message-ID: <0df572f4-2d8d-3c05-cf8d-d3101b223b09@arinc9.com>
Date:   Tue, 28 Mar 2023 00:46:04 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH net 3/7] net: dsa: mt7530: do not run mt7530_setup_port5()
 if port 5 is disabled
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
 <20230326140818.246575-1-arinc.unal@arinc9.com>
 <20230326140818.246575-4-arinc.unal@arinc9.com>
 <20230326140818.246575-4-arinc.unal@arinc9.com>
 <20230327185611.gjwlrmhaiorfpj5q@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230327185611.gjwlrmhaiorfpj5q@skbuf>
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

On 27.03.2023 21:56, Vladimir Oltean wrote:
> On Sun, Mar 26, 2023 at 05:08:14PM +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> There's no need to run all the code on mt7530_setup_port5() if port 5 is
>> disabled. Run mt7530_setup_port5() if priv->p5_intf_sel is not P5_DISABLED
>> and remove the P5_DISABLED case from mt7530_setup_port5().
>>
>> Stop initialising the interface variable as the remaining cases will always
>> call mt7530_setup_port5() with it initialised.
>>
>> Fixes: 38f790a80560 ("net: dsa: mt7530: Add support for port 5")
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
> 
> Again, not sure what is the problem, and how this solution addresses
> that problem. I see Fixes tags for all patches, but I don't understand
> what they fix, what didn't work before that works now?

It really depends on what you call working. Does this patch fix any 
feature of the switch that didn't work before? No.

Does it fix a bad logic introduced with the said commit? Yes.

Arınç
