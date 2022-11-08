Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C78620D8A
	for <lists+netdev@lfdr.de>; Tue,  8 Nov 2022 11:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233941AbiKHKmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 05:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbiKHKmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 05:42:20 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD65EBC99;
        Tue,  8 Nov 2022 02:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=obs9vf68EcbHcOmjLYXoaWq/po3n5rf409qiOBIph6A=; b=HjjKxBOYTtLiSyAMgQxaQkJa27
        F0PHoT7og2Cd2AfnEnFJdeim+QEpGOkkc5xNU97iN+1Pzj/50pZIky06nziodDzbIq4ReC648IJ8N
        K7qqOSFsfKXg7P+eOJzJrwald+aLdO67hhuODRk60ouIHl6438y9ha8Fl5Dovr/Z7Ufw=;
Received: from p200300daa72ee1006d973cebf3767a25.dip0.t-ipconnect.de ([2003:da:a72e:e100:6d97:3ceb:f376:7a25] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1osM3V-000UZL-Kg; Tue, 08 Nov 2022 11:42:09 +0100
Message-ID: <1be4d21b-c0a4-e136-ed68-c96470135f14@nbd.name>
Date:   Tue, 8 Nov 2022 11:42:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.3.2
Content-Language: en-US
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
References: <20221107185452.90711-1-nbd@nbd.name>
 <20221107185452.90711-8-nbd@nbd.name> <20221107215745.ascdvnxqrbw4meuv@skbuf>
 <3b275dda-39ac-282d-8a46-d3a95fdfc766@nbd.name>
 <20221108090039.imamht5iyh2bbbnl@skbuf>
 <0948d841-b0eb-8281-455a-92f44586e0c0@nbd.name>
 <20221108094018.6cspe3mkh3hakxpd@skbuf>
 <a9109da1-ba49-d8f4-1315-278e5c890b99@nbd.name>
 <20221108100851.tl5aqhmbc5altdwv@skbuf>
 <5dbfa404-ec02-ac41-8c9b-55f8dfb7800a@nbd.name>
 <20221108103330.xt6wi3x3ugp7bbih@skbuf>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH 08/14] net: vlan: remove invalid VLAN protocol warning
In-Reply-To: <20221108103330.xt6wi3x3ugp7bbih@skbuf>
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

On 08.11.22 11:33, Vladimir Oltean wrote:
> On Tue, Nov 08, 2022 at 11:24:51AM +0100, Felix Fietkau wrote:
>> On 08.11.22 11:08, Vladimir Oltean wrote:
>> > On Tue, Nov 08, 2022 at 10:46:54AM +0100, Felix Fietkau wrote:
>> > > I think it depends on the hardware. If you can rely on the hardware always
>> > > reporting the port out-of-band, a generic "oob" tagger would be fine.
>> > > In my case, it depends on whether a second non-DSA ethernet MAC is active on
>> > > the same device, so I do need to continue using the "mtk" tag driver.
>> > 
>> > It's not only about the time dimension (always OOB, vs sometimes OOB),
>> > but also about what is conveyed through the OOB tag. I can see 2 vendors
>> > agreeing today on a common "oob" tagger only to diverge in the future
>> > when they'll need to convey more information than just port id. What do
>> > you do with the tagging protocol string names then. Gotta make them
>> > unique from the get go, can't export "oob" to user space IMO.
>> > 
>> > > The flow dissector part is already solved: I simply used the existing
>> > > .flow_dissect() tag op.
>> > 
>> > Yes, well this seems like a generic enough case (DSA offload tag present
>> > => don't shift network header because it's where it should be) to treat
>> > it in the generic flow dissector and not have to invoke any tagger-specific
>> > fixup method.
>> 
>> In that case I think we shouldn't use METADATA_HW_PORT_MUX, since it is
>> already used for other purposes. I will add a new metadata type METADATA_DSA
>> instead.
> 
> Which case, flow dissector figuring out that DSA offload tag is present?
> Well, the skb can only carry one dst pointer ATM, so if it's METADATA_HW_PORT_MUX
> but it belongs to SR-IOV on the DSA master, we have bigger problems anyway.
> So, proto == ETH_P_XDSA && have METADATA_HW_PORT_MUX should be pretty
> good indication that DSA offload tag is present.
> 
> Anyway I raised this concern as well to Jakub as well. Seems to be
> theoretical at the moment. Using METADATA_HW_PORT_MUX seems to be fine
> right now. Can be changed later if needed; it's not ABI.
Okay, I will stick with METADATA_HW_PORT_MUX for now. If we use it in 
the flow dissector to avoid the tagger specific fixup, we might as well 
use it in DSA to skip the tag proto receive call. What do you think?

- Felix
