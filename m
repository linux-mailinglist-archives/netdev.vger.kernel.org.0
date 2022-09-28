Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B21C55ED2A3
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 03:27:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiI1B1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 21:27:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232346AbiI1B1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 21:27:52 -0400
Received: from mail-vk1-xa62.google.com (mail-vk1-xa62.google.com [IPv6:2607:f8b0:4864:20::a62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E988B1D624F
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:27:51 -0700 (PDT)
Received: by mail-vk1-xa62.google.com with SMTP id g85so5758692vkf.10
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 18:27:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:message-id:subject:cc:to:from:date
         :dkim-signature:x-gm-message-state:from:to:cc:subject:date;
        bh=Qz5cZ1dKHpFe+uznEPT4rkoMBo9Ge3E30XeFeUWy5mE=;
        b=1olaXEXvtPa8naFfplFO7fQXP/jDklWLA99g44V1pdtWU4OtrTkYqUO20IWJTVQ5eZ
         m+ZpdmBc9vgw03Y+ABHLVUww4oMC9TCBkpdAuqAsmMnJvE4YMC67VJzC1/KfqgJ+p9Pd
         FkkxjrK01tR8BeShpjxs9h4uk++B0c+Z5yY7V2D2EHXc3HTwzZv6HuxzCTtpKP4WA90f
         x9s4XmKavEg5ElA8k3+YrSQhN6jIYiWJ8YrIdralaZ7LcBAs2996JxIkW2ljipjh+G9k
         iu/bwZVDYDBM+besRyigbV+MzOsppASoweghLBHiMMeVDDjKJbnwRplQPXSNhC+vkeiY
         ZEgg==
X-Gm-Message-State: ACrzQf10vcfXbrfyZ64NLqYNlipImvyPr3i+9rSz5gTYq7RK0kKe5Foz
        wA0i4P/Ltiyzf30C3VyTBjJGeI7mU9GzGXFl8zQ+GnAoPi6P
X-Google-Smtp-Source: AMsMyM67kpBezgFODbSEU45KeVvN4UIgvuZwRllusRhb56QOMtF8EaFCaLlbwLW/2jMzUhV/hUQOSnVAFf3O
X-Received: by 2002:a05:6122:91e:b0:3a2:e497:2484 with SMTP id j30-20020a056122091e00b003a2e4972484mr12793883vka.41.1664328471019;
        Tue, 27 Sep 2022 18:27:51 -0700 (PDT)
Received: from smtp.aristanetworks.com (smtp.aristanetworks.com. [52.0.43.43])
        by smtp-relay.gmail.com with ESMTPS id j189-20020a1fd2c6000000b003a4a4c7dc91sm320320vkg.9.2022.09.27.18.27.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Sep 2022 18:27:51 -0700 (PDT)
X-Relaying-Domain: arista.com
Received: from chmeee (unknown [10.95.71.70])
        by smtp.aristanetworks.com (Postfix) with ESMTPS id 465A430000AD;
        Tue, 27 Sep 2022 18:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arista.com;
        s=Arista-B; t=1664328469;
        bh=Qz5cZ1dKHpFe+uznEPT4rkoMBo9Ge3E30XeFeUWy5mE=;
        h=Date:From:To:Cc:Subject:From;
        b=E16SIa4lYOPZo3XnRkH0LzvPn3MnnOt1gbxBIZFiC8tRowFKa75tR/WZqeuIpnCSQ
         dlRwL4ziIBBOeCqTHx79NOAVVL4SmpO6L18IAx+sqz+EC1SETjSPPWoUTSRQXtE7X7
         dc8mrs/W8NbfwT18dHxHCFw26wQmH/8/5gz8N6Do=
Received: from kevmitch by chmeee with local (Exim 4.96)
        (envelope-from <kevmitch@arista.com>)
        id 1odLrX-000QfB-1L;
        Tue, 27 Sep 2022 18:27:47 -0700
Date:   Tue, 27 Sep 2022 18:27:46 -0700
From:   Kevin Mitchell <kevmitch@arista.com>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: new warning caused by ("net-sysfs: update the queue counts in the
 unregistration path")
Message-ID: <YzOjEqBMtF+Ib72v@chmeee>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

With the inclusion of d7dac083414e ("net-sysfs: update the queue counts in the
unregistration path"), we have started see the following message during one of
our stress tests that brings an interface up and down while continuously
trying to send out packets on it:

et3_11_1 selects TX queue 0, but real number of TX queues is 0

It seems that this is a result of a race between remove_queue_kobjects() and
netdev_cap_txqueue() for the last packets before setting dev->flags &= ~IFF_UP
in __dev_close_many(). When this message is displayed, netdev_cap_txqueue()
selects queue 0 anyway (the noop queue at this point). As it did before the
above commit, that queue (which I guess is still around due to reference
counting) proceeds to drop the packet and return NET_XMIT_CN. So there doesn't
appear to be a functional change. However, the warning message seems to be
spurious if not slightly confusing.

I'm not exactly sure what the fix for this should be or if there should be
one. In the meantime, we have ignored this message for this test, but was
wondering if there weren't any ideas for a better solution.

Thanks,
Kevin
