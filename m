Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D169F6B6F4
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 08:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfGQGtR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 02:49:17 -0400
Received: from mga12.intel.com ([192.55.52.136]:34318 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725912AbfGQGtR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jul 2019 02:49:17 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Jul 2019 23:49:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,273,1559545200"; 
   d="scan'208";a="167877158"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga008.fm.intel.com with ESMTP; 16 Jul 2019 23:49:14 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 4/5] PTP: Add flag for non-periodic output
In-Reply-To: <20190716163927.GA2125@localhost>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190716072038.8408-5-felipe.balbi@linux.intel.com> <20190716163927.GA2125@localhost>
Date:   Wed, 17 Jul 2019 09:49:13 +0300
Message-ID: <87k1ch2m1i.fsf@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi Richard,

Richard Cochran <richardcochran@gmail.com> writes:

> On Tue, Jul 16, 2019 at 10:20:37AM +0300, Felipe Balbi wrote:
>> When this new flag is set, we can use single-shot output.
>> 
>> Signed-off-by: Felipe Balbi <felipe.balbi@linux.intel.com>
>> ---
>>  include/uapi/linux/ptp_clock.h | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
>> index 674db7de64f3..439cbdfc3d9b 100644
>> --- a/include/uapi/linux/ptp_clock.h
>> +++ b/include/uapi/linux/ptp_clock.h
>> @@ -67,7 +67,9 @@ struct ptp_perout_request {
>>  	struct ptp_clock_time start;  /* Absolute start time. */
>>  	struct ptp_clock_time period; /* Desired period, zero means disable. */
>>  	unsigned int index;           /* Which channel to configure. */
>> -	unsigned int flags;           /* Reserved for future use. */
>> +
>> +#define PTP_PEROUT_ONE_SHOT BIT(0)
>> +	unsigned int flags;           /* Bit 0 -> oneshot output. */
>>  	unsigned int rsv[4];          /* Reserved for future use. */
>
> Unfortunately, the code never checked that .flags and .rsv are zero,
> and so the de-facto ABI makes extending these fields impossible.  That
> was my mistake from the beginning.
>
> In order to actually support extensions, you will first have to
> introduce a new ioctl.

No worries, I'll work on this after vacations (I'll off for 2 weeks
starting next week). I thought about adding a new IOCTL until I saw that
rsv field. Oh well :-)

-- 
balbi
