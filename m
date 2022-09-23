Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EE325E8297
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 21:33:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232659AbiIWTdq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 15:33:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231409AbiIWTdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 15:33:45 -0400
Received: from mx12lb.world4you.com (mx12lb.world4you.com [81.19.149.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBDB912E431;
        Fri, 23 Sep 2022 12:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=yJ45+8Twh5W55TqVWVz1itS37M0JIDKK1FAg1rHdr8A=; b=YYLe3tPc749xYqzNECnBOyUWG/
        WVUXik+s++BbAqgNKSY72bg0qSq3OXazKeeLAy6WC/NGw0A2OH/rOPofVC3fj6SPGMDxXUzyU3nyy
        6MT7eUgzSf7+puJqGA2hbJx3YN9Y7BkV8JGwmyNIHnmqfSYlHmOzSDsppin+fsc8qm+I=;
Received: from [88.117.54.199] (helo=[10.0.0.160])
        by mx12lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oboQf-0002xy-3g; Fri, 23 Sep 2022 21:33:41 +0200
Message-ID: <cf75ebb5-c8ab-ed41-9256-57a55b2d18da@engleder-embedded.com>
Date:   Fri, 23 Sep 2022 21:33:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 7/7] tsnep: Rework RX buffer allocation
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
 <20220915203638.42917-8-gerhard@engleder-embedded.com>
 <20220921180152.002dea73@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20220921180152.002dea73@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 22.09.22 03:01, Jakub Kicinski wrote:
> On Thu, 15 Sep 2022 22:36:37 +0200 Gerhard Engleder wrote:
>> Try to refill RX queue continously instead of dropping frames if
>> allocation fails. This seems to be the more common pattern for network
>> drivers and makes future XDP support simpler.
> 
> Is there anything preventing the queue from becoming completely empty
> and potentially never getting refilled?
> 
> The lazy refill usually comes with some form of a watchdog / periodic
> depletion check.

You are right, I need to improve that. I will remove that commit for
now and rework it.
