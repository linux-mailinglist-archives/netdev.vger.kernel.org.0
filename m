Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E00764BF17
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 18:56:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfFSQ4T convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 19 Jun 2019 12:56:19 -0400
Received: from mga18.intel.com ([134.134.136.126]:25087 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726091AbfFSQ4T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Jun 2019 12:56:19 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 19 Jun 2019 09:56:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,392,1557212400"; 
   d="scan'208";a="153861538"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga008.jf.intel.com with ESMTP; 19 Jun 2019 09:56:18 -0700
Received: from orsmsx159.amr.corp.intel.com (10.22.240.24) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 19 Jun 2019 09:56:18 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.248]) by
 ORSMSX159.amr.corp.intel.com ([169.254.11.185]) with mapi id 14.03.0439.000;
 Wed, 19 Jun 2019 09:56:18 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        "Jamal Hadi Salim" <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "l@dorileo.org" <l@dorileo.org>
Subject: Re: [PATCH net-next v3 2/6] etf: Add skip_sock_check
Thread-Topic: [PATCH net-next v3 2/6] etf: Add skip_sock_check
Thread-Index: AQHVJUNDCz9qKl2Ng0aWJgMU0X4IqqahmzmAgAIPRYA=
Date:   Wed, 19 Jun 2019 16:55:47 +0000
Message-ID: <6AA5A401-97AE-47D6-BD0D-2746C4FE3DAE@intel.com>
References: <1560799870-18956-1-git-send-email-vedang.patel@intel.com>
 <1560799870-18956-3-git-send-email-vedang.patel@intel.com>
 <3b9b74f4-526e-143e-21a9-ffd841b26bcb@cogentembedded.com>
In-Reply-To: <3b9b74f4-526e-143e-21a9-ffd841b26bcb@cogentembedded.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.201]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <654E82A170329043BC955417DA758152@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks Sergei for the input.

> On Jun 18, 2019, at 2:28 AM, Sergei Shtylyov <sergei.shtylyov@cogentembedded.com> wrote:
> 
> Hello!
> 
> On 17.06.2019 22:31, Vedang Patel wrote:
> 
>> Currently, etf expects a socket with SO_TXTIME option set for each packet
>> it encounters. So, it will drop all other packets. But, in the future
>> commits we are planning to add functionality which where tstamp value will
>> be set by another qdisc. Also, some packets which are generated from within
>> the kernel (e.g. ICMP packets) do not have any socket associated with them.
>> So, this commit adds support for skip_sock_check. When this option is set,
>> etf will skip checking for a socket and other associated options for all
>> skbs.
>> Signed-off-by: Vedang Patel <vedang.patel@intel.com>
>> ---
>>  include/uapi/linux/pkt_sched.h |  1 +
>>  net/sched/sch_etf.c            | 10 ++++++++++
>>  2 files changed, 11 insertions(+)
>> diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.h
>> index 8b2f993cbb77..69fc52e4d6bd 100644
>> --- a/include/uapi/linux/pkt_sched.h
>> +++ b/include/uapi/linux/pkt_sched.h
>> @@ -990,6 +990,7 @@ struct tc_etf_qopt {
>>  	__u32 flags;
>>  #define TC_ETF_DEADLINE_MODE_ON	BIT(0)
>>  #define TC_ETF_OFFLOAD_ON	BIT(1)
>> +#define TC_ETF_SKIP_SOCK_CHECK  BIT(2)
> 
>  Please indent with a tab like above, not 2 spaces.
> 
I will include this in the next version.

-Vedang
> [...]
> 
> MBR, Sergei

