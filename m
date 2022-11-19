Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10AE6310F9
	for <lists+netdev@lfdr.de>; Sat, 19 Nov 2022 21:46:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234911AbiKSUqk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Nov 2022 15:46:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiKSUqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Nov 2022 15:46:39 -0500
Received: from mx10lb.world4you.com (mx10lb.world4you.com [81.19.149.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBAA13D25
        for <netdev@vger.kernel.org>; Sat, 19 Nov 2022 12:46:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=frSB2yXTaj9uGu8EipcAL0nCY6i1dBrprm0/VeJk+IU=; b=QQikPfHRTbiTAydYoy9WrYLcNf
        gD1ocXg0ziOxyamJSpQrTkKbi9zSViHdZTVERTN/kZxIpHnAHZB7mkfI9JiWyiPqknJzL5JoJjXtf
        xJqLD74x/k4G8A+C4M++lbDdcXaOEK8xl6e4sF3cgCp/1DVqNzqqNxjbdt12uv08b2KA=;
Received: from [88.117.56.227] (helo=[10.0.0.160])
        by mx10lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1owUjS-0006NX-9K; Sat, 19 Nov 2022 21:46:34 +0100
Message-ID: <8ede7314-c0a0-5160-5a03-aef9ddd620f3@engleder-embedded.com>
Date:   Sat, 19 Nov 2022 21:46:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next 1/4] tsnep: Throttle interrupts
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
References: <20221117201440.21183-1-gerhard@engleder-embedded.com>
 <20221117201440.21183-2-gerhard@engleder-embedded.com>
 <20221118172421.01644d5a@kernel.org>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <20221118172421.01644d5a@kernel.org>
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

On 19.11.22 02:24, Jakub Kicinski wrote:
> On Thu, 17 Nov 2022 21:14:37 +0100 Gerhard Engleder wrote:
>> Without interrupt throttling, iperf server mode generates a CPU load of
>> 100% (A53 1.2GHz). Also the throughput suffers with less than 900Mbit/s
>> on a 1Gbit/s link. The reason is a high interrupt load with interrupts
>> every ~20us.
>>
>> Reduce interrupt load by throttling of interrupts. Interrupt delay is
>> configured statically to 64us. For iperf server mode the CPU load is
>> significantly reduced to ~20% and the throughput reaches the maximum of
>> 941MBit/s. Interrupts are generated every ~140us.
> 
> User should be able to control these settings, please implement
> ethtool::get_coalesce / set_coalesce.

I will implement it.
