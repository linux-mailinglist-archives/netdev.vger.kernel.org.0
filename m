Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DD1BA4094
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 00:30:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728293AbfH3WaS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 18:30:18 -0400
Received: from mga04.intel.com ([192.55.52.120]:38335 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728138AbfH3WaS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Aug 2019 18:30:18 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 30 Aug 2019 15:30:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,447,1559545200"; 
   d="scan'208";a="382157160"
Received: from athevana-mobl.amr.corp.intel.com (HELO ellie) ([10.251.132.149])
  by fmsmga006.fm.intel.com with ESMTP; 30 Aug 2019 15:30:17 -0700
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, vedang.patel@intel.com,
        leandro.maciel.dorileo@intel.com
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v2 net 1/3] taprio: Fix kernel panic in taprio_destroy
In-Reply-To: <20190830010723.32096-2-olteanv@gmail.com>
References: <20190830010723.32096-1-olteanv@gmail.com> <20190830010723.32096-2-olteanv@gmail.com>
Date:   Fri, 30 Aug 2019 15:30:17 -0700
Message-ID: <875zmeb81y.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Vladimir Oltean <olteanv@gmail.com> writes:

> taprio_init may fail earlier than this line:
>
> 	list_add(&q->taprio_list, &taprio_list);
>
> i.e. due to the net device not being multi queue.
>
> Attempting to remove q from the global taprio_list when it is not part
> of it will result in a kernel panic.
>
> Fix it by matching list_add and list_del better to one another in the
> order of operations. This way we can keep the deletion unconditional
> and with lower complexity - O(1).
>
> Cc: Leandro Dorileo <leandro.maciel.dorileo@intel.com>
> Fixes: 7b9eba7ba0c1 ("net/sched: taprio: fix picos_per_byte miscalculation")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
> ---

Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
