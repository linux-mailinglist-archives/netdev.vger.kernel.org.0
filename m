Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34E7D14787
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 11:18:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbfEFJSr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 05:18:47 -0400
Received: from www62.your-server.de ([213.133.104.62]:36978 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfEFJSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 05:18:46 -0400
Received: from [88.198.220.132] (helo=sslproxy03.your-server.de)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNZlk-0007m5-Jj; Mon, 06 May 2019 11:18:44 +0200
Received: from [2a02:120b:c3fc:feb0:dda7:bd28:a848:50e2] (helo=linux.home)
        by sslproxy03.your-server.de with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <daniel@iogearbox.net>)
        id 1hNZlk-0007E6-AG; Mon, 06 May 2019 11:18:44 +0200
Subject: Re: [bpf-next PATCH v3 0/4] sockmap/ktls fixes
To:     John Fastabend <john.fastabend@gmail.com>,
        jakub.kicinski@netronome.com, ast@kernel.org
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
References: <155667629056.4128.14102391877350907561.stgit@john-XPS-13-9360>
 <c6621617-9edf-bd4a-7738-63de6e910eb4@gmail.com>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <1bf04abf-478b-28c3-21df-0be049074f0f@iogearbox.net>
Date:   Mon, 6 May 2019 11:18:43 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.3.0
MIME-Version: 1.0
In-Reply-To: <c6621617-9edf-bd4a-7738-63de6e910eb4@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25441/Mon May  6 10:04:24 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/02/2019 10:05 PM, John Fastabend wrote:
> On 4/30/19 7:06 PM, John Fastabend wrote:
>> Series of fixes for sockmap and ktls, see patches for descriptions.
>>
>> v2: fix build issue for CONFIG_TLS_DEVICE and fixup couple comments
>>     from Jakub
>>
>> v3: fix issue where release could call unhash resulting in a use after
>>     free. Now we detach the ulp pointer before calling into destroy
>>     or unhash. This way if we get a callback into unhash from destroy
>>     path there is no ulp to access. The fallout is we must pass the
>>     ctx into the functions rather than use the sk lookup in each
>>     routine. This is probably better anyways.
>>
>>     @Jakub, I did not fix the hw device case it seems the ulp ptr is
>>     needed for the hardware teardown but this is buggy for sure. Its
>>     not clear to me how to resolve the hw issue at the moment so fix
>>     the sw path why we discuss it.
>>
> Unfortunately, this is still failing with hardware offload (thanks
> Jakub) so will need a v4 to actually fix this.

Perhaps split off the skmsg fixes from the series so they can already
be applied since they should be independent of the tlx fix?

Thanks,
Daniel
