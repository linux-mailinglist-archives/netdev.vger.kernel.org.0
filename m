Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5CB622178
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 02:55:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiKIBzh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 20:55:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiKIBzg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 20:55:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB8E81F9E2;
        Tue,  8 Nov 2022 17:55:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C31AB81CE7;
        Wed,  9 Nov 2022 01:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81443C433C1;
        Wed,  9 Nov 2022 01:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667958933;
        bh=veYpa7FaRsry6Y/dznGkIf1wj51JZYkzA2/VjZdjWk8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=U3ePUuXm8KJ0wbYI4jMIvw7AKFALf/YxRLPRbj3/XewK8+eKoK0G61vG4YQda288w
         bw7e4xPPaf4hhfZRYDknAAvOnVFShrtgYcTOqJmsR9wwzoXX5jv7hfY5ZQEM0FwfFY
         nzmqBMIOt5iqudcAZBNbwPmH84AGw1s47iZm0KLZSyuUnb/0qves4RXtka+VSIU9lc
         RvzvHV2eLISdu827ghwWsJqjdO0VWSECVJyc8W3EeLwO9nMzPdgoKrjxLARUWBpJut
         wgUuPmfjigVp2mRy63r+kbLbandUi27wD9VE94xNerWAtYwJP2mAOlx3IA3fZGb1TJ
         7a4CvAM3DJNow==
Date:   Tue, 8 Nov 2022 17:55:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Looi Hong Aun <hong.aun.looi@intel.com>,
        Voon Weifeng <weifeng.voon@intel.com>,
        Tan Tee Min <tee.min.tan@intel.com>,
        Zulkifli Muhammad Husaini <muhammad.husaini.zulkifli@intel.com>,
        Gan Yi Fang <yi.fang.gan@intel.com>
Subject: Re: [PATCH net 1/1] net: phy: dp83867: Fix SGMII FIFO depth for non
 OF devices
Message-ID: <20221108175531.1a7c16a6@kernel.org>
In-Reply-To: <20221108101218.612499-1-michael.wei.hong.sit@intel.com>
References: <20221108101218.612499-1-michael.wei.hong.sit@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Nov 2022 18:12:18 +0800 Michael Sit Wei Hong wrote:
> Current driver code will read device tree node information,
> and set default values if there is no info provided.
> 
> This is not done in non-OF devices leading to SGMII fifo depths being
> set to the smallest size.
> 
> This patch sets the value to the default value of the PHY as stated in the
> PHY datasheet.

We need a Fixes tag, which commit should have contained this code?
