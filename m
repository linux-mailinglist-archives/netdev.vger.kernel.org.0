Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C39464F856D
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 19:00:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346002AbiDGRCy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 13:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346015AbiDGRCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 13:02:51 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E3C1C8863
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 10:00:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=vENSv8lP8Ut37DNoBAoTPYOdif4ADrHDkp52LZIvgnw=; b=UBR+Un0Bt3zC4CZe47z012DyZp
        m3wAU7sKVROLk/oCT88VLlUh/kikSANxEjUIk0bvGYIFpoLSsLUt/A7ZvW46D+dvnTbD0sdngxq2+
        06W6NBg6OBAeWv+1GrUfxHYT3KfHnl3d71TLRDsQPN15hWrcIqNLYZKXMf9Um33/AjZo=;
Received: from p200300daa70ef2000000000000000451.dip0.t-ipconnect.de ([2003:da:a70e:f200::451] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ncVUq-0005sP-UU; Thu, 07 Apr 2022 19:00:37 +0200
Message-ID: <d3414eb8-bcf5-094c-8f27-66743dbbd441@nbd.name>
Date:   Thu, 7 Apr 2022 19:00:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH v2 00/14] MediaTek SoC flow offload improvements +
 wireless support
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, matthias.bgg@gmail.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220405195755.10817-1-nbd@nbd.name>
 <164925181755.19554.1627872315624407424.git-patchwork-notify@kernel.org>
 <Yk8J1xjbClhuAdBG@lunn.ch>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <Yk8J1xjbClhuAdBG@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.22 17:57, Andrew Lunn wrote:
> On Wed, Apr 06, 2022 at 01:30:17PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
>> Hello:
>> 
>> This series was applied to netdev/net-next.git (master)
>> by David S. Miller <davem@davemloft.net>:
>> 
>> On Tue,  5 Apr 2022 21:57:41 +0200 you wrote:
>> > This series contains the following improvements to mediatek ethernet flow
>> > offload support:
>> > 
>> > - support dma-coherent on ethernet to improve performance
>> > - add ipv6 offload support
>> > - rework hardware flow table entry handling to improve dealing with hash
>> >   collisions and competing flows
>> > - support creating offload entries from user space
>> > - support creating offload entries with just source/destination mac address,
>> >   vlan and output device information
>> > - add driver changes for supporting the Wireless Ethernet Dispatch core,
>> >   which can be used to offload flows from ethernet to MT7915 PCIe WLAN
>> >   devices
> 
> Hi David
> 
> It seems very early to merge this. The discussion of if the files are
> even in the right places has not even finished. And Arnd seems to not
> want parts of this in his subsystem. And there are some major
> architecture issues which need discussing...
> 
> I think you should revert this.
How about I simply send follow-up patches that move the relevant pieces 
to net?

- Felix
