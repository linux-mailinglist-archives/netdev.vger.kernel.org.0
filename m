Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDC3E16B9BB
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 07:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729057AbgBYG3X convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Feb 2020 01:29:23 -0500
Received: from coyote.holtmann.net ([212.227.132.17]:41713 "EHLO
        mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgBYG3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 01:29:22 -0500
Received: from marcel-macpro.fritz.box (p4FEFC5A7.dip0.t-ipconnect.de [79.239.197.167])
        by mail.holtmann.org (Postfix) with ESMTPSA id C500DCECC5;
        Tue, 25 Feb 2020 07:38:46 +0100 (CET)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: WARNING: refcount bug in l2cap_chan_put
From:   Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <CABBYNZJzxO=aTnYOL7UpDzK+PDNcAa-DuH_5N+FZV6OZp52uFA@mail.gmail.com>
Date:   Tue, 25 Feb 2020 07:29:20 +0100
Cc:     Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
        syzbot <syzbot+198362c76088d1515529@syzkaller.appspotmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bluez mailing list <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, syzkaller-bugs@googlegroups.com
Content-Transfer-Encoding: 8BIT
Message-Id: <9D797053-B09C-4AB8-8C32-E572E57F9140@holtmann.org>
References: <0000000000000cce30059f4e27e9@google.com>
 <CANFp7mWobejCpiq5xXouKAcRBSAbVwxKOnFbJ_XfiU6rLsT0Vw@mail.gmail.com>
 <CABBYNZJzxO=aTnYOL7UpDzK+PDNcAa-DuH_5N+FZV6OZp52uFA@mail.gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Luiz,

>> (Resent in plain text; sorry for double send)
>> 
>> I took a brief look at this error and uncovered that 6lowpan uses zero
>> locks when using l2cap (should be using the channel lock).
>> 
>> It seems like it would be better just to convert its direct use of
>> l2cap channel into using an l2cap socket.
> 
> I recall having some thought on that, I think having a socket like
> RFCOMM does would be better but I don't remember why I haven't
> follow-up on that, well we wanted to discontinue the bt specific
> 6lowpan on the kernel side though.

because sockets have their own locking issues for Bluetooth. We actually want to get rid of the internal socket usage.

Regards

Marcel

