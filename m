Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2069D158
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 17:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbjBTQa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 11:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjBTQa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 11:30:57 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA00E1E9DB;
        Mon, 20 Feb 2023 08:30:55 -0800 (PST)
Message-ID: <ad25cce1-108c-76b0-fd46-739603e87d1c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676910654;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aEm/TNJLORpqvWwjmQACQjom/ytGLcd9sIrUwioF51U=;
        b=P1DQ/S9HKivBza7+HzkOmQCpK9GE8H/BxfPsK1CyoZpB3O1ygnXPW/MgHmvjuAvuXU52y7
        ZeRCQW1VgK4MXIrxKAJdX77t8E5KtcQokjiiFXyt9qCnQDReVySgLzjpHM+TKjx/EeY2ge
        stICyYiQ7pQbCQVPAiR3QL0uC14KT08=
Date:   Mon, 20 Feb 2023 16:30:50 +0000
MIME-Version: 1.0
Subject: Re: [PATCH v2] bnx2: remove deadcode in bnx2_init_cpus()
Content-Language: en-US
To:     Leon Romanovsky <leon@kernel.org>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>
Cc:     Rasesh Mody <rmody@marvell.com>, GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230219152225.3339-1-korotkov.maxim.s@gmail.com>
 <Y/Mv4nhHLq2Ms8d4@unreal>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <Y/Mv4nhHLq2Ms8d4@unreal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/02/2023 08:31, Leon Romanovsky wrote:
> On Sun, Feb 19, 2023 at 06:22:25PM +0300, Maxim Korotkov wrote:
>> The load_cpu_fw function has no error return code
>> and always returns zero. Checking the value returned by
>> this function does not make sense.
>> As a result, bnx2_init_cpus() will also return only zero
>> Therefore, it will be safe to change the type of functions
>> to void and remove checking
>>
>> Found by Security Code and Linux Verification
>> Center (linuxtesting.org) with SVACE
>>
>> Fixes: 57579f7629a3 ("bnx2: Use request_firmware()")
>> Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
>> ---
>> changes v2:
>> - bnx2_init_cpu_fw() and bnx2_init_cpus() are void
>> - delete casts to void
>> - remove check of bnx2_init_cpus() in bnx2_init_chip()
>>
> 
> Thanks,
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>

Not sure if it should go to -net, because it doesn't actually fix any
bug, more like refactoring which goes to -next, I believe.
