Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD8BB6A02D
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 03:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732085AbfGPBPZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 15 Jul 2019 21:15:25 -0400
Received: from mga03.intel.com ([134.134.136.65]:20561 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730690AbfGPBPZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Jul 2019 21:15:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 Jul 2019 18:15:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,496,1557212400"; 
   d="scan'208";a="318845186"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by orsmga004.jf.intel.com with ESMTP; 15 Jul 2019 18:15:24 -0700
Received: from orsmsx115.amr.corp.intel.com ([169.254.4.240]) by
 ORSMSX103.amr.corp.intel.com ([169.254.5.44]) with mapi id 14.03.0439.000;
 Mon, 15 Jul 2019 18:15:24 -0700
From:   "Patel, Vedang" <vedang.patel@intel.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Dorileo, Leandro" <leandro.maciel.dorileo@intel.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>
Subject: Re: [PATCH iproute2 net-next v3 2/5] taprio: Add support for
 setting flags
Thread-Topic: [PATCH iproute2 net-next v3 2/5] taprio: Add support for
 setting flags
Thread-Index: AQHVO1/o38slkEjeMUyLF8zjrUdu2KbMyzGAgAAbRgA=
Date:   Tue, 16 Jul 2019 01:15:24 +0000
Message-ID: <E88A4281-E41D-4A04-B01A-196AC72564DD@intel.com>
References: <1563231104-19912-1-git-send-email-vedang.patel@intel.com>
 <1563231104-19912-2-git-send-email-vedang.patel@intel.com>
 <20190715163743.2c6cec2b@hermes.lan>
In-Reply-To: <20190715163743.2c6cec2b@hermes.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.24.11.11]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <D53B50DAF868044CA766059FAC65B06F@intel.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

> On Jul 15, 2019, at 4:37 PM, Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> On Mon, 15 Jul 2019 15:51:41 -0700
> Vedang Patel <vedang.patel@intel.com> wrote:
> 
>> @@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>> 	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
>> 	struct tc_mqprio_qopt *qopt = 0;
>> 	__s32 clockid = CLOCKID_INVALID;
>> +	__u32 taprio_flags = 0;
>> 	int i;
>> 
>> 	if (opt == NULL)
>> @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>> 
>> 	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
>> 
>> +	if (tb[TCA_TAPRIO_ATTR_FLAGS]) {
>> +		taprio_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_FLAGS]);
>> +		print_uint(PRINT_ANY, "flags", " flags %x", taprio_flags);
>> +	}
>> +
> 
> Overall this looks fine, but three small comments:
> 1. It is better not to do unnecessary variable initialization
> 2. It is better to move variables into the basic block where they are used.
> 3. Use the print_0xhex() instead of print_uint() for hex values. The difference
>   is that in the JSON output, print_uint would be decimal but the print_0xhex
>   is always hex.  And use "flags %#x" so that it is clear you are printing flags in hex.
Thanks for they inputs. I will incorporate your comments and send the updated series in a couple of days.

-Vedang
> 
> 

