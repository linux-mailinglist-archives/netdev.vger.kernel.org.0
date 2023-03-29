Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9EC26CD145
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 06:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjC2EyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 00:54:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjC2EyM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 00:54:12 -0400
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E49358E
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 21:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fxfm5Oc/n7SDht/zpHrUS6orw9qlRAZ8ZPsHcVfdIM0=; b=WK6zAjvM/5TF2oQcJdJvEWvcis
        tN8wch3BExDf8cn8zskvkZCjciT/ePJjqRJ9li6UpaGnlDg3DiAwZDTwWBH2r3n9dbpX3ZwFrGlMn
        2T0dwsDBpBUNa0kM5UvijJbZFNy625A6PRRQE4eYVRG0d9tBNJdbg0Qv4NYWslLsOfeY=;
Received: from p54ae9730.dip0.t-ipconnect.de ([84.174.151.48] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1phNoz-0082QC-Ib; Wed, 29 Mar 2023 06:54:05 +0200
Message-ID: <9562d963-2636-5643-a461-6f304f59c3ab@nbd.name>
Date:   Wed, 29 Mar 2023 06:54:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.9.0
Subject: Re: [PATCH net] net: ethernet: mtk_eth_soc: fix tx throughput
 regression with direct 1G links
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Frank Wunderlich <frank-w@public-files.de>,
        Daniel Golle <daniel@makrotopia.org>
References: <20230324140404.95745-1-nbd@nbd.name>
 <20230328190155.7eab8368@kernel.org>
Content-Language: en-US
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230328190155.7eab8368@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.03.23 04:01, Jakub Kicinski wrote:
> On Fri, 24 Mar 2023 15:04:04 +0100 Felix Fietkau wrote:
>> Using the QDMA tx scheduler to throttle tx to line speed works fine for
>> switch ports, but apparently caused a regression on non-switch ports.
>> 
>> Based on a number of tests, it seems that this throttling can be safely
>> dropped without re-introducing the issues on switch ports that the
>> tx scheduling changes resolved.
>> 
>> Link: https://lore.kernel.org/netdev/trinity-92c3826f-c2c8-40af-8339-bc6d0d3ffea4-1678213958520@3c-app-gmx-bs16/
>> Fixes: f63959c7eec3 ("net: ethernet: mtk_eth_soc: implement multi-queue support for per-port queues")
>> Reported-by: Frank Wunderlich <frank-w@public-files.de>
>> Reported-by: Daniel Golle <daniel@makrotopia.org>
>> Tested-by: Daniel Golle <daniel@makrotopia.org>
>> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> 
> My reading of the discussion was that this patch is good, even if it
> doesn't fix all the models, but it's marked as Changes Requested in PW.
> Could you confirm that we should apply this one as is, just to be sure?
Yes, please apply this one. I will send another patch to take care of 
MT7623 soon.

- Felix
