Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E2326DFCD8
	for <lists+netdev@lfdr.de>; Wed, 12 Apr 2023 19:42:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbjDLRmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 13:42:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229491AbjDLRmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 13:42:20 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8673461BE
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:42:19 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id eo6-20020a05600c82c600b003ee5157346cso8570495wmb.1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 10:42:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681321338; x=1683913338;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=soabvj1bkWYq/KO12QcQAr2XxwzwHokfn17ovhqehlY=;
        b=jVEGvITUOFNu9TXUOWiehzx0KM7+eogeqtLD8/T44mtHvEiRcxz0J7mNMgArAobT8Q
         SVF53cqOsC2fexUiujPSNlRxZmLWt0a1ZmOpOixWtXX0npC5cfZPiUuy4k0vIpTmyLfS
         2oI5XjYInRppJBoq0S8FysFAjTNWaqOCQFXLvBcxWFQJHBBH2OoWjupOmNLFb1PkQ2e1
         f1UDMD7vimv9sM83TqE9sWJH1cxHbqBe0qQsNDJmqkzqu7QPDR1tjnHw9brTalwMqySk
         GxLHsCFurfbRnCBxd8YlyIOE2TjGigvvCkx+UUp41MhcW11QzU3i8nU/vb1v7xK29U+M
         zISg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681321338; x=1683913338;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=soabvj1bkWYq/KO12QcQAr2XxwzwHokfn17ovhqehlY=;
        b=Onb76fzKkinhzz+K5x+25QgB1K+jCmC1fYtE45J8FZED+A1uMqLxxfTgNaXXnWsN/P
         OTMBTJttqdwolh+fWaiSpg2q5anePp80Wa7rHBrCf3F+Y9qtYoWuWdqAJ6NpWkT5Wti+
         2YPsAmEPpZMAyJ6xC0erIOFfcwTt1u/zoJcsNYJ5+0VJcGdDdS0O/ecYNB1dVuIHkWMJ
         2sep28ib24nYNsL66iEL6caAabM4XKut9e6mMAW4p1SBlc8BYlrY3qZYLamTAi4xJN23
         OxfEmONhtsv19fayMkFzraA3gwO9WlKgYyBG7SUlSlWpVlkiQAETCpe8Y6LLqBGePZXw
         ElTA==
X-Gm-Message-State: AAQBX9end4Q4HMHPYB9g6ATHKMNmgFb5PQPpkvr/qm/siNLY6iIL/lhb
        kH5HekoyIQaIDuIfU1TxcTk=
X-Google-Smtp-Source: AKy350Y0Oi50Wq9QGWmUBzwNZ8Ssicby/m95wH0LaIJXnpay1tJoZ6mCXFZyjpdiN7IOpsBtBWCUVQ==
X-Received: by 2002:a7b:cc8d:0:b0:3ee:672d:caa5 with SMTP id p13-20020a7bcc8d000000b003ee672dcaa5mr2370559wma.17.1681321337921;
        Wed, 12 Apr 2023 10:42:17 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id iz11-20020a05600c554b00b003f09aaf547asm4300487wmb.1.2023.04.12.10.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 10:42:17 -0700 (PDT)
Subject: Re: [RFC PATCH v2 net-next 6/7] net: ethtool: add a mutex protecting
 RSS contexts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     edward.cree@amd.com, linux-net-drivers@amd.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1681236653.git.ecree.xilinx@gmail.com>
 <9e2bcb887b5cf9cbb8c0c4ba126115fe01a01f3f.1681236654.git.ecree.xilinx@gmail.com>
 <ea711ae7-c730-4347-a148-0602c69c9828@lunn.ch>
 <69612358-2003-677a-80a2-5971dc026646@gmail.com>
 <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <3623a7f3-6f90-8570-5b9a-10ff56cc04e5@gmail.com>
Date:   Wed, 12 Apr 2023 18:42:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <61041c56-f7d2-49f8-9fc3-57852a96105a@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/04/2023 18:15, Andrew Lunn wrote:
> I have to wonder if your locking model is wrong. When i look at the
> next patch, i see the driver is also using this lock. And i generally
> find that is wrong.
...
> Drivers writers should not need to worry about locking. The API
> into the driver will take the locks needed before entering the driver,
> and release them on exit.
I don't think that's possible without increasing driver complexity in
 other ways.  Essentially, for the driver to take advantage of the core
 tracking these contexts, and thus not need its own data structures to
 track them as well (like the efx->rss_context.list we remove in patch
 #7), it has to be able to access them on driver-initiated (not just
 core-initiated) events.  (The central example of this being "oh, the
 NIC MCPU just rebooted, we have to reinstall all our filters".)  And
 it needs to be able to exclude writes while it does that, not only for
 consistency but also because e.g. context deletion will free that
 memory (though I guess we could finesse that part with RCU?).
What I *could* do is add suitable wrapper functions for access to
 dev->ethtool->rss_ctx (e.g. a core equivalent of
 efx_find_rss_context_entry() that wraps the idr_find()) and have them
 assert that the lock is held (like efx_find_rss_context_entry() does);
 that would at least validate the driver locking somewhat.
But having those helper functions perform the locking themselves would
 mean going to a get/put model for managing the lifetime of the
 driver's reference (with a separate get_write for exclusive access),
 at which point it's probably harder for driver writers to understand
 than "any time you're touching rss_ctx you need to hold the rss_lock".

-ed
