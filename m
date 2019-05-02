Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9FBA1235E
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 22:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfEBU3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 16:29:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:23029 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726022AbfEBU3t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 May 2019 16:29:49 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 13:29:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,423,1549958400"; 
   d="scan'208";a="145539253"
Received: from dalhanat-mobl3.ger.corp.intel.com (HELO btopel-mobl.ger.intel.com) ([10.255.41.107])
  by fmsmga008.fm.intel.com with ESMTP; 02 May 2019 13:29:46 -0700
Subject: Re: [net-next 01/12] i40e: replace switch-statement to speed-up
 retpoline-enabled builds
To:     Daniel Borkmann <daniel@iogearbox.net>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
References: <20190429191628.31212-1-jeffrey.t.kirsher@intel.com>
 <20190429191628.31212-2-jeffrey.t.kirsher@intel.com>
 <806f5242-d509-e015-275e-ad0325f17222@iogearbox.net>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Message-ID: <0c73af48-d638-dd58-fcf8-c872ff8591d7@intel.com>
Date:   Thu, 2 May 2019 22:29:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <806f5242-d509-e015-275e-ad0325f17222@iogearbox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-02 16:47, Daniel Borkmann wrote:
> On 04/29/2019 09:16 PM, Jeff Kirsher wrote:
>> From: Björn Töpel <bjorn.topel@intel.com>
>>
>> GCC will generate jump tables for switch-statements with more than 5
>> case statements. An entry into the jump table is an indirect call,
>> which means that for CONFIG_RETPOLINE builds, this is rather
>> expensive.
>>
>> This commit replaces the switch-statement that acts on the XDP program
>> result with an if-clause.
>>
>> The if-clause was also refactored into a common function that can be
>> used by AF_XDP zero-copy and non-zero-copy code.
> 
> Isn't it fixed upstream by now already (also in gcc)?
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=ce02ef06fcf7a399a6276adb83f37373d10cbbe1
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a9d57ef15cbe327fe54416dd194ee0ea66ae53a4
> 

Hmm, given that Daniel's work is upstream, this patch doesn't really
make sense any more. OTOH it can stay in the series, and be cleaned up
later.

I'll leave it for you to decide, Jeff!


Cheers,
Björn
