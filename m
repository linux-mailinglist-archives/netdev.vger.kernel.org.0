Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4BAE4DC450
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 11:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbiCQKyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 06:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232767AbiCQKyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 06:54:37 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C0A981659
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 03:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647514401; x=1679050401;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=SxC2QqgTFily9yDmlJyzC7OEugcjrA1fnsWYloWChOA=;
  b=2rURxI6emxh8fsN9gJp4d/IfTDcksshHxCQ2xidRxeZemDlvzUewFubk
   hBpxqRt6Ja/5ZMrqrQ1kvBLP3szPMl0bpSfZVkdMFgSxm230VTDCKaS0H
   DEzV2DTof1kbfRprfauuz4i6yYJOKu4rs2vQHM1XGoUi0IEqVTnTkOPp0
   KM/yT0vbb1jeeXQpAHZG4oV6l3KLzFo38mx7DF7ggyU2/8/HTnfT7Uvro
   IwYLGbRRtPUsnE8LY/haVErvS2n+TjkfXg3n3b4I8A5eaQiGRwcwmFinH
   jHKVSkg7ot2y5e15A0uBqEVmaNWXGAZf8pkbUJDnZE+1omCT9p3jxN9jH
   w==;
X-IronPort-AV: E=Sophos;i="5.90,188,1643698800"; 
   d="scan'208";a="166137493"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Mar 2022 03:53:20 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 17 Mar 2022 03:53:20 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Thu, 17 Mar 2022 03:53:20 -0700
Date:   Thu, 17 Mar 2022 16:23:14 +0530
From:   Raju Lakkaraju <Raju.Lakkaraju@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Ian.Saturley@microchip.com>
Subject: Re: [PATCH net-next 4/5] net: lan743x: Add support for PTP-IO Event
 Input External Timestamp (extts)
Message-ID: <20220317105314.zudmr3m4zc7ctglw@microsemi.com>
References: <20220315061701.3006-1-Raju.Lakkaraju@microchip.com>
 <20220315061701.3006-5-Raju.Lakkaraju@microchip.com>
 <YjD7Ac02mZ5ZBhSg@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YjD7Ac02mZ5ZBhSg@lunn.ch>
User-Agent: NeoMutt/20180716-255-141487
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

The 03/15/2022 21:45, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Tue, Mar 15, 2022 at 11:47:00AM +0530, Raju Lakkaraju wrote:
> > PTP-IOs block provides for time stamping PTP-IO input events.
> > PTP-IOs are numbered from 0 to 11.
> > When a PTP-IO is enabled by the corresponding bit in the PTP-IO
> > Capture Configuration Register, a rising or falling edge,
> > respectively, will capture the 1588 Local Time Counter
> 
> For PTP patches, please always Cc: the PTP maintainer.
> 

Accepted. Fix in V1 patches

>     Andrew

-- 

Thanks,
Raju

