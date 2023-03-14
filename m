Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCB136B9A47
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbjCNPsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:48:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjCNPsp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:48:45 -0400
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9C50B32A6
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:48:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678808897; x=1710344897;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=rhaZE0ztQk9buy0o9h/Ia9yHUDHNEezr1unI25pqdmU=;
  b=vujop9jB3UaXb0jl2GxgNIJ+d5Qy/JAtL/JgbdJ+xjDa5WwjsFog42Wl
   xIfJ51e8m5RAv8lNZRqZfGopLXzt0fstl9hn5DcigppeOhj70zcm42j4U
   qb2AokLsG1RWe4rdhmRS9PTRIQIuYORHR/PZzD41NPy95DvlJenCpuAe3
   s=;
X-IronPort-AV: E=Sophos;i="5.98,260,1673913600"; 
   d="scan'208";a="309027012"
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-6001.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 15:47:39 +0000
Received: from EX19D003EUA003.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-pdx-2b-m6i4x-f323d91c.us-west-2.amazon.com (Postfix) with ESMTPS id 088B040D7A;
        Tue, 14 Mar 2023 15:47:37 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D003EUA003.ant.amazon.com (10.252.50.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 14 Mar 2023 15:47:36 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 14 Mar 2023 15:47:27 +0000
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-2-shayagr@amazon.com>
 <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Gal Pressman <gal@nvidia.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Saeed Bshara" <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Date:   Tue, 14 Mar 2023 17:46:41 +0200
In-Reply-To: <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
Message-ID: <pj41zl7cvj2v3r.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D038UWB001.ant.amazon.com (10.13.139.148) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Gal Pressman <gal@nvidia.com> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> On 09/03/2023 15:13, Shay Agroskin wrote:
>> +``ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN`` specifies the maximum 
>> number of bytes of a
>> +transmitted packet a driver can push directly to the 
>> underlying device
>> +('push' mode). Pushing some of the payload bytes to the device 
>> has the
>> +advantages of reducing latency for small packets by avoiding 
>> DMA mapping (same
>> +as ``ETHTOOL_A_RINGS_TX_PUSH`` parameter) as well as allowing 
>> the underlying
>> +device to process packet headers ahead of fetching its 
>> payload.
>> +This can help the device to make fast actions based on the 
>> packet's headers.
> ...
>
> BTW, as I mentioned in v1, ENA doesn't advertise tx_push, which 
> is a bit
> strange given the fact that it now adds tx_push_buf_len support.

Yup you're right, sorry for missing it. I'll advertisement for 
tx_push support in next version
