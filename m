Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 054E9632FD9
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 23:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231650AbiKUWab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 17:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiKUWaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 17:30:30 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7845C694B;
        Mon, 21 Nov 2022 14:30:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:Subject:From
        :References:Cc:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=uxuIYSshrqEsvoKJWcNOpfY8vHfrYW3veh9MBfAIpnU=; b=qZ3Of+ZyrkGSar9m0nqK8N1r8X
        PHYAtBzewU9ZqZ7rL5jKRrWaAbsUC2jOKte/CWHIfmgXdK/mkxxvhPS4WdGrzdOOfmLvcbJuZRYZE
        ab0ZWMrOUK5e0j7cKYl8/mcJvykUen18FsEUINr6LJpOdYnmmAIRaZI/4na2Wovgb1KY=;
Received: from p200300daa7225c007502151ad3a4cf6f.dip0.t-ipconnect.de ([2003:da:a722:5c00:7502:151a:d3a4:cf6f] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1oxFIx-003cZx-Qy; Mon, 21 Nov 2022 23:30:19 +0100
Message-ID: <12f33881-4b6c-c4d4-1c2e-27bf93921536@nbd.name>
Date:   Mon, 21 Nov 2022 23:30:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20221121182615.90843-1-nbd@nbd.name>
 <3a9c2e94-3c45-5f83-c703-75e1cde13be1@nbd.name>
 <CANn89iKps9pM=DPn1aWF1SDMqrr=HHkHL8VofVHThUmtqzn=tQ@mail.gmail.com>
 <441bcda3-403f-0bf6-2d6f-d8c9d2ce44d6@nbd.name>
 <20221121123552.16c00373@kernel.org>
From:   Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] netfilter: nf_flow_table: add missing locking
In-Reply-To: <20221121123552.16c00373@kernel.org>
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

On 21.11.22 21:35, Jakub Kicinski wrote:
> On Mon, 21 Nov 2022 21:08:12 +0100 Felix Fietkau wrote:
>> > Could you also add a Fixes: tag ?  
>> 
>> I don't know which commit to use for that tag.
> 
> The oldest upstream commit where the problem you're solving
> can trigger?
I know, but I'm having a hard time figuring that out. The initial
version of that file came without locking. Later on some locking was
added for supporting an extra API for registering to flow table events,
but it didn't cover the cases that I'm fixing.

My guess is that the locking should have been present from the start, so:

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")

- Felix
