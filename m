Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27CE616939
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 17:36:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231879AbiKBQg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 12:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbiKBQgJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 12:36:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47DA2E9C5;
        Wed,  2 Nov 2022 09:31:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED5FEB823C1;
        Wed,  2 Nov 2022 16:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F2AC433C1;
        Wed,  2 Nov 2022 16:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667406694;
        bh=2nuCPWnsntj/V1Ilk+t2EKDcgaQhP8VQs4FNpOQCQ7Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qOCaiOXVSQb79pR0eVnT5oDKO8azi0YVQNAloIhbOxZe97unsO6Jsk9DQxTfCTDEP
         t7lhJi1O9831GwGhIeS+H77yPje8yACFCC81du58m58G8PoZ3BpWdmUY646glzgGFQ
         CSgKmHzhO6ZpznGHuLRXHQqjFIHLPyZUKjHjFPv4y9w1cqq7CAsXlBJFmVCH/MSeyu
         kcyyo6oSuDQLN8cFm4nLJRViIOYEQuTQ1/mUujYw7rzpvv79ZArF7u7jqC2n8D4oEd
         UdhAMEhZ25EVd89E5m8rttWyWtDNcELiie7jzaomi8G0bLhUdV6c0wQzrJDuwT0Jum
         xzDiAucGZgdlw==
Date:   Wed, 2 Nov 2022 09:31:33 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Andrew Lunn <andrew@lunn.ch>, corbet@lwn.net,
        hkallweit1@gmail.com, linux@armlinux.org.uk,
        huangguangbin2@huawei.com, chenhao288@hisilicon.com,
        moshet@nvidia.com, linux@rempel-privat.de,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next v4] ethtool: linkstate: add a statistic for PHY
 down events
Message-ID: <20221102093133.4000add1@kernel.org>
In-Reply-To: <20221102035704.110304-1-kuba@kernel.org>
References: <20221102035704.110304-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  1 Nov 2022 20:57:04 -0700 Jakub Kicinski wrote:
> +	 * This statistic counts when PHY _actually_ went down, or lost link.
> +	 */

Please ignore, I just realized I forgot to commit the change:

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index fa8e0d52dd30..15c0134ae938 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -132,6 +132,9 @@ struct ethtool_link_ext_stats {
         * actually take the physical link down, not to mention NC-SI which,
         * if present, keeps the link up regardless of host state.
         * This statistic counts when PHY _actually_ went down, or lost link.
+        *
+        * Note that we need u64 for ethtool_stats_init() and comparisons
+        * to ETHTOOL_STAT_NOT_SET, only u32 is exposed to the user.
         */
        u64 link_down_events;
 };
