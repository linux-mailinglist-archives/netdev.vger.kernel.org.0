Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 294E33BE928
	for <lists+netdev@lfdr.de>; Wed,  7 Jul 2021 15:59:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhGGOCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Jul 2021 10:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbhGGOCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Jul 2021 10:02:09 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80667C061574;
        Wed,  7 Jul 2021 06:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
         s=42; h=Date:Message-ID:From:Cc:To;
        bh=xuGmJhz3sxUrlzylz+fYSwJZSsCIiXutJD1UKv9KiXs=; b=vrx+EcqFoB0FN7ecC8Rc8vKbRQ
        BZHl5uxpCgwbFYMW5HmbU8rzODOJs06rN9ARXQlmWir500Y3s9lglCqqd799fyIKypEBBJJHdOHsb
        PylGWXiyDT10Z/Nw5uQTShEz/SgaXEmA196/fzZ9pd+Blu3MBYZozqvewJTUqdR+amfEN1A3u1yvg
        LLWqHd/5iUe79cc6iwf/p4dSpKntltxzDde7q7KgyqOCbfYDN12kiIRfyqBSYA3kHmfm3wvjf1p6K
        YyUev7Q4k9qyTxuoEiMejw2jH0MDHJRdkuSspFxKkjsTjxe5E/1PHXCn6++ZwI6PkOqbNtQP8EaGS
        oFxFBeftsN3sEbaMrwWckm+oJkK0/ZWXS9v+nWYNo5ygG+TIL1RdP17I7jxU1fmwAMP+2dOETj1Th
        hKhFvd3m4Iid4wu0+koyreXQvV1ev4T/1xWEkAzCeTJ+3jZTOmqoL0wjPIa0ZhK4xKZiLT5UQqPGB
        K4r30Y/kbDJ0ZKdMqmN/f6EU;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_RSA_CHACHA20_POLY1305:256)
        (Exim)
        id 1m185E-0001e6-SA; Wed, 07 Jul 2021 13:59:24 +0000
Subject: Re: [RFC 0/4] open/accept directly into io_uring fixed file table
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>
References: <cover.1625657451.git.asml.silence@gmail.com>
 <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
From:   Stefan Metzmacher <metze@samba.org>
Message-ID: <4accdfa5-36fc-7de8-f4b2-7609b6f9d8ee@samba.org>
Date:   Wed, 7 Jul 2021 15:59:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <48bd91bc-ba1a-1e69-03a1-3d6f913f96c3@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 07.07.21 um 15:07 schrieb Jens Axboe:
> On 7/7/21 5:39 AM, Pavel Begunkov wrote:
>> Implement an old idea allowing open/accept io_uring requests to register
>> a newly created file as a io_uring's fixed file instead of placing it
>> into a task's file table. The switching is encoded in io_uring's SQEs
>> by setting sqe->buf_index/file_index, so restricted to 2^16-1. Don't
>> think we need more, but may be a good idea to scrap u32 somewhere
>> instead.
>>
>> From the net side only needs a function doing __sys_accept4_file()
>> but not installing fd, see 2/4.
>>
>> Only RFC for now, the new functionality is tested only for open yet.
>> I hope we can remember the author of the idea to add attribution.
> 
> Pretty sure the original suggester of this as Josh, CC'ed.

I also requested it for open :-)

metze

