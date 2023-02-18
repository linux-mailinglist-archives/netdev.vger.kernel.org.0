Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E07AF69BAE1
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 17:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjBRQNY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 11:13:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBRQNX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 11:13:23 -0500
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B92EB58;
        Sat, 18 Feb 2023 08:13:22 -0800 (PST)
Message-ID: <62832516-d4b9-add6-4925-1caeaa33d167@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676736800;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4AGRsWNnZ3I51W4RCVYcNG1MNaQ/qy5knYIrxHe13ds=;
        b=Bf5iJJKiNawUijBorJDBGPLXdR7BtD42HaI/alLcCv6De1uyT+VsID+3fErzOI/THiVlS/
        Iqj4pt8czOiUo/PIRiosTuGADJNu0kyxUTKoxWh05yOFq8tdOs86nW8ebUTLxRU6LZcZ/h
        rwJO+ffDG8DI1NnMoLv0hCydJsF86WI=
Date:   Sat, 18 Feb 2023 16:13:19 +0000
MIME-Version: 1.0
Subject: Re: [PATCH] bnx2: remove deadcode in bnx2_init_cpus()
Content-Language: en-US
To:     Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        Rasesh Mody <rmody@marvell.com>
Cc:     GR-Linux-NIC-Dev@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Michael Chan <mchan@broadcom.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230218130016.42856-1-korotkov.maxim.s@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230218130016.42856-1-korotkov.maxim.s@gmail.com>
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

On 18.02.2023 13:00, Maxim Korotkov wrote:
> The load_cpu_fw function has no error return code
> and always returns zero. Checking the value returned by
> this function does not make sense.
> As a result, bnx2_init_cpus will also return only zero
> 
In this case it's safe to convert both load_cpu_fw and bnx2_init_cpus to void 
and remove the check in bnx2_init_chip. This will reduce the code a bit.


