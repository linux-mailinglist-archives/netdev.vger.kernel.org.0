Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A198686BC1
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 22:42:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403873AbfHHUmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 16:42:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:38354 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733140AbfHHUmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Aug 2019 16:42:05 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Aug 2019 13:42:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,362,1559545200"; 
   d="scan'208";a="374981565"
Received: from ellie.jf.intel.com (HELO ellie) ([10.24.12.198])
  by fmsmga006.fm.intel.com with ESMTP; 08 Aug 2019 13:42:04 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     David Miller <davem@davemloft.net>, yuehaibing@huawei.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] taprio: remove unused variable 'entry_list_policy'
In-Reply-To: <20190808.113813.478689798535715440.davem@davemloft.net>
References: <20190808142623.69188-1-yuehaibing@huawei.com> <20190808.113813.478689798535715440.davem@davemloft.net>
Date:   Thu, 08 Aug 2019 13:42:04 -0700
Message-ID: <87mugjtmn7.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

David Miller <davem@davemloft.net> writes:

> From: YueHaibing <yuehaibing@huawei.com>
> Date: Thu, 8 Aug 2019 22:26:23 +0800
>
>> net/sched/sch_taprio.c:680:32: warning:
>>  entry_list_policy defined but not used [-Wunused-const-variable=]
>> 
>> It is not used since commit a3d43c0d56f1 ("taprio: Add
>> support adding an admin schedule")
>> 
>> Reported-by: Hulk Robot <hulkci@huawei.com>
>> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>
> This is probably unintentional and a bug, we should be using that
> policy value to validate that the sched list is indeed a nested
> attribute.

Removing this policy should be fine.

One of the points of commit (as explained in the commit message)
a3d43c0d56f1 ("taprio: Add support adding an admin schedule") is that it
removes support (it now returns "not supported") for schedules using the
TCA_TAPRIO_ATTR_SCHED_SINGLE_ENTRY attribute (which were never used),
the parsing of those types of schedules was the only user of this
policy.

>
> I'm not applying this without at least a better and clear commit
> message explaining why we shouldn't be using this policy any more.

YueHaibing may use the text above in the commit message of a new spin of
this patch if you think it's clear enough.


Cheers,
--
Vinicius
