Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3C8218D13
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730371AbgGHQiP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:38:15 -0400
Received: from out0-155.mail.aliyun.com ([140.205.0.155]:41389 "EHLO
        out0-155.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgGHQiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 12:38:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594226292; h=From:Subject:To:Message-ID:Date:MIME-Version:Content-Type;
        bh=l7i8wcN53dpAQOn2SDCTlYoizdgNw7h5JlnrZf08p+M=;
        b=T3x3HG+tqKcrCZ2BAmFB5mc654WnFGRy3EhzFu3lm8xUSNhQ5Adg6pRaGx9Y0uag/VPYO4tdgxvu4kdWMMwhPnOAztOgOBXnS+XPSfh5mm2Bm8lqVujpo9JnUI9HFqSvM4JiViKXYBrJJp19v3HrNIzCQWL7Hqf4GSYTwGEbDl8=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03303;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=1;SR=0;TI=SMTPD_---.I-IoKB0_1594226289;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I-IoKB0_1594226289)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Jul 2020 00:38:10 +0800
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Subject: [PATCH net-next v2 0/2] Lockless Token Bucket (LTB) Qdisc
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Message-ID: <3ed11bd4-f6d6-568d-cb3c-140dd0d9461d@alibaba-inc.com>
Date:   Thu, 09 Jul 2020 00:38:07 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Both Cong and David have pointed out it's not a good idea to have a
per-qdisc kernel thread. In this patch we replaced it with a delayed work.
Also applied other code review comments. 

Changes in v2:

    - Replace kernel thread with a delayed work.
    - Check SPEED_UNKNOWN for link speed.
    - Remove all inline keyword.
    - Fix local variable declarations.
    - Add some JSON output for iproute2.
    - Fix compiler warnings reported by kernel test bot.

Thanks!

-- 
Xiangning Yu (2):
	irq_work: Export symbol "irq_work_queue_on"
	net: sched: Lockless Token Bucket (LTB) qdisc

 include/uapi/linux/pkt_sched.h |   35 ++
 kernel/irq_work.c              |    2 +-
 net/sched/Kconfig              |   12 +
 net/sched/Makefile             |    1 +
 net/sched/sch_ltb.c            | 1255 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 1304 insertions(+), 1 deletion(-)

