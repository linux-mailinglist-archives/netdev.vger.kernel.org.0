Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A22C13AB2B
	for <lists+netdev@lfdr.de>; Tue, 14 Jan 2020 14:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbgANNd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 08:33:56 -0500
Received: from host-88-217-225-28.customer.m-online.net ([88.217.225.28]:43646
        "EHLO mail.dev.tdt.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726106AbgANNd4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 08:33:56 -0500
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
        by mail.dev.tdt.de (Postfix) with ESMTP id B0457207D2;
        Tue, 14 Jan 2020 13:33:51 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 14 Jan 2020 14:33:51 +0100
From:   Martin Schiller <ms@dev.tdt.de>
To:     Jakub Kicinski <kubakici@wp.pl>
Cc:     khc@pm.waw.pl, davem@davemloft.net, linux-x25@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] wan/hdlc_x25: make lapb params configurable
Organization: TDT AG
In-Reply-To: <20200114045149.4e97f0ac@cakuba>
References: <20200113124551.2570-1-ms@dev.tdt.de>
 <20200113055316.4e811276@cakuba>
 <83f60f76a0cf602c73361ccdb34cc640@dev.tdt.de>
 <20200114045149.4e97f0ac@cakuba>
Message-ID: <3b439730f93e29c9e823126b74c2fbd3@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.1.5
X-Spam-Status: No, score=-1.0 required=5.0 tests=ALL_TRUSTED autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.dev.tdt.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-01-14 13:51, Jakub Kicinski wrote:
> On Tue, 14 Jan 2020 06:37:03 +0100, Martin Schiller wrote:
>> >> diff --git a/include/uapi/linux/hdlc/ioctl.h
>> >> b/include/uapi/linux/hdlc/ioctl.h
>> >> index 0fe4238e8246..3656ce8b8af0 100644
>> >> --- a/include/uapi/linux/hdlc/ioctl.h
>> >> +++ b/include/uapi/linux/hdlc/ioctl.h
>> >> @@ -3,7 +3,7 @@
>> >>  #define __HDLC_IOCTL_H__
>> >>
>> >>
>> >> -#define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc
>> >> utility */
>> >> +#define GENERIC_HDLC_VERSION 5	/* For synchronization with sethdlc
>> >> utility */
>> >
>> > What's the backward compatibility story in this code?
>> 
>> Well, I thought I have to increment the version to keep the kernel 
>> code
>> and the sethdlc utility in sync (like the comment says).
> 
> Perhaps I chose the wrong place for asking this question, IOCTL code
> was my real worry. I don't think this version number is validated so
> I think bumping it shouldn't break anything?

sethdlc validates the GENERIC_HDLC_VERSION at compile time.

https://mirrors.edge.kernel.org/pub/linux/utils/net/hdlc/

Another question:
Where do I have to send my patch for sethdlc to?

> 
>> > The IOCTL handling at least looks like it may start returning errors
>> > to existing user space which could have expected the parameters to
>> > IF_PROTO_X25 (other than just ifr_settings.type) to be ignored.
>> 
>> I could also try to implement it without incrementing the version by
>> looking at ifr_settings.size and using the former defaults if the size
>> doesn't match.
> 
> Sounds good, thank you!

OK, I will send a v2 of the patch.
