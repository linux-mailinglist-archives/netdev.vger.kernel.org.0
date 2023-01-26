Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2267E67D475
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 19:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232163AbjAZSl6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 13:41:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbjAZSl5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 13:41:57 -0500
Received: from wout4-smtp.messagingengine.com (wout4-smtp.messagingengine.com [64.147.123.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D7AD3EFC6;
        Thu, 26 Jan 2023 10:41:43 -0800 (PST)
Received: from compute6.internal (compute6.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 0AB3E32000D9;
        Thu, 26 Jan 2023 13:41:39 -0500 (EST)
Received: from imap51 ([10.202.2.101])
  by compute6.internal (MEProxy); Thu, 26 Jan 2023 13:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; t=1674758499; x=1674844899; bh=s/3u3IdhZX
        LqBuo4DZdO5LrZKWdZJ/fXn8nsI7x5qv8=; b=FpYz1KWomhYBEGMOKTj6x5Kn5l
        1DHsVSZb3K0d3QkItsPmvcQH31GP710+8Efw1VLHUE6VQK7zAAyEfPBrDIiP0jDM
        PQ3TjZgWQ4oE6TBlY1dgNQRmb/8N7apPIGJuj8koMiod7r33aCU/2rmK059CJVtL
        xU6Bs1K0iTE1xuAFTuZH4fvcfgWbkWOJftbuZG6tnePkqoNRrOQQQRasdzqx611H
        OP8OnqI6I09P0UkQhATWZwhkygZTMtug9kN18+s1NE8oSWEt4CLBLTTZdepswNQc
        cATI8IKZbxYvV4hxvnqilGcXKiSNoq/HwVnas6wA2dICzDrHeLd4jUNMVuHA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1674758499; x=1674844899; bh=s/3u3IdhZXLqBuo4DZdO5LrZKWdZ
        J/fXn8nsI7x5qv8=; b=YuHXoEXx5blFxXBbkw5H+PsaxScEXQIcgdWvf78r0G5L
        a7n1gL1b1ZgT7be3EZwfF3KT7GxettJlq6PBbTzOvD7RSlW3chK4kXeYps4+eK1O
        YJywqsEYwpBv0NPndDaIJQI4eZ5tnXfXB9Lzgtgh9zacI7GB4qOJ68UqeDRsILS0
        U4iaHF4Z9JNaTasGXdzorVoXOoh56P6Wn6Y3e53i3YeFlm3sQQbNppWXO7ZREwcb
        QBWtCUdJn0fE6+hlozaALBgUY2+OKJKkSm59xkyv+Q63iKdnf052s1ECWPvOnZWQ
        OBLIY+pq1zGEA+0lHogMZ5IpBPnslMYiPTKP/NxFGg==
X-ME-Sender: <xms:Y8nSY4OfXRXctYOJ8kHq-RPx3tb87SDkmINi6exFN1daN6301GCYgA>
    <xme:Y8nSY--45iQ-pBNn1SburrssP3OljWCTAqHk_kh0pfHAb-kOWtcmNtnInaZaTaP91
    CDZaRwUtdg60IUDEos>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedruddvgedgudduiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefofgggkfgjfhffhffvvefutgesthdtredtreertdenucfhrhhomhepfdet
    rhhnugcuuegvrhhgmhgrnhhnfdcuoegrrhhnugesrghrnhgusgdruggvqeenucggtffrrg
    htthgvrhhnpeffheeugeetiefhgeethfejgfdtuefggeejleehjeeutefhfeeggefhkedt
    keetffenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhhnugesrghrnhgusgdruggv
X-ME-Proxy: <xmx:Y8nSY_TPF7alI46nUTidbO_C_DXkOKVUf3pz5mTBEJ224kDe8jhcng>
    <xmx:Y8nSYwsvzH4ZCb_Cu0zfXRzKTu7rwH8PAtV4SLqZ3CvsSTOfSxil8Q>
    <xmx:Y8nSYweum5M6XgJ8mO5p4k37gPh00yxW7WmR14j2B9_He2SZnIHj0Q>
    <xmx:Y8nSY44oR1hLP64jHYL4F4OTVZxWrcoAtQS95dc23hQouyF_hbuZKw>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.nyi.internal (Postfix, from userid 501)
        id 43B3DB60086; Thu, 26 Jan 2023 13:41:39 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
User-Agent: Cyrus-JMAP/3.9.0-alpha0-85-gd6d859e0cf-fm-20230116.001-gd6d859e0
Mime-Version: 1.0
Message-Id: <5313ee39-7313-493b-9b66-a9c697962831@app.fastmail.com>
In-Reply-To: <Y9LDIvWiG9gSl9f2@unreal>
References: <20230126135454.3556647-1-arnd@kernel.org>
 <Y9LDIvWiG9gSl9f2@unreal>
Date:   Thu, 26 Jan 2023 19:41:19 +0100
From:   "Arnd Bergmann" <arnd@arndb.de>
To:     "Leon Romanovsky" <leon@kernel.org>,
        "Arnd Bergmann" <arnd@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "Rob Herring" <robh+dt@kernel.org>,
        "Krzysztof Kozlowski" <krzysztof.kozlowski+dt@linaro.org>,
        Netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wiznet: convert to GPIO descriptors
Content-Type: text/plain
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 26, 2023, at 19:14, Leon Romanovsky wrote:
> On Thu, Jan 26, 2023 at 02:54:12PM +0100, Arnd Bergmann wrote:
>>  
>> @@ -139,6 +139,12 @@ MODULE_LICENSE("GPL");
>>  #define W5500_RX_MEM_START	0x30000
>>  #define W5500_RX_MEM_SIZE	0x04000
>>  
>> +#ifndef CONFIG_WIZNET_BUS_SHIFT
>> +#define CONFIG_WIZNET_BUS_SHIFT 0
>> +#endif
>
> I don't see any define of CONFIG_WIZNET_BUS_SHIFT in the code, so it looks
> like it always zero and can be removed.

Good catch! Evidently the original idea was that this would
be set to a machine specific value through Kconfig. I've renamed
the constant, removed the #ifdef and explained it in the changelog
text now.

     Arnd
