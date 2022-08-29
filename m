Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B92425A5028
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiH2P0Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 11:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiH2P0Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:26:24 -0400
Received: from smtp-fw-9103.amazon.com (smtp-fw-9103.amazon.com [207.171.188.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0F4E09D
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 08:26:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1661786782; x=1693322782;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=+74oyRTFbjVv2/HgNLrfsY8GkoXcQiT18wXzIsCgyIA=;
  b=Itj01Sz4Es0pPDL4MJauOj8/vSFD02NHRfPg1p8dp4aBSqZEMajKn9ee
   lLtKifgOke9Q3S3hzeArai6KZ0jdjC2cHw39WfQJDovO9wBtD7ELD2dbf
   hwnC7PG3rbx4PjeVen9+FsAno2d/SBTgYm0WnzV8R1rYuYytUt9suhSvg
   c=;
X-IronPort-AV: E=Sophos;i="5.93,272,1654560000"; 
   d="scan'208";a="1049110567"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-9103.sea19.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 15:26:21 +0000
Received: from EX13MTAUEA001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1a-828bd003.us-east-1.amazon.com (Postfix) with ESMTPS id A620080C02;
        Mon, 29 Aug 2022 15:26:17 +0000 (UTC)
Received: from EX13D37UEA002.ant.amazon.com (10.43.61.46) by
 EX13MTAUEA001.ant.amazon.com (10.43.61.82) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 29 Aug 2022 15:26:11 +0000
Received: from EX13MTAUEA001.ant.amazon.com (10.43.61.82) by
 EX13D37UEA002.ant.amazon.com (10.43.61.46) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Mon, 29 Aug 2022 15:26:11 +0000
Received: from ua5189936247a55.ant.amazon.com.amazon.com (10.94.102.54) by
 mail-relay.amazon.com (10.43.61.243) with Microsoft SMTP Server (TLS) id
 15.0.1497.38 via Frontend Transport; Mon, 29 Aug 2022 15:26:10 +0000
From:   Anthony Liguori <aliguori@amazon.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>
CC:     <netdev@vger.kernel.org>, <xiyou.wangcong@gmail.com>,
        <jiri@resnulli.us>, <kuznet@ms2.inr.ac.ru>,
        <cascardo@canonical.com>, <linux-distros@vs.openwall.org>,
        <security@kernel.org>, <stephen@networkplumber.org>,
        <dsahern@gmail.com>, <gregkh@linuxfoundation.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Re: [vs-plain] [PATCH net 1/1] net_sched: cls_route: disallow handle of 0
In-Reply-To: <20220814112758.3088655-1-jhs@mojatatu.com>
References: <20220814112758.3088655-1-jhs@mojatatu.com>
Date:   Mon, 29 Aug 2022 08:26:09 -0700
Message-ID: <pwfk72r10zgjfy.fsf@ua5189936247a55.ant.amazon.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jamal Hadi Salim <jhs@mojatatu.com> writes:

> Follows up on:
> https://lore.kernel.org/all/20220809170518.164662-1-cascardo@canonical.com/
>
> handle of 0 implies from/to of universe realm which is not very
> sensible.

Hi,

This was posted two weeks ago and now that it's merged, could you please
post to oss-security?

I don't think there was an actual embargo on this one.

Regards,

Anthony Liguori
