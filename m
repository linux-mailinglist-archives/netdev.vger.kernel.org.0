Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3482866C29E
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 15:47:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbjAPOro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 09:47:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231858AbjAPOrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 09:47:13 -0500
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E709021A16
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 06:29:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673879374; x=1705415374;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=tbsByN7eki0twdCmSVgcSMKpx3MGgEaIh5ttVtUpscw=;
  b=XzHQnYdLwr5QxXSTfa2B+y6uaUkuzyv2LabsOVQbXLzySi2iHE6rhZl1
   zREbgwks2r2JUsdH4OT8LbYoPv7viXFO9B1V26oeQgmh3lO8hFfCTD3++
   BP/RJl+qOkTuefruDP1sBC4oLHRkhxVCd2JXLjirLqQPgTrCPe+ULBH6+
   A=;
X-IronPort-AV: E=Sophos;i="5.97,221,1669075200"; 
   d="scan'208";a="287121143"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2023 14:29:30 +0000
Received: from EX13D46EUB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-pdx-2c-m6i4x-b1c0e1d0.us-west-2.amazon.com (Postfix) with ESMTPS id 29B5D81FE4;
        Mon, 16 Jan 2023 14:29:28 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D46EUB001.ant.amazon.com (10.43.166.230) with Microsoft SMTP Server (TLS)
 id 15.0.1497.45; Mon, 16 Jan 2023 14:29:26 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.161.198) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Mon, 16 Jan 2023 14:29:18 +0000
References: <20230108103533.10104-1-darinzon@amazon.com>
 <20230109164500.7801c017@kernel.org>
 <574f532839dd4e93834dbfc776059245@amazon.com>
 <20230110124418.76f4b1f8@kernel.org>
 <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
 <20230111110043.036409d0@kernel.org>
 <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
 <20230111120003.1a2e2357@kernel.org>
 <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
 <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
 <20230112115613.0a33f6c4@kernel.org>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Gal Pressman <gal@nvidia.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        "Bshara, Saeed" <saeedb@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>,
        "Bernstein, Amit" <amitbern@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Date:   Mon, 16 Jan 2023 16:23:56 +0200
In-Reply-To: <20230112115613.0a33f6c4@kernel.org>
Message-ID: <pj41zla62ift8o.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.161.198]
X-ClientProxiedBy: EX13D43UWA003.ant.amazon.com (10.43.160.9) To
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

> On Thu, 12 Jan 2023 15:47:13 +0200 Shay Agroskin wrote:
>> Gal Pressman <gal@nvidia.com> writes:
>> > TX copybreak? When the user sets it to > 96 bytes, use the 
>> > large 
>> > LLQ.
>> >
>> > BTW, shouldn't ethtool's tx_push reflect the fact that LLQs 
>> > are 
>> > being
>> > used? I don't see it used in ena.  
>> 
>> Using tx copybreak does sound like it can work for our use 
>> case. Thanks for the tip Gal (:
>> 
>> Jakub, do you see an issue with utilizing tx_copybreak ethtool 
>> parameter instead of the devlink param in this patchset ?
>
> IDK, the semantics don't feel close enough.
>
> As a user I'd set tx_copybreak only on systems which have IOMMU 
> enabled 
> (or otherwise have high cost of DMA mapping), to save CPU 
> cycles.
>
> The ena feature does not seem to be about CPU cycle saving 
> (likely 
> the opposite, in fact), and does not operate on full segments 
> AFAIU.
>
> Hence my preference to expose it as a new tx_push_buf_len, 
> combining
> the semantics of tx_push and rx_buf_len.

We'll proceed with working on and RFC that adds the new param to 
ethtool.

Going forward, can I ask what's the community's stand on adding 
sysfs or procfse entries to the driver as means to tweak custom 
device attributes ?

Thanks,
Shay
