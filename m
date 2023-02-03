Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 715176899DD
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 14:36:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbjBCNgu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 08:36:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBCNgt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 08:36:49 -0500
Received: from nbd.name (nbd.name [46.4.11.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B72030D0;
        Fri,  3 Feb 2023 05:36:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
        s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:Cc:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=jxT0yUI20l6x1hGO/soHk0H1JmfQR0mHTZY9GctczLo=; b=mXxLRSUnBY4yYRxu0TGXvCkv1N
        CRquBHGC+RyW8jSaMoDlMXb6H767isgwnmL237y4eGt9Reuf7dZKQq2VoebIW9aiQTg/+62XbkVW2
        jUHLRRfXAuOVs6AWz6QX7ak/XIluk4P+yahbsQNSnkxhFnakvEV/5OZDyEG6i01CVUek=;
Received: from p200300daa717ad088514d6b2ab605d8d.dip0.t-ipconnect.de ([2003:da:a717:ad08:8514:d6b2:ab60:5d8d] helo=nf.local)
        by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <nbd@nbd.name>)
        id 1pNwF5-004hYx-1K; Fri, 03 Feb 2023 14:36:39 +0100
Message-ID: <17e91542-25fc-97e1-46a8-86d219dfe545@nbd.name>
Date:   Fri, 3 Feb 2023 14:36:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.6.1
Subject: Re: [PATCH net-next v2] net: page_pool: use in_softirq() instead
Content-Language: en-US
To:     Qingfang DENG <dqfext@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230203011612.194701-1-dqfext@gmail.com>
From:   Felix Fietkau <nbd@nbd.name>
In-Reply-To: <20230203011612.194701-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.02.23 02:16, Qingfang DENG wrote:
> From: Qingfang DENG <qingfang.deng@siflower.com.cn>
> 
> We use BH context only for synchronization, so we don't care if it's
> actually serving softirq or not.
> 
> As a side node, in case of threaded NAPI, in_serving_softirq() will
> return false because it's in process context with BH off, making
> page_pool_recycle_in_cache() unreachable.
> 
> Signed-off-by: Qingfang DENG <qingfang.deng@siflower.com.cn>
Tested-by: Felix Fietkau <nbd@nbd.name>

