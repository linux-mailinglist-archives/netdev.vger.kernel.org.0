Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A7B922D216
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 01:12:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgGXXMA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 19:12:00 -0400
Received: from mga04.intel.com ([192.55.52.120]:19091 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726438AbgGXXMA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Jul 2020 19:12:00 -0400
IronPort-SDR: kdQYQhAbn4+6ZIGa9GhlgW6/AM3D4jAfJ3VEG/nWoQpiDwA+6B4iZt3+2K+zWelYOVVXBsZ/Um
 PItmgp4aXcyw==
X-IronPort-AV: E=McAfee;i="6000,8403,9692"; a="148281972"
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="148281972"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jul 2020 16:11:58 -0700
IronPort-SDR: 22DXrr07uwr7NEldS6kJ7cOEQhwSjvWNXbGYq91IJGf27iqRbDgPlUxDncA6tVLjyye/YZ8/qQ
 1ioPmEbssuDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,392,1589266800"; 
   d="scan'208";a="289132518"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.254.52.44]) ([10.254.52.44])
  by orsmga006.jf.intel.com with ESMTP; 24 Jul 2020 16:11:57 -0700
Subject: Re: [RFC 2/7] ath10k: Add support to process rx packet in thread
To:     Rakesh Pillai <pillair@codeaurora.org>,
        'Rajkumar Manoharan' <rmanohar@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        johannes@sipsolutions.net, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dianders@chromium.org,
        evgreen@chromium.org, linux-wireless-owner@vger.kernel.org
References: <1595351666-28193-1-git-send-email-pillair@codeaurora.org>
 <1595351666-28193-3-git-send-email-pillair@codeaurora.org>
 <13573549c277b34d4c87c471ff1a7060@codeaurora.org>
 <003001d6611e$9afa0cc0$d0ee2640$@codeaurora.org>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <0d9baad4-fba7-d362-41b7-f0b37446c5ef@intel.com>
Date:   Fri, 24 Jul 2020 16:11:57 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0.1
MIME-Version: 1.0
In-Reply-To: <003001d6611e$9afa0cc0$d0ee2640$@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/23/2020 11:25 AM, Rakesh Pillai wrote:
> Hi Rajkumar,
> In linux, the IRQs are directed to the first core which is booted.
> I see that all the IRQs are getting routed to CORE0 even if its heavily
> loaded.
> 

You should be able to configure the initial IRQ setup so that they don't
all go on CPU 0 when you create the IRQ. That obviously doesn't help the
case of wanting scheduler to dynamically move the processing around to
other CPUs though.
