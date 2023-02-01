Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4625686D7F
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 18:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbjBAR6d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 12:58:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbjBAR6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 12:58:32 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7287E4C0DB;
        Wed,  1 Feb 2023 09:58:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1675274285; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=Lo9Ml/vQ1/Wtky7jkidoReeOE45KTxClPo73lvQK5Raa38x9za6Hnuur4fVXwlevNoxbGxZaxv+P/UBTLzgMnm9zCehw65xiYN8ok9H3xWfP4qJFf/97GhUBFq7k1dpa6k9dMLcGfJ2xTtLzyPKo8O1C5s4jI77h1AK/2lpIsxo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1675274285; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=sanDwlKMu1XJbvPWqtzhQXrv5xMEUsJJgfXxkqVcqSs=; 
        b=bT82x/CIcO360OZamHyzcf4moNj2281Bgg8vjBYchmM1vAafvM2+DDXjx4sSi2hmaHEX4lquAGOIj5SNiVNAKJHKiADr0FLCwRaLI7diQwCqpTUejGWNm0wMh1XLZ+BxZMnyKJDcJCOvWdNumVyLx82/nJAO+/xGAy2taCII+X8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1675274285;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=sanDwlKMu1XJbvPWqtzhQXrv5xMEUsJJgfXxkqVcqSs=;
        b=WkazmVmtMlgzQ71boLbgGpKLQSsv8JGB50U9Nyq7hbIgESX0tGeF7ObJmjUDLtUW
        KupOLmo5hR3fjutejuQ+ehhW3zKQFvIVRytr2geV0URikSZXQ2OzbLSK08br6rbAjPZ
        SDHBcotATnx23WsZmPfJL0QbojheL+BJ1qi4FYFA=
Received: from [10.10.10.3] (37.120.152.236 [37.120.152.236]) by mx.zohomail.com
        with SMTPS id 167527428298987.0552013678548; Wed, 1 Feb 2023 09:58:02 -0800 (PST)
Message-ID: <5968fa14-e894-7592-c2a4-d3aeaa14174d@arinc9.com>
Date:   Wed, 1 Feb 2023 20:57:58 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: disable hardware DSA
 untagging for second MAC
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        erkin.bozoglu@xeront.com,
        Frank Wunderlich <frank-w@public-files.de>
References: <20230128094232.2451947-1-arinc.unal@arinc9.com>
 <f753ad2b0c19e085867698f7bbbe37f6d172772e.camel@redhat.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <f753ad2b0c19e085867698f7bbbe37f6d172772e.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31.01.2023 16:00, Paolo Abeni wrote:
> On Sat, 2023-01-28 at 12:42 +0300, arinc9.unal@gmail.com wrote:
>> From: Arınç ÜNAL <arinc.unal@arinc9.com>
>>
>> According to my tests on MT7621AT and MT7623NI SoCs, hardware DSA untagging
>> won't work on the second MAC. Therefore, disable this feature when the
>> second MAC of the MT7621 and MT7623 SoCs is being used.
>>
>> Fixes: 2d7605a72906 ("net: ethernet: mtk_eth_soc: enable hardware DSA untagging")
>> Link: https://lore.kernel.org/netdev/6249fc14-b38a-c770-36b4-5af6d41c21d3@arinc9.com/
>> Tested-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> Signed-off-by: Arınç ÜNAL <arinc.unal@arinc9.com>
>> ---
>>
>> Final send which should end up on the list. I tested this with Felix's
>> upcoming patch series. This fix is still needed on top of it.
>>
>> https://lore.kernel.org/netdev/20221230073145.53386-1-nbd@nbd.name/
>>
>> The MTK_GMAC1_TRGMII capability is only on the MT7621 and MT7623 SoCs which
>> I see this problem on. I'm new to coding so I took an educated guess from
>> the use of MTK_NETSYS_V2 to disable this feature altogether for MT7986 SoC.
> 
> Keeping this one a little more on pw. It would be great is someone else
> could validate the above on the relevant H/W.

CC'ing Frank. Frank, could you test this on your Bananapi BPI-R2?

Arınç
