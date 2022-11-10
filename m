Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F7C66249D1
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 19:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbiKJSoX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 13:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231367AbiKJSoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 13:44:15 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965544730D
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 10:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=r4WgWvq7LeWC54KLFtoLJVFPenyJUDyOFYsB574niLI=; b=OtEx2/ra0q4bCSHCPWJ552VOfH
        tAxiuL3A4uiMPOV3peFwmADmLpDOMLV2sJdh7SNurcoqIQ31U//7xFM/RWjhmT3wSf+f016ZKUTeo
        Cc2peJuT08P0H+1sOcb5MHxYHpW9aHLhnZdsiJm3BUp+91uBnYq1zJe/J5F7YByg99L8=;
Received: from p200300daa72ee10c199752172ce6dd7a.dip0.t-ipconnect.de ([2003:da:a72e:e10c:1997:5217:2ce6:dd7a] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1otCX6-0010Bz-PZ; Thu, 10 Nov 2022 19:44:12 +0100
Message-ID: <2abbe051-7ddb-e9d6-a477-86555c9ed377@nbd.name>
Date:   Thu, 10 Nov 2022 19:44:12 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v2 00/12] Multiqueue + DSA untag support + fixes
 for mtk_eth_soc
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Matthias Brugger <matthias.bgg@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20221109163426.76164-1-nbd@nbd.name>
 <20221110142816.nzy4sb27km7xpctd@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20221110142816.nzy4sb27km7xpctd@skbuf>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10.11.22 15:28, Vladimir Oltean wrote:
> On Wed, Nov 09, 2022 at 05:34:14PM +0100, Felix Fietkau wrote:
>> This series contains multiple improvements for mtk_eth_soc:
>> 
>> On devices with QDMA (MT7621 and newer), multiqueue support is implemented
>> by using the SoC's traffic shaper function, which sits on the DMA engine.
>> The driver exposes traffic shaper queues as network stack queues and configures
>> them to the link speed limit. This fixes an issue where traffic to slower ports
>> would drown out traffic to faster ports. It also fixes packet drops and jitter
>> when running hardware offloaded traffic alongside traffic from the CPU.
>> 
>> On MT7622, the DSA tag for MT753x switches can be untagged by the DMA engine,
>> which removes the need for header mangling in the DSA tag driver.
>> 
>> This is implemented by letting DSA skip the tag receive function, if the port
>> is passed via metadata dst type METADATA_HW_PORT_MUX
>> 
>> Also part of this series are a number of fixes to TSO/SG support
>> 
>> Changes in v2:
>> - drop the use of skb vlan tags to pass the port information to the tag driver,
>>   use metadata_dst instead
>> - fix a small issue in enabling untag
> 
> Please split the work and let's concentrate on one thing at a time
> without extra noise, for example DSA RX tag processing offload first,
> since that needs the most attention.
> 
> Also please use ./scripts/get_maintainer.pl when sending patches ;)
I did that. That's where most of the To/Cc's came from.

- Felix
