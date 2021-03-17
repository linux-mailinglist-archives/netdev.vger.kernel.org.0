Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49C3233F5BF
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 17:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232632AbhCQQkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 12:40:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58440 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhCQQjb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 12:39:31 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 695684FC83BE2;
        Wed, 17 Mar 2021 09:39:30 -0700 (PDT)
Date:   Wed, 17 Mar 2021 09:39:26 -0700 (PDT)
Message-Id: <20210317.093926.47944613217780721.davem@davemloft.net>
To:     menglong8.dong@gmail.com
Cc:     linux@roeck-us.net, andy.shevchenko@gmail.com, kuba@kernel.org,
        axboe@kernel.dk, viro@zeniv.linux.org.uk,
        herbert@gondor.apana.org.au, dong.menglong@zte.com.cn,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4 RESEND net-next] net: socket: use BIT() for MSG_*
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
References: <CAHp75VdE3fkCjb53vBso5uJX9aEFtAOAdh5NVOSbK0YR64+jOg@mail.gmail.com>
        <20210317013758.GA134033@roeck-us.net>
        <CADxym3bu0Ds6dD6OhyvdzbWDW-KqXsqGGxt3HKj-dsedFn9GXg@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 17 Mar 2021 09:39:30 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <menglong8.dong@gmail.com>
Date: Wed, 17 Mar 2021 16:21:14 +0800

> Hello,
> 
> On Wed, Mar 17, 2021 at 9:38 AM Guenter Roeck <linux@roeck-us.net> wrote:
>>
>> On Wed, Mar 17, 2021 at 01:02:51AM +0200, Andy Shevchenko wrote:
>> > On Wednesday, March 17, 2021, Guenter Roeck <linux@roeck-us.net> wrote:
>> >
> ...
>>
>> The problem is in net/packet/af_packet.c:packet_recvmsg(). This function,
>> as well as all other rcvmsg functions, is declared as
>>
>> static int packet_recvmsg(struct socket *sock, struct msghdr *msg, size_t len,
>>                           int flags)
>>
>> MSG_CMSG_COMPAT (0x80000000) is set in flags, meaning its value is negative.
>> This is then evaluated in
>>
>>        if (flags & ~(MSG_PEEK|MSG_DONTWAIT|MSG_TRUNC|MSG_CMSG_COMPAT|MSG_ERRQUEUE))
>>                 goto out;
> So what should I do? Revert this patch? Or fix the usages of 'flags'?

I already reverted this patch from net-next to fix the regression.
