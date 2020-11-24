Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741EE2C1D90
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 06:30:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728817AbgKXF3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 00:29:54 -0500
Received: from mxout70.expurgate.net ([91.198.224.70]:2586 "EHLO
        mxout70.expurgate.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKXF3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 00:29:53 -0500
Received: from [127.0.0.1] (helo=localhost)
        by relay.expurgate.net with smtp (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1khQtf-000MZZ-Fa; Tue, 24 Nov 2020 06:29:47 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
        by relay.expurgate.net with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ms@dev.tdt.de>)
        id 1khQte-0001dF-LO; Tue, 24 Nov 2020 06:29:46 +0100
Received: from securemail.tdt.de (localhost [127.0.0.1])
        by securemail.tdt.de (Postfix) with ESMTP id 0E08E240041;
        Tue, 24 Nov 2020 06:29:46 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
        by securemail.tdt.de (Postfix) with ESMTP id 7CF87240040;
        Tue, 24 Nov 2020 06:29:45 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id EF582204C2;
        Tue, 24 Nov 2020 06:29:44 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 24 Nov 2020 06:29:44 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Xie He <xie.he.0141@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Andrew Hendry <andrew.hendry@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Linux X25 <linux-x25@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v4 2/5] net/lapb: support netdev events
Organization: TDT AG
In-Reply-To: <CAJht_EOA4+DSjnKYZX3udrXX9jGHRmFw3OQesUb3AncD2oowwA@mail.gmail.com>
References: <20201120054036.15199-1-ms@dev.tdt.de>
 <20201120054036.15199-3-ms@dev.tdt.de>
 <CAJht_EONd3+S12upVPk2K3PWvzMLdE3BkzY_7c5gA493NHcGnA@mail.gmail.com>
 <CAJht_EP_oqCDs6mMThBZNtz4sgpbyQgMhKkHeqfS_7JmfEzfQg@mail.gmail.com>
 <87a620b6a55ea8386bffefca0a1f8b77@dev.tdt.de>
 <CAJht_EPc8MF1TjznSjWTPyMbsrw3JVqxST5g=eF0yf_zasUdeA@mail.gmail.com>
 <d85a4543eae46bac1de28ec17a2389dd@dev.tdt.de>
 <CAJht_EMjO_Tkm93QmAeK_2jg2KbLdv2744kCSHiZLy48aXiHnw@mail.gmail.com>
 <CAJht_EO+enBOFMkVVB5y6aRnyMEsOZtUBJcAvOFBS91y7CauyQ@mail.gmail.com>
 <16b7e74e6e221f43420da7836659d7df@dev.tdt.de>
 <CAJht_EPtPDOSYfwc=9trBMdzLw4BbTzJbGvaEgWoyiy2624Q+Q@mail.gmail.com>
 <20201123113622.115c474b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAJht_EOA4+DSjnKYZX3udrXX9jGHRmFw3OQesUb3AncD2oowwA@mail.gmail.com>
Message-ID: <39b6386b4ce7462f6cb4448020735ed5@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.15
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
X-purgate-type: clean
X-purgate: clean
X-purgate-ID: 151534::1606195787-00001F6B-CD377998/0/0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-23 23:09, Xie He wrote:
> On Mon, Nov 23, 2020 at 11:36 AM Jakub Kicinski <kuba@kernel.org> 
> wrote:
>> 
>> > >  From this point of view it will be the best to handle the NETDEV_UP in
>> > > the lapb event handler and establish the link analog to the
>> > > NETDEV_CHANGE event if the carrier is UP.
>> >
>> > Thanks! This way we can make sure LAPB would automatically connect in
>> > all situations.
>> >
>> > Since we'll have a netif_carrier_ok check in NETDEV_UP handing, it
>> > might make the code look prettier to also have a netif_carrier_ok
>> > check in NETDEV_GOING_DOWN handing (for symmetry). Just a suggestion.
>> > You can do whatever looks good to you :)
>> 
>> Xie other than this the patches look good to you?
>> 
>> Martin should I expect a respin to follow Xie's suggestion
>> or should I apply v4?
> 
> There should be a respin because we need to handle the NETDEV_UP
> event. The lapbether driver (and possibly some HDLC WAN drivers)
> doesn't generate carrier events so we need to do auto-connect in the
> NETDEV_UP event.

I'll send a v5 with the appropriate change.
