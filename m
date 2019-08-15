Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1539A8F5F9
	for <lists+netdev@lfdr.de>; Thu, 15 Aug 2019 22:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732720AbfHOUvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 16:51:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50078 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730540AbfHOUvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 16:51:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D40871401D397;
        Thu, 15 Aug 2019 13:51:11 -0700 (PDT)
Date:   Thu, 15 Aug 2019 13:51:11 -0700 (PDT)
Message-Id: <20190815.135111.1048854967874803531.davem@davemloft.net>
To:     wenwen@cs.uga.edu
Cc:     rfontana@redhat.com, allison@lohutok.net, alexios.zavras@intel.com,
        gregkh@linuxfoundation.org, tglx@linutronix.de,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: pch_gbe: Fix memory leaks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAAa=b7duRXsiVBfzbvHhoU000gGh53Mme3ZKCO5SoiTdgRaXtg@mail.gmail.com>
References: <CAAa=b7ft-crBJm+H9U7Bn2dcgfjQsE8o53p2ryBWK3seQoF3Cg@mail.gmail.com>
        <20190815.134230.1028411309377288636.davem@davemloft.net>
        <CAAa=b7duRXsiVBfzbvHhoU000gGh53Mme3ZKCO5SoiTdgRaXtg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 15 Aug 2019 13:51:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wenwen Wang <wenwen@cs.uga.edu>
Date: Thu, 15 Aug 2019 16:46:05 -0400

> On Thu, Aug 15, 2019 at 4:42 PM David Miller <davem@davemloft.net> wrote:
>>
>> From: Wenwen Wang <wenwen@cs.uga.edu>
>> Date: Thu, 15 Aug 2019 16:03:39 -0400
>>
>> > On Thu, Aug 15, 2019 at 3:34 PM David Miller <davem@davemloft.net> wrote:
>> >>
>> >> From: Wenwen Wang <wenwen@cs.uga.edu>
>> >> Date: Tue, 13 Aug 2019 20:33:45 -0500
>> >>
>> >> > In pch_gbe_set_ringparam(), if netif_running() returns false, 'tx_old' and
>> >> > 'rx_old' are not deallocated, leading to memory leaks. To fix this issue,
>> >> > move the free statements after the if branch.
>> >> >
>> >> > Signed-off-by: Wenwen Wang <wenwen@cs.uga.edu>
>> >>
>> >> Why would they be "deallocated"?  They are still assigned to
>> >> adapter->tx_ring and adapter->rx_ring.
>> >
>> > 'adapter->tx_ring' and 'adapter->rx_ring' has been covered by newly
>> > allocated 'txdr' and 'rxdr' respectively before this if statement.
>>
>> That only happens inside of the if() statement, that's why rx_old and
>> tx_old are only freed in that code path.
> 
> That happens not only inside of the if statement, but also before the
> if statement, just after 'txdr' and 'rxdr' are allocated.

Then the assignments inside of the if() statement are redundant.

Something doesn't add up here, please make the code consistent.
