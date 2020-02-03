Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17706150F57
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 19:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgBCS1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 13:27:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:48173 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727124AbgBCS1a (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 13:27:30 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Feb 2020 10:27:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,398,1574150400"; 
   d="scan'208";a="278822787"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [134.134.177.86]) ([134.134.177.86])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Feb 2020 10:27:28 -0800
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
To:     Richard Cochran <richardcochran@gmail.com>,
        christopher.s.hall@intel.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, hpa@zytor.com, mingo@redhat.com,
        x86@kernel.org, davem@davemloft.net, sean.v.kelley@intel.com
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <20200203040838.GA5851@localhost>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <85f42aa9-65fa-121b-a24d-017b56c61267@intel.com>
Date:   Mon, 3 Feb 2020 10:27:28 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <20200203040838.GA5851@localhost>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/2/2020 8:08 PM, Richard Cochran wrote:
> On Wed, Dec 11, 2019 at 01:48:47PM -0800, christopher.s.hall@intel.com wrote:
>> The ART frequency is not adjustable. In order, to implement output
>> adjustments an additional edge-timestamp API is added, as well, as
>> a periodic output frequency adjustment API. Togther, these implement
>> equivalent functionality to the existing SYS_OFFSET_* and frequency
>> adjustment APIs.
> 
> I don't see a reason for a custom, new API just for this device.
> 
> The TGPIO input clock, the ART, is a free running counter, but you
> want to support frequency adjustments.  Use a timecounter cyclecounter
> pair.
> 
> Let the user dial a periodic output signal in the normal way.
> 
> Let the user change the frequency in the normal way, and during this
> call, adjust the counter values accordingly.
> 

To add:

in order to program the pin output correctly, you may need to reverse
the timecounter/cyclecounter calculations. I recall doing something
similar in ixgbe for programming the correct output signal to match.

It may actually be worth adding helper functions to the timecounter
system for doing those kind of reverse calculations for converting from
a time value back into cycles.

> Thanks,
> Richard
> 
