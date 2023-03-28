Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 337336CCC18
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 23:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229626AbjC1V2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 17:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC1V2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 17:28:00 -0400
Received: from sender4-op-o10.zoho.com (sender4-op-o10.zoho.com [136.143.188.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF89B2681;
        Tue, 28 Mar 2023 14:27:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1680038840; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Mm+Vi7gRsZCWnfYtjcfvIpt/YbzZ+Wn3MKA3cJtIlZwSUmp1tygyxI2OkYL913cFizn+4Y5MhitdhOXjyTAJ+DBKCvpjUee8ag2Q01ShtKDqZ5loTGSQ/9tsE4aDJqutfGiNogzR/uA4dqps2oi/A5LddDIIy+HlWTGzeIbUbEA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1680038840; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=+y0Ba+KFp0LIEVnL+sMXDfVh8ybd+Bu3l5NO3YH+4Pw=; 
        b=ELEtOeuq9Um9ZX45dqpJ4g67JJDXbwQgMyrVgXiyS3KfI31P0E6HNukQ5kWtNtYmgK3npihvuK4yNePhaJ00e3cOCUxSvejurlb3h0HVCeEZfNyl1e9DETxelfRkXNiu2+4VUZkFkuGVZ9q/OosYc3kTDlOEMTNELYaYdeKogRk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1680038840;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=+y0Ba+KFp0LIEVnL+sMXDfVh8ybd+Bu3l5NO3YH+4Pw=;
        b=MQsoRsrShXwj3VYTDgfV4SV8HGAegWDWQP6rrc85bQl1FQslEn3esImY6cYenis/
        bknzoo7DN9guOGFlLLNtGKWKTgGr/aeJGhTH+NOU1TN7g5BE1UhOY06kQmbpxmwK7hO
        ljIzdhQ0mPIIJ67pOM6Ka89RRT+p+crG3/nPM4Ds=
Received: from [10.10.10.3] (149.91.1.15 [149.91.1.15]) by mx.zohomail.com
        with SMTPS id 1680038838686721.2602700369897; Tue, 28 Mar 2023 14:27:18 -0700 (PDT)
Message-ID: <ab68cc01-e962-74c1-f22a-de5df42cc7d2@arinc9.com>
Date:   Wed, 29 Mar 2023 00:27:10 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 0/7] net: dsa: mt7530: fix port 5 phylink, phy muxing, and
 port 6
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
 <20230328112154.qk5fwqaig4sit3ho@skbuf>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20230328112154.qk5fwqaig4sit3ho@skbuf>
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

On 28/03/2023 14:21, Vladimir Oltean wrote:
> On Sun, Mar 26, 2023 at 05:08:11PM +0300, arinc9.unal@gmail.com wrote:
>> Hello!
>>
>> This patch series is mainly focused on fixing the support for port 5 and
>> setting up port 6.
>>
>> The only missing piece to properly support port 5 as a CPU port is the
>> fixes [0] [1] [2] from Richard.
>>
>> Russell, looking forward to your review regarding phylink.
>>
>> I have very thoroughly tested the patch series with every possible mode to
>> use. I'll let the name of the dtb files speak for themselves.
> 
> This patch needs to be resubmitted (potentially as RFC) to the net-next
> tree, and the commits readjusted to clarify what are fixes and what is
> pure refactoring. With the mentioned that I have not reviewed the entire
> series and I will not do that, either.

Makes sense, will do.

Arınç
