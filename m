Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F563E145D
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 14:02:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241250AbhHEMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 08:02:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:41198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241222AbhHEMCL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Aug 2021 08:02:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A06016113E;
        Thu,  5 Aug 2021 12:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628164917;
        bh=Kuc+GOOSF7Mr7kB0f+76kZ8lYT/l/s3e8RSo/5gqf2w=;
        h=From:To:Cc:Subject:Date:From;
        b=HBy+C5pvmnL32VO1/rcihJh30I5KVQ9fq1puGBRaOUGEIS5+VujRs7je/3Iv/5FzS
         iusCpB1IiB06aAIaRAb7NySLNlRI3XOwoWuTd0hj0oAAqH3F7pnrCJVkvuRmEVhXUr
         PNLM++wM9gV4WxT1QqBeCFi9StbIbm4ujMY6MLf2QxPqDwOZLvRBNoEr4ZHSfqV3pf
         HIRo+4G48lo70j7IVzMCEtSPJIvFB9Hn+xkhTbhPguht4/FXwkiAIbTGsN/kVuCVNd
         jZzpAy23XT6IPpSm7JIVkImXwOLmKgwXZBqC32dhkOcE8UPWsYHkla1Dfqy+FElFYE
         bsAWtD5yrRLCA==
From:   Mark Brown <broonie@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>,
        "David S . Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: linux-next: build failure after merge of the net-next tree
Date:   Thu,  5 Aug 2021 13:01:38 +0100
Message-Id: <20210805120138.23953-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

After merging the mac80211-next tree, today's linux-next build
(x86 allmodconfig) failed like this:

/tmp/next/build/drivers/net/wwan/mhi_wwan_mbim.c: In function 'mhi_mbim_probe':
/tmp/next/build/drivers/net/wwan/mhi_wwan_mbim.c:611:8: error: too few arguments to function 'mhi_prepare_for_transfer'
  err = mhi_prepare_for_transfer(mhi_dev);
        ^~~~~~~~~~~~~~~~~~~~~~~~
In file included from /tmp/next/build/drivers/net/wwan/mhi_wwan_mbim.c:18:
/tmp/next/build/include/linux/mhi.h:726:5: note: declared here
 int mhi_prepare_for_transfer(struct mhi_device *mhi_dev,
     ^~~~~~~~~~~~~~~~~~~~~~~~


Caused by commit

   aa730a9905b7b079ef2ff ("net: wwan: Add MHI MBIM network driver")

That API has been modified in ce78ffa3ef16810 ("net: really fix the
build...") in the net tree.  I've used the net-next tree from yesterday.
