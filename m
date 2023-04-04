Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33DBA6D6066
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 14:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234860AbjDDMcN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 08:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231344AbjDDMcM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 08:32:12 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735822D4B
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 05:32:08 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id v6-20020a05600c470600b003f034269c96so9716702wmo.4
        for <netdev@vger.kernel.org>; Tue, 04 Apr 2023 05:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680611526;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ylDrhbqVWDR6Y9Ng197oJFfgiiLsAds9Kew0sQ1WYg=;
        b=BaFleLTj+s49HYpa4BqeiyzpwCgkPl/87DbBeE67mF1+H4f04028CnVfRur4JVN43Y
         nTNWF2zhrEUSLWaYQ5BbQx1RJ4xiXfjtxZ3izdVM6KaK6GBfcnNGMRTQKY/CCQMqfpcK
         UnRxqgUeq2TMKZuu4fq9IbfiBVaoFYaWpM63L1/h31TmwNvZEKjBqzrKv/qBU1+MM53r
         +CMOgERyGsgcpxJVV8dT3aZh81GL/bX12u69cLPH78HqwtQN9B/y4o4BI7MoJluYDx/0
         Ko1euUP+9N6WF1fnK5MOLEPLjIJQatSKh2NH6L0OreOJG7wn0SplPwtdHgliD2FmvAgf
         /iUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680611526;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4ylDrhbqVWDR6Y9Ng197oJFfgiiLsAds9Kew0sQ1WYg=;
        b=yeXWZdA6sLWi/rjCc2Ygo8iqLZUjSj6JXaGl1yM0TKnae2LuSqbLPm3NOR0KC14nfK
         U9Gdv1zGlLVGPKO8BWHhWbMTzWbpyxT6c2bMjpUqohVWLVYZ6ipAzDnhMhZc9DkqLwoa
         39DRL5jiAwn1F0oLTd976YhCroGV+3yQRYkGW7QGou6dQTvPyfm8GoohdTNTgMxFRmvG
         x8MPXHrIhP+32N9ggfGYeN+6YyAA5UTXJ/L4LXQwLudc0b+CjAB/205UXwLSDru1Fj/u
         gXr2jCp+meolpOBH/fddZpFOJo49TKWTa5KPCqE+q7rPiumDUf0ylNaN9dg9q3GR4bIu
         +ENQ==
X-Gm-Message-State: AAQBX9fYKVtSqw4wIWBMwl30try20BKjpjC9CYJ6ffbYNednhzNZaZqz
        kbj7rZoUq/HOBrCwucIeMJg=
X-Google-Smtp-Source: AKy350YJ/8caJCZgGfRnsSFkbi7td3kjuH6hNzvCg2vKW07j1V4U/beYCEZISqV2PI2Nj1pZlGVMzA==
X-Received: by 2002:a05:600c:2312:b0:3ed:2b27:5bcc with SMTP id 18-20020a05600c231200b003ed2b275bccmr2095897wmo.38.1680611526604;
        Tue, 04 Apr 2023 05:32:06 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d14-20020a5d4f8e000000b002d1bfe3269esm12196967wru.59.2023.04.04.05.32.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 05:32:05 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 5/6] net: ethtool: add a mutex protecting RSS
 contexts
To:     Jakub Kicinski <kuba@kernel.org>, edward.cree@amd.com
Cc:     linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        habetsm.xilinx@gmail.com, sudheer.mogilappagari@intel.com
References: <cover.1680538846.git.ecree.xilinx@gmail.com>
 <255a20efdbbaa1cd26f3ae1baf4a3379bf63aa5e.1680538846.git.ecree.xilinx@gmail.com>
 <20230403150312.79174a7e@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <9536914b-0254-23e4-de6d-a936a50129b0@gmail.com>
Date:   Tue, 4 Apr 2023 13:32:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230403150312.79174a7e@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03/04/2023 23:03, Jakub Kicinski wrote:
> On Mon, 3 Apr 2023 17:33:02 +0100 edward.cree@amd.com wrote:
>>  	u32			rss_ctx_max_id;
>>  	struct idr		rss_ctx;
>> +	struct mutex		rss_lock;
> 
> Argh, the mutex doubles the size of the state, and most drivers don't
> implement this feature.  My thinking was to add a "ethtool state"> pointer to net_device which will be allocated by ethtool on demand
> and can hold all ethtool related state.

Would any other existing net_device fields go in this struct, or is
 it just the RSS stuff so far?
