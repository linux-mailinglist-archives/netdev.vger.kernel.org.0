Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8646B04D
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 22:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388590AbfGPUPE convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 16 Jul 2019 16:15:04 -0400
Received: from mga12.intel.com ([192.55.52.136]:47566 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbfGPUPE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Jul 2019 16:15:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 13:15:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,271,1559545200"; 
   d="scan'208";a="175504312"
Received: from orsmsx106.amr.corp.intel.com ([10.22.225.133])
  by FMSMGA003.fm.intel.com with ESMTP; 16 Jul 2019 13:15:03 -0700
Received: from orsmsx162.amr.corp.intel.com (10.22.240.85) by
 ORSMSX106.amr.corp.intel.com (10.22.225.133) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Tue, 16 Jul 2019 13:15:03 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX162.amr.corp.intel.com ([169.254.3.137]) with mapi id 14.03.0439.000;
 Tue, 16 Jul 2019 13:15:03 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        "Murali Karicheri" <m-karicheri2@ti.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH net-next v1] fix: taprio: Change type of txtime-delay
 parameter to u32
Thread-Topic: [PATCH net-next v1] fix: taprio: Change type of txtime-delay
 parameter to u32
Thread-Index: AQHVPBAH2Iab5gicXE2VxFW40gJB96bOI4OA
Date:   Tue, 16 Jul 2019 20:15:02 +0000
Message-ID: <853E300D-C6C5-420F-849F-4739B3758490@intel.com>
References: <1563306738-2779-1-git-send-email-vedang.patel@intel.com>
In-Reply-To: <1563306738-2779-1-git-send-email-vedang.patel@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.201]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <2FF43D508270474690B9D2408DF964A5@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I request that this patch should also be considered for the net tree since it fixes the data type of of the txtime_delay parameter and should go in with the iproute2 patches which implement support for txtime-assist mode. 

Thanks,
Vedang Patel

> On Jul 16, 2019, at 12:52 PM, Patel, Vedang <vedang.patel@intel.com> wrote:
> 
> During the review of the iproute2 patches for txtime-assist mode, it was
> pointed out that it does not make sense for the txtime-delay parameter to
> be negative. So, change the type of the parameter from s32 to u32.
> 
> Fixes: 4cfd5779bd6e ("taprio: Add support for txtime-assist mode")
> Reported-by: Stephen Hemminger <stephen@networkplumber.org>
> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> ---
> include/uapi/linux/pkt_sched.h | 2 +-
> net/sched/sch_taprio.c         | 6 +++---
> 2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
> index 1f623252abe8..18f185299f47 100644
> --- a/include/uapi/linux/pkt_sched.h
> +++ b/include/uapi/linux/pkt_sched.h
> @@ -1174,7 +1174,7 @@ enum {
> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME, /* s64 */
> 	TCA_TAPRIO_ATTR_SCHED_CYCLE_TIME_EXTENSION, /* s64 */
> 	TCA_TAPRIO_ATTR_FLAGS, /* u32 */
> -	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* s32 */
> +	TCA_TAPRIO_ATTR_TXTIME_DELAY, /* u32 */
> 	__TCA_TAPRIO_ATTR_MAX,
> };
> 
> diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
> index 388750ddc57a..c39db507ba3f 100644
> --- a/net/sched/sch_taprio.c
> +++ b/net/sched/sch_taprio.c
> @@ -75,7 +75,7 @@ struct taprio_sched {
> 	struct sched_gate_list __rcu *admin_sched;
> 	struct hrtimer advance_timer;
> 	struct list_head taprio_list;
> -	int txtime_delay;
> +	u32 txtime_delay;
> };
> 
> static ktime_t sched_base_time(const struct sched_gate_list *sched)
> @@ -1113,7 +1113,7 @@ static int taprio_change(struct Qdisc *sch, struct nlattr *opt,
> 			goto unlock;
> 		}
> 
> -		q->txtime_delay = nla_get_s32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
> +		q->txtime_delay = nla_get_u32(tb[TCA_TAPRIO_ATTR_TXTIME_DELAY]);
> 	}
> 
> 	if (!TXTIME_ASSIST_IS_ENABLED(taprio_flags) &&
> @@ -1430,7 +1430,7 @@ static int taprio_dump(struct Qdisc *sch, struct sk_buff *skb)
> 		goto options_error;
> 
> 	if (q->txtime_delay &&
> -	    nla_put_s32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
> +	    nla_put_u32(skb, TCA_TAPRIO_ATTR_TXTIME_DELAY, q->txtime_delay))
> 		goto options_error;
> 
> 	if (oper && dump_schedule(skb, oper))
> -- 
> 2.7.3
> 

