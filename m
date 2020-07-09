Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ACCA21A573
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgGIRKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:10:06 -0400
Received: from out0-137.mail.aliyun.com ([140.205.0.137]:44005 "EHLO
        out0-137.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgGIRKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 13:10:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=alibaba-inc.com; s=default;
        t=1594314604; h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        bh=iMnBtfixZth/446ZleyX3VrFVJIJxOTvs3Y0sw4XXfM=;
        b=OHTDpTh5P+frrjAmB8jYrrWXRRa6P4mINtFJ46rTf/0Bi14G7EwKY1RiwFcK+uR30S6gUxa8x6fahHF9C5lG2jlXt1r0Do2UIOI0ruMBpLjsLjK1cqeaZhh9ZYq+LT2svfSw0tm0ahA0dOSNTp40NmaIru2Q6IAY7ItdqqYGPp8=
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e02c03311;MF=xiangning.yu@alibaba-inc.com;NM=1;PH=DS;RN=2;SR=0;TI=SMTPD_---.I.2V46Y_1594314602;
Received: from US-118000MP.local(mailfrom:xiangning.yu@alibaba-inc.com fp:SMTPD_---.I.2V46Y_1594314602)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 10 Jul 2020 01:10:03 +0800
Subject: Re: [PATCH iproute2-next v2] iproute2 Support lockless token bucket
 (ltb)
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
References: <2a2b2cc9-eeba-4176-198f-fab74ebe4a33@alibaba-inc.com>
 <20200708233305.07b53f8a@hermes.lan>
From:   "=?UTF-8?B?WVUsIFhpYW5nbmluZw==?=" <xiangning.yu@alibaba-inc.com>
Message-ID: <00e9179c-a4a4-fb37-705e-0d790ae9b7b0@alibaba-inc.com>
Date:   Fri, 10 Jul 2020 01:10:02 +0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200708233305.07b53f8a@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/8/20 11:33 PM, Stephen Hemminger wrote:
> On Thu, 09 Jul 2020 00:38:27 +0800
> "YU, Xiangning" <xiangning.yu@alibaba-inc.com> wrote:
> 
>> +static int ltb_parse_class_opt(struct qdisc_util *qu, int argc, char **argv,
>> +			       struct nlmsghdr *n, const char *dev)
>> +{
>> +	struct tc_ltb_opt opt;
> 
> If you use empty initializer in C it will make everything 0 and save you some pain.
> 
> 	struct tc_ltb_opt opt = { };
> 

Thank you!
> 
>> +		fprintf(f, "rate %s ", sprint_rate(rate64, b1));
>> +		fprintf(f, "ceil %s ", sprint_rate(ceil64, b1));
>> +		if (show_details) {
>> +			fprintf(f, "measured %llu allocated %llu highwater %llu",
>> +				lopt->measured, lopt->allocated,
>> +				lopt->high_water);
> 
> 
> All output has to be in JSON. Any use of fprintf(f, ...) directly
> is a indication to me of code that is not supporting JSON correctly.
> 

I see your point now. Looks like everything is heading to support JSON, but we have some thing left in other files to be cleaned up. Will change all fprintf in this file.

Thanks,
- Xiangning
