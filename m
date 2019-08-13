Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B52398B1D3
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 09:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbfHMH6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 03:58:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:26608 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbfHMH6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 03:58:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Aug 2019 00:50:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,380,1559545200"; 
   d="scan'208";a="375517226"
Received: from pipin.fi.intel.com (HELO pipin) ([10.237.72.175])
  by fmsmga005.fm.intel.com with ESMTP; 13 Aug 2019 00:50:07 -0700
From:   Felipe Balbi <felipe.balbi@linux.intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        "Christopher S . Hall" <christopher.s.hall@intel.com>
Subject: Re: [RFC PATCH 0/5] PTP: add support for Intel's TGPIO controller
In-Reply-To: <20190719132021.GC24930@lunn.ch>
References: <20190716072038.8408-1-felipe.balbi@linux.intel.com> <20190718195040.GL25635@lunn.ch> <87h87isci5.fsf@linux.intel.com> <20190719132021.GC24930@lunn.ch>
Date:   Tue, 13 Aug 2019 10:50:06 +0300
Message-ID: <87wofhy05t.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

Andrew Lunn <andrew@lunn.ch> writes:
>> Andrew Lunn <andrew@lunn.ch> writes:
>> > On Tue, Jul 16, 2019 at 10:20:33AM +0300, Felipe Balbi wrote:
>> >> TGPIO is a new IP which allows for time synchronization between systems
>> >> without any other means of synchronization such as PTP or NTP. The
>> >> driver is implemented as part of the PTP framework since its features
>> >> covered most of what this controller can do.
>> >
>> > Hi Felipe
>> >
>> > Given the name TGPIO, can it also be used for plain old boring GPIO?
>> 
>> not really, no. This is a misnomer, IMHO :-) We can only assert output
>> pulses at specified intervals or capture a timestamp of an external
>> signal.
>
> Hi Felipe
>
> So i guess Intel Marketing wants to call it a GPIO, but between
> engineers can we give it a better name?

If we do that we make it difficult for those reading specification and
trying to find the matching driver.

>> > Also, is this always embedded into a SoC? Or could it actually be in a
>> > discrete NIC?
>> 
>> Technically, this could be done as a discrete, but it isn't. In any
>> case, why does that matter? From a linux-point of view, we have a device
>> driver either way.
>
> I've seen a lot of i210 used with ARM SoCs. How necessary is the tsc
> patch? Is there an architecture independent alternative?

Without the TSC patch, we don't get the timestamp we need. One can argue
that $this driver could call get_tsc_ns() directly instead of providing
a wrapper for it. But that's something else entirely.

-- 
balbi
