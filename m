Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F3001441B6
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 17:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729045AbgAUQJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 11:09:12 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726555AbgAUQJM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 11:09:12 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDAF51585A86D;
        Tue, 21 Jan 2020 08:09:09 -0800 (PST)
Date:   Tue, 21 Jan 2020 17:09:05 +0100 (CET)
Message-Id: <20200121.170905.87149625206286035.davem@davemloft.net>
To:     gautamramk@gmail.com
Cc:     netdev@vger.kernel.org, tahiliani@nitk.edu.in, jhs@mojatatu.com,
        dave.taht@gmail.com, toke@redhat.com, kuba@kernel.org,
        stephen@networkplumber.org, lesliemonis@gmail.com
Subject: Re: [PATCH net-next v4 05/10] pie: rearrange structure members and
 their initializations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com>
References: <20200121141250.26989-6-gautamramk@gmail.com>
        <20200121.153522.1248409324581446114.davem@davemloft.net>
        <CADAms0zvGp4ffqmvZV6RVOTfrosjt6Ht6EkyQ594yJYQFTJBXA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jan 2020 08:09:11 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gautam Ramakrishnan <gautamramk@gmail.com>
Date: Tue, 21 Jan 2020 21:14:50 +0530

> On Tue, Jan 21, 2020 at 8:05 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: gautamramk@gmail.com
>> Date: Tue, 21 Jan 2020 19:42:44 +0530
>>
>> > From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>
>> >
>> > Rearrange the members of the structures such that they appear in
>> > order of their types. Also, change the order of their
>> > initializations to match the order in which they appear in the
>> > structures. This improves the code's readability and consistency.
>> >
>> > Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
>> > Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
>> > Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
>>
>> What matters for structure member ordering is dense packing and
>> grouping commonly-used-together elements for performance.
>>
> We shall reorder the variables as per their appearance in the
> structure and re-submit. Could you elaborate a bit on dense packing?

It means eliminating unnecessary padding in the structure.  F.e. if
you have:

	u32	x;
	u64	y;

Then 32-bits of wasted space will be inserted after 'x' so that
'y' is properly 64-bit aligned.

If in doubt use the 'pahole' tool to see how the structure is
laid out.  It will show you where unnecessary padding exists as
well.
