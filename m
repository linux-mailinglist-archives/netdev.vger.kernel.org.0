Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44A46DD2DB
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 08:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230091AbjDKGde (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 02:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjDKGdc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 02:33:32 -0400
Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD8949D
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 23:33:24 -0700 (PDT)
X-QQ-mid: Yeas3t1681194755t335t64138
Received: from 7082A6556EBF4E69829842272A565F7C (jiawenwu@trustnetic.com [183.129.236.74])
X-QQ-SSF: 00400000000000F0FL9000000000000
From:   =?utf-8?b?Smlhd2VuIFd1?= <jiawenwu@trustnetic.com>
X-BIZMAIL-ID: 17176085211662832527
To:     "'Russell King \(Oracle\)'" <linux@armlinux.org.uk>
Cc:     <netdev@vger.kernel.org>, <mengyuanlou@net-swift.com>
References: <20230403064528.343866-1-jiawenwu@trustnetic.com> <20230403064528.343866-6-jiawenwu@trustnetic.com> <ZCrY9Pqn+fID63s3@shell.armlinux.org.uk> <00a701d96b7e$90edb890$b2c929b0$@trustnetic.com> <ZDPnpgYablOB5NRa@shell.armlinux.org.uk>
In-Reply-To: <ZDPnpgYablOB5NRa@shell.armlinux.org.uk>
Subject: RE: [PATCH net-next 5/6] net: txgbe: Implement phylink pcs
Date:   Tue, 11 Apr 2023 14:32:33 +0800
Message-ID: <00c801d96c3f$66246160$326d2420$@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Content-Language: zh-cn
Thread-Index: AQKwNRf195lW+I6aexcIjeJmW6Wh1gJHr+azAlWE08ABYJm4YQJ8yyLdrTQ91AA=
X-QQ-SENDSIZE: 520
Feedback-ID: Yeas:trustnetic.com:qybglogicsvr:qybglogicsvr5
X-Spam-Status: No, score=-0.0 required=5.0 tests=FROM_EXCESS_BASE64,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> It is normal for the first read of the BMSR to report that the link is
> down after it has come up. This is so that software can see if the
link
> has failed since it last read the BMSR. Phylink knows this, and will
> re-request the link state via the pcs_get_state() callback
> appropriately.
> 
> Is it reporting that the link is down after the second read of the
> link status after the interrupt?
> 
> --
> RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
> 

I find out where the problem is.
I should to enable the AN interrupt, and call phylink_mac_change() when
interrupt happend.
Thanks for the tips!!

