Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BFA6B9A33
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 16:46:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCNPqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 11:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbjCNPqe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 11:46:34 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169569065
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 08:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678808765; x=1710344765;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=b8m7nO0Bmp5ymxlCAIQHK+OML+5cZteC5meaEPmcKCM=;
  b=kIqPMTdHgFVDKgVsAdVcVe/gH082b3rErxqTBm8XOqk6H/xAZPzyAMVH
   G5nBkJmyziHdS+0N4t23zP62cX9TIEemlykBRj23aOwVZMHU7LgJx+NYP
   Mu0RKdIeHjgSBTl0cuc87K+J5f9h28jmKRhYJA7JgAv7XtmnYPeo4o7HW
   k=;
X-IronPort-AV: E=Sophos;i="5.98,260,1673913600"; 
   d="scan'208";a="1112552210"
Subject: Re: [PATCH v4 net-next 1/5] ethtool: Add support for configuring
 tx_push_buf_len
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 15:45:40 +0000
Received: from EX19D014EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-ed19f671.us-west-2.amazon.com (Postfix) with ESMTPS id 31F79819CD;
        Tue, 14 Mar 2023 15:45:40 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D014EUA001.ant.amazon.com (10.252.50.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 14 Mar 2023 15:45:39 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.174) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Tue, 14 Mar 2023 15:45:30 +0000
References: <20230309131319.2531008-1-shayagr@amazon.com>
 <20230309131319.2531008-2-shayagr@amazon.com>
 <316ee596-e184-8613-d136-cd2cb13a589f@nvidia.com>
 <20230309225326.2976d514@kernel.org>
 <d438ef12-86f8-7415-4690-3e378ac1048f@nvidia.com>
 <20230313120942.75599b8e@kernel.org>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>, David Miller <davem@davemloft.net>,
        <netdev@vger.kernel.org>, "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
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
Date:   Tue, 14 Mar 2023 17:38:23 +0200
In-Reply-To: <20230313120942.75599b8e@kernel.org>
Message-ID: <pj41zlbkkv2v6z.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.174]
X-ClientProxiedBy: EX19D039UWA004.ant.amazon.com (10.13.139.68) To
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


Jakub Kicinski <kuba@kernel.org> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> On Sun, 12 Mar 2023 14:41:39 +0200 Gal Pressman wrote:
>> On 10/03/2023 8:53, Jakub Kicinski wrote:
>> > On Thu, 9 Mar 2023 19:15:43 +0200 Gal Pressman wrote:
>> >> I know Jakub prefers the new parameter, but the description 
>> >> of this
>> >> still sounds extremely similar to TX copybreak to me..
>> >> TX copybreak was traditionally used to copy packets to 
>> >> preallocated DMA
>> >> buffers, but this could be implemented as copying the packet 
>> >> to the
>> >> (preallocated) WQE's inline part. That usually means DMA 
>> >> memory, but
>> >> could also be device memory in this ENA LLQ case.
>> >>
>> >> Are we drawing a line that TX copybreak is the threshold for 
>> >> DMA memory
>> >> and tx_push_buf_len is the threshold for device memory?
>> >
>> > Pretty much, yes. Not an amazing distinction but since TX 
>> > copybreak can
>> > already mean two different things (inline or DMA buf) I'd err 
>> > on
>> > the side of not overloading it with another one.
>>
>> Can we document that please?
>
> Shay, could you add a paragraph in the docs regarding copybreak 
> in v5?

Document that tx_copybreak defines the threshold below which the 
packet is copied into a preallocated DMA'ed buffer and that 
tx_push_buf defines the same but for device memory?
Are we sure we want to make this distinction ? While the meaning 
of both params can overlap in their current definition, the 
motivation to use them is pretty different.
A driver can implement both for different purposes (and still copy 
both into the device).

I'll modify the documentation in next version
