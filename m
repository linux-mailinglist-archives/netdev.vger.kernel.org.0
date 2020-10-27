Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3157B29CC8F
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 00:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832898AbgJ0XGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 19:06:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:1581 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1832894AbgJ0XGl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:06:41 -0400
IronPort-SDR: XaoQ0lxkqDZMb1Q4ye341gcYdJ/K+RrTTVwzJukLKbh4wVyj3GrtQYa/6j2bZ6MsCGG43cbaXM
 Bg1F9ngGOFzw==
X-IronPort-AV: E=McAfee;i="6000,8403,9787"; a="185927180"
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="185927180"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 16:06:41 -0700
IronPort-SDR: ORVeemA/euaMKWtuWWgQhJI4twC5jSMpqznjjbJusW5rhsR9z3l2ZTcD8JsjeI6cr9HQ7Ji0Dt
 JLqNmUjZYKdA==
X-IronPort-AV: E=Sophos;i="5.77,424,1596524400"; 
   d="scan'208";a="350781638"
Received: from jekeller-mobl1.amr.corp.intel.com (HELO [10.212.204.205]) ([10.212.204.205])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2020 16:06:41 -0700
Subject: Re: checkpatch.pl broke in net-next
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e8ea2204-b74a-3b75-c257-0f8acbb916a6@intel.com>
 <20201027160331.05677f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Jacob Keller <jacob.e.keller@intel.com>
Organization: Intel Corporation
Message-ID: <16e7dbd1-12e6-11fb-ffc1-49694d25f323@intel.com>
Date:   Tue, 27 Oct 2020 16:06:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201027160331.05677f55@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/27/2020 4:03 PM, Jakub Kicinski wrote:
> On Tue, 27 Oct 2020 15:56:35 -0700 Jacob Keller wrote:
>> Hi Jakub,
>>
>> It looks like net-next just pulled in a change to checkpatch.pl which
>> causes it to break:
>>
>> $ ./scripts/checkpatch.pl
>> Global symbol "$gitroot" requires explicit package name (did you forget
>> to declare "my $gitroot"?) at ./scripts/checkpatch.pl line 980.
>> Execution of ./scripts/checkpatch.pl aborted due to compilation errors.
>> ERROR: checkpatch.pl failed: 255
>>
>> It is caused by commit f5f613259f3f ("checkpatch: allow not using -f
>> with files that are in git"), which appears to make use of "$gitroot".
>>
>> This variable doesn't exist, so of course the perl script breaks.
>>
>> This commit appears in Linus' tree, and must have been picked up when we
>> merged with his tree.
>>
>> This issue is fixed by 0f7f635b0648 ("checkpatch: enable GIT_DIR
>> environment use to set git repository location") which is the commit
>> that actually introduces $gitroot.
>>
>> Any chance we can get this merged into net-next? It has broken our
>> automation that runs checkpatch.pl
> 
> That and kvm broke the 32 bit x86 build :/
> 
> I will submit net to Linus on Thu, and pull back from him to net and
> net-next. That'll fix it.
> 

Sounds good, thanks.
