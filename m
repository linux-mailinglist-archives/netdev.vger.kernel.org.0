Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5517411EEFE
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 01:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726642AbfLNAGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Dec 2019 19:06:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:20151 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726345AbfLNAGU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Dec 2019 19:06:20 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Dec 2019 16:06:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,311,1571727600"; 
   d="scan'208";a="216583684"
Received: from amhui-mobl1.amr.corp.intel.com ([10.251.3.80])
  by orsmga006.jf.intel.com with ESMTP; 13 Dec 2019 16:06:19 -0800
Date:   Fri, 13 Dec 2019 16:06:19 -0800 (PST)
From:   Mat Martineau <mathew.j.martineau@linux.intel.com>
X-X-Sender: mjmartin@amhui-mobl1.amr.corp.intel.com
To:     Eric Dumazet <eric.dumazet@gmail.com>
cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next 02/11] sock: Make sk_protocol a 16-bit value
In-Reply-To: <9a83715c-92c3-7e3e-304d-34b1d9285138@gmail.com>
Message-ID: <alpine.OSX.2.21.1912131555280.38100@amhui-mobl1.amr.corp.intel.com>
References: <20191213230022.28144-1-mathew.j.martineau@linux.intel.com> <20191213230022.28144-3-mathew.j.martineau@linux.intel.com> <9a83715c-92c3-7e3e-304d-34b1d9285138@gmail.com>
User-Agent: Alpine 2.21 (OSX 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, 13 Dec 2019, Eric Dumazet wrote:

>
>
> On 12/13/19 3:00 PM, Mat Martineau wrote:
>> Match the 16-bit width of skbuff->protocol. Fills an 8-bit hole so
>> sizeof(struct sock) does not change.
>>
>> Signed-off-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
>> ---
>>  include/net/sock.h          | 4 ++--
>>  include/trace/events/sock.h | 2 +-
>>  2 files changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/net/sock.h b/include/net/sock.h
>> index 81dc811aad2e..9dd225f62012 100644
>> --- a/include/net/sock.h
>> +++ b/include/net/sock.h
>> @@ -456,10 +456,10 @@ struct sock {
>>  				sk_no_check_tx : 1,
>>  				sk_no_check_rx : 1,
>>  				sk_userlocks : 4,
>> -				sk_protocol  : 8,
>> +				sk_pacing_shift : 8,
>>  				sk_type      : 16;
>> +	u16			sk_protocol;
>>  	u16			sk_gso_max_segs;
>> -	u8			sk_pacing_shift;
>
> Unfortunately sk_pacing_shift must not be a bit field.
>
> I have a patch to add proper READ_ONCE()/WRITE_ONCE() on it,
> since an update can be done from a lockless context ( sk_pacing_shift_update())

Ok, thanks for noting this. I'll remove the change to sk_pacing_shift.

--
Mat Martineau
Intel
