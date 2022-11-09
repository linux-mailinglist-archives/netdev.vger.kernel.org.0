Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19CD5622626
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 10:03:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230127AbiKIJDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 04:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230123AbiKIJDw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 04:03:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7AFD1263F;
        Wed,  9 Nov 2022 01:03:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667984631; x=1699520631;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cZFDEG2cr14qKxNh523mmiNj6wQwNrxYPGzaxSddF8M=;
  b=ATSGi6YmMJj9DmX8CJw7ilWYxfOh9l4RvwPePflrx7GZL0QJq+8YwD1c
   SSaXcHV66k3Jt/8KBoJHhkqvf6C5CfmmK2cymQdqiSUWkInoGf25WPYNE
   VTBdCKApVHRVkymFZh6Ieb7oRev6n+mMHA3fsTzgt0dOEk+QTFfczqDlW
   gRwRb1hx42hfnB5GeJmv9aog7kaxWCNxkzu/HpkHt8ulJAYQqE8rPyOb7
   olvhXxrs4WscBoMHXbrRMfYCjTN/bna4yRFt8XQgDQ7IvdBiGESHE2wQl
   auLoHLaygco7zHnZlQqUQHuHTDX2pd7YlxZxPMytDUhS1bIFJfUQGAzqi
   g==;
X-IronPort-AV: E=Sophos;i="5.96,150,1665471600"; 
   d="scan'208";a="188289219"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Nov 2022 02:03:50 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 9 Nov 2022 02:03:50 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Wed, 9 Nov 2022 02:03:47 -0700
Message-ID: <3bd9fa1c7b3349e13803759a54e72521d62212a6.camel@microchip.com>
Subject: Re: [PATCH net-next v5 0/8] Extend TC key support for Sparx5 IS2
 VCAP
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        "Daniel Machon" <daniel.machon@microchip.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Wed, 9 Nov 2022 10:03:46 +0100
In-Reply-To: <20221108171103.73ca999b@kernel.org>
References: <20221104141830.1527159-1-steen.hegelund@microchip.com>
         <20221108171103.73ca999b@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jacub,

On Tue, 2022-11-08 at 17:11 -0800, Jakub Kicinski wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Fri, 4 Nov 2022 15:18:22 +0100 Steen Hegelund wrote:
> > v5      Add support for a TC matchall filter with a single goto action
> >         which will activate the lookups of the VCAP.  Removing this filter
> >         will deactivate the VCAP lookups again.
> 
> There are conflicts applying this patch set to net-next now,
> could you rebase + repost?

I will do that.

BR
Steen


