Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D133EB71B5
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 04:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388506AbfISC6b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 22:58:31 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:2677 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388440AbfISC6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Sep 2019 22:58:23 -0400
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id C655714591BE98259A92;
        Thu, 19 Sep 2019 10:58:19 +0800 (CST)
Received: from use12-sp2.huawei.com (10.67.189.174) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.439.0; Thu, 19 Sep 2019 10:58:10 +0800
From:   Xiaoming Ni <nixiaoming@huawei.com>
To:     <gregkh@linuxfoundation.org>, <akpm@linux-foundation.org>,
        <vvs@virtuozzo.com>, <torvalds@linux-foundation.org>,
        <adobriyan@gmail.com>, <anna.schumaker@netapp.com>,
        <arjan@linux.intel.com>, <bfields@fieldses.org>,
        <chuck.lever@oracle.com>, <davem@davemloft.net>,
        <jlayton@kernel.org>, <luto@kernel.org>, <mingo@kernel.org>,
        <Nadia.Derbey@bull.net>, <paulmck@linux.vnet.ibm.com>,
        <semen.protsenko@linaro.org>, <stern@rowland.harvard.edu>,
        <tglx@linutronix.de>, <trond.myklebust@hammerspace.com>,
        <viresh.kumar@linaro.org>
CC:     <stable@kernel.org>, <dylix.dailei@huawei.com>,
        <nixiaoming@huawei.com>, <yuehaibing@huawei.com>,
        <linux-kernel@vger.kernel.org>, <linux-nfs@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: [PATCH v4 0/3] kernel/notifier.c: intercepting duplicate registrations to avoid infinite loops
Date:   Thu, 19 Sep 2019 10:58:05 +0800
Message-ID: <1568861888-34045-1-git-send-email-nixiaoming@huawei.com>
X-Mailer: git-send-email 1.8.5.6
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.189.174]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Registering the same notifier to a hook repeatedly can cause the hook
list to form a ring or lose other members of the list.
so, need add a check in in notifier_chain_register(),
intercepting duplicate registrations to avoid infinite loops


v1:
* use notifier_chain_cond_register replace notifier_chain_register

v2:
* Add a check in notifier_chain_register() to avoid duplicate registration
* remove notifier_chain_cond_register() to avoid duplicate code 
* remove blocking_notifier_chain_cond_register() to avoid duplicate code

v3:
* Add a cover letter.

v4:
* Add Reviewed-by and adjust the title.

Xiaoming Ni (3):
  kernel/notifier.c: intercepting duplicate registrations to avoid
    infinite loops
  kernel/notifier.c: remove notifier_chain_cond_register()
  kernel/notifier.c: remove blocking_notifier_chain_cond_register()

 include/linux/notifier.h |  4 ----
 kernel/notifier.c        | 41 +++--------------------------------------
 net/sunrpc/rpc_pipe.c    |  2 +-
 3 files changed, 4 insertions(+), 43 deletions(-)

-- 
1.8.5.6

