Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 627616C4AFD
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 13:46:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230471AbjCVMqX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 08:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230435AbjCVMqT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 08:46:19 -0400
Received: from smtp-fw-2101.amazon.com (smtp-fw-2101.amazon.com [72.21.196.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29AC5B5F3
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 05:46:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679489171; x=1711025171;
  h=references:from:to:cc:date:in-reply-to:message-id:
   mime-version:subject;
  bh=fjPtvZncNnzhacOOUF0RAM5D3IIG3CIgfBDLqJC08d4=;
  b=k1178TMMu+rmjSZ4VqsReBBJWe/SktyIC2djNpjKgmfJAHA0cgNdb32t
   Xkhs4W9hPOldWp61buQR1Azp3FMAmEtOds+Kwiyhea1QXocrrYZj8KdNL
   7Bumx5wdVilaGCr4vSTRfYgZGEeLb86spVXQwVi0N89WK1+tVUd0H7jce
   g=;
X-IronPort-AV: E=Sophos;i="5.98,281,1673913600"; 
   d="scan'208";a="305878472"
Subject: Re: [PATCH v6 net-next 1/7] netlink: Add a macro to set policy message with
 format string
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-2101.iad2.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 12:46:08 +0000
Received: from EX19D001EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-9694bb9e.us-east-1.amazon.com (Postfix) with ESMTPS id B079581946;
        Wed, 22 Mar 2023 12:46:03 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D001EUA004.ant.amazon.com (10.252.50.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.26; Wed, 22 Mar 2023 12:46:03 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.177) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Wed, 22 Mar 2023 12:45:52 +0000
References: <20230320132523.3203254-1-shayagr@amazon.com>
 <20230320132523.3203254-2-shayagr@amazon.com>
 <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
User-agent: mu4e 1.8.13; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Paolo Abeni <pabeni@redhat.com>
CC:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
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
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jie Wang <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Date:   Wed, 22 Mar 2023 14:39:49 +0200
In-Reply-To: <ed1b26c32307ecfc39da3eaba474645280809dec.camel@redhat.com>
Message-ID: <pj41zlsfdxymx0.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.177]
X-ClientProxiedBy: EX19D041UWB004.ant.amazon.com (10.13.139.143) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-10.0 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Paolo Abeni <pabeni@redhat.com> writes:

> CAUTION: This email originated from outside of the 
> organization. Do not click links or open attachments unless you 
> can confirm the sender and know the content is safe.
>
>
>
> On Mon, 2023-03-20 at 15:25 +0200, Shay Agroskin wrote:
>> Similar to NL_SET_ERR_MSG_FMT, add a macro which sets netlink 
>> policy
>> error message with a format string.
>>
>> Signed-off-by: Shay Agroskin <shayagr@amazon.com>
>> ---
>>  include/linux/netlink.h | 13 +++++++++++++
>>  1 file changed, 13 insertions(+)
>>
>> diff --git a/include/linux/netlink.h b/include/linux/netlink.h
>> index 3e8743252167..2ca76ec1fc33 100644
>> --- a/include/linux/netlink.h
>> +++ b/include/linux/netlink.h
>> @@ -161,9 +161,22 @@ struct netlink_ext_ack {
>>       }                                                       \
>>  } while (0)
>>
>> +#define NL_SET_ERR_MSG_ATTR_POL_FMT(extack, attr, pol, fmt, 
>> args...) do {    \
>> +     struct netlink_ext_ack *__extack = (extack); 
>> \
>> + 
>> \
>> +     if (__extack) { 
>> \
>> +             NL_SET_ERR_MSG_FMT(extack, fmt, ##args); 
>> \

Thanks for reviewing the patch

>
> You should use '__extack' even above, to avoid multiple 
> evaluation of
> the 'extack' expression.

I've got to admit that I don't understand the cost of such 
evaluations. I thought that it was added to help readers of the 
source code to understand what is the type of this attribute and 
have a better warning message when the wrong variable is passed 
(kind of typing in Python which isn't strictly needed).
What cost is there for casting a pointer ?

>
> Side note: you dropped the acked-by/revied-by tags collected on
> previous iterations, you could and should have retained them for 
> the
> unmodified patches.

Yap that's an oversight by my side. Forgot to do it in the last 
patchset. I'll make sure to do it in the next patchset

>
> Thanks,
>
> Paolo

