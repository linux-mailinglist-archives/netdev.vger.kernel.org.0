Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 739F16A84EC
	for <lists+netdev@lfdr.de>; Thu,  2 Mar 2023 16:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCBPHG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Mar 2023 10:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjCBPGw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Mar 2023 10:06:52 -0500
Received: from smtp-fw-33001.amazon.com (smtp-fw-33001.amazon.com [207.171.190.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735AE5653E
        for <netdev@vger.kernel.org>; Thu,  2 Mar 2023 07:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1677769604; x=1709305604;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=Ff1FqqYO805lpW5G33/SECnHSs203EiO+jLq4kDuA/E=;
  b=pUg3o9i0RVhxaqlK6zvLkB2NzufEQQetcZyyFSzQqHx4d64Xl7DYK/l5
   WXTycX9KKEAJ+BDxd7Jc084l1Lb/AnHZKJqdySoTLGuiyF7qk/gA2AFnj
   ZiuQ0HWhYCYgFq27BDQLQ71+AW74QIq/tZbZamnp4A9ZZQPA4K2oxX5cI
   8=;
X-IronPort-AV: E=Sophos;i="5.98,228,1673913600"; 
   d="scan'208";a="266585723"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-33001.sea14.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Mar 2023 15:06:37 +0000
Received: from EX19D013EUA004.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1a-m6i4x-b5bd57cf.us-east-1.amazon.com (Postfix) with ESMTPS id 4D88C447FE;
        Thu,  2 Mar 2023 15:06:34 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D013EUA004.ant.amazon.com (10.252.50.48) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 2 Mar 2023 15:06:33 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.85.143.175) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 2 Mar 2023 15:06:26 +0000
References: <20230301175916.1819491-1-shayagr@amazon.com>
 <20230301175916.1819491-2-shayagr@amazon.com>
 <20230301200055.69e86e53@kernel.org>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
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
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH RFC v1 net-next 1/5] ethtool: Add support for
 configuring tx_push_buf_len
Date:   Thu, 2 Mar 2023 16:23:59 +0200
In-Reply-To: <20230301200055.69e86e53@kernel.org>
Message-ID: <pj41zledq742hf.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.85.143.175]
X-ClientProxiedBy: EX19D042UWB004.ant.amazon.com (10.13.139.150) To
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

> On Wed, 1 Mar 2023 19:59:12 +0200 Shay Agroskin wrote:
>> @@ -98,7 +100,12 @@ static int rings_fill_reply(struct sk_buff 
>> *skb,
>>  	    (kr->cqe_size &&
>>  	     (nla_put_u32(skb, ETHTOOL_A_RINGS_CQE_SIZE, 
>>  kr->cqe_size))) ||
>>  	    nla_put_u8(skb, ETHTOOL_A_RINGS_TX_PUSH, 
>>  !!kr->tx_push) ||
>> -	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, 
>> !!kr->rx_push))
>> +	    nla_put_u8(skb, ETHTOOL_A_RINGS_RX_PUSH, 
>> !!kr->rx_push) ||
>> +	    (kr->tx_push_buf_len &&
>> +	     (nla_put_u32(skb, 
>> ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN_MAX,
>> +			  kr->tx_push_buf_max_len) ||
>> +	      nla_put_u32(skb, ETHTOOL_A_RINGS_TX_PUSH_BUF_LEN,
>> +			  kr->tx_push_buf_len))))
>
> Why gate both on kr->tx_push_buf_len and not current and max 
> separately?
> Is kr->tx_push_buf_len == 0 never a valid setting?
>

Hi, thanks for reviewing it

There's actually no requirement that tx_push_buf_len needs to be > 
0. I'll drop this check.
It seems like the reply object gets zeroed at 
ethnl_init_reply_data() so ENA can simply not touch this field if 
no push buffer exists, leaving the values at 0.

> Otherwise LGTM!
>
> Could you add this chunk to expose the value in the YAML spec?
>
> diff --git a/Documentation/netlink/specs/ethtool.yaml 
> b/Documentation/netlink/specs/ethtool.yaml
> index 35c462bce56f..2dd6aef582e4 100644
> --- a/Documentation/netlink/specs/ethtool.yaml
> +++ b/Documentation/netlink/specs/ethtool.yaml
> @@ -163,6 +163,12 @@ doc: Partial family for Ethtool Netlink.
>        -
>          name: rx-push
>          type: u8
> +      -
> +        name: tx-push-buf-len
> +        type: u32
> +      -
> +        name: tx-push-buf-len-max
> +        type: u32
>  
>    -
>      name: mm-stat
> @@ -309,6 +315,8 @@ doc: Partial family for Ethtool Netlink.
>              - cqe-size
>              - tx-push
>              - rx-push
> +            - tx-push-buf-len
> +            - tx-push-buf-len-max
>        dump: *ring-get-op
>      -
>        name: rings-set

ack. I'll add it

