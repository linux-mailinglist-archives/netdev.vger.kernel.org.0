Return-Path: <netdev+bounces-11026-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2DA70731253
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 063331C20E88
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 08:37:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09509137A;
	Thu, 15 Jun 2023 08:37:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D241379
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 08:37:03 +0000 (UTC)
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0247526B1
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 01:37:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686818222; x=1718354222;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/a8SY8xTHheE09Xf91jCGd2LO1LsnY9iPE1RNBhkIjY=;
  b=dzMoOJfvEXbeqcUPodCjkh8BBBa1Jp+BTlmdKjhiLye6AAglq/AgM/1I
   wReYnXQ9auENjdmybDG0LMHiQSVkiNQI4YE46Ohagkq7gogQxddPBcjpC
   qFQGs+5J+WEB+HQCMdq31TQWmN7ChGhkHuuSn43IYvFo6QZ/COjIipbx9
   kuRzm4OgvKLMnAMHbL8J9leoh6lP1BZNZkjqDVmHPJ9YSl6Ef9U2cbmbd
   /Djqtk5O2COxiUMM+Vuntt4ouJToP0M42jXyIdjd9cGE9AgUfaWfzLwgS
   7XhgMFBC+K+jejtyCLezesp+8A3mGVoozWePZBzINc7c6pezJmdYOiLz7
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="361333850"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="361333850"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 01:37:01 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="836530460"
X-IronPort-AV: E=Sophos;i="6.00,244,1681196400"; 
   d="scan'208";a="836530460"
Received: from mszycik-mobl1.ger.corp.intel.com (HELO [10.249.144.96]) ([10.249.144.96])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 01:37:00 -0700
Message-ID: <a22c8701-0663-2c27-d866-492e7655fe5e@linux.intel.com>
Date: Thu, 15 Jun 2023 10:36:51 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH iproute2-next] f_flower: implement pfcp opts
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, dsahern@gmail.com,
 Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
References: <20230614091758.11180-1-marcin.szycik@linux.intel.com>
 <20230614095458.54140ac7@hermes.local>
Content-Language: en-US
From: Marcin Szycik <marcin.szycik@linux.intel.com>
In-Reply-To: <20230614095458.54140ac7@hermes.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 14.06.2023 18:54, Stephen Hemminger wrote:
> On Wed, 14 Jun 2023 11:17:58 +0200
> Marcin Szycik <marcin.szycik@linux.intel.com> wrote:
> 
>> +static void flower_print_pfcp_opts(const char *name, struct rtattr *attr,
>> +				   char *strbuf, int len)
>> +{
>> +	struct rtattr *tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX + 1];
>> +	struct rtattr *i = RTA_DATA(attr);
>> +	int rem = RTA_PAYLOAD(attr);
>> +	__be64 seid;
>> +	__u8 type;
>> +
>> +	parse_rtattr(tb, TCA_FLOWER_KEY_ENC_OPT_PFCP_MAX, i, rem);
>> +	type = rta_getattr_u8(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_TYPE]);
>> +	seid = rta_getattr_be64(tb[TCA_FLOWER_KEY_ENC_OPT_PFCP_SEID]);
>> +
>> +	snprintf(strbuf, len, "%02x:%llx", type, seid);
>> +}
>> +
> 
> NAK you need to support JSON output.
> Also whet if kernel gives partial data.

Hmm... when we were adding GTP opts parsing, you requested to remove JSON
support [1]. Are you sure you want us to add it here?

Could you elaborate about partial data? Are there any similar functions
which properly handle partial data?

[1] https://lore.kernel.org/netdev/20220127091541.6667d4d1@hermes.local

Regards,
Marcin

