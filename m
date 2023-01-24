Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 375C767A1FE
	for <lists+netdev@lfdr.de>; Tue, 24 Jan 2023 20:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbjAXTAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Jan 2023 14:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbjAXTAE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Jan 2023 14:00:04 -0500
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 243584B4AD
        for <netdev@vger.kernel.org>; Tue, 24 Jan 2023 11:00:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ayrCVhcmSvvWKbOkWqYaExCenOasqZZcrvFbq5dVUGw=; b=VUJ3d5gv27omDXKvYAOo4I1tEq
        7i9OOv8YKUnJXtyBlWPpIwqv1rB672zCgDdve24pu4WcqcMD3lrThIVveKZlzUcNoLQFFZX1ocmdW
        Eyh8I5HNptkwXcKIn32u2bBVJT0u1pn7RXbMOkIS2A+cLG1dXG0WU8nxgWgdPRR6RT7o=;
Received: from [88.117.49.184] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pKOWW-0005u0-BF; Tue, 24 Jan 2023 20:00:00 +0100
Message-ID: <7b90b632-b442-be66-5036-a818c683ccdc@engleder-embedded.com>
Date:   Tue, 24 Jan 2023 19:59:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] tsnep: Fix TX queue stop/wake for multiple
 queues
Content-Language: en-US
To:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com
References: <20230122190425.10041-1-gerhard@engleder-embedded.com>
 <1b7dbb0a7e228faea3ffe5737969eb3fd3492a27.camel@redhat.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <1b7dbb0a7e228faea3ffe5737969eb3fd3492a27.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.01.23 13:07, Paolo Abeni wrote:
> Hello,
> 
> On Sun, 2023-01-22 at 20:04 +0100, Gerhard Engleder wrote:
>> netif_stop_queue() and netif_wake_queue() act on TX queue 0. This is ok
>> as long as only a single TX queue is supported. But support for multiple
>> TX queues was introduced with 762031375d5c and I missed to adapt stop
>> and wake of TX queues.
>>
>> Use netif_stop_subqueue() and netif_tx_wake_queue() to act on specific
>> TX queue.
>>
>> Fixes: 762031375d5c ("tsnep: Support multiple TX/RX queue pairs")
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> Any special reason to have this on net-next instead of on the net tree?
> The fix is reasonably small and safe and the culprit commit is on net
> already.

Not really. May I'm too shy to send to net. I will repost to net. Commit
will grow a little, but those additional lines should make a future
merge more straightforward.

Gerhard
