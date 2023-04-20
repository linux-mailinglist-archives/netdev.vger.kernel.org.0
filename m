Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45C936E9BD1
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 20:41:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjDTSk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 14:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDTSk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 14:40:58 -0400
Received: from mx04lb.world4you.com (mx04lb.world4you.com [81.19.149.114])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02AD4D8;
        Thu, 20 Apr 2023 11:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=eo7EWGqoQIEk6OAIa+6tsmwmaAE3icssflkxmNu7opc=; b=XM2NQxKCyNUaZeTuJKdwpg4zP/
        NTcytP5TffcMNnu3XVk2p3b3wQartNTXC70VLOe0fks5f9EUmdyANiMqYdW+bOESDf0d6980C2+mD
        kKp5xxTUKPl3bWKUwuvuQejXQXrpOWhHWwG56ReCmiVddsKMRT2emtZdnX/3Gzv/umUo=;
Received: from [88.117.57.231] (helo=[10.0.0.160])
        by mx04lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1ppZDB-0003AB-D6; Thu, 20 Apr 2023 20:40:53 +0200
Message-ID: <1feb69c9-f9a0-900d-459c-8363f4901e01@engleder-embedded.com>
Date:   Thu, 20 Apr 2023 20:40:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 1/6] tsnep: Replace modulo operation with mask
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        bjorn@kernel.org, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
References: <20230418190459.19326-1-gerhard@engleder-embedded.com>
 <20230418190459.19326-2-gerhard@engleder-embedded.com>
 <ZEFKzuPKGRv0bO35@boxer>
Content-Language: en-US
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <ZEFKzuPKGRv0bO35@boxer>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.04.23 16:23, Maciej Fijalkowski wrote:
> On Tue, Apr 18, 2023 at 09:04:54PM +0200, Gerhard Engleder wrote:
>> TX/RX ring size is static and power of 2 to enable compiler to optimize
>> modulo operation to mask operation. Make this optimization already in
>> the code and don't rely on the compiler.
> 
> I think this came out of my review, so:
> Suggested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

Sorry, I forgot to add it.

> Does this give you a minor perf boost?

I will try to measure some difference.
