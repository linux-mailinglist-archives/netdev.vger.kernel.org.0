Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD48473412
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241902AbhLMScq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:32:46 -0500
Received: from mga03.intel.com ([134.134.136.65]:62035 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235897AbhLMScj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 13:32:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639420359; x=1670956359;
  h=from:to:cc:subject:in-reply-to:references:date:
   message-id:mime-version;
  bh=rR5wDnxhbQ3N8e1axn4/M4hEIyEIJ9oj/UGYIs4GJVg=;
  b=FBXCTi1ZPLQMs1bbd6/BCdsPRk2PwuEwNrWX22agiwoHVgXTJSznNmoM
   fbsH0ZCEH4qbljchemJV/u2OH5GXLxwutvhpT1BYY2tDGGlFDTQ7ds42u
   YRqKSlhDB3byvmYHmiX9qJJfo40P6odpWtC1Ck3C4Xt9+QzqmNZVh0ln1
   qTO/xaFSqr729PXB1GWfq6CyTxvItCVKeLgGesrr3q/WLNAEApIEbS874
   TPH76Kw4if5eKLJfErijKU+ZIj/cysuSuBCr7g7qnC192pNTUEZlGIGIs
   AiRmvNmzOsESXU92vwA4ln5EQJhBbAGAqekES71dyBX9OQI8xK8+b0qF8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10197"; a="238744019"
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="238744019"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 10:32:21 -0800
X-IronPort-AV: E=Sophos;i="5.88,203,1635231600"; 
   d="scan'208";a="481612683"
Received: from robertki-mobl1.amr.corp.intel.com (HELO vcostago-mobl3) ([10.251.4.188])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Dec 2021 10:32:20 -0800
From:   Vinicius Costa Gomes <vinicius.gomes@intel.com>
To:     Stefan Dietrich <roots@gmx.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     kuba@kernel.org, greg@kroah.com, netdev@vger.kernel.org,
        intel-wired-lan@lists.osuosl.org, regressions@lists.linux.dev
Subject: Re: [PATCH] igc: Avoid possible deadlock during suspend/resume
In-Reply-To: <6bcce8e66fde064fd2879e802970bb4a8f382743.camel@gmx.de>
References: <87r1awtdx3.fsf@intel.com>
 <20211201185731.236130-1-vinicius.gomes@intel.com>
 <5a4b31d43d9bf32e518188f3ef84c433df3a18b1.camel@gmx.de>
 <87o85yljpu.fsf@intel.com>
 <063995d8-acf3-9f33-5667-f284233c94b4@leemhuis.info>
 <8e59b7d6b5d4674d5843bb45dde89e9881d0c741.camel@gmx.de>
 <5c5b606a-4694-be1b-0d4b-80aad1999bd9@leemhuis.info>
 <d4c9bb101aa79c5acaaa6dd7b42159fb0c91a341.camel@gmx.de>
 <87h7bgrn0j.fsf@intel.com>
 <6bcce8e66fde064fd2879e802970bb4a8f382743.camel@gmx.de>
Date:   Mon, 13 Dec 2021 10:32:19 -0800
Message-ID: <87wnk8qrt8.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stefan,

Stefan Dietrich <roots@gmx.de> writes:

> Hi Vinicius,
>
> thanks a lot - that patch fixed it! Both "normal" shutdown as well as
> ifdown/ifup are working without issues now if CONFIG_PCIE_PTM is
> enabled in the kernel config.

Great!

This patch is mostly to give us time to investigate, this seems to be an
issue related to that specific i225 model. I have to track one down and
perhaps talk to the hardware folks and see what I am doing wrong.

>
> I've done a DSL download/upload speed comparison against my current
> 5.14.0-19.2 and did not see any performance differences outside margin
> of error. I currently have no other Linux machine I could use for iperf
> but I will report if I encounter any issues.
>

I wasn't expecting any changes in performance, I was more asking if you
had some use case for PCIe PTM, and something stopped working. It seems
that the answer is no. That's good.

> As I am not familiar with the kernel development procedure: can you
> give a rough estimate when we may expect this patch in the stable
> branch?

I will write a useful commit message, take another closer look to see if
I am still missing something and propose the patch upstream. From there
until it's accepted in a stable tree, I guess it could take a few days,
a week, perhaps.

>
>
> Thanks again,
> Stefan
>
>
>
> On Fri, 2021-12-10 at 16:41 -0800, Vinicius Costa Gomes wrote:
>> Hi Stefan,
>>
>> Stefan Dietrich <roots@gmx.de> writes:
>>
>> > Agreed and thanks for the pointers; please see the log files and
>> > .config attached as requested.
>> >
>>
>> Thanks for the logs.
>>
>> Very interesting that the initialization of the device is fine, so
>> it's
>> something that happens later.
>>
>> Can you test the attached patch?
>>
>> If the patch works, I would also be interested if you notice any loss
>> of
>> functionality with your NIC. (I wouldn't think so, as far as I know,
>> i225-V models have PTM support but don't have any PTP support).
>>
>> > Cheers,
>> > Stefan
>> >
>> >
>> > On Fri, 2021-12-10 at 15:01 +0100, Thorsten Leemhuis wrote:
>> > > On 10.12.21 14:45, Stefan Dietrich wrote:
>> > > > thanks for keeping an eye on the issue. I've sent the files in
>> > > > private
>> > > > because I did not want to spam the mailing lists with them.
>> > > > Please
>> > > > let
>> > > > me know if this is the correct procedure.
>>
>> Cheers,
>

Cheers,
-- 
Vinicius
