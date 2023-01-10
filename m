Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F4996646E2
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:00:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233557AbjAJRAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:00:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbjAJRAA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:00:00 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E14A380;
        Tue, 10 Jan 2023 08:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673370000; x=1704906000;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=v0FHnqz++7WAyCUdZ4a39D9ZNS9Mj+/iD1X/Rx7tWI4=;
  b=hOSplJKNcnwv7w8M77WMlrFQXDw/P49OpFHcgkmX0OiGLuoGFvCo1Q2T
   WeEkScKgEccpX538NKE2xFObQt7EiLzl2LhmwlloPHIl+ZDRqxsY+ug62
   qx9/LmmIaJ41fRXlofc0/ff5CQGjyZbQ9QDeVqNw0/ib0bSSuqo6tNIWt
   s=;
X-IronPort-AV: E=Sophos;i="5.96,315,1665446400"; 
   d="scan'208";a="285208024"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 16:59:53 +0000
Received: from EX13D48EUB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2b-m6i4x-189d700f.us-west-2.amazon.com (Postfix) with ESMTPS id 6920741664;
        Tue, 10 Jan 2023 16:59:51 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D48EUB001.ant.amazon.com (10.43.166.179) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Tue, 10 Jan 2023 16:59:50 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.120) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Tue, 10 Jan 2023 16:59:40 +0000
References: <20230108143843.2987732-1-trix@redhat.com>
 <CANn89iLFtrQm-E5BRwgKFw4xRZiOOdWg-WTFi5eZsg7ycq2szg@mail.gmail.com>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Tom Rix <trix@redhat.com>, <akiyano@amazon.com>,
        <darinzon@amazon.com>, <ndagan@amazon.com>, <saeedb@amazon.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <nathan@kernel.org>, <ndesaulniers@google.com>, <khalasa@piap.pl>,
        <wsa+renesas@sang-engineering.com>, <yuancan@huawei.com>,
        <tglx@linutronix.de>, <42.hyeyoo@gmail.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <llvm@lists.linux.dev>
Subject: Re: [PATCH] net: ena: initialize dim_sample
Date:   Tue, 10 Jan 2023 18:58:37 +0200
In-Reply-To: <CANn89iLFtrQm-E5BRwgKFw4xRZiOOdWg-WTFi5eZsg7ycq2szg@mail.gmail.com>
Message-ID: <pj41zlpmbmba16.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D45UWA002.ant.amazon.com (10.43.160.38) To
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


Eric Dumazet <edumazet@google.com> writes:

> On Sun, Jan 8, 2023 at 3:38 PM Tom Rix <trix@redhat.com> wrote:
>>
>> clang static analysis reports this problem
>> drivers/net/ethernet/amazon/ena/ena_netdev.c:1821:2: warning: 
>> Passed-by-value struct
>>   argument contains uninitialized data (e.g., field: 
>>   'comp_ctr') [core.CallAndMessage]
>>         net_dim(&ena_napi->dim, dim_sample);
>>         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> net_dim can call dim_calc_stats() which uses the comp_ctr 
>> element,
>> so it must be initialized.
>
> This seems to be a dim_update_sample() problem really, when 
> comp_ctr
> has been added...
>
> Your patch works, but we could avoid pre-initializing dim_sample 
> in all callers,
> then re-writing all but one field...
>
> diff --git a/include/linux/dim.h b/include/linux/dim.h
> index 
> 6c5733981563eadf5f06c59c5dc97df961692b02..4604ced4517268ef8912cd8053ac8f4d2630f977
> 100644
> --- a/include/linux/dim.h
> +++ b/include/linux/dim.h
> @@ -254,6 +254,7 @@ dim_update_sample(u16 event_ctr, u64 
> packets, u64
> bytes, struct dim_sample *s)
>         s->pkt_ctr   = packets;
>         s->byte_ctr  = bytes;
>         s->event_ctr = event_ctr;
> +       s->comp_ctr  = 0;
>  }
>
>  /**

Hi,

I'd rather go with Eric's solution to this issue than zero the 
whole struct in ENA

Thanks,
Shay
