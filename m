Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E16E2D53D5
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 07:37:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732029AbgLJGhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 01:37:18 -0500
Received: from mxout70.expurgate.net ([194.37.255.70]:51535 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLJGhS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 01:37:18 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1knFXz-0003uC-7z; Thu, 10 Dec 2020 07:35:27 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90)
        (envelope-from <ms@dev.tdt.de>)
        id 1knFXx-0003GH-7Q; Thu, 10 Dec 2020 07:35:25 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 1F132240041;
        Thu, 10 Dec 2020 07:35:24 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 9E2E2240040;
        Thu, 10 Dec 2020 07:35:23 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id 4AF47202DE;
        Thu, 10 Dec 2020 07:35:23 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 10 Dec 2020 07:35:23 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: x25: Fix handling of Restart Request and
 Restart Confirmation
Organization: TDT AG
In-Reply-To: <CAJht_EPk4uzA+QeL0_nHBhNoaro48ieF1vTwxQihk5_D66GTEA@mail.gmail.com>
References: <20201209081604.464084-1-xie.he.0141@gmail.com>
 <7aed2f12bd42013e2d975280a3242136@dev.tdt.de>
 <dde53213f7e297690e054d01d815957f@dev.tdt.de>
 <CAJht_EPk4uzA+QeL0_nHBhNoaro48ieF1vTwxQihk5_D66GTEA@mail.gmail.com>
Message-ID: <8e15d185cabc9294958b13f5cff389aa@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-ID: 151534::1607582125-000064E4-79283030/0/0
X-purgate: clean
X-purgate-type: clean
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-12-09 21:16, Xie He wrote:
> On Wed, Dec 9, 2020 at 2:31 AM Martin Schiller <ms@dev.tdt.de> wrote:
>> 
>> >> 1. When the x25 module gets loaded, layer 2 may already be running and
>> >> connected. In this case, although we are in X25_LINK_STATE_0, we still
>> >> need to handle the Restart Request received, rather than ignore it.
>> >
>> > Hmm... I've never loaded the X.25 module after the interface is UP, but
>> > in this case we really have to fix it.
>> >
>> 
>> This seems to be a regression caused by moving the Layer2 link 
>> handling
>> into the lapb driver, which wasn't intended in my original patchset.
>> 
>> I also have another patch on my todo list which aims orphan packet
>> handling in the x25_receive_data() function. Maybe it is better to 
>> catch
>> the whole thing there.
> 
> OK..
> 
> Currently it's not clear to me what your future patches would be.
> Maybe we can first have this patch applied? Because based on the
> current code I think this patch is necessary. When you are ready to
> submit your patches, you can replace my code and we can discuss
> further.

Yes, that's also the reason why I already acked this patch. We can
solve this later a little bit cleaner if necessary.

My patch that takes care of the orphaned packets in x25_receive_data()
has again a dependency on other patches, especially the patch to
configure the neighbor parameters (DCE/DTE, number of channels etc.),
which I already sent before but still have to revise.

Unfortunately I have only limited time for this topic, so I am not as
fast as some people would wish. Sorry for that.

Martin
