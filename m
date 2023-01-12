Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDDA667390
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 14:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbjALNvU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 08:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbjALNvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 08:51:18 -0500
Received: from smtp-fw-80006.amazon.com (smtp-fw-80006.amazon.com [99.78.197.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E50B39F95
        for <netdev@vger.kernel.org>; Thu, 12 Jan 2023 05:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1673531478; x=1705067478;
  h=references:from:to:cc:subject:date:in-reply-to:
   message-id:mime-version;
  bh=ICMorBcRUeZOSPsvteBM7H/tFz4SKKGmt36CjK8cvtk=;
  b=JG/uzB+StHqyyNSzCaxWY2SRuq3A9IiOhXRS//i6ePM6q/Otj1PORhLZ
   iBrNtVwDdWEq9UQlcF8FFQn4to+QYYtXwlI2YxxznVg+2wVS4hzW/EllY
   ZhyFmv8DZ1T6m8iKw5zxpgwxyf+0QTZfysvb0GqTRA8F3uZJmsYwGuNaZ
   s=;
X-IronPort-AV: E=Sophos;i="5.97,211,1669075200"; 
   d="scan'208";a="170483746"
Received: from pdx4-co-svc-p1-lb2-vlan2.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com) ([10.25.36.210])
  by smtp-border-fw-80006.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2023 13:51:17 +0000
Received: from EX13D34EUB003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-3e1fab07.us-east-1.amazon.com (Postfix) with ESMTPS id C859582C9E;
        Thu, 12 Jan 2023 13:51:15 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX13D34EUB003.ant.amazon.com (10.43.166.189) with Microsoft SMTP Server (TLS)
 id 15.0.1497.42; Thu, 12 Jan 2023 13:51:15 +0000
Received: from u570694869fb251.ant.amazon.com.amazon.com (10.43.160.120) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.2.1118.7; Thu, 12 Jan 2023 13:51:09 +0000
References: <20230108103533.10104-1-darinzon@amazon.com>
 <20230109164500.7801c017@kernel.org>
 <574f532839dd4e93834dbfc776059245@amazon.com>
 <20230110124418.76f4b1f8@kernel.org>
 <865255fd30cd4339966425ea1b1bd8f9@amazon.com>
 <20230111110043.036409d0@kernel.org>
 <29a2fdae8f344ff48aeb223d1c3c78ad@amazon.com>
 <20230111120003.1a2e2357@kernel.org>
 <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
User-agent: mu4e 1.6.10; emacs 28.0.91
From:   Shay Agroskin <shayagr@amazon.com>
To:     Gal Pressman <gal@nvidia.com>, Jakub Kicinski <kuba@kernel.org>
CC:     "Arinzon, David" <darinzon@amazon.com>,
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
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: Re: [PATCH V1 net-next 0/5] Add devlink support to ena
Date:   Thu, 12 Jan 2023 15:47:13 +0200
In-Reply-To: <f2fd4262-58b7-147d-2784-91f2431c53df@nvidia.com>
Message-ID: <pj41zltu0vn9o7.fsf@u570694869fb251.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Originating-IP: [10.43.160.120]
X-ClientProxiedBy: EX13D47UWC004.ant.amazon.com (10.43.162.74) To
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

> On 11/01/2023 22:00, Jakub Kicinski wrote:
>> On Wed, 11 Jan 2023 19:31:39 +0000 Arinzon, David wrote:
>>> If the packet network headers are not within the size of the 
>>> LLQ entry, then the packet will
>>> be dropped. So I'll say that c) describes the impact the best 
>>> given that certain types of
>>> traffic will not succeed or have disruptions due to dropped TX 
>>> packets.
>> 
>> I see. Sounds like it could be a fit for
>> DEVLINK_ATTR_ESWITCH_INLINE_MODE ? But that one configures the 
>> depth of
>> the headers copied inline, rather than bytes. We could add a 
>> value for
>> "tunneled" and have that imply 256B LLQ in case of ena.
>> 
>> The other option is to introduce the concept of "max length of 
>> inline
>> data" to ethtool, and add a new netlink attribute to ethtool 
>> -g.
>
> TX copybreak? When the user sets it to > 96 bytes, use the large 
> LLQ.
>
> BTW, shouldn't ethtool's tx_push reflect the fact that LLQs are 
> being
> used? I don't see it used in ena.

Using tx copybreak does sound like it can work for our use 
case. Thanks for the tip Gal (:

Jakub, do you see an issue with utilizing tx_copybreak ethtool 
parameter instead of the devlink param in this patchset ?

Thanks,
Shay
