Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9FA55DEF0
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238482AbiF0Ttc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 15:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238616AbiF0Ttb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 15:49:31 -0400
Received: from alexa-out-sd-02.qualcomm.com (alexa-out-sd-02.qualcomm.com [199.106.114.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EB61BE8B
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 12:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1656359370; x=1687895370;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=p165C94D2pgy7ihGZficvwoMHXfbzXfhUYRZmWjYf2Q=;
  b=NL560lP/yiPC3i5m1RhOaWEBbObBsV/E2ukasaqhfk0A6ms9ehW6Nj24
   syGIfjLC0oKwQvrfElpwJiNlx1Kh85Y+zE5hhR8MMfDk90xPf5O3o/Zai
   mq5kodmmsepqLzk4BdPmTFI7Y7CDMmxU05hyaS+L9d+G5nJFeapA2Pry4
   s=;
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by alexa-out-sd-02.qualcomm.com with ESMTP; 27 Jun 2022 12:49:30 -0700
X-QCInternal: smtphost
Received: from nasanex01c.na.qualcomm.com ([10.47.97.222])
  by ironmsg04-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jun 2022 12:49:30 -0700
Received: from nalasex01a.na.qualcomm.com (10.47.209.196) by
 nasanex01c.na.qualcomm.com (10.47.97.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Mon, 27 Jun 2022 12:49:29 -0700
Received: from [10.110.66.114] (10.80.80.8) by nalasex01a.na.qualcomm.com
 (10.47.209.196) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.22; Mon, 27 Jun
 2022 12:49:28 -0700
Message-ID: <ad6f3fbc-9996-6fa7-2015-01832b013c98@quicinc.com>
Date:   Mon, 27 Jun 2022 13:49:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next v2] net: Print hashed skb addresses for all net
 and qdisc events
Content-Language: en-US
To:     Cong Wang <xiyou.wangcong@gmail.com>
CC:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <quic_jzenner@quicinc.com>, <cong.wang@bytedance.com>,
        <qitao.xu@bytedance.com>, <bigeasy@linutronix.de>,
        <rostedt@goodmis.org>, <mingo@redhat.com>,
        Sean Tranchetti <quic_stranche@quicinc.com>
References: <1656106465-26544-1-git-send-email-quic_subashab@quicinc.com>
 <YroGx7Wd2BQ28PjA@pop-os.localdomain>
From:   "Subash Abhinov Kasiviswanathan (KS)" <quic_subashab@quicinc.com>
In-Reply-To: <YroGx7Wd2BQ28PjA@pop-os.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nalasex01a.na.qualcomm.com (10.47.209.196)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/27/2022 1:36 PM, Cong Wang wrote:
> On Fri, Jun 24, 2022 at 03:34:25PM -0600, Subash Abhinov Kasiviswanathan wrote:
>> The following commits added support for printing the real address-
>> 65875073eddd ("net: use %px to print skb address in trace_netif_receive_skb")
>> 70713dddf3d2 ("net_sched: introduce tracepoint trace_qdisc_enqueue()")
>> 851f36e40962 ("net_sched: use %px to print skb address in trace_qdisc_dequeue()")
>>
>> However, tracing the packet traversal shows a mix of hashes and real
>> addresses. Pasting a sample trace for reference-
>>
>> ping-14249   [002] .....  3424.046612: netif_rx_entry: dev=lo napi_id=0x3 queue_mapping=0
>> skbaddr=00000000dcbed83e vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800
>> ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1
>> mac_header=-14 nr_frags=0 gso_size=0 gso_type=0x0
>> ping-14249   [002] .....  3424.046615: netif_rx: dev=lo skbaddr=ffffff888e5d1000 len=84
>>
>> Switch the trace print formats to %p for all the events to have a
>> consistent format of printing the hashed addresses in all cases.
>>
> 
> This is obscured...
> 
> What exactly is the inconsistency here? Both are apparently hex, from
> user's point of view. The only difference is one is an apparently
> invalid kernel address, the other is not. This difference only matters
> when you try to dereference it, but I don't think you should do it here,
> this is not a raw tracepoint at all. You can always use raw tracepoints
> to dereference it without even bothering whatever we print.
> 
> Thanks.

Matching skbs addresses (in a particular format) helps to track the 
packet traversal timings / delays in processing.
