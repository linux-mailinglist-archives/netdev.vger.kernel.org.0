Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33E4C37F4A
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 23:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727915AbfFFVNv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 6 Jun 2019 17:13:51 -0400
Received: from mga07.intel.com ([134.134.136.100]:46442 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725267AbfFFVNv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 17:13:51 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Jun 2019 14:13:51 -0700
X-ExtLoop1: 1
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga006.jf.intel.com with ESMTP; 06 Jun 2019 14:13:50 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.408.0; Thu, 6 Jun 2019 14:13:50 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.229]) by
 ORSMSX111.amr.corp.intel.com ([169.254.12.32]) with mapi id 14.03.0415.000;
 Thu, 6 Jun 2019 14:13:50 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>
Subject: Re: [PATCH iproute2 net-next v1 3/6] taprio: Add support for
 enabling offload mode
Thread-Topic: [PATCH iproute2 net-next v1 3/6] taprio: Add support for
 enabling offload mode
Thread-Index: AQHVHJCoV3T3WxPxBkGvdj/9wljud6aPfImAgAAZJoA=
Date:   Thu, 6 Jun 2019 21:13:50 +0000
Message-ID: <E3C41041-64E5-4C95-9057-1F2A0E6ECEAC@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
 <1559843541-12695-3-git-send-email-vedang.patel@intel.com>
 <20190606124349.653454ab@hermes.lan>
In-Reply-To: <20190606124349.653454ab@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.14.182]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7D7062E54E42264F939D10C59498F8D9@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Jun 6, 2019, at 12:43 PM, Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> On Thu,  6 Jun 2019 10:52:18 -0700
> Vedang Patel <vedang.patel@intel.com> wrote:
> 
>> @@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>> 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
>> 	struct tc_mqprio_qopt *qopt = 0;
>> 	__s32 clockid = CLOCKID_INVALID;
>> +	__u32 offload_flags = 0;
>> 	int i;
>> 
>> 	if (opt == NULL)
>> @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>> 
>> 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
>> 
>> +	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
>> +		offload_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
>> +
>> +	print_uint(PRINT_ANY, "offload", " offload %x", offload_flags);
> 
> I don't think offload flags should be  printed at all if not present.
> 
> Why not?
Will make this in the next version.
> 	if (tb[TCA_TAPRIO_ATTR_OFFLOLAD_FLAGS]) {
> 		__u32 offload_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
> 
> 		print_uint(PRINT_ANY, "offload", " offload %x", offload_flags);
> 	}

