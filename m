Return-Path: <netdev+bounces-11491-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 768E2733579
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:10:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B18121C20FC5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B823819E6F;
	Fri, 16 Jun 2023 16:10:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8BA19E67
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:10:40 +0000 (UTC)
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7B782132;
	Fri, 16 Jun 2023 09:10:37 -0700 (PDT)
Message-ID: <908bd8bd-8629-f6e4-40f9-77454d52100d@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1686931835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p6oLGVNweNaAz9q3bwuoYd9B/Su73SFzlRNr+jNmEvE=;
	b=SY76/pwnrynNqSpqjc/Zb1ewlNXjQzd9ft/z0dKhl07xiDvwJ3CXoEN46jykySHfCCspy5
	bYfMkHTnaZFXL0QFi7CGZawfDZwJvcPQtwAcvpemxy4M5X2W/WWs7NFOR0vfBdFKsAWKwp
	aGqZ4up7QeVsFxX/Nd+hUuatiJMiwuYJvC47J2VUMbH65MtMStBW2GQww06uAkMCw/tzCp
	WXrjhKztze7bExFcS3ed5oxi16PdrpPnaOjVMiVETmvqk1lm0gSYiXzyb3ENNZqlRYx5p5
	/iYmtb2CfdOScXqB0ZuPLyhXxNn364ze1hWHkMsRAoGb6MHqsl1njgGsyvfrnw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1686931835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p6oLGVNweNaAz9q3bwuoYd9B/Su73SFzlRNr+jNmEvE=;
	b=1SdLEoLL3wNqoCtB9hlwsLf0ucyx4G5+RrAPvrUc8FNLzhg292NbCQynDeaTGWPTdYaH7S
	WiUcFHkcxOyKeSCw==
Date: Fri, 16 Jun 2023 18:10:32 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Language: en-US
To: "Zulkifli, Muhammad Husaini" <muhammad.husaini.zulkifli@intel.com>,
 "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
 "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
 "Gomes, Vinicius" <vinicius.gomes@intel.com>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Tan Tee Min <tee.min.tan@linux.intel.com>,
 "Gunasekaran, Aravindhan" <aravindhan.gunasekaran@intel.com>,
 "Chilakala, Mallikarjuna" <mallikarjuna.chilakala@intel.com>
Cc: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "kurt@linutronix.de" <kurt@linutronix.de>
References: <20230614140714.14443-1-florian.kauer@linutronix.de>
 <SJ1PR11MB6180B5C87699252B91FB7EE1B858A@SJ1PR11MB6180.namprd11.prod.outlook.com>
From: Florian Kauer <florian.kauer@linutronix.de>
Subject: Re: [PATCH net-next 0/6] igc: Fix corner cases for TSN offload
In-Reply-To: <SJ1PR11MB6180B5C87699252B91FB7EE1B858A@SJ1PR11MB6180.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 16.06.23 17:53, Zulkifli, Muhammad Husaini wrote:
>> Florian Kauer (6):
>>   igc: Rename qbv_enable to taprio_offload_enable
>>   igc: Do not enable taprio offload for invalid arguments
>>   igc: Handle already enabled taprio offload for basetime 0
>>   igc: No strict mode in pure launchtime/CBS offload
>>   igc: Fix launchtime before start of cycle
>>   igc: Fix inserting of empty frame for launchtime
> 
> All six patches, as far as I can see here, have the Fixes tag. Should they go to Net instead of Net-Next?

You are correct, these are all fixes and could go to net.
However, in its current form they will not fully apply to net 
(e.g. due to the commit 2d800bc500fb ("net/sched: taprio: replace tc_taprio_qopt_offload :: enable with a "cmd" enum")
that has overlapping code changes) and are also not tested with net. 
If you prefer to have them in net already I could send a second series.
For me personally all options (net, net-next or iwl-next) would be fine.

Thanks,
Florian

