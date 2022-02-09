Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70CA14AEE66
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 10:49:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230178AbiBIJtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:49:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbiBIJtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:49:16 -0500
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D91FC001F5C;
        Wed,  9 Feb 2022 01:49:07 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R341e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=tonylu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0V4-gd1y_1644399828;
Received: from localhost(mailfrom:tonylu@linux.alibaba.com fp:SMTPD_---0V4-gd1y_1644399828)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 09 Feb 2022 17:43:48 +0800
Date:   Wed, 9 Feb 2022 17:43:45 +0800
From:   Tony Lu <tonylu@linux.alibaba.com>
To:     "Dmitry V. Levin" <ldv@altlinux.org>
Cc:     Karsten Graul <kgraul@linux.ibm.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-api@vger.kernel.org
Subject: Re: [PATCH] Partially revert "net/smc: Add netlink net namespace
 support"
Message-ID: <YgOM0dKMYGr8xeey@TonyMac-Alibaba>
Reply-To: Tony Lu <tonylu@linux.alibaba.com>
References: <20211228130611.19124-1-tonylu@linux.alibaba.com>
 <20211228130611.19124-3-tonylu@linux.alibaba.com>
 <20220131002453.GA7599@altlinux.org>
 <521e3f2a-8b00-43d4-b296-1253c351a3d2@linux.ibm.com>
 <20220202030904.GA9742@altlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220202030904.GA9742@altlinux.org>
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 02, 2022 at 06:09:04AM +0300, Dmitry V. Levin wrote:
> The change of sizeof(struct smc_diag_linkinfo) by commit 79d39fc503b4
> ("net/smc: Add netlink net namespace support") introduced an ABI
> regression: since struct smc_diag_lgrinfo contains an object of
> type "struct smc_diag_linkinfo", offset of all subsequent members
> of struct smc_diag_lgrinfo was changed by that change.
> 
> As result, applications compiled with the old version
> of struct smc_diag_linkinfo will receive garbage in
> struct smc_diag_lgrinfo.role if the kernel implements
> this new version of struct smc_diag_linkinfo.
> 
> Fix this regression by reverting the part of commit 79d39fc503b4 that
> changes struct smc_diag_linkinfo.  After all, there is SMC_GEN_NETLINK
> interface which is good enough, so there is probably no need to touch
> the smc_diag ABI in the first place.
> 
> Fixes: 79d39fc503b4 ("net/smc: Add netlink net namespace support")
> Signed-off-by: Dmitry V. Levin <ldv@altlinux.org>

Thank you and Karsten.

It was my negligence that caused the ABI incompatibility issue.
I will consider to fix it completely. And we are starting to build
smc-tools and other userspace test for potential ABI modifications.

Best regards,
Tony Lu
