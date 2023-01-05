Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C07B065F4CD
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbjAETtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:49:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235623AbjAETtI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:49:08 -0500
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A1314D29
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:49:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=ZPAJpktGi1Jn3rG2s8q6Y74LtZPgwU7fcPfe6RJB0Z0=; b=KrPAANbzr+ItEgn3XmwYo69yP/
        gCSf4Qi0kSCow4FBC5hVpuljqxOSIl08jWMdPzu9J7ML8Gd2tZ8lEknpO5DOphrpsPhYBKeLEm1x3
        buY7SKx71NTt3TIq8W9lY9OWCe0BkXtwUu/QoZAUtELZb/wb22VelpjX4/hFKFDGeBMw=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDWER-0005tA-In; Thu, 05 Jan 2023 20:48:55 +0100
Message-ID: <cbffa3fd-b095-2c87-2a5a-dcbab553b0af@engleder-embedded.com>
Date:   Thu, 5 Jan 2023 20:48:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 1/9] tsnep: Use spin_lock_bh for TX
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-2-gerhard@engleder-embedded.com>
 <79d2e66a-3633-ff3a-bdfd-656c735c85e0@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <79d2e66a-3633-ff3a-bdfd-656c735c85e0@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.01.23 13:40, Alexander Lobakin wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> Date: Wed Jan 04 2023 20:41:24 GMT+0100
> 
>> TX processing is done only within process or BH context. Therefore,
>> _irqsafe variant is not necessary.
> 
> NAPI and .ndo_{start,xdp}_xmit are BH-only, where can the process
> context happen here?

I will remove the process context from the description.

Gerhard
