Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD1F65F4D7
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 20:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234591AbjAETy0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 14:54:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234650AbjAETyI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 14:54:08 -0500
Received: from mx07lb.world4you.com (mx07lb.world4you.com [81.19.149.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADA6C1658B
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 11:54:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=k/p0yLK6D6TGPkzIUMcM6wiLlUR8nXm2NmHlsljmjpQ=; b=S+x4jLVnKie5kKbfHbmuWa7bas
        sWTW0NcpcFuAMcdG3yxaFTIr4UbeqiG6o79j56C13Pc7v+qzBK5/l+GNs5o4hHdyjWEsa90pfXvl9
        dXCeqPU5XTV4plwp7NFrKIPscvxtkEBrk8SHVEx25j5xmkgALEF4Pg58DLKXqYnUstHI=;
Received: from [88.117.53.17] (helo=[10.0.0.160])
        by mx07lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1pDWJN-0006hq-45; Thu, 05 Jan 2023 20:54:01 +0100
Message-ID: <c360e1b2-5ea0-44b5-1e66-cf8101744ac8@engleder-embedded.com>
Date:   Thu, 5 Jan 2023 20:54:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v3 3/9] tsnep: Add adapter down state
Content-Language: en-US
To:     Alexander Lobakin <alexandr.lobakin@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org
References: <20230104194132.24637-1-gerhard@engleder-embedded.com>
 <20230104194132.24637-4-gerhard@engleder-embedded.com>
 <3747ac7a-2901-4d2c-8227-3e3bf34633ed@intel.com>
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
In-Reply-To: <3747ac7a-2901-4d2c-8227-3e3bf34633ed@intel.com>
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

On 05.01.23 13:44, Alexander Lobakin wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> Date: Wed Jan 04 2023 20:41:26 GMT+0100
> 
>> Add adapter state with flag for down state. This flag will be used by
>> the XDP TX path to deny TX if adapter is down.
>>
>> Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
>> ---
>>   drivers/net/ethernet/engleder/tsnep.h      |  1 +
>>   drivers/net/ethernet/engleder/tsnep_main.c | 11 +++++++++++
>>   2 files changed, 12 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/engleder/tsnep.h b/drivers/net/ethernet/engleder/tsnep.h
>> index f93ba48bac3f..f72c0c4da1a9 100644
>> --- a/drivers/net/ethernet/engleder/tsnep.h
>> +++ b/drivers/net/ethernet/engleder/tsnep.h
>> @@ -148,6 +148,7 @@ struct tsnep_adapter {
>>   	phy_interface_t phy_mode;
>>   	struct phy_device *phydev;
>>   	int msg_enable;
>> +	unsigned long state;
> 
> Now there will be a 4-byte hole in between ::msg_enable and ::state,
> maybe add ::state right after ::phydev?

I will do that.

Gerhard
