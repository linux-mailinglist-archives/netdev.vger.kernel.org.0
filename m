Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2454C554027
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 03:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbiFVBm0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 21:42:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbiFVBmZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 21:42:25 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5582F3A1
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 18:42:24 -0700 (PDT)
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com [209.85.214.197])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 880063FBF5
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 01:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1655862142;
        bh=+5CGZkLDfl40CcFfi/cWH+s1gprCUkzbML/cAfdT+Zk=;
        h=From:To:cc:Subject:In-reply-to:References:MIME-Version:
         Content-Type:Date:Message-ID;
        b=m69JzZ598Sdn5LZdr+Lvw9GOG6bl6RI6f9MAqLmTyZ//h9l9G16tq1/lKGVHfq7nb
         6Y0fS/qsE1Qel2eXC5kPSW7BiaopKjdPrEG90CNPjLcymQ3mhqVPWYgKxFjEXwLxJH
         1dKMd3q/qHIHmU1xrWGGyr1fOeiDR1tIvdM72L+jaNycCNiaOsXaIkTWKBvxWGIQgU
         xaMK76X5uL5ltJ/mYsN4BmGdU5OQdpRkjkeqbB+y4dpTYgTovqwxHgYm7gaEccZ1Pc
         dfa9Lc86kDEQlWJ/uRIaIHIG6bwKchj7ef6etOQx2A1TZzc/ctXU0MsdgX2GAbt/5x
         qWtMH3FQgDyng==
Received: by mail-pl1-f197.google.com with SMTP id t1-20020a170902e84100b001689cab0be3so9228423plg.11
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 18:42:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references
         :comments:mime-version:content-id:date:message-id;
        bh=+5CGZkLDfl40CcFfi/cWH+s1gprCUkzbML/cAfdT+Zk=;
        b=NVcflkL+o5xygvQjZL3LuU8uxbEvvLK6HDm5b08CxzN0vhyKNFCclchETJcKNmd+74
         8aH0VV2TRQuZHrmSTBebSo0F7YZ6v2vsMxz3PDje+CJ50W07k0JVx8yndYPdfqNM3NBM
         2dhV0MgcxKsO5XgkzA6csxFEUmanxo57ANBTP2E3CZW2yLqJj/1Em47wugh6KHWQ2mfo
         e27EUysi8H9jg/AzkoGH/UuGJTXqDh4JkA1RWZA2sPmuGEIe3wYxbwsgmySpbzVJhKP0
         vpR/7i+U73KnFy7YyHwXa7TkyA7EVjipTFUpF9VUtgs/yvNctAvykncUUlRsoVuK+d7J
         f0jg==
X-Gm-Message-State: AJIora9GgCUTvqdTt1lTekSEZri9FuP1SPLLzH5GeEAL2YKZqxWZL/7F
        /g9q/hPZm+DAtGL7DW4dVEgKqK+lVRaKKvGUQTmDSWKBclku71oz2PQjjSWkRnxwRVlMHYetOkd
        iHpA1S/R9A9LzeRCfsN2Fpy8RNz3mjFHd+A==
X-Received: by 2002:a65:48c6:0:b0:405:176f:695c with SMTP id o6-20020a6548c6000000b00405176f695cmr760379pgs.295.1655862140996;
        Tue, 21 Jun 2022 18:42:20 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tpMs24CCQ09cC0i+G80gH/fTJupDuacqcUW0h6Ke2QAEljqhKBg0+WsolAoHSt94QZuuqzGg==
X-Received: by 2002:a65:48c6:0:b0:405:176f:695c with SMTP id o6-20020a6548c6000000b00405176f695cmr760363pgs.295.1655862140701;
        Tue, 21 Jun 2022 18:42:20 -0700 (PDT)
Received: from famine.localdomain ([50.125.80.157])
        by smtp.gmail.com with ESMTPSA id n18-20020a639712000000b0040cb1f55391sm5288280pge.2.2022.06.21.18.42.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jun 2022 18:42:20 -0700 (PDT)
Received: by famine.localdomain (Postfix, from userid 1000)
        id AE2D76227E; Tue, 21 Jun 2022 18:42:19 -0700 (PDT)
Received: from famine (localhost [127.0.0.1])
        by famine.localdomain (Postfix) with ESMTP id A558DA0B36;
        Tue, 21 Jun 2022 18:42:19 -0700 (PDT)
From:   Jay Vosburgh <jay.vosburgh@canonical.com>
To:     Jakub Kicinski <kuba@kernel.org>
cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Jonathan Toppins <jtoppins@redhat.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net] veth: Add updating of trans_start
In-reply-to: <20220621125233.1d36737b@kicinski-fedora-PC1C0HJN>
References: <9088.1655407590@famine> <20220617084535.6d687ed0@kernel.org> <5765.1655484175@famine> <20220617124413.6848c826@kernel.org> <28607.1655512063@famine> <20220617175550.6a3602ab@kernel.org> <20220621125233.1d36737b@kicinski-fedora-PC1C0HJN>
Comments: In-reply-to Jakub Kicinski <kuba@kernel.org>
   message dated "Tue, 21 Jun 2022 12:52:39 -0700."
X-Mailer: MH-E 8.6+git; nmh 1.6; Emacs 29.0.50
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <15666.1655862139.1@famine>
Date:   Tue, 21 Jun 2022 18:42:19 -0700
Message-ID: <15667.1655862139@famine>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:

>On Fri, 17 Jun 2022 17:55:50 -0700 Jakub Kicinski wrote:
>> > >I presume it needs it to check if the device has transmitted anything
>> > >in the last unit of time, can we look at the device stats for LLTX for
>> > >example?    
>> > 
>> > 	Yes, that's the use case.  
>> > 
>> > 	Hmm.  Polling the device stats would likely work for software
>> > devices, although the unit of time varies (some checks are fixed at one
>> > unit, but others can be N units depending on the missed_max option
>> > setting).
>> > 
>> > 	Polling hardware devices might not work; as I recall, some
>> > devices only update the statistics on timespans on the order of seconds,
>> > e.g., bnx2 and tg3 appear to update once per second.  But those do
>> > update trans_start.  
>> 
>> Right, unfortunately.
>> 
>> > 	The question then becomes how to distinguish a software LLTX
>> > device from a hardware LLTX device.  
>> 
>> If my way of thinking about trans_start is correct then we can test 
>> for presence of ndo_tx_timeout. Anything that has the tx_timeout NDO
>> must be maintaining trans_start.
>
>So what's your thinking Jay? Keep this as an immediate small fix 
>for net but work on using a different approach in net-next?

	Sorry, was out for the three day weekend.

	I had a quick look and I think you're probably right that
anything with a ndo_tx_timeout will deal with trans_start, and anything
without ndo_tx_timeout will be a software device not subject to delayed
batching of stats updates.

	And, yes, if there are no objections, what I'd like to do now is
apply the veth change to get things working and work up the bifurcated
approach separately (which would ultimately include removing the
trans_start updates from veth and tun).

	-J

---
	-Jay Vosburgh, jay.vosburgh@canonical.com
