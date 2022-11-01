Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB74614E82
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 16:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230180AbiKAPlS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229628AbiKAPlR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 11:41:17 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E43E15FF3
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 08:41:16 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id bk15so20658723wrb.13
        for <netdev@vger.kernel.org>; Tue, 01 Nov 2022 08:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1uler0/QWQ8bRsdvF6DxxegKbDUGa4DiZnighvU7ong=;
        b=Bbhf/oA/4XejucjIc9ffQqIwM+fwnO8KC0wN59k+U779DKo9nrwgv1K/m+KxMZYETI
         e8eAfGE1tTsxm7N+5CnR+p1sQY+65vO+2mesZI2QI65IgrKUUuNnZ86ptU55TRHaok1M
         PLSDeZldpbhsitO5NCWZ2nmxL2GL0CmJf5Brh4yddJFiQFtQvk8e4iaSOgnRBrhI9NDd
         KnmEYbdXErXBss9yTwxn/35p5LpcnyjRkSzwKmupTrm1GpIba02qYXOsDHK9B3NyIx1b
         W4Lv66Z6ChWoQ5ed/ZSUn/6ncEekkcF/Z5I6uA5y8OesiowVk7ZlK0gzUsPoOysujKXs
         wZyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1uler0/QWQ8bRsdvF6DxxegKbDUGa4DiZnighvU7ong=;
        b=ZI4xBX5ZCjc2taWC/mbAB6WQMTtsUu2bf2n6rGvy57ZdmcuMB6c2sYN35gISHVo59Y
         nUkBIoAhhvyc7eU64sioXcR74Pe9YnaKt7xl6+a8PPZZIkDIvx8Twi/GnKO96Zx3JajA
         B+u3auI8/XpMaMkS3/IwqcJKGNiU4I7PzGw3VMFhNQPZtcoRJdq2C0qy4L0EgTykcuUG
         o8yNam0QiK1S9yWKGTVvAxsXk3GW3d21MACzyr8b8/7qtM1tVy7OcjW48wwLnrwn8qfZ
         rycqbXWeeK11mfdLD6qmw7TMW+1nz8ht9IW1ovYfYJRlVjcUfleEVH7bqSCJVtmFIZiw
         Wbcw==
X-Gm-Message-State: ACrzQf0B5xDbXHEjMshxoSPDZnIaTc7QjN7LwhXpkBfRwEStEJl5ji0l
        DeFM3BP9qAKHr2B9MNJrVh8=
X-Google-Smtp-Source: AMsMyM62JtyhSmPPo2f+dPYsNPjDSZuwpHoC8e4/hLoGOJZDiIUMzTbkoZLGAJJMxgBzxOOvGIV5fg==
X-Received: by 2002:a5d:6d02:0:b0:232:4070:6026 with SMTP id e2-20020a5d6d02000000b0023240706026mr12297031wrq.33.1667317274686;
        Tue, 01 Nov 2022 08:41:14 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d8-20020a5d5388000000b0023672104c24sm10625447wrv.74.2022.11.01.08.41.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Nov 2022 08:41:14 -0700 (PDT)
Subject: Re: [PATCH net-next 1/5] sfc: check recirc_id match caps before MAE
 offload
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     edward.cree@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com
References: <cover.1666603600.git.ecree.xilinx@gmail.com>
 <d3da32136ba31c553fa267381eb6a01903525814.1666603600.git.ecree.xilinx@gmail.com>
 <20221025194035.7eb96c0a@kernel.org>
 <958764a5-8b2d-fe99-c59d-fbdddd53e0bc@gmail.com>
 <20221101082152.25b19c17@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <279a6644-4f3e-2ef3-2aa4-4463fbb9b8fc@gmail.com>
Date:   Tue, 1 Nov 2022 15:41:13 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20221101082152.25b19c17@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/11/2022 15:21, Jakub Kicinski wrote:
> On Tue, 1 Nov 2022 13:30:10 +0000 Edward Cree wrote:
>>> This commit made it to net, needs to go separately there.  
>>
>> Hmm I might just drop the fixes tag; the cited commit isn't really
>>  broken, just suboptimal.
> 
> Can you describe the current behavior is? Isn't the driver accepting
> rules it can't correctly offload?

The rule will pass the checks here, but then when we make the MCDI call
 to install it in hardware, MC_CMD_MAE_ACTION_RULE_INSERT will evoke an
 error response from the firmware, so the TC_SETUP_CLSFLOWER callback
 will ultimately return an error to the kernel as it should.
The advantage of having these checks in the driver is that we get a
 useful error message rather than just "Failed to insert rule in hw",
 and also save the round trip across the PCIe bus to firmware.
